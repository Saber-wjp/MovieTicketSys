<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>电影列表 - 江南影院购票平台</title>
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
            padding: 20px;
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
        .filter-bar {
            background: white;
            padding: 20px;
            margin: 30px 0;
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
    </style>
</head>
<body>
    <div class="header">
        <div class="container">
            <div class="header-content">
                <div class="logo">🎬 江南影院购票平台</div>
                <div class="nav">
                    <a href="${pageContext.request.contextPath}/index.jsp">返回首页</a>
                </div>
            </div>
        </div>
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

            <div class="movie-grid">
                 <c:forEach var="movie" items="${requestScope.movies}">
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

            <c:if test="${empty requestScope.movies}">
                <p style="text-align: center; padding: 40px; color: #999;">暂无电影</p>
            </c:if>
        </div>
</body>
</html>