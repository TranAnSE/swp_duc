<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Login Page</title>
        <link rel="stylesheet" href="https://unpkg.com/bootstrap@5.3.3/dist/css/bootstrap.min.css">
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="manifest" href="site.webmanifest">
        <link rel="shortcut icon" type="image/x-icon" href="assets/img/favicon.ico">
        <!-- CSS here -->
        <link rel="stylesheet" href="assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="assets/css/owl.carousel.min.css">
        <link rel="stylesheet" href="assets/css/slicknav.css">
        <link rel="stylesheet" href="assets/css/flaticon.css">
        <link rel="stylesheet" href="assets/css/progressbar_barfiller.css">
        <link rel="stylesheet" href="assets/css/gijgo.css">
        <link rel="stylesheet" href="assets/css/animate.min.css">
        <link rel="stylesheet" href="assets/css/animated-headline.css">
        <link rel="stylesheet" href="assets/css/magnific-popup.css">
        <link rel="stylesheet" href="assets/css/fontawesome-all.min.css">
        <link rel="stylesheet" href="assets/css/themify-icons.css">
        <link rel="stylesheet" href="assets/css/slick.css">
        <link rel="stylesheet" href="assets/css/nice-select.css">
        <link rel="stylesheet" href="assets/css/style.css">
        <style>
            .header-area {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                z-index: 1000;
                background-color: white;
                border-bottom: 1px solid #ddd;
            }

            body {
                padding-top: 90px; /* Tăng khoảng cách để không bị che */
            }

            main {
                background-color: #f8f9fa;
                padding: 30px 15px;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            }

            main h2 {
                text-align: center;
                font-weight: 600;
                color: #343a40;
            }

            form[method="get"] {
                display: flex;
                align-items: center;
                gap: 10px;
                flex-wrap: wrap;
                justify-content: center;
                margin-bottom: 20px;
            }

            form[method="get"] input[type="text"] {
                max-width: 300px;
            }

            table.table {
                background-color: #fff;
                border-radius: 6px;
                overflow: hidden;
            }

            table.table thead {
                background-color: #343a40;
                color: #fff;
            }

            table.table td,
            table.table th {
                vertical-align: middle !important;
                text-align: center;
            }

            .img-thumbnail {
                object-fit: cover;
                border-radius: 8px;
            }

            .btn {
                margin: 2px;
            }

            .btn-success, .btn-outline-secondary {
                margin-top: 10px;
                margin-right: 10px;
            }

            .text-danger {
                text-align: center;
                font-weight: bold;
            }




            body {
                font-family: Arial, sans-serif;
                background-color: #f5f5f5;
            }
            .login-container {
                max-width: 400px;
                margin: 50px auto;
                padding: 25px;
                background-color: white;
                box-shadow: 0 0 10px #ccc;
                border-radius: 5px;
            }
            .login-container h2 {
                text-align: center;
                margin-bottom: 25px;
            }
            .form-group {
                margin-bottom: 15px;
            }
            label {
                display: block;
                font-weight: bold;
            }
            input[type=text], input[type=password], select {
                width: 100%;
                padding: 8px;
                box-sizing: border-box;
            }
            .error {
                color: red;
                margin-bottom: 15px;
                text-align: center;
            }
            .remember-me {
                display: flex;
                align-items: center;
            }
            .remember-me input {
                margin-right: 5px;
            }
            button {
                width: 100%;
                padding: 10px;
                background-color: #3f51b5;
                border: none;
                color: white;
                font-weight: bold;
                cursor: pointer;
                border-radius: 3px;
            }
            button:hover {
                background-color: #303f9f;
            }

            /* Google Sign-In Button Styles */
            .google-btn {
                width: 100%;
                padding: 10px;
                background-color: #fff;
                border: 1px solid #ccc;
                color: #757575;
                font-weight: bold;
                cursor: pointer;
                border-radius: 3px;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-top: 15px;
                text-decoration: none;
            }

            .google-btn:hover {
                background-color: #f5f5f5;
            }

            .google-btn img {
                margin-right: 10px;
                width: 18px;
                height: 18px;
            }

            .or-divider {
                text-align: center;
                margin: 15px 0;
                position: relative;
            }

            .or-divider:before,
            .or-divider:after {
                content: "";
                display: block;
                width: 45%;
                height: 1px;
                background: #ddd;
                position: absolute;
                top: 50%;
            }

            .or-divider:before {
                left: 0;
            }

            .or-divider:after {
                right: 0;
            }
        </style>
    </head>
    <body>
        <!--         ? Preloader Start 
                <div id="preloader-active">
                    <div class="preloader d-flex align-items-center justify-content-center">
                        <div class="preloader-inner position-relative">
                            <div class="preloader-circle"></div>
                            <div class="preloader-img pere-text">
                                <img src="assets/img/logo/loder.png" alt="">
                            </div>
                        </div>
                    </div>
                </div>
                 Preloader Start 
                 Header Start 
                <div class="header-area header-transparent">
                    <div class="main-header ">
                        <div class="header-bottom header-sticky">
                            <div class="container-fluid">
                                <div class="row align-items-center">
                                     Logo 
                                    <div class="col-xl-2 col-lg-2">
                                        <div class="logo">
                                            <a href="index.html"><img src="assets/img/logo/logo.png" alt=""></a>
                                        </div>
                                    </div>
                                    <div class="col-xl-10 col-lg-10">
                                        <div class="menu-wrapper d-flex align-items-center justify-content-end">
                                             Main-menu 
                                            <div class="main-menu d-none d-lg-block">
                                                <nav>
                                                    <ul id="navigation">                                                                                          
                                                        <li class="active" ><a href="index.html">Home</a></li>
                                                        <li><a href="courses.html">Courses</a></li>
                                                        <li><a href="about.html">About</a></li>
                                                        <li><a href="#">Blog</a>
                                                            <ul class="submenu">
                                                                <li><a href="blog.html">Blog</a></li>
                                                                <li><a href="blog_details.html">Blog Details</a></li>
                                                                <li><a href="elements.html">Element</a></li>
                                                            </ul>
                                                        </li>
                                                        <li><a href="contact.html">Contact</a></li>
                                                    </ul>
                                                </nav>
                                            </div>
                                        </div>
                                    </div> 
                                     Mobile Menu 
                                    <div class="col-12">
                                        <div class="mobile_menu d-block d-lg-none"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                 Header End -->

        <%@include file="header.jsp" %>
        <div class="login-container">
            <h2>Login</h2>

            <c:if test="${not empty error}">
                <div class="error">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="post">
                <div class="form-group">
                    <label for="userType">User Type</label>
                    <select name="userType" id="userType" required onchange="toggleInputFields()">
                        <option value="teacher" ${userType == 'teacher' ? 'selected' : ''}>Teacher</option>
                        <option value="admin" ${userType == 'admin' ? 'selected' : ''}>Admin</option>
                        <option value="parent" ${userType == 'parent' ? 'selected' : ''}>Parent</option>
                        <option value="student" ${userType == 'student' ? 'selected' : ''}>Student</option>
                    </select>
                </div>
                </br>
                </br>

                <div class="form-group" id="emailGroup">
                    <label for="email">Email</label>
                    <input type="text" name="email" id="email"
                           value="${cookie.email.value != null ? cookie.email.value : requestScope.email}"
                           placeholder="Enter your email"/>
                </div>

                <div class="form-group" id="usernameGroup" style="display:none;">
                    <label for="username">Username</label>
                    <input type="text" name="username" id="username"
                           value="${cookie.username.value != null ? cookie.username.value : requestScope.username}"
                           placeholder="Enter your username"/>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" name="password" id="password"
                           value="${cookie.password.value != null ? cookie.password.value : requestScope.password}" placeholder="Enter your password"/>
                </div>

                <div class="form-group remember-me">
                    <input type="checkbox" id="remember_me" name="remember_me"
                           ${cookie.remember.value!=null?'checked':''}/>
                    <label for="remember_me">Remember me</label>
                </div>
                <!--<a href="${pageContext.request.contextPath}/forgot-password" class="forget-password" style="background: black">Forget Password?</a>-->
                <button  class="btn btn-lg btn-danger" type="submit">Login</button>
