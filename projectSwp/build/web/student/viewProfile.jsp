<%-- 
    Document   : viewProfile
    Created on : May 28, 2025, 10:55:02 PM
    Author     : BuiNgocLinh
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html class="no-js" lang="zxx">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>View Profile</title>
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
        <%@include file="../header.jsp" %>
        <main>
            <div class="container mt-5 mb-5">
                <div class="row justify-content-center">
                    <div class="col-md-6">
                        <h2 class="mb-4">My Profile</h2>

                        <table class="table table-bordered">
                            <tbody>
                                <tr>
                                    <th scope="row">Name:</th>
                                    <td>${view.full_name}</td>
                                </tr>
                                <tr>
                                    <th scope="row">Username:</th>
                                    <td>${view.username}</td>
                                </tr>
                                <tr>
                                    <th scope="row">Sex:</th>
                                    <td>
                                        <c:choose>
                                            <c:when test="${view.sex}">Male</c:when>
                                            <c:otherwise>Female</c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Date of birth:</th>

                                    <td><fmt:formatDate value="${view.getFormattedDate()}" pattern="dd/MM/yyyy" /></td>
                                </tr>
                                <tr>
                                    <th scope="row">Parent:</th>
                                    <td>
                                        <c:forEach items="${accList}" var="a">
                                            <c:if test="${a.id == view.parent_id}">
                                                ${a.full_name}
                                            </c:if>
                                        </c:forEach>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Grade:</th>
                                    <td>
                                        <c:forEach items="${gradeList}" var="g">
                                            <c:if test="${g.id == view.grade_id}">
                                                ${g.name}
                                            </c:if>
                                        </c:forEach>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Avatar:</th>
                                    <td>
                                        <c:forEach items="${imageList}" var="i">
                                            <c:if test="${i.id == view.image_id}">
                                                <img src="${pageContext.request.contextPath}/${not empty i.image_data ? i.image_data : 'assets/img/avatar/macdinh.jpg'}"
                                                     alt="Avatar" class="img-fluid img-thumbnail" style="max-width: 200px; height: auto;" />
                                            </c:if>
                                        </c:forEach>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <a href="student?action=edit&id=${view.id}" class="btn btn-warning btn-sm">
                                            Update
                                        </a>
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                    </div>
                </div>
            </div>
        </main>





        <%@include file="../footer.jsp" %>
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
