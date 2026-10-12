<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>错误页面 - 江南影院购票平台</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .error-container {
            background: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            width: 500px;
            max-width: 100%;
            text-align: center;
        }
        .error-icon {
            font-size: 64px;
            color: #e74c3c;
            margin-bottom: 20px;
        }
        .error-title {
            font-size: 28px;
            color: #333;
            margin-bottom: 20px;
        }
        .error-message {
            font-size: 16px;
            color: #666;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        .error-code {
            font-size: 14px;
            color: #999;
            margin-bottom: 30px;
            font-weight: bold;
        }
        .btn {
            display: inline-block;
            padding: 12px 30px;
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-size: 16px;
            transition: transform 0.2s;
            margin: 5px;
        }
        .btn:hover {
            transform: translateY(-2px);
        }
        .debug-info {
            margin-top: 20px;
            padding: 15px;
            background-color: #f8f9fa;
            border-radius: 5px;
            text-align: left;
            font-size: 12px;
            color: #666;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-icon">⚠️</div>
        <%
            // 获取错误信息
            Integer statusCode = (Integer) request.getAttribute("javax.servlet.error.status_code");
            String errorMessage = (String) request.getAttribute("javax.servlet.error.message");
            String requestUri = (String) request.getAttribute("javax.servlet.error.request_uri");
            
            // 设置默认值
            if (statusCode == null) statusCode = 0;
            if (errorMessage == null || errorMessage.isEmpty()) errorMessage = "未知错误";
            if (requestUri == null) requestUri = "未知路径";
        %>
        
        <h1 class="error-title">页面出错了</h1>
        
        <div class="error-code">
            错误代码: <%= statusCode %>
        </div>
        
        <div class="error-message">
            <%= errorMessage %>
        </div>
        
        <div class="debug-info">
            <strong>请求路径:</strong> <%= requestUri %><br>
            <strong>时间:</strong> <%= new java.util.Date() %>
        </div>
        
        <a href="${pageContext.request.contextPath}/index.jsp" class="btn">返回首页</a>
        <button class="btn" onclick="window.history.back()">返回上页</button>
    </div>
</body>
</html>