<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>管理员登录说明</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .warning {
            background-color: #fff3cd;
            border: 1px solid #ffeaa7;
            color: #856404;
            padding: 15px;
            border-radius: 5px;
            margin: 20px 0;
        }
        .info {
            background-color: #d1ecf1;
            border: 1px solid #bee5eb;
            color: #0c5460;
            padding: 15px;
            border-radius: 5px;
            margin: 20px 0;
        }
        .code {
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            padding: 10px;
            border-radius: 5px;
            font-family: monospace;
            margin: 10px 0;
        }
        a {
            color: #007bff;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>管理员登录系统说明</h1>
        
        <div class="warning">
            <strong>重要提醒：</strong>请勿直接访问JSP文件，这会导致错误！
        </div>
        
        <h2>正确的访问方式</h2>
        
        <div class="info">
            <h3>1. 访问管理员登录页面</h3>
            <p>请访问以下URL来显示管理员登录页面：</p>
            <div class="code">
                http://localhost:8080/MovieTicketSys_war_exploded/admin/login
            </div>
            <p>注意：URL末尾是 <strong>/admin/login</strong>，而不是 <strong>/admin/login.jsp</strong></p>
        </div>
        
        <div class="info">
            <h3>2. 访问管理员首页</h3>
            <p>登录成功后，会自动跳转到管理员首页：</p>
            <div class="code">
                http://localhost:8080/MovieTicketSys_war_exploded/admin/
            </div>
        </div>
        
        <h2>为什么不能直接访问JSP文件？</h2>
        <p>JSP文件存放在 <code>WEB-INF/views/admin/</code> 目录下，这个目录受到Servlet规范保护：</p>
        <ul>
            <li>不能通过URL直接访问</li>
            <li>只能通过Servlet转发访问</li>
            <li>这样可以保证安全性，防止用户绕过权限验证</li>
        </ul>
        
        <h2>当前会话信息</h2>
        <p>Session ID: <%= session.getId() %></p>
        <p>Admin in session: <%= session.getAttribute("admin") %></p>
        
        <h2>快速链接</h2>
        <ul>
            <li><a href="<%= request.getContextPath() %>/admin/login">管理员登录页面</a></li>
            <li><a href="<%= request.getContextPath() %>/">返回网站首页</a></li>
        </ul>
    </div>
</body>
</html>