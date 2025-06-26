<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
    <head>
        <title>Question List</title>

        <!-- Bootstrap CSS -->
        <!-- External CSS -->
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

        <!-- Internal CSS -->

        <style>
            body {
                display: flex;
                flex-direction: column;
                min-height: 100vh;
                font-family: Arial, sans-serif;
                background-color: #f9f9f9;
                padding-top: 120px;
            }
            th, td {
                vertical-align: middle;
                text-align: center;
            }
            img.img-thumbnail {
                object-fit: cover;
            }
        </style>
    </head>

    <body class="bg-light">
        <!-- Include header -->
        <jsp:include page="/header.jsp" />

        <div class="container mt-5 mb-5">
            <h2 class="mb-4">Question List</h2>

            <form method="get" action="Question" class="mb-4 d-flex gap-2">
                <input type="text" name="question" class="form-control w-25" placeholder="Search by question..." />
                <button type="submit" class="btn btn-primary">Search</button>
            </form>

            <table class="table table-bordered table-striped table-hover">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Question</th>
                        <th>Image</th>
                        <th>Lesson Name</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="q" items="${questionList}">
                        <tr>
                            <td>${q.id}</td>
                            <td>${q.question}</td>
                            <td>
                                <c:forEach var="img" items="${images}">
                                    <c:if test="${img.id == q.image_id}">
                                        <img src="data:image/jpg;base64, ${img.image_data}" alt="Ảnh câu hỏi" width="100" height="100" class="img-thumbnail">
                                    </c:if>
                                </c:forEach>
                            </td>
                            <td>
                                <c:forEach var="l" items="${les}">
                                    <c:if test="${q.lesson_id eq l.id}">
                                        ${l.name}
                                    </c:if>
                                </c:forEach>
                            </td>
                            <td>
                                <a href="Question?action=updateForm&id=${q.id}" class="btn btn-sm btn-warning">Edit</a>
                                <a href="Question?action=delete&id=${q.id}" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure?');">Delete</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <div class="mb-4">
                <div class="row">
                    <div class="col-md-8">
                        <div class="btn-group" role="group" aria-label="Question creation options">
                            <a href="Question?action=addForm" class="btn btn-success btn-lg">
                                <i class="fas fa-plus me-2"></i>
                                Manual Entry
                            </a>
                            <a href="/ai-question?action=form" class="btn btn-primary btn-lg">
                                <i class="fas fa-robot me-2"></i>
                                AI Generator
                            </a>
                        </div>
                    </div>
                    <div class="col-md-4 text-end">
                        <div class="dropdown">
                            <button class="btn btn-outline-secondary dropdown-toggle" type="button" 
                                    data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="fas fa-cog me-2"></i>Quick Actions
                            </button>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item" href="/ai-question?action=form&type=single_choice">
                                        <i class="fas fa-dot-circle me-2"></i>Generate Single Choice
                                    </a></li>
                                <li><a class="dropdown-item" href="/ai-question?action=form&type=multiple_choice">
                                        <i class="fas fa-check-square me-2"></i>Generate Multiple Choice
                                    </a></li>
                                <li><a class="dropdown-item" href="/ai-question?action=form&type=true_false">
                                        <i class="fas fa-balance-scale me-2"></i>Generate True/False
                                    </a></li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Include footer -->
        <jsp:include page="/footer.jsp" />

        <!-- JS Libraries -->
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
