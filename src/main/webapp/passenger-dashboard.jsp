<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@page import="com.univelo.dao.RideDAO, com.univelo.dao.NotificationDAO, com.univelo.model.Ride, com.univelo.model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) { 
        response.sendRedirect("index.jsp"); 
        return; 
    }
    
    // 🛡️ ROLE GUARD AUTHENTICATION SYSTEM
    if (currentUser.getRole() == null || !"PASSENGER".equalsIgnoreCase(currentUser.getRole())) {
        response.sendRedirect("driver-dashboard.jsp");
        return;
    }

    RideDAO rideDao = new RideDAO();
    NotificationDAO notificationDao = new NotificationDAO();
    
    Ride activeRide = rideDao.getActivePassengerRide(currentUser.getId());
    request.setAttribute("activeRide", activeRide);
    request.setAttribute("history", rideDao.getPassengerHistory(currentUser.getId()));
    
    // Fetch live notifications directly onto dashboard requests state context
    request.setAttribute("unreadNotifications", notificationDao.getUnreadNotifications(currentUser.getId()));
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UniVelo - Passenger Dashboard</title>
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
            --table-header-bg: #1e1833;
            
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
            --btn-danger-gradient: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
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

        .subtitle-desc {
            color: var(--text-secondary);
            font-size: 1.05rem;
            font-weight: 500;
            margin-top: 0;
            margin-bottom: 2.5rem;
            letter-spacing: 0.5px;
            text-transform: uppercase;
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
        .status-badge.PRICED { background-color: var(--info-glow); color: var(--info-text); border: 1px solid rgba(6, 182, 212, 0.3); }

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

        form input[type="text"] {
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

        form input[type="text"]:focus {
            border-color: var(--primary-interactive);
            background-color: rgba(31, 26, 51, 0.9);
            box-shadow: 0 0 15px rgba(168, 85, 247, 0.15);
        }

        form input[type="text"]::placeholder {
            color: rgba(255, 255, 255, 0.25);
        }

        /* Action Component Buttons */
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

        .btn-action-green {
            background: var(--btn-success-gradient);
            color: var(--text-pure);
            border: none;
            padding: 11px 22px;
            border-radius: 10px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 700;
            transition: all 0.2s ease;
            box-shadow: 0 4px 14px rgba(34, 197, 94, 0.2);
        }

        .btn-action-green:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 18px rgba(34, 197, 94, 0.35);
        }

        .btn-action-red {
            background: var(--btn-danger-gradient);
            color: var(--text-pure);
            border: none;
            padding: 11px 22px;
            border-radius: 10px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 700;
            transition: all 0.2s ease;
            box-shadow: 0 4px 14px rgba(239, 68, 68, 0.2);
        }

        .btn-action-red:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 18px rgba(239, 68, 68, 0.35);
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
        
        .alert-banner.pending {
            background-color: var(--warning-glow);
            color: var(--warning-text);
            border: 1px solid rgba(234, 179, 8, 0.25);
            border-left: 4px solid #eab308;
        }

        .alert-banner.priced {
            background-color: var(--info-glow);
            color: var(--info-text);
            border: 1px solid rgba(6, 182, 212, 0.25);
            border-left: 4px solid #06b6d4;
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
        }
        .btn-dismiss:hover {
            color: #ef4444;
            background: rgba(239, 68, 68, 0.1);
            border-color: rgba(239, 68, 68, 0.2);
        }

        /* Structural Divider Elements */
        hr {
            border: 0;
            height: 1px;
            background: rgba(255, 255, 255, 0.08);
            margin: 2.2rem 0;
        }

        /* Header Alignment Utilities */
        .section-title-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }
        .section-title-row h3 { margin-bottom: 0; }

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
            <span class="status-badge ${currentUser.status}"><c:out value="${currentUser.status}"/></span>
        </div>

        <div class="sidebar-menu">
            <a href="passenger-dashboard.jsp" class="active">🚖 Ride Booking Portal</a>
            <a href="${pageContext.request.contextPath}/ProfileController?action=edit">👤 Edit Profile Settings</a>
            <a href="complaint-form.jsp">⚠️ File a New Complaint</a>
            <a href="ComplaintController?action=viewMyComplaints">📋 View My Complaints History</a>
            
            <a href="${pageContext.request.contextPath}/AuthController?action=logout" style="color: #fca5a5; margin-top: auto;">🚪 Log Out</a>
        </div>
    </div>

    <div class="main-content">
        <h2>UiTM Ride Booking Portal</h2>
        <div class="subtitle-desc">Track statuses and manage real-time transport options</div>
        
        <%-- System Session Messaging Alerts --%>
        <% 
            String msg = request.getParameter("msg");
            if("complaintSuccess".equals(msg)) { 
        %>
            <div style="background-color: var(--success-glow); color: var(--success-text); border: 1px solid rgba(34, 197, 94, 0.25); padding: 14px 18px; margin-bottom: 25px; border-radius: 12px; font-size: 14px;">
                <strong>Success:</strong> Your report has been submitted to management logs for tracking and assessment.
            </div>
        <% } else if("complaintFailed".equals(msg)) { %>
            <div style="background-color: var(--danger-glow); color: var(--danger-text); border: 1px solid rgba(239, 68, 68, 0.25); padding: 14px 18px; margin-bottom: 25px; border-radius: 12px; font-size: 14px;">
                <strong>System Error:</strong> Unable to process the complaint entry. Please try again.
            </div>
        <% } else if("rideComplete".equals(msg) || "rideCompleted".equals(msg)) { %>
            <div style="background-color: var(--success-glow); color: var(--success-text); border: 1px solid rgba(34, 197, 94, 0.25); padding: 14px 18px; margin-bottom: 25px; border-radius: 12px; font-size: 14px;">
                <strong>Operation Completed:</strong> The ride request has been archived and logged successfully into accounting history.
            </div>
        <% } %>

        <%-- Live System Alerts / Notifications Container Card --%>
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
        
        <%-- Monitoring / Ride Request Activity Container Card --%>
        <div class="card">
            <div class="section-title-row">
                <h3>Current Ride Activity Status</h3>
                <a href="passenger-dashboard.jsp" class="sync-link">🔄 Sync Live Monitor</a>
            </div>
            
            <c:choose>
                <c:when test="${empty activeRide}">
                    <p style="color: var(--text-secondary); font-size: 14px; margin-bottom: 2rem; font-style: italic;">No active trip requests running currently.</p>
                    <hr>
                    <h4 style="font-size: 11px; color: var(--text-secondary); margin-bottom: 1.5rem; text-transform: uppercase; letter-spacing: 1px; font-weight: 700;">Request a New Ride (UiTM Shah Alam)</h4>
                    <form action="RideController" method="POST" style="margin-bottom:0;">
                        <input type="hidden" name="action" value="requestRide">
                        
                        <label>Pickup Location</label>
                        <input type="text" name="pickupLocation" placeholder="e.g., Kolej Jati" required>
                        
                        <label>Dropoff Destination</label>
                        <input type="text" name="dropoffLocation" placeholder="e.g., FSKM Building" required>
                        
                        <button type="submit" class="btn-submit">Broadcast Request to Drivers</button>
                    </form>
                </c:when>

                <c:when test="${activeRide.status eq 'PENDING'}">
                    <div class="alert-banner pending">
                        <strong style="font-size:15px;">📡 Broadcasting Request...</strong><br>
                        <span style="display:inline-block; margin-top:4px;">Waiting for available student drivers to see your request and calculate a quote.</span>
                        <p style="margin: 12px 0 0 0; font-size: 13px; color: var(--text-primary); background: rgba(0,0,0,0.15); padding: 10px 14px; border-radius: 8px;">
                            <strong>Route Plan:</strong> <c:out value="${activeRide.pickupLocation}"/> ➡️ <c:out value="${activeRide.dropoffLocation}"/>
                        </p>
                    </div>
                </c:when>

                <c:when test="${activeRide.status eq 'PRICED'}">
                    <c:choose>
                        <c:when test="${sessionScope.pendingAcceptRideId eq activeRide.id}">
                            <div class="alert-banner priced" style="border-left: 4px solid #eab308; background-color: var(--warning-glow); color: var(--warning-text);">
                                <h4 style="margin-top:0; color: var(--warning-text); font-size: 1.1rem; font-weight:700;">⏳ Price Match Confirmed!</h4>
                                <p>You accepted the offer of <strong>RM <c:out value="${activeRide.price}"/></strong> from <strong><c:out value="${activeRide.driverName}"/></strong>.</p>
                                <p style="margin: 0; font-size: 13px; color: var(--text-primary);">
                                    <strong>Status:</strong> Awaiting driver to submit vehicle specifications and disembark...
                                </p>
                            </div>
                        </c:when>
                        
                        <c:otherwise>
                            <div class="alert-banner priced">
                                <h4 style="margin-top:0; color: var(--info-text); font-size: 1.1rem; font-weight:700;">💰 Fare Counter-Offer Received!</h4>
                                <p>Driver <strong style="color: var(--text-pure);"><c:out value="${activeRide.driverName}"/></strong> has offered a ride rate of <strong style="color: var(--text-pure); background: rgba(6, 182, 212, 0.2); padding: 2px 6px; border-radius: 4px;">RM <c:out value="${activeRide.price}"/></strong>.</p>
                                
                                <div style="display: flex; gap: 12px; margin-top: 15px;">
                                    <form action="RideController" method="POST" style="margin: 0;">
                                        <input type="hidden" name="action" value="handleOffer">
                                        <input type="hidden" name="rideId" value="${activeRide.id}">
                                        <input type="hidden" name="decision" value="accept">
                                        <button type="submit" class="btn-action-green">Accept Price</button>
                                    </form>
                                    <form action="RideController" method="POST" style="margin: 0;">
                                        <input type="hidden" name="action" value="handleOffer">
                                        <input type="hidden" name="rideId" value="${activeRide.id}">
                                        <input type="hidden" name="decision" value="reject">
                                        <button type="submit" class="btn-action-red">Reject & Re-Broadcast</button>
                                    </form>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </c:when>

                <c:when test="${activeRide.status eq 'ON_WAY'}">
                    <div class="alert-banner on-way">
                        <h4 style="margin-top:0; color: var(--success-text); font-size: 1.1rem; font-weight:700;">🚖 Driver is on the way!</h4>
                        <p style="margin: 5px 0;"><strong>Route Path:</strong> <c:out value="${activeRide.pickupLocation}"/> ➡️ <c:out value="${activeRide.dropoffLocation}"/></p>
                        <p style="margin: 5px 0;"><strong>Total Price Charged:</strong> RM <c:out value="${activeRide.price}"/></p>
                        <hr style="border-top:1px solid rgba(34, 197, 94, 0.15); margin: 15px 0;">
                        <h5 style="margin: 0 0 10px 0; color: var(--text-pure); font-size: 0.95rem; font-weight:700; text-transform:uppercase; letter-spacing:0.5px;">Driver Logistics Profile</h5>
                        <div style="background: rgba(0,0,0,0.15); padding: 14px; border-radius: 10px; display:flex; flex-direction:column; gap:6px;">
                            <p style="margin:0; font-size:13px; color: var(--text-primary);"><strong>Driver Name:</strong> <c:out value="${activeRide.driverName}"/></p>
                            <p style="margin:0; font-size:13px; color: var(--text-primary);"><strong>Phone Contact:</strong> <a href="tel:${activeRide.driverPhone}" style="color: var(--success-text); font-weight:700; text-decoration: underline;"><c:out value="${activeRide.driverPhone}"/></a></p>
                            <p style="margin:0; font-size:13px; color: var(--text-primary);"><strong>Car Description:</strong> <span style="color:var(--text-pure); font-weight:600;"><c:out value="${activeRide.carColor}"/> <c:out value="${activeRide.carModel}"/></span> [<c:out value="${activeRide.numberPlate}"/>]</p>
                        </div>
                    </div>
                </c:when>
            </c:choose>
        </div>

        <%-- Completed Trips Architecture Table Logs --%>
        <div class="card">
            <h3>Completed Trips Logs</h3>
            <table>
                <thead>
                    <tr>
                        <th style="width: 15%;">Trip ID</th>
                        <th style="width: 25%;">Driver</th>
                        <th style="width: 40%;">Route Specifications</th>
                        <th style="width: 20%;">Price Paid</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${history}" var="h">
                        <tr>
                            <td><span style="font-weight: 700; color: var(--primary-interactive);"># <c:out value="${h.id}"/></span></td>
                            <td><strong style="color: var(--text-pure); font-size:15px;"><c:out value="${h.driverName}"/></strong></td>
                            <td style="color: var(--text-primary);"><c:out value="${h.pickupLocation}"/> <span style="color:var(--text-secondary);">to</span> <c:out value="${h.dropoffLocation}"/></td>
                            <td><strong style="color: var(--success-text); font-size:15px;">RM <c:out value="${h.price}"/></strong></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty history}">
                        <tr>
                            <td colspan="4" style="text-align: center; color: var(--text-secondary); padding: 45px; font-size:15px;">
                                <span style="font-size: 24px; display: block; margin-bottom: 10px;">🎉</span>
                                No historical data entries discovered.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

</body>
</html>