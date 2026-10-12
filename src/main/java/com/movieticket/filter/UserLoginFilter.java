package com.movieticket.filter;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * 用户登录过滤器
 */
public class UserLoginFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        // 使用getSession(false)避免创建不必要的session
        HttpSession session = httpRequest.getSession(false);
        
        String user = (session != null) ? (String) session.getAttribute("user") : null;
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        
        System.out.println("[UserLoginFilter] URI: " + requestURI);
        
        // 排除所有不需要登录验证的路径
        String[] excludedPaths = {
            "/login.jsp",
            "/register.jsp",
            "/index.jsp",
            "/error.jsp",
            "/movie/",           // 电影相关
            "/user/register",    // 用户注册
            "/admin/",           // 管理员路径  非常重要
            "/AuthServlet",      // 认证Servlet
            ".css", ".js", ".jpg", ".png", ".gif", ".ico"  // 静态资源
        };
        
        for (String path : excludedPaths) {
            if (requestURI.contains(path)) {
                System.out.println("[UserLoginFilter] 放行路径: " + path);
                chain.doFilter(request, response);
                return;
            }
        }
        
        if (user == null) {
            System.out.println("[UserLoginFilter] 用户未登录，重定向到登录页");
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp");
            return;
        }
        
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}