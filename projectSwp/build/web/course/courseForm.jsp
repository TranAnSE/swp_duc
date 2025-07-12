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
        <title>${isEdit ? 'Edit Course' : 'Create New Course'}</title>
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

            /* Select2 Custom Styling */
            .select2-container {
                width: 100% !important;
                z-index: 1000;
            }
            .select2-selection--single {
                height: 48px !important;
                padding: 12px 15px !important;
                border-radius: 6px !important;
                border: 1px solid #ced4da !important;
                font-size: 16px !important;
                line-height: 24px !important;
            }
            .select2-selection__rendered {
                line-height: 24px !important;
                padding-left: 0 !important;
                color: #495057 !important;
            }
            .select2-selection__arrow {
                height: 46px !important;
                right: 15px !important;
            }
            .select2-container--focus .select2-selection--single {
                border-color: #007bff !important;
                box-shadow: 0 0 0 0.2rem rgba(0,123,255,.25) !important;
            }
            .select2-dropdown {
                border-radius: 6px !important;
                border: 1px solid #ced4da !important;
                box-shadow: 0 4px 6px rgba(0,0,0,0.1) !important;
                z-index: 9999 !important;
            }
            .select2-results__option {
                padding: 12px 15px !important;
                font-size: 16px !important;
            }
            .select2-results__option--highlighted {
                background-color: #007bff !important;
            }
            .select2-search--dropdown .select2-search__field {
                padding: 8px 12px !important;
                border-radius: 4px !important;
                border: 1px solid #ced4da !important;
                font-size: 16px !important;
            }
            .text-muted {
                font-size: 0.875em;
                color: #6c757d !important;
                margin-top: 5px;
            }

            /* Hide nice-select elements */
            .nice-select {
                display: none !important;
            }
        </style>
    </head>
    <body>
        <%@include file="../header.jsp" %>

        <div class="form-container">
            <h2 class="text-center mb-4">${isEdit ? 'Edit Course' : 'Create New Course'}</h2>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger">${errorMessage}</div>
            </c:if>

            <c:if test="${not empty message}">
                <div class="alert alert-success">${message}</div>
            </c:if>

            <c:choose>
                <c:when test="${isEdit}">
                    <!-- Edit Mode Form -->
                    <form id="courseForm" action="course" method="post">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="courseId" value="${courseDetails.course_id}">

                        <!-- Pre-filled form fields -->
                        <div class="form-group">
                            <label for="gradeId" class="form-label">Grade <span class="required">*</span></label>
                            <select id="gradeId" name="gradeId" class="form-select select2-enabled" required disabled>
                                <c:forEach items="${grades}" var="grade">
                                    <option value="${grade.id}" 
                                            ${courseDetails.grade_id == grade.id ? 'selected' : ''}>
                                        ${grade.name}
                                    </option>
                                </c:forEach>
                            </select>
                            <!-- Add hidden field for gradeId since select is disabled -->
                            <input type="hidden" name="gradeId" value="${courseDetails.grade_id}">
                            <small class="text-muted">Grade cannot be changed after course creation</small>
                        </div>

                        <div class="form-group">
                            <label for="subjectId" class="form-label">Subject <span class="required">*</span></label>
                            <select id="subjectId" name="subjectId" class="form-select select2-enabled" required disabled>
                                <c:forEach items="${subjects}" var="subject">
                                    <option value="${subject.id}" 
                                            ${courseDetails.subject_id == subject.id ? 'selected' : ''}>
                                        ${subject.name}
                                    </option>
                                </c:forEach>
                            </select>
                            <!-- Add hidden field for subjectId since select is disabled -->
                            <input type="hidden" name="subjectId" value="${courseDetails.subject_id}">
                            <small class="text-muted">Subject cannot be changed after course creation</small>
                        </div>

                        <!-- Hierarchy Display -->
                        <div class="hierarchy-display">
                            <h5><i class="fas fa-sitemap"></i> Course Hierarchy</h5>
                            <div class="hierarchy-path">
                                <span>${courseDetails.grade_name}</span>
                                <i class="fas fa-arrow-right hierarchy-arrow"></i>
                                <span>${courseDetails.subject_name}</span>
                                <i class="fas fa-arrow-right hierarchy-arrow"></i>
                                <span><strong>${courseDetails.course_title}</strong></span>
                            </div>
                        </div>

                        <!-- Editable fields -->
                        <div class="form-group">
                            <label for="courseTitle" class="form-label">Course Title <span class="required">*</span></label>
                            <input type="text" id="courseTitle" name="courseTitle" class="form-control" 
                                   value="${courseDetails.course_title}" required maxlength="500">
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="price" class="form-label">Price (VND) <span class="required">*</span></label>
                                    <input type="number" id="price" name="price" class="form-control" 
                                           value="${courseDetails.price}" required min="0" step="1000">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="durationDays" class="form-label">Duration (Days) <span class="required">*</span></label>
                                    <input type="number" id="durationDays" name="durationDays" class="form-control" 
                                           value="${courseDetails.duration_days}" required min="1" max="3650">
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="description" class="form-label">Course Description</label>
                            <textarea id="description" name="description" class="form-control" rows="4">${courseDetails.description}</textarea>
                        </div>

                        <div class="btn-container">
                            <button type="submit" class="btn-custom btn-primary-custom">
                                <i class="fas fa-save"></i> Update Course
                            </button>
                            <a href="${pageContext.request.contextPath}/course?action=build&id=${courseDetails.course_id}" 
                               class="btn-custom btn-secondary-custom">
                                <i class="fas fa-arrow-left"></i> Back to Course Builder
                            </a>
                        </div>
                    </form>
                </c:when>
                <c:otherwise>
                    <!-- Create Mode Form -->
                    <form id="courseForm" action="course" method="post">
                        <input type="hidden" name="action" value="create">

                        <!-- Step 1: Grade and Subject Selection -->
                        <div class="form-group">
                            <label for="gradeId" class="form-label">Select Grade <span class="required">*</span></label>
                            <select id="gradeId" name="gradeId" class="form-select select2-enabled" required>
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
                            <select id="subjectId" name="subjectId" class="form-select select2-enabled" required>
                                <option value="">-- Select Subject --</option>
                                <c:forEach items="${subjects}" var="subject">
                                    <option value="${subject.id}" 
                                            data-grade-id="${subject.grade_id}"
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
                </c:otherwise>
            </c:choose>
        </div>

        <%@include file="../footer.jsp" %>

        <!-- JS -->
        <script src="${pageContext.request.contextPath}/assets/js/vendor/jquery-1.12.4.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>
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

                // Initialize Select2 with proper configuration
                $('.select2-enabled').select2({
                    placeholder: function () {
                        return $(this).data('placeholder') || '-- Select --';
                    },
                    allowClear: true,
                    width: '100%',
                    dropdownParent: $('body')
                });

            <c:choose>
                <c:when test="${isEdit}">
                // Edit mode - form validation
                $('#courseForm').on('submit', function (e) {
                    const courseTitle = $('#courseTitle').val().trim();
                    const price = $('#price').val();
                    const durationDays = $('#durationDays').val();

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

                    return confirm('Are you sure you want to update this course?');
                });
                </c:when>
                <c:otherwise>
                // Create mode functionality

                // Handle grade selection
                $('#gradeId').on('change', function () {
                    const selectedGradeId = $(this).val();
                    const $subjectSelect = $('#subjectId');

                    if (selectedGradeId) {
                        // Show loading state
                        $subjectSelect.html('<option value="">Loading subjects...</option>');
                        $subjectSelect.prop('disabled', true);

                        // Fetch subjects for selected grade
                        $.ajax({
                            url: '${pageContext.request.contextPath}/course',
                            type: 'GET',
                            data: {
                                action: 'getSubjectsByGrade',
                                gradeId: selectedGradeId
                            },
                            dataType: 'json',
                            success: function (subjects) {
                                $subjectSelect.html('<option value="">-- Select Subject --</option>');

                                if (subjects.length === 0) {
                                    $subjectSelect.html('<option value="">No subjects available for this grade</option>');
                                    // Show message to create subject
                                    showNoSubjectsMessage(selectedGradeId);
                                } else {
                                    $.each(subjects, function (index, subject) {
                                        $subjectSelect.append(
                                                '<option value="' + subject.id + '">' +
                                                escapeHtml(subject.name) + '</option>'
                                                );
                                    });
                                    hideNoSubjectsMessage();
                                }

                                $subjectSelect.prop('disabled', false);

                                // Refresh Select2
                                $subjectSelect.select2('destroy').select2({
                                    placeholder: '-- Select Subject --',
                                    allowClear: true,
                                    width: '100%',
                                    dropdownParent: $('body')
                                });

                                // Check if pre-selected subject matches
                    <c:if test="${preSelectedSubjectId != null}">
                                $subjectSelect.val('${preSelectedSubjectId}').trigger('change');
                    </c:if>
                            },
                            error: function () {
                                $subjectSelect.html('<option value="">Error loading subjects</option>');
                                $subjectSelect.prop('disabled', false);
                                showNoSubjectsMessage(selectedGradeId);
                            }
                        });
                    } else {
                        // Reset subject selection
                        $subjectSelect.html('<option value="">-- Select Subject --</option>');
                        $subjectSelect.prop('disabled', false);
                        hideNoSubjectsMessage();

                        // Refresh Select2
                        $subjectSelect.select2('destroy').select2({
                            placeholder: '-- Select Subject --',
                            allowClear: true,
                            width: '100%',
                            dropdownParent: $('body')
                        });
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

                // Form validation for create mode
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
                </c:otherwise>
            </c:choose>
            });
            function showNoSubjectsMessage(gradeId) {
                const gradeName = $('#gradeId option:selected').text();
                let messageHtml = '<div id="noSubjectsAlert" class="alert alert-warning mt-3">';
                messageHtml += '<i class="fas fa-exclamation-triangle"></i> ';
                messageHtml += 'No subjects available for <strong>' + escapeHtml(gradeName) + '</strong>. ';
                messageHtml += '<a href="${pageContext.request.contextPath}/subjects?action=create&gradeId=' + gradeId + '" class="alert-link">';
                messageHtml += 'Create a subject first</a>.';
                messageHtml += '</div>';

                // Remove existing message
                $('#noSubjectsAlert').remove();

                // Add message after subject select
                $('#subjectId').closest('.form-group').after(messageHtml);
            }

            function hideNoSubjectsMessage() {
                $('#noSubjectsAlert').remove();
            }

            function escapeHtml(text) {
                if (!text)
                    return '';
                const div = document.createElement('div');
                div.textContent = text;
                return div.innerHTML;
            }
        </script>
    </body>
</html>
