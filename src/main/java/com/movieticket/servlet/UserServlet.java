package com.movieticket.servlet;

import com.movieticket.dao.UserDAO;
import com.movieticket.entity.User;
import com.movieticket.util.DebugUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * 用户相关Servlet
 */
@WebServlet("/user/*")
public class UserServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 打印调试信息
        DebugUtil.printRequestInfo(request);
        
        String action = request.getPathInfo();
        if (action == null) {
            action = "/";
        }

        switch (action) {
            case "/logout":
                logout(request, response);
                break;
            case "/orders":
                showOrders(request, response);
                break;
            case "/profile":
                showProfile(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 打印调试信息
        DebugUtil.printRequestInfo(request);
        
        String action = request.getPathInfo();
        if (action == null) {
            action = "/";
        }

        switch (action) {
            case "/register":
                register(request, response);
                break;
            case "/changePassword":
                changePassword(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    /**
     * 用户注册
     */
    private void register(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");

        System.out.println("[第一步] 接收了注册请求");
        System.out.println("[第一步] username: " + username);
        System.out.println("[第一步] phone: " + phone);
        System.out.println("[第一步] email: " + email);

        // 验证参数（字段不能为null或空白）
        if (username == null || username.trim().isEmpty()) {
            System.out.println("[第二步] 执行事件: 用户名不能为空");
            request.setAttribute("error", "用户名不能为空");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (password == null || password.trim().isEmpty()) {
            System.out.println("[第二步] 执行事件: 密码不能为空");
            request.setAttribute("error", "密码不能为空");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // 验证手机号格式（可选但如果有输入则必须格式正确）
        if (phone != null && !phone.trim().isEmpty() && !phone.matches("^1[3-9]\\d{9}$")) {
            System.out.println("[第二步] 执行事件: 手机号格式不正确");
            request.setAttribute("error", "手机号格式不正确，请输入11位有效手机号");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // 验证邮箱格式（可选但如果有输入则必须格式正确）
        if (email != null && !email.trim().isEmpty() && !email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
            System.out.println("[第二步] 执行事件: 邮箱格式不正确");
            request.setAttribute("error", "邮箱格式不正确，请输入有效的邮箱地址");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // 验证用户名是否已存在
        System.out.println("[第三步] 开始检查用户名是否已存在");
        if (userDAO.existsByUsername(username)) {
            System.out.println("[第三步] 执行事件: 用户名已存在");
            request.setAttribute("error", "用户名已存在，请选择其他用户名");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // 验证手机号是否已存在（如果提供了手机号）
        if (phone != null && !phone.trim().isEmpty() && userDAO.existsByPhone(phone)) {
            System.out.println("[第三步] 执行事件: 手机号已存在");
            request.setAttribute("error", "手机号已存在，请使用其他手机号或直接登录");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // 验证邮箱是否已存在（如果提供了邮箱）
        if (email != null && !email.trim().isEmpty() && userDAO.existsByEmail(email)) {
            System.out.println("[第三步] 执行事件: 邮箱已存在");
            request.setAttribute("error", "邮箱已存在，请使用其他邮箱或直接登录");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // 创建用户对象
        System.out.println("[第四步] 创建 User 对象");
        User user = new User();
        user.setUsername(username);
        user.setPassword(password);
        user.setPhone(phone);
        user.setEmail(email);

        // 执行注册
        System.out.println("[第五步] 执行注册操作");
        if (userDAO.register(user)) {
            System.out.println("[第五步] 执行事件: 注册成功");
            System.out.println("[第五步] 重定向到登录页面");
            String redirectUrl = request.getContextPath() + "/login.jsp?msg=" + java.net.URLEncoder.encode("注册成功，请使用账号登录", "UTF-8");
            System.out.println("[第五步] 重定向URL: " + redirectUrl);
            response.sendRedirect(redirectUrl);
        } else {
            System.err.println("[第五步] 注册失败");
            request.setAttribute("error", "注册失败，请稍后重试");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }

    /**
     * 用户退出
     */
    private void logout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        session.removeAttribute("user");
        session.removeAttribute("userId");
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }

    /**
     * 查看订单
     */
    private void showOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        DebugUtil.printSessionInfo(session);
        
        Integer userId = (Integer) session.getAttribute("userId");
        
        System.out.println("[UserServlet] 访问订单页面，用户ID: " + userId);
        System.out.println("[UserServlet] SessionID: " + session.getId());
        
        if (userId == null) {
            System.out.println("[UserServlet] 用户未登录，重定向到登录页面");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            com.movieticket.dao.OrderDAO orderDAO = new com.movieticket.dao.OrderDAO();
            java.util.List<com.movieticket.entity.Order> orders = orderDAO.findByUserId(userId);
            System.out.println("[UserServlet] 查询到 " + (orders != null ? orders.size() : 0) + " 条订单");
            
            request.setAttribute("orders", orders);
            // 修改转发路径到WEB-INF目录
            String jspPath = "/WEB-INF/views/user/orders.jsp";
            System.out.println("[UserServlet] 转发到: " + jspPath);
            request.getRequestDispatcher(jspPath).forward(request, response);
        } catch (Exception e) {
            System.err.println("[UserServlet] 查询订单失败: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "页面加载失败");
        }
    }

    /**
     * 查看个人信息
     */
    private void showProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        DebugUtil.printSessionInfo(session);
        
        Integer userId = (Integer) session.getAttribute("userId");
        
        System.out.println("[UserServlet] 访问个人中心，用户ID: " + userId);
        System.out.println("[UserServlet] SessionID: " + session.getId());
        
        if (userId == null) {
            System.out.println("[UserServlet] 用户未登录，重定向到登录页面");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = userDAO.findById(userId);
        if (user == null) {
            System.out.println("[UserServlet] 数据库未找到用户，清除session");
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        System.out.println("[UserServlet] 找到用户: " + user.getUsername());
        request.setAttribute("user", user);
        
        // 修改转发路径到WEB-INF目录
        String jspPath = "/WEB-INF/views/user/profile.jsp";
        System.out.println("[UserServlet] 转发到: " + jspPath);
        
        try {
            request.getRequestDispatcher(jspPath).forward(request, response);
        } catch (Exception e) {
            System.err.println("[UserServlet] 转发失败: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "页面加载失败");
        }
    }

    /**
     * 修改密码
     */
    private void changePassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // 验证旧密码
        User user = userDAO.findById(userId);
        if (user == null || !user.getPassword().equals(oldPassword)) {
            request.setAttribute("error", "旧密码错误");
            request.setAttribute("user", user);
            request.getRequestDispatcher("/WEB-INF/views/user/profile.jsp").forward(request, response);
            return;
        }

        // 验证新密码是否一致
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "两次新密码不一致");
            request.setAttribute("user", user);
            request.getRequestDispatcher("/WEB-INF/views/user/profile.jsp").forward(request, response);
            return;
        }

        // 更新密码
        if (userDAO.updatePassword(userId, newPassword)) {
            request.setAttribute("success", "密码修改成功");
            user.setPassword(newPassword);
            request.setAttribute("user", user);
            request.getRequestDispatcher("/WEB-INF/views/user/profile.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "密码修改失败");
            request.setAttribute("user", user);
            request.getRequestDispatcher("/WEB-INF/views/user/profile.jsp").forward(request, response);
        }
    }
}