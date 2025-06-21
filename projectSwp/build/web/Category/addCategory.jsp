<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
    <head>
        <title>Add Category</title>

        <!-- CSS Libraries -->
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
                padding: 0;
                height: 100%;
                font-family: Arial, sans-serif;
                background-color: #f9f9f9;
            }

            .page-wrapper {
                min-height: 100vh;
                display: flex;
                flex-direction: column;
                padding-top: 80px; /* tránh header che */
            }

            main {
                flex: 1;
                padding: 20px;
            }

            footer {
                background-color: #f1f1f1;
                padding: 10px 20px;
                text-align: center;
                font-size: 14px;
            }

            .form-container {
                background: #fff;
                padding: 30px;
                border-radius: 8px;
                max-width: 600px;
                margin: 20px auto;
                box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
            }

            .form-title {
                color: #333;
                text-align: center;
                margin-bottom: 25px;
                font-weight: 600;
            }

            .alert {
                padding: 10px;
                margin: 10px 0;
                border-radius: 4px;
            }

            .alert-danger {
                background-color: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
            }
        </style>
    </head>
    <body>
        <div class="page-wrapper">
            <jsp:include page="/header.jsp" />
            <main>
                <div class="form-container">
                    <h2 class="form-title">Add New Category</h2>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">${error}</div>
                    </c:if>

                    <form method="post" action="category" id="categoryForm" class="needs-validation" novalidate>
                        <input type="hidden" name="action" value="insert" />

                        <div class="form-group">
                            <label for="name">Category Name:</label>
                            <input type="text" class="form-control" name="name" id="name" required 
                                   placeholder="Enter category name" maxlength="300"/>
                            <div class="invalid-feedback">
                                Please enter a valid category name.
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="num_question">Number of Questions:</label>
                            <input type="number" class="form-control" name="num_question" id="num_question" 
                                   min="1" max="500" required placeholder="Number of questions"/>
                            <div class="invalid-feedback">
                                Please enter a number between 1 and 500.
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="duration">Duration (minutes):</label>
                            <input type="number" class="form-control" name="duration" id="duration" 
                                   min="1" max="300" required placeholder="Test duration in minutes"/>
                            <div class="invalid-feedback">
                                Please enter a duration between 1 and 300 minutes.
                            </div>
                        </div>

                        <div class="form-group mt-4 text-center">
                            <button type="submit" class="btn btn-primary">Add Category</button>
                            <a href="category" class="btn btn-secondary ml-2">Cancel</a>
                        </div>
                    </form>
                </div>
            </main>
            <jsp:include page="/footer.jsp" />
        </div>

        <!-- JS Libraries -->
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

        <script>
        // Bootstrap form validation script
            (function () {
                'use strict';
                window.addEventListener('load', function () {
                    // Fetch all forms we want to apply validation to
                    var forms = document.getElementsByClassName('needs-validation');
                    // Loop over them and prevent submission
                    var validation = Array.prototype.filter.call(forms, function (form) {
                        form.addEventListener('submit', function (event) {
                            if (form.checkValidity() === false) {
                                event.preventDefault();
                                event.stopPropagation();
                            }
                            form.classList.add('was-validated');
                        }, false);
                    });
                }, false);
            })();
        </script>
    </body>
</html>
