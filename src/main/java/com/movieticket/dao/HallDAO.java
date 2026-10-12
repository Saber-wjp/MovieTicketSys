package com.movieticket.dao;

import com.movieticket.entity.Hall;
import com.movieticket.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 影厅数据访问层
 */
public class HallDAO {

    /**
     * 查询所有影厅
     */
    public List<Hall> findAll() {
        List<Hall> halls = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM halls ORDER BY id";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Hall hall = new Hall();
                hall.setId(rs.getInt("id"));
                hall.setName(rs.getString("name"));
                hall.setTotalSeats(rs.getInt("total_seats"));
                hall.setRowsCount(rs.getInt("rows"));
                hall.setColsCount(rs.getInt("cols"));
                halls.add(hall);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return halls;
    }

    /**
     * 根据ID查询影厅
     */
    public Hall findById(Integer id) {
        String sql = "SELECT * FROM halls WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToHall(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 将ResultSet映射为Hall对象
     */
    private Hall mapResultSetToHall(ResultSet rs) throws SQLException {
        Hall hall = new Hall();
        hall.setId(rs.getInt("id"));
        hall.setName(rs.getString("name"));
        hall.setTotalSeats(rs.getInt("total_seats"));
        hall.setRowsCount(rs.getInt("rows"));
        hall.setColsCount(rs.getInt("cols"));
        return hall;
    }
}

