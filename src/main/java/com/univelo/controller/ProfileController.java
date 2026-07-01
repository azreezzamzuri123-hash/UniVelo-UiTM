package com.univelo.controller;

import com.univelo.dao.UserDAO;
import com.univelo.model.User;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/ProfileController")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class ProfileController extends HttpServlet {
    private UserDAO dao = new UserDAO();

    // ─── GET: HANDLES PAGE REDIRECTION TO THE PROFILE EDITOR ────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("edit".equals(action)) {
            response.sendRedirect(request.getContextPath() + "/edit-profile.jsp");
        } else {
            response.sendRedirect("index.jsp");
        }
    }

    // ─── POST: HANDLES PARSING AND SAVING MULTIPART FORM UPDATES ────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // Extract string action from multi-part data boundaries
        String action = getValueFromPart(request.getPart("action"));
        if (action == null || action.trim().isEmpty()) {
            action = request.getParameter("action"); 
        }

        if ("updateProfile".equals(action)) {
            User currentUser = (User) session.getAttribute("currentUser");
            
            if (currentUser != null) {
                // 1. Parse string form values out of the raw stream bytes
                String newUsername = getValueFromPart(request.getPart("username"));
                String newPhone = getValueFromPart(request.getPart("phone"));
                String newPassword = getValueFromPart(request.getPart("password"));
                
                if (newUsername != null && !newUsername.trim().isEmpty()) currentUser.setUsername(newUsername.trim());
                if (newPhone != null && !newPhone.trim().isEmpty()) currentUser.setPhone(newPhone.trim());
                
                // Overwrite password if user actually typed a new value
                if (newPassword != null && !newPassword.trim().isEmpty()) {
                    currentUser.setPassword(newPassword.trim());
                }

                // 2. Handle Profile Image File Streams
                Part filePart = request.getPart("profilePic");
                if (filePart != null && filePart.getSize() > 0) {
                    String fileName = System.currentTimeMillis() + "_" + getSubmittedFileName(filePart);
                    String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                    
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdir();
                    }
                    filePart.write(uploadPath + File.separator + fileName); // Disk write operation
                    
                    currentUser.setProfilePicPath("uploads/" + fileName); // Assign file reference path to user
                }

                // 3. Persist modifications and update local session values
                if (dao.updateProfile(currentUser)) {
                    session.setAttribute("currentUser", currentUser); 
                    request.setAttribute("message", "Profile updated successfully!");
                } else {
                    request.setAttribute("message", "Failed to update profile details.");
                }
                
                // Use PRG pattern (Post/Redirect/Get) to eliminate duplicate form execution concerns on refresh
                if ("PASSENGER".equalsIgnoreCase(currentUser.getRole())) {
                    response.sendRedirect(request.getContextPath() + "/passenger-dashboard.jsp");
                } else {
                    response.sendRedirect(request.getContextPath() + "/driver-dashboard.jsp");
                }
            } else {
                response.sendRedirect("index.jsp");
            }
        }
    }

    // Helper: Converts part input streams into standard Java Strings
    private String getValueFromPart(Part part) throws IOException {
        if (part == null) return null;
        try (InputStream is = part.getInputStream();
             BufferedReader reader = new BufferedReader(new InputStreamReader(is))) {
            String line = reader.readLine();
            return (line != null) ? line.trim() : null;
        }
    }

    // Helper: Isolates the true filename from the Part's Content-Disposition metadata header
    private String getSubmittedFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        if (contentDisp != null) {
            for (String cd : contentDisp.split(";")) {
                if (cd.trim().startsWith("filename")) {
                    String fileName = cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
                    return fileName.substring(fileName.lastIndexOf('/') + 1).substring(fileName.lastIndexOf('\\') + 1);
                }
            }
        }
        return "unknown.png";
    }
}