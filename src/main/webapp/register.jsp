<%@page contentType="text/html" pageEncoding="UTF-8"%> <%-- Declares character configuration and content specifications --%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UniVelo - Registration</title>
    <style>
        /* Shared Premium Cyber-Purple Dashboard Theme Variables */
        :root {
            --bg-dark: #07050c;
            --card-glass: rgba(22, 18, 36, 0.85);
            --primary-glow: #a855f7;
            --primary-interactive: #b56eff;
            --primary-gradient: linear-gradient(135deg, #a855f7 0%, #7c3aed 100%);
            --text-pure: #ffffff;
            --text-primary: #f3f4f6;
            --text-secondary: #9ca3af;
            --border-glow: rgba(168, 85, 247, 0.25);
            --input-focus-glow: rgba(168, 85, 247, 0.4);
        }

        body {
            font-family: 'Plus Jakarta Sans', 'Segoe UI', system-ui, -apple-system, sans-serif;
            /* Perfectly synced automotive overlay + campus landmarks combo */
            background: radial-gradient(circle at center, rgba(13, 11, 20, 0.7) 0%, rgba(7, 5, 12, 0.97) 100%), 
                        url('https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&q=80&w=1600'), 
                        url('https://upload.wikimedia.org/wikipedia/commons/e/e0/UiTM_Main_Gate.jpg');
            background-blend-mode: multiply, screen, normal;
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            background-attachment: fixed;
            margin: 0;
            padding: 40px 20px;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            color: var(--text-primary);
            box-sizing: border-box;
            overflow-x: hidden;
        }

        /* --- REGISTRATION GLASS CARD --- */
        .register-wrapper {
            background: var(--card-glass);
            backdrop-filter: blur(24px);
            -webkit-backdrop-filter: blur(24px);
            padding: 3rem 2.5rem;
            border-radius: 24px;
            border: 1px solid var(--border-glow);
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.75),
                        0 0 25px 0 rgba(168, 85, 247, 0.12);
            width: 100%;
            max-width: 460px;
            box-sizing: border-box;
            text-align: center;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .register-wrapper:hover {
            box-shadow: 0 25px 60px -12px rgba(0, 0, 0, 0.85),
                        0 0 35px 2px rgba(168, 85, 247, 0.2);
        }

        .register-wrapper h2 {
            font-size: 2.2rem;
            font-weight: 800;
            letter-spacing: -1px;
            margin-top: 0;
            margin-bottom: 0.25rem;
            background: linear-gradient(to right, #ffffff, #d8b4fe);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .brand-subtext {
            font-size: 0.9rem;
            color: var(--text-secondary);
            margin-bottom: 2.5rem;
            font-weight: 500;
            letter-spacing: 0.5px;
        }

        /* --- STRUCTURAL FORM LAYOUT --- */
        .input-field-group {
            position: relative;
            margin-bottom: 1.2rem;
            text-align: left;
        }

        .input-field-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-size: 13px;
            color: var(--text-secondary);
            font-weight: 600;
            letter-spacing: 0.3px;
            text-transform: uppercase;
            padding-left: 4px;
        }

        .input-field-group svg.input-icon {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-secondary);
            width: 20px;
            height: 20px;
            transition: color 0.3s ease;
            pointer-events: none;
            z-index: 2;
        }

        .input-field-group.has-label svg.input-icon {
            top: calc(50% + 12px);
        }

        /* --- INPUT & INTERACTIVE FIELDS --- */
        .input-field-group input[type="text"],
        .input-field-group input[type="password"],
        .input-field-group input[type="tel"],
        .input-field-group select {
            width: 100%;
            padding: 16px 16px 16px 48px;
            background-color: rgba(13, 11, 20, 0.7);
            border: 1px solid var(--border-glow);
            border-radius: 14px;
            font-size: 15px;
            color: var(--text-pure);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            box-sizing: border-box;
            outline: none;
        }

        .input-field-group select {
            appearance: none;
            background-image: url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='24' height='24' viewBox='0 0 24 24' fill='none' stroke='%239ca3af' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'><polyline points='6 9 12 15 18 9'></polyline></svg>");
            background-repeat: no-repeat;
            background-position: right 16px center;
            background-size: 16px;
            padding-right: 48px;
            cursor: pointer;
        }

        .input-field-group input:focus,
        .input-field-group select:focus {
            border-color: var(--primary-interactive);
            box-shadow: 0 0 0 4px var(--input-focus-glow);
            background-color: rgba(13, 11, 20, 0.95);
        }

        .input-field-group input:focus + svg.input-icon,
        .input-field-group select:focus + svg.input-icon {
            color: var(--primary-interactive);
        }

        /* --- DOCUMENT UPLOAD ZONE --- */
        .input-field-group input[type="file"] {
            width: 100%;
            padding: 14px;
            background-color: rgba(13, 11, 20, 0.4);
            border: 1px dashed var(--border-glow);
            border-radius: 14px;
            color: var(--text-secondary);
            font-size: 14px;
            box-sizing: border-box;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .input-field-group input[type="file"]:hover {
            border-color: var(--primary-interactive);
            background-color: rgba(13, 11, 20, 0.6);
        }

        /* --- INTERACTIVE ACTION ACCENTS --- */
        .submit-action-btn {
            width: 100%;
            padding: 15px;
            background: var(--primary-gradient);
            color: var(--text-pure);
            border: none;
            border-radius: 14px;
            font-size: 16px;
            font-weight: 600;
            letter-spacing: 0.2px;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            margin-top: 1rem;
            box-shadow: 0 4px 20px rgba(168, 85, 247, 0.3);
        }

        .submit-action-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(168, 85, 247, 0.45);
            filter: brightness(1.1);
        }

        .submit-action-btn:active {
            transform: translateY(0);
        }

        .navigation-footer {
            margin-top: 2rem;
            font-size: 14px;
            color: var(--text-secondary);
            border-top: 1px solid rgba(255, 255, 255, 0.06);
            padding-top: 1.5rem;
            text-align: center;
        }

        .navigation-footer a {
            color: var(--primary-interactive);
            text-decoration: none;
            font-weight: 600;
            transition: all 0.2s;
            position: relative;
        }

        .navigation-footer a::after {
            content: '';
            position: absolute;
            width: 0;
            height: 2px;
            bottom: -2px;
            left: 0;
            background-color: var(--primary-interactive);
            transition: width 0.2s ease;
        }

        .navigation-footer a:hover::after {
            width: 100%;
        }
    </style>
    <script>
        /**
         * Real-time client-side structural form mutation layout engine
         * Dynamically alters label typography variables based on programmatic role choices
         */
        function toggleLabel() {
            var role = document.getElementById("role").value;
            var docLabel = document.getElementById("docLabel");
            if (role === "DRIVER") {
                docLabel.innerText = "Upload Driver's License Image:";
            } else {
                docLabel.innerText = "Upload Student Card ID Image:";
            }
        }
    </script>
