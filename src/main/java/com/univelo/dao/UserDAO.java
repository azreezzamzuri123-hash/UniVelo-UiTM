package com.univelo.dao;

import com.univelo.model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    private final String url = "jdbc:mysql://localhost:3306/univelo_db";
    private final String dbUser = "root";
    private final String dbPassword = ""; 

    // Establishes connection to the MySQL database instance
    private Connection getConnection() throws SQLException {
        try { 
            Class.forName("com.mysql.cj.jdbc.Driver"); 
        } catch (ClassNotFoundException e) { 
            e.printStackTrace(); 
        }
        return DriverManager.getConnection(url, dbUser, dbPassword);
    }

    // ─── AUTHENTICATION & ONBOARDING OPERATIONS ─────────────────────────────

    // Registers a new system account with an initial tracking state of PENDING
    public boolean registerUser(User user) {
        String sql = "INSERT INTO users (username, password, phone, role, status, document_path) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getRole());
            ps.setString(5, "PENDING"); 
            ps.setString(6, user.getDocumentPath());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { 
            e.printStackTrace(); 
            return false; 
        }
    }

    // Validates credentials and constructs a complete matching User context snapshot
    public User login(String username, String password) {
        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setPassword(rs.getString("password")); // Retained explicitly to support seamless password changes
                u.setPhone(rs.getString("phone"));
                u.setRole(rs.getString("role"));
                u.setStatus(rs.getString("status"));
                u.setDocumentPath(rs.getString("document_path"));
                u.setProfilePicPath(rs.getString("profile_pic_path"));
                return u;
            }
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
        return null;
    }

    // ─── PROFILE UPDATE OPERATIONS ──────────────────────────────────────────

    // Persists core modifications made by users onto their own profile settings
    public boolean updateProfile(User user) {
        String sql = "UPDATE users SET username = ?, phone = ?, profile_pic_path = ?, password = ? WHERE id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPhone());
            ps.setString(3, user.getProfilePicPath());
            ps.setString(4, user.getPassword()); 
            ps.setInt(5, user.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { 
            e.printStackTrace(); 
            return false; 
        }
    }

    // ─── ADMINISTRATIVE CONTROL PANEL OPERATIONS ────────────────────────────

    // Approvals Queue: Pulls newly registered users waiting for document verification
    public List<User> getPendingUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE status = 'PENDING'";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setPhone(rs.getString("phone"));
                u.setRole(rs.getString("role"));
                u.setDocumentPath(rs.getString("document_path"));
                list.add(u);
            }
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
        return list;
    }

    // Admin Action: Switches user status markers (e.g., APPROVED, SUSPENDED)
    public boolean updateStatus(int userId, String status) {
        String sql = "UPDATE users SET status = ? WHERE id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { 
            e.printStackTrace(); 
            return false; 
        }
    }
    
    // User Management View: Pulls all platform accounts while ignoring Admin records
    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role != 'ADMIN'";
        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) {
             
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setPhone(rs.getString("phone"));
                u.setRole(rs.getString("role"));
                u.setStatus(rs.getString("status"));
                u.setDocumentPath(rs.getString("document_path"));
                u.setProfilePicPath(rs.getString("profile_pic_path"));
                list.add(u);
            }
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
        return list;
    }
}