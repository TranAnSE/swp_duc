<%-- 
    Document   : contact
    Created on : Jun 26, 2025, 4:39:31 AM
    Author     : ankha
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Contact Us - Online Learning Platform</title>
    <link rel="stylesheet" href="assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/css/style.css">
    <link rel="stylesheet" href="assets/css/fontawesome-all.min.css">
</head>
<body>
    <jsp:include page="header.jsp" />
    
    <main style="padding-top: 100px;">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="text-center mb-5">
                        <h2>Contact Us</h2>
                        <p class="lead">Get in touch with our team for any questions or support</p>
                    </div>
                    
                    <div class="card">
                        <div class="card-body p-5">
                            <form>
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group mb-3">
                                            <label>Full Name</label>
                                            <input type="text" class="form-control" required>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group mb-3">
                                            <label>Email Address</label>
                                            <input type="email" class="form-control" required>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group mb-3">
                                    <label>Subject</label>
                                    <input type="text" class="form-control" required>
                                </div>
                                <div class="form-group mb-3">
                                    <label>Message</label>
                                    <textarea class="form-control" rows="5" required></textarea>
                                </div>
                                <div class="text-center">
                                    <button type="submit" class="btn btn-primary btn-lg">Send Message</button>
                                </div>
                            </form>
                        </div>
                    </div>
                    
                    <div class="row mt-5">
                        <div class="col-md-4 text-center">
                            <div class="mb-3">
                                <i class="fas fa-map-marker-alt fa-2x text-primary"></i>
                            </div>
                            <h5>Address</h5>
                            <p>123 Education Street<br>Learning City, LC 12345</p>
                        </div>
                        <div class="col-md-4 text-center">
                            <div class="mb-3">
                                <i class="fas fa-phone fa-2x text-primary"></i>
                            </div>
                            <h5>Phone</h5>
                            <p>+1 (555) 123-4567</p>
                        </div>
                        <div class="col-md-4 text-center">
                            <div class="mb-3">
                                <i class="fas fa-envelope fa-2x text-primary"></i>
                            </div>
                            <h5>Email</h5>
                            <p>info@learningplatform.com</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
    
    <jsp:include page="footer.jsp" />
    
    <script src="assets/js/vendor/jquery-1.12.4.min.js"></script>
    <script src="assets/js/bootstrap.min.js"></script>
</body>
</html>
