<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>个人中心 - 江南影院购票平台</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            background: #f5f5f5;
        }
        .header {
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            color: white;
            padding: 20px 0;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 20px;
        }
        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .logo {
            font-size: 28px;
            font-weight: bold;
        }
        .nav a {
            color: white;
            text-decoration: none;
            padding: 8px 16px;
            border-radius: 4px;
            margin-left: 20px;
            transition: background 0.3s;
        }
        .nav a:hover {
            background: rgba(255,255,255,0.2);
        }
        .profile-container {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-top: 30px;
            padding: 30px;
        }
        .tabs {
            display: flex;
            border-bottom: 2px solid #e0e0e0;
            margin-bottom: 30px;
        }
        .tab-btn {
            padding: 15px 30px;
            background: none;
            border: none;
            font-size: 16px;
            cursor: pointer;
            color: #666;
            border-bottom: 3px solid transparent;
            transition: all 0.3s;
        }
        .tab-btn.active {
            color: #6c757d;
            border-bottom-color: #6c757d;
        }
        .tab-content {
            display: none;
        }
        .tab-content.active {
            display: block;
        }
        .info-item {
            margin-bottom: 20px;
            display: flex;
            align-items: center;
        }
        .info-label {
            width: 120px;
            font-weight: bold;
            color: #666;
        }
        .info-value {
            flex: 1;
            padding: 10px 15px;
            background: #f9f9f9;
            border-radius: 4px;
            color: #333;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #666;
            font-weight: bold;
        }
        .form-group input {
            width: 100%;
            max-width: 400px;
            padding: 10px;
            border: 2px solid #e0e0e0;
            border-radius: 4px;
            font-size: 14px;
        }
        .form-group input:focus {
            outline: none;
            border-color: #6c757d;
        }
        .btn {
            padding: 10px 30px;
            background: #6c757d;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
            transition: background 0.3s;
        }
        .btn:hover {
            background: #495057;
        }
        .success {
            color: #27ae60;
            text-align: center;
            margin-bottom: 15px;
            padding: 10px;
            background: #eafaf1;
            border-radius: 4px;
        }
        .error {
            color: #e74c3c;
            text-align: center;
            margin-bottom: 15px;
            padding: 10px;
            background: #ffeaea;
            border-radius: 4px;
        }

    </style>
</head>
<body>
    <div class="header">
        <div class="container">
            <div class="header-content">
                <div class="logo">🎬 江南影院购票平台</div>
                <div class="nav">
                    <a href="${pageContext.request.contextPath}/index.jsp">首页</a>
                    <a href="${pageContext.request.contextPath}/user/logout">退出</a>
                </div>
            </div>
        </div>
    </div>

    <div class="container">
        <div class="profile-container">
            <div class="tabs">
                <button class="tab-btn active" onclick="switchTab(this, 'info')">个人信息</button>
                <button class="tab-btn" onclick="switchTab(this, 'password')">修改密码</button>
            </div>

            <!-- 个人信息标签 -->
            <div id="info" class="tab-content active">
                <h3 style="margin-bottom: 20px; color: #333;">基本信息</h3>
                <div class="info-item">
                    <div class="info-label">用户ID:</div>
                    <div class="info-value">${user.id}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">用户名:</div>
                    <div class="info-value">${user.username}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">邮箱:</div>
                    <div class="info-value">${user.email}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">手机号:</div>
                    <div class="info-value">${user.phone}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">注册时间:</div>
                    <div class="info-value"><fmt:formatDate value="${user.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/></div>
                </div>
            </div>

            <!-- 修改密码标签 -->
            <div id="password" class="tab-content">
                <h3 style="margin-bottom: 20px; color: #333;">修改密码</h3>

                <c:if test="${not empty requestScope.success}">
                    <div class="success">${requestScope.success}</div>
                </c:if>

                <c:if test="${not empty requestScope.error}">
                    <div class="error">${requestScope.error}</div>
                </c:if>

                <form method="post" action="${pageContext.request.contextPath}/user/changePassword" style="max-width: 400px;">
                    <div class="form-group">
                        <label>旧密码 *</label>
                        <input type="password" name="oldPassword" required>
                    </div>
                    <div class="form-group">
                        <label>新密码 *</label>
                        <input type="password" name="newPassword" required>
                    </div>
                    <div class="form-group">
                        <label>确认新密码 *</label>
                        <input type="password" name="confirmPassword" required>
                    </div>
                    <button type="submit" class="btn">修改密码</button>
                </form>
            </div>
        </div>
    </div>

    <script>
        function switchTab(btn, tabId) {
            // 移除所有active类
            document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
            document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));
            
            // 添加active类
            btn.classList.add('active');
            document.getElementById(tabId).classList.add('active');
        }
    </script>
</body>
</html>