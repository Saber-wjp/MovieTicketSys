package com.movieticket.dao;

import com.movieticket.entity.User;
import com.movieticket.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 用户数据访问层
 */
public class UserDAO {

    /**
     * 查询所有用户
     */
    public List<User> findAll() {
        List<User> users = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM users ORDER BY create_time DESC";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setCreateTime(rs.getTimestamp("create_time"));
                users.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return users;
    }

    /**
     * 统计用户总数
     */
    public int countAll() {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int count = 0;
        
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT COUNT(*) FROM users";
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
     * 用户注册
     */
    public boolean register(User user) {
        String sql = "INSERT INTO users (username, password, phone, email) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getPassword());
            pstmt.setString(3, user.getPhone());
            pstmt.setString(4, user.getEmail());
            int result = pstmt.executeUpdate();
            System.out.println("[用户注册] 执行 SQL: " + sql);
            System.out.println("[用户注册] 参数: username=" + user.getUsername() + ", phone=" + user.getPhone() + ", email=" + user.getEmail());
            System.out.println("[用户注册] 结果: " + (result > 0 ? "成功" : "失败"));
            return result > 0;
        } catch (SQLException e) {
            System.err.println("[用户注册] 数据库事务异常: " + e.getMessage());
            System.err.println("[用户注册] SQL错误代码: " + e.getSQLState());
            System.err.println("[用户注册] 错误信息: " + e.getMessage());
            e.printStackTrace();
            return false;
        } catch (Exception e) {
            System.err.println("[用户注册] 未知异常: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 用户登录
     */
    public User login(String username, String password) {
        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 根据ID查询用户
     */
    public User findById(Integer id) {
        String sql = "SELECT * FROM users WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 检查用户名是否存在
     */
    public boolean existsByUsername(String username) {
        String sql = "SELECT COUNT(*) FROM users WHERE username = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, username);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    boolean exists = rs.getInt(1) > 0;
                    System.out.println("[检查用户名] username=" + username + ", 是否存在: " + exists);
                    return exists;
                }
            }
        } catch (SQLException e) {
            System.err.println("[检查用户名] 数据库错误: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 检查手机号是否存在
     */
    public boolean existsByPhone(String phone) {
        String sql = "SELECT COUNT(*) FROM users WHERE phone = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, phone);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("[检查手机号] 数据库错误: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 检查邮箱是否存在
     */
    public boolean existsByEmail(String email) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, email);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("[检查邮箱] 数据库错误: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 更新用户信息
     */
    public boolean update(User user) {
        StringBuilder sqlBuilder = new StringBuilder("UPDATE users SET ");
        boolean hasSetClause = false;
        
        // 只更新非空字段
        if (user.getUsername() != null && !user.getUsername().isEmpty()) {
            sqlBuilder.append("username = ?, ");
            hasSetClause = true;
        }
        
        if (user.getPassword() != null && !user.getPassword().isEmpty()) {
            sqlBuilder.append("password = ?, ");
            hasSetClause = true;
        }
        
        if (user.getEmail() != null) {
            sqlBuilder.append("email = ?, ");
            hasSetClause = true;
        }
        
        if (user.getPhone() != null) {
            sqlBuilder.append("phone = ?, ");
            hasSetClause = true;
        }
        
        // 如果没有任何字段需要更新，则直接返回true
        if (!hasSetClause) {
            return true;
        }
        
        // 移除最后的逗号和空格
        sqlBuilder.setLength(sqlBuilder.length() - 2);
        sqlBuilder.append(" WHERE id = ?");
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sqlBuilder.toString())) {
            
            int paramIndex = 1;
            
            // 设置参数值
            if (user.getUsername() != null && !user.getUsername().isEmpty()) {
                pstmt.setString(paramIndex++, user.getUsername());
            }
            
            if (user.getPassword() != null && !user.getPassword().isEmpty()) {
                pstmt.setString(paramIndex++, user.getPassword());
            }
            
            if (user.getEmail() != null) {
                pstmt.setString(paramIndex++, user.getEmail());
            }
            
            if (user.getPhone() != null) {
                pstmt.setString(paramIndex++, user.getPhone());
            }
            
            pstmt.setInt(paramIndex, user.getId());
            
            int result = pstmt.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 更新密码
     */
    public boolean updatePassword(Integer userId, String newPassword) {
        String sql = "UPDATE users SET password = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, newPassword);
            pstmt.setInt(2, userId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 删除用户
     */
    public boolean delete(int id) {
        // 防止删除管理员账户
        if (id == 1) {
            return false;
        }
        
        String sql = "DELETE FROM users WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            int result = pstmt.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 将ResultSet映射为User对象
     */
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setPhone(rs.getString("phone"));
        user.setEmail(rs.getString("email"));
        user.setCreateTime(rs.getTimestamp("create_time"));
        return user;
    }
}