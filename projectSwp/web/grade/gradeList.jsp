<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
    <head>
        <title>Grade List</title>

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
        <link rel="shortcut icon" type="image/x-icon" href="assets/img/favicon.ico">

        <!-- External CSS -->
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

        <!-- Custom style -->
        <style>
            body {
                padding-top: 100px; /* tránh bị header che */
            }

            .search-box {
                height: 45px;
                width: 300px;
                font-size: 16px;
                padding: 6px 12px;
            }

            .search-button {
                height: 45px;
                font-size: 16px;
                padding: 6px 20px;
            }
        </style>
    </head>
    <body>

        <jsp:include page="../header.jsp" />

        <div class="container mt-4">
            <h2 class="mb-4">Grade List</h2>

            <!-- Form search -->
            <form method="get" action="../Grade" class="row g-3 mb-3">
                <div class="col-auto">
                    <input type="text" name="name" class="form-control search-box" placeholder="Search by name" />
                </div>
                <div class="col-auto">
                    <button type="submit" class="btn btn-primary search-button">Search</button>
                </div>
            </form>

            <!-- Hiển thị lỗi -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <!-- Bảng danh sách -->
            <table class="table table-bordered table-striped align-middle">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Description</th>
                        <th>Teacher Name</th>  
                        <th>Actions</th>              
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="gra" items="${requestScope.gradeList}">
                        <tr>
                            <td>${gra.id}</td>
                            <td>${gra.name}</td>
                            <td>${gra.description}</td>
                            <td>
                                <c:forEach var="acc" items="${accounts}">
                                    <c:if test="${acc.id eq gra.teacher_id}">
                                        ${acc.full_name}
                                    </c:if>
                                </c:forEach>
                            </td>
                            <td>
                                <a href="../Grade?action=updateForm&id=${gra.id}" class="btn btn-sm btn-warning">Update</a> 
                                <a href="../Grade?action=delete&id=${gra.id}" 
                                   onclick="return confirm('Are you sure to delete grade ID ${gra.id}?');" 
                                   class="btn btn-sm btn-danger ms-1">Delete</a>
                            </td>               
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <!-- Nút thêm mới -->
            <a href="../Grade?action=addForm" class="btn btn-success">Add New Grade</a>

            <!-- Hiển thị thông báo -->
            <c:if test="${not empty message}">
                <div class="alert alert-success mt-3">${message}</div>
            </c:if>
        </div>

        <!-- Include footer -->
        <jsp:include page="../footer.jsp" />

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <!-- JS Libraries -->
        <script src="./assets/js/vendor/modernizr-3.5.0.min.js"></script>
        <script src="./assets/js/vendor/jquery-1.12.4.min.js"></script>
        <script src="./assets/js/popper.min.js"></script>
        <script src="./assets/js/bootstrap.min.js"></script>
        <script src="./assets/js/jquery.slicknav.min.js"></script>
        <script src="./assets/js/owl.carousel.min.js"></script>
        <script src="./assets/js/slick.min.js"></script>
        <script src="./assets/js/wow.min.js"></script>
        <script src="./assets/js/animated.headline.js"></script>
        <script src="./assets/js/jquery.magnific-popup.js"></script>
        <script src="./assets/js/gijgo.min.js"></script>
        <script src="./assets/js/jquery.nice-select.min.js"></script>
        <script src="./assets/js/jquery.sticky.js"></script>
        <script src="./assets/js/jquery.barfiller.js"></script>
        <script src="./assets/js/jquery.counterup.min.js"></script>
        <script src="./assets/js/waypoints.min.js"></script>
        <script src="./assets/js/jquery.countdown.min.js"></script>
        <script src="./assets/js/hover-direction-snake.min.js"></script>
        <script src="./assets/js/contact.js"></script>
        <script src="./assets/js/jquery.form.js"></script>
        <script src="./assets/js/jquery.validate.min.js"></script>
        <script src="./assets/js/mail-script.js"></script>
        <script src="./assets/js/jquery.ajaxchimp.min.js"></script>
        <script src="./assets/js/plugins.js"></script>
        <script src="./assets/js/main.js"></script>

    </body>
</html>
