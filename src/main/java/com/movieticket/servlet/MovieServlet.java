package com.movieticket.servlet;

import com.movieticket.dao.MovieDAO;
import com.movieticket.entity.Movie;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * 电影相关Servlet
 */
@WebServlet({"/movie/list", "/movie/detail"})
public class MovieServlet extends HttpServlet {
    private MovieDAO movieDAO = new MovieDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String requestURI = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = requestURI.substring(contextPath.length());
        
        System.out.println("[MovieServlet] requestURI=" + requestURI);
        System.out.println("[MovieServlet] contextPath=" + contextPath);
        System.out.println("[MovieServlet] path=" + path);

        if (path.equals("/movie/list")) {
            System.out.println("[MovieServlet] Processing /movie/list request");
            listMovies(request, response);
        } else if (path.equals("/movie/detail")) {
            System.out.println("[MovieServlet] Processing /movie/detail request");
            showDetail(request, response);
        } else {
            System.out.println("[MovieServlet] Unknown path: " + path);
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    /**
     * 电影列表（支持按类型筛选）
     */
    private void listMovies(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String type = request.getParameter("type");
        List<Movie> movies;
        
        if (type != null && !type.isEmpty()) {
            movies = movieDAO.findByType(type);
        } else {
            movies = movieDAO.findAll();
        }
        
        request.setAttribute("movies", movies);
        request.setAttribute("currentType", type);
        request.getRequestDispatcher("/movie/list.jsp").forward(request, response);
    }

    /**
     * 电影详情
     */
    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        System.out.println("[MovieServlet] 电影详情请求，id参数=" + idStr);
        if (idStr == null || idStr.isEmpty()) {
            System.out.println("[MovieServlet] id参数为空");
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        try {
            Integer id = Integer.parseInt(idStr);
            System.out.println("[MovieServlet] 查询电影，id=" + id);
            Movie movie = movieDAO.findById(id);
            System.out.println("[MovieServlet] 查询结果：movie=" + (movie != null ? movie.getTitle() : "null"));
            if (movie == null) {
                System.out.println("[MovieServlet] 电影不存在，id=" + id);
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            // 查询该电影的场次
            com.movieticket.dao.ScheduleDAO scheduleDAO = new com.movieticket.dao.ScheduleDAO();
            java.util.List schedules = scheduleDAO.findByMovieId(id);
            request.setAttribute("movie", movie);
            request.setAttribute("schedules", schedules);
            System.out.println("[MovieServlet] 电影ID " + id + " 的场次数量: " + (schedules != null ? schedules.size() : "null"));
            System.out.println("[MovieServlet] 转发到电影详情页面");
            request.getRequestDispatcher("/movie/detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            System.out.println("[MovieServlet] id格式错误: " + idStr);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
}

