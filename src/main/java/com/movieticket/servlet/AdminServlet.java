package com.movieticket.servlet;

import com.movieticket.dao.*;
import com.movieticket.entity.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet("/admin/*")
public class AdminServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null) pathInfo = "";
        
        // 获取当前登录的管理员
        HttpSession session = request.getSession();
        String admin = (String) session.getAttribute("admin");
        
        // 检查是否登录（除了登录页面和登录操作）
        if (admin == null && !pathInfo.equals("/login")) {
            response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
            return;
        }
        
        switch (pathInfo) {
            case "":
            case "/":
                showDashboard(request, response);
                break;
            case "/test":
                request.getRequestDispatcher("/WEB-INF/views/admin/test-admin.jsp").forward(request, response);
                break;
            case "/login":
                showLoginPage(request, response);
                break;
            case "/logout":
                doLogout(request, response);
                break;
            case "/users":
                showUserList(request, response);
                break;
            case "/movies":
                showMoviesPage(request, response);
                break;
            case "/movie_save":
                saveMovie(request, response);
                break;
            case "/movie_delete":
                deleteMovie(request, response);
                break;
            case "/schedules":
                showSchedulesPage(request, response);
                break;
            case "/schedule_save":
                saveSchedule(request, response);
                break;
            case "/schedule_delete":
                deleteSchedule(request, response);
                break;
            case "/user_add":
                addUser(request, response);
                break;
            case "/user_delete":
                deleteUser(request, response);
                break;
            default:
                request.getRequestDispatcher("/WEB-INF/views/admin/index.jsp")
                       .forward(request, response);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null) pathInfo = "";
        
        switch (pathInfo) {
            case "/login":
                doLogin(request, response);
                break;
            case "/movie_save":
                saveMovie(request, response);
                break;
            case "/schedule_save":
                saveSchedule(request, response);
                break;
            case "/user_add":
                addUser(request, response);
                break;
            case "/user_delete":
                deleteUser(request, response);
                break;
            case "/user_update":
                updateUser(request, response);
                break;
        }
    }
    
    // =========== 页面显示方法 ===========
    
    // 显示后台首页
    private void showDashboard(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // 获取统计数据
            UserDAO userDAO = new UserDAO();
            MovieDAO movieDAO = new MovieDAO();
            ScheduleDAO scheduleDAO = new ScheduleDAO();
            
            int totalUsers = userDAO.countAll();
            int totalMovies = movieDAO.countAll();
            int todaySchedules = scheduleDAO.countToday();
            
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("totalMovies", totalMovies);
            request.setAttribute("todaySchedules", todaySchedules);
            
            request.getRequestDispatcher("/WEB-INF/views/admin/index.jsp")
                   .forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "加载数据失败: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    // 显示登录页面
    private void showLoginPage(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 如果已经登录，直接显示登录页面而不是重定向
        HttpSession session = request.getSession();
        String admin = (String) session.getAttribute("admin");
        if (admin != null) {
            // 如果已登录，仍然允许访问登录页面（例如切换账户）
            request.setAttribute("admin", admin);
        }
        request.getRequestDispatcher("/WEB-INF/views/admin/login.jsp")
               .forward(request, response);
    }
    
    // 显示用户列表
    private void showUserList(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            UserDAO userDAO = new UserDAO();
            List<User> users = userDAO.findAll();
            request.setAttribute("users", users);
            request.getRequestDispatcher("/WEB-INF/views/admin/user_list.jsp")
                   .forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "加载用户数据失败: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    // 显示电影管理页面（合并列表和编辑）
    private void showMoviesPage(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            MovieDAO movieDAO = new MovieDAO();
            List<Movie> movies = movieDAO.findAll();
            request.setAttribute("movies", movies);
            request.getRequestDispatcher("/WEB-INF/views/admin/movies.jsp")
                   .forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "加载电影数据失败: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    // 显示电影编辑表单
    private void showMovieEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String id = request.getParameter("id");
            if (id != null && !id.trim().isEmpty()) {
                // 编辑模式：加载电影数据
                MovieDAO movieDAO = new MovieDAO();
                Movie movie = movieDAO.findById(Integer.parseInt(id));
                request.setAttribute("movie", movie);
            } else {
                // 新增模式：创建一个空电影对象
                request.setAttribute("movie", new Movie());
            }
            request.getRequestDispatcher("/WEB-INF/views/admin/movie_edit.jsp")
                   .forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "加载电影信息失败: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    // 显示场次管理页面（合并列表和编辑）
    private void showSchedulesPage(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            ScheduleDAO scheduleDAO = new ScheduleDAO();
            List<Schedule> schedules = scheduleDAO.findAllWithMovieAndHall();
            
            // 获取电影和影厅列表供选择
            MovieDAO movieDAO = new MovieDAO();
            HallDAO hallDAO = new HallDAO();
            
            List<Movie> movies = movieDAO.findAll();
            List<Hall> halls = hallDAO.findAll();
            
            request.setAttribute("schedules", schedules);
            request.setAttribute("movies", movies);
            request.setAttribute("halls", halls);
            request.getRequestDispatcher("/WEB-INF/views/admin/schedules.jsp")
                   .forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "加载场次数据失败: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    // 显示场次编辑表单
    private void showScheduleEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String id = request.getParameter("id");
            if (id != null && !id.trim().isEmpty()) {
                // 编辑模式：加载场次数据
                ScheduleDAO scheduleDAO = new ScheduleDAO();
                Schedule schedule = scheduleDAO.findById(Integer.parseInt(id));
                request.setAttribute("schedule", schedule);
            } else {
                // 新增模式：创建一个空场次对象
                request.setAttribute("schedule", new Schedule());
            }
            
            // 获取电影和影厅列表供选择
            MovieDAO movieDAO = new MovieDAO();
            HallDAO hallDAO = new HallDAO();
            
            List<Movie> movies = movieDAO.findAll();
            List<Hall> halls = hallDAO.findAll();
            
            request.setAttribute("movies", movies);
            request.setAttribute("halls", halls);
            
            request.getRequestDispatcher("/WEB-INF/views/admin/schedule_edit.jsp")
                   .forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "加载场次信息失败: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    // =========== 业务处理方法 ===========
    
    // 管理员登录
    private void doLogin(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        try {
            AdminDAO adminDAO = new AdminDAO();
            Admin admin = adminDAO.login(username, password);
            
            if (admin != null) {
                // 登录成功，保存到Session
                HttpSession session = request.getSession();
                session.setAttribute("admin", admin.getUsername());
                session.setAttribute("adminId", admin.getId());
                session.setAttribute("adminObj", admin);
                
                System.out.println("[AdminServlet] 管理员登录成功: " + admin.getUsername());
                
                // 重定向到管理员首页
                response.sendRedirect(request.getContextPath() + "/admin/");
            } else {
                // 登录失败
                request.setAttribute("error", "用户名或密码错误");
                request.getRequestDispatcher("/WEB-INF/views/admin/login.jsp")
                       .forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "登录失败: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/login.jsp")
                   .forward(request, response);
        }
    }
    
    // 管理员登出
    private void doLogout(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        session.removeAttribute("admin");
        response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
    }
    
    // 保存电影（新增或更新）
    private void saveMovie(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            Movie movie = new Movie();
            String id = request.getParameter("id");
            
            // 设置电影属性
            movie.setTitle(request.getParameter("title"));
            movie.setType(request.getParameter("type"));
            movie.setDirector(request.getParameter("director"));
            movie.setActors(request.getParameter("actors"));
            movie.setDuration(Integer.parseInt(request.getParameter("duration")));
            movie.setDescription(request.getParameter("description"));
            movie.setPosterUrl(request.getParameter("poster_url"));
            
            // 设置上映日期
            String releaseDateStr = request.getParameter("release_date");
            if (releaseDateStr != null && !releaseDateStr.isEmpty()) {
                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                movie.setReleaseDate(dateFormat.parse(releaseDateStr));
            }
            
            MovieDAO movieDAO = new MovieDAO();
            boolean success;
            
            if (id != null && !id.trim().isEmpty()) {
                // 更新模式
                movie.setId(Integer.parseInt(id));
                success = movieDAO.update(movie);
            } else {
                // 新增模式
                success = movieDAO.add(movie);
            }
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/movies");
            } else {
                request.setAttribute("error", "保存电影失败");
                // 失败时重定向到新的电影管理页面
                response.sendRedirect(request.getContextPath() + "/admin/movies?error=" + java.net.URLEncoder.encode("保存电影失败", "UTF-8"));
            }
        } catch (Exception e) {
            e.printStackTrace();
            // 出错时重定向到新的电影管理页面
            response.sendRedirect(request.getContextPath() + "/admin/movies?error=" + java.net.URLEncoder.encode("保存电影失败: " + e.getMessage(), "UTF-8"));
        }
    }
    
    // 删除电影
    private void deleteMovie(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String id = request.getParameter("id");
            if (id != null && !id.trim().isEmpty()) {
                MovieDAO movieDAO = new MovieDAO();
                boolean success = movieDAO.delete(Integer.parseInt(id));
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/admin/movies");
                } else {
                    request.setAttribute("error", "删除电影失败");
                    showMoviesPage(request, response);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "删除电影失败: " + e.getMessage());
            showMoviesPage(request, response);
        }
    }
    
    // 保存场次（新增或更新）
    private void saveSchedule(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            Schedule schedule = new Schedule();
            String id = request.getParameter("id");
            
            // 设置场次属性
            schedule.setMovieId(Integer.parseInt(request.getParameter("movie_id")));
            schedule.setHallId(Integer.parseInt(request.getParameter("hall_id")));
            schedule.setPrice(Double.parseDouble(request.getParameter("price")));
            
            // 解析日期时间
            String showTimeStr = request.getParameter("show_time");
            if (showTimeStr == null || showTimeStr.isEmpty()) {
                throw new IllegalArgumentException("放映时间不能为空");
            }
            
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
                schedule.setShowTime(sdf.parse(showTimeStr));
            } catch (ParseException e) {
                // 尝试另一种格式
                SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                schedule.setShowTime(sdf2.parse(showTimeStr));
            }
            
            ScheduleDAO scheduleDAO = new ScheduleDAO();
            boolean success;
            
            if (id != null && !id.trim().isEmpty()) {
                // 更新模式
                schedule.setId(Integer.parseInt(id));
                success = scheduleDAO.update(schedule);
            } else {
                // 新增模式
                success = scheduleDAO.add(schedule);
            }
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/schedules");
            } else {
                // 失败时重定向到新的场次管理页面
                response.sendRedirect(request.getContextPath() + "/admin/schedules?error=" + java.net.URLEncoder.encode("保存场次失败", "UTF-8"));
            }
        } catch (Exception e) {
            e.printStackTrace();
            // 出错时重定向到新的场次管理页面
            response.sendRedirect(request.getContextPath() + "/admin/schedules?error=" + java.net.URLEncoder.encode("保存场次失败: " + e.getMessage(), "UTF-8"));
        }
    }
    
    // 删除场次
    private void deleteSchedule(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String id = request.getParameter("id");
            if (id != null && !id.trim().isEmpty()) {
                ScheduleDAO scheduleDAO = new ScheduleDAO();
                boolean success = scheduleDAO.delete(Integer.parseInt(id));
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/admin/schedules");
                } else {
                    request.setAttribute("error", "删除场次失败");
                    showSchedulesPage(request, response);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "删除场次失败: " + e.getMessage());
            showSchedulesPage(request, response);
        }
    }
    
    // 更新用户
    private void updateUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // 创建用户对象
            User user = new User();
            user.setId(Integer.parseInt(request.getParameter("id")));
            user.setUsername(request.getParameter("username"));
            user.setEmail(request.getParameter("email"));
            user.setPhone(request.getParameter("phone"));
            
            // 只有当密码不为空时才设置密码
            String password = request.getParameter("password");
            if (password != null && !password.isEmpty()) {
                user.setPassword(password);
            }
            
            // 调用DAO更新用户
            UserDAO userDAO = new UserDAO();
            boolean success = userDAO.update(user);
            
            if (success) {
                // 更新成功，重定向回用户列表
                response.sendRedirect(request.getContextPath() + "/admin/users");
            } else {
                // 更新失败，设置错误信息并转发回用户列表
                request.setAttribute("error", "更新用户失败");
                showUserList(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "更新用户失败: " + e.getMessage());
            showUserList(request, response);
        }
    }
    
    // 添加用户
    private void addUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // 创建用户对象
            User user = new User();
            user.setUsername(request.getParameter("username"));
            user.setPassword(request.getParameter("password"));
            user.setEmail(request.getParameter("email"));
            user.setPhone(request.getParameter("phone"));
            
            // 调用DAO保存用户
            UserDAO userDAO = new UserDAO();
            boolean success = userDAO.register(user);
            
            if (success) {
                // 添加成功，重定向回用户列表
                response.sendRedirect(request.getContextPath() + "/admin/users");
            } else {
                // 添加失败，设置错误信息并转发回用户列表
                request.setAttribute("error", "添加用户失败");
                showUserList(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "添加用户失败: " + e.getMessage());
            showUserList(request, response);
        }
    }
    
    // 删除用户
    private void deleteUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String id = request.getParameter("id");
            if (id != null && !id.trim().isEmpty()) {
                int userId = Integer.parseInt(id);
                
                // 防止删除管理员账户（假设管理员ID为1）
                if (userId == 1) {
                    response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                    response.getWriter().write("不能删除管理员账户");
                    return;
                }
                
                // 调用DAO删除用户
                UserDAO userDAO = new UserDAO();
                boolean success = userDAO.delete(userId);
                
                if (success) {
                    response.setStatus(HttpServletResponse.SC_OK);
                    response.getWriter().write("用户删除成功");
                } else {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    response.getWriter().write("删除用户失败");
                }
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("无效的用户ID");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("删除用户失败: " + e.getMessage());
        }
    }
}