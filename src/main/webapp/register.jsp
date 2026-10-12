<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>用户注册 - 江南影院售票平台</title>
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
            --bg-secondary: rgba(255, 255, 255, 0.95);
            --bg-grid: linear-gradient(90deg, rgba(230, 230, 235, 0.3) 1px, transparent 1px) 0 0 / 80px 80px,
            linear-gradient(rgba(230, 230, 235, 0.3) 1px, transparent 1px) 0 0 / 80px 80px;
            --text-primary: #333;
            --text-secondary: #666;
            --text-tertiary: #888;
            --border-color: #ddd;
            --accent-color: #667eea;
            --accent-light: #00c6ff;
            --input-bg: rgba(255, 255, 255, 0.9);
            --shadow-light: 0 10px 30px rgba(0, 0, 0, 0.08);
            --shadow-accent: 0 0 30px rgba(102, 126, 234, 0.15);
            --container-border: rgba(255, 255, 255, 0.8);
            --link-color: #667eea;
            --error-bg: rgba(231, 76, 60, 0.1);
            --success-bg: rgba(39, 174, 96, 0.1);
            --footer-bg: rgba(240, 240, 240, 0.8);
            --input-border: rgba(102, 126, 234, 0.2);
        }

        body.dark-mode {
            /* 深色主题变量 */
            --bg-primary: linear-gradient(135deg, #0a0a0a 0%, #0f1525 50%, #1a1a2e 100%);
            --bg-secondary: rgba(10, 15, 25, 0.95);
            --bg-grid: linear-gradient(90deg, rgba(30, 30, 60, 0.7) 1px, transparent 1px) 0 0 / 80px 80px,
            linear-gradient(rgba(30, 30, 60, 0.7) 1px, transparent 1px) 0 0 / 80px 80px;
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
            --input-border: rgba(102, 126, 234, 0.3);
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
            opacity: 0.3;
            transition: background 0.5s ease;
        }

        /* 注册容器 */
        .register-container {
            background: var(--bg-secondary);
            padding: 30px;
            border-radius: 12px;
            box-shadow: var(--shadow-light), var(--shadow-accent),
            inset 0 0 20px rgba(102, 126, 234, 0.1);
            width: 100%;
            max-width: 480px;
            position: relative;
            backdrop-filter: blur(10px);
            border: 1px solid var(--container-border);
            z-index: 2;
            animation: containerFloat 4s ease-in-out infinite;
            max-height: 90vh;
            overflow-y: auto;
            margin: 20px 0;
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

        body.dark-mode .register-container {
            animation: containerGlow 4s ease-in-out infinite;
        }

        @keyframes containerGlow {
            0%, 100% {
                box-shadow:
                        0 0 40px rgba(102, 126, 234, 0.6),
                        0 0 80px rgba(10, 15, 200, 0.3),
                        inset 0 0 20px rgba(102, 126, 234, 0.2);
            }
            50% {
                box-shadow:
                        0 0 60px rgba(102, 126, 234, 0.8),
                        0 0 100px rgba(10, 15, 200, 0.5),
                        inset 0 0 30px rgba(102, 126, 234, 0.3);
            }
        }

        /* 容器边框光效 */
        .register-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            border-radius: 12px;
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

        body.dark-mode .register-container::before {
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

        /* 自定义滚动条样式 */
        .register-container::-webkit-scrollbar {
            width: 6px;
        }

        .register-container::-webkit-scrollbar-track {
            background: rgba(20, 25, 40, 0.3);
            border-radius: 3px;
        }

        .register-container::-webkit-scrollbar-thumb {
            background: linear-gradient(180deg, #667eea, #00c6ff);
            border-radius: 3px;
        }

        .register-title {
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

        body.dark-mode .register-title {
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

        .register-subtitle {
            text-align: center;
            color: var(--text-secondary);
            margin-bottom: 30px;
            font-size: 14px;
            font-weight: 300;
            letter-spacing: 1px;
            transition: color 0.5s ease;
        }

        body.dark-mode .register-subtitle {
            text-shadow: 0 0 10px rgba(102, 126, 234, 0.5);
        }

        .form-group {
            margin-bottom: 20px;
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
            border-radius: 6px;
            border: 1px solid var(--input-border);
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

        body.dark-mode .input-wrapper:hover {
            box-shadow: 0 0 15px rgba(102, 126, 234, 0.4);
        }

        .form-group input {
            width: 100%;
            padding: 14px 15px 14px 50px;
            border: none;
            border-radius: 6px;
            font-size: 15px;
            transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            background: transparent;
            color: var(--text-primary);
            letter-spacing: 1px;
            transition: color 0.5s ease;
        }

        .form-group input:focus {
            outline: none;
            box-shadow: 0 0 0 2px rgba(102, 126, 234, 0.5);
        }

        .input-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--accent-color);
            font-size: 16px;
            z-index: 2;
            transition: all 0.3s;
        }

        body.dark-mode .input-icon {
            text-shadow: 0 0 10px rgba(102, 126, 234, 0.8);
        }

        .form-group input:focus + .input-icon {
            color: var(--accent-light);
            transform: translateY(-50%) scale(1.2);
        }

        .required-mark {
            color: #ff6b6b;
            margin-left: 5px;
            font-weight: bold;
            text-shadow: 0 0 10px rgba(255, 107, 107, 0.8);
        }

        .btn {
            width: 100%;
            padding: 16px;
            background: linear-gradient(90deg, var(--accent-color), var(--accent-light));
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            position: relative;
            overflow: hidden;
            margin-top: 15px;
            letter-spacing: 2px;
            text-transform: uppercase;
            box-shadow: 0 5px 20px rgba(102, 126, 234, 0.3);
        }

        body.dark-mode .btn {
            box-shadow: 0 0 20px rgba(102, 126, 234, 0.5);
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

        body.dark-mode .btn:hover {
            box-shadow: 0 0 30px rgba(102, 126, 234, 0.8);
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
            color: #4cd964;
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

        /* 密码强度提示 */
        .password-strength {
            margin-top: 5px;
            font-size: 12px;
            color: var(--text-secondary);
            letter-spacing: 1px;
            transition: color 0.5s ease;
        }

        .strength-bar {
            height: 4px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 2px;
            margin-top: 5px;
            overflow: hidden;
            position: relative;
            border: 1px solid var(--input-border);
        }

        .strength-bar::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg,
            transparent 25%,
            rgba(102, 126, 234, 0.2) 25%,
            rgba(102, 126, 234, 0.2) 50%,
            transparent 50%,
            transparent 75%,
            rgba(102, 126, 234, 0.2) 75%);
            background-size: 8px 100%;
            animation: scan 2s linear infinite;
        }

        @keyframes scan {
            0% { background-position: 0 0; }
            100% { background-position: 8px 0; }
        }

        .strength-fill {
            height: 100%;
            width: 0;
            transition: width 0.3s, background 0.3s;
            border-radius: 2px;
            position: relative;
            z-index: 1;
        }

        /* 验证提示 */
        .validation-message {
            margin-top: 5px;
            font-size: 12px;
            letter-spacing: 1px;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .validation-success {
            color: #4cd964;
            text-shadow: 0 0 10px rgba(76, 217, 100, 0.5);
        }

        .validation-error {
            color: #ff6b6b;
            text-shadow: 0 0 10px rgba(255, 107, 107, 0.5);
        }

        /* 响应式设计 */
        @media (max-width: 480px) {
            .register-container {
                margin: 10px;
                padding: 25px;
                max-width: 350px;
                max-height: 85vh;
            }

            .register-title {
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

<div class="register-container">
    <h2 class="register-title">
        <span class="cyber-text">🎬 江南影院</span>
    </h2>
    <div class="register-subtitle">CREATE NEW ACCOUNT</div>

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

    <form action="${pageContext.request.contextPath}/user/register" method="post" id="registerForm">
        <div class="form-group">
            <label for="username">
                <i class="fas fa-user"></i> USERNAME <span class="required-mark">*</span>
            </label>
            <div class="input-wrapper">
                <i class="fas fa-user input-icon"></i>
                <input type="text" id="username" name="username" required
                       placeholder="ENTER USERNAME" autocomplete="off">
            </div>
            <div class="validation-message" id="usernameMsg"></div>
        </div>

        <div class="form-group">
            <label for="password">
                <i class="fas fa-lock"></i> PASSWORD <span class="required-mark">*</span>
            </label>
            <div class="input-wrapper">
                <i class="fas fa-lock input-icon"></i>
                <input type="password" id="password" name="password" required
                       placeholder="ENTER PASSWORD (MIN 6 CHARS)" autocomplete="off">
                <span class="input-icon" style="left: auto; right: 15px; cursor: pointer;"
                      onclick="togglePasswordVisibility('password')">
                    <i class="fas fa-eye"></i>
                </span>
            </div>
            <div class="password-strength" id="passwordStrength">SECURITY LEVEL: LOW</div>
            <div class="strength-bar">
                <div class="strength-fill" id="strengthFill"></div>
            </div>
        </div>

        <div class="form-group">
            <label for="confirmPassword">
                <i class="fas fa-lock"></i> CONFIRM PASSWORD <span class="required-mark">*</span>
            </label>
            <div class="input-wrapper">
                <i class="fas fa-lock input-icon"></i>
                <input type="password" id="confirmPassword" name="confirmPassword" required
                       placeholder="RE-ENTER PASSWORD" autocomplete="off">
                <span class="input-icon" style="left: auto; right: 15px; cursor: pointer;"
                      onclick="togglePasswordVisibility('confirmPassword')">
                    <i class="fas fa-eye"></i>
                </span>
            </div>
            <div class="validation-message" id="confirmPasswordMsg"></div>
        </div>

        <div class="form-group">
            <label for="phone">
                <i class="fas fa-phone"></i> PHONE (OPTIONAL)
            </label>
            <div class="input-wrapper">
                <i class="fas fa-phone input-icon"></i>
                <input type="text" id="phone" name="phone"
                       placeholder="ENTER 11-DIGIT PHONE" pattern="[0-9]{11}">
            </div>
            <div class="validation-message" id="phoneMsg"></div>
        </div>

        <div class="form-group">
            <label for="email">
                <i class="fas fa-envelope"></i> EMAIL (OPTIONAL)
            </label>
            <div class="input-wrapper">
                <i class="fas fa-envelope input-icon"></i>
                <input type="email" id="email" name="email"
                       placeholder="ENTER EMAIL ADDRESS">
            </div>
            <div class="validation-message" id="emailMsg"></div>
        </div>

        <button type="submit" class="btn" id="registerBtn">
            <i class="fas fa-user-plus"></i> CREATE ACCOUNT
        </button>
    </form>

    <div class="links">
        <a href="${pageContext.request.contextPath}/login.jsp">
            <i class="fas fa-sign-in-alt"></i> ALREADY HAVE ACCOUNT? LOGIN
        </a>
        <br style="margin: 8px 0;">
        <a href="${pageContext.request.contextPath}/index.jsp">
            <i class="fas fa-home"></i> RETURN HOME
        </a>
    </div>

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
    function togglePasswordVisibility(fieldId) {
        const passwordInput = document.getElementById(fieldId);
        const eyeIcon = passwordInput.parentElement.querySelector('.fa-eye');
        const isDarkMode = body.classList.contains('dark-mode');

        if (passwordInput.type === 'password') {
            passwordInput.type = 'text';
            eyeIcon.classList.replace('fa-eye', 'fa-eye-slash');
            passwordInput.parentElement.style.boxShadow = '0 5px 20px rgba(0, 198, 255, 0.2)';
        } else {
            passwordInput.type = 'password';
            eyeIcon.classList.replace('fa-eye-slash', 'fa-eye');
            passwordInput.parentElement.style.boxShadow = isDarkMode
                ? '0 0 15px rgba(102, 126, 234, 0.4)'
                : '0 5px 20px rgba(102, 126, 234, 0.15)';
        }
    }

    // 密码强度检测
    function checkPasswordStrength(password) {
        let strength = 0;
        const strengthFill = document.getElementById('strengthFill');
        const strengthText = document.getElementById('passwordStrength');
        const isDarkMode = body.classList.contains('dark-mode');

        if (password.length < 6) {
            strengthFill.style.width = '20%';
            strengthFill.style.background = '#ff6b6b';
            strengthText.innerHTML = 'SECURITY LEVEL: TOO WEAK';
            strengthText.style.color = '#ff6b6b';
            strengthText.style.textShadow = '0 0 10px rgba(255, 107, 107, 0.8)';
            return false;
        }

        // 长度检测
        if (password.length >= 6) strength += 1;
        if (password.length >= 8) strength += 1;
        if (password.length >= 12) strength += 1;

        // 包含小写字母
        if (/[a-z]/.test(password)) strength += 1;

        // 包含大写字母
        if (/[A-Z]/.test(password)) strength += 1;

        // 包含数字
        if (/[0-9]/.test(password)) strength += 1;

        // 包含特殊字符
        if (/[^a-zA-Z0-9]/.test(password)) strength += 1;

        // 更新UI
        let width = (strength / 6) * 100;
        let color = '#ff6b6b';
        let text = 'SECURITY LEVEL: WEAK';

        if (strength >= 3) {
            color = '#f39c12';
            text = 'SECURITY LEVEL: MEDIUM';
        }
        if (strength >= 4) {
            color = '#27ae60';
            text = 'SECURITY LEVEL: STRONG';
        }
        if (strength >= 5) {
            color = '#4cd964';
            text = 'SECURITY LEVEL: VERY STRONG';
        }

        strengthFill.style.width = width + '%';
        strengthFill.style.background = `linear-gradient(90deg, ${color}, #00c6ff)`;
        strengthText.innerHTML = text;
        strengthText.style.color = color;
        if (isDarkMode) {
            strengthText.style.textShadow = `0 0 10px ${color}`;
        } else {
            strengthText.style.textShadow = 'none';
        }

        return strength >= 2;
    }

    // 确认密码验证
    function validateConfirmPassword() {
        const password = document.getElementById('password').value;
        const confirmPassword = document.getElementById('confirmPassword').value;
        const confirmMsg = document.getElementById('confirmPasswordMsg');

        if (confirmPassword === '') {
            confirmMsg.innerHTML = '';
            confirmMsg.className = 'validation-message';
            return false;
        }

        if (password === confirmPassword) {
            confirmMsg.innerHTML = '<i class="fas fa-check"></i> PASSWORDS MATCH';
            confirmMsg.className = 'validation-message validation-success';
            return true;
        } else {
            confirmMsg.innerHTML = '<i class="fas fa-times"></i> PASSWORDS DO NOT MATCH';
            confirmMsg.className = 'validation-message validation-error';
            return false;
        }
    }

    // 用户名验证
    function validateUsername() {
        const username = document.getElementById('username').value.trim();
        const usernameMsg = document.getElementById('usernameMsg');

        if (username === '') {
            usernameMsg.innerHTML = '';
            usernameMsg.className = 'validation-message';
            return false;
        }

        if (username.length < 3) {
            usernameMsg.innerHTML = '<i class="fas fa-times"></i> USERNAME TOO SHORT (MIN 3 CHARS)';
            usernameMsg.className = 'validation-message validation-error';
            return false;
        }

        if (username.length > 20) {
            usernameMsg.innerHTML = '<i class="fas fa-times"></i> USERNAME TOO LONG (MAX 20 CHARS)';
            usernameMsg.className = 'validation-message validation-error';
            return false;
        }

        usernameMsg.innerHTML = '<i class="fas fa-check"></i> USERNAME VALID';
        usernameMsg.className = 'validation-message validation-success';
        return true;
    }

    // 手机号验证
    function validatePhone() {
        const phone = document.getElementById('phone').value.trim();
        const phoneMsg = document.getElementById('phoneMsg');

        if (phone === '') {
            phoneMsg.innerHTML = '';
            phoneMsg.className = 'validation-message';
            return true;
        }

        if (!/^[0-9]{11}$/.test(phone)) {
            phoneMsg.innerHTML = '<i class="fas fa-times"></i> INVALID PHONE (11 DIGITS REQUIRED)';
            phoneMsg.className = 'validation-message validation-error';
            return false;
        }

        phoneMsg.innerHTML = '<i class="fas fa-check"></i> PHONE VALID';
        phoneMsg.className = 'validation-message validation-success';
        return true;
    }

    // 邮箱验证
    function validateEmail() {
        const email = document.getElementById('email').value.trim();
        const emailMsg = document.getElementById('emailMsg');

        if (email === '') {
            emailMsg.innerHTML = '';
            emailMsg.className = 'validation-message';
            return true;
        }

        if (!/^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/.test(email)) {
            emailMsg.innerHTML = '<i class="fas fa-times"></i> INVALID EMAIL FORMAT';
            emailMsg.className = 'validation-message validation-error';
            return false;
        }

        emailMsg.innerHTML = '<i class="fas fa-check"></i> EMAIL VALID';
        emailMsg.className = 'validation-message validation-success';
        return true;
    }

    // 显示错误模态框
    function showErrorModal(message) {
        const isDarkMode = body.classList.contains('dark-mode');
        const modal = document.createElement('div');
        modal.style.cssText = `
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: ${isDarkMode ? 'rgba(0,0,0,0.85)' : 'rgba(0,0,0,0.6)'};
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000;
            animation: fadeIn 0.2s ease-out;
            backdrop-filter: blur(5px);
        `;

        const modalContent = document.createElement('div');
        modalContent.style.cssText = `
            background: ${isDarkMode ? 'rgba(10, 15, 25, 0.95)' : 'rgba(255, 255, 255, 0.98)'};
            padding: 30px;
            border-radius: 12px;
            max-width: 400px;
            width: 90%;
            text-align: center;
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
            animation: fadeInUp 0.3s ease-out;
            border: 1px solid ${isDarkMode ? 'rgba(102, 126, 234, 0.4)' : 'rgba(255, 255, 255, 0.9)'};
        `;

        modalContent.innerHTML = `
            <div style="color: #ff6b6b; margin-bottom: 15px; font-size: 24px;">
                <i class="fas fa-exclamation-triangle"></i>
            </div>
            <h3 style="color: ${isDarkMode ? '#fff' : '#333'}; margin-bottom: 15px; font-size: 18px; letter-spacing: 2px;">
                REGISTRATION ERROR
            </h3>
            <p style="color: ${isDarkMode ? '#88aaff' : '#666'}; margin-bottom: 20px; line-height: 1.5; font-size: 14px;">
                ${message}
            </p>
            <button id="confirmErrorBtn" style="background: linear-gradient(90deg, #667eea, #00c6ff);
                   color: white; border: none; padding: 10px 25px;
                   border-radius: 6px; cursor: pointer; font-size: 14px;
                   transition: 0.3s; letter-spacing: 1px; box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);">
                CONFIRM
            </button>
        `;

        modal.appendChild(modalContent);
        document.body.appendChild(modal);

        // 点击确定按钮关闭模态框
        const confirmBtn = modalContent.querySelector('#confirmErrorBtn');
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

    // 表单验证
    function validateForm() {
        const username = document.getElementById('username').value.trim();
        const password = document.getElementById('password').value.trim();
        const confirmPassword = document.getElementById('confirmPassword').value.trim();

        // 用户名验证
        if (username.length < 3) {
            showErrorModal('Username must be at least 3 characters');
            return false;
        }

        // 密码验证
        if (password.length < 6) {
            showErrorModal('Password must be at least 6 characters');
            return false;
        }

        // 密码强度验证
        if (!checkPasswordStrength(password)) {
            showErrorModal('Password is too weak. Please use a stronger password');
            return false;
        }

        // 确认密码验证
        if (password !== confirmPassword) {
            showErrorModal('Passwords do not match');
            return false;
        }

        // 手机号验证（如果填写）
        if (!validatePhone()) {
            return false;
        }

        // 邮箱验证（如果填写）
        if (!validateEmail()) {
            return false;
        }

        return true;
    }

    // 表单提交处理
    document.getElementById('registerForm').addEventListener('submit', function(e) {
        if (!validateForm()) {
            e.preventDefault();
            return false;
        }

        const btn = document.getElementById('registerBtn');
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> CREATING ACCOUNT...';

        return true;
    });

    // 实时验证
    document.getElementById('username').addEventListener('input', validateUsername);
    document.getElementById('password').addEventListener('input', function() {
        checkPasswordStrength(this.value);
        validateConfirmPassword();
    });
    document.getElementById('confirmPassword').addEventListener('input', validateConfirmPassword);
    document.getElementById('phone').addEventListener('input', validatePhone);
    document.getElementById('email').addEventListener('input', validateEmail);

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

        // 鼠标移动效果
        document.addEventListener('mousemove', function(e) {
            const container = document.querySelector('.register-container');
            const x = (e.clientX / window.innerWidth - 0.5) * 2;
            const y = (e.clientY / window.innerHeight - 0.5) * 2;

            container.style.transform = `translateY(-5px) translateX(${x}px) translateY(${y}px)`;
        });

        // 鼠标离开效果
        document.addEventListener('mouseleave', function() {
            const container = document.querySelector('.register-container');
            container.style.transform = 'translateY(0)';
        });
    });
</script>
</body>
</html>