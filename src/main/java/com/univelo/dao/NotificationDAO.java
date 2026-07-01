package com.univelo.dao;

import com.univelo.model.Notification;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO {
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

    // ─── CREATE operations ──────────────────────────────────────────────────

    // Inserts a new notification record using a Notification entity object model
    public boolean createNotification(Notification notif) {
        String sql = "INSERT INTO notifications (user_id, title, message, is_read) VALUES (?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, notif.getUserId());
            ps.setString(2, notif.getTitle());
            ps.setString(3, notif.getMessage());
            ps.setBoolean(4, false); // Defaults flag status parameter to false (unread)
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { 
            e.printStackTrace(); 
            return false; 
        }
    }

    // Inserts a new notification record using raw independent method arguments
    public boolean addNotification(int userId, String title, String message) {
        String sql = "INSERT INTO notifications (user_id, title, message) VALUES (?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, title);
            ps.setString(3, message);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { 
            e.printStackTrace(); 
            return false; 
        }
    }

    // ─── READ operations ────────────────────────────────────────────────────

    // Retrieves all unread notification records for a specific user ID sorted by newest first
    public List<Notification> getUnreadNotifications(int userId) {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT * FROM notifications WHERE user_id = ? AND is_read = FALSE ORDER BY id DESC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Notification n = new Notification();
                    n.setId(rs.getInt("id"));
                    n.setUserId(rs.getInt("user_id"));
                    n.setTitle(rs.getString("title"));
                    n.setMessage(rs.getString("message"));
                    n.setRead(rs.getBoolean("is_read"));
                    n.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(n);
                }
            }
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
        return list;
    }

    // ─── UPDATE operations ──────────────────────────────────────────────────

    // Updates a single notification record state marker to read (TRUE)
    public boolean markAsRead(int notificationId) {
        String sql = "UPDATE notifications SET is_read = TRUE WHERE id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, notificationId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { 
            e.printStackTrace(); 
            return false; 
        }
    }
}