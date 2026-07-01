package com.univelo.controller;

import com.univelo.dao.RideDAO;
import com.univelo.dao.NotificationDAO;
import com.univelo.model.User;
import com.univelo.model.Ride;
import com.univelo.model.Notification;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/RideController")
public class RideController extends HttpServlet {
    private final RideDAO dao = new RideDAO();
    private final NotificationDAO notificationDao = new NotificationDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        if (currentUser == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            response.sendRedirect("index.jsp");
            return;
        }

        // 1. Passenger requests a new trip
        if ("requestRide".equals(action)) {
            String pickup = request.getParameter("pickupLocation");
            String dropoff = request.getParameter("dropoffLocation");
            
            if (pickup != null && !pickup.trim().isEmpty() && dropoff != null && !dropoff.trim().isEmpty()) {
                dao.createRequest(currentUser.getId(), pickup.trim(), dropoff.trim());
                response.sendRedirect("passenger-dashboard.jsp");
            } else {
                response.sendRedirect("passenger-dashboard.jsp?msg=errorInvalidLocations");
            }
        } 
        
        // 2. Driver counters a ride request with a price offer
        else if ("offerPrice".equals(action)) {
            try {
                String rideIdParam = request.getParameter("rideId");
                String priceParam = request.getParameter("price");
                
                if (rideIdParam == null || priceParam == null) {
                    throw new NumberFormatException("Missing pricing parameters.");
                }
                
                int rideId = Integer.parseInt(rideIdParam.trim());
                double price = Double.parseDouble(priceParam.trim());
                
                dao.driverOfferPrice(rideId, currentUser.getId(), price);
                response.sendRedirect("driver-dashboard.jsp");
            } catch (NumberFormatException e) {
                response.sendRedirect("driver-dashboard.jsp?msg=errorInvalidInput");
            }
        } 
        
        // 3. Passenger decides to accept or reject the driver's fare offer
        else if ("handleOffer".equals(action)) {
            try {
                String rideIdParam = request.getParameter("rideId");
                String decision = request.getParameter("decision");
                
                if (rideIdParam == null) {
                    throw new NumberFormatException("Missing ride confirmation context.");
                }
                
                int rideId = Integer.parseInt(rideIdParam.trim());

                if ("accept".equals(decision)) {
                    session.setAttribute("pendingAcceptRideId", rideId);
                    response.sendRedirect("passenger-dashboard.jsp?step=confirmVehicle");
                } else {
                    dao.rejectOffer(rideId);
                    response.sendRedirect("passenger-dashboard.jsp");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect("passenger-dashboard.jsp?msg=errorInvalidRide");
            }
        } 
        
        // 4. Passenger inputs and finalizes vehicle metadata info to lock the match
        else if ("submitVehicleInfo".equals(action)) {
            try {
                String rideIdParam = request.getParameter("rideId");
                int rideId = 0;
                
                if (rideIdParam != null && !rideIdParam.trim().isEmpty()) {
                    rideId = Integer.parseInt(rideIdParam.trim());
                } else {
                    Integer sessionRideId = (Integer) session.getAttribute("pendingAcceptRideId");
                    if (sessionRideId != null) {
                        rideId = sessionRideId;
                    }
                }

                if (rideId == 0) {
                    throw new IllegalArgumentException("Ride ID missing from context processing.");
                }

                String model = request.getParameter("carModel");
                String color = request.getParameter("carColor");
                String plate = request.getParameter("numberPlate");
                
                // Set default fallbacks if fields are passed empty
                model = (model != null) ? model.trim() : "Unknown Model";
                color = (color != null) ? color.trim() : "Unknown Color";
                plate = (plate != null) ? plate.trim() : "Unknown Plate";
                
                dao.acceptOfferAndConfirmCar(rideId, model, color, plate);
                
                // Clean up session token after use
                session.removeAttribute("pendingAcceptRideId");
                
                response.sendRedirect("passenger-dashboard.jsp?msg=matchConfirmed");
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("passenger-dashboard.jsp?msg=errorProcessingConfirmation");
            }
        } 
        
        // 5. Driver completes trip
        else if ("completeRide".equals(action)) {
            try {
                String rideIdParam = request.getParameter("rideId");
                if (rideIdParam == null || rideIdParam.trim().isEmpty()) {
                    throw new IllegalArgumentException("Missing parameter data snapshot identifiers.");
                }
                
                int rideId = Integer.parseInt(rideIdParam.trim());
                
                Ride rideSnapshot = dao.getRideById(rideId); 
                if (rideSnapshot == null) {
                    rideSnapshot = dao.getActiveDriverRide(currentUser.getId());
                }

                dao.updateStatus(rideId, "COMPLETED");

                // Dispatch Driver Notification
                Notification driverNotif = new Notification();
                driverNotif.setUserId(currentUser.getId());
                driverNotif.setTitle("🏁 Ride Completed Successfully");
                if (rideSnapshot != null && rideSnapshot.getDropoffLocation() != null) {
                    driverNotif.setMessage("Trip #" + rideId + " to " + rideSnapshot.getDropoffLocation() + " has been successfully finalized.");
                } else {
                    driverNotif.setMessage("Trip #" + rideId + " has been successfully completed and tracked into logs.");
                }
                driverNotif.setRead(false);
                notificationDao.createNotification(driverNotif);

                // Isolate target passenger ID
                int targetPassengerId = 0;
                if (rideSnapshot != null && rideSnapshot.getPassengerId() > 0) {
                    targetPassengerId = rideSnapshot.getPassengerId();
                } else {
                    targetPassengerId = dao.getPassengerIdByRideId(rideId); 
                }

                // Dispatch Passenger Notification
                if (targetPassengerId > 0) {
                    Notification passengerNotif = new Notification();
                    passengerNotif.setUserId(targetPassengerId); 
                    passengerNotif.setTitle("✅ Your Ride is Complete!");
                    passengerNotif.setMessage("Your trip with driver " + currentUser.getUsername() + " has arrived safely. Thank you for using UniVelo!");
                    passengerNotif.setRead(false);
                    notificationDao.createNotification(passengerNotif);
                } else {
                    System.out.println("CRITICAL ERROR: No passenger user link identified for completed Ride ID: " + rideId);
                }

                response.sendRedirect("driver-dashboard.jsp?msg=rideCompleted");
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("driver-dashboard.jsp?msg=complaintFailed");
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doPost(request, response);
    }
}