<!--                <a href="https://accounts.google.com/o/oauth2/auth?scope=email%20profile%20openid&redirect_uri=http://localhost:9999/logingoogle&response_type=code&client_id=118450184719-ar44tevflkttlnqbb8hina7u55l0ecdv.apps.googleusercontent.com&approval_prompt=force" class="btn btn-lg btn-danger">
                    <svg xmlns="http://www.w3.org/2000/svg" width="90" height="20" fill="currentColor">
                    <path d="M15.545 6.558a9.42 9.42 0 0 1 .139 1.626c0 2.434-.87 4.492-2.384 5.885h.002C11.978 15.292 10.158 16 8 16A8 8 0 1 1 8 0a7.689 7.689 0 0 1 5.352 2.082l-2.284 2.284A4.347 4.347 0 0 0 8 3.166c-2.087 0-3.86 1.408-4.492 3.304a4.792 4.792 0 0 0 0 3.063h.003c.635 1.893 2.405 3.301 4.492 3.301 1.078 0 2.004-.276 2.722-.764h-.003a3.702 3.702 0 0 0 1.599-2.431H8v-3.08h7.545z" />
                    </svg>
                    <span class="">Sign in with Google</span>
                </a>-->


                <!--<a href="/register.jsp"  class="btn btn-lg btn-danger">Register</a>-->

            </form>

            <div class="or-divider">
                <span>OR</span>
            </div>

            <a href="https://accounts.google.com/o/oauth2/auth?scope=email%20profile%20openid&redirect_uri=http://localhost:9999/logingoogle&response_type=code&client_id=118450184719-ar44tevflkttlnqbb8hina7u55l0ecdv.apps.googleusercontent.com&approval_prompt=force" class="google-btn">
                <img src="https://developers.google.com/identity/images/g-logo.png" alt="Google logo">
                <path d="M15.545 6.558a9.42 9.42 0 0 1 .139 1.626c0 2.434-.87 4.492-2.384 5.885h.002C11.978 15.292 10.158 16 8 16A8 8 0 1 1 8 0a7.689 7.689 0 0 1 5.352 2.082l-2.284 2.284A4.347 4.347 0 0 0 8 3.166c-2.087 0-3.86 1.408-4.492 3.304a4.792 4.792 0 0 0 0 3.063h.003c.635 1.893 2.405 3.301 4.492 3.301 1.078 0 2.004-.276 2.722-.764h-.003a3.702 3.702 0 0 0 1.599-2.431H8v-3.08h7.545z" />

                Sign in with Google
            </a>

            <div style="margin-top: 15px; text-align: center;">
                <a style="color: black" href="${pageContext.request.contextPath}/forgot-password.jsp">Forgot Password?</a>
                <span style="margin: 0 5px;">|</span>
                <a style="color: black"  href="${pageContext.request.contextPath}/register.jsp">Register</a>
            </div>
        </div>

        <script>
            function toggleInputFields() {
                const userType = document.getElementById('userType').value;
                if (userType === 'student') {
                    document.getElementById('emailGroup').style.display = 'none';
                    document.getElementById('usernameGroup').style.display = 'block';
                } else {
                    document.getElementById('emailGroup').style.display = 'block';
                    document.getElementById('usernameGroup').style.display = 'none';
                }
            }

            // Khởi động ban đầu để ẩn hiện đúng
            toggleInputFields();
        </script>
        <footer>
            <div class="footer-wrappper footer-bg">
                <!-- Footer Start-->
                <div class="footer-area footer-padding">
                    <div class="container">
                        <div class="row justify-content-between">
                            <div class="col-xl-4 col-lg-5 col-md-4 col-sm-6">
                                <div class="single-footer-caption mb-50">
                                    <div class="single-footer-caption mb-30">
                                        <!-- logo -->
                                        <div class="footer-logo mb-25">
                                            <a href="index.html"><img src="assets/img/logo/logo2_footer.png" alt=""></a>
                                        </div>
                                        <div class="footer-tittle">
                                            <div class="footer-pera">
                                                <p>The automated process starts as soon as your clothes go into the machine.</p>
                                            </div>
                                        </div>
                                        <!-- social -->
                                        <div class="footer-social">
                                            <a href="#"><i class="fab fa-twitter"></i></a>
                                            <a href="https://bit.ly/sai4ull"><i class="fab fa-facebook-f"></i></a>
                                            <a href="#"><i class="fab fa-pinterest-p"></i></a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xl-2 col-lg-3 col-md-4 col-sm-5">
                                <div class="single-footer-caption mb-50">
                                    <div class="footer-tittle">
                                        <h4>Our solutions</h4>
                                        <ul>
                                            <li><a href="#">Design & creatives</a></li>
                                            <li><a href="#">Telecommunication</a></li>
                                            <li><a href="#">Restaurant</a></li>
                                            <li><a href="#">Programing</a></li>
                                            <li><a href="#">Architecture</a></li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xl-2 col-lg-4 col-md-4 col-sm-6">
                                <div class="single-footer-caption mb-50">
                                    <div class="footer-tittle">
                                        <h4>Support</h4>
                                        <ul>
                                            <li><a href="#">Design & creatives</a></li>
                                            <li><a href="#">Telecommunication</a></li>
                                            <li><a href="#">Restaurant</a></li>
                                            <li><a href="#">Programing</a></li>
                                            <li><a href="#">Architecture</a></li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xl-2 col-lg-3 col-md-4 col-sm-6">
                                <div class="single-footer-caption mb-50">
                                    <div class="footer-tittle">
                                        <h4>Company</h4>
                                        <ul>
                                            <li><a href="#">Design & creatives</a></li>
                                            <li><a href="#">Telecommunication</a></li>
                                            <li><a href="#">Restaurant</a></li>
                                            <li><a href="#">Programing</a></li>
                                            <li><a href="#">Architecture</a></li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- footer-bottom area -->
                <div class="footer-bottom-area">
                    <div class="container">
                        <div class="footer-border">
                            <div class="row d-flex align-items-center">
                                <div class="col-xl-12 ">
                                    <div class="footer-copy-right text-center">
                                        <p><!-- Link back to Colorlib can't be removed. Template is licensed under CC BY 3.0. -->
                                            Copyright &copy;<script>document.write(new Date().getFullYear());</script> All rights reserved | This template is made with <i class="fa fa-heart" aria-hidden="true"></i> by <a href="https://colorlib.com" target="_blank">Colorlib</a>
                                            <!-- Link back to Colorlib can't be removed. Template is licensed under CC BY 3.0. --></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Footer End-->
            </div>

        </footer> 
        <!-- Scroll Up -->
        <div id="back-top" >
            <a title="Go to Top" href="#"> <i class="fas fa-level-up-alt"></i></a>
        </div>

        <!-- JS here -->
        <script src="./assets/js/vendor/modernizr-3.5.0.min.js"></script>
        <!-- Jquery, Popper, Bootstrap -->
        <script src="./assets/js/vendor/jquery-1.12.4.min.js"></script>
        <script src="./assets/js/popper.min.js"></script>
        <script src="./assets/js/bootstrap.min.js"></script>
        <!-- Jquery Mobile Menu -->
        <script src="./assets/js/jquery.slicknav.min.js"></script>

        <!-- Jquery Slick , Owl-Carousel Plugins -->
        <script src="./assets/js/owl.carousel.min.js"></script>
        <script src="./assets/js/slick.min.js"></script>
        <!-- One Page, Animated-HeadLin -->
        <script src="./assets/js/wow.min.js"></script>
        <script src="./assets/js/animated.headline.js"></script>
        <script src="./assets/js/jquery.magnific-popup.js"></script>

        <!-- Date Picker -->
        <script src="./assets/js/gijgo.min.js"></script>
        <!-- Nice-select, sticky -->
        <script src="./assets/js/jquery.nice-select.min.js"></script>
        <script src="./assets/js/jquery.sticky.js"></script>
        <!-- Progress -->
        <script src="./assets/js/jquery.barfiller.js"></script>

        <!-- counter , waypoint,Hover Direction -->
        <script src="./assets/js/jquery.counterup.min.js"></script>
        <script src="./assets/js/waypoints.min.js"></script>
        <script src="./assets/js/jquery.countdown.min.js"></script>
        <script src="./assets/js/hover-direction-snake.min.js"></script>

        <!-- contact js -->
        <script src="./assets/js/contact.js"></script>
        <script src="./assets/js/jquery.form.js"></script>
        <script src="./assets/js/jquery.validate.min.js"></script>
        <script src="./assets/js/mail-script.js"></script>
        <script src="./assets/js/jquery.ajaxchimp.min.js"></script>

        <!-- Jquery Plugins, main Jquery -->	
        <script src="./assets/js/plugins.js"></script>
        <script src="./assets/js/main.js"></script>
        <script src="./assets/js/main.js"></script>

    </body>
</html>
