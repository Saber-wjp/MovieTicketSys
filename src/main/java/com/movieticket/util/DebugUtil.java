package com.movieticket.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Enumeration;

/**
 * 调试工具类
 */
public class DebugUtil {
    
    /**
     * 打印请求信息
     */
    public static void printRequestInfo(HttpServletRequest request) {
        System.out.println("=== 请求信息 ===");
        System.out.println("Request URI: " + request.getRequestURI());
        System.out.println("Context Path: " + request.getContextPath());
        System.out.println("Servlet Path: " + request.getServletPath());
        System.out.println("Path Info: " + request.getPathInfo());
        System.out.println("Query String: " + request.getQueryString());
        System.out.println("Method: " + request.getMethod());
        System.out.println("Remote Address: " + request.getRemoteAddr());
        System.out.println("Remote Host: " + request.getRemoteHost());
        System.out.println("===============");
    }
    
    /**
     * 打印会话信息
     */
    public static void printSessionInfo(HttpSession session) {
        System.out.println("=== 会话信息 ===");
        System.out.println("Session ID: " + session.getId());
        System.out.println("Creation Time: " + session.getCreationTime());
        System.out.println("Last Accessed Time: " + session.getLastAccessedTime());
        System.out.println("Max Inactive Interval: " + session.getMaxInactiveInterval());
        
        // 打印会话属性
        System.out.println("Session Attributes:");
        Enumeration<String> attributeNames = session.getAttributeNames();
        while (attributeNames.hasMoreElements()) {
            String name = attributeNames.nextElement();
            System.out.println("  " + name + ": " + session.getAttribute(name));
        }
        System.out.println("===============");
    }
}