</head>
<body>

    <%-- Centered Authentication Registration Workspace Panel Shell --%>
    <div class="register-wrapper">
        <h2>UniVelo</h2>
        <div class="brand-subtext">JOIN THE CAMPUS DRIVING NETWORK</div>
        
        <%-- Form module processing incoming stream payloads with strict multi-part encoding filters --%>
        <form action="${pageContext.request.contextPath}/AuthController" method="POST" enctype="multipart/form-data">
            <input type="hidden" name="action" value="register">
            
            <div class="input-field-group">
                <input type="text" name="username" placeholder="Username" required autocomplete="username">
                <svg class="input-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                </svg>
            </div>
            
            <div class="input-field-group">
                <input type="password" name="password" placeholder="Password" required autocomplete="new-password">
                <svg class="input-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/>
                </svg>
            </div>
            
            <div class="input-field-group">
                <input type="tel" name="phone" placeholder="Phone Number (e.g. +601234567)" required>
                <svg class="input-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.94.725l.548 2.2a1 1 0 01-.321.988l-1.305.98a10.582 10.582 0 004.872 4.872l.98-1.305a1 1 0 01.988-.321l2.2.548a1 1 0 01.725.94V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"/>
                </svg>
            </div>
            
            <div class="input-field-group has-label">
                <label for="role">Sign up as:</label>
                <select name="role" id="role" onchange="toggleLabel()">
                    <option value="PASSENGER">Passenger (Rider)</option>
                    <option value="DRIVER">Driver (Vehicle Owner)</option>
                </select>
                <svg class="input-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
                </svg>
            </div>
            
            <%-- Dynamic functional context node mutated via explicit role verification events --%>
            <div class="input-field-group">
                <label id="docLabel" for="documentImage">Upload Student Card ID Image:</label>
                <input type="file" id="documentImage" name="documentImage" accept="image/*" required>
            </div>
            
            <button type="submit" class="submit-action-btn">Register Network Account</button>
        </form>
        
        <div class="navigation-footer">
            Already have an account? <a href="index.jsp">Login Here</a>
        </div>
    </div>

</body>
</html>