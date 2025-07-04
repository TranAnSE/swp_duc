<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
    <head>
        <meta charset="UTF-8">
        <title>Add Subject</title>

        <!-- CSS Libraries -->
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
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">

        <!-- Select2 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />

        <style>
            html, body {
                height: 100%;
                margin: 0;
                padding-top: 50px;
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
            input[type="text"], textarea {
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

            /* Select2 Custom Styling */
            .select2-container {
                width: 100% !important;
                z-index: 1000;
            }
            .select2-selection--single {
                height: 42px !important;
                padding: 8px !important;
                border-radius: 4px !important;
                border: 1px solid #ccc !important;
                font-size: 16px !important;
                line-height: 26px !important;
            }
            .select2-selection__rendered {
                line-height: 26px !important;
                padding-left: 0 !important;
                color: #495057 !important;
            }
            .select2-selection__arrow {
                height: 40px !important;
                right: 8px !important;
            }
            .select2-container--focus .select2-selection--single {
                border-color: #4CAF50 !important;
                box-shadow: 0 0 0 0.2rem rgba(76,175,80,.25) !important;
            }
            .select2-dropdown {
                border-radius: 4px !important;
                border: 1px solid #ccc !important;
                box-shadow: 0 4px 6px rgba(0,0,0,0.1) !important;
                z-index: 9999 !important;
            }
            .select2-results__option {
                padding: 10px 12px !important;
                font-size: 16px !important;
            }
            .select2-results__option--highlighted {
                background-color: #4CAF50 !important;
            }
            .select2-search--dropdown .select2-search__field {
                padding: 8px 10px !important;
                border-radius: 4px !important;
                border: 1px solid #ccc !important;
                font-size: 16px !important;
            }

            /* Hide nice-select elements */
            .nice-select {
                display: none !important;
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
                    <select id="grade_id" name="grade_id" class="form-select select2-enabled" required>
                        <option value="">-- Select Grade --</option>
                        <c:forEach var="entry" items="${gradeMap}">
                            <option value="${entry.key}" 
                                    <c:if test="${param.grade_id == entry.key}">selected</c:if>>
                                ${entry.value}
                            </option>
                        </c:forEach>
                    </select>

                    <input type="submit" value="Add Subject" />
                    <a href="subjects" class="btn-back">Back to List</a>
                </form>
            </div>

            <%@include file="../footer.jsp" %>
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

        <!-- Select2 JS -->
        <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

        <script>
            $(document).ready(function () {
                // Disable nice-select initialization
                if (typeof $.fn.niceSelect !== 'undefined') {
                    $.fn.niceSelect = function () {
                        return this;
                    };
                }

                // Destroy any existing Select2 instances and nice-select
                $('.select2-enabled').each(function () {
                    if ($(this).hasClass('select2-hidden-accessible')) {
                        $(this).select2('destroy');
                    }
                    // Remove nice-select if exists
                    if ($(this).next('.nice-select').length) {
                        $(this).next('.nice-select').remove();
                        $(this).show();
                    }
                });

                // Initialize Select2 for grade dropdown
                $('.select2-enabled').select2({
                    placeholder: '-- Select Grade --',
                    allowClear: true,
                    width: '100%',
                    dropdownParent: $('body')
                });
            });
        </script>
    </body>
</html>
