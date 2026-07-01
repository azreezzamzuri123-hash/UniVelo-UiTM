<%@taglib prefix="c" uri="jakarta.tags.core"%> <%-- Imports JSTL core library tags for iteration and conditional choices --%>
<%@page import="com.univelo.model.User"%> <%-- Imports User model class for data mapping inside scriptlets --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%> <%-- Declares character configuration and content specifications --%>
<%
    // Server-side session verification guard module
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) { 
        response.sendRedirect("index.jsp"); // Re-routes unauthorized requests back to login landing index
        return; // Terminates execution of the current request thread
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UniVelo - My Complaints Log</title>
    <style>
        /* Shared Premium Cyber-Purple Dashboard Theme Variables */
        :root {
            --bg-dark: #07050c;
            --sidebar-bg: rgba(17, 14, 28, 0.75);
            --card-glass: rgba(22, 18, 36, 0.82);
            --input-bg: rgba(31, 26, 51, 0.6);
            --primary-glow: #a855f7;
            --primary-interactive: #b56eff;
            --text-pure: #ffffff;
            --text-primary: #f3f4f6;
            --text-secondary: #9ca3af;
            --border-glow: rgba(168, 85, 247, 0.2);
            
            /* Multi-State Feedback Theme Elements */
            --success-glow: rgba(34, 197, 94, 0.12);
            --success-text: #4ade80;
            --warning-glow: rgba(234, 179, 8, 0.12);
            --warning-text: #facc15;
            --btn-active: rgba(168, 85, 247, 0.15);
        }

        body {
            font-family: 'Plus Jakarta Sans', 'Segoe UI', system-ui, -apple-system, sans-serif;
            background: radial-gradient(circle at center, rgba(13, 11, 20, 0.75) 0%, rgba(7, 5, 12, 0.98) 100%), 
                        url('https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&q=80&w=1600'), 
                        url('https://upload.wikimedia.org/wikipedia/commons/e/e0/UiTM_Main_Gate.jpg');
            background-blend-mode: multiply, screen, normal;
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            background-attachment: fixed;
            margin: 0;
            padding: 0;
            color: var(--text-primary);
            display: flex;
            min-height: 100vh;
            overflow-x: hidden;
        }

        /* --- GLASSMORPHIC SIDEBAR --- */
        .sidebar {
            width: 280px;
            background-color: var(--sidebar-bg);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-right: 1px solid var(--border-glow);
            display: flex;
            flex-direction: column;
            padding: 40px 24px;
            box-sizing: border-box;
            position: fixed;
            height: 100vh;
            z-index: 10;
        }

        .sidebar h1 {
            font-size: 1.4rem;
            font-weight: 800;
            margin-top: 0;
            margin-bottom: 25px;
            letter-spacing: -1px;
            background: linear-gradient(to right, #ffffff, #d8b4fe);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            display: flex;
            align-items: center;
            gap: 12px;
            justify-content: center;
        }

        .sidebar-menu {
            display: flex;
            flex-direction: column;
            gap: 10px;
            flex-grow: 1;
        }

        .sidebar-menu a {
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
            color: var(--text-secondary);
            padding: 14px 18px;
            border-radius: 12px;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 12px;
            border: 1px solid transparent;
        }

        .sidebar-menu a:hover {
            color: var(--text-pure);
            background-color: rgba(255, 255, 255, 0.04);
            transform: translateX(4px);
        }

        .sidebar-menu a.active {
            color: var(--primary-interactive);
            background-color: var(--btn-active);
            border-color: rgba(168, 85, 247, 0.25);
            box-shadow: 0 0 15px rgba(168, 85, 247, 0.1);
        }

        /* Profile Layout in Sidebar */
        .profile-container {
            text-align: center; 
            margin-bottom: 30px; 
            border-bottom: 1px solid var(--border-glow); 
            padding-bottom: 25px;
        }

        .profile-img {
            width: 84px;
            height: 84px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid var(--primary-interactive);
            display: block;
            margin: 0 auto 12px auto;
            box-shadow: 0 0 20px rgba(168, 85, 247, 0.3);
        }

        .avatar-placeholder {
            width: 84px;
            height: 84px;
            background-color: var(--input-bg);
            border-radius: 50%;
            text-align: center;
            line-height: 84px;
            margin: 0 auto 12px auto;
            color: var(--text-secondary);
            font-size: 12px;
            font-weight: 600;
            border: 2px dashed var(--border-glow);
        }

        .status-badge {
            display: inline-block;
            padding: 6px 14px;
            border-radius: 20px;
            font-weight: 700;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.8px;
        }
        .status-badge.APPROVED, .status-badge.ACTIVE { background-color: var(--success-glow); color: var(--success-text); border: 1px solid rgba(34, 197, 94, 0.3); }
        .status-badge.PENDING { background-color: var(--warning-glow); color: var(--warning-text); border: 1px solid rgba(234, 179, 8, 0.3); }

        /* --- MAIN CONTENT LAYOUT --- */
        .main-content {
            margin-left: 280px;
            padding: 50px 60px;
            width: calc(100% - 280px);
            box-sizing: border-box;
        }

        h2 {
            font-size: 2.4rem;
            font-weight: 800;
            letter-spacing: -1px;
            margin-top: 0;
            margin-bottom: 0.25rem;
            background: linear-gradient(to right, #ffffff, #e9d5ff);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .subtitle-desc {
            color: var(--text-secondary);
            font-size: 1.05rem;
            font-weight: 500;
            margin-top: 0;
            margin-bottom: 2.5rem;
            max-width: 700px;
            line-height: 1.5;
        }

        /* --- COMPLAINTS GLASS CARD --- */
        .card {
            background: var(--card-glass);
            backdrop-filter: blur(24px);
            -webkit-backdrop-filter: blur(24px);
            padding: 2.5rem;
            border-radius: 20px;
            border: 1px solid var(--border-glow);
            margin-bottom: 30px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5),
                        0 0 25px 0 rgba(168, 85, 247, 0.03);
            width: 100%;
            max-width: 1100px;
            box-sizing: border-box;
        }

        /* --- SEARCH FILTER UTILITY --- */
        .search-wrapper {
            margin-bottom: 2rem;
            width: 100%;
            max-width: 360px;
        }

        .search-wrapper input {
            width: 100%;
            padding: 14px 18px;
            background-color: var(--input-bg);
            backdrop-filter: blur(5px);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 12px;
            font-size: 14px;
            color: var(--text-primary);
            box-sizing: border-box;
            outline: none;
            transition: all 0.3s ease;
        }

        .search-wrapper input:focus {
            border-color: var(--primary-interactive);
            background-color: rgba(31, 26, 51, 0.9);
            box-shadow: 0 0 15px rgba(168, 85, 247, 0.15);
        }

        /* --- MODERN TABLE DESIGN --- */
        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            border: 1px solid rgba(255, 255, 255, 0.05);
            border-radius: 14px;
            overflow: hidden;
            background-color: rgba(13, 11, 20, 0.2);
        }

        th, td {
            padding: 18px 20px;
            text-align: left;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
            font-size: 14px;
            vertical-align: top;
        }

        th {
            background-color: rgba(26, 21, 43, 0.6);
            color: var(--text-primary);
            font-weight: 700;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 1px;
            border-bottom: 1px solid var(--border-glow);
        }

        tr:last-child td {
            border-bottom: none;
        }

        tr:hover td {
            background-color: rgba(255, 255, 255, 0.015);
        }

        /* Status Pills inside Table Rows */
        .status {
            padding: 6px 14px;
            border-radius: 20px;
            font-weight: 700;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.6px;
            display: inline-flex;
            align-items: center;
        }
        .status.PENDING { background-color: var(--warning-glow); color: var(--warning-text); border: 1px solid rgba(234, 179, 8, 0.25); }
        .status.RESOLVED { background-color: var(--success-glow); color: var(--success-text); border: 1px solid rgba(34, 197, 94, 0.25); }

        /* Resolution Message Box */
        .resolution-box {
            padding: 16px;
            background-color: rgba(34, 197, 94, 0.03);
            border: 1px solid rgba(34, 197, 94, 0.12);
            border-left: 4px solid var(--success-text);
            border-radius: 10px;
            font-size: 13.5px;
            line-height: 1.5;
        }
    </style>
</head>
<body>

    <%-- Left Dashboard Sidebar Navigation Shell --%>
    <div class="sidebar">
        <h1>🔮 UniVelo</h1>
        
        <div class="profile-container">
            <c:choose>
                <%-- Evaluates if profile picture data path parameters are valid --%>
                <c:when test="${not empty currentUser.profilePicPath}">
                    <img src="${pageContext.request.contextPath}/${currentUser.profilePicPath}" class="profile-img" alt="Avatar">
                </c:when>
                <c:otherwise>
                    <div class="avatar-placeholder">NO AVATAR</div>
                </c:otherwise>
            </c:choose>
            <h4 style="margin: 6px 0; font-size: 15px; font-weight: 700; color: var(--text-pure);">${currentUser.username}</h4>
            <span class="status-badge ${currentUser.status}">${currentUser.status}</span>
        </div>

        <div class="sidebar-menu">
            <c:choose>
                <%-- Customizes workspace redirection based on role parameters --%>
                <c:when test="${currentUser.role eq 'DRIVER'}">
                    <a href="driver-dashboard.jsp">🚖 Driver Workspace</a>
                </c:when>
                <c:otherwise>
                    <a href="passenger-dashboard.jsp">🚖 Ride Booking Portal</a>
                </c:otherwise>
            </c:choose>
            <a href="${pageContext.request.contextPath}/ProfileController?action=edit">👤 Edit Profile Settings</a>
            <a href="complaint-form.jsp">⚠️ File a New Complaint</a>
            <a href="ComplaintController?action=viewMyComplaints" class="active">📋 View My Complaints History</a>
            
            <a href="${pageContext.request.contextPath}/AuthController?action=logout" style="color: #fca5a5; margin-top: auto;">🚪 Log Out</a>
        </div>
    </div>

    <%-- Main Workspace Logs Container --%>
    <div class="main-content">
        <h2>My Support Logs</h2>
        <div class="subtitle-desc">Track statuses and administrative resolutions</div>

        <div class="card">
            <div class="search-wrapper">
                <input type="text" id="logSearchInput" placeholder="🔍 Search logs by ID or description...">
            </div>

            <table id="complaintsTable">
                <thead>
                    <tr>
                        <th style="width: 12%;">Ticket ID</th>
                        <th style="width: 43%;">Reported Issue Description</th>
                        <th style="width: 15%;">Log Status</th>
                        <th style="width: 30%;">Admin Remarks / Resolution</th>
                    </tr>
                </thead>
                <tbody>
                    <%-- Loops dynamically through specific support tickets linked to the current active profile --%>
                    <c:forEach items="${userComplaintsList}" var="complaint">
                        <tr>
                            <td style="font-weight: 700; color: var(--text-secondary);"># ${complaint.id}</td>
                            <td>
                                <div style="line-height: 1.6; color: var(--text-primary); font-weight: 500;">${complaint.description}</div>
                            </td>
                            <td>
                                <span class="status ${complaint.status}">${complaint.status}</span>
                            </td>
                            <td>
                                <c:choose>
                                    <%-- Pulls and decorates custom resolution administrative statements only when tickets reach RESOLVED state flags --%>
                                    <c:when test="${complaint.status eq 'RESOLVED'}">
                                        <div class="resolution-box">
                                            <strong style="color: var(--success-text); display: block; margin-bottom: 6px; font-size: 11px; text-transform: uppercase; letter-spacing: 0.8px;">System Update:</strong>
                                            <span style="color: var(--text-primary); font-style: italic;">"${complaint.resolution}"</span>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color: var(--text-secondary); font-size: 13px; font-style: italic; display: flex; align-items: center; gap: 6px;">⏳ Awaiting assessment...</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    <%-- Displays customized empty fallback indicators if the database collections return vacant --%>
                    <c:if test="${empty userComplaintsList}">
                        <tr id="emptyRow">
                            <td colspan="4" style="text-align: center; color: var(--text-secondary); padding: 50px; font-style: italic; font-weight: 500;">
                                You haven't filed any complaints or support tickets yet.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        /**
         * Real-time client-side filter engine to search and parse log listings instantly
         * Evaluates Ticket IDs and Description data nodes across table cell layouts.
         */
        document.getElementById('logSearchInput').addEventListener('keyup', function() {
            const query = this.value.toLowerCase();
            const rows = document.querySelectorAll('#complaintsTable tbody tr:not(#emptyRow)');
            
            rows.forEach(row => {
                const idText = row.cells[0].textContent.toLowerCase();
                const descText = row.cells[1].textContent.toLowerCase();
                
                // Toggles element visibility layout based on pattern matching query criteria
                if (idText.includes(query) || descText.includes(query)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        });
    </script>
</body>
</html>