<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
    <head>
        <title>Sửa Test</title>
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
                display: flex;
                flex-direction: column;
                min-height: 100vh;
            }

            header, footer {
                flex-shrink: 0;
            }

            main {
                flex: 1;
                padding: 100px 20px 20px 20px; /* top-padding tránh bị header che */
                display: flex;
                justify-content: center;
            }

            .form-container {
                background-color: #fff;
                padding: 25px;
                border-radius: 8px;
                box-shadow: 0 0 8px rgba(0, 0, 0, 0.1);
                max-width: 500px;
                width: 100%;
            }

            h3 {
                color: #333;
                margin-bottom: 20px;
                border-bottom: 2px solid #007BFF;
                padding-bottom: 5px;
            }

            input[type="text"], select {
                width: 100%;
                padding: 10px;
                margin: 6px 0 15px 0;
                border: 1px solid #ccc;
                border-radius: 4px;
            }

            input[type="checkbox"] {
                margin-right: 8px;
            }

            input[type="submit"] {
                background-color: #007BFF;
                color: white;
                border: none;
                padding: 10px 16px;
                border-radius: 4px;
                cursor: pointer;
            }

            input[type="submit"]:hover {
                background-color: #0056b3;
            }

            a {
                display: inline-block;
                margin-top: 10px;
                text-decoration: none;
                color: #007BFF;
            }

            a:hover {
                text-decoration: underline;
            }

            footer {
                background: #f1f1f1;
                padding: 10px;
                text-align: center;
                margin-top: auto;
            }

            /* Fix for Nice Select dropdown */
            .nice-select {
                width: 100%;
                margin: 6px 0 15px 0;
                line-height: 40px;
                height: 42px;
            }

            .nice-select .list {
                width: 100%;
                max-height: 300px;
                overflow-y: auto;
            }

            .nice-select .option {
                line-height: 35px;
                min-height: 35px;
            }

            /* Ensure dropdown is visible */
            .nice-select .list {
                opacity: 1;
                pointer-events: auto;
                transform: scale(1) translateY(0);
                z-index: 9999;
            }

            .nice-select.open .list {
                opacity: 1;
                pointer-events: auto;
                transform: scale(1) translateY(0);
                z-index: 9999;
            }
        </style>
    </head>
    <body>
        <div class="page-wrapper">
            <jsp:include page="/header.jsp" />

            <main>
                <div class="form-container">
                    <h3>Sửa Test</h3>

                    <form action="${pageContext.request.contextPath}/test" method="post">
                        <input type="hidden" name="action" value="update"/>
                        <input type="hidden" name="id" value="${test.id}"/>

                        Name:
                        <input type="text" name="name" value="${test.name}" required/>

                        Description:
                        <input type="text" name="description" value="${test.description}" required/>

                        <label>
                            <input type="checkbox" name="practice" value="true"
                                   <c:if test="${test.is_practice}">checked</c:if> />
                                   Practice
                            </label>

                            <label for="category">Category:</label>
                            <select id="category" name="categoryId" required style="display: block; width: 100%; height: 40px; padding: 8px; border: 1px solid #ccc; border-radius: 4px; background-color: white;">
                                <option value="" disabled>-- Chọn danh mục --</option>
                            <c:forEach var="entry" items="${categoryMap}">
                                <option value="${entry.key}" ${test.category_id == entry.key ? 'selected' : ''}>${entry.value}</option>
                            </c:forEach>
                        </select>

                        <!-- Danh sách câu hỏi từ question bank -->
                        <h4>Chọn câu hỏi cho bài test:</h4>
                        <div style="max-height:400px;overflow-y:auto;border:1px solid #ccc;padding:10px;margin-bottom:15px;background:#fafafa">
                            <c:if test="${empty questionList}">
                                <p class="text-danger">Không có câu hỏi nào trong ngân hàng câu hỏi.</p>
                            </c:if>
                            <c:if test="${not empty questionList}">
                                <table class="table table-bordered table-sm">
                                    <thead>
                                        <tr>
                                            <th style="width:40px"></th>
                                            <th style="width:50px">ID</th>
                                            <th>Nội dung câu hỏi</th>
                                            <th style="width:80px">Lesson</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="q" items="${questionList}">
                                            <tr>
                                                <td>
                                                    <input type="checkbox" name="questionIds" value="${q.id}" 
                                                           <c:if test="${selectedQuestionIds.contains(q.id)}">checked</c:if> />
                                                    </td>
                                                    <td>${q.id}</td>
                                                <td>${q.question}</td>
                                                <td>${q.lesson_id}</td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:if>
                        </div>

                        <input type="submit" value="Cập nhật"/>
                    </form>

                    <a href="${pageContext.request.contextPath}/test">← Quay lại danh sách</a>
                </div>
            </main>

            <jsp:include page="/footer.jsp" />
        </div>

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
        <script>
            $(document).ready(function () {
                // Disable Nice Select for the category dropdown to use native select
                if ($.fn.niceSelect) {
                    // First destroy any existing nice-select
                    $('#category').niceSelect('destroy');
                }

                // Add a click handler to ensure the dropdown opens
                $('#category').on('click', function (e) {
                    e.stopPropagation();
                    $(this).focus();
                });

                // Make sure the selected option is correct
                var selectedValue = '${test.category_id}';
                if (selectedValue) {
                    $('#category').val(selectedValue);
                }

                // Log for debugging
                console.log("Selected category ID: " + selectedValue);
                console.log("Available categories in map");
            <c:forEach var="entry" items="${categoryMap}">
                console.log("ID: ${entry.key}, Name: ${entry.value}");
            </c:forEach>
            });
        </script>
    </body>
</html>
