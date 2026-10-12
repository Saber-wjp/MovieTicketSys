<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>我的订单 - 江南影院购票平台</title>
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
        .orders-container {
            background: white;
            padding: 40px;
            margin: 30px 0;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .page-title {
            font-size: 28px;
            font-weight: bold;
            margin-bottom: 30px;
            color: #333;
        }
        .order-list {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        .order-card {
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            padding: 25px;
            transition: all 0.3s;
        }
        .order-card:hover {
            border-color: #6c757d;
            box-shadow: 0 4px 12px rgba(108, 117, 125, 0.2);
        }
        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
        }
        .order-id {
            font-size: 18px;
            font-weight: bold;
            color: #6c757d;
        }
        .order-status {
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: bold;
        }
        .status-pending {
            background: #ff9800;
            color: white;
        }
        .status-paid {
            background: #4caf50;
            color: white;
        }
        .status-cancelled {
            background: #999;
            color: white;
        }
        .order-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 15px;
        }
        .info-item {
            font-size: 14px;
            color: #666;
        }
        .info-item strong {
            color: #333;
            display: block;
            margin-bottom: 5px;
        }
        .order-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 15px;
            padding-top: 15px;
            border-top: 2px solid #f0f0f0;
        }
        .order-total {
            font-size: 20px;
            font-weight: bold;
            color: #e74c3c;
        }
        .no-orders {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }
        .no-orders-icon {
            font-size: 64px;
            margin-bottom: 20px;
        }
        .footer {
            background: #343a40;
            color: white;
            text-align: center;
            padding: 30px 0;
            margin-top: 50px;
        }
        .success {
            color: #27ae60;
            background: #eafaf1;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 20px;
            text-align: center;
        }
        .error {
            color: #e74c3c;
            background: #ffeaea;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 20px;
            text-align: center;
        }
        .btn-cancel {
            background: #e74c3c;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
        }
        .btn-cancel:hover {
            background: #c0392b;
        }
        .btn-cancel:disabled {
            background: #999;
            cursor: not-allowed;
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
                    <span>欢迎，${sessionScope.user}</span>
                </div>
            </div>
        </div>
    </div>

    <div class="container">
        <div class="orders-container">
            <h1 class="page-title">我的订单</h1>
            
            <c:if test="${not empty requestScope.success}">
                <div class="success">${requestScope.success}</div>
            </c:if>
            
            <c:if test="${not empty requestScope.error}">
                <div class="error">${requestScope.error}</div>
            </c:if>
            
            <c:choose>
                <c:when test="${not empty orders}">
                    <div class="order-list">
                        <c:forEach var="order" items="${orders}">
                            <div class="order-card">
                                <div class="order-header">
                                    <div class="order-id">订单号：#${order.id}</div>
                                    <c:choose>
                                        <c:when test="${order.status == 0}">
                                            <span class="order-status status-pending">待支付</span>
                                        </c:when>
                                        <c:when test="${order.status == 1}">
                                            <span class="order-status status-paid">已支付</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="order-status status-cancelled">已取消</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                
                                <div class="order-info">
                                    <div class="info-item">
                                        <strong>电影名称</strong>
                                        ${order.movieTitle}
                                    </div>
                                    <div class="info-item">
                                        <strong>座位</strong>
                                        ${order.seatNumbers}
                                    </div>
                                    <div class="info-item">
                                        <strong>下单时间</strong>
                                        <fmt:formatDate value="${order.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                                    </div>
                                </div>
                                
                                <div class="order-footer">
                                    <div class="order-total">总计：¥${order.totalPrice}</div>
                                    <c:if test="${order.status == 1}">
                                        <!-- 只有已支付的订单才能退票 -->
                                        <form method="post" action="${pageContext.request.contextPath}/order/cancel" style="display: inline;">
                                            <input type="hidden" name="id" value="${order.id}">
                                            <button type="submit" class="btn-cancel" 
                                                    onclick="return confirm('确定要退票吗？退票后金额将原路退回。')">退票</button>
                                        </form>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="no-orders">
                        <div class="no-orders-icon">📋</div>
                        <div style="font-size: 18px; margin-bottom: 10px;">暂无订单</div>
                        <a href="${pageContext.request.contextPath}/index.jsp" style="color: #667eea; text-decoration: none;">去购票 →</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <div class="footer">
        <div class="container">
            <p>&copy; 2025 江南影院购票平台 版权所有</p>
        </div>
    </div>
</body>
</html>