<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>用户登录 - 江南影院售票平台</title>
    <!-- 引入Font Awesome图标 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            /* 浅色主题变量 */
            --bg-primary: linear-gradient(135deg, #f5f5f5 0%, #f0f2f5 50%, #e8e8e8 100%);
            --bg-secondary: rgba(255, 255, 255, 0.92);
            --bg-grid: linear-gradient(90deg, rgba(230, 230, 235, 0.3) 1px, transparent 1px) 0 0 / 50px 50px,
            linear-gradient(rgba(230, 230, 235, 0.3) 1px, transparent 1px) 0 0 / 50px 50px;
            --text-primary: #333;
            --text-secondary: #666;
            --text-tertiary: #888;
            --border-color: #ddd;
            --accent-color: #667eea;
            --accent-light: #00c6ff;
            --input-bg: rgba(255, 255, 255, 0.95);
            --shadow-light: 0 10px 30px rgba(0, 0, 0, 0.08);
            --shadow-accent: 0 0 30px rgba(102, 126, 234, 0.15);
            --container-border: rgba(255, 255, 255, 0.8);
            --link-color: #667eea;
            --error-bg: rgba(231, 76, 60, 0.1);
            --success-bg: rgba(39, 174, 96, 0.1);
            --footer-bg: rgba(240, 240, 240, 0.8);
        }

        body.dark-mode {
            /* 深色主题变量 */
            --bg-primary: linear-gradient(135deg, #0a0a0a 0%, #0f1525 50%, #1a1a2e 100%);
            --bg-secondary: rgba(10, 15, 25, 0.85);
            --bg-grid: linear-gradient(90deg, rgba(30, 30, 60, 0.7) 1px, transparent 1px) 0 0 / 50px 50px,
            linear-gradient(rgba(30, 30, 60, 0.7) 1px, transparent 1px) 0 0 / 50px 50px;
            --text-primary: #fff;
            --text-secondary: #aaccff;
            --text-tertiary: #88aaff;
            --border-color: rgba(102, 126, 234, 0.3);
            --accent-color: #667eea;
            --accent-light: #00c6ff;
            --input-bg: rgba(20, 25, 40, 0.7);
            --shadow-light: 0 0 40px rgba(102, 126, 234, 0.6);
            --shadow-accent: 0 0 80px rgba(10, 15, 200, 0.3);
            --container-border: rgba(102, 126, 234, 0.4);
            --link-color: #88aaff;
            --error-bg: rgba(231, 76, 60, 0.1);
            --success-bg: rgba(39, 174, 96, 0.1);
            --footer-bg: rgba(20, 25, 40, 0.5);
        }

        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: var(--bg-primary);
            padding: 20px;
            position: relative;
            overflow: auto;
            transition: background 0.5s ease;
        }

        body, html {
            overflow-x: hidden;
            overflow-y: auto;
        }

        /* 主题切换按钮 */
        .theme-toggle {
            position: fixed;
            top: 20px;
            right: 20px;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: var(--bg-secondary);
            border: 2px solid var(--accent-color);
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
            color: var(--accent-color);
            z-index: 1000;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
        }

        .theme-toggle:hover {
            transform: scale(1.1);
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
        }

        .theme-toggle .fa-sun {
            display: block;
        }

        .theme-toggle .fa-moon {
            display: none;
        }

        body.dark-mode .theme-toggle .fa-sun {
            display: none;
        }

        body.dark-mode .theme-toggle .fa-moon {
            display: block;
        }

        /* 背景网格 */
        .theme-grid {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: var(--bg-grid);
            z-index: 0;
            opacity: 0.5;
            transition: background 0.5s ease;
        }

        /* 登录容器 */
        .login-container {
            background: var(--bg-secondary);
            padding: 30px;
            border-radius: 16px;
            box-shadow: var(--shadow-light), var(--shadow-accent),
            inset 0 0 20px rgba(102, 126, 234, 0.1);
            width: 100%;
            max-width: 420px;
            position: relative;
            backdrop-filter: blur(10px);
            border: 1px solid var(--container-border);
            z-index: 2;
            animation: containerFloat 4s ease-in-out infinite;
            transition: all 0.5s ease;
        }

        @keyframes containerFloat {
            0%, 100% {
                transform: translateY(0);
                box-shadow: var(--shadow-light), var(--shadow-accent);
            }
            50% {
                transform: translateY(-5px);
                box-shadow: 0 15px 40px rgba(0, 0, 0, 0.12),
                0 0 40px rgba(102, 126, 234, 0.2),
                0 0 80px rgba(10, 15, 200, 0.15);
            }
        }

        /* 容器边框光效 */
        .login-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            border-radius: 16px;
            padding: 2px;
            background: linear-gradient(
                    135deg,
                    rgba(102, 126, 234, 0.3),
                    rgba(0, 198, 255, 0.3),
                    rgba(102, 126, 234, 0.3)
            );
            mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
            mask-composite: exclude;
            z-index: -1;
            animation: borderGlow 3s ease-in-out infinite alternate;
        }

        body.dark-mode .login-container::before {
            background: linear-gradient(
                    135deg,
                    rgba(102, 126, 234, 0.5),
                    rgba(0, 198, 255, 0.5),
                    rgba(102, 126, 234, 0.5)
            );
        }

        @keyframes borderGlow {
            0% {
                opacity: 0.5;
                background: linear-gradient(
                        135deg,
                        rgba(102, 126, 234, 0.3),
                        rgba(0, 198, 255, 0.3),
                        rgba(102, 126, 234, 0.3)
                );
            }
            100% {
                opacity: 0.8;
                background: linear-gradient(
                        135deg,
                        rgba(102, 126, 234, 0.5),
                        rgba(0, 198, 255, 0.5),
                        rgba(102, 126, 234, 0.5)
                );
            }
        }

        .login-title {
            text-align: center;
            font-size: 32px;
            margin-bottom: 25px;
            color: var(--text-primary);
            font-weight: 700;
            letter-spacing: 2px;
            text-transform: uppercase;
            position: relative;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            transition: color 0.5s ease;
        }

        body.dark-mode .login-title {
            text-shadow: 0 0 10px rgba(102, 126, 234, 0.8);
        }

        /* 科技感文字 */
        .cyber-text {
            background: linear-gradient(90deg, #667eea, #00c6ff, #667eea);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            background-size: 200% auto;
            animation: textShine 3s ease-in-out infinite alternate;
            position: relative;
        }

        .cyber-text::before {
            content: '';
            position: absolute;
            bottom: -5px;
            left: 50%;
            transform: translateX(-50%);
            width: 100px;
            height: 2px;
            background: linear-gradient(90deg, transparent, #00c6ff, transparent);
            animation: linePulse 2s ease-in-out infinite;
        }

        @keyframes linePulse {
            0%, 100% { width: 100px; opacity: 1; }
            50% { width: 150px; opacity: 0.7; }
        }

        @keyframes textShine {
            to { background-position: 200% center; }
        }

        .login-subtitle {
            text-align: center;
            color: var(--text-secondary);
            margin-bottom: 30px;
            font-size: 14px;
            font-weight: 300;
            letter-spacing: 1px;
            transition: color 0.5s ease;
        }

        body.dark-mode .login-subtitle {
            text-shadow: 0 0 10px rgba(102, 126, 234, 0.5);
        }

        .form-group {
            margin-bottom: 25px;
            position: relative;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: var(--text-secondary);
            font-weight: 600;
            font-size: 14px;
            letter-spacing: 1px;
            text-transform: uppercase;
            transition: color 0.5s ease;
        }

        .input-wrapper {
            position: relative;
            overflow: hidden;
            border-radius: 8px;
            border: 1px solid var(--border-color);
            background: var(--input-bg);
            transition: all 0.3s;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }

        body.dark-mode .input-wrapper {
            box-shadow: 0 0 15px rgba(102, 126, 234, 0.1);
        }

        .input-wrapper:hover {
            border-color: var(--accent-color);
            box-shadow: 0 5px 20px rgba(102, 126, 234, 0.15);
        }

        .form-group input {
            width: 100%;
            padding: 16px 15px 16px 50px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            background: transparent;
            color: var(--text-primary);
            letter-spacing: 1px;
            transition: color 0.5s ease;
        }

        .form-group input:focus {
            outline: none;
            box-shadow: 0 0 0 2px rgba(102, 126, 234, 0.3);
        }

        .input-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--accent-color);
            font-size: 18px;
            z-index: 2;
            transition: all 0.3s;
        }

        .form-group input:focus + .input-icon {
            color: var(--accent-light);
            transform: translateY(-50%) scale(1.2);
        }

        .btn {
            width: 100%;
            padding: 16px;
            background: linear-gradient(90deg, var(--accent-color), var(--accent-light));
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            position: relative;
            overflow: hidden;
            margin-top: 10px;
            letter-spacing: 2px;
            text-transform: uppercase;
            box-shadow: 0 5px 20px rgba(102, 126, 234, 0.3);
        }

        .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: left 0.5s;
        }

        .btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
        }

        .btn:hover::before {
            left: 100%;
        }

        .btn:active {
            transform: translateY(-1px);
        }

        .btn i {
            margin-right: 10px;
        }

        .error {
            color: #ff6b6b;
            text-align: center;
            margin-bottom: 15px;
            padding: 12px;
            background: var(--error-bg);
            border-radius: 6px;
            border: 1px solid rgba(231, 76, 60, 0.2);
            font-size: 13px;
            animation: shake 0.5s ease-in-out;
            box-shadow: 0 2px 10px rgba(231, 76, 60, 0.1);
            transition: background 0.5s ease;
        }

        body.dark-mode .error {
            border: 1px solid rgba(231, 76, 60, 0.3);
            box-shadow: 0 0 15px rgba(231, 76, 60, 0.2);
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            75% { transform: translateX(5px); }
        }

        .msg {
            color: #27ae60;
            text-align: center;
            margin-bottom: 15px;
            padding: 12px;
            background: var(--success-bg);
            border-radius: 6px;
            border: 1px solid rgba(39, 174, 96, 0.2);
            font-size: 13px;
            animation: fadeInUp 0.4s ease-out;
            box-shadow: 0 2px 10px rgba(39, 174, 96, 0.1);
            transition: background 0.5s ease;
        }

        body.dark-mode .msg {
            border: 1px solid rgba(39, 174, 96, 0.3);
            box-shadow: 0 0 15px rgba(39, 174, 96, 0.2);
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .links {
            text-align: center;
            margin-top: 25px;
            padding-top: 25px;
            border-top: 1px solid rgba(221, 221, 221, 0.8);
            position: relative;
            transition: border-color 0.5s ease;
        }

        body.dark-mode .links {
            border-top: 1px solid rgba(102, 126, 234, 0.3);
        }

        .links::before {
            content: '';
            position: absolute;
            top: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 50px;
            height: 1px;
            background: var(--accent-light);
            transition: background 0.5s ease;
        }

        body.dark-mode .links::before {
            box-shadow: 0 0 10px var(--accent-light);
        }

        .links a {
            color: var(--link-color);
            text-decoration: none;
            font-size: 14px;
            margin: 0 15px;
            transition: all 0.3s;
            display: inline-block;
            position: relative;
            padding: 5px 0;
            letter-spacing: 1px;
        }

        .links a::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 0;
            height: 1px;
            background: linear-gradient(90deg, var(--accent-color), var(--accent-light));
            transition: width 0.3s;
        }

        .links a:hover {
            color: var(--accent-light);
        }

        body.dark-mode .links a:hover {
            text-shadow: 0 0 10px rgba(0, 198, 255, 0.8);
        }

        .links a:hover::after {
            width: 100%;
        }

        .forgot-password {
            display: block;
            text-align: center;
            margin-top: 15px;
            color: var(--link-color);
            text-decoration: none;
            cursor: pointer;
            font-size: 13px;
            transition: all 0.3s;
            padding: 8px;
            border-radius: 4px;
            letter-spacing: 1px;
        }

        .forgot-password:hover {
            color: var(--accent-light);
            background: rgba(102, 126, 234, 0.08);
        }

        body.dark-mode .forgot-password:hover {
            background: rgba(102, 126, 234, 0.1);
        }

        .footer-note {
            text-align: center;
            margin-top: 20px;
            color: var(--text-tertiary);
            font-size: 12px;
            padding: 12px;
            background: var(--footer-bg);
            border-radius: 6px;
            letter-spacing: 1px;
            transition: all 0.5s ease;
        }

        /* 响应式设计 */
        @media (max-width: 480px) {
            .login-container {
                margin: 10px;
                padding: 25px;
                max-width: 350px;
            }

            .login-title {
                font-size: 26px;
            }

            body {
                padding: 10px;
            }

            .theme-toggle {
                top: 10px;
                right: 10px;
                width: 40px;
                height: 40px;
                font-size: 18px;
            }
        }

        /* 主题切换动画 */
        .theme-transition * {
            transition: background-color 0.5s ease, color 0.5s ease, border-color 0.5s ease, box-shadow 0.5s ease;
        }
    </style>
