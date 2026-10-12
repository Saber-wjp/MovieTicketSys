<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>电影院购票平台</title>
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
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
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
        .nav {
            display: flex;
            gap: 20px;
            align-items: center;
        }
        .nav a {
            color: white;
            text-decoration: none;
            padding: 8px 16px;
            border-radius: 4px;
            transition: background 0.3s;
        }
        .nav a:hover {
            background: rgba(255,255,255,0.2);
        }
        .banner {
            /* 使用本地首页背景图片 */
            background: url('${pageContext.request.contextPath}/images/首页.jpg') center/cover;
            height: 400px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 48px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.5);
            margin-bottom: 40px;
        }
        .filter-bar {
            background: white;
            padding: 20px;
            margin-bottom: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .filter-buttons {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        .filter-btn {
            padding: 10px 20px;
            border: 2px solid #6c757d;
            background: white;
            color: #6c757d;
            border-radius: 25px;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.3s;
        }
        .filter-btn:hover, .filter-btn.active {
            background: #6c757d;
            color: white;
        }
        .movie-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 30px;
            margin-bottom: 40px;
        }
        .movie-card {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            transition: transform 0.3s, box-shadow 0.3s;
            cursor: pointer;
        }
        .movie-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.15);
        }
        .movie-poster {
            width: 100%;
            height: 350px;
            object-fit: cover;
            background-color: #f0f0f0; /* 添加默认背景色 */
        }
        .movie-info {
            padding: 20px;
        }
        .movie-title {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 10px;
            color: #333;
        }
        .movie-type {
            display: inline-block;
            padding: 4px 12px;
            background: #6c757d;
            color: white;
            border-radius: 12px;
            font-size: 12px;
            margin-bottom: 10px;
        }
        .movie-duration {
            color: #666;
            font-size: 14px;
        }
        .footer {
            background: #343a40;
            color: white;
            text-align: center;
            padding: 30px 0;
            margin-top: 50px;
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
                    <c:choose>
                        <c:when test="${sessionScope.user != null}">
                            <a href="${pageContext.request.contextPath}/user/profile">个人中心</a>
                            <a href="${pageContext.request.contextPath}/user/orders">我的订单</a>
                            <a href="${pageContext.request.contextPath}/user/logout">退出</a>
                            <span>欢迎，${sessionScope.user}</span>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login.jsp">登录</a>
                            <a href="${pageContext.request.contextPath}/register.jsp">注册</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <div class="banner">
        <div>欢迎来到江南影院</div>
    </div>

    <div class="container">
        <div class="filter-bar">
            <div class="filter-buttons">
                <a href="${pageContext.request.contextPath}/movie/list" class="filter-btn ${empty param.type ? 'active' : ''}">全部</a>
                <a href="${pageContext.request.contextPath}/movie/list?type=%E5%8A%A8%E4%BD%9C" class="filter-btn ${param.type == '动作' ? 'active' : ''}">动作</a>
                <a href="${pageContext.request.contextPath}/movie/list?type=%E7%A7%91%E5%B9%BB" class="filter-btn ${param.type == '科幻' ? 'active' : ''}">科幻</a>
                <a href="${pageContext.request.contextPath}/movie/list?type=%E6%81%90%E6%80%96" class="filter-btn ${param.type == '恐怖' ? 'active' : ''}">恐怖</a>
                <a href="${pageContext.request.contextPath}/movie/list?type=%E5%96%9C%E5%89%A7" class="filter-btn ${param.type == '喜剧' ? 'active' : ''}">喜剧</a>
            </div>
        </div>

        <jsp:useBean id="movieDAO" class="com.movieticket.dao.MovieDAO" />
        <c:set var="movies" value="${empty param.type ? movieDAO.findAll() : movieDAO.findByType(param.type)}" />
        
        <div class="movie-grid">
            <c:forEach var="movie" items="${movies}">
                <div class="movie-card" onclick="location.href='${pageContext.request.contextPath}/movie/detail?id=${movie.id}'">
                    <!-- 电影海报图片：使用相对路径并结合上下文路径 -->
                    <img src="${pageContext.request.contextPath}${movie.posterUrl}" alt="${movie.title}" class="movie-poster" 
                         onerror="this.src='${pageContext.request.contextPath}/images/placeholder.jpg'" onload="if(this.naturalHeight === 0) this.src='${pageContext.request.contextPath}/images/placeholder.jpg'">
                    <div class="movie-info">
                        <div class="movie-title">${movie.title}</div>
                        <span class="movie-type">${movie.type}</span>
                        <div class="movie-duration">时长：${movie.duration}分钟</div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

    <div class="footer">
        <div class="container">
            <p>&copy; 2025 江南影院购票平台 版权所有</p>
        </div>
    </div>
</body>
</html>

