<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="com.univelo.model.User" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) { 
        response.sendRedirect("index.jsp"); 
        return; 
    }
    boolean isPassenger = "PASSENGER".equalsIgnoreCase(currentUser.getRole());
    pageContext.setAttribute("isPassenger", isPassenger);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UniVelo - File a New Complaint</title>
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
            --success-glow: rgba(34, 197, 94, 0.15);
            --success-text: #4ade80;
            --warning-glow: rgba(234, 179, 8, 0.15);
            --warning-text: #facc15;
            --btn-active: rgba(168, 85, 247, 0.15);

            /* Interactive role-based feedback behaviors */
            --passenger-gradient: linear-gradient(135deg, #a855f7 0%, #7c3aed 100%);
            --passenger-hover: #9333ea;
            --driver-gradient: linear-gradient(135deg, #22c55e 0%, #15803d 100%);
            --driver-hover: #16a34a;
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

        /* High Visibility Status Pill Badge */
        .status-badge {
            padding: 6px 14px;
            border-radius: 20px;
            font-weight: 700;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            display: inline-flex;
            align-items: center;
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

        /* --- COMPLAINT GLASS CARD ARCHITECTURE --- */
        .card {
            background: var(--card-glass);
            backdrop-filter: blur(24px);
            -webkit-backdrop-filter: blur(24px);
            padding: 3rem 2.5rem;
            border-radius: 20px;
            border: 1px solid var(--border-glow);
            margin-bottom: 30px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5),
                        0 0 25px 0 rgba(168, 85, 247, 0.03);
            width: 100%;
            max-width: 650px;
            box-sizing: border-box;
        }

        /* --- INPUT FORMS SYSTEM --- */
        .form-group {
            margin-bottom: 1.75rem;
            position: relative;
        }

        .form-group label {
            display: block;
            font-size: 13px;
            color: var(--text-secondary);
            margin-bottom: 0.8rem;
            font-weight: 600;
        }

        select, textarea {
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
            font-family: inherit;
        }

        select:focus, textarea:focus {
            border-color: var(--primary-interactive);
            background-color: rgba(31, 26, 51, 0.9);
            box-shadow: 0 0 15px rgba(168, 85, 247, 0.15);
        }

        textarea {
            resize: none;
        }

        /* Styled select dropdown styling helper */
        select option {
            background-color: #161224;
            color: var(--text-primary);
        }

        .char-counter {
            text-align: right;
            font-size: 11px;
            color: var(--text-secondary);
            margin-top: 8px;
            display: block;
            font-weight: 500;
        }

        /* --- ACTION CONTAINER ELEMENTS --- */
        .btn-container {
            display: flex;
            gap: 16px;
            margin-top: 2.2rem;
        }

        .btn-submit {
            flex: 1;
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
        }

        .btn-submit:hover {
            transform: translateY(-2px);
        }
        
        .btn-PASSENGER {
            background: var(--passenger-gradient);
            box-shadow: 0 4px 20px rgba(168, 85, 247, 0.3);
        }
        .btn-PASSENGER:hover {
            box-shadow: 0 6px 24px rgba(168, 85, 247, 0.5);
            filter: brightness(1.1);
        }

        .btn-DRIVER {
            background: var(--driver-gradient);
            box-shadow: 0 4px 20px rgba(34, 197, 94, 0.3);
        }
        .btn-DRIVER:hover {
            box-shadow: 0 6px 24px rgba(34, 197, 94, 0.5);
            filter: brightness(1.1);
        }
        
        .btn-cancel {
            flex: 1;
            text-align: center;
            background-color: rgba(39, 39, 42, 0.6);
            backdrop-filter: blur(5px);
            color: #d1d5db;
            padding: 16px;
            text-decoration: none;
            border-radius: 12px;
            font-weight: 700;
            font-size: 15px;
            box-sizing: border-box;
            transition: all 0.3s ease;
            border: 1px solid rgba(255, 255, 255, 0.08);
            display: flex;
            justify-content: center;
            align-items: center;
        }
        
        .btn-cancel:hover {
            background-color: rgba(63, 63, 70, 0.8);
            color: var(--text-pure);
            border-color: var(--text-secondary);
        }
    </style>
</head>
<body>

    <!-- Left Dashboard Sidebar Navigation Shell -->
    <div class="sidebar">
        <h1>🔮 UniVelo</h1>
        
        <div class="profile-container">
            <c:choose>
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
                <c:when test="${currentUser.role eq 'DRIVER'}">
                    <a href="driver-dashboard.jsp">🚖 Driver Workspace</a>
                </c:when>
                <c:otherwise>
                    <a href="passenger-dashboard.jsp">🚖 Ride Booking Portal</a>
                </c:otherwise>
            </c:choose>
            <a href="${pageContext.request.contextPath}/ProfileController?action=edit">👤 Edit Profile Settings</a>
            <a href="complaint-form.jsp" class="active">⚠️ File a New Complaint</a>
            <a href="ComplaintController?action=viewMyComplaints">📋 View My Complaints History</a>
            
            <a href="${pageContext.request.contextPath}/AuthController?action=logout" style="color: #fca5a5; margin-top: auto;">🚪 Log Out</a>
        </div>
    </div>

    <!-- Main Workspace Content Terminal -->
    <div class="main-content">
        <h2><%= isPassenger ? "Report an Issue / Driver" : "Report Passenger / App Issue" %></h2>
        <div class="subtitle-desc">Your report will be forwarded to administration management logs for immediate safety assessment.</div>

        <%-- Management Centralized Form Card Control --%>
        <div class="card">
            <form action="ComplaintController" method="POST" style="margin: 0;">
                <input type="hidden" name="action" value="submitComplaint">
                
                <div class="form-group">
                    <label for="complaintType">Issue Category:</label>
                    <select id="complaintType" name="complaintType" required>
                        <option value="" disabled selected>Select issue type...</option>
                        <% if (isPassenger) { %>
                            <option value="Driver Conduct">Driver Misconduct / Aggressive Driving</option>
                            <option value="Billing Discrepancy">Incorrect Price Overcharge</option>
                            <option value="App System Glitch">Technical Issue / App Bug</option>
                            <option value="Other">Other Reasons</option>
                        <% } else { %>
                            <option value="Passenger Misbehavior">Passenger Misbehavior / Rude Conduct</option>
                            <option value="No Show">Passenger No-Show / Cancellation Abuse</option>
                            <option value="Payment Dispute">Cash Collection / Fare Dispute</option>
                            <option value="App Issue">GPS routing / Application Bug</option>
                            <option value="Other">Other Administrative Issues</option>
                        <% } %>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="description">Detailed Description:</label>
                    <textarea id="description" name="description" rows="6" placeholder="Provide clear particulars regarding what transpired..." maxlength="1000" required></textarea>
                    <small class="char-counter"><span id="charCount">0</span> / 1000 characters</small>
                </div>
                
                <div class="btn-container">
                    <button type="submit" class="btn-submit btn-${currentUser.role}">Submit Official Report</button>
                    
                    <c:choose>
                        <c:when test="${currentUser.role eq 'DRIVER'}">
                            <a href="driver-dashboard.jsp" class="btn-cancel">Cancel</a>
                        </c:when>
                        <c:otherwise>
                            <a href="passenger-dashboard.jsp" class="btn-cancel">Cancel</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </form>
        </div>
    </div>

    <!-- Real-time dynamic description counter -->
    <script>
        const textarea = document.getElementById('description');
        const charCount = document.getElementById('charCount');

        textarea.addEventListener('input', () => {
            charCount.textContent = textarea.value.length;
        });
    </script>
</body>
</html>