<%@taglib prefix="c" uri="jakarta.tags.core"%> <%-- Imports standard JSTL tags for looping and conditionals --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%> <%-- Sets standard character and page rendering properties --%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Master User Database</title>
    <style>
        /* Shared Premium Cyber-Purple Dashboard Theme Variables */
        :root {
            --bg-dark: #07050c;
            --sidebar-bg: rgba(17, 14, 28, 0.75);
            --card-glass: rgba(22, 18, 36, 0.82);
            --primary-glow: #a855f7;
            --primary-interactive: #b56eff;
            --primary-gradient: linear-gradient(135deg, #a855f7 0%, #7c3aed 100%);
            --text-pure: #ffffff;
            --text-primary: #f3f4f6;
            --text-secondary: #9ca3af;
            --border-glow: rgba(168, 85, 247, 0.2);
            --table-header-bg: #1e1833;
            --btn-info: #06b6d4;
            --btn-info-gradient: linear-gradient(135deg, #06b6d4 0%, #0891b2 100%);
            --btn-active: rgba(168, 85, 247, 0.15);
        }

        body {
            font-family: 'Plus Jakarta Sans', 'Segoe UI', system-ui, -apple-system, sans-serif;
            /* Matches the car cockpit + campus hybrid background profile */
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

        /* --- DATATABLE GLASSMORPHISM ARCHITECTURE --- */
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
            background-color: rgba(168, 85, 247, 0.04);
            color: var(--text-pure);
        }

        /* High Visibility Status Pill Badges */
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

        .APPROVED { background-color: rgba(34, 197, 94, 0.15); color: #4ade80; border: 1px solid rgba(34, 197, 94, 0.3); } 
        .PENDING { background-color: rgba(234, 179, 8, 0.15); color: #facc15; border: 1px solid rgba(234, 179, 8, 0.3); } 
        .REJECTED { background-color: rgba(239, 68, 68, 0.15); color: #fca5a5; border: 1px solid rgba(239, 68, 68, 0.3); }

        /* Core UI Interactive Action Button */
        .btn-review {
            background: var(--btn-info-gradient);
            color: var(--text-pure);
            border: none;
            padding: 10px 16px;
            border-radius: 10px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 600;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 4px 15px rgba(6, 182, 212, 0.25);
        }

        .btn-review:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(6, 182, 212, 0.4);
            filter: brightness(1.1);
        }

        .btn-review:active {
            transform: translateY(0);
        }

        /* --- FLOATING MODAL DOCUMENT MODULE --- */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(5, 4, 8, 0.88); 
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
        }

        .modal-content {
            background-color: var(--card-glass);
            margin: 6% auto;
            padding: 2.5rem;
            width: 90%;
            max-width: 540px;
            text-align: center;
            border-radius: 24px;
            position: relative;
            box-shadow: 0 30px 60px rgba(0, 0, 0, 0.8),
                        0 0 30px rgba(168, 85, 247, 0.15);
            border: 1px solid var(--border-glow);
        }

        .modal-content h3 {
            font-size: 1.4rem;
            font-weight: 800;
            color: var(--text-pure);
            margin-bottom: 1.5rem;
            background: linear-gradient(to right, #ffffff, #d8b4fe);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .modal-content img {
            max-width: 100%;
            height: auto;
            border-radius: 14px;
            border: 1px solid rgba(255, 255, 255, 0.08);
            margin-top: 10px;
            background-color: rgba(7, 5, 12, 0.5);
            box-shadow: inset 0 0 20px rgba(0,0,0,0.6);
        }

        .close-btn {
            position: absolute;
            right: 24px;
            top: 20px;
            font-size: 30px;
            font-weight: 300;
            cursor: pointer;
            color: var(--text-secondary);
            transition: color 0.2s;
        }
        
        .close-btn:hover {
            color: var(--text-pure);
        }
    </style>
</head>
<body>

    <%-- Glassmorphic Sidebar Navigation Shell --%>
    <div class="sidebar">
        <h1>🚗 UniVelo Admin</h1>
        <div class="sidebar-menu">
            <a href="AdminController?action=viewPending">⏳ Pending Approvals</a>
            <a href="AdminController?action=viewUsers" class="active">👥 Master User Directory</a>
            <a href="ComplaintController?action=viewComplaints">⚠️ Support Complaints View</a>
            
            <a href="${pageContext.request.contextPath}/AuthController?action=logout" class="logout-btn">🚪 Log Out</a>
        </div>
    </div>

    <%-- Main Control Center Interface Panel --%>
    <div class="main-content">
        <h2>Admin Master Control Center</h2>
        <h3>All System Registered Users</h3>
        
        <%-- Interactive Glassmorphic Datatable --%>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Username</th>
                    <th>Phone Number</th>
                    <th>Role Type</th>
                    <th>Verification Status</th>
                    <th>Historical Verification File</th>
                </tr>
            </thead>
            <tbody>
                <%-- Iterates dynamically through the list of users provided by the AdminController servlet --%>
                <c:forEach items="${allUsersList}" var="user">
                    <tr>
                        <td>${user.id}</td>
                        <td><strong>${user.username}</strong></td>
                        <td>${user.phone}</td>
                        <td>${user.role}</td>
                        <td>
                            <%-- Generates status pill badges that dynamically change visual color classes via user.status properties --%>
                            <span class="status ${user.status}">${user.status}</span>
                        </td>
                        <td>
                            <%-- Interactive button that passes individual document pathing strings into the JavaScript modal framework --%>
                            <button class="btn-review" onclick="openDocModal('${pageContext.request.contextPath}/${user.documentPath}', '${user.username}')">
                                Open Uploaded Doc
                            </button>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <%-- Floating Modal Document Display Target Module --%>
    <div id="documentModal" class="modal" onclick="closeDocModal(event)">
        <div class="modal-content">
            <span class="close-btn" onclick="document.getElementById('documentModal').style.display='none'">&times;</span>
            <h3 id="modalTitle">Document History Trace</h3>
            <img id="modalImage" src="" alt="User Document Evidence">
        </div>
    </div>

    <script>
        /**
         * Dynamically configures and opens the verification document modal window.
         * @param {string} imageSrc - The file path location of the image document.
         * @param {string} username - The account name of the corresponding target user record.
         */
        function openDocModal(imageSrc, username) {
            document.getElementById("modalImage").src = imageSrc;
            document.getElementById("modalTitle").innerText = "Document Trace for: " + username;
            document.getElementById("documentModal").style.display = "block";
        }
        
        /**
         * Closes the document preview modal layout when checking for clicks landed on outer glass backdrops.
         * @param {MouseEvent} event - Standard browser action cursor telemetry parameters.
         */
        function closeDocModal(event) {
            if (event.target.id === "documentModal") {
                document.getElementById("documentModal").style.display = "none";
            }
        }
    </script>

</body>
</html>