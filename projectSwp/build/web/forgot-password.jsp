<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Forgot Password</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
        <style>
            .login-container {
                max-width: 450px;
                margin: 100px auto;
                padding: 20px;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                border-radius: 5px;
                background-color: #fff;
            }
            .logo-img {
                width: 100px;
                display: block;
                margin: 0 auto 20px;
            }
            .form-group {
                margin-bottom: 20px;
            }
            .btn-login {
                background-color: #007bff;
                color: white;
                width: 100%;
            }
            .message {
                padding: 10px;
                margin-bottom: 20px;
                border-radius: 5px;
            }
            .error {
                background-color: #f8d7da;
                color: #721c24;
            }
            .success {
                background-color: #d4edda;
                color: #155724;
            }
            .back-link {
                display: block;
                text-align: center;
                margin-top: 20px;
            }
            .debug-info {
                margin-top: 20px;
                padding: 10px;
                background-color: #f8f9fa;
                border: 1px solid #dee2e6;
                border-radius: 5px;
                font-family: monospace;
                max-height: 200px;
                overflow-y: auto;
            }
        </style>
    </head>
    <body class="bg-light">
        <!-- Hiển thị console script từ servlet nếu có -->
        <%= request.getAttribute("consoleScript") != null ? request.getAttribute("consoleScript") : "" %>
        
        <div class="container">
            <div class="login-container">
                <h2 class="text-center mb-4">Forgot Password</h2>
                
                <% if (request.getAttribute("error") != null) { %>
                <div class="message error">
                    <%= request.getAttribute("error") %>
                </div>
                <% } %>
                
                <% if (request.getAttribute("success") != null) { %>
                <div class="message success">
                    <%= request.getAttribute("success") %>
                </div>
                <% } %>
                
                <form action="forgot-password" method="POST">
                    <div class="form-group">
                        <label for="email" class="form-label">Email</label>
                        <input type="email" class="form-control" id="email" name="email" 
                               value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>"
                               placeholder="Enter your email" required>
                    </div>
                    
                    <div class="form-group">
                        <button type="submit" class="btn btn-login">Send Reset Link</button>
                    </div>
                </form>
                
                <a href="login" class="back-link">Back to Login</a>
                
                <!-- Debug information button -->
<!--                <div class="mt-4">
                    <button class="btn btn-sm btn-secondary w-100" onclick="toggleDebugInfo()">
                        Hiển thị thông tin debug
                    </button>
                    <div id="debugInfo" class="debug-info" style="display: none;"></div>
                </div>-->
            </div>
        </div>
        
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Function to show debug info
            function toggleDebugInfo() {
                const debugDiv = document.getElementById('debugInfo');
                if (debugDiv.style.display === 'none') {
                    // Capture console.log output
                    const oldLog = console.log;
                    const logMessages = [];
                    
                    console.log = function(message) {
                        logMessages.push(message);
                        oldLog.apply(console, arguments);
                    };
                    
                    // Emit a special log to trigger copying of previous logs
                    console.log("--- Debug Info ---");
                    
                    // Restore console.log
                    console.log = oldLog;
                    
                    // Display logs in debug div
                    debugDiv.innerHTML = logMessages.join('<br>');
                    debugDiv.style.display = 'block';
                } else {
                    debugDiv.style.display = 'none';
                }
            }
            
            // Auto-open console in browser
            document.addEventListener('DOMContentLoaded', function() {
                setTimeout(function() {
                    console.log("Để xem link đặt lại mật khẩu, nhấp vào nút 'Hiển thị thông tin debug'");
                }, 500);
            });
        </script>
    </body>
</html> 