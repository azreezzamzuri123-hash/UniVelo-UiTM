<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.univelo.model.User"%>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) { 
        response.sendRedirect("index.jsp"); 
        return; 
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UniVelo - Profile Management</title>
    <style>
        /* Shared Premium Cyber-Purple Dashboard Theme Variables */
        :root {
            --bg-dark: #07050c;
            --sidebar-bg: rgba(17, 14, 28, 0.75);
            --card-glass: rgba(22, 18, 36, 0.82);
            --input-bg: rgba(31, 26, 51, 0.6);
            --primary-glow: #a855f7;
            --primary-interactive: #b56eff;
            --primary-gradient: linear-gradient(135deg, #a855f7 0%, #7c3aed 100%);
            --text-pure: #ffffff;
            --text-primary: #f3f4f6;
            --text-secondary: #9ca3af;
            --border-glow: rgba(168, 85, 247, 0.2);
            
            /* Multi-State Feedback Theme Elements */
            --success-glow: rgba(34, 197, 94, 0.15);
            --success-text: #4ade80;
            --danger-glow: rgba(239, 68, 68, 0.15);
            --danger-text: #fca5a5;
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

        .sidebar-menu a.logout-btn {
            color: #fca5a5;
            margin-top: auto;
        }

        .sidebar-menu a.logout-btn:hover {
            color: #ef4444;
            background-color: rgba(239, 68, 68, 0.08);
            border-color: rgba(239, 68, 68, 0.15);
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

        .profile-phone {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 4px;
            font-size: 12px;
            color: var(--text-secondary);
            margin: 4px 0 10px 0;
            font-weight: 500;
        }

        /* High Visibility Status Pill Badge */
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
            letter-spacing: -1.5px;
            margin-top: 0;
            margin-bottom: 0.25rem;
            background: linear-gradient(to right, #ffffff, #e9d5ff);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        h3 {
            color: var(--text-secondary);
            font-size: 1.05rem;
            font-weight: 500;
            margin-top: 0;
            margin-bottom: 2.5rem;
            letter-spacing: 0.5px;
            text-transform: uppercase;
        }

        /* --- PROFILE GLASS CARD ARCHITECTURE --- */
        .card {
            background: var(--card-glass);
            backdrop-filter: blur(24px);
            -webkit-backdrop-filter: blur(24px);
            padding: 3rem 2.5rem;
            border-radius: 20px;
            border: 1px solid var(--border-glow);
            margin-top: 15px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.6),
                        0 0 25px 0 rgba(168, 85, 247, 0.05);
            max-width: 650px;
        }

        /* Center Display Avatar Styling inside Form */
        .form-avatar-container {
            text-align: center;
            margin-bottom: 2.5rem;
        }

        .form-avatar-img {
            width: 130px;
            height: 130px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid var(--primary-interactive);
            box-shadow: 0 0 25px rgba(168, 85, 247, 0.45);
        }

        /* --- INPUT FORMS SYSTEM --- */
        form label {
            display: block;
            font-size: 13px;
            color: var(--text-secondary);
            margin-bottom: 0.8rem;
            font-weight: 600;
        }

        form input[type="text"], 
        form input[type="password"],
        form input[type="file"] {
            width: 100%;
            padding: 15px 18px;
            background-color: var(--input-bg);
            backdrop-filter: blur(5px);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 12px;
            font-size: 14px;
            color: var(--text-primary);
            transition: all 0.3s ease;
            box-sizing: border-box;
            outline: none;
            margin-bottom: 1.75rem;
        }

        form input[type="text"]:focus,
        form input[type="password"]:focus {
            border-color: var(--primary-interactive);
            background-color: rgba(31, 26, 51, 0.9);
            box-shadow: 0 0 15px rgba(168, 85, 247, 0.15);
        }

        form input[type="file"] {
            padding: 12px;
            cursor: pointer;
        }

        .btn-submit {
            display: block;
            width: 100%;
            text-align: center;
            color: white;
            border: none;
            padding: 16px;
            border-radius: 12px;
            cursor: pointer;
            font-weight: 700;
            font-size: 15px;
            box-sizing: border-box;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            background: var(--primary-gradient);
            box-shadow: 0 4px 20px rgba(168, 85, 247, 0.3);
        }
        
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 24px rgba(168, 85, 247, 0.5);
            filter: brightness(1.1);
        }
    </style>
</head>
<body>

    <div class="sidebar">
        <c:choose>
            <c:when test="${currentUser.role eq 'ADMIN'}">
                <h1>🚗 UniVelo Admin</h1>
            </c:when>
            <c:otherwise>
                <h1>🔮 UniVelo</h1>
            </c:otherwise>
        </c:choose>
        
        <div class="profile-container">
            <c:choose>
                <c:when test="${not empty currentUser.profilePicPath}">
                    <img src="${pageContext.request.contextPath}/${currentUser.profilePicPath}" class="profile-img" alt="Avatar">
                </c:when>
                <c:otherwise>
                    <div class="avatar-placeholder">NO AVATAR</div>
                </c:otherwise>
            </c:choose>
            <h4 style="margin: 6px 0 0 0; font-size: 15px; font-weight: 700; color: var(--text-pure);"><c:out value="${currentUser.username}"/></h4>
            
            <div class="profile-phone">
                <span>📞</span> <c:out value="${currentUser.phone != null ? currentUser.phone : 'No Phone Logged'}"/>
            </div>
            
            <span class="status-badge ${currentUser.status}"><c:out value="${currentUser.status}"/></span>
        </div>

        <div class="sidebar-menu">
            <c:choose>
                <c:when test="${currentUser.role eq 'ADMIN'}">
                    <a href="AdminController?action=viewPending">⏳ Pending Approvals</a>
                    <a href="AdminController?action=viewAllUsers">👥 Master User Directory</a>
                    <a href="ComplaintController?action=viewComplaints">⚠️ Support Complaints View</a>
                </c:when>
                <c:when test="${currentUser.role eq 'DRIVER'}">
                    <a href="driver-dashboard.jsp">🚖 Driver Workspace</a>
                    <a href="${pageContext.request.contextPath}/ProfileController?action=edit" class="active">👤 Edit Profile Settings</a>
                    <a href="complaint-form.jsp">⚠️ File a New Complaint</a>
                    <a href="ComplaintController?action=viewMyComplaints">📋 View My Complaints History</a>
                </c:when>
                <c:otherwise>
                    <a href="passenger-dashboard.jsp">🚖 Ride Booking Portal</a>
                    <a href="${pageContext.request.contextPath}/ProfileController?action=edit" class="active">👤 Edit Profile Settings</a>
                    <a href="complaint-form.jsp">⚠️ File a New Complaint</a>
                    <a href="ComplaintController?action=viewMyComplaints">📋 View My Complaints History</a>
                </c:otherwise>
            </c:choose>
            
            <a href="${pageContext.request.contextPath}/AuthController?action=logout" class="logout-btn">🚪 Log Out</a>
        </div>
    </div>

    <div class="main-content">
        <h2>Profile Management</h2>
        <h3>Update security keys and visual identity configurations</h3>
        
        <%-- Status Notifications messages context logs --%>
        <c:if test="${param.status eq 'success'}">
            <div style="background-color: var(--success-glow); color: var(--success-text); border: 1px solid rgba(34, 197, 94, 0.25); padding: 14px 18px; margin-bottom: 25px; border-radius: 12px; font-size: 14px; max-width: 650px; box-sizing: border-box;">
                <strong>Success:</strong> Profile configurations updated securely.
            </div>
        </c:if>
        <c:if test="${param.status eq 'error'}">
            <div style="background-color: var(--danger-glow); color: var(--danger-text); border: 1px solid rgba(239, 68, 68, 0.25); padding: 14px 18px; margin-bottom: 25px; border-radius: 12px; font-size: 14px; max-width: 650px; box-sizing: border-box;">
                <strong>Error:</strong> Failed to validate or record updated structural values.
            </div>
        </c:if>

        <%-- Management Centralized Form Control --%>
        <div class="card">
            <form action="ProfileController" method="POST" enctype="multipart/form-data" style="margin: 0;">
                <input type="hidden" name="action" value="updateProfile">
                
                <div class="form-avatar-container">
                    <c:choose>
                        <c:when test="${not empty currentUser.profilePicPath}">
                            <img src="${pageContext.request.contextPath}/${currentUser.profilePicPath}" class="form-avatar-img" alt="User Profile Image">
                        </c:when>
                        <c:otherwise>
                            <div class="avatar-placeholder" style="width: 120px; height: 120px; line-height: 120px; font-size:14px; margin: 0 auto;">NO IMAGE</div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <label for="username">Update Nickname / Username:</label>
                <input type="text" id="username" name="username" value="<c:out value="${currentUser.username}"/>" required>

                <label for="phone">Contact Phone Line:</label>
                <input type="text" id="phone" name="phone" value="<c:out value="${currentUser.phone}"/>" placeholder="e.g., 01127240294" required>

                <label for="password">New Password (Leave blank to keep current):</label>
                <input type="password" id="password" name="password" placeholder="••••••••">

                <label for="profilePic">Modify Visual Display Identity Profile:</label>
                <input type="file" id="profilePic" name="profilePic" accept="image/*">

                <button type="submit" class="btn-submit">Commit Profile Configurations</button>
            </form>
        </div>
    </div>

</body>
</html>