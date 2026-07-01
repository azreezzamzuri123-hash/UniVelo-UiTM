package com.univelo.controller;

import com.univelo.dao.UserDAO;
import com.univelo.model.User;
import java.io.File;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/AuthController")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class AuthController extends HttpServlet {
    private UserDAO dao = new UserDAO();

    // ─── GET: HANDLES LOGOUT SESSIONS ───────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate(); // Destroy session
            }
            response.sendRedirect("index.jsp"); 
        }
    }

    // ─── POST: HANDLES REGISTER & LOGIN SUBMISSIONS ─────────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        // 1. ACCOUNT REGISTRATION & DOCUMENT UPLOAD
        if ("register".equals(action)) {
            String username = request.getParameter("username");
            String role = request.getParameter("role");
            String phone = request.getParameter("phone");
            
            // Extract file part, generate unique filename, and setup destination directory
            Part filePart = request.getPart("documentImage");
            String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
            
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }
            
            filePart.write(uploadPath + File.separator + fileName); // Save image file to server

            // Build user object model
            User user = new User();
            user.setUsername(username);
            user.setPassword(request.getParameter("password"));
            user.setPhone(phone);
            user.setRole(role);
            user.setDocumentPath("uploads/" + fileName); // Save relative path to DB

            if (dao.registerUser(user)) {
                request.setAttribute("message", "Registration successful! Document uploaded. Waiting for approval.");
                request.getRequestDispatcher("index.jsp").forward(request, response);
            } else {
                request.setAttribute("message", "Registration failed. Username might exist.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }
        } 
        // 2. ACCOUNT LOGIN & STATUS CHECK
        else if ("login".equals(action)) {
            User user = dao.login(request.getParameter("username"), request.getParameter("password"));
            if (user != null) {
                
                // Block login if user registration status is PENDING admin approval
                if ("PENDING".equals(user.getStatus())) {
                    request.setAttribute("popupMessage", "Your registration is still PENDING admin approval. Please try again later.");
                    request.getRequestDispatcher("index.jsp").forward(request, response);
                    return; 
                }
                
                // Block login if user registration status has been REJECTED
                if ("REJECTED".equals(user.getStatus())) {
                    request.setAttribute("popupMessage", "Your registration has been REJECTED. Access denied.");
                    request.getRequestDispatcher("index.jsp").forward(request, response);
                    return; 
                }

                session.setAttribute("currentUser", user); // Initialize session storage

                // Role-Based Access Control (RBAC) routing mechanism
                if ("ADMIN".equals(user.getRole())) {
                    response.sendRedirect("AdminController?action=viewPending");
                } else if ("PASSENGER".equals(user.getRole())) {
                    response.sendRedirect("passenger-dashboard.jsp");
                } else if ("DRIVER".equals(user.getRole())) {
                    response.sendRedirect("driver-dashboard.jsp");
                }
            } else {
                request.setAttribute("message", "Invalid username or password!");
                request.getRequestDispatcher("index.jsp").forward(request, response);
            }
        }
    }
}