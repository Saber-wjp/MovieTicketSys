<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>支付成功 - 江南影院购票平台</title>
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
        .success-container {
            background: white;
            padding: 50px;
            border-radius: 12px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            max-width: 600px;
            width: 100%;
            text-align: center;
        }
        .success-icon {
            font-size: 80px;
            color: #4caf50;
            margin-bottom: 20px;
        }
        .success-title {
            font-size: 32px;
            font-weight: bold;
            color: #333;
            margin-bottom: 20px;
        }
        .success-message {
            font-size: 18px;
            color: #666;
            margin-bottom: 40px;
        }
        .order-details {
            background: #f9f9f9;
            padding: 30px;
            border-radius: 8px;
            margin-bottom: 30px;
            text-align: left;
        }
        .detail-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
            font-size: 16px;
        }
        .detail-item strong {
            color: #6c757d;
        }
        .detail-item:last-child {
            margin-bottom: 0;
            padding-top: 15px;
            border-top: 2px solid #ddd;
            font-size: 20px;
            font-weight: bold;
            color: #e74c3c;
        }
        .btn-group {
            display: flex;
            gap: 15px;
        }
        .btn {
            flex: 1;
            padding: 15px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
            transition: transform 0.2s;
            text-decoration: none;
            display: inline-block;
        }
        .btn-primary {
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            color: white;
        }
        .btn-secondary {
            background: #f5f5f5;
            color: #333;
        }
        .btn:hover {
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
    <div class="success-container">
        <div class="success-icon">✓</div>
        <h1 class="success-title">支付成功！</h1>
        <p class="success-message">您的订单已成功支付，祝您观影愉快！</p>
        
        <div class="order-details">
            <div class="detail-item">
                <span>订单号：</span>
                <strong>#${order.id}</strong>
            </div>
            <div class="detail-item">
                <span>电影：</span>
                <strong>${order.schedule.movie.title}</strong>
            </div>
            <div class="detail-item">
                <span>影厅：</span>
                <strong>${order.schedule.hall.name}</strong>
            </div>
            <div class="detail-item">
                <span>场次时间：</span>
                <strong><fmt:formatDate value="${order.schedule.showTime}" pattern="yyyy-MM-dd HH:mm"/></strong>
            </div>
            <div class="detail-item">
                <span>座位：</span>
                <strong>${order.seatInfo}</strong>
            </div>
            <div class="detail-item">
                <span>支付金额：</span>
                <strong>¥${order.totalPrice}</strong>
            </div>
        </div>
        
        <div class="btn-group">
            <a href="${pageContext.request.contextPath}/user/orders" class="btn btn-primary">查看我的订单</a>
            <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-secondary">返回首页</a>
        </div>
    </div>
</body>
</html>