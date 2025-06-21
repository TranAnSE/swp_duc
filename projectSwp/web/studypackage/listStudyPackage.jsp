<%-- 
    Document   : listStudyPackage
    Created on : Jun 2, 2025, 12:37:58 AM
    Author     : Na
    Modified   : Tách form thêm/sửa thành trang riêng (studyPackageForm.jsp), tích hợp header/footer
--%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>Quản lý Gói Học</title>
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
        /* Form tìm kiếm */
        form[method="get"] {
            display: flex;
            align-items: flex-end;
            gap: 15px;
            flex-wrap: wrap;
            justify-content: center;
            margin-bottom: 30px;
            background: #ffffff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        form[method="get"] .form-group {
            display: flex;
            flex-direction: column;
            margin-bottom: 0;
        }
        form[method="get"] label {
            font-weight: 600;
            color: #333;
            margin-bottom: 5px;
        }
        form[method="get"] input[type="text"],
        form[method="get"] input[type="number"] {
            width: 200px;
            padding: 8px 12px;
            font-size: 14px;
            border-radius: 6px;
            border: 1px solid #ced4da;
            box-sizing: border-box;
            background-color: #fdfdfd;
            transition: border-color 0.3s ease;
        }
        form[method="get"] input[type="text"]:focus,
        form[method="get"] input[type="number"]:focus {
            border-color: #007bff;
            outline: none;
        }
        form[method="get"] input[type="submit"],
        form[method="get"] button {
            padding: 8px 15px;
            font-size: 14px;
            border-radius: 6px;
            border: none;
            text-decoration: none;
            color: #fff;
            background-color: #28a745;
            transition: background-color 0.3s ease;
        }
        form[method="get"] button[type="button"] {
            background-color: #6c757d;
        }
        form[method="get"] input[type="submit"]:hover,
        form[method="get"] button:hover {
            background-color: #218838;
        }
        form[method="get"] button[type="button"]:hover {
            background-color: #5a6268;
        }
        /* Nút thêm mới */
        .add-btn {
            display: inline-block;
            margin-bottom: 20px;
            padding: 8px 15px;
            font-size: 14px;
            border-radius: 6px;
            text-decoration: none;
            color: #fff;
            background-color: #28a745;
            transition: background-color 0.3s ease;
        }
        .add-btn:hover {
            background-color: #218838;
        }
        /* Bảng */
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
        table.table .btn {
            margin: 2px;
            font-size: 14px;
            padding: 5px 10px;
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
        <h2>Manage Study Packages</h2>

        <!-- Thông báo lỗi và thành công -->
        <c:if test="${not empty errorMessage}">
            <div class="text-danger"><c:out value="${errorMessage}"/></div>
        </c:if>
        <c:if test="${not empty message}">
            <div class="text-success"><c:out value="${message}"/></div>
        </c:if>

        <!-- Form tìm kiếm -->
        <script>
            function validateSearchForm() {
                const id = document.getElementById("id").value.trim();
                const name = document.getElementById("name").value.trim();
                const price = document.getElementById("price").value.trim();
                
                if (!id && !name && !price) {
                    alert("Please enter at least one search criterion (ID, Name, or Price).");
                    return false;
                }
                return true;
            }
        </script>

        <form method="get" action="study_package" onsubmit="return validateSearchForm()">
            <input type="hidden" name="service" value="search" />
            <div class="form-group">
                <label for="id">ID</label>
                <input type="text" name="id" id="id" placeholder="enter ID" value="${param.id != null ? param.id : ''}" />
            </div>
            <div class="form-group">
                <label for="name">Name</label>
                <input type="text" name="name" id="name" placeholder="enter name" value="${param.name != null ? param.name : ''}" />
            </div>
            <div class="form-group">
                <label for="price">Price</label>
                <input type="text" name="price" id="price" placeholder="enter price" value="${param.price != null ? param.price : ''}" />
            </div>
            <div>
                <input type="submit" value="Find" />
                <button type="button" onclick="window.location.href = 'study_package'">Del Find</button>
            </div>
        </form>

        <!-- Nút thêm gói học mới -->
        <div style="text-align: center;">
            <a href="study_package?service=add" class="add-btn">Add new Study Package</a>
        </div>

        <!-- Bảng danh sách gói học -->
        <h2>Study Package</h2>
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Price</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty listStudyPackage}">
                        <c:forEach var="sp" items="${listStudyPackage}">
                            <tr>
                                <td><c:out value="${sp.id}"/></td>
                                <td><c:out value="${sp.name}"/></td>
                                <td><c:out value="${sp.price}"/></td>
                                <td>
                                    <a href="study_package?service=edit&editId=${sp.id}" class="btn btn-primary btn-sm">Edit</a>
                                    <form method="post" action="study_package" style="display:inline-block;" onsubmit="return confirm('Bạn có chắc chắn muốn xóa ID ${sp.id}?');">
                                        <input type="hidden" name="service" value="delete" />
                                        <input type="hidden" name="id" value="${sp.id}" />
                                        <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                                    </form>
                                    <!-- Nút thanh toán -->
                                    <form method="post" action="study_package" style="display:inline-block;" onsubmit="return confirm('Bạn có chắc chắn muốn thanh toán gói học này?');">
                                        <input type="hidden" name="service" value="checkout" />
                                        <input type="hidden" name="id" value="${sp.id}" />
                                        <button type="submit" class="btn btn-success btn-sm">Thanh toán</button>
                                    </form>
                                </td>

                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr><td colspan="4">No data available</td></tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
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