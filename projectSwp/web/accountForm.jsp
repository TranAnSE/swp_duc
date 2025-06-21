<%-- 
    Document   : accountForm
    Created on : May 23, 2025, 11:16:10 AM
    Author     : BuiNgocLinh
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>

    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title><c:choose>
                <c:when test="${not empty account}">Edit</c:when>
                <c:otherwise>Add</c:otherwise>
            </c:choose>
        </title>
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
        <main>
            <div class="container mt-5 mb-5">
                <div class="row justify-content-center">
                    <div class="col-md-8 col-lg-6">
                        <h2 class="mb-4">${empty account ? "Add New Account" : "Edit Account"}</h2>

                        <form action="admin" method="post" enctype="multipart/form-data">
                            <c:if test="${not empty account}">
                                <input type="hidden" name="id" value="${account.id}" />
                                <input type="hidden" name="action" value="editAccount" />
                            </c:if>
                            <c:if test="${empty account}">
                                <input type="hidden" name="action" value="createAccount" />
                            </c:if>

                            <div class="mb-3">
                                <label class="form-label">Email:</label>
                                <input type="email" name="email" class="form-control" value="${account.email}" required />
                            </div>

                            <c:choose>
                                <c:when test="${not empty account}">
                                    <!-- Edit mode - show old and new password fields -->
                                    <div class="mb-3">
                                        <label class="form-label">Current Password:</label>
                                        <div class="input-group">
                                            <input type="password" name="oldPassword" id="oldPassword" class="form-control" />
                                            <button type="button" class="btn btn-outline-secondary" onclick="togglePassword('oldPassword')">
                                                <i class="fas fa-eye" id="oldPasswordIcon"></i>
                                            </button>
                                        </div>
                                        <c:if test="${not empty passwordError}">
                                            <small class="text-danger">${passwordError}</small>
                                        </c:if>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">New Password:</label>
                                        <div class="input-group">
                                            <input type="password" name="password" id="newPassword" class="form-control" />
                                            <button type="button" class="btn btn-outline-secondary" onclick="togglePassword('newPassword')">
                                                <i class="fas fa-eye" id="newPasswordIcon"></i>
                                            </button>
                                        </div>
                                        <small class="text-muted">Leave blank if you don't want to change password</small>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <!-- Create mode - show only one password field -->
                                    <div class="mb-3">
                                        <label class="form-label">Password:</label>
                                        <div class="input-group">
                                            <input type="password" name="password" id="newPassword" class="form-control" value="${account.password}" required />
                                            <button type="button" class="btn btn-outline-secondary" onclick="togglePassword('newPassword')">
                                                <i class="fas fa-eye" id="newPasswordIcon"></i>
                                            </button>
                                        </div>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                            <script>
                                function togglePassword(fieldId) {
                                    var input = document.getElementById(fieldId);
                                    var icon = document.getElementById(fieldId + 'Icon');
                                    if (input.type === 'password') {
                                        input.type = 'text';
                                        icon.classList.remove('fa-eye');
                                        icon.classList.add('fa-eye-slash');
                                    } else {
                                        input.type = 'password';
                                        icon.classList.remove('fa-eye-slash');
                                        icon.classList.add('fa-eye');
                                    }
                                }
                            </script>

                            <div class="mb-3">
                                <label class="form-label">Full Name:</label>
                                <input type="text" name="full_name" class="form-control" value="${account.full_name}" required />
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Role:</label>
                                <input type="text" name="role" class="form-control" value="${account.role}" required />
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Status:</label>
                                <input type="text" name="status" class="form-control" value="${account.status}" required />
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Sex:</label>
                                <select name="sex" class="form-select" required>
                                    <option value="">--Select Sex--</option>
                                    <option value="0" ${account.sex == 0 ? "selected" : ""}>Male</option>
                                    <option value="1" ${account.sex == 1 ? "selected" : ""}>Female</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Date of Birth:</label>
                                <input type="date" name="dob" class="form-control" value="${account.dob}" />
                            </div>

                            <c:if test="${image.id == account.image_id}">
                                <div class="mb-3">
                                    <label class="form-label">Current Avatar:</label><br/>
                                    <img src="${pageContext.request.contextPath}/${not empty image.image_data ? image.image_data : 'assets/img/avatar/macdinh.jpg'}"
                                         alt="Ảnh cá nhân" class="img-thumbnail" width="200" height="200"/>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">New Avatar:</label>
                                    <input type="file" name="imgURL" class="form-control"/>
                                </div>
                            </c:if>

                            <div class="d-flex justify-content-between">
                                <button type="submit" class="btn btn-success">${empty account ? "Create" : "Update"}</button>
                                <a href="admin?action=listAccount" class="btn btn-secondary">Back</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </main>


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