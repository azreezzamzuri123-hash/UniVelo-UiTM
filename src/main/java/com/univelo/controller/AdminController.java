package com.univelo.controller;

import com.univelo.dao.UserDAO;
import com.univelo.model.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/AdminController")
public class AdminController extends HttpServlet {
    private UserDAO dao = new UserDAO();

    // ─── POST: HANDLES DATA CHANGES (SUBMISSIONS) ───────────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");

        // Process admin decision (Approve/Reject) on a pending account
        if ("approveOrReject".equals(action)) {
            int id = Integer.parseInt(request.getParameter("userId"));
            String status = request.getParameter("status"); // "APPROVED" or "REJECTED"
            
            dao.updateStatus(id, status); // Save new status to database
            response.sendRedirect("AdminController?action=viewPending"); // Refresh page
        }
    }

    // ─── GET: HANDLES PAGE LOADS & FETCHING DATA ────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        // Load the approval workspace queue
        if ("viewPending".equals(action)) {
            request.setAttribute("pendingUsers", dao.getPendingUsers());
            request.getRequestDispatcher("view-all.jsp").forward(request, response);
        } 
        // Load the complete directory of all system users
        else if ("viewAllUsers".equals(action)) {
            List<User> allUsers = dao.getAllUsers();
            request.setAttribute("allUsersList", allUsers);
            request.getRequestDispatcher("master-users.jsp").forward(request, response);
        }
    }
}