<%-- 
    Document   : form
    Created on : Jun 1, 2025, 1:46:39 AM
    Author     : Na
--%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>${studyPackageToEdit == null ? 'Add Study Package' : 'Edit Study Package'}</title>
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
        <!-- Select2 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
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
            .form-container {
                background: #ffffff;
                padding: 30px;
                margin: 20px auto;
                border-radius: 10px;
                max-width: 800px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            .form-group {
                margin-bottom: 20px;
            }
            .form-group label {
                font-weight: 600;
                display: block;
                margin-bottom: 8px;
                color: #333;
            }
            .form-group input,
            .form-group textarea {
                width: 100%;
                padding: 10px 15px;
                font-size: 14px;
                border-radius: 6px;
                border: 1px solid #ced4da;
                box-sizing: border-box;
                background-color: #fdfdfd;
                transition: border-color 0.3s ease;
            }
            .form-group input:focus,
            .form-group textarea:focus {
                border-color: #007bff;
                outline: none;
            }
            .form-group textarea {
                height: 100px;
                resize: vertical;
            }
            .form-row {
                display: flex;
                gap: 20px;
            }
            .form-row .form-group {
                flex: 1;
            }
            .btn-container {
                display: flex;
                gap: 15px;
                justify-content: center;
                margin-top: 30px;
            }
            .btn {
                padding: 12px 25px;
                font-size: 14px;
                border-radius: 6px;
                border: none;
                text-decoration: none;
                color: #fff;
                background-color: #28a745;
                transition: background-color 0.3s ease;
                cursor: pointer;
            }
            .btn-secondary {
                background-color: #6c757d;
            }
            .btn:hover {
                background-color: #218838;
            }
            .btn-secondary:hover {
                background-color: #5a6268;
            }
            .package-type-info {
                background-color: #e9ecef;
                padding: 15px;
                border-radius: 6px;
                margin-top: 10px;
                font-size: 13px;
                color: #495057;
            }

            /* Hide nice-select completely */
            .nice-select {
                display: none !important;
            }

            /* Select2 custom styling */
            .select2-container--default .select2-selection--single {
                height: 42px;
                border: 1px solid #ced4da;
                border-radius: 6px;
                background-color: #fdfdfd;
            }
            .select2-container--default .select2-selection--single .select2-selection__rendered {
                line-height: 40px;
                padding-left: 15px;
                color: #495057;
            }
            .select2-container--default .select2-selection--single .select2-selection__arrow {
                height: 40px;
                right: 10px;
            }
            .select2-container--default .select2-selection--multiple {
                border: 1px solid #ced4da;
                border-radius: 6px;
                min-height: 42px;
                background-color: #fdfdfd;
            }
            .select2-container {
                width: 100% !important;
            }
            .select2-container--default .select2-selection--single:focus,
            .select2-container--default .select2-selection--multiple:focus {
                border-color: #007bff;
                outline: none;
            }
            .select2-container--default .select2-selection--single .select2-selection__placeholder {
                color: #6c757d;
            }
            .select2-container--default .select2-selection--multiple .select2-selection__placeholder {
                color: #6c757d;
            }

            #subject-selection {
                display: none;
                margin-top: 20px;
                padding: 20px;
                background-color: #f8f9fa;
                border-radius: 6px;
                border: 1px solid #dee2e6;
            }
            #subject-selection.show {
                display: block;
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
            <h2>${studyPackageToEdit == null ? 'Add New Study Package' : 'Edit Study Package'}</h2>

            <!-- Error and success messages -->
            <c:if test="${not empty errorMessage}">
                <div class="text-danger text-center"><c:out value="${errorMessage}"/></div>
            </c:if>
            <c:if test="${not empty message}">
                <div class="text-success text-center"><c:out value="${message}"/></div>
            </c:if>

            <!-- Study package form -->
            <div class="form-container">
                <form action="study_package" method="post" id="packageForm">
                    <input type="hidden" name="service" value="${studyPackageToEdit == null ? 'add' : 'update'}" />
                    <c:if test="${not empty studyPackageToEdit}">
                        <input type="hidden" name="id" value="${studyPackageToEdit.id}" />
                    </c:if>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="id">Package ID *</label>
                            <input type="number" name="id" id="id" 
                                   value="${studyPackageToEdit != null ? studyPackageToEdit.id : ''}" 
                                   ${studyPackageToEdit != null ? 'readonly' : ''} 
                                   required placeholder="Enter package ID" min="1" />
                        </div>
                        <div class="form-group">
                            <label for="name">Package Name *</label>
                            <input type="text" name="name" id="name" 
                                   value="${studyPackageToEdit != null ? studyPackageToEdit.name : ''}" 
                                   required placeholder="Enter package name" maxlength="300" />
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="price">Price (VND) *</label>
                            <input type="text" name="price" id="price" 
                                   value="${studyPackageToEdit != null ? studyPackageToEdit.price : ''}" 
                                   required placeholder="Enter price" maxlength="20" />
                        </div>
                        <div class="form-group">
                            <label for="type">Package Type *</label>
                            <select name="type" id="type" required class="select2-no-nice">
                                <option value="">-- Select Package Type --</option>
                                <option value="SUBJECT_COMBO" ${studyPackageToEdit != null && studyPackageToEdit.type == 'SUBJECT_COMBO' ? 'selected' : ''}>
                                    Subject Combo
                                </option>
                                <option value="GRADE_ALL" ${studyPackageToEdit != null && studyPackageToEdit.type == 'GRADE_ALL' ? 'selected' : ''}>
                                    All Subjects in Grade
                                </option>
                            </select>
                            <div class="package-type-info">
                                <div id="combo-info" style="display: none;">
                                    <strong>Subject Combo:</strong> Package includes selected subjects from different grades.
                                </div>
                                <div id="grade-info" style="display: none;">
                                    <strong>All Subjects in Grade:</strong> Package includes all subjects in a specific grade.
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="grade_id">Target Grade</label>
                            <select name="grade_id" id="grade_id" class="select2-no-nice">
                                <option value="">-- Select Grade (Optional for Subject Combo) --</option>
                                <c:forEach items="${grades}" var="grade">
                                    <option value="${grade.id}" 
                                            ${studyPackageToEdit != null && studyPackageToEdit.grade_id != null && studyPackageToEdit.grade_id == grade.id ? 'selected' : ''}>
                                        ${grade.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="max_students">Maximum Students *</label>
                            <input type="number" name="max_students" id="max_students" 
                                   value="${studyPackageToEdit != null ? studyPackageToEdit.max_students : '1'}" 
                                   required placeholder="Maximum students per package" min="1" max="100" />
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="duration_days">Duration (Days) *</label>
                            <input type="number" name="duration_days" id="duration_days" 
                                   value="${studyPackageToEdit != null ? studyPackageToEdit.duration_days : '365'}" 
                                   required placeholder="Package duration in days" min="1" max="3650" />
                        </div>
                    </div>

                    <!-- Subject Selection for SUBJECT_COMBO -->
                    <div id="subject-selection">
                        <div class="form-group">
                            <label for="subject_ids">Select Subjects for Combo *</label>
                            <select name="subject_ids" id="subject_ids" multiple="multiple" class="select2-no-nice">
                                <c:forEach items="${allSubjects}" var="subject">
                                    <option value="${subject.id}"
                                            <c:if test="${not empty selectedSubjectIds}">
                                                <c:forEach items="${selectedSubjectIds}" var="selectedId">
                                                    <c:if test="${selectedId == subject.id}">selected</c:if>
                                                </c:forEach>
                                            </c:if>>
                                        ${subject.name}
                                    </option>
                                </c:forEach>
                            </select>
                            <small class="form-text text-muted">
                                Select multiple subjects to include in this combo package.
                            </small>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="description">Description</label>
                        <textarea name="description" id="description" 
                                  placeholder="Enter package description">${studyPackageToEdit != null ? studyPackageToEdit.description : ''}</textarea>
                    </div>

                    <div class="btn-container">
                        <button type="submit" class="btn">
                            ${studyPackageToEdit == null ? 'Create Package' : 'Update Package'}
                        </button>
                        <a href="study_package" class="btn btn-secondary">Back to List</a>
                    </div>
                </form>
            </div>
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

        <!-- Select2 JS - Load BEFORE main.js -->
        <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

        <!-- Load main.js AFTER Select2 -->
        <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>

        <script>
            $(document).ready(function () {
                // Destroy any existing nice-select instances first
                $('.select2-no-nice').each(function () {
                    if ($(this).next('.nice-select').length) {
                        $(this).next('.nice-select').remove();
                    }
                    $(this).show();
                });

                // Initialize Select2 for all select elements with custom class
                $('#type').select2({
                    placeholder: "-- Select Package Type --",
                    allowClear: true,
                    width: '100%'
                });

                $('#grade_id').select2({
                    placeholder: "-- Select Grade (Optional for Subject Combo) --",
                    allowClear: true,
                    width: '100%'
                });

                $('#subject_ids').select2({
                    placeholder: "Select subjects for this combo package",
                    allowClear: true,
                    width: '100%'
                });

                // Handle package type change
                $('#type').on('change', function () {
                    toggleGradeSelection();
                });

                // Initialize on page load
                toggleGradeSelection();
            });

            function toggleGradeSelection() {
                const typeSelect = $('#type');
                const gradeSelect = $('#grade_id');
                const subjectSelection = $('#subject-selection');
                const comboInfo = $('#combo-info');
                const gradeInfo = $('#grade-info');

                // Hide all info divs first
                comboInfo.hide();
                gradeInfo.hide();
                subjectSelection.removeClass('show');

                const selectedType = typeSelect.val();

                if (selectedType === 'GRADE_ALL') {
                    gradeSelect.prop('required', true);
                    gradeInfo.show();
                    subjectSelection.removeClass('show');
                    $('#subject_ids').prop('required', false);
                } else if (selectedType === 'SUBJECT_COMBO') {
                    gradeSelect.prop('required', false);
                    comboInfo.show();
                    subjectSelection.addClass('show');
                    $('#subject_ids').prop('required', true);
                } else {
                    gradeSelect.prop('required', false);
                    $('#subject_ids').prop('required', false);
                }
            }

            // Form validation
            $('#packageForm').on('submit', function (e) {
                const type = $('#type').val();
                const gradeId = $('#grade_id').val();
                const subjectIds = $('#subject_ids').val();

                if (type === 'GRADE_ALL' && !gradeId) {
                    e.preventDefault();
                    alert('Please select a grade for "All Subjects in Grade" package type.');
                    return false;
                }

                if (type === 'SUBJECT_COMBO' && (!subjectIds || subjectIds.length === 0)) {
                    e.preventDefault();
                    alert('Please select at least one subject for "Subject Combo" package type.');
                    return false;
                }

                const maxStudents = parseInt($('#max_students').val());
                if (maxStudents < 1 || maxStudents > 100) {
                    e.preventDefault();
                    alert('Maximum students must be between 1 and 100.');
                    return false;
                }

                const durationDays = parseInt($('#duration_days').val());
                if (durationDays < 1 || durationDays > 3650) {
                    e.preventDefault();
                    alert('Duration must be between 1 and 3650 days (10 years).');
                    return false;
                }
            });
        </script>
    </body>
</html>
