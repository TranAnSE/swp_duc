<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Create Account</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
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
            .text-danger {
                color: red;
                font-size: 0.875em;
            }
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
            /* Đặt chiều rộng cố định và nhất quán cho input, select */
            form input[type="email"],
            form input[type="password"],
            form input[type="text"],
            form input[type="date"],
            form select {
                width: 100%;       /* chiếm hết chiều ngang container cha */
                max-width: 400px;  /* hoặc giá trị bạn muốn */
                height: 40px;      /* chiều cao cố định */
                padding: 6px 12px; /* khoảng cách trong ô */
                box-sizing: border-box; /* tính padding và border vào chiều rộng */
                border-radius: 6px;
                border: 1px solid #ced4da;
                font-size: 16px;
            }


            /* Đối với radio thì cho khoảng cách và size đồng bộ */
            form input[type="radio"] {
                width: 20px;
                height: 20px;
                margin-right: 6px;
                vertical-align: middle;
            }

            /* Đảm bảo label nằm sát với radio */
            form label[for^="sex"] {
                margin-right: 15px;
                font-weight: 500;
                vertical-align: middle;
            }

            /* Giữ khoảng cách giữa các nhóm radio */
            .mb-3 .form-check {
                margin-bottom: 8px;
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
    <body>
        <div class="container mt-5">
            <h2 class="mb-4">Create Account</h2>

            <form id="accountForm" action="admin" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="createAccount"/>
                <!-- Email -->
                <div class="mb-3">
                    <label for="email" class="form-label">Email</label>
                    <input type="text" class="form-control" id="email" name="email">
                    <span class="text-danger" id="emailError"></span>
                </div>

                <!-- Password -->
                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" class="form-control" id="password" name="password">
                    <span class="text-danger" id="passwordError"></span>
                </div>

                <!-- Full Name -->
                <div class="mb-3">
                    <label for="full_name" class="form-label">Name</label>
                    <input type="text" class="form-control" id="full_name" name="full_name">
                    <span class="text-danger" id="fullNameError"></span>
                </div>

                <!-- Ngày sinh -->
                <div class="mb-3">
                    <label for="dob" class="form-label">Date of birth</label>
                    <input type="date" class="form-control" id="dob" name="dob">
                    <span class="text-danger" id="dobError"></span>
                </div>

                <!-- Giới tính -->
                <div class="mb-3">
                    <label class="form-label">Sex</label><br>
                    <input type="radio" name="sex" value="1" id="sexMale"> Male
                    <input type="radio" name="sex" value="0" id="sexFemale"> Female
                    <br>
                    <span class="text-danger" id="sexError"></span>
                </div>

                <!-- Role -->
                <div class="mb-3">
                    <label for="role" class="form-label">Role</label>
                    <select class="form-select" id="role" name="role">
                        <option value="">----</option>
                        <option value="student">Student</option>
                        <option value="parent">Parent</option>
                        <option value="teacher">Teacher</option>
                    </select>
                    <span class="text-danger" id="roleError"></span>
                </div>

                <!-- Status -->
                <div class="mb-3">
                    <label for="status" class="form-label">Status</label>
                    <select class="form-select" id="status" name="status">
                        <option value="">----</option>
                        <option value="active" >Active</option>
                        <option value="inactive">Inactive</option>
                    </select>
                    <span class="text-danger" id="statusError"></span>
                </div>

                <!-- Ảnh đại diện -->
                <div class="mb-3">
                    <label for="imgURL" class="form-label">Avatar</label>
                    <input type="file" class="form-control" id="imgURL" name="imgURL" accept="image/*">
                    <span class="text-danger" id="imgError"></span>
                </div>

                <!-- Submit -->
                <button type="submit" class="btn btn-primary">Add</button>
            </form>


            <c:if test="${not empty error}">
                <div class="alert alert-danger mt-3">${error}</div>
            </c:if>
        </div>
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
        <script>
            document.getElementById("accountForm").addEventListener("submit", function (e) {
                let isValid = true;

                // Lấy giá trị các trường
                const email = document.getElementById("email").value.trim();
                const password = document.getElementById("password").value.trim();
                const fullName = document.getElementById("full_name").value.trim();
                const dob = document.getElementById("dob").value;
                const sexMale = document.getElementById("sexMale").checked;
                const sexFemale = document.getElementById("sexFemale").checked;
                const role = document.getElementById("role").value;
                const status = document.getElementById("status").value;
                const imgFile = document.getElementById("imgURL").files[0];

                const errorFields = [
                    "emailError", "passwordError", "fullNameError", "dobError",
                    "sexError", "roleError", "statusError", "imgError"
                ];
                errorFields.forEach(id => document.getElementById(id).innerText = "");

                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailRegex.test(email)) {
                    document.getElementById("emailError").innerText = "Invalid email.";
                    isValid = false;
                }

                if (password.length < 6) {
                    document.getElementById("passwordError").innerText = "Password must be at least 6 characters.";
                    isValid = false;
                }

                if (fullName === "") {
                    document.getElementById("fullNameError").innerText = "Please enter your full name.";
                    isValid = false;
                }

                if (dob === "") {
                    document.getElementById("dobError").innerText = "Please select date of birth.";
                    isValid = false;
                }

                if (!sexMale && !sexFemale) {
                    document.getElementById("sexError").innerText = "Please select gender.";
                    isValid = false;
                }

                if (role === "") {
                    document.getElementById("roleError").innerText = "Please select role.";
                    isValid = false;
                }

                if (status === "") {
                    document.getElementById("statusError").innerText = "Please select status.";
                    isValid = false;
                }

                if (!imgFile) {
                    document.getElementById("imgError").innerText = "Please select an avatar.";
                    isValid = false;
                }

                if (!isValid) {
                    e.preventDefault();
                }
            });
        </script>

    </script>

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
