<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>选座购票 - 江南影院购票平台</title>
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
        .order-info {
            background: white;
            padding: 30px;
            margin: 30px 0;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .info-item {
            margin-bottom: 15px;
            font-size: 16px;
            color: #333;
        }
        .info-item strong {
            color: #6c757d;
        }
        .seat-selection {
            background: white;
            padding: 40px;
            margin: 30px 0;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .screen {
            text-align: center;
            margin-bottom: 40px;
            padding: 20px;
            background: linear-gradient(to bottom, #6c757d, #495057);
            color: white;
            border-radius: 8px;
            font-size: 24px;
            font-weight: bold;
        }
        .seat-map {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 10px;
            margin-bottom: 30px;
        }
        .seat-row {
            display: flex;
            gap: 8px;
            align-items: center;
        }
        .row-label {
            width: 30px;
            text-align: center;
            font-weight: bold;
            color: #333;
        }
        .seat {
            width: 40px;
            height: 40px;
            border: 2px solid #ddd;
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            font-size: 12px;
            font-weight: bold;
            transition: all 0.3s;
            user-select: none;
        }
        .seat.available {
            background: #4caf50;
            border-color: #4caf50;
            color: white;
        }
        .seat.available:hover {
            background: #45a049;
            transform: scale(1.1);
        }
        .seat.sold {
            background: #f44336;
            border-color: #f44336;
            color: white;
            cursor: not-allowed;
        }
        .seat.selected {
            background: #ff9800;
            border-color: #ff9800;
            color: white;
            transform: scale(1.1);
        }
        .seat.space {
            background: transparent;
            border: none;
            cursor: default;
        }
        .legend {
            display: flex;
            justify-content: center;
            gap: 30px;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }
        .legend-item {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .legend-seat {
            width: 30px;
            height: 30px;
            border: 2px solid;
            border-radius: 6px;
        }
        .legend-seat.available {
            background: #4caf50;
            border-color: #4caf50;
        }
        .legend-seat.sold {
            background: #f44336;
            border-color: #f44336;
        }
        .legend-seat.selected {
            background: #ff9800;
            border-color: #ff9800;
        }
        .order-summary {
            background: #f9f9f9;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .summary-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            font-size: 16px;
        }
        .summary-total {
            font-size: 20px;
            font-weight: bold;
            color: #e74c3c;
            margin-top: 10px;
            padding-top: 10px;
            border-top: 2px solid #ddd;
        }
        .btn-submit {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 18px;
            font-weight: bold;
            cursor: pointer;
            transition: transform 0.2s;
        }
        .btn-submit:hover:not(:disabled) {
            transform: translateY(-2px);
        }
        .btn-submit:disabled {
            background: #ccc;
            cursor: not-allowed;
        }
        .error {
            background: #ffeaea;
            color: #e74c3c;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            text-align: center;
        }
        .warning {
            background: #fff3cd;
            color: #856404;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            text-align: center;
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
        <c:choose>
            <c:when test="${empty schedule}">
                <div class="warning">
                    <h2>场次信息不存在</h2>
                    <p>抱歉，您请求的场次信息不存在或已被删除。</p>
                    <a href="${pageContext.request.contextPath}/index.jsp">返回首页</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="order-info">
                    <div class="info-item"><strong>电影：</strong>
                        <c:choose>
                            <c:when test="${not empty schedule.movie && not empty schedule.movie.title}">
                                ${schedule.movie.title}
                            </c:when>
                            <c:otherwise>
                                未知电影
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="info-item"><strong>影厅：</strong>
                        <c:choose>
                            <c:when test="${not empty schedule.hall && not empty schedule.hall.name}">
                                ${schedule.hall.name}
                            </c:when>
                            <c:otherwise>
                                未知影厅
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="info-item"><strong>时间：</strong>
                        <fmt:formatDate value="${schedule.showTime}" pattern="yyyy-MM-dd HH:mm"/>
                    </div>
                    <div class="info-item"><strong>票价：</strong>¥${schedule.price}</div>
                </div>

                <div class="seat-selection">
                    <div class="screen">荧幕</div>
                    
                    <div class="legend">
                        <div class="legend-item">
                            <div class="legend-seat available"></div>
                            <span>可选</span>
                        </div>
                        <div class="legend-item">
                            <div class="legend-seat selected"></div>
                            <span>已选</span>
                        </div>
                        <div class="legend-item">
                            <div class="legend-seat sold"></div>
                            <span>已售</span>
                        </div>
                    </div>

                    <c:if test="${not empty requestScope.error}">
                        <div class="error">${requestScope.error}</div>
                    </c:if>

                    <div class="seat-map" id="seatMap">
                        <c:choose>
                            <c:when test="${not empty schedule.hall}">
                                <c:set var="hall" value="${schedule.hall}" />
                            </c:when>
                            <c:otherwise>
                                <jsp:useBean id="hallDAO" class="com.movieticket.dao.HallDAO" />
                                <c:set var="hall" value="${hallDAO.findById(schedule.hallId)}" />
                            </c:otherwise>
                        </c:choose>
                        
                        <c:if test="${empty hall}">
                            <div class="warning">
                                <p>影厅信息加载失败</p>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty hall and not empty rowLetters}">
                            <c:forEach var="rowLetter" items="${rowLetters}" varStatus="rowStatus">
                                <div class="seat-row">
                                    <div class="row-label">${rowLetter}</div>
                                    <c:forEach var="col" begin="1" end="${hallCols}">
                                        <%-- 生成座位代码和状态 --%>
                                        <c:set var="seatCode" value="${rowLetter}${col}" />
                                        <c:set var="isSold" value="false" />
                                        <c:forEach var="soldSeat" items="${soldSeats}">
                                            <c:if test="${soldSeat == seatCode}">
                                                <c:set var="isSold" value="true" />
                                            </c:if>
                                        </c:forEach>
                                        <div class="seat ${isSold ? 'sold' : 'available'}" 
                                             data-seat-code="${seatCode}" 
                                             data-is-sold="${isSold}"
                                             onclick="selectSeat(this)">
                                            ${col}
                                        </div>
                                        <c:if test="${col == hallCols / 2}">
                                            <div class="seat space"></div>
                                        </c:if>
                                    </c:forEach>
                                </div>
                            </c:forEach>
                        </c:if>
                    </div>

                    <form id="orderForm" action="${pageContext.request.contextPath}/order/create" method="post">
                        <input type="hidden" name="scheduleId" value="${schedule.id}">
                        <input type="hidden" name="seatInfo" id="seatInfo">
                        
                        <div class="order-summary">
                            <div class="summary-item">
                                <span>已选座位：</span>
                                <span id="selectedSeats">未选择</span>
                            </div>
                            <div class="summary-item">
                                <span>单价：</span>
                                <span>¥${schedule.price}</span>
                            </div>
                            <div class="summary-total">
                                <span>总计：</span>
                                <span id="totalPrice">¥0.00</span>
                            </div>
                        </div>

                        <button type="submit" class="btn-submit" id="submitBtn" disabled>确认购票</button>
                    </form>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <script>
        let selectedSeats = [];
        const price = ${schedule.price};

        function selectSeat(element) {
            const seatCode = element.getAttribute('data-seat-code');
            const isSold = element.getAttribute('data-is-sold') === 'true';
            
            if (isSold) {
                return;
            }
            
            const index = selectedSeats.indexOf(seatCode);

            if (index > -1) {
                // 取消选择
                selectedSeats.splice(index, 1);
                element.classList.remove('selected');
                element.classList.add('available');
            } else {
                // 选择座位
                selectedSeats.push(seatCode);
                element.classList.remove('available');
                element.classList.add('selected');
            }

            updateSummary();
        }

        function updateSummary() {
            const selectedSeatsElement = document.getElementById('selectedSeats');
            const totalPriceElement = document.getElementById('totalPrice');
            const submitBtn = document.getElementById('submitBtn');
            const seatInfoInput = document.getElementById('seatInfo');

            if (selectedSeats.length === 0) {
                selectedSeatsElement.textContent = '未选择';
                totalPriceElement.textContent = '¥0.00';
                submitBtn.disabled = true;
                seatInfoInput.value = '';
            } else {
                selectedSeatsElement.textContent = selectedSeats.join(', ');
                const total = (selectedSeats.length * price).toFixed(2);
                totalPriceElement.textContent = '¥' + total;
                submitBtn.disabled = false;
                seatInfoInput.value = selectedSeats.join(',');
            }
        }
    </script>
</body>
</html>