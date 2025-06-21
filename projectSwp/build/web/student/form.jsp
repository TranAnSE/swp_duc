<%-- 
    Document   : form
    Created on : May 21, 2025, 11:30:09 PM
    Author     : BuiNgocLinh
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>${student == null ? "Add student" : "Edit Student"}</title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="manifest" href="site.webmanifest">
        <link rel="shortcut icon" type="image/x-icon" href="assets/img/favicon.ico">

        <!-- CSS here -->
        <link rel="stylesheet" href="/assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="/assets/css/owl.carousel.min.css">
        <link rel="stylesheet" href="/assets/css/slicknav.css">
        <link rel="stylesheet" href="/assets/css/flaticon.css">
        <link rel="stylesheet" href="/assets/css/progressbar_barfiller.css">
        <link rel="stylesheet" href="/assets/css/gijgo.css">
        <link rel="stylesheet" href="/assets/css/animate.min.css">
        <link rel="stylesheet" href="/assets/css/animated-headline.css">
        <link rel="stylesheet" href="/assets/css/magnific-popup.css">
        <link rel="stylesheet" href="/assets/css/fontawesome-all.min.css">
        <link rel="stylesheet" href="/assets/css/themify-icons.css">
        <link rel="stylesheet" href="/assets/css/slick.css">
        <link rel="stylesheet" href="/assets/css/nice-select.css">
        <link rel="stylesheet" href="/assets/css/style.css">
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
                padding-top: 130px; /* Tăng khoảng cách để không bị che */
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

            /* ==== FORM STYLING ==== */
            form {
                background: #ffffff;
                padding: 30px;
                margin: 20px auto;
                border-radius: 10px;
                max-width: 700px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                font-size: 16px;
            }

            /* INPUT, SELECT, DATE, TEXT */
            form input[type="text"],
            form input[type="email"],
            form input[type="password"],
            form input[type="date"],
            form select {
                width: 100%;
                max-width: 500px;
                padding: 10px 14px;
                margin: 10px 0 20px;
                font-size: 16px;
                border-radius: 6px;
                border: 1px solid #ced4da;
                box-sizing: border-box;
                background-color: #fdfdfd;
                transition: border-color 0.3s ease;
            }

            form input[type="text"]:focus,
            form input[type="email"]:focus,
            form input[type="password"]:focus,
            form input[type="date"]:focus,
            form select:focus {
                border-color: #007bff;
                outline: none;
            }

            /* ==== LABEL ==== */
            form label {
                font-weight: 600;
                display: block;
                margin-bottom: 5px;
                color: #333;
            }

            /* ==== RADIO ==== */
            form input[type="radio"] {
                width: 18px;
                height: 18px;
                margin-right: 6px;
                vertical-align: middle;
            }

            form label[for^="sex"] {
                margin-right: 15px;
                font-weight: 500;
                vertical-align: middle;
            }

            /* ==== IMAGE PREVIEW ==== */
            form img {
                display: block;
                margin: 10px 0;
                border-radius: 8px;
                object-fit: cover;
                max-width: 200px;
                height: auto;
            }

            /* ==== BUTTONS ==== */
            form input[type="submit"],
            form a {
                display: inline-block;
                margin-top: 15px;
                padding: 10px 20px;
                font-weight: bold;
                font-size: 16px;
                border-radius: 6px;
                border: none;
                text-decoration: none;
                color: #fff;
                background-color: #28a745;
                transition: background-color 0.3s ease;
            }

            form input[type="submit"]:hover,
            form a:hover {
                background-color: #218838;
            }

            /* ==== ERROR MESSAGE ==== */
            .text-danger {
                color: red;
                font-size: 0.9em;
                font-weight: bold;
                margin-top: -10px;
                margin-bottom: 15px;
                display: block;
                text-align: left;
            }

            /* ==== FORM HEADER ==== */
            main h2 {
                text-align: center;
                font-weight: 700;
                color: #343a40;
                margin-bottom: 30px;
            }

        </style>
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
            
            function previewImage(event) {
                const file = event.target.files[0];
                const reader = new FileReader();
                reader.onload = function () {
                    const output = document.getElementById('avatarPreview');
                    output.src = reader.result;
                };
                if (file) {
                    reader.readAsDataURL(file);
                }
            }
        </script>
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
                        <div class="header-bottom  header-sticky">
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
                                                        <li class="active" ><a href="#">Home</a></li>
                                                        <li><a href="#">Courses</a></li>
                                                        <li><a href="#">About</a></li>
                                                        <li><a href="#">Blog</a>
                                                            <ul class="submenu">
                                                                <li><a href="#">Blog</a></li>
                                                                <li><a href="#">Blog Details</a></li>
                                                                <li><a href="#">Element</a></li>
                                                            </ul>
                                                        </li>
                                                        <li><a href="#">Contact</a></li>
                                                        Button 
                                                        <li class="button-header"><a href="/LessonURL" class="btn btn3">Lesson</a></li>
                                                        <li class="button-header"><a href="/subjects" class="btn btn3">subjects</a></li>
                                                        <li class="button-header"><a href="/Grade" class="btn btn3">Grades</a></li>
                                                        <li class="button-header"><a href="/Question" class="btn btn3">Questions</a></li>
        
        
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

        <%@include file="../header.jsp" %>

        <form action="student" method="post" enctype="multipart/form-data">
            <h2>${student == null ? "Add student" : "Edit Student"}</h2>
            <input type="hidden" name="action" value="${student == null ? "create" : "edit"}" />

            <c:if test="${student != null}">
                ID: <input type="text" name="id" value="${student.id}" readonly required/><br/>
            </c:if>
            <label for="grade_id">Grade:</label>
            <select name="grade_id" id="grade_id" required>
                <c:forEach var="grade" items="${gradeList}">
                    <option value="${grade.id}" ${grade.id == student.grade_id ? 'selected' : ''}>${grade.name}</option>
                </c:forEach>
            </select>
            <br/>
            <br/>
            <label for="parent_id">Parent:</label>
            <c:choose>
                <c:when test="${isParentCreating}">
                    <!-- Parent đang tạo con, không cho phép chọn parent khác -->
                    <c:forEach var="parent" items="${accList}">
                        <c:if test="${parent.role == 'parent' && parent.id == currentParentId}">
                            <input type="hidden" name="parent_id" value="${parent.id}" />
                            <input type="text" value="${parent.full_name}" readonly style="background-color: #f8f9fa;" />
                        </c:if>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <!-- Admin/Teacher có thể chọn parent -->
                    <select name="parent_id" id="parent_id" required>
                        <c:forEach var="parent" items="${accList}">
                            <c:if test="${parent.role == 'parent'}">
                                <option value="${parent.id}" ${parent.id == student.parent_id ? 'selected' : ''}>${parent.full_name}</option>
                            </c:if>
                        </c:forEach>
                    </select>
                </c:otherwise>
            </c:choose>
            <br/>
            <br/>
            Username: <input type="text" name="username" value="${student.username}" required/><br/>
            <c:choose>
                <c:when test="${not empty student}">
                    <!-- Edit mode - show old and new password fields -->
                    <div class="mb-3">
                        <label class="form-label">Current Password:</label>
                        <div class="input-group">
                            <input type="password" name="oldPassword" id="oldPassword" class="form-control" required />
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
                            <input type="password" name="password" id="newPassword" class="form-control" value="${student.password}" required />
                            <button type="button" class="btn btn-outline-secondary" onclick="togglePassword('newPassword')">
                                <i class="fas fa-eye" id="newPasswordIcon"></i>
                            </button>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
            Full Name: <input type="text" name="full_name" value="${student.full_name}" required/><br/>
            DOB: <input type="date" name="dob" value="${student.dob}" required/><br/>

            Sex:<br/>
            <select name="sex">
                <option value="true" ${student.sex ? "selected" : ""}>Male</option>
                <option value="false" ${!student.sex ? "selected" : ""}>Female</option>
            </select>
            <br/>
            <br/>

            <c:if test="${image.id == student.image_id}">
                <div class="mb-3">
                    <label class="form-label">Avatar:</label><br/>
                    <img id="avatarPreview"
                         src="${pageContext.request.contextPath}/${not empty image.image_data ? image.image_data : 'assets/img/avatar/macdinh.jpg'}"
                         alt="Ảnh cá nhân" width="200" height="200"/>
                </div>
                <div class="mb-3">
                    <label class="form-label">New avatar:</label>
                    <input type="file" name="imgURL" class="form-control" onchange="previewImage(event)"/>
                </div>
            </c:if>
            <input type="submit" value="${student == null ? "Add" : "update"}"/>
            <c:choose>
                <c:when test="${isParentCreating}">
                    <a href="${pageContext.request.contextPath}/parent?action=myChildren" class="btn btn-secondary">Back to My Children</a>
                </c:when>
                <c:otherwise>
                    <a href="student" class="btn btn-secondary">Back</a>
                </c:otherwise>
            </c:choose>
        </form>
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
        <script src="${pageContext.request.contextPath}/assets/js/vendor/modernizr-3.5.0.min.js"></script>
        <!-- Jquery, Popper, Bootstrap -->
        <script src="${pageContext.request.contextPath}/assets/js/vendor/jquery-1.12.4.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/popper.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>
        <!-- Jquery Mobile Menu -->
        <script src="${pageContext.request.contextPath}/assets/js/jquery.slicknav.min.js"></script>

        <!-- Jquery Slick , Owl-Carousel Plugins -->
        <script src="${pageContext.request.contextPath}/assets/js/owl.carousel.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/slick.min.js"></script>
        <!-- One Page, Animated-HeadLin -->
        <script src="${pageContext.request.contextPath}/assets/js/wow.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/animated.headline.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.magnific-popup.js"></script>

        <!-- Date Picker -->
        <script src="${pageContext.request.contextPath}/assets/js/gijgo.min.js"></script>
        <!-- Nice-select, sticky -->
        <script src="${pageContext.request.contextPath}/assets/js/jquery.nice-select.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.sticky.js"></script>
        <!-- Progress -->
        <script src="${pageContext.request.contextPath}/assets/js/jquery.barfiller.js"></script>

        <!-- counter , waypoint,Hover Direction -->
        <script src="${pageContext.request.contextPath}/assets/js/jquery.counterup.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/waypoints.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.countdown.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/hover-direction-snake.min.js"></script>

        <!-- contact js -->
        <script src="${pageContext.request.contextPath}/assets/js/contact.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.form.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.validate.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/mail-script.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.ajaxchimp.min.js"></script>

        <!-- Jquery Plugins, main Jquery -->	
        <script src="${pageContext.request.contextPath}/assets/js/plugins.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>

    </body>
</html>