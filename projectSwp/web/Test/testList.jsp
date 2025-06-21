<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
    <head>
        <title>Danh sách Tests</title>
        <style>
            html, body {
                height: 100%;
                margin: 0;
                padding-top:  50px;
                font-family: Arial, sans-serif;
                background-color: #f9f9f9;
            }

            body {
                display: flex;
                flex-direction: column;
                min-height: 100vh;
                padding-top: 80px;
            }

            main {
                flex: 1;
                padding: 20px;
            }

            h2 {
                color: #333;
                border-bottom: 2px solid #007BFF;
                padding-bottom: 5px;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                background-color: white;
                margin-top: 20px;
            }

            table th, table td {
                border: 1px solid #ddd;
                padding: 10px;
                text-align: left;
            }

            table th {
                background-color: #007BFF;
                color: white;
            }

            table tr:nth-child(even) {
                background-color: #f2f2f2;
            }

            a {
                text-decoration: none;
                color: #007BFF;
            }

            a:hover {
                text-decoration: underline;
            }

            p {
                margin: 10px 0;
                color: red;
            }

            .add-link {
                display: inline-block;
                margin-top: 15px;
                background-color: #007BFF;
                color: white;
                padding: 8px 12px;
                border-radius: 4px;
            }

            .add-link:hover {
                background-color: #0056b3;
            }
        </style>

        <!-- Styles -->
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
    </head>

    <body>
        <jsp:include page="../header.jsp" />

        <main>
            <h2>Danh sách Tests</h2>

            <c:if test="${not empty error}">
                <p>${error}</p>
            </c:if>

            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Description</th>
                        <th>Practice</th>
                        <th>Category Name</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="test" items="${testList}">
                        <tr>
                            <td>${test.id}</td>
                            <td>${test.name}</td>
                            <td>${test.description}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${test.is_practice}">Yes</c:when>
                                    <c:otherwise>No</c:otherwise>
                                </c:choose>
                            </td>
                            <td>${categoryMap[test.category_id]}</td>
                            <td>
                                <a href="${pageContext.request.contextPath}/test?action=edit&id=${test.id}">Sửa</a> |
                                <a href="${pageContext.request.contextPath}/test?action=delete&id=${test.id}" onclick="return confirm('Bạn chắc chắn muốn xoá?');">Xoá</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <a class="add-link" href="${pageContext.request.contextPath}/test?action=create">Thêm mới Test</a>
        </main>

        <jsp:include page="/footer.jsp" />

        <!-- JS -->
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
    </body>
</html>
