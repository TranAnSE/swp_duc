<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Thêm mới Test</title>

        <!-- CSS -->
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
            html, body {
                margin: 0;
                padding-top:  50px;
                height: 100%;
                font-family: Arial, sans-serif;
                background-color: #f9f9f9;
            }

            body {
                padding-top: 80px; /* tránh header che nội dung */
                display: flex;
                flex-direction: column;
                min-height: 100vh;
            }

            .page-wrapper {
                flex: 1;
                display: flex;
                flex-direction: column;
            }

            .content {
                max-width: 600px;
                width: 100%;
                margin: 0 auto;
                padding: 20px;
            }

            h3 {
                color: #333;
                border-bottom: 2px solid #007BFF;
                padding-bottom: 8px;
                margin-bottom: 20px;
            }

            form {
                background-color: #fff;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            }

            input[type="text"],
            select {
                width: 100%;
                padding: 10px;
                margin-bottom: 15px;
                border: 1px solid #ccc;
                border-radius: 5px;
            }

            input[type="checkbox"] {
                margin-right: 5px;
            }

            input[type="submit"] {
                background-color: #007BFF;
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 5px;
                cursor: pointer;
            }

            input[type="submit"]:hover {
                background-color: #0056b3;
            }

            a {
                display: inline-block;
                margin-top: 15px;
                color: #007BFF;
                text-decoration: none;
            }

        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<div class="page-wrapper">
    <jsp:include page="/header.jsp" />

            <div class="content">
                <h3>Thêm mới Test</h3>
                <form action="${pageContext.request.contextPath}/test" method="post">
                    <input type="hidden" name="action" value="add" />

                    <label for="name">Name:</label>
                    <input type="text" id="name" name="name" value="${test != null ? test.name : ''}" required />

                    <label for="description">Description:</label>
                    <input type="text" id="description" name="description" value="${test != null ? test.description : ''}" required />

                    <label><input type="checkbox" name="practice" value="true" /> Practice</label>

                    <label for="category">Category:</label>
                    <select id="category" name="categoryId" required>
                        <option value="" disabled selected>-- Chọn danh mục --</option>
                        <c:forEach var="entry" items="${categoryMap}">
                            <option value="${entry.key}">${entry.value}</option>
                        </c:forEach>
                    </select>

            <!-- Danh sách câu hỏi từ question bank -->
            <h4>Chọn câu hỏi cho bài test:</h4>
            <div style="max-height:300px;overflow-y:auto;border:1px solid #ccc;padding:10px;margin-bottom:15px;background:#fafafa">
                <table class="table table-bordered table-sm">
                    <thead>
                        <tr>
                            <th></th>
                            <th>ID</th>
                            <th>Nội dung câu hỏi</th>
                            <th>Lesson ID</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="q" items="${questionList}">
                            <tr>
                                <td><input type="checkbox" name="questionIds" value="${q.id}" /></td>
                                <td>${q.id}</td>
                                <td>${q.question}</td>
                                <td>${q.lesson_id}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <input type="submit" value="Thêm mới" />
        </form>

    
</div>

            <jsp:include page="/footer.jsp" />
        </div>

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
        <script>
            $(document).ready(function () {
                $('select').niceSelect();
            });
        </script>
    </body>
</html>
