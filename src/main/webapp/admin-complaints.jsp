<%@taglib prefix="c" uri="jakarta.tags.core"%> <%-- Import loop and conditional tags --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%> <%-- Set page type and encoding --%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - User Complaints Feed</title>
    <style>
        /* --- CSS Theme Variables --- */
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
            --success-glow: rgba(34, 197, 94, 0.15);
            --success-text: #4ade80;
            --warning-glow: rgba(234, 179, 8, 0.15);
            --warning-text: #facc15;
            --btn-success-gradient: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
            --btn-active: rgba(168, 85, 247, 0.15);
        }

        /* --- Global Layout Styles --- */
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

        /* --- Sidebar Styles --- */
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
            margin-bottom: 40px;
            letter-spacing: -1px;
            background: linear-gradient(to right, #ffffff, #d8b4fe);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            display: flex;
            align-items: center;
            gap: 12px;
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

        /* --- Main Layout Grid --- */
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

        /* --- Table Component Styles --- */
        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            background: var(--card-glass);
            backdrop-filter: blur(24px);
            -webkit-backdrop-filter: blur(24px);
            margin-top: 15px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.6),
                        0 0 25px 0 rgba(168, 85, 247, 0.05);
            border-radius: 20px;
            overflow: hidden;
            border: 1px solid var(--border-glow);
        }

        th, td {
            padding: 18px 20px;
            text-align: left;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
            font-size: 14px;
            vertical-align: top;
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
            background-color: rgba(168, 85, 247, 0.04);
        }

        /* --- Status Pill Badges --- */
        .status {
            padding: 6px 14px;
            border-radius: 20px;
            font-weight: 700;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            display: inline-flex;
            align-items: center;
        }

        .PENDING { background-color: var(--warning-glow); color: var(--warning-text); border: 1px solid rgba(234, 179, 8, 0.3); }
        .RESOLVED { background-color: var(--success-glow); color: var(--success-text); border: 1px solid rgba(34, 197, 94, 0.3); }

        /* --- Input Action Elements --- */
        textarea {
            width: 100%;
            background-color: var(--input-bg);
            backdrop-filter: blur(5px);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 12px;
            color: var(--text-primary);
            padding: 12px 14px;
            font-family: inherit;
            font-size: 13px;
            box-sizing: border-box;
            resize: vertical;
            outline: none;
            transition: all 0.3s ease;
        }

        textarea:focus {
            border-color: var(--primary-interactive);
            background-color: rgba(31, 26, 51, 0.9);
            box-shadow: 0 0 15px rgba(168, 85, 247, 0.15);
        }

        textarea::placeholder {
            color: rgba(255, 255, 255, 0.3);
        }

        .btn-resolve {
            background: var(--btn-success-gradient);
            color: var(--text-pure);
            border: none;
            padding: 10px 18px;
            border-radius: 10px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 600;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            white-space: nowrap;
            box-shadow: 0 4px 14px rgba(34, 197, 94, 0.25);
            align-self: flex-start;
        }

        .btn-resolve:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 18px rgba(34, 197, 94, 0.4);
            filter: brightness(1.1);
        }

        .btn-resolve:active {
            transform: translateY(0);
        }
    </style>
</head>
<body>

    <div class="sidebar">
        <h1>🚗 UniVelo Admin</h1>
        <div class="sidebar-menu">
            <a href="AdminController?action=viewPending">⏳ Pending Approvals</a>
            <a href="AdminController?action=viewAllUsers">👥 Master User Directory</a>
            <a href="ComplaintController?action=viewComplaints" class="active">⚠️ Support Complaints View</a>
            <a href="${pageContext.request.contextPath}/AuthController?action=logout" class="logout-btn">🚪 Log Out</a>
        </div>
    </div>

    <div class="main-content">
        <h2>Admin Support Control Board</h2>
        <h3>Submitted User & Driver Complaints Logs</h3>
        
        <table>
            <thead>
                <tr>
                    <th style="width: 8%;">ID</th>
                    <th style="width: 18%;">Complainant</th>
                    <th style="width: 28%;">Issue Description</th>
                    <th style="width: 11%;">Status</th>
                    <th style="width: 35%;">Action / Resolution Log</th>
                </tr>
            </thead>
            <tbody>
                <%-- Loops through list of complaints items passed from the controller servlet --%>
                <c:forEach items="${complaintsList}" var="c">
                    <tr>
                        <td><span style="font-weight: 700; color: var(--primary-interactive);"># ${c.id}</span></td>
                        <td>
                            <strong style="color: var(--text-pure); font-size: 15px;">${c.username}</strong><br>
                            <span style="font-size: 12px; color: var(--text-secondary); font-weight: 500; text-transform: uppercase; letter-spacing: 0.3px;">${c.role}</span>
                        </td>
                        <td>
                            <div style="line-height: 1.5; color: var(--text-primary); font-size: 14px;">${c.description}</div>
                        </td>
                        <td>
                            <span class="status ${c.status}">${c.status}</span>
                        </td>
                        <td>
                            <%-- Renders resolution form or locked notes based on complaint status --%>
                            <c:choose>
                                <%-- Form displayed if complaint status equals PENDING --%>
                                <c:when test="${c.status eq 'PENDING'}">
                                    <form action="ComplaintController" method="POST" style="margin:0; display:flex; flex-direction:column; gap:10px;">
                                        <input type="hidden" name="action" value="resolveComplaint">
                                        <input type="hidden" name="complaintId" value="${c.id}">
                                        
                                        <textarea name="resolution" rows="2" placeholder="Provide system resolution remarks details here..." required></textarea>
                                        <button type="submit" class="btn-resolve">✔️ Mark as Resolved</button>
                                    </form>
                                </c:when>
                                <%-- Static text content displayed if status is already RESOLVED --%>
                                <c:otherwise>
                                    <div style="font-size:13px; color:var(--success-text); font-weight:700; display: flex; align-items: center; gap: 6px;">
                                        <span>🔒</span> Resolution Notice:
                                    </div>
                                    <div style="font-size:13px; color:var(--text-secondary); margin-top:6px; font-style:italic; line-height: 1.4; background: rgba(255,255,255,0.02); padding: 10px 14px; border-radius: 8px; border-left: 3px solid var(--success-text);">
                                        "${c.resolution}"
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                
                <%-- Fallback row when list contains zero entries --%>
                <c:if test="${empty complaintsList}">
                    <tr>
                        <td colspan="5" style="text-align: center; color: var(--text-secondary); padding: 45px; font-size: 15px;">
                            <span style="font-size: 24px; display: block; margin-bottom: 10px;">🎉</span>
                            No reported system complaints or support tickets found.
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>

</body>
</html>