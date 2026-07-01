<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@page import="com.univelo.dao.RideDAO, com.univelo.dao.NotificationDAO, com.univelo.model.Ride, com.univelo.model.User, java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) { 
        response.sendRedirect("index.jsp"); 
        return; 
    }
    RideDAO rideDao = new RideDAO();
    NotificationDAO notificationDao = new NotificationDAO();
    
    // Fetch live data metrics
    Ride ongoingRide = rideDao.getActiveDriverRide(currentUser.getId());
    request.setAttribute("ongoingRide", ongoingRide);
    
    List<Ride> availableBroadcasts = rideDao.getAvailableBroadcasts();
    request.setAttribute("broadcasts", availableBroadcasts);
    
    request.setAttribute("driverHistory", rideDao.getDriverHistory(currentUser.getId()));
    
    // Fetch live notifications directly into request state context
    request.setAttribute("unreadNotifications", notificationDao.getUnreadNotifications(currentUser.getId()));
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UniVelo - Driver Dashboard</title>
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
            --warning-glow: rgba(234, 179, 8, 0.15);
            --warning-text: #facc15;
            --info-glow: rgba(6, 182, 212, 0.15);
            --info-text: #22d3ee;
            --danger-glow: rgba(239, 68, 68, 0.15);
            --danger-text: #fca5a5;
            
            --btn-success-gradient: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
            --btn-info-gradient: linear-gradient(135deg, #06b6d4 0%, #0891b2 100%);
            --btn-active: rgba(168, 85, 247, 0.15);
        }

        body {
            font-family: 'Plus Jakarta Sans', 'Segoe UI', system-ui, -apple-system, sans-serif;
            /* Atmospheric multi-layer background blend */
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

        /* High Visibility Status Pill Badges */
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
        .status-badge.APPROVED, .status-badge.ACTIVE, .status-badge.ON_WAY { background-color: var(--success-glow); color: var(--success-text); border: 1px solid rgba(34, 197, 94, 0.3); }
        .status-badge.PENDING { background-color: var(--warning-glow); color: var(--warning-text); border: 1px solid rgba(234, 179, 8, 0.3); }
        .status-badge.REJECTED { background-color: var(--danger-glow); color: var(--danger-text); border: 1px solid rgba(239, 68, 68, 0.3); }

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
            color: var(--text-pure);
            font-size: 1.2rem;
            font-weight: 700;
            margin-top: 0;
            margin-bottom: 1.5rem;
            letter-spacing: -0.3px;
        }

        /* --- GLASSMORPHIC LAYERED CONTAINER CARDS --- */
        .card {
            background: var(--card-glass);
            backdrop-filter: blur(24px);
            -webkit-backdrop-filter: blur(24px);
            padding: 2.2rem;
            border-radius: 20px;
            border: 1px solid var(--border-glow);
            margin-bottom: 30px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5),
                        0 0 25px 0 rgba(168, 85, 247, 0.03);
        }

        /* --- INPUT FORMS LOGIC --- */
        form label {
            display: block;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: var(--text-secondary);
            margin-bottom: 0.8rem;
            font-weight: 700;
        }

        form input[type="text"], form input[type="number"] {
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

        form input:focus {
            border-color: var(--primary-interactive);
            background-color: rgba(31, 26, 51, 0.9);
            box-shadow: 0 0 15px rgba(168, 85, 247, 0.15);
        }

        form input[type="text"]::placeholder, form input[type="number"]::placeholder {
            color: rgba(255, 255, 255, 0.25);
        }

        /* --- DATATABLE ARCHITECTURE --- */
        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            background: rgba(15, 12, 26, 0.4);
            border-radius: 16px;
            overflow: hidden;
            border: 1px solid rgba(255, 255, 255, 0.05);
            margin-top: 15px;
        }

        th, td {
            padding: 18px 20px;
            text-align: left;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
            font-size: 14px;
            vertical-align: middle;
        }

        th {
            background-color: rgba(30, 24, 51, 0.85);
            font-weight: 700;
            color: var(--text-pure);
            text-transform: uppercase;
            font-size: 11px;
            letter-spacing: 1px;
            border-bottom: 1px solid var(--border-glow);
        }

        tr:last-child td {
            border-bottom: none;
        }

        tr:hover td {
            background-color: rgba(168, 85, 247, 0.03);
        }

        /* Action Buttons Core System */
        .btn-submit, .btn-quote {
            display: block;
            text-align: center;
            color: white;
            border: none;
            padding: 14px 20px;
            border-radius: 12px;
            cursor: pointer;
            font-weight: 700;
            font-size: 14px;
            text-decoration: none;
            box-sizing: border-box;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .btn-submit {
            width: 100%;
            background: var(--btn-success-gradient);
            box-shadow: 0 4px 14px rgba(34, 197, 94, 0.2);
        }
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(34, 197, 94, 0.45);
            filter: brightness(1.1);
        }

        .btn-quote {
            width: auto;
            background: var(--btn-info-gradient);
            box-shadow: 0 4px 14px rgba(6, 182, 212, 0.2);
            padding: 10px 20px;
        }
        .btn-quote:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 18px rgba(6, 182, 212, 0.4);
            filter: brightness(1.1);
        }

        /* --- ALERTS & NOTIFICATIONS DESIGN SYSTEM --- */
        .alert-banner {
            padding: 22px;
            border-radius: 14px;
            margin-top: 15px;
            font-size: 14px;
            line-height: 1.6;
            border: 1px solid transparent;
        }

        .alert-banner.priced {
            background-color: var(--warning-glow);
            color: var(--warning-text);
            border: 1px solid rgba(234, 179, 8, 0.25);
            border-left: 4px solid #eab308;
        }

        .alert-banner.on-way {
            background-color: var(--success-glow);
            color: var(--success-text);
            border: 1px solid rgba(34, 197, 94, 0.25);
            border-left: 4px solid #22c55e;
        }

        .notif-item {
            background: rgba(30, 24, 51, 0.4);
            border-left: 4px solid var(--primary-glow); 
            padding: 16px; 
            margin-bottom: 12px; 
            border-radius: 12px; 
            display: flex; 
            justify-content: space-between; 
            align-items: center;
            border-top: 1px solid rgba(255,255,255,0.02);
            border-right: 1px solid rgba(255,255,255,0.02);
            border-bottom: 1px solid rgba(255,255,255,0.02);
        }

        .btn-dismiss {
            color: var(--text-secondary); 
            text-decoration: none; 
            font-weight: 700; 
            padding: 8px 12px; 
            background: rgba(255, 255, 255, 0.03);
            border-radius: 8px;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border: 1px solid rgba(255, 255, 255, 0.05);
            transition: all 0.2s ease;
            cursor: pointer;
        }
        .btn-dismiss:hover {
            color: #ef4444;
            background: rgba(239, 68, 68, 0.1);
            border-color: rgba(239, 68, 68, 0.2);
        }

        hr {
            border: 0;
            height: 1px;
            background: rgba(255, 255, 255, 0.08);
            margin: 2.2rem 0;
        }

        .sync-link {
            text-decoration: none;
            font-weight: 700;
            color: var(--primary-interactive);
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 16px;
            background: rgba(168, 85, 247, 0.05);
            border: 1px solid rgba(168, 85, 247, 0.2);
            border-radius: 8px;
            transition: all 0.2s ease;
        }
        .sync-link:hover {
            background: rgba(168, 85, 247, 0.15);
            border-color: rgba(168, 85, 247, 0.4);
            transform: translateY(-1px);
        }
        
        .sync-container-above {
            display: flex;
            justify-content: flex-end;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>

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
            <h4 style="margin: 6px 0; font-size: 15px; font-weight: 700; color: var(--text-pure);"><c:out value="${currentUser.username}"/></h4>
            <p style="color: var(--text-secondary); margin: 4px 0 8px 0; font-size: 13px; font-weight: 500;">📞 ${currentUser.phone}</p>
            <span class="status-badge ${currentUser.status}"><c:out value="${currentUser.status}"/></span>
        </div>

        <div class="sidebar-menu">
            <a href="driver-dashboard.jsp" class="active">🚖 Driver Workspace</a>
            <a href="${pageContext.request.contextPath}/ProfileController?action=edit">👤 Edit Profile Settings</a>
            <a href="complaint-form.jsp">⚠️ File a New Complaint</a>
            <a href="ComplaintController?action=viewMyComplaints">📋 View My Complaints History</a>
            
            <a href="${pageContext.request.contextPath}/AuthController?action=logout" style="color: #fca5a5; margin-top: auto;">🚪 Log Out</a>
        </div>
    </div>

    <div class="main-content">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2.2rem;">
            <h2>UiTM Driver Control Center</h2>
            <a href="driver-dashboard.jsp" class="sync-link">🔄 Refresh Broadcast Feeds</a>
        </div>

        <%-- Dynamic System Message Feedback --%>
        <% 
            String msg = request.getParameter("msg");
            if("complaintSuccess".equals(msg)) { 
        %>
            <div style="background-color: var(--success-glow); color: var(--success-text); border: 1px solid rgba(34, 197, 94, 0.25); padding: 14px 18px; margin-bottom: 25px; border-radius: 12px; font-size: 14px;">
                <strong>Success:</strong> Your report has been submitted to management logs for tracking and assessment.
            </div>
        <% } else if("rideCompleted".equals(msg)) { %>
            <div style="background-color: var(--success-glow); color: var(--success-text); border: 1px solid rgba(34, 197, 94, 0.25); padding: 14px 18px; margin-bottom: 25px; border-radius: 12px; font-size: 14px;">
                <strong>Operation Completed:</strong> The ride request has been archived and logged successfully into accounting history.
            </div>
        <% } else if("complaintFailed".equals(msg)) { %>
            <div style="background-color: var(--danger-glow); color: var(--danger-text); border: 1px solid rgba(239, 68, 68, 0.25); padding: 14px 18px; margin-bottom: 25px; border-radius: 12px; font-size: 14px;">
                <strong>System Error:</strong> Unable to process the complaint entry. Please try again.
            </div>
        <% } %>

        <%-- LIVE SYSTEM ALERTS & NOTIFICATIONS CONTAINER --%>
        <div class="card">
            <h3>🔔 Live Updates & System Alerts</h3>
            <c:choose>
                <c:when test="${not empty unreadNotifications}">
                    <div style="margin-top: 15px;">
                        <c:forEach var="notif" items="${unreadNotifications}">
                            <div class="notif-item">
                                <div>
                                    <strong style="color: var(--primary-interactive); font-size: 14px;"><c:out value="${notif.title}"/></strong>
                                    <p style="margin: 5px 0 0 0; font-size: 13px; color: var(--text-primary);"><c:out value="${notif.message}"/></p>
                                </div>
                                <form action="NotificationController" method="POST" style="margin: 0;">
                                    <input type="hidden" name="action" value="dismiss">
                                    <input type="hidden" name="id" value="${notif.id}">
                                    <button type="submit" class="btn-dismiss">✕ Dismiss</button>
                                </form>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <p style="color: var(--text-secondary); font-size: 14px; margin: 0; font-style: italic;">No new notifications or platform updates discovered at this time.</p>
                </c:otherwise>
            </c:choose>
        </div>

        <%-- REFRESH SYNC CONTROL UTILITY BUTTON --%>
        <div class="sync-container-above">
            <a href="driver-dashboard.jsp" class="sync-link">🔄 Refresh Ride Status</a>
        </div>

        <%-- ASSIGNED OPERATIONAL WORK CARD --%>
        <div class="card">
            <h3>Ongoing Assigned Operations</h3>
            
            <c:choose>
                <c:when test="${empty ongoingRide}">
                    <p style="color: var(--text-secondary); font-size: 14px; margin: 0; font-style: italic;">You have no active running rides assigned right now.</p>
                </c:when>
                
                <c:when test="${ongoingRide.status eq 'PRICED'}">
                    <div class="alert-banner priced">
                        <h4 style="color: var(--warning-text); font-size: 1.1rem; font-weight: 700; margin-top: 0; margin-bottom: 0.6rem;">⏳ Offer Provisionally Accepted! Input Vehicle Details</h4>
                        <p style="margin-bottom: 1.5rem; color: var(--text-primary);">The passenger has conditionally accepted your price quote of <strong>RM ${ongoingRide.price}</strong>. Fill in your car deployment particulars below to start the tracking session:</p>
                        
                        <form action="RideController" method="POST" style="margin: 0;">
                            <input type="hidden" name="action" value="submitVehicleInfo">
                            <input type="hidden" name="rideId" value="${ongoingRide.id}">
                            
                            <label>Car Model</label>
                            <input type="text" name="carModel" placeholder="e.g., Proton Saga" required>
                            
                            <label>Car Color</label>
                            <input type="text" name="carColor" placeholder="e.g., Metallic Black" required>
                            
                            <label>Plate Number</label>
                            <input type="text" name="numberPlate" placeholder="e.g., VBL 8432" required>
                            
                            <button type="submit" class="btn-submit">Confirm & Disembark</button>
                        </form>
                    </div>
                </c:when>
                
                <c:when test="${ongoingRide.status eq 'ON_WAY'}">
                    <div class="alert-banner on-way">
                        <h4 style="color: var(--success-text); font-size: 1.1rem; font-weight: 700; margin-top: 0; margin-bottom: 0.8rem;">🚀 Ride In Progress</h4>
                        <div style="background: rgba(0,0,0,0.15); padding: 16px; border-radius: 12px; display: flex; flex-direction: column; gap: 8px; margin-bottom: 1.5rem;">
                            <p style="margin: 0; font-size: 14px; color: var(--text-primary);"><strong>Passenger Name:</strong> ${ongoingRide.passengerName}</p>
                            <p style="margin: 0; font-size: 14px; color: var(--text-primary);"><strong>Contact Line:</strong> <a href="tel:${ongoingRide.passengerPhone}" style="color: var(--success-text); font-weight:700; text-decoration: underline;">${ongoingRide.passengerPhone}</a></p>
                            <p style="margin: 0; font-size: 14px; color: var(--text-primary);"><strong>Route Specifications:</strong> <span style="color: var(--text-pure); font-weight: 600;">${ongoingRide.pickupLocation} ➡️ ${ongoingRide.dropoffLocation}</span></p>
                            <p style="margin: 0; font-size: 14px; color: var(--text-primary);"><strong>Fare Value:</strong> <span style="color: var(--success-text); font-weight: 700;">RM ${ongoingRide.price}</span></p>
                        </div>
                        
                        <form action="RideController" method="POST" style="margin:0;">
                            <input type="hidden" name="action" value="completeRide">
                            <input type="hidden" name="rideId" value="${ongoingRide.id}">
                            <button type="submit" class="btn-submit">🏁 Complete Ride & Collect Fare</button>
                        </form>
                    </div>
                </c:when>
            </c:choose>
        </div>

        <%-- CONDITIONAL DRIVER STREAM BROADCAST FEEDS --%>
        <c:if test="${empty ongoingRide}">
            <div class="card">
                <h3>📡 Available Broadcast Stream (UiTM Shah Alam)</h3>
                <c:choose>
                    <c:when test="${empty broadcasts}">
                        <p style="color: var(--text-secondary); font-size: 14px; margin: 0; font-style: italic;">No student requests are broadcasting on the system feed right now.</p>
                    </c:when>
                    <c:otherwise>
                        <table>
                            <thead>
                                <tr>
                                    <th>Passenger</th>
                                    <th>Pickup Location</th>
                                    <th>Dropoff Target</th>
                                    <th style="text-align: right; padding-right: 40px;">Propose Price Offer</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${broadcasts}" var="b">
                                    <tr>
                                        <td><strong style="color: var(--text-pure); font-size: 15px;">${b.passengerName}</strong></td>
                                        <td>${b.pickupLocation}</td>
                                        <td>${b.dropoffLocation}</td>
                                        <td style="text-align: right;">
                                            <form action="RideController" method="POST" style="margin:0; display: inline-flex; gap: 8px; align-items: center; justify-content: flex-end;">
                                                <input type="hidden" name="action" value="offerPrice">
                                                <input type="hidden" name="rideId" value="${b.id}">
                                                <span style="font-size: 14px; font-weight: 700; color: var(--text-secondary);">RM</span> 
                                                <input type="number" step="0.01" name="price" placeholder="10.00" required style="width: 90px; margin-bottom: 0; padding: 8px 12px; height: 38px; border-radius: 8px;">
                                                <button type="submit" class="btn-quote">Quote</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <%-- HISTORICAL METRICS AND REVENUE TABLES LOG --%>
        <div class="card">
            <h3>Completed Trips History Logs</h3>
            <table>
                <thead>
                    <tr>
                        <th style="width: 15%;">Trip ID</th>
                        <th style="width: 25%;">Passenger Name</th>
                        <th style="width: 40%;">Route Plan</th>
                        <th style="width: 20%;">Revenue Collected</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${driverHistory}" var="dh">
                        <tr>
                            <td><span style="font-weight: 700; color: var(--primary-interactive);"># ${dh.id}</span></td>
                            <td><strong style="color: var(--text-pure); font-size: 15px;">${dh.passengerName}</strong></td>
                            <td style="color: var(--text-primary);">${dh.pickupLocation} <span style="color:var(--text-secondary);">to</span> ${dh.dropoffLocation}</td>
                            <td><strong style="color: var(--success-text); font-size: 15px;">RM ${dh.price}</strong></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty driverHistory}">
                        <tr>
                            <td colspan="4" style="text-align: center; color: var(--text-secondary); padding: 45px; font-size: 14px; font-style: italic;">
                                No completed logs found in your trip log history.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

</body>
</html>