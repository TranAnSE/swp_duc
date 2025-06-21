<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <meta charset="UTF-8">
    <title>Add Subject</title>

    <!-- Only necessary CSS -->
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
            height: 100%;
            margin: 0;
            padding-top:  50px;
            font-family: Arial, sans-serif;
            background-color: #f4f6f8;
        }
        body {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            padding-top: 80px;
        }
        .page-wrapper {
            flex: 1;
            display: flex;
            flex-direction: column;
        }
        .container {
            max-width: 600px;
            margin: auto;
        }
        form {
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }
        label {
            font-weight: bold;
        }
        input[type="text"], textarea, select {
            width: 100%;
            padding: 8px;
            margin: 8px 0 15px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        input[type="submit"], .btn-back {
            background-color: #4CAF50;
            color: white;
            padding: 10px 18px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .btn-back {
            background-color: #6c757d;
            text-decoration: none;
            margin-left: 10px;
            display: inline-block;
        }
        .error {
            color: red;
        }
        footer {
            margin-top: auto;
        }
    </style>
</head>
<body>

<div class="page-wrapper">
    <%@include file="../header.jsp" %>

    <div class="container">
        <h2>Add New Subject</h2>

        <c:if test="${not empty error}">
            <p class="error">${error}</p>
        </c:if>

        <form method="post" action="subjects">
            <label for="name">Subject Name:</label>
            <input type="text" id="name" name="name" value="${param.name}" required />

            <label for="description">Description (optional):</label>
            <textarea id="description" name="description" rows="4">${param.description}</textarea>

            <label for="grade_id">Grade:</label>
            <select id="grade_id" name="grade_id" required>
                <c:forEach var="entry" items="${gradeMap}">
                    <option value="${entry.key}" <c:if test="${param.grade_id == entry.key}">selected</c:if>>${entry.value}</option>
                </c:forEach>
            </select>

            <input type="submit" value="Add Subject" />
            <a href="subjects" class="btn-back">Back to List</a>
        </form>
    </div>

    <%@include file="../footer.jsp" %>
</div>

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
        // Chỉ gọi khi chắc chắn DOM đã sẵn sàng
        $('select').niceSelect();
    });
</script>

</body>
</html>
