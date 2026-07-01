package com.univelo.controller;

import com.univelo.dao.NotificationDAO;
import com.univelo.model.Notification;
import com.univelo.model.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/NotificationController")
public class NotificationController extends HttpServlet {
    private NotificationDAO dao = new NotificationDAO();

    // ─── POST: HANDLES DISMISSING/READING NOTIFICATIONS ─────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        // Session validation guard
        if (currentUser == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String action = request.getParameter("action");

        // Mark a notification alert as read/dismissed
        if ("dismiss".equals(action)) {
            int notificationId = Integer.parseInt(request.getParameter("id"));
            dao.markAsRead(notificationId); // Update status flags in database
            
            // Redirect back to the role-appropriate dashboard panel
            if ("DRIVER".equalsIgnoreCase(currentUser.getRole())) {
                response.sendRedirect("driver-dashboard.jsp");
            } else {
                response.sendRedirect("passenger-dashboard.jsp");
            }
        }
    }

    // ─── GET: FETCHES UNREAD NOTIFICATIONS FOR DASHBOARDS ───────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        if (currentUser == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        // Fetch unread notifications matching the active user session ID
        List<Notification> unreadList = dao.getUnreadNotifications(currentUser.getId());
        request.setAttribute("unreadNotifications", unreadList);
        
        // Forward data payload to render seamlessly inside their respective dashboards
        if ("DRIVER".equalsIgnoreCase(currentUser.getRole())) {
            request.getRequestDispatcher("driver-dashboard.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("passenger-dashboard.jsp").forward(request, response);
        }
    }
}