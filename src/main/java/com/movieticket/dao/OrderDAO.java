package com.movieticket.dao;

import com.movieticket.entity.Order;
import com.movieticket.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 订单数据访问层
 */
public class OrderDAO {

    /**
     * 创建订单，返回插入的订单ID
     */
    public Integer add(Order order) {
        String sql = "INSERT INTO orders (order_number, user_id, schedule_id, seat_numbers, total_price, status) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setString(1, order.getOrderNumber());
            pstmt.setInt(2, order.getUserId());
            pstmt.setInt(3, order.getScheduleId());
            pstmt.setString(4, order.getSeatNumbers());
            pstmt.setDouble(5, order.getTotalPrice());
            pstmt.setInt(6, order.getStatus());
            
            int affectedRows = pstmt.executeUpdate();
            if (affectedRows > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 根据用户ID查询订单
     */
    public List<Order> findByUserId(Integer userId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, m.title as movie_title " +
                     "FROM orders o " +
                     "LEFT JOIN schedules s ON o.schedule_id = s.id " +
                     "LEFT JOIN movies m ON s.movie_id = m.id " +
                     "WHERE o.user_id = ? " +
                     "ORDER BY o.create_time DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    orders.add(mapResultSetToOrder(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("[OrderDAO] findByUserId error: " + e.getMessage());
            e.printStackTrace();
        }
        return orders;
    }

    /**
     * 根据ID查询订单
     */
    public Order findById(Integer id) {
        String sql = "SELECT o.*, m.title as movie_title, h.name as hall_name, s.show_time, s.price as schedule_price " +
                     "FROM orders o " +
                     "LEFT JOIN schedules s ON o.schedule_id = s.id " +
                     "LEFT JOIN movies m ON s.movie_id = m.id " +
                     "LEFT JOIN halls h ON s.hall_id = h.id " +
                     "WHERE o.id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToOrder(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 更新订单状态
     */
    public boolean updateStatus(Integer id, Integer status) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, status);
            pstmt.setInt(2, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 查询场次已売座位
     */
    public List<String> getSoldSeats(Integer scheduleId) {
        List<String> soldSeats = new ArrayList<>();
        String sql = "SELECT seat_numbers FROM orders WHERE schedule_id = ? AND status = 1";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, scheduleId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    String seatNumbers = rs.getString("seat_numbers");
                    if (seatNumbers != null && !seatNumbers.isEmpty()) {
                        String[] seats = seatNumbers.split(",");
                        for (String seat : seats) {
                            if (!seat.trim().isEmpty()) {
                                soldSeats.add(seat.trim());
                            }
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return soldSeats;
    }

    /**
     * 查询所有订单（管理员用）
     */
    public List<Order> findAllForAdmin() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.username, m.title as movie_title, h.name as hall_name, s.show_time, s.price as schedule_price " +
                     "FROM orders o " +
                     "LEFT JOIN users u ON o.user_id = u.id " +
                     "LEFT JOIN schedules s ON o.schedule_id = s.id " +
                     "LEFT JOIN movies m ON s.movie_id = m.id " +
                     "LEFT JOIN halls h ON s.hall_id = h.id " +
                     "ORDER BY o.create_time DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                orders.add(mapResultSetToOrder(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    /**
     * 将ResultSet映射为Order对象
     */
    private Order mapResultSetToOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setId(rs.getInt("id"));
        order.setOrderNumber(rs.getString("order_number"));
        order.setUserId(rs.getInt("user_id"));
        order.setScheduleId(rs.getInt("schedule_id"));
        order.setSeatNumbers(rs.getString("seat_numbers"));
        order.setTotalPrice(rs.getDouble("total_price"));
        order.setStatus(rs.getInt("status"));
        order.setCreateTime(rs.getTimestamp("create_time"));
        
        // 设置电影标题
        if (rs.getString("movie_title") != null) {
            order.setMovieTitle(rs.getString("movie_title"));
        }
        
        return order;
    }
}

