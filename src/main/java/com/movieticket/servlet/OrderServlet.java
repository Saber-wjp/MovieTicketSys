package com.movieticket.servlet;

import com.movieticket.dao.OrderDAO;
import com.movieticket.dao.ScheduleDAO;
import com.movieticket.entity.Order;
import com.movieticket.entity.Schedule;
import com.movieticket.util.DebugUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * 订单Servlet
 */
@WebServlet("/order/*")
public class OrderServlet extends HttpServlet {
    private OrderDAO orderDAO = new OrderDAO();
    private ScheduleDAO scheduleDAO = new ScheduleDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 打印调试信息
        DebugUtil.printRequestInfo(request);
        
        String action = request.getPathInfo();
        if (action == null) {
            action = "/";
        }

        System.out.println("[OrderServlet] Processing " + action + " request");

        switch (action) {
            case "/selectSeat":
                selectSeatForm(request, response);
                break;
            case "/cancel":
                cancelOrder(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 打印调试信息
        DebugUtil.printRequestInfo(request);
        
        String action = request.getPathInfo();
        if (action == null) {
            action = "/";
        }

        System.out.println("[OrderServlet] Processing POST " + action + " request");

        switch (action) {
            case "/create":
                createOrder(request, response);
                break;
            case "/cancel":
                cancelOrder(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    /**
     * 显示选座界面
     */
    private void selectSeatForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        DebugUtil.printSessionInfo(session);
        
        Integer userId = (Integer) session.getAttribute("userId");
        
        System.out.println("[OrderServlet] Accessing selectSeat, userId: " + userId);
        System.out.println("[OrderServlet] SessionID: " + session.getId());
        
        if (userId == null) {
            System.out.println("[OrderServlet] User not logged in, redirecting to login page");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String scheduleIdStr = request.getParameter("scheduleId");
        System.out.println("[OrderServlet] scheduleId parameter: " + scheduleIdStr);
        if (scheduleIdStr == null || scheduleIdStr.isEmpty()) {
            System.out.println("[OrderServlet] Missing scheduleId parameter");
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        try {
            Integer scheduleId = Integer.parseInt(scheduleIdStr);
            System.out.println("[OrderServlet] Looking for schedule with id: " + scheduleId);
            Schedule schedule = scheduleDAO.findById(scheduleId);
            System.out.println("[OrderServlet] Found schedule: " + (schedule != null ? (schedule.getMovie() != null ? schedule.getMovie().getTitle() : "movie null") : "null"));
            
            if (schedule == null) {
                System.out.println("[OrderServlet] Schedule not found");
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            // 获取已售座位
            List<String> soldSeats = orderDAO.getSoldSeats(scheduleId);
            System.out.println("[OrderServlet] Sold seats count: " + soldSeats.size());
            
            // 生成行号字母映射
            // 添加空值检查，避免NullPointerException
            Integer rowsCountObj = schedule.getHall().getRowsCount();
            int hallRows = (rowsCountObj != null) ? rowsCountObj : 10; // 默认10行
            
            Integer colsCountObj = schedule.getHall().getColsCount();
            int hallCols = (colsCountObj != null) ? colsCountObj : 10; // 默认10列
            
            List<Character> rowLetters = new ArrayList<>();
            for (int i = 0; i < hallRows; i++) {
                rowLetters.add((char) ('A' + i));
            }
            
            // 将数据设置到请求属性中
            request.setAttribute("schedule", schedule);
            request.setAttribute("soldSeats", soldSeats);
            request.setAttribute("rowLetters", rowLetters);
            request.setAttribute("hallCols", hallCols);
            
            // 转发到WEB-INF目录下的JSP文件
            String forwardPath = "/WEB-INF/views/order/selectSeat.jsp";
            System.out.println("[OrderServlet] Forwarding to: " + forwardPath);
            request.getRequestDispatcher(forwardPath).forward(request, response);
        } catch (NumberFormatException e) {
            System.out.println("[OrderServlet] Invalid scheduleId format: " + scheduleIdStr);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        } catch (Exception e) {
            System.out.println("[OrderServlet] Error occurred: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * 创建订单
     */
    private void createOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        DebugUtil.printSessionInfo(session);
        
        Integer userId = (Integer) session.getAttribute("userId");
        
        System.out.println("[OrderServlet] Creating order, userId: " + userId);
        System.out.println("[OrderServlet] SessionID: " + session.getId());
        
        if (userId == null) {
            System.out.println("[OrderServlet] User not logged in, redirecting to login page");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            Integer scheduleId = Integer.parseInt(request.getParameter("scheduleId"));
            String seatInfo = request.getParameter("seatInfo");
            
            System.out.println("[OrderServlet] scheduleId: " + scheduleId + ", seatInfo: " + seatInfo);
            
            if (seatInfo == null || seatInfo.trim().isEmpty()) {
                System.out.println("[OrderServlet] No seats selected");
                request.setAttribute("error", "请选择座位");
                response.sendRedirect(request.getContextPath() + "/order/selectSeat?scheduleId=" + scheduleId);
                return;
            }

            Schedule schedule = scheduleDAO.findById(scheduleId);
            if (schedule == null) {
                System.out.println("[OrderServlet] Schedule not found");
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            // 创建订单
            Order order = new Order();
            order.setOrderNumber(generateOrderNumber());
            order.setUserId(userId);
            order.setScheduleId(scheduleId);
            order.setSeatNumbers(seatInfo);
            
            // 计算总价
            String[] seats = seatInfo.split(",");
            order.setTotalPrice(schedule.getPrice() * seats.length);
            order.setStatus(1); // 直接标记为已支付（演示系统）

            Integer orderId = orderDAO.add(order);
            if (orderId != null) {
                // 获取订单信息用于展示成功页
                Order createdOrder = orderDAO.findById(orderId);
                request.setAttribute("order", createdOrder);
                
                // 转发到WEB-INF目录下的成功页面
                String forwardPath = "/WEB-INF/views/order/success.jsp";
                System.out.println("[OrderServlet] Order created successfully, forwarding to: " + forwardPath);
                request.getRequestDispatcher(forwardPath).forward(request, response);
            } else {
                System.out.println("[OrderServlet] Failed to create order");
                request.setAttribute("error", "订单创建失败，请重试");
                response.sendRedirect(request.getContextPath() + "/order/selectSeat?scheduleId=" + scheduleId);
            }
        } catch (NumberFormatException e) {
            System.out.println("[OrderServlet] Invalid scheduleId format");
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        } catch (Exception e) {
            System.out.println("[OrderServlet] Error occurred: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * 取消订单（退票）
     */
    private void cancelOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        DebugUtil.printSessionInfo(session);
        
        Integer userId = (Integer) session.getAttribute("userId");
        
        System.out.println("[OrderServlet] Canceling order, userId: " + userId);
        
        if (userId == null) {
            System.out.println("[OrderServlet] User not logged in, redirecting to login page");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            Integer orderId = Integer.parseInt(request.getParameter("id"));
            
            // 检查订单是否存在且属于当前用户
            Order order = orderDAO.findById(orderId);
            if (order == null) {
                System.out.println("[OrderServlet] Order not found");
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            
            if (!order.getUserId().equals(userId)) {
                System.out.println("[OrderServlet] Order doesn't belong to user");
                response.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
            
            // 检查订单状态（只能取消已支付的订单）
            if (order.getStatus() != 1) {
                System.out.println("[OrderServlet] Order cannot be canceled");
                request.setAttribute("error", "该订单无法退票");
                request.getRequestDispatcher("/WEB-INF/views/user/orders.jsp").forward(request, response);
                return;
            }
            
            // 检查场次时间（不能退已过的场次）
            Schedule schedule = scheduleDAO.findById(order.getScheduleId());
            if (schedule == null || schedule.getShowTime().before(new java.util.Date())) {
                System.out.println("[OrderServlet] Show time has passed");
                request.setAttribute("error", "已过场次时间，无法退票");
                request.getRequestDispatcher("/WEB-INF/views/user/orders.jsp").forward(request, response);
                return;
            }
            
            // 更新订单状态为已取消（状态3表示已取消）
            if (orderDAO.updateStatus(orderId, 3)) {
                System.out.println("[OrderServlet] Order canceled successfully");
                request.setAttribute("success", "退票成功");
            } else {
                System.out.println("[OrderServlet] Failed to cancel order");
                request.setAttribute("error", "退票失败，请重试");
            }
            
            // 重新加载用户订单并转发到订单页面
            com.movieticket.dao.UserDAO userDAO = new com.movieticket.dao.UserDAO();
            com.movieticket.entity.User user = userDAO.findById(userId);
            java.util.List<Order> orders = orderDAO.findByUserId(userId);
            
            request.setAttribute("user", user);
            request.setAttribute("orders", orders);
            request.getRequestDispatcher("/WEB-INF/views/user/orders.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            System.out.println("[OrderServlet] Invalid order id format");
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        } catch (Exception e) {
            System.out.println("[OrderServlet] Error occurred: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * 生成订单号
     */
    private String generateOrderNumber() {
        return "ORD" + System.currentTimeMillis();
    }
}