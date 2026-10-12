package com.movieticket.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;

@WebFilter("/admin/*")  // 只拦截/admin/路径
public class AdminLoginFilter implements Filter {
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, 
                         FilterChain chain) throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();
        
        System.out.println("[AdminLoginFilter] 当前URI: " + uri);
        System.out.println("[AdminLoginFilter] ContextPath: " + contextPath);
        System.out.println("[AdminLoginFilter] 完整URL: " + req.getRequestURL());
        
        // 获取session但不创建新session
        HttpSession session = req.getSession(false);
        
        // 排除不需要过滤的路径（更精确）
        System.out.println("[AdminLoginFilter] 检查路径排除...");
        System.out.println("[AdminLoginFilter] 比较 " + uri + " 和 " + contextPath + "/admin/login.jsp: " + uri.equals(contextPath + "/admin/login.jsp"));
        System.out.println("[AdminLoginFilter] 比较 " + uri + " 和 " + contextPath + "/admin/test-admin.jsp: " + uri.equals(contextPath + "/admin/test-admin.jsp"));
        System.out.println("[AdminLoginFilter] 比较 " + uri + " 和 " + contextPath + "/admin/debug.jsp: " + uri.equals(contextPath + "/admin/debug.jsp"));
        
        // 检查是否试图直接访问WEB-INF下的JSP文件
        if (uri.contains("/WEB-INF/")) {
            System.out.println("[AdminLoginFilter] 试图直接访问WEB-INF资源，返回404");
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        // 检查是否试图直接访问admin下的JSP文件
        if (uri.endsWith(".jsp") && uri.contains("/admin/")) {
            System.out.println("[AdminLoginFilter] 试图直接访问JSP文件，重定向到正确路径");
            // 特殊处理登录页面
            if (uri.endsWith("/admin/login.jsp")) {
                resp.sendRedirect(contextPath + "/admin/login");
            } else {
                // 对于其他JSP文件，重定向到管理员首页
                resp.sendRedirect(contextPath + "/admin/");
            }
            return;
        }
        
        if (uri.equals(contextPath + "/admin/login.jsp") || 
            uri.equals(contextPath + "/admin/test-admin.jsp") ||  // 测试页面
            uri.equals(contextPath + "/admin/debug.jsp") ||  // 调试页面
            uri.equals(contextPath + "/admin/login") ||    // 管理员登录处理Servlet
            uri.contains("/admin/AdminServlet") ||        // 管理员Servlet
            uri.contains("/admin/logout") ||              // 登出功能
            uri.endsWith(".css") || uri.endsWith(".js") || 
            uri.endsWith(".jpg") || uri.endsWith(".png") ||
            uri.endsWith(".gif") || uri.endsWith(".ico")) {
            
            System.out.println("[AdminLoginFilter] 放行路径: " + uri);
            chain.doFilter(request, response);
            return;
        }
        
        // 检查管理员登录状态
        String admin = (session != null) ? (String) session.getAttribute("admin") : null;
        
        System.out.println("[AdminLoginFilter] 管理员session: " + admin);
        
        if (admin == null) {
            System.out.println("[AdminLoginFilter] 未登录，重定向到管理员登录页");
            
            // 重要：检查是否是重定向循环
            String referer = req.getHeader("Referer");
            System.out.println("[AdminLoginFilter] Referer: " + referer);
            
            // 如果是从登录页面重定向过来的，避免循环
            if (referer != null && referer.contains("/admin/login.jsp")) {
                System.out.println("[AdminLoginFilter] 检测到重定向循环，返回错误页面");
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "访问被拒绝");
                return;
            }
            
            resp.sendRedirect(contextPath + "/admin/login.jsp");
            return;
        }
        
        chain.doFilter(request, response);
    }
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}
    
    @Override
    public void destroy() {}
}