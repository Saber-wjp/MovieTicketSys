<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${movie.title} - 电影详情 - 江南影院购票平台</title>
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
            width: 100%;
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
        .movie-detail {
            background: white;
            padding: 40px;
            margin: 30px 0;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .movie-header {
            display: flex;
            gap: 30px;
            margin-bottom: 30px;
            align-items: flex-start;
        }
        .movie-poster {
            width: 300px;
            height: 450px;
            object-fit: cover;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
            background-color: #f0f0f0; /* 添加默认背景色 */
        }
        .movie-info {
            flex: 1;
        }
        .movie-title {
            font-size: 32px;
            font-weight: bold;
            margin-bottom: 15px;
            color: #333;
        }
        .movie-meta {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }
        .meta-item {
            color: #666;
            font-size: 14px;
        }
        .movie-type {
            display: inline-block;
            padding: 6px 16px;
            background: #6c757d;
            color: white;
            border-radius: 20px;
            font-size: 14px;
            margin-bottom: 20px;
        }
        .movie-description {
            line-height: 1.8;
            color: #555;
            margin-bottom: 30px;
        }
        .schedules-section {
            margin-top: 40px;
        }
        .section-title {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 20px;
            color: #333;
        }
        .schedule-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }
        .schedule-card {
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            padding: 20px;
            transition: all 0.3s;
            cursor: pointer;
        }
        .schedule-card:hover {
            border-color: #6c757d;
            box-shadow: 0 4px 12px rgba(108, 117, 125, 0.2);
        }
        .schedule-time {
            font-size: 20px;
            font-weight: bold;
            color: #6c757d;
            margin-bottom: 10px;
        }
        .schedule-info {
            color: #666;
            font-size: 14px;
            margin-bottom: 5px;
        }
        .schedule-price {
            font-size: 18px;
            font-weight: bold;
            color: #e74c3c;
            margin-top: 10px;
        }
        .btn-book {
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
            margin-top: 15px;
            transition: transform 0.2s;
        }
        .btn-book:hover {
            transform: translateY(-2px);
        }
        .no-schedules {
            text-align: center;
            padding: 40px;
            color: #999;
            font-size: 16px;
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

    <div class="container">
        <div class="movie-detail">
            <div class="movie-header">
                <!-- 电影海报图片：使用相对路径并结合上下文路径 -->
                <img src="${pageContext.request.contextPath}${movie.posterUrl}" alt="${movie.title}" class="movie-poster" 
                     onerror="this.src='${pageContext.request.contextPath}/images/placeholder.jpg'" onload="if(this.naturalHeight === 0) this.src='${pageContext.request.contextPath}/images/placeholder.jpg'">
                <div class="movie-info">
                    <h1 class="movie-title">${movie.title}</h1>
                    <span class="movie-type">${movie.type}</span>
                    <div class="movie-meta">
                        <div class="meta-item"><strong>导演：</strong>${movie.director}</div>
                        <div class="meta-item"><strong>主演：</strong>${movie.actors}</div>
                        <div class="meta-item"><strong>时长：</strong>${movie.duration}分钟</div>
                        <div class="meta-item"><strong>上映日期：</strong><fmt:formatDate value="${movie.releaseDate}" pattern="yyyy-MM-dd"/></div>
                    </div>
                    <div class="movie-description">
                        <strong>简介：</strong><br>
                        ${movie.description}
                    </div>
                </div>
            </div>

            <div class="schedules-section">
                <h2 class="section-title">场次信息</h2>
                <c:choose>
                    <c:when test="${not empty schedules}">
                        <div class="schedule-list">
                            <c:forEach var="schedule" items="${schedules}">
                                <div class="schedule-card">
                                    <div class="schedule-time">
                                        <fmt:formatDate value="${schedule.showTime}" pattern="MM月dd日 HH:mm"/>
                                    </div>
                                    <div class="schedule-info">影厅：${schedule.hall.name}</div>
                                    <div class="schedule-info">电影：${schedule.movie.title}</div>
                                    <div class="schedule-price">¥${schedule.price}</div>
                                    <c:choose>
                                        <c:when test="${sessionScope.user != null}">
                                            <button class="btn-book" onclick="location.href='${pageContext.request.contextPath}/order/selectSeat?scheduleId=${schedule.id}'">
                                                立即购票
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="btn-book" onclick="location.href='${pageContext.request.contextPath}/login.jsp'">
                                                请先登录
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="no-schedules">暂无场次信息</div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <div class="footer">
        <div class="container">
            <p>&copy; 2025 江南影院购票平台 版权所有</p>
        </div>
    </div>
</body>
</html>