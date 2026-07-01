<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UniVelo - Premium Campus Transit</title>
    <style>
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
            /* Combines the UiTM Main Gate structure from image_62edf9.jpg with a dark bokeh driving aesthetic */
            background: radial-gradient(circle at center, rgba(13, 11, 20, 0.7) 0%, rgba(7, 5, 12, 0.97) 100%), 
                        url('https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&q=80&w=1600'), /* Blurred car cockpit/road view asset */
                        url('https://upload.wikimedia.org/wikipedia/commons/e/e0/UiTM_Main_Gate.jpg');
            background-blend-mode: multiply, screen, normal;
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            background-attachment: fixed;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            color: var(--text-primary);
            overflow-x: hidden;
        }

        .login-wrapper {
            background: var(--card-glass);
            backdrop-filter: blur(24px);
            -webkit-backdrop-filter: blur(24px);
            padding: 3rem 2.5rem;
            border-radius: 24px;
            border: 1px solid var(--border-glow);
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.75),
                        0 0 25px 0 rgba(168, 85, 247, 0.12);
            width: 100%;
            max-width: 440px;
            box-sizing: border-box;
            text-align: center;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .login-wrapper:hover {
            box-shadow: 0 25px 60px -12px rgba(0, 0, 0, 0.85),
                        0 0 35px 2px rgba(168, 85, 247, 0.2);
        }

        .brand-logo {
            font-size: 2.4rem;
            font-weight: 800;
            letter-spacing: -1.5px;
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

        .input-field-group {
            position: relative;
            margin-bottom: 1.5rem;
            text-align: left;
        }

        .input-field-group svg {
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

        .input-field-group input {
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

        .input-field-group input:focus {
            border-color: var(--primary-interactive);
            box-shadow: 0 0 0 4px var(--input-focus-glow);
            background-color: rgba(13, 11, 20, 0.95);
        }

        .input-field-group input:focus + svg {
            color: var(--primary-interactive);
        }

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
            margin-top: 0.5rem;
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

        .info-status-msg {
            background: rgba(96, 165, 250, 0.1);
            border: 1px solid rgba(96, 165, 250, 0.2);
            color: #93c5fd;
            padding: 12px 16px;
            margin-bottom: 1.5rem;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 500;
        }

        .error-status-popup {
            color: #fca5a5; 
            background-color: rgba(127, 29, 29, 0.4); 
            border: 1px solid rgba(239, 68, 68, 0.3); 
            padding: 14px 16px; 
            margin-bottom: 1.5rem; 
            border-radius: 12px; 
            font-weight: 500; 
            font-size: 14px;
            text-align: left;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .navigation-footer {
            margin-top: 2rem;
            font-size: 14px;
            color: var(--text-secondary);
            border-top: 1px solid rgba(255, 255, 255, 0.06);
            padding-top: 1.5rem;
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
</head>
<body>

    <div class="login-wrapper">
        <div class="brand-logo">UniVelo</div>
        <div class="brand-subtext">CAMPUS RIDE-HAILING PORTAL</div>
        
        <c:if test="${not empty message}">
            <div class="info-status-msg">${message}</div> 
        </c:if>
        
        <c:if test="${not empty popupMessage}">
            <div class="error-status-popup">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" style="width:20px; height:20px; flex-shrink:0;">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/>
                </svg>
                <span>${popupMessage}</span>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/AuthController" method="POST">
            <input type="hidden" name="action" value="login">
            
            <div class="input-field-group">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                </svg>
                <input type="text" name="username" placeholder="Username" required autocomplete="username">
            </div>
            
            <div class="input-field-group">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/>
                </svg>
                <input type="password" name="password" placeholder="Password" required autocomplete="current-password">
            </div>
            
            <button type="submit" class="submit-action-btn">Book Your Ride</button>
        </form>
        
        <div class="navigation-footer">
            New to UniVelo? <a href="register.jsp">Register Here</a>
        </div>
    </div>

</body>
</html>