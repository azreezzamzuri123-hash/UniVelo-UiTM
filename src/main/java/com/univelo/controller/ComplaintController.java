package com.univelo.controller;

import com.univelo.dao.ComplaintDAO;
import com.univelo.model.Complaint;
import com.univelo.model.User;
import com.univelo.dao.NotificationDAO;
import com.univelo.model.Notification;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/ComplaintController")
public class ComplaintController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ComplaintDAO dao = new ComplaintDAO();

    // ─── GET: FETCHES AND DISPLAYS COMPLAINT LISTS ─────────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        // Kick unauthenticated users out to login page
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String action = request.getParameter("action");

        // Admin view: Loads all system tickets
        if ("viewComplaints".equals(action)) {
            if ("ADMIN".equalsIgnoreCase(currentUser.getRole())) {
                List<Complaint> complaintsList = dao.getAllComplaints();
                request.setAttribute("complaintsList", complaintsList);
                request.getRequestDispatcher("/admin-complaints.jsp").forward(request, response);
                return;
            } else {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
                return;
            }
        }

        // User view: Filter out and show only their personal filed tickets
        if ("viewMyComplaints".equals(action)) {
            List<Complaint> userComplaintsList = dao.getComplaintsByUser(currentUser.getId());
            request.setAttribute("userComplaintsList", userComplaintsList);
            request.getRequestDispatcher("/my-complaints.jsp").forward(request, response);
            return;
        }

        // Fallback catch routing based on roles
        if ("PASSENGER".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/passenger-dashboard.jsp");
        } else if ("DRIVER".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/driver-dashboard.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/master-users.jsp");
        }
    }

    // ─── POST: HANDLES COMPLAINT SUBMISSIONS & RESOLUTIONS ──────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String action = request.getParameter("action");

        // 1. New Complaint Registration
        if ("submitComplaint".equals(action)) {
            String complaintType = request.getParameter("complaintType");
            String description = request.getParameter("description");

            Complaint complaint = new Complaint();
            complaint.setUserId(currentUser.getId());
            complaint.setComplaintType(complaintType != null ? complaintType.trim() : "");
            complaint.setDescription(description != null ? description.trim() : "");

            boolean success = dao.insertComplaint(complaint);
            
            String targetDashboard = "driver-dashboard.jsp";
            if ("PASSENGER".equalsIgnoreCase(currentUser.getRole())) {
                targetDashboard = "passenger-dashboard.jsp";
            }

            if (success) {
                response.sendRedirect(request.getContextPath() + "/" + targetDashboard + "?msg=complaintSuccess");
            } else {
                response.sendRedirect(request.getContextPath() + "/" + targetDashboard + "?msg=complaintFailed");
            }

        // 2. Admin Ticket Resolution Workflow
        } else if ("resolveComplaint".equals(action)) {
            if (!"ADMIN".equalsIgnoreCase(currentUser.getRole())) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Unauthorized action");
                return;
            }

            try {
                int complaintId = Integer.parseInt(request.getParameter("complaintId"));
                String resolutionText = request.getParameter("resolution");

                if (resolutionText != null) {
                    resolutionText = resolutionText.trim();
                }

                // Step A: Find the creator of the ticket to track the notification target
                Complaint originalComplaint = dao.getComplaintById(complaintId);

                // Step B: Mark item as RESOLVED and append the summary log
                boolean updated = dao.updateComplaintStatus(complaintId, "RESOLVED", resolutionText);

                if (updated) {
                    // Step C: Push an alert directly down to the targeted client account
                    if (originalComplaint != null) {
                        try {
                            NotificationDAO notificationDao = new NotificationDAO();
                            Notification notif = new Notification();
                            
                            notif.setUserId(originalComplaint.getUserId()); 
                            notif.setTitle("⚠️ Complaint Resolved");
                            notif.setMessage("Your " + originalComplaint.getComplaintType() + " complaint (#" + complaintId + ") has been resolved by Admin: \"" + resolutionText + "\"");
                            notif.setRead(false); // Map to boolean data properties

                            notificationDao.createNotification(notif);
                        } catch (Exception nfe) {
                            nfe.printStackTrace();
                        }
                    }

                    response.sendRedirect(request.getContextPath() + "/ComplaintController?action=viewComplaints&status=updated");
                } else {
                    response.sendRedirect(request.getContextPath() + "/ComplaintController?action=viewComplaints&status=error");
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/ComplaintController?action=viewComplaints&status=badId");
            }

        } else {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }
}