<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
    <head>
        <title>Test Management</title>
        <link rel="stylesheet" href="/assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="/assets/css/style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">

        <style>
            body {
                background: #f9f9f9;
                padding-top: 80px;
            }

            .container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 20px;
            }

            .page-header {
                background: white;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                margin-bottom: 30px;
            }

            .filters-section {
                background: white;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                margin-bottom: 20px;
            }

            .filter-row {
                display: grid;
                grid-template-columns: 2fr 1fr 1fr 1fr auto;
                gap: 15px;
                align-items: end;
            }

            .form-group {
                display: flex;
                flex-direction: column;
            }

            .form-group label {
                font-weight: 600;
                margin-bottom: 5px;
                color: #333;
            }

            .form-control {
                padding: 8px 12px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 14px;
            }

            .test-table {
                background: white;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                overflow: hidden;
            }

            .table {
                margin-bottom: 0;
            }

            .table th {
                background: #f8f9fa;
                border-bottom: 2px solid #dee2e6;
                font-weight: 600;
                color: #495057;
            }

            .table td {
                vertical-align: middle;
            }

            .test-badge {
                padding: 4px 8px;
                border-radius: 12px;
                font-size: 0.75em;
                font-weight: 500;
            }

            .badge-practice {
                background: #d4edda;
                color: #155724;
            }

            .badge-official {
                background: #f8d7da;
                color: #721c24;
            }

            .badge-course {
                background: #e2e3e5;
                color: #383d41;
            }

            .badge-general {
                background: #cce5ff;
                color: #004085;
            }

            .btn-group {
                display: flex;
                gap: 5px;
            }

            .btn-sm {
                padding: 4px 8px;
                font-size: 0.75em;
            }

            .pagination-container {
                background: white;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                margin-top: 20px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .pagination-info {
                color: #666;
                font-size: 0.9em;
            }

            .pagination {
                display: flex;
                gap: 5px;
                margin: 0;
            }

            .page-link {
                padding: 6px 12px;
                border: 1px solid #dee2e6;
                color: #007bff;
                text-decoration: none;
                border-radius: 4px;
                transition: all 0.2s ease;
            }

            .page-link:hover {
                background: #e9ecef;
                text-decoration: none;
            }

            .page-item.active .page-link {
                background: #007bff;
                color: white;
                border-color: #007bff;
            }

            .page-item.disabled .page-link {
                color: #6c757d;
                pointer-events: none;
                background: #fff;
                border-color: #dee2e6;
            }

            .empty-state {
                text-align: center;
                padding: 60px 20px;
                color: #666;
            }

            .empty-state i {
                font-size: 4em;
                margin-bottom: 20px;
                color: #ddd;
            }

            @media (max-width: 768px) {
                .filter-row {
                    grid-template-columns: 1fr;
                    gap: 10px;
                }

                .pagination-container {
                    flex-direction: column;
                    gap: 15px;
                    text-align: center;
                }

                .table-responsive {
                    font-size: 0.875em;
                }
            }
        </style>
    </head>

    <body>
        <jsp:include page="../header.jsp" />

        <div class="container">
            <!-- Page Header -->
            <div class="page-header">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h2><i class="fas fa-clipboard-list"></i> Test Management</h2>
                        <p class="text-muted mb-0">Create and manage tests for your courses</p>
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/test?action=create" class="btn btn-primary">
                            <i class="fas fa-plus"></i> Create New Test
                        </a>
                    </div>
                </div>
            </div>

            <!-- Filters -->
            <div class="filters-section">
                <form method="get" action="${pageContext.request.contextPath}/test">
                    <div class="filter-row">
                        <div class="form-group">
                            <label for="search">Search Tests</label>
                            <input type="text" id="search" name="search" class="form-control" 
                                   placeholder="Search by name or description..." 
                                   value="${searchKeyword}">
                        </div>

                        <div class="form-group">
                            <label for="testType">Test Type</label>
                            <select id="testType" name="testType" class="form-control">
                                <option value="all" ${selectedTestType == 'all' ? 'selected' : ''}>All Types</option>
                                <option value="practice" ${selectedTestType == 'practice' ? 'selected' : ''}>Practice Tests</option>
                                <option value="official" ${selectedTestType == 'official' ? 'selected' : ''}>Official Tests</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="courseId">Course</label>
                            <select id="courseId" name="courseId" class="form-control">
                                <option value="">All Courses</option>
                                <c:forEach var="course" items="${courses}">
                                    <option value="${course.course_id}" ${selectedCourseId == course.course_id ? 'selected' : ''}>
                                        ${course.course_title}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="pageSize">Per Page</label>
                            <select id="pageSize" name="pageSize" class="form-control">
                                <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                                <option value="25" ${pageSize == 25 ? 'selected' : ''}>25</option>
                                <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                            </select>
                        </div>

                        <div>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-search"></i> Filter
                            </button>
                            <a href="${pageContext.request.contextPath}/test" class="btn btn-outline-secondary">
                                <i class="fas fa-times"></i> Clear
                            </a>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Success/Error Messages -->
            <c:if test="${not empty message}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle"></i> ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-triangle"></i> ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Tests Table -->
            <c:choose>
                <c:when test="${empty testList}">
                    <div class="test-table">
                        <div class="empty-state">
                            <i class="fas fa-clipboard-list"></i>
                            <h4>No Tests Found</h4>
                            <p>No tests match your current filters. Try adjusting your search criteria.</p>
                            <a href="${pageContext.request.contextPath}/test?action=create" class="btn btn-primary">
                                <i class="fas fa-plus"></i> Create Your First Test
                            </a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="test-table">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Test Name</th>
                                        <th>Type</th>
                                        <th>Course/Context</th>
                                        <th>Duration</th>
                                        <th>Questions</th>
                                        <th>Created</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="test" items="${testList}">
                                        <tr>
                                            <td>
                                                <strong>${test.test_name}</strong>
                                                <c:if test="${not empty test.test_description}">
                                                    <br><small class="text-muted">${test.test_description}</small>
                                                </c:if>
                                            </td>
                                            <td>
                                                <span class="test-badge ${test.is_practice ? 'badge-practice' : 'badge-official'}">
                                                    <i class="fas ${test.is_practice ? 'fa-play-circle' : 'fa-certificate'}"></i>
                                                    ${test.is_practice ? 'Practice' : 'Official'}
                                                </span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty test.course_name}">
                                                        <span class="test-badge badge-course">
                                                            <i class="fas fa-graduation-cap"></i> ${test.course_name}
                                                        </span>
                                                        <c:if test="${not empty test.chapter_name}">
                                                            <br><small class="text-muted">Chapter: ${test.chapter_name}</small>
                                                        </c:if>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="test-badge badge-general">
                                                            <i class="fas fa-globe"></i> General Test
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <i class="fas fa-clock text-muted"></i> ${test.duration_minutes} min
                                            </td>
                                            <td>
                                                <i class="fas fa-question-circle text-muted"></i> ${test.total_questions_assigned}
                                            </td>
                                            <td>
                                                <small class="text-muted">
                                                    <fmt:formatDate value="${test.created_at}" pattern="MMM dd, yyyy" />
                                                    <c:if test="${not empty test.created_by_name}">
                                                        <br>by ${test.created_by_name}
                                                    </c:if>
                                                </small>
                                            </td>
                                            <td>
                                                <div class="btn-group">
                                                    <a href="${pageContext.request.contextPath}/test?action=edit&id=${test.test_id}" 
                                                       class="btn btn-outline-primary btn-sm" title="Edit Test">
                                                        <i class="fas fa-edit"></i>
                                                    </a>

                                                    <c:if test="${test.total_questions_assigned > 0}">
                                                        <a href="${pageContext.request.contextPath}/student/taketest?action=start&testId=${test.test_id}" 
                                                           class="btn btn-outline-success btn-sm" title="Preview Test" target="_blank">
                                                            <i class="fas fa-play"></i>
                                                        </a>
                                                    </c:if>

                                                    <c:if test="${not empty test.course_name}">
                                                        <a href="${pageContext.request.contextPath}/course?action=build&id=${test.course_id}" 
                                                           class="btn btn-outline-info btn-sm" title="Go to Course">
                                                            <i class="fas fa-external-link-alt"></i>
                                                        </a>
                                                    </c:if>

                                                    <button class="btn btn-outline-danger btn-sm" 
                                                            onclick="deleteTest(${test.test_id}, '${fn:escapeXml(test.test_name)}')"
                                                            title="Delete Test">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>

            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
                <div class="pagination-container">
                    <div class="pagination-info">
                        Showing ${displayStart} to ${displayEnd} of ${totalTests} tests
                    </div>

                    <nav>
                        <ul class="pagination">
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage - 1}&pageSize=${pageSize}&search=${searchKeyword}&testType=${selectedTestType}&courseId=${selectedCourseId}">
                                    <i class="fas fa-chevron-left"></i> Previous
                                </a>
                            </li>

                            <c:forEach begin="${startPage}" end="${endPage}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="?page=${i}&pageSize=${pageSize}&search=${searchKeyword}&testType=${selectedTestType}&courseId=${selectedCourseId}">${i}</a>
                                </li>
                            </c:forEach>

                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage + 1}&pageSize=${pageSize}&search=${searchKeyword}&testType=${selectedTestType}&courseId=${selectedCourseId}">
                                    Next <i class="fas fa-chevron-right"></i>
                                </a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </c:if>
        </div>

        <jsp:include page="../footer.jsp" />

        <!-- JS -->
        <script src="/assets/js/bootstrap.bundle.min.js"></script>

        <script>
                                                                function deleteTest(testId, testName) {
                                                                    if (!confirm('Are you sure you want to delete "' + testName + '"?\n\nThis action cannot be undone and will also remove all associated test records.')) {
                                                                        return;
                                                                    }

                                                                    // Show loading state
                                                                    const deleteBtn = event.target.closest('button');
                                                                    const originalContent = deleteBtn.innerHTML;
                                                                    deleteBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
                                                                    deleteBtn.disabled = true;

                                                                    fetch('${pageContext.request.contextPath}/test?action=delete&id=' + testId, {
                                                                        method: 'POST'
                                                                    })
                                                                            .then(response => {
                                                                                if (response.ok) {
                                                                                    // Remove the row from table
                                                                                    const row = deleteBtn.closest('tr');
                                                                                    row.style.transition = 'opacity 0.3s ease';
                                                                                    row.style.opacity = '0';
                                                                                    setTimeout(() => {
                                                                                        row.remove();
                                                                                        // Refresh page to update pagination
                                                                                        location.reload();
                                                                                    }, 300);
                                                                                } else {
                                                                                    throw new Error('Failed to delete test');
                                                                                }
                                                                            })
                                                                            .catch(error => {
                                                                                console.error('Error:', error);
                                                                                alert('Failed to delete test. Please try again.');
                                                                                deleteBtn.innerHTML = originalContent;
                                                                                deleteBtn.disabled = false;
                                                                            });
                                                                }

                                                                // Auto-submit form when filters change
                                                                document.getElementById('testType').addEventListener('change', function () {
                                                                    this.form.submit();
                                                                });

                                                                document.getElementById('courseId').addEventListener('change', function () {
                                                                    this.form.submit();
                                                                });

                                                                document.getElementById('pageSize').addEventListener('change', function () {
                                                                    this.form.submit();
                                                                });

                                                                // Auto-dismiss alerts after 5 seconds
                                                                setTimeout(function () {
                                                                    const alerts = document.querySelectorAll('.alert');
                                                                    alerts.forEach(alert => {
                                                                        if (alert.querySelector('.btn-close')) {
                                                                            const bsAlert = new bootstrap.Alert(alert);
                                                                            bsAlert.close();
                                                                        }
                                                                    });
                                                                }, 5000);

                                                                // Enhance search with debouncing
                                                                let searchTimeout;
                                                                document.getElementById('search').addEventListener('input', function () {
                                                                    clearTimeout(searchTimeout);
                                                                    searchTimeout = setTimeout(() => {
                                                                        // Auto-submit after 1 second of no typing
                                                                        this.form.submit();
                                                                    }, 1000);
                                                                });
        </script>
    </body>
</html>