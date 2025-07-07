<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Subject Management</title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- CSS here -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
        <!-- Select2 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
        <style>
            body {
                padding-top: 130px;
                background-color: #f8f9fa;
            }
            main {
                max-width: 1200px;
                margin: 40px auto;
                padding: 20px;
                background: white;
                border-radius: 12px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }

            /* Filter Section */
            .filter-section {
                background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
                border-radius: 8px;
                padding: 20px;
                margin-bottom: 25px;
                border: 1px solid #dee2e6;
            }

            .filter-row {
                display: flex;
                flex-wrap: wrap;
                gap: 15px;
                align-items: end;
            }

            .filter-group {
                min-width: 200px;
                flex: 1;
            }

            .filter-group label {
                font-weight: 600;
                color: #495057;
                margin-bottom: 5px;
                display: block;
            }

            .filter-group select,
            .filter-group input {
                width: 100%;
                padding: 8px 12px;
                border: 1px solid #ced4da;
                border-radius: 4px;
                font-size: 14px;
            }

            .filter-actions {
                display: flex;
                gap: 10px;
                align-items: end;
            }

            .btn-filter {
                padding: 8px 20px;
                border-radius: 4px;
                border: none;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .btn-primary {
                background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
                color: white;
            }

            .btn-secondary {
                background: #6c757d;
                color: white;
            }

            .btn-filter:hover {
                transform: translateY(-1px);
                box-shadow: 0 2px 8px rgba(0,0,0,0.15);
            }

            /* Results info */
            .results-info {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
                padding: 15px 0;
                border-bottom: 1px solid #dee2e6;
            }

            .results-count {
                font-weight: 600;
                color: #495057;
            }

            .page-size-selector {
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .page-size-selector select {
                padding: 5px 10px;
                border: 1px solid #ced4da;
                border-radius: 4px;
            }

            /* Success notification */
            .success-notification {
                background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
                border: 1px solid #28a745;
                border-radius: 8px;
                padding: 20px;
                margin-bottom: 20px;
                position: relative;
            }
            .success-notification h5 {
                color: #155724;
                margin-bottom: 15px;
            }
            .success-notification p {
                color: #155724;
                margin-bottom: 15px;
            }
            .btn-create-course {
                background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 6px;
                text-decoration: none;
                font-weight: 600;
                margin-right: 10px;
            }
            .btn-create-course:hover {
                color: white;
                transform: translateY(-2px);
                box-shadow: 0 4px 15px rgba(0,123,255,0.3);
            }
            .btn-dismiss {
                background: #6c757d;
                color: white;
                border: none;
                padding: 8px 15px;
                border-radius: 4px;
                cursor: pointer;
            }

            /* Fixed button group styling */
            .btn-group {
                display: flex;
                flex-direction: row;
                gap: 8px;
                align-items: center;
                justify-content: center;
                flex-wrap: wrap;
            }

            .btn-group .btn {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                padding: 8px 12px;
                font-size: 0.875rem;
                line-height: 1.5;
                border-radius: 4px;
                text-decoration: none;
                border: 1px solid transparent;
                transition: all 0.15s ease-in-out;
                white-space: nowrap;
                min-width: auto;
                margin: 0;
            }

            .btn-group .btn i {
                margin-right: 4px;
                font-size: 0.875rem;
            }

            .btn-group .btn:hover {
                text-decoration: none;
                transform: translateY(-1px);
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }

            /* Button variants */
            .btn-outline-primary {
                color: #0d6efd;
                border-color: #0d6efd;
                background-color: transparent;
            }

            .btn-outline-primary:hover {
                color: #fff !important;
                background-color: #0d6efd;
                border-color: #0d6efd;
            }

            .btn-outline-success {
                color: #198754;
                border-color: #198754;
                background-color: transparent;
            }

            .btn-outline-success:hover {
                color: #fff !important;
                background-color: #198754;
                border-color: #198754;
            }

            .btn-outline-danger {
                color: #dc3545;
                border-color: #dc3545;
                background-color: transparent;
            }

            .btn-outline-danger:hover {
                color: #fff !important;
                background-color: #dc3545;
                border-color: #dc3545;
            }

            /* Table responsive improvements */
            .table-responsive {
                border-radius: 8px;
                overflow: hidden;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }

            .table th {
                background-color: #343a40;
                color: white;
                font-weight: 600;
                border: none;
                padding: 12px;
            }

            .table td {
                padding: 12px;
                vertical-align: middle;
                border-color: #dee2e6;
            }

            .table tbody tr:hover {
                background-color: #f8f9fa;
            }

            .badge {
                padding: 6px 12px;
                font-size: 0.75rem;
                font-weight: 600;
                border-radius: 20px;
            }

            .bg-primary {
                background-color: #0d6efd !important;
            }

            /* Action column width */
            .action-column {
                width: 220px;
                min-width: 220px;
            }

            /* Pagination */
            .pagination-container {
                display: flex;
                justify-content: center;
                align-items: center;
                margin-top: 30px;
                padding-top: 20px;
                border-top: 1px solid #dee2e6;
            }

            .pagination {
                display: flex;
                align-items: center;
                gap: 5px;
            }

            .pagination a,
            .pagination span {
                padding: 8px 12px;
                text-decoration: none;
                border: 1px solid #dee2e6;
                border-radius: 4px;
                color: #495057;
                transition: all 0.3s ease;
            }

            .pagination a:hover {
                background-color: #e9ecef;
                color: #495057;
                text-decoration: none;
            }

            .pagination .current {
                background-color: #007bff;
                color: white;
                border-color: #007bff;
            }

            .pagination .disabled {
                color: #6c757d;
                background-color: #f8f9fa;
                cursor: not-allowed;
            }

            /* Responsive adjustments */
            @media (max-width: 768px) {
                .filter-row {
                    flex-direction: column;
                }

                .filter-group {
                    min-width: 100%;
                }

                .results-info {
                    flex-direction: column;
                    gap: 10px;
                    align-items: flex-start;
                }

                .btn-group {
                    flex-direction: column;
                    gap: 4px;
                    width: 100%;
                }

                .btn-group .btn {
                    width: 100%;
                    justify-content: center;
                }

                .action-column {
                    width: auto;
                    min-width: auto;
                }
            }
            .btn-group-vertical {
                width: 100%;
            }

            .btn-group-vertical .btn-group {
                width: 100%;
            }

            .btn-group-vertical .btn {
                border-radius: 4px !important;
                margin: 1px 0;
                font-size: 0.8rem;
                padding: 6px 10px;
                white-space: nowrap;
            }

            .btn-group .btn {
                flex: 1;
                font-size: 0.75rem;
                padding: 5px 8px;
            }

            /* Primary action styling */
            .btn-primary {
                background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
                border: none;
                font-weight: 600;
            }

            .btn-primary:hover {
                background: linear-gradient(135deg, #0056b3 0%, #004085 100%);
                transform: translateY(-1px);
                box-shadow: 0 2px 8px rgba(0,123,255,0.3);
            }

            /* Outline button enhancements */
            .btn-outline-primary:hover,
            .btn-outline-info:hover,
            .btn-outline-success:hover,
            .btn-outline-secondary:hover {
                transform: translateY(-1px);
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }

            /* Dropdown styling */
            .dropdown-menu {
                border-radius: 8px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.15);
                border: 1px solid #e9ecef;
                padding: 8px 0;
            }

            .dropdown-item {
                padding: 8px 16px;
                font-size: 0.875rem;
                transition: all 0.2s ease;
            }

            .dropdown-item:hover {
                background-color: #f8f9fa;
                transform: translateX(4px);
            }

            .dropdown-item i {
                width: 16px;
                margin-right: 8px;
                text-align: center;
            }

            .dropdown-item.text-danger:hover {
                background-color: #f8d7da;
                color: #721c24 !important;
            }

            /* Action column responsive */
            .action-column {
                width: 200px;
                min-width: 200px;
            }

            @media (max-width: 768px) {
                .action-column {
                    width: auto;
                    min-width: 160px;
                }

                .btn-group .btn {
                    font-size: 0.7rem;
                    padding: 4px 6px;
                }

                .btn-group-vertical .btn {
                    font-size: 0.75rem;
                    padding: 5px 8px;
                }
            }

            /* Success notification enhancements */
            .success-notification {
                border-left: 4px solid #28a745;
                animation: slideInDown 0.5s ease-out;
            }

            @keyframes slideInDown {
                from {
                    transform: translateY(-20px);
                    opacity: 0;
                }
                to {
                    transform: translateY(0);
                    opacity: 1;
                }
            }

            .btn-create-course {
                transition: all 0.3s ease;
            }

            .btn-create-course:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 15px rgba(0,123,255,0.3);
            }

            /* Table enhancements */
            .table tbody tr {
                transition: background-color 0.2s ease;
            }

            .table tbody tr:hover {
                background-color: #f8f9fa;
            }

            /* Badge enhancements */
            .badge {
                font-size: 0.8em;
                padding: 6px 12px;
                font-weight: 600;
            }

            .bg-primary {
                background: linear-gradient(135deg, #007bff 0%, #0056b3 100%) !important;
            }
        </style>
    </head>
    <body>
        <%@include file="../header.jsp" %>

        <main>
            <h2 class="text-center mb-4">Subject Management</h2>

            <!-- Success notification for new subject creation -->
            <c:if test="${sessionScope.subjectCreated != null && sessionScope.subjectCreated}">
                <div class="success-notification" id="courseCreationNotification">
                    <h5><i class="fas fa-check-circle"></i> Subject Created Successfully!</h5>
                    <p>Subject "<strong>${sessionScope.newSubjectName}</strong>" has been created successfully.</p>
                    <p>Would you like to create a course for this subject now?</p>
                    <div>
                        <a href="${pageContext.request.contextPath}/course?action=create&subjectId=${sessionScope.newSubjectId}" 
                           class="btn-create-course">
                            <i class="fas fa-plus"></i> Create Course Now
                        </a>
                        <button type="button" class="btn-dismiss" onclick="dismissNotification()">
                            <i class="fas fa-times"></i> Maybe Later
                        </button>
                    </div>
                </div>
            </c:if>

            <!-- Error and success messages -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <!-- Filter Section -->
            <div class="filter-section">
                <form method="get" action="subjects" id="filterForm">
                    <div class="filter-row">
                        <div class="filter-group">
                            <label for="gradeFilter">Grade:</label>
                            <select id="gradeFilter" name="gradeId">
                                <option value="">All Grades</option>
                                <c:forEach items="${grades}" var="grade">
                                    <option value="${grade.id}" 
                                            ${selectedGradeId != null && selectedGradeId == grade.id ? 'selected' : ''}>
                                        ${grade.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="filter-group">
                            <label for="nameFilter">Subject Name:</label>
                            <input type="text" id="nameFilter" name="name" 
                                   placeholder="Search by subject name..." 
                                   value="${selectedName}">
                        </div>

                        <div class="filter-actions">
                            <button type="submit" class="btn-filter btn-primary">
                                <i class="fas fa-search"></i> Filter
                            </button>
                            <button type="button" class="btn-filter btn-secondary" onclick="clearFilters()">
                                <i class="fas fa-times"></i> Clear
                            </button>
                        </div>
                    </div>

                    <!-- Hidden fields to preserve pagination -->
                    <input type="hidden" name="page" value="1">
                    <input type="hidden" name="pageSize" value="${pageSize}">
                </form>
            </div>

            <!-- Results Info -->
            <div class="results-info">
                <div class="results-count">
                    <c:choose>
                        <c:when test="${totalSubjects > 0}">
                            <div class="results-count">
                                <c:choose>
                                    <c:when test="${totalSubjects > 0}">
                                        Showing ${displayStart} - ${displayEnd} of ${totalSubjects} subjects
                                    </c:when>
                                    <c:otherwise>
                                        No subjects found
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:when>
                        <c:otherwise>
                            No subjects found
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="d-flex gap-3 align-items-center">
                    <div class="page-size-selector">
                        <label for="pageSizeSelect">Show:</label>
                        <select id="pageSizeSelect" onchange="changePageSize(this.value)">
                            <option value="5" ${pageSize == 5 ? 'selected' : ''}>5</option>
                            <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                            <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                            <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                        </select>
                        <span>per page</span>
                    </div>

                    <a href="subjects?action=create" class="btn btn-success">
                        <i class="fas fa-plus"></i> Add New Subject
                    </a>
                </div>
            </div>

            <!-- Subject table -->
            <div class="table-responsive">
                <table class="table table-striped table-hover">
                    <thead class="table-dark">
                        <tr>
                            <th>ID</th>
                            <th>Subject Name</th>
                            <th>Grade</th>
                            <th>Description</th>
                            <th class="action-column">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty subjectList}">
                                <c:forEach var="subject" items="${subjectList}">
                                    <tr>
                                        <td>${subject.id}</td>
                                        <td><strong>${subject.name}</strong></td>
                                        <td>
                                            <span class="badge bg-primary">
                                                ${gradeMap[subject.grade_id]}
                                            </span>
                                        </td>
                                        <td>${subject.description}</td>
                                        <td class="action-column">
                                            <div class="btn-group-vertical" role="group" aria-label="Subject actions">
                                                <!-- Primary Actions -->
                                                <div class="btn-group mb-1" role="group">
                                                    <a href="subjects?action=edit&id=${subject.id}" 
                                                       class="btn btn-outline-primary btn-sm" 
                                                       title="Edit Subject Details">
                                                        <i class="fas fa-edit"></i> Edit
                                                    </a>
<!--                                                    <a href="${pageContext.request.contextPath}/course?action=create&subjectId=${subject.id}" 
                                                       class="btn btn-primary btn-sm" 
                                                       title="Create New Course for this Subject">
                                                        <i class="fas fa-plus-circle"></i> New Course
                                                    </a>-->
                                                </div>

                                                <!-- Secondary Actions -->
                                                <div class="btn-group mb-1" role="group">
                                                    <a href="${pageContext.request.contextPath}/course?subjectId=${subject.id}" 
                                                       class="btn btn-outline-info btn-sm" 
                                                       title="View All Courses in this Subject">
                                                        <i class="fas fa-graduation-cap"></i> View Courses
                                                    </a>
                                                </div>

                                                <!-- Management Actions -->
                                                <div class="btn-group" role="group">
                                                    <div class="dropdown">
                                                        <button class="btn btn-outline-secondary btn-sm dropdown-toggle" 
                                                                type="button" 
                                                                id="subjectActions${subject.id}" 
                                                                data-bs-toggle="dropdown" 
                                                                aria-expanded="false"
                                                                title="More Actions">
                                                            <i class="fas fa-cog"></i> More
                                                        </button>
                                                        <ul class="dropdown-menu" aria-labelledby="subjectActions${subject.id}">
                                                            <li>
                                                                <a class="dropdown-item" href="${pageContext.request.contextPath}/chapter?subject_id=${subject.id}">
                                                                    <i class="fas fa-list"></i> View Chapters
                                                                </a>
                                                            </li>
                                                            <li>
                                                                <a class="dropdown-item" href="${pageContext.request.contextPath}/LessonURL?subjectId=${subject.id}">
                                                                    <i class="fas fa-play-circle"></i> View Lessons
                                                                </a>
                                                            </li>
                                                            <li>
                                                                <a class="dropdown-item" href="${pageContext.request.contextPath}/Question?subjectId=${subject.id}">
                                                                    <i class="fas fa-question-circle"></i> View Questions
                                                                </a>
                                                            </li>
                                                            <li><hr class="dropdown-divider"></li>
                                                            <li>
                                                                <a class="dropdown-item text-danger" 
                                                                   href="subjects?action=delete&id=${subject.id}"
                                                                   onclick="return confirmDelete('${subject.name}', ${subject.id})"
                                                                   title="Delete Subject">
                                                                    <i class="fas fa-trash"></i> Delete Subject
                                                                </a>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="5" class="text-center text-muted">
                                        <i class="fas fa-inbox fa-2x mb-2"></i>
                                        <br>No subjects found.
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
                <div class="pagination-container">
                    <div class="pagination">
                        <!-- First page -->
                        <c:if test="${currentPage > 1}">
                            <a href="javascript:void(0)" onclick="goToPage(1)" title="First page">
                                <i class="fas fa-angle-double-left"></i>
                            </a>
                        </c:if>

                        <!-- Previous page -->
                        <c:if test="${currentPage > 1}">
                            <a href="javascript:void(0)" onclick="goToPage(${currentPage - 1})" title="Previous page">
                                <i class="fas fa-angle-left"></i>
                            </a>
                        </c:if>

                        <!-- Page numbers -->
                        <c:forEach begin="${startPage}" end="${endPage}" var="pageNum">
                            <c:choose>
                                <c:when test="${pageNum == currentPage}">
                                    <span class="current">${pageNum}</span>
                                </c:when>
                                <c:otherwise>
                                    <a href="javascript:void(0)" onclick="goToPage(${pageNum})">${pageNum}</a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>

                        <!-- Next page -->
                        <c:if test="${currentPage < totalPages}">
                            <a href="javascript:void(0)" onclick="goToPage(${currentPage + 1})" title="Next page">
                                <i class="fas fa-angle-right"></i>
                            </a>
                        </c:if>

                        <!-- Last page -->
                        <c:if test="${currentPage < totalPages}">
                            <a href="javascript:void(0)" onclick="goToPage(${totalPages})" title="Last page">
                                <i class="fas fa-angle-double-right"></i>
                            </a>
                        </c:if>
                    </div>
                </div>
            </c:if>
        </main>

        <%@include file="../footer.jsp" %>

        <!-- JS -->
        <script src="${pageContext.request.contextPath}/assets/js/vendor/jquery-1.12.4.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4" crossorigin="anonymous"></script>
        <!-- Select2 JS -->
        <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
        <script>
                                // Initialize page
                                $(document).ready(function () {
                                    // Disable nice-select initialization completely
                                    if (typeof $.fn.niceSelect !== 'undefined') {
                                        $.fn.niceSelect = function () {
                                            return this;
                                        };
                                    }

                                    // Destroy any existing Select2 instances and nice-select
                                    $('select').each(function () {
                                        if ($(this).hasClass('select2-hidden-accessible')) {
                                            $(this).select2('destroy');
                                        }
                                        // Remove nice-select if exists
                                        if ($(this).next('.nice-select').length) {
                                            $(this).next('.nice-select').remove();
                                            $(this).show();
                                        }
                                    });

                                    // Initialize Select2 for all select elements
                                    $('select').select2({
                                        placeholder: function () {
                                            return $(this).find('option:first').text() || 'Select...';
                                        },
                                        allowClear: true,
                                        width: '100%',
                                        dropdownParent: $('body')
                                    });

                                    // Auto-submit form when Enter is pressed in search field
                                    $('#nameFilter').on('keypress', function (e) {
                                        if (e.which === 13) {
                                            $('#filterForm').submit();
                                        }
                                    });
                                });

                                function dismissNotification() {
                                    const notification = document.getElementById('courseCreationNotification');
                                    if (notification) {
                                        notification.style.transition = 'all 0.5s ease';
                                        notification.style.transform = 'translateY(-20px)';
                                        notification.style.opacity = '0';

                                        setTimeout(() => {
                                            notification.style.display = 'none';
                                        }, 500);
                                    }

                                    // Clear session attributes via AJAX
                                    fetch('${pageContext.request.contextPath}/subjects?action=clearNotification', {
                                        method: 'POST'
                                    });
                                }

                                function clearFilters() {
                                    $('#gradeFilter').val('').trigger('change');
                                    $('#nameFilter').val('');

                                    // Add visual feedback
                                    const clearBtn = event.target;
                                    const originalText = clearBtn.innerHTML;
                                    clearBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Clearing...';
                                    clearBtn.disabled = true;

                                    setTimeout(() => {
                                        $('#filterForm').submit();
                                    }, 300);
                                }

                                function changePageSize(newPageSize) {
                                    const form = $('#filterForm');
                                    const pageSizeSelect = $('#pageSizeSelect');

                                    // Add loading state
                                    pageSizeSelect.prop('disabled', true);

                                    form.find('input[name="pageSize"]').val(newPageSize);
                                    form.find('input[name="page"]').val(1); // Reset to first page

                                    setTimeout(() => {
                                        form.submit();
                                    }, 200);
                                }

                                function goToPage(pageNumber) {
                                    const form = $('#filterForm');

                                    // Add loading overlay
                                    $('body').append('<div id="pageLoadingOverlay" style="position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(255,255,255,0.8); z-index: 9999; display: flex; align-items: center; justify-content: center;"><div class="spinner-border text-primary" role="status"><span class="visually-hidden">Loading...</span></div></div>');

                                    form.find('input[name="page"]').val(pageNumber);

                                    setTimeout(() => {
                                        form.submit();
                                    }, 300);
                                }

                                function confirmDelete(subjectName, subjectId) {
                                    const modal = `
        <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header bg-danger text-white">
                        <h5 class="modal-title">
                            <i class="fas fa-exclamation-triangle"></i> Confirm Deletion
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="text-center mb-3">
                            <i class="fas fa-trash fa-3x text-danger mb-3"></i>
                            <h6>Are you sure you want to delete this subject?</h6>
                        </div>
                        <div class="alert alert-warning">
                            <strong>Subject:</strong> ${subjectName}<br>
                            <strong>Warning:</strong> This action cannot be undone. All related chapters, lessons, and courses will be affected.
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times"></i> Cancel
                        </button>
                        <button type="button" class="btn btn-danger" onclick="proceedDelete(${subjectId})">
                            <i class="fas fa-trash"></i> Delete Subject
                        </button>
                    </div>
                </div>
            </div>
        </div>
    `;

                                    // Remove existing modal if any
                                    const existingModal = document.getElementById('deleteConfirmModal');
                                    if (existingModal) {
                                        existingModal.remove();
                                    }

                                    // Add modal to body
                                    document.body.insertAdjacentHTML('beforeend', modal);

                                    // Show modal
                                    const modalElement = document.getElementById('deleteConfirmModal');
                                    const bootstrapModal = new bootstrap.Modal(modalElement);
                                    bootstrapModal.show();

                                    // Clean up modal after hiding
                                    modalElement.addEventListener('hidden.bs.modal', function () {
                                        modalElement.remove();
                                    });

                                    return false; // Prevent default link action
                                }

                                function proceedDelete(subjectId) {
                                    // Show loading state
                                    const deleteBtn = document.querySelector('#deleteConfirmModal .btn-danger');
                                    const originalText = deleteBtn.innerHTML;
                                    deleteBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Deleting...';
                                    deleteBtn.disabled = true;

                                    // Proceed with deletion
                                    window.location.href = `subjects?action=delete&id=${subjectId}`;
                                }

                                $(document).ready(function () {
                                    const notification = document.getElementById('courseCreationNotification');
                                    if (notification) {
                                        let countdown = 10;
                                        const dismissBtn = notification.querySelector('.btn-dismiss');
                                        const originalText = dismissBtn.textContent;

                                        const timer = setInterval(() => {
                                            countdown--;
                                            dismissBtn.innerHTML = `<i class="fas fa-clock"></i> Auto-dismiss in ${countdown}s`;

                                            if (countdown <= 0) {
                                                clearInterval(timer);
                                                dismissNotification();
                                            }
                                        }, 1000);

                                        // Stop countdown if user interacts
                                        notification.addEventListener('mouseenter', () => {
                                            clearInterval(timer);
                                            dismissBtn.innerHTML = originalText;
                                        });
                                    }
                                });

                                $(document).ready(function () {
                                    // Add hover effects to action buttons
                                    $('.btn-group .btn').hover(
                                            function () {
                                                $(this).addClass('shadow-sm');
                                            },
                                            function () {
                                                $(this).removeClass('shadow-sm');
                                            }
                                    );

                                    // Add click feedback
                                    $('.btn').on('click', function () {
                                        const btn = $(this);
                                        btn.addClass('btn-clicked');
                                        setTimeout(() => {
                                            btn.removeClass('btn-clicked');
                                        }, 150);
                                    });
                                });

// Add CSS for click feedback
                                const style = document.createElement('style');
                                style.textContent = `
    .btn-clicked {
        transform: scale(0.95) !important;
        transition: transform 0.1s ease !important;
    }
`;
                                document.head.appendChild(style);

                                $(document).ready(function () {
                                    $('[title]').tooltip();
                                });
        </script>
    </body>
</html>
