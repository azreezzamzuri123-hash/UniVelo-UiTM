package com.univelo.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Ride implements Serializable {
    private int id;
    private int passengerId;
    private int driverId;
    private String pickupLocation;
    private String dropoffLocation;
    private double price;
    private String carModel;
    private String carColor;
    private String numberPlate;
    private String status;
    private Timestamp createdAt;
    
    private String passengerName;
    private String passengerPhone;
    private String driverName;
    private String driverPhone;

    public Ride() {}

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getPassengerId() { return passengerId; }
    public void setPassengerId(int id) { this.passengerId = id; }
    public int getDriverId() { return driverId; }
    public void setDriverId(int id) { this.driverId = id; }
    public String getPickupLocation() { return pickupLocation; }
    public void setPickupLocation(String p) { this.pickupLocation = p; }
    public String getDropoffLocation() { return dropoffLocation; }
    public void setDropoffLocation(String d) { this.dropoffLocation = d; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    public String getCarModel() { return carModel; }
    public void setCarModel(String cm) { this.carModel = cm; }
    public String getCarColor() { return carColor; }
    public void setCarColor(String cc) { this.carColor = cc; }
    public String getNumberPlate() { return numberPlate; }
    public void setNumberPlate(String np) { this.numberPlate = np; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp t) { this.createdAt = t; }
    
    public String getPassengerName() { return passengerName; }
    public void setPassengerName(String n) { this.passengerName = n; }
    public String getPassengerPhone() { return passengerPhone; }
    public void setPassengerPhone(String p) { this.passengerPhone = p; }
    public String getDriverName() { return driverName; }
    public void setDriverName(String n) { this.driverName = n; }
    public String getDriverPhone() { return driverPhone; }
    public void setDriverPhone(String p) { this.driverPhone = p; }
}