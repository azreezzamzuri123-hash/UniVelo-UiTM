package com.univelo.dao;

import com.univelo.model.Complaint;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ComplaintDAO {
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

    // ─── READ OPERATIONS ────────────────────────────────────────────────────

    // Retrieves a single complaint by its unique ID
    public Complaint getComplaintById(int complaintId) {
        String sql = "SELECT * FROM complaints WHERE id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, complaintId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Complaint c = new Complaint();
                    c.setId(rs.getInt("id"));
                    c.setUserId(rs.getInt("user_id"));
                    c.setComplaintType(rs.getString("complaint_type"));
                    c.setDescription(rs.getString("description"));
                    c.setStatus(rs.getString("status"));
                    c.setCreatedAt(rs.getTimestamp("created_at"));
                    c.setResolution(rs.getString("resolution"));
                    return c;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Retrieves all complaints filed by a specific user (Passenger/Driver)
    public List<Complaint> getComplaintsByUser(int userId) {
        List<Complaint> list = new ArrayList<>();
        String sql = "SELECT * FROM complaints WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Complaint c = new Complaint();
                    c.setId(rs.getInt("id"));
                    c.setUserId(rs.getInt("user_id"));
                    c.setComplaintType(rs.getString("complaint_type"));
                    c.setDescription(rs.getString("description"));
                    c.setStatus(rs.getString("status"));
                    c.setCreatedAt(rs.getTimestamp("created_at"));
                    c.setResolution(rs.getString("resolution")); 
                    list.add(c);
                }
            }
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
        return list;
    }

    // Admin View: Retrieves all system complaints joined with user profile info
    public List<Complaint> getAllComplaints() {
        List<Complaint> list = new ArrayList<>();
        String sql = "SELECT c.*, u.username, u.role FROM complaints c " +
                     "INNER JOIN users u ON c.user_id = u.id " +
                     "ORDER BY c.created_at DESC";
                     
        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) {
             
            while (rs.next()) {
                Complaint c = new Complaint();
                c.setId(rs.getInt("id"));
                c.setUserId(rs.getInt("user_id"));
                c.setComplaintType(rs.getString("complaint_type"));
                c.setDescription(rs.getString("description"));
                c.setStatus(rs.getString("status"));
                c.setCreatedAt(rs.getTimestamp("created_at"));
                c.setResolution(rs.getString("resolution")); 
                c.setUsername(rs.getString("username"));     
                c.setRole(rs.getString("role"));             
                list.add(c);
            }
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
        return list;
    }

    // ─── CREATE OPERATIONS ──────────────────────────────────────────────────

    // Inserts a new user complaint log into the database
    public boolean insertComplaint(Complaint complaint) {
        String sql = "INSERT INTO complaints (user_id, complaint_type, description) VALUES (?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, complaint.getUserId());
            ps.setString(2, complaint.getComplaintType());
            ps.setString(3, complaint.getDescription());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { 
            e.printStackTrace(); 
            return false; 
        }
    }

    // ─── UPDATE OPERATIONS ──────────────────────────────────────────────────

    // Admin Action: Updates complaint status and saves resolution feedback
    public boolean updateComplaintStatus(int complaintId, String status, String resolution) {
        String sql = "UPDATE complaints SET status = ?, resolution = ? WHERE id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, resolution);
            ps.setInt(3, complaintId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { 
            e.printStackTrace(); 
            return false; 
        }
    }
}