package com.movieticket.dao;

import com.movieticket.entity.Movie;
import com.movieticket.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 电影数据访问层
 */
public class MovieDAO {

    /**
     * 查询所有电影
     */
    public List<Movie> findAll() {
        List<Movie> movies = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM movies ORDER BY id DESC";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Movie movie = new Movie();
                movie.setId(rs.getInt("id"));
                movie.setTitle(rs.getString("title"));
                movie.setType(rs.getString("type"));
                movie.setDirector(rs.getString("director"));
                movie.setActors(rs.getString("actors"));
                movie.setDuration(rs.getInt("duration"));
                movie.setDescription(rs.getString("description"));
                movie.setPosterUrl(rs.getString("poster_url"));
                movie.setReleaseDate(rs.getDate("release_date"));
                movies.add(movie);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return movies;
    }

    /**
     * 按类型查询电影
     */
    public List<Movie> findByType(String type) {
        List<Movie> movies = new ArrayList<>();
        String sql = "SELECT * FROM movies WHERE type = ? AND status = 1 ORDER BY release_date DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, type);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    movies.add(mapResultSetToMovie(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return movies;
    }

    /**
     * 根据ID查询电影
     */
    public Movie findById(Integer id) {
        String sql = "SELECT * FROM movies WHERE id = ?";
        System.out.println("[MovieDAO] findById: id=" + id);
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            System.out.println("[MovieDAO] 执行SQL: " + sql + ", 参数: " + id);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                Movie movie = mapResultSetToMovie(rs);
                System.out.println("[MovieDAO] 找到电影: " + movie.getTitle() + " (ID: " + movie.getId() + ")");
                return movie;
            }
            System.out.println("[MovieDAO] 没有找到id=" + id + "的电影");
        } catch (SQLException e) {
            System.err.println("[MovieDAO] SQL错误: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 统计电影总数
     */
    public int countAll() {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int count = 0;
        
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT COUNT(*) FROM movies";
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
     * 添加电影
     */
    public boolean add(Movie movie) {
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBUtil.getConnection();
            String sql = "INSERT INTO movies (title, type, director, actors, duration, description, poster_url, release_date) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(sql);
            ps.setString(1, movie.getTitle());
            ps.setString(2, movie.getType());
            ps.setString(3, movie.getDirector());
            ps.setString(4, movie.getActors());
            ps.setInt(5, movie.getDuration());
            ps.setString(6, movie.getDescription());
            ps.setString(7, movie.getPosterUrl());
            ps.setDate(8, movie.getReleaseDate() != null ? 
                new java.sql.Date(movie.getReleaseDate().getTime()) : null);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBUtil.close(conn, ps, null);
        }
    }

    /**
     * 更新电影
     */
    public boolean update(Movie movie) {
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBUtil.getConnection();
            String sql = "UPDATE movies SET title=?, type=?, director=?, actors=?, duration=?, " +
                         "description=?, poster_url=?, release_date=? WHERE id=?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, movie.getTitle());
            ps.setString(2, movie.getType());
            ps.setString(3, movie.getDirector());
            ps.setString(4, movie.getActors());
            ps.setInt(5, movie.getDuration());
            ps.setString(6, movie.getDescription());
            ps.setString(7, movie.getPosterUrl());
            ps.setDate(8, movie.getReleaseDate() != null ? 
                new java.sql.Date(movie.getReleaseDate().getTime()) : null);
            ps.setInt(9, movie.getId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBUtil.close(conn, ps, null);
        }
    }

    /**
     * 删除电影
     */
    public boolean delete(int id) {
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBUtil.getConnection();
            String sql = "DELETE FROM movies WHERE id=?";
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
     * 查询所有电影（包括已下架）
     */
    public List<Movie> findAllForAdmin() {
        List<Movie> movies = new ArrayList<>();
        String sql = "SELECT * FROM movies ORDER BY create_time DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                movies.add(mapResultSetToMovie(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return movies;
    }

    /**
     * 将ResultSet映射为Movie对象
     */
    private Movie mapResultSetToMovie(ResultSet rs) throws SQLException {
        Movie movie = new Movie();
        movie.setId(rs.getInt("id"));
        movie.setTitle(rs.getString("title"));
        movie.setDirector(rs.getString("director"));
        movie.setActors(rs.getString("actors"));
        movie.setType(rs.getString("type"));
        movie.setDuration(rs.getInt("duration"));
        movie.setDescription(rs.getString("description"));
        movie.setPosterUrl(rs.getString("poster_url"));
        movie.setReleaseDate(rs.getDate("release_date"));
        movie.setStatus(rs.getInt("status"));
        movie.setCreateTime(rs.getTimestamp("create_time"));
        return movie;
    }
}