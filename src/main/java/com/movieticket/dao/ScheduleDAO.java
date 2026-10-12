package com.movieticket.dao;

import com.movieticket.entity.Schedule;
import com.movieticket.entity.Movie;
import com.movieticket.entity.Hall;
import com.movieticket.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 场次数据访问层
 */
public class ScheduleDAO {

    /**
     * 根据电影ID查询场次
     */
    public List<Schedule> findByMovieId(Integer movieId) {
        List<Schedule> schedules = new ArrayList<>();
        String sql = "SELECT s.*, m.title as movie_title, h.name as hall_name, h.total_seats, h.rows, h.cols " +
                     "FROM schedules s " +
                     "LEFT JOIN movies m ON s.movie_id = m.id " +
                     "LEFT JOIN halls h ON s.hall_id = h.id " +
                     "WHERE s.movie_id = ? AND s.status = 1 " +
                     "ORDER BY s.show_time";
        System.out.println("[ScheduleDAO] findByMovieId: movieId=" + movieId);
        System.out.println("[ScheduleDAO] SQL: " + sql);
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, movieId);
            System.out.println("[ScheduleDAO] 执行查询");
            ResultSet rs = pstmt.executeQuery();
            int count = 0;
            while (rs.next()) {
                schedules.add(mapResultSetToSchedule(rs));
                count++;
            }
            System.out.println("[ScheduleDAO] 查询到 " + count + " 个场次");
        } catch (SQLException e) {
            System.err.println("[ScheduleDAO] SQL异常: " + e.getMessage());
            e.printStackTrace();
        }
        return schedules;
    }

    /**
     * 根据ID查询场次
     */
    public Schedule findById(Integer id) {
        String sql = "SELECT s.*, m.title as movie_title, h.name as hall_name, h.total_seats, h.rows, h.cols " +
                     "FROM schedules s " +
                     "LEFT JOIN movies m ON s.movie_id = m.id " +
                     "LEFT JOIN halls h ON s.hall_id = h.id " +
                     "WHERE s.id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToSchedule(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 查询所有场次（包含电影和影厅信息）
     */
    public List<Schedule> findAllWithMovieAndHall() {
        List<Schedule> schedules = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT s.*, m.title as movie_title, h.name as hall_name, h.total_seats, h.rows, h.cols " +
                         "FROM schedules s " +
                         "LEFT JOIN movies m ON s.movie_id = m.id " +
                         "LEFT JOIN halls h ON s.hall_id = h.id " +
                         "ORDER BY s.show_time DESC";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Schedule schedule = new Schedule();
                schedule.setId(rs.getInt("id"));
                schedule.setMovieId(rs.getInt("movie_id"));
                schedule.setHallId(rs.getInt("hall_id"));
                schedule.setShowTime(rs.getTimestamp("show_time"));
                schedule.setPrice(rs.getDouble("price"));
                
                // 创建临时电影和影厅对象来存储名称和其他信息
                Movie movie = new Movie();
                movie.setTitle(rs.getString("movie_title"));
                
                Hall hall = new Hall();
                hall.setName(rs.getString("hall_name"));
                hall.setTotalSeats(rs.getInt("total_seats"));
                hall.setRowsCount(rs.getInt("rows"));
                hall.setColsCount(rs.getInt("cols"));
                
                schedule.setMovie(movie);
                schedule.setHall(hall);
                
                schedules.add(schedule);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return schedules;
    }

    /**
     * 统计今日场次数
     */
    public int countToday() {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int count = 0;
        
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT COUNT(*) FROM schedules WHERE DATE(show_time) = CURDATE()";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return count;
    }

    /**
     * 添加场次
     */
    public boolean add(Schedule schedule) {
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBUtil.getConnection();
            String sql = "INSERT INTO schedules (movie_id, hall_id, show_time, price) VALUES (?, ?, ?, ?)";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, schedule.getMovieId());
            ps.setInt(2, schedule.getHallId());
            ps.setTimestamp(3, new java.sql.Timestamp(schedule.getShowTime().getTime()));
            ps.setDouble(4, schedule.getPrice());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBUtil.close(conn, ps, null);
        }
    }

    /**
     * 更新场次
     */
    public boolean update(Schedule schedule) {
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBUtil.getConnection();
            String sql = "UPDATE schedules SET movie_id=?, hall_id=?, show_time=?, price=? WHERE id=?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, schedule.getMovieId());
            ps.setInt(2, schedule.getHallId());
            ps.setTimestamp(3, new java.sql.Timestamp(schedule.getShowTime().getTime()));
            ps.setDouble(4, schedule.getPrice());
            ps.setInt(5, schedule.getId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBUtil.close(conn, ps, null);
        }
    }

    /**
     * 删除场次
     */
    public boolean delete(int id) {
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBUtil.getConnection();
            String sql = "DELETE FROM schedules WHERE id=?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBUtil.close(conn, ps, null);
        }
    }

    /**
     * 查询所有场次（管理员用）
     */
    public List<Schedule> findAllForAdmin() {
        List<Schedule> schedules = new ArrayList<>();
        String sql = "SELECT s.*, m.title as movie_title, h.name as hall_name, h.total_seats, h.rows, h.cols " +
                     "FROM schedules s " +
                     "LEFT JOIN movies m ON s.movie_id = m.id " +
                     "LEFT JOIN halls h ON s.hall_id = h.id " +
                     "ORDER BY s.show_time DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                schedules.add(mapResultSetToSchedule(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return schedules;
    }

    /**
     * 检查时间冲突
     * 假设每场电影时长为2小时（120分钟），场次间隔30分钟
     */
    private boolean hasTimeConflict(Integer hallId, java.util.Date showTime, Integer excludeId) {
        String sql = "SELECT COUNT(*) FROM schedules WHERE hall_id = ? AND status = 1 " +
                     "AND id != COALESCE(?, -1) " +
                     "AND ABS(TIMESTAMPDIFF(MINUTE, show_time, ?)) < 150";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, hallId);
            pstmt.setObject(2, excludeId);
            pstmt.setTimestamp(3, new Timestamp(showTime.getTime()));
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 将ResultSet映射为Schedule对象
     */
    private Schedule mapResultSetToSchedule(ResultSet rs) throws SQLException {
        Schedule schedule = new Schedule();
        schedule.setId(rs.getInt("id"));
        schedule.setMovieId(rs.getInt("movie_id"));
        schedule.setHallId(rs.getInt("hall_id"));
        schedule.setShowTime(rs.getTimestamp("show_time"));
        schedule.setPrice(rs.getDouble("price"));
        schedule.setStatus(rs.getInt("status"));
        schedule.setCreateTime(rs.getTimestamp("create_time"));
        
        // 设置关联对象 - 即使字段为null也要创建对象
        com.movieticket.entity.Movie movie = new com.movieticket.entity.Movie();
        movie.setTitle(rs.getString("movie_title"));
        schedule.setMovie(movie);
        
        com.movieticket.entity.Hall hall = new com.movieticket.entity.Hall();
        hall.setName(rs.getString("hall_name"));
        hall.setTotalSeats(rs.getInt("total_seats"));
        hall.setRowsCount(rs.getInt("rows"));
        hall.setColsCount(rs.getInt("cols"));
        schedule.setHall(hall);
        
        return schedule;
    }
}