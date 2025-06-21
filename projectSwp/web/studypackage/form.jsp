<%-- 
    Document   : form
    Created on : Jun 1, 2025, 1:46:39 AM
    Author     : Na
--%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>${studyPackageToEdit == null ? 'Thêm Gói Học' : 'Sửa Gói Học'}</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="manifest" href="site.webmanifest">
    <link rel="shortcut icon" type="image/x-icon" href="assets/img/favicon.ico">

    <!-- CSS here -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/owl.carousel.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/slicknav.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/flaticon.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/progressbar_barfiller.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/gijgo.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/animate.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/animated-headline.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/magnific-popup.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fontawesome-all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/themify-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/slick.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/nice-select.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .text-danger {
            color: red;
            font-size: 0.875em;
        }
        .text-success {
            color: green;
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
            padding-top: 130px;
        }
        main {
            background-color: #f8f9fa;
            padding: 30px 15px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            margin: 20px auto;
            max-width: 1200px;
        }
        main h2 {
            text-align: center;
            font-weight: 700;
            color: #343a40;
            margin-bottom: 30px;
        }
        /* Form thêm/sửa */
        form[method="post"] {
            background: #ffffff;
            padding: 30px;
            margin: 20px auto;
            border-radius: 10px;
            max-width: 1200px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            font-size: 16px;
            display: flex;
            align-items: flex-end;
            gap: 15px;
            flex-wrap: wrap;
        }
        form[method="post"] .form-group {
            display: flex;
            flex-direction: column;
            margin-bottom: 0;
        }
        form[method="post"] input[type="text"],
        form[method="post"] input[type="number"] {
            width: 200px;
            padding: 8px 12px;
            font-size: 14px;
            border-radius: 6px;
            border: 1px solid #ced4da;
            box-sizing: border-box;
            background-color: #fdfdfd;
            transition: border-color 0.3s ease;
        }
        form[method="post"] input[type="text"]:focus,
        form[method="post"] input[type="number"]:focus {
            border-color: #007bff;
            outline: none;
        }
        form[method="post"] label {
            font-weight: 600;
            display: block;
            margin-bottom: 5px;
            color: #333;
        }
        form[method="post"] input[type="submit"],
        form[method="post"] a {
            padding: 8px 15px;
            font-size: 14px;
            border-radius: 6px;
            border: none;
            text-decoration: none;
            color: #fff;
            background-color: #28a745;
            transition: background-color 0.3s ease;
        }
        form[method="post"] a {
            background-color: #6c757d;
        }
        form[method="post"] input[type="submit"]:hover,
        form[method="post"] a:hover {
            background-color: #218838;
        }
        form[method="post"] a:hover {
            background-color: #5a6268;
        }
        /* Thông báo */
        .text-danger, .text-success {
            font-size: 0.9em;
            font-weight: bold;
            margin: 10px 0;
            text-align: center;
        }
    </style>
</head>
<body>
    <!-- Preloader Start -->
    <div id="preloader-active">
        <div class="preloader d-flex align-items-center justify-content-center">
            <div class="preloader-inner position-relative">
                <div class="preloader-circle"></div>
                <div class="preloader-img pere-text">
                    <img src="${pageContext.request.contextPath}/assets/img/logo/loder.png" alt="">
                </div>
            </div>
        </div>
    </div>
    <!-- Preloader End -->

    <%@include file="../header.jsp" %>

    <main>
        <h2>${studyPackageToEdit == null ? 'Add new Study Package' : 'Edit Study Package'}</h2>

        <!-- Thông báo lỗi và thành công -->
        <c:if test="${not empty errorMessage}">
            <div class="text-danger"><c:out value="${errorMessage}"/></div>
        </c:if>
        <c:if test="${not empty message}">
            <div class="text-success"><c:out value="${message}"/></div>
        </c:if>

        <!-- Form thêm/sửa gói học -->
        <form action="study_package" method="post">
            <input type="hidden" name="service" value="${studyPackageToEdit == null ? 'add' : 'update'}" />
            <c:if test="${not empty studyPackageToEdit}">
                <input type="hidden" name="id" value="${studyPackageToEdit.id}" />
            </c:if>
            <div class="form-group">
                <label for="id">ID</label>
                <input type="number" name="id" id="id" value="${studyPackageToEdit != null ? studyPackageToEdit.id : ''}" 
                       ${studyPackageToEdit != null ? 'readonly' : ''} required placeholder="enter ID" min="1" />
            </div>
            <div class="form-group">
                <label for="name">Name</label>
                <input type="text" name="name" id="name" value="${studyPackageToEdit != null ? studyPackageToEdit.name : ''}" 
                       required placeholder="enter Name" maxlength="100" />
            </div>
            <div class="form-group">
                <label for="price">Price</label>
                <input type="text" name="price" id="price" value="${studyPackageToEdit != null ? studyPackageToEdit.price : ''}" 
                       required placeholder="enter Price" maxlength="20" />
            </div>
            <div>
                <input type="submit" value="${studyPackageToEdit == null ? 'Creat' : 'Save'}" />
                <a href="study_package">Back</a>
            </div>
        </form>
    </main>

    <%@include file="../footer.jsp" %>
    <div id="back-top">
        <a title="Go to Top" href="#"> <i class="fas fa-level-up-alt"></i></a>
    </div>

    <!-- JS here -->
    <script src="${pageContext.request.contextPath}/assets/js/vendor/modernizr-3.5.0.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/vendor/jquery-1.12.4.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/popper.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.slicknav.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/owl.carousel.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/slick.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/wow.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/animated.headline.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.magnific-popup.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/gijgo.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.nice-select.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.sticky.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.barfiller.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.counterup.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/waypoints.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.countdown.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/hover-direction-snake.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/contact.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.form.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.validate.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/mail-script.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.ajaxchimp.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/plugins.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