</head>
<body class="theme-transition">
<!-- 主题切换按钮 -->
<div class="theme-toggle" id="themeToggle">
    <i class="fas fa-sun"></i>
    <i class="fas fa-moon"></i>
</div>

<!-- 背景网格 -->
<div class="theme-grid"></div>

<div class="login-container">
    <h2 class="login-title">
        <span class="cyber-text">🎬 江南影院</span>
    </h2>
    <div class="login-subtitle">CYBER CINEMA ACCESS PORTAL</div>

    <c:if test="${not empty requestScope.error}">
        <div class="error">
            <i class="fas fa-exclamation-circle"></i> ${requestScope.error}
        </div>
    </c:if>

    <c:if test="${not empty param.msg}">
        <div class="msg">
            <i class="fas fa-check-circle"></i> ${param.msg}
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/auth/login" method="post" id="loginForm">
        <div class="form-group">
            <label for="username">
                <i class="fas fa-user"></i> USERNAME
            </label>
            <div class="input-wrapper">
                <i class="fas fa-user input-icon"></i>
                <input type="text" id="username" name="username" required
                       placeholder="ENTER USERNAME" autocomplete="off">
            </div>
        </div>

        <div class="form-group">
            <label for="password">
                <i class="fas fa-lock"></i> PASSWORD
            </label>
            <div class="input-wrapper">
                <i class="fas fa-lock input-icon"></i>
                <input type="password" id="password" name="password" required
                       placeholder="ENTER PASSWORD" autocomplete="off">
                <span class="input-icon" style="left: auto; right: 15px; cursor: pointer;"
                      onclick="togglePasswordVisibility()">
                    <i class="fas fa-eye"></i>
                </span>
            </div>
        </div>

        <button type="submit" class="btn" id="loginBtn">
            <i class="fas fa-terminal"></i> ACCESS SYSTEM
        </button>
    </form>

    <div class="links">
        <a href="${pageContext.request.contextPath}/register.jsp">
            <i class="fas fa-user-plus"></i> REGISTER
        </a>
        <a href="${pageContext.request.contextPath}/index.jsp">
            <i class="fas fa-home"></i> RETURN HOME
        </a>
    </div>

    <a class="forgot-password" onclick="showForgotPassword()">
        <i class="fas fa-question-circle"></i> FORGOT PASSWORD?
    </a>

    <div class="footer-note">
        <i class="fas fa-server"></i> © 2025 CYBER CINEMA SYSTEM v2.0
    </div>
