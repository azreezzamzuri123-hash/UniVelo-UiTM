package com.univelo.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Complaint implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int userId; 
    private String complaintType;
    private String description;
    private String status;
    private Timestamp createdAt;
    
    private String resolution;
    private String username;     
    private String role;         

    public Complaint() {}

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getComplaintType() { return complaintType; }
    public void setComplaintType(String complaintType) { this.complaintType = complaintType; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    // NEW Getters and Setters
    public String getResolution() { return resolution; }
    public void setResolution(String resolution) { this.resolution = resolution; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
}