package com.movieticket.servlet;

import com.movieticket.dao.UserDAO;
import com.movieticket.entity.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * 认证Servlet（登录/登出）
 */
@WebServlet("/auth/*")
public class AuthServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo();
        if (action == null) {
            action = "/";
        }

        switch (action) {
            case "/login":
                userLogin(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    /**
     * 用户登录
     */
    private void userLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        System.out.println("[AuthServlet] 登录请求，用户名: " + username);
        
        // 验证参数
        if (username == null || username.trim().isEmpty()) {
            System.out.println("[AuthServlet] 用户名为null，返回登录页");
            request.setAttribute("error", "用户名不能为null");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        if (password == null || password.trim().isEmpty()) {
            System.out.println("[AuthServlet] 密码为null，返回登录页");
            request.setAttribute("error", "密码不能为null");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        User user = userDAO.login(username, password);
        if (user != null) {
            System.out.println("[AuthServlet] 登录成功，用户ID: " + user.getId());
            
            HttpSession session = request.getSession();
            session.setAttribute("user", user.getUsername());
            session.setAttribute("userId", user.getId());
            session.setAttribute("userObj", user);
            
            System.out.println("[AuthServlet] SessionID: " + session.getId());
            System.out.println("[AuthServlet] 重定向到首页");
            
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        } else {
            System.out.println("[AuthServlet] 登录失败，用户名: " + username);
            request.setAttribute("error", "用户名或密码错误");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
