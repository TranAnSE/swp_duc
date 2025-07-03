<%-- 
    Document   : courseForm
    Created on : Jul 3, 2025, 10:34:36 AM
    Author     : ankha
--%>

<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Create New Course</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">

        <!-- Select2 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />

        <style>
            body {
                padding-top: 130px;
                background-color: #f8f9fa;
            }
            .form-container {
                max-width: 800px;
                margin: 40px auto;
                background: white;
                padding: 40px;
                border-radius: 12px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            .hierarchy-display {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 20px;
                border-radius: 8px;
                margin-bottom: 30px;
            }
            .hierarchy-display h5 {
                margin-bottom: 15px;
                font-weight: bold;
            }
            .hierarchy-path {
                font-size: 1.1em;
                display: flex;
                align-items: center;
                gap: 10px;
            }
            .hierarchy-arrow {
                font-size: 1.2em;
            }
            .form-group {
                margin-bottom: 25px;
            }
            .form-label {
                font-weight: 600;
                color: #333;
                margin-bottom: 8px;
            }
            .required {
                color: #dc3545;
            }
            .form-control, .form-select {
                padding: 12px 15px;
                border-radius: 6px;
                border: 1px solid #ced4da;
            }
            .form-control:focus, .form-select:focus {
                border-color: #007bff;
                box-shadow: 0 0 0 0.2rem rgba(0,123,255,.25);
            }
            .btn-container {
                display: flex;
                gap: 15px;
                justify-content: center;
                margin-top: 30px;
            }
            .btn-custom {
                padding: 12px 30px;
                border-radius: 6px;
                font-weight: 600;
                text-decoration: none;
                border: none;
                cursor: pointer;
                transition: all 0.3s ease;
            }
            .btn-primary-custom {
                background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
                color: white;
            }
            .btn-primary-custom:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 15px rgba(0,123,255,0.3);
            }
            .btn-secondary-custom {
                background: #6c757d;
                color: white;
            }
            .btn-secondary-custom:hover {
                background: #5a6268;
                color: white;
            }
            .select2-container {
                width: 100% !important;
            }
            .select2-container--default .select2-selection--single {
                height: 48px;
                border-radius: 6px;
                border: 1px solid #ced4da;
            }
            .select2-container--default .select2-selection--single .select2-selection__rendered {
                line-height: 46px;
                padding-left: 15px;
            }
        </style>
    </head>
    <body>
        <%@include file="../header.jsp" %>

        <div class="form-container">
            <h2 class="text-center mb-4">Create New Course</h2>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger">${errorMessage}</div>
            </c:if>

            <c:if test="${not empty message}">
                <div class="alert alert-success">${message}</div>
            </c:if>

            <form id="courseForm" action="course" method="post">
                <input type="hidden" name="action" value="create">

                <!-- Step 1: Grade and Subject Selection -->
                <div class="form-group">
                    <label for="gradeId" class="form-label">Select Grade <span class="required">*</span></label>
                    <select id="gradeId" name="gradeId" class="form-select" required>
                        <option value="">-- Select Grade --</option>
                        <c:forEach items="${grades}" var="grade">
                            <option value="${grade.id}" 
                                    ${preSelectedGradeId != null && preSelectedGradeId == grade.id ? 'selected' : ''}>
                                ${grade.name}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label for="subjectId" class="form-label">Select Subject <span class="required">*</span></label>
                    <select id="subjectId" name="subjectId" class="form-select" required>
                        <option value="">-- Select Subject --</option>
                        <c:forEach items="${subjects}" var="subject">
                            <option value="${subject.id}" data-grade-id="${subject.grade_id}"
                                    ${preSelectedSubjectId != null && preSelectedSubjectId == subject.id ? 'selected' : ''}>
                                ${subject.name}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Hierarchy Display -->
                <div id="hierarchyDisplay" class="hierarchy-display" style="display: none;">
                    <h5><i class="fas fa-sitemap"></i> Course Hierarchy</h5>
                    <div class="hierarchy-path">
                        <span id="selectedGradeName"></span>
                        <i class="fas fa-arrow-right hierarchy-arrow"></i>
                        <span id="selectedSubjectName"></span>
                        <i class="fas fa-arrow-right hierarchy-arrow"></i>
                        <span><strong>New Course</strong></span>
                    </div>
                </div>

                <!-- Step 2: Course Details -->
                <div id="courseDetailsSection" style="display: none;">
                    <div class="form-group">
                        <label for="courseTitle" class="form-label">Course Title <span class="required">*</span></label>
                        <input type="text" id="courseTitle" name="courseTitle" class="form-control" 
                               placeholder="Enter course title" required maxlength="500">
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="price" class="form-label">Price (VND) <span class="required">*</span></label>
                                <input type="number" id="price" name="price" class="form-control" 
                                       placeholder="Enter price" required min="0" step="1000">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="durationDays" class="form-label">Duration (Days) <span class="required">*</span></label>
                                <input type="number" id="durationDays" name="durationDays" class="form-control" 
                                       placeholder="Enter duration in days" required min="1" max="3650" value="365">
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="description" class="form-label">Course Description</label>
                        <textarea id="description" name="description" class="form-control" rows="4" 
                                  placeholder="Enter course description"></textarea>
                    </div>

                    <div class="btn-container">
                        <button type="submit" class="btn-custom btn-primary-custom">
                            <i class="fas fa-plus"></i> Create Course
                        </button>
                        <a href="${pageContext.request.contextPath}/course" class="btn-custom btn-secondary-custom">
                            <i class="fas fa-arrow-left"></i> Back to List
                        </a>
                    </div>
                </div>
            </form>
        </div>

        <%@include file="../footer.jsp" %>

        <!-- JS -->
        <script src="${pageContext.request.contextPath}/assets/js/vendor/jquery-1.12.4.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

        <script>
            $(document).ready(function () {
                // Initialize Select2
                $('#gradeId').select2({
                    placeholder: "-- Select Grade --",
                    allowClear: true
                });

                $('#subjectId').select2({
                    placeholder: "-- Select Subject --",
                    allowClear: true
                });

                // Handle grade selection
                $('#gradeId').on('change', function () {
                    const selectedGradeId = $(this).val();
                    const $subjectSelect = $('#subjectId');

                    if (selectedGradeId) {
                        // Filter subjects by selected grade
                        $subjectSelect.find('option').each(function () {
                            const $option = $(this);
                            const gradeId = $option.data('grade-id');

                            if (gradeId && gradeId != selectedGradeId) {
                                $option.hide();
                            } else {
                                $option.show();
                            }
                        });

                        // Clear subject selection if it doesn't match the grade
                        const currentSubjectGradeId = $subjectSelect.find('option:selected').data('grade-id');
                        if (currentSubjectGradeId && currentSubjectGradeId != selectedGradeId) {
                            $subjectSelect.val('').trigger('change');
                        }
                    } else {
                        // Show all subjects
                        $subjectSelect.find('option').show();
                        $subjectSelect.val('').trigger('change');
                    }

                    updateHierarchyDisplay();
                });

                // Handle subject selection
                $('#subjectId').on('change', function () {
                    updateHierarchyDisplay();
                });

                function updateHierarchyDisplay() {
                    const gradeId = $('#gradeId').val();
                    const subjectId = $('#subjectId').val();

                    if (gradeId && subjectId) {
                        const gradeName = $('#gradeId option:selected').text();
                        const subjectName = $('#subjectId option:selected').text();

                        $('#selectedGradeName').text(gradeName);
                        $('#selectedSubjectName').text(subjectName);
                        $('#hierarchyDisplay').show();
                        $('#courseDetailsSection').show();
                    } else {
                        $('#hierarchyDisplay').hide();
                        $('#courseDetailsSection').hide();
                    }
                }

                // Initialize if pre-selected values exist
                <c:if test="${preSelectedGradeId != null && preSelectedSubjectId != null}">
                updateHierarchyDisplay();
                </c:if>

                // Form validation
                $('#courseForm').on('submit', function (e) {
                    const gradeId = $('#gradeId').val();
                    const subjectId = $('#subjectId').val();
                    const courseTitle = $('#courseTitle').val().trim();
                    const price = $('#price').val();
                    const durationDays = $('#durationDays').val();

                    if (!gradeId) {
                        e.preventDefault();
                        alert('Please select a grade.');
                        return false;
                    }

                    if (!subjectId) {
                        e.preventDefault();
                        alert('Please select a subject.');
                        return false;
                    }

                    if (!courseTitle) {
                        e.preventDefault();
                        alert('Please enter a course title.');
                        return false;
                    }

                    if (!price || price <= 0) {
                        e.preventDefault();
                        alert('Please enter a valid price.');
                        return false;
                    }

                    if (!durationDays || durationDays <= 0) {
                        e.preventDefault();
                        alert('Please enter a valid duration.');
                        return false;
                    }

                    return confirm('Are you sure you want to create this course?\n\n' +
                            'Grade: ' + $('#gradeId option:selected').text() + '\n' +
                            'Subject: ' + $('#subjectId option:selected').text() + '\n' +
                            'Course: ' + courseTitle);
                });
            });
        </script>
    </body>
</html>