</div>

<script>
    // 主题切换功能
    const themeToggle = document.getElementById('themeToggle');
    const body = document.body;

    // 检查本地存储中的主题偏好
    const savedTheme = localStorage.getItem('theme');
    if (savedTheme === 'dark') {
        body.classList.add('dark-mode');
    }

    // 切换主题
    themeToggle.addEventListener('click', () => {
        body.classList.toggle('dark-mode');

        // 保存用户偏好到本地存储
        if (body.classList.contains('dark-mode')) {
            localStorage.setItem('theme', 'dark');
        } else {
            localStorage.setItem('theme', 'light');
        }

        // 添加点击反馈
        themeToggle.style.transform = 'scale(0.9)';
        setTimeout(() => {
            themeToggle.style.transform = 'scale(1)';
        }, 150);
    });

    // 密码可见性切换
    function togglePasswordVisibility() {
        const passwordInput = document.getElementById('password');
        const eyeIcon = document.querySelector('.fa-eye');

        if (passwordInput.type === 'password') {
            passwordInput.type = 'text';
            eyeIcon.classList.replace('fa-eye', 'fa-eye-slash');
            passwordInput.parentElement.style.boxShadow = '0 5px 20px rgba(0, 198, 255, 0.2)';
        } else {
            passwordInput.type = 'password';
            eyeIcon.classList.replace('fa-eye-slash', 'fa-eye');
            passwordInput.parentElement.style.boxShadow = body.classList.contains('dark-mode')
                ? '0 0 15px rgba(102, 126, 234, 0.4)'
                : '0 5px 20px rgba(102, 126, 234, 0.15)';
        }
    }

    // 忘记密码提示
    function showForgotPassword() {
        // 创建模态框
        const modal = document.createElement('div');
        modal.style.cssText = `
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: ${body.classList.contains('dark-mode') ? 'rgba(0,0,0,0.85)' : 'rgba(0,0,0,0.6)'};
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000;
            animation: fadeIn 0.2s ease-out;
            backdrop-filter: blur(5px);
        `;

        const modalContent = document.createElement('div');
        modalContent.style.cssText = `
            background: ${body.classList.contains('dark-mode') ? 'rgba(10, 15, 25, 0.95)' : 'rgba(255, 255, 255, 0.98)'};
            padding: 30px;
            border-radius: 16px;
            max-width: 400px;
            width: 90%;
            text-align: center;
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
            animation: fadeInUp 0.3s ease-out;
            border: 1px solid ${body.classList.contains('dark-mode') ? 'rgba(102, 126, 234, 0.4)' : 'rgba(255, 255, 255, 0.9)'};
            position: relative;
        `;

        modalContent.innerHTML = `
            <div style="color: #00c6ff; margin-bottom: 15px; font-size: 24px;">
                <i class="fas fa-life-ring"></i>
            </div>
            <h3 style="color: ${body.classList.contains('dark-mode') ? '#fff' : '#333'}; margin-bottom: 15px; font-size: 18px; letter-spacing: 2px;">
                PASSWORD RECOVERY
            </h3>
            <p style="color: ${body.classList.contains('dark-mode') ? '#88aaff' : '#666'}; margin-bottom: 20px; line-height: 1.5; font-size: 14px;">
                For password recovery, please contact system administrator:
            </p>
            <div style="background: linear-gradient(90deg, #667eea, #00c6ff);
                       padding: 12px; border-radius: 8px; color: white; margin-bottom: 20px; font-size: 14px; box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);">
                <i class="fas fa-envelope"></i>
                <strong style="letter-spacing: 1px;">EMAIL:</strong> 3088798042@qq.com
            </div>
            <p style="color: ${body.classList.contains('dark-mode') ? '#6688cc' : '#888'}; font-size: 13px; margin-bottom: 20px; line-height: 1.6;">
                We will reset your password within 24 hours and send it to your registered email
            </p>
            <button id="confirmBtn" style="background: linear-gradient(90deg, #667eea, #00c6ff);
                   color: white; border: none; padding: 10px 25px;
                   border-radius: 8px; cursor: pointer; font-size: 14px;
                   transition: 0.3s; letter-spacing: 1px; box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);">
                CONFIRM
            </button>
        `;

        modal.appendChild(modalContent);
        document.body.appendChild(modal);

        // 点击确定按钮关闭模态框
        const confirmBtn = modalContent.querySelector('#confirmBtn');
        confirmBtn.addEventListener('click', function() {
            modal.remove();
        });

        // 点击模态框背景关闭
        modal.addEventListener('click', function(e) {
            if (e.target === modal) {
                modal.remove();
            }
        });
    }

    // 登录按钮点击效果
    document.getElementById('loginBtn').addEventListener('click', function(e) {
        const username = document.getElementById('username').value.trim();
        const password = document.getElementById('password').value.trim();

        if (!username || !password) {
            e.preventDefault();
            const originalHTML = this.innerHTML;
            const originalBackground = this.style.background;
            const originalShadow = this.style.boxShadow;

            this.innerHTML = '<i class="fas fa-exclamation-triangle"></i> INPUT REQUIRED';
            this.style.background = 'linear-gradient(90deg, #ff6b6b, #ee5a24)';
            this.style.boxShadow = '0 5px 20px rgba(231, 76, 60, 0.4)';

            setTimeout(() => {
                this.innerHTML = originalHTML;
                this.style.background = originalBackground;
                this.style.boxShadow = originalShadow;
            }, 1500);
        }
    });

    // 表单提交动画
    document.getElementById('loginForm').addEventListener('submit', function(e) {
        const btn = document.getElementById('loginBtn');
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> ACCESSING...';
    });

    // 页面加载效果
    document.addEventListener('DOMContentLoaded', function() {
        // 添加页面加载动画
        document.body.style.opacity = '0';
        document.body.style.transition = 'opacity 0.8s';

        setTimeout(() => {
            document.body.style.opacity = '1';
        }, 100);

        // 输入框聚焦效果
        const inputs = document.querySelectorAll('input');
        inputs.forEach(input => {
            input.addEventListener('focus', function() {
                this.parentElement.style.boxShadow = '0 5px 20px rgba(0, 198, 255, 0.2)';
                this.parentElement.style.borderColor = '#00c6ff';
            });

            input.addEventListener('blur', function() {
                const isDarkMode = body.classList.contains('dark-mode');
                this.parentElement.style.boxShadow = isDarkMode
                    ? '0 0 15px rgba(102, 126, 234, 0.4)'
                    : '0 5px 20px rgba(102, 126, 234, 0.15)';
                this.parentElement.style.borderColor = isDarkMode
                    ? 'rgba(102, 126, 234, 0.3)'
                    : '#ddd';
            });
        });

        // 鼠标移动效果 - 移除倾斜效果，保留轻微浮动
        document.addEventListener('mousemove', function(e) {
            const container = document.querySelector('.login-container');
            const x = (e.clientX / window.innerWidth - 0.5) * 2;
            const y = (e.clientY / window.innerHeight - 0.5) * 2;

            container.style.transform = `translateY(-5px) translateX(${x}px) translateY(${y}px)`;
        });

        // 鼠标离开效果
        document.addEventListener('mouseleave', function() {
            const container = document.querySelector('.login-container');
            container.style.transform = 'translateY(0)';
        });
    });
</script>
</body>
</html>