package com.univelo.dao;

import com.univelo.model.Ride;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RideDAO {
    private final String url = "jdbc:mysql://localhost:3306/univelo_db";
    private final String dbUser = "root";
    private final String dbPassword = ""; 

    private Connection getConnection() throws SQLException {
        try { 
            Class.forName("com.mysql.cj.jdbc.Driver"); 
        } catch (ClassNotFoundException e) { 
            e.printStackTrace(); 
        }
        return DriverManager.getConnection(url, dbUser, dbPassword);
    }

    // ─── PASSENGER BOOKING OPERATIONS ───────────────────────────────────────

    public boolean createRequest(int passengerId, String pickup, String dropoff) {
        String sql = "INSERT INTO rides (passenger_id, pickup_location, dropoff_location, status) VALUES (?, ?, ?, 'PENDING')";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, passengerId);
            ps.setString(2, pickup);
            ps.setString(3, dropoff);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public Ride getActivePassengerRide(int passengerId) {
        String sql = "SELECT r.*, d.username AS d_name, d.phone AS d_phone FROM rides r LEFT JOIN users d ON r.driver_id = d.id WHERE r.passenger_id = ? AND r.status != 'COMPLETED' ORDER BY r.id DESC LIMIT 1";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, passengerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Ride r = new Ride();
                    r.setId(rs.getInt("id"));
                    r.setPassengerId(rs.getInt("passenger_id"));
                    
                    // SAFE-CHECK: Handle nullable driver_id column safely
                    int driverId = rs.getInt("driver_id");
                    if (!rs.wasNull()) {
                        r.setDriverId(driverId);
                    }
                    
                    r.setPickupLocation(rs.getString("pickup_location"));
                    r.setDropoffLocation(rs.getString("dropoff_location"));
                    r.setPrice(rs.getDouble("price"));
                    r.setStatus(rs.getString("status"));
                    r.setCarModel(rs.getString("car_model"));
                    r.setCarColor(rs.getString("car_color"));
                    r.setNumberPlate(rs.getString("number_plate"));
                    r.setDriverName(rs.getString("d_name"));
                    r.setDriverPhone(rs.getString("d_phone"));
                    return r;
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    // ─── DRIVER MATCHING & STATE OPERATIONS ──────────────────────────────────

    public List<Ride> getAvailableBroadcasts() {
        List<Ride> list = new ArrayList<>();
        String sql = "SELECT r.*, u.username AS p_name FROM rides r JOIN users u ON r.passenger_id = u.id WHERE r.status = 'PENDING'";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Ride r = new Ride();
                r.setId(rs.getInt("id"));
                r.setPassengerId(rs.getInt("passenger_id"));
                r.setPickupLocation(rs.getString("pickup_location"));
                r.setDropoffLocation(rs.getString("dropoff_location"));
                r.setPassengerName(rs.getString("p_name"));
                r.setStatus(rs.getString("status"));
                list.add(r);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean driverOfferPrice(int rideId, int driverId, double price) {
        String sql = "UPDATE rides SET driver_id = ?, price = ?, status = 'PRICED' WHERE id = ? AND status = 'PENDING'";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, driverId);
            ps.setDouble(2, price);
            ps.setInt(3, rideId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public Ride getActiveDriverRide(int driverId) {
        String sql = "SELECT r.*, p.username AS p_name, p.phone AS p_phone FROM rides r JOIN users p ON r.passenger_id = p.id WHERE r.driver_id = ? AND r.status IN ('PRICED', 'ON_WAY') ORDER BY r.id DESC LIMIT 1";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, driverId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Ride r = new Ride();
                    r.setId(rs.getInt("id"));
                    r.setPassengerId(rs.getInt("passenger_id"));
                    r.setDriverId(rs.getInt("driver_id"));
                    r.setPickupLocation(rs.getString("pickup_location"));
                    r.setDropoffLocation(rs.getString("dropoff_location"));
                    r.setPrice(rs.getDouble("price"));
                    r.setStatus(rs.getString("status"));
                    r.setPassengerName(rs.getString("p_name"));
                    r.setPassengerPhone(rs.getString("p_phone"));
                    r.setCarModel(rs.getString("car_model"));
                    r.setCarColor(rs.getString("car_color"));
                    r.setNumberPlate(rs.getString("number_plate"));
                    return r;
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    // ─── OFFER MANAGEMENT & NEGOTIATION WORKFLOW ────────────────────────────

    public boolean acceptOfferAndConfirmCar(int rideId, String model, String color, String plate) {
        String sql = "UPDATE rides SET car_model = ?, car_color = ?, number_plate = ?, status = 'ON_WAY' WHERE id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, model);
            ps.setString(2, color);
            ps.setString(3, plate);
            ps.setInt(4, rideId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean rejectOffer(int rideId) {
        String sql = "UPDATE rides SET driver_id = NULL, price = NULL, status = 'PENDING' WHERE id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, rideId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean updateStatus(int rideId, String status) {
        String sql = "UPDATE rides SET status = ? WHERE id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, rideId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // ─── DATA ARCHIVE HISTORY LOGS & SNAPSHOTS ──────────────────────────────

    public List<Ride> getPassengerHistory(int passengerId) {
        List<Ride> list = new ArrayList<>();
        String sql = "SELECT r.*, d.username AS d_name FROM rides r JOIN users d ON r.driver_id = d.id WHERE r.passenger_id = ? AND r.status = 'COMPLETED'";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, passengerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Ride r = new Ride();
                    r.setId(rs.getInt("id"));
                    r.setPickupLocation(rs.getString("pickup_location"));
                    r.setDropoffLocation(rs.getString("dropoff_location"));
                    r.setPrice(rs.getDouble("price"));
                    r.setDriverName(rs.getString("d_name"));
                    list.add(r);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Ride> getDriverHistory(int driverId) {
        List<Ride> list = new ArrayList<>();
        String sql = "SELECT r.*, p.username AS p_name FROM rides r JOIN users p ON r.passenger_id = p.id WHERE r.driver_id = ? AND r.status = 'COMPLETED'";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, driverId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Ride r = new Ride();
                    r.setId(rs.getInt("id"));
                    r.setPickupLocation(rs.getString("pickup_location"));
                    r.setDropoffLocation(rs.getString("dropoff_location"));
                    r.setPrice(rs.getDouble("price"));
                    r.setPassengerName(rs.getString("p_name"));
                    list.add(r);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Ride getRideById(int rideId) {
        String sql = "SELECT r.*, p.username AS p_name, p.phone AS p_phone FROM rides r LEFT JOIN users p ON r.passenger_id = p.id WHERE r.id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, rideId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Ride r = new Ride();
                    r.setId(rs.getInt("id"));
                    r.setPassengerId(rs.getInt("passenger_id"));
                    
                    // SAFE-CHECK: Handle nullable driver_id column safely
                    int driverId = rs.getInt("driver_id");
                    if (!rs.wasNull()) {
                        r.setDriverId(driverId);
                    }
                    
                    r.setPickupLocation(rs.getString("pickup_location"));
                    r.setDropoffLocation(rs.getString("dropoff_location"));
                    r.setPrice(rs.getDouble("price"));
                    r.setStatus(rs.getString("status"));
                    r.setPassengerName(rs.getString("p_name"));
                    r.setPassengerPhone(rs.getString("p_phone")); 
                    r.setCarModel(rs.getString("car_model"));
                    r.setCarColor(rs.getString("car_color"));
                    r.setNumberPlate(rs.getString("number_plate"));
                    return r;
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public int getPassengerIdByRideId(int rideId) {
        String sql = "SELECT passenger_id FROM rides WHERE id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, rideId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("passenger_id");
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }
}