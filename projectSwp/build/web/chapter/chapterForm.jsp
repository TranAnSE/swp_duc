<%-- 
    Document   : chapterForm
    Created on : June 01, 2025, 01:14:00 AM
    Author     : Na
--%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page errorPage="error.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>${chapterToEdit == null ? 'Add Chapter' : 'Edit Chapter'}</title>
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
            /* Course builder breadcrumb */
            .course-breadcrumb {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 15px 20px;
                border-radius: 8px;
                margin-bottom: 20px;
            }
            .course-breadcrumb a {
                color: rgba(255,255,255,0.8);
                text-decoration: none;
            }
            .course-breadcrumb a:hover {
                color: white;
            }
            /* Form styling */
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
            form[method="post"] input[type="number"],
            form[method="post"] textarea,
            form[method="post"] select {
                width: 200px;
                padding: 8px 12px;
                font-size: 14px;
                border-radius: 6px;
                border: 1px solid #ced4da;
                box-sizing: border-box;
                background-color: #fdfdfd;
                transition: border-color 0.3s ease;
            }
            form[method="post"] textarea {
                resize: vertical;
                min-height: 80px;
                width: 300px;
            }
            form[method="post"] input[type="text"]:focus,
            form[method="post"] input[type="number"]:focus,
            form[method="post"] textarea:focus,
            form[method="post"] select:focus {
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
            /* Notification styling */
            .text-danger, .text-success {
                font-size: 0.9em;
                font-weight: bold;
                margin: 10px 0;
            }
            .required {
                color: #dc3545;
            }
        </style>
    </head>
    <body>
        <%@include file="../header.jsp" %>

        <main>
            <!-- Course Builder Breadcrumb (if coming from course builder) -->
            <c:if test="${returnToCourse}">
                <div class="course-breadcrumb">
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-0" style="background: transparent;">
                            <li class="breadcrumb-item">
                                <a href="${pageContext.request.contextPath}/course"><i class="fas fa-graduation-cap"></i> Courses</a>
                            </li>
                            <li class="breadcrumb-item">
                                <a href="${pageContext.request.contextPath}/course?action=build&id=${courseId}">
                                    <i class="fas fa-cogs"></i> Course Builder
                                </a>
                            </li>
                            <li class="breadcrumb-item active" aria-current="page" style="color: white;">
                                <i class="fas fa-plus"></i> Add Chapter
                            </li>
                        </ol>
                    </nav>
                </div>
            </c:if>

            <h2>
                <i class="fas fa-book"></i> 
                ${chapterToEdit == null ? 'Add New Chapter' : 'Edit Chapter'}
            </h2>

            <!-- Error/Success Messages -->
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i> ${errorMessage}
                </div>
            </c:if>

            <c:if test="${not empty message}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> ${message}
                </div>
            </c:if>

            <!-- Chapter Form -->
            <form method="post" action="chapter">
                <input type="hidden" name="service" value="${chapterToEdit == null ? 'add' : 'edit'}">
                
                <!-- Hidden fields for course builder return -->
                <c:if test="${returnToCourse}">
                    <input type="hidden" name="returnTo" value="course">
                    <input type="hidden" name="courseId" value="${courseId}">
                </c:if>

                <div class="form-group">
                    <label for="id">Chapter ID <span class="required">*</span></label>
                    <input type="number" id="id" name="id" 
                           value="${chapterToEdit != null ? chapterToEdit.id : ''}" 
                           ${chapterToEdit != null ? 'readonly' : ''} 
                           required min="1" max="999999">
                </div>

                <div class="form-group">
                    <label for="name">Chapter Name <span class="required">*</span></label>
                    <input type="text" id="name" name="name" 
                           value="${chapterToEdit != null ? chapterToEdit.name : ''}" 
                           required maxlength="255" placeholder="Enter chapter name">
                </div>

                <div class="form-group">
                    <label for="subject_id">Subject <span class="required">*</span></label>
                    <select id="subject_id" name="subject_id" required>
                        <option value="">-- Select Subject --</option>
                        <c:forEach var="subject" items="${listSubject}">
                            <option value="${subject.id}" 
                                    ${(chapterToEdit != null && chapterToEdit.subject_id == subject.id) ? 'selected' : ''}>
                                ${subject.name}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label for="description">Description</label>
                    <textarea id="description" name="description" 
                              placeholder="Enter chapter description">${chapterToEdit != null ? chapterToEdit.description : ''}</textarea>
                </div>

                <div class="form-group">
                    <input type="submit" value="${chapterToEdit == null ? 'Add Chapter' : 'Update Chapter'}">
                </div>

                <div class="form-group">
                    <c:choose>
                        <c:when test="${returnToCourse}">
                            <a href="${pageContext.request.contextPath}/course?action=build&id=${courseId}">
                                <i class="fas fa-arrow-left"></i> Back to Course Builder
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/chapter">
                                <i class="fas fa-list"></i> Back to List
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </form>

            <!-- Help Section for Course Builder -->
            <c:if test="${returnToCourse}">
                <div class="alert alert-info mt-4">
                    <h5><i class="fas fa-info-circle"></i> Creating Chapter for Course</h5>
                    <p>You are creating a new chapter that will be available for your course. After creating this chapter, you can:</p>
                    <ul>
                        <li>Add it to your course content</li>
                        <li>Create lessons within this chapter</li>
                        <li>Organize your course structure</li>
                    </ul>
                    <p><strong>Note:</strong> The chapter will be created for the selected subject and can be used in multiple courses.</p>
                </div>
            </c:if>
        </main>

        <%@include file="../footer.jsp" %>

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
            // Form validation
            document.querySelector('form').addEventListener('submit', function(e) {
                const id = document.getElementById('id').value;
                const name = document.getElementById('name').value.trim();
                const subjectId = document.getElementById('subject_id').value;

                if (!id || id <= 0) {
                    alert('Please enter a valid Chapter ID (positive number).');
                    e.preventDefault();
                    return false;
                }

                if (!name) {
                    alert('Please enter a chapter name.');
                    e.preventDefault();
                    return false;
                }

                if (!subjectId) {
                    alert('Please select a subject.');
                    e.preventDefault();
                    return false;
                }

                return true;
            });

            // Auto-focus on first input
            document.addEventListener('DOMContentLoaded', function() {
                const firstInput = document.querySelector('input[type="number"], input[type="text"]');
                if (firstInput && !firstInput.hasAttribute('readonly')) {
                    firstInput.focus();
                }
            });
        </script>
    </body>
</html>