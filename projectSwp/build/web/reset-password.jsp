<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Reset Password</title>
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
                <h2 class="text-center mb-4">Reset Password</h2>
                
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
                    <input type="hidden" name="action" value="reset">
                    <input type="hidden" name="email" value="<%= request.getAttribute("email") %>">
                    
                    <div class="form-group">
                        <label for="new_password" class="form-label">New Password</label>
                        <input type="password" class="form-control" id="new_password" name="new_password" 
                               placeholder="Enter new password" required minlength="6">
                    </div>
                    
                    <div class="form-group">
                        <label for="confirm_password" class="form-label">Confirm Password</label>
                        <input type="password" class="form-control" id="confirm_password" name="confirm_password" 
                               placeholder="Confirm new password" required minlength="6">
                    </div>
                    
                    <div class="form-group">
                        <button type="submit" class="btn btn-login">Reset Password</button>
                    </div>
                </form>
                
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
            // Password matching validation
            document.getElementById('confirm_password').addEventListener('input', function() {
                const password = document.getElementById('new_password').value;
                const confirmPassword = this.value;
                
                if (password !== confirmPassword) {
                    this.setCustomValidity('Passwords do not match');
                } else {
                    this.setCustomValidity('');
                }
            });
            
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
        </script>
    </body>
</html> 