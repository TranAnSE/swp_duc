<%-- 
    Document   : courseTestList
    Created on : Jul 8, 2025, 6:10:15 PM
    Author     : ankha
--%>

<%-- web/Test/courseTestList.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Tests - ${courseDetails.course_title}</title>
        <link rel="stylesheet" href="/assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="/assets/css/style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">

        <style>
            body {
                background: #f9f9f9;
                padding-top: 80px;
            }

            .course-header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 20px;
                border-radius: 8px;
                margin-bottom: 30px;
            }

            .course-path {
                display: flex;
                align-items: center;
                gap: 10px;
                font-size: 0.9em;
                opacity: 0.9;
                margin-bottom: 10px;
            }

            .test-card {
                background: white;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                margin-bottom: 20px;
                overflow: hidden;
                transition: all 0.3s ease;
            }

            .test-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 15px rgba(0,0,0,0.15);
            }

            .test-header {
                padding: 20px;
                border-bottom: 1px solid #eee;
            }

            .test-title {
                font-size: 1.2em;
                font-weight: 600;
                color: #333;
                margin-bottom: 10px;
            }

            .test-meta {
                display: flex;
                flex-wrap: wrap;
                gap: 15px;
                align-items: center;
            }

            .test-badge {
                padding: 4px 12px;
                border-radius: 12px;
                font-size: 0.8em;
                font-weight: 500;
            }

            .badge-practice {
                background: #e8f5e8;
                color: #2e7d32;
            }

            .badge-official {
                background: #ffebee;
                color: #c62828;
            }

            .badge-chapter {
                background: #e3f2fd;
                color: #1565c0;
            }

            .badge-course {
                background: #f3e5f5;
                color: #7b1fa2;
            }

            .test-stats {
                display: flex;
                gap: 20px;
                font-size: 0.9em;
                color: #666;
            }

            .test-actions {
                padding: 15px 20px;
                background: #f8f9fa;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .btn-group {
                display: flex;
                gap: 10px;
            }

            .btn-sm {
                padding: 6px 12px;
                font-size: 0.875em;
                border-radius: 4px;
                text-decoration: none;
                border: none;
                cursor: pointer;
                transition: all 0.2s ease;
            }

            .btn-primary {
                background: #007bff;
                color: white;
            }

            .btn-success {
                background: #28a745;
                color: white;
            }

            .btn-warning {
                background: #ffc107;
                color: #212529;
            }

            .btn-danger {
                background: #dc3545;
                color: white;
            }

            .btn-outline-secondary {
                background: white;
                color: #6c757d;
                border: 1px solid #6c757d;
            }

            .btn-sm:hover {
                transform: translateY(-1px);
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
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

            .pagination-container {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-top: 30px;
                padding: 20px;
                background: white;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
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
                padding: 8px 12px;
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

            .action-buttons {
                margin-bottom: 20px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .filter-section {
                display: flex;
                gap: 10px;
                align-items: center;
            }

            @media (max-width: 768px) {
                .test-meta {
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 10px;
                }

                .test-actions {
                    flex-direction: column;
                    gap: 10px;
                    align-items: stretch;
                }

                .btn-group {
                    justify-content: center;
                }

                .action-buttons {
                    flex-direction: column;
                    gap: 15px;
                    align-items: stretch;
                }
            }
        </style>
    </head>
    <body>
        <jsp:include page="/header.jsp" />

        <div class="container">
            <!-- Course Header -->
            <div class="course-header">
                <div class="course-path">
                    <span>${courseDetails.grade_name}</span>
                    <i class="fas fa-arrow-right"></i>
                    <span>${courseDetails.subject_name}</span>
                    <i class="fas fa-arrow-right"></i>
                    <span><strong>${courseDetails.course_title}</strong></span>
                </div>
                <h2><i class="fas fa-clipboard-check"></i> Course Tests</h2>
                <p>Manage tests and assessments for this course</p>
            </div>

            <!-- Action Buttons -->
            <div class="action-buttons">
                <div>
                    <a href="${pageContext.request.contextPath}/test?action=createForCourse&courseId=${courseDetails.course_id}" 
                       class="btn btn-success">
                        <i class="fas fa-plus"></i> Create New Test
                    </a>
                    <a href="${pageContext.request.contextPath}/course?action=build&id=${courseDetails.course_id}" 
                       class="btn btn-outline-secondary">
                        <i class="fas fa-arrow-left"></i> Back to Course Builder
                    </a>
                </div>

                <div class="filter-section">
                    <select class="form-select form-select-sm" onchange="filterTests(this.value)">
                        <option value="all">All Tests</option>
                        <option value="practice">Practice Tests</option>
                        <option value="official">Official Tests</option>
                    </select>
                </div>
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

            <!-- Tests List -->
            <c:choose>
                <c:when test="${empty tests}">
                    <div class="empty-state">
                        <i class="fas fa-clipboard-list"></i>
                        <h4>No Tests Created Yet</h4>
                        <p>Start by creating your first test for this course.</p>
                        <a href="${pageContext.request.contextPath}/test?action=createForCourse&courseId=${courseDetails.course_id}" 
                           class="btn btn-primary btn-lg">
                            <i class="fas fa-plus"></i> Create First Test
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="test" items="${tests}">
                        <div class="test-card" data-test-type="${test.is_practice ? 'practice' : 'official'}">
                            <div class="test-header">
                                <div class="test-title">
                                    <i class="fas fa-clipboard-check"></i> ${test.test_name}
                                </div>

                                <div class="test-meta">
                                    <div>
                                        <span class="test-badge ${test.is_practice ? 'badge-practice' : 'badge-official'}">
                                            <i class="fas ${test.is_practice ? 'fa-play-circle' : 'fa-certificate'}"></i>
                                            ${test.is_practice ? 'Practice Test' : 'Official Test'}
                                        </span>

                                        <c:choose>
                                            <c:when test="${test.chapter_id != null}">
                                                <span class="test-badge badge-chapter">
                                                    <i class="fas fa-bookmark"></i> ${test.chapter_name}
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="test-badge badge-course">
                                                    <i class="fas fa-graduation-cap"></i> Course Level
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <div class="test-stats">
                                        <span><i class="fas fa-clock"></i> ${test.duration_minutes} min</span>
                                        <span><i class="fas fa-question-circle"></i> ${test.total_questions_assigned} questions</span>
                                        <span><i class="fas fa-sort-numeric-up"></i> Order: ${test.test_order}</span>
                                    </div>
                                </div>

                                <c:if test="${not empty test.test_description}">
                                    <div style="margin-top: 10px; color: #666; font-size: 0.9em;">
                                        ${test.test_description}
                                    </div>
                                </c:if>
                            </div>

                            <div class="test-actions">
                                <div style="font-size: 0.85em; color: #666;">
                                    Created by ${test.created_by_name} on 
                                    <fmt:formatDate value="${test.created_at}" pattern="MMM dd, yyyy" />
                                </div>

                                <div class="btn-group">
                                    <a href="${pageContext.request.contextPath}/test?action=edit&id=${test.test_id}" 
                                       class="btn btn-primary btn-sm">
                                        <i class="fas fa-edit"></i> Edit
                                    </a>

                                    <c:if test="${test.total_questions_assigned > 0}">
                                        <a href="${pageContext.request.contextPath}/student/taketest?action=start&testId=${test.test_id}" 
                                           class="btn btn-success btn-sm" target="_blank">
                                            <i class="fas fa-play"></i> Preview
                                        </a>
                                    </c:if>

                                    <button class="btn btn-warning btn-sm" 
                                            onclick="reorderTest(${test.test_id}, 'up')" 
                                            ${test.test_order == 1 ? 'disabled' : ''}>
                                        <i class="fas fa-arrow-up"></i>
                                    </button>

                                    <button class="btn btn-warning btn-sm" 
                                            onclick="reorderTest(${test.test_id}, 'down')">
                                        <i class="fas fa-arrow-down"></i>
                                    </button>

                                    <button class="btn btn-danger btn-sm" 
                                            onclick="removeTestFromCourse(${test.test_id}, '${fn:escapeXml(test.test_name)}')">
                                        <i class="fas fa-trash"></i> Remove
                                    </button>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
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
                                <a class="page-link" href="?courseId=${courseDetails.course_id}&page=${currentPage - 1}&pageSize=${pageSize}">
                                    <i class="fas fa-chevron-left"></i> Previous
                                </a>
                            </li>

                            <c:forEach begin="${startPage}" end="${endPage}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="?courseId=${courseDetails.course_id}&page=${i}&pageSize=${pageSize}">${i}</a>
                                </li>
                            </c:forEach>

                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="?courseId=${courseDetails.course_id}&page=${currentPage + 1}&pageSize=${pageSize}">
                                    Next <i class="fas fa-chevron-right"></i>
                                </a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </c:if>
        </div>

        <jsp:include page="/footer.jsp" />

        <!-- JS -->
        <script src="/assets/js/bootstrap.bundle.min.js"></script>

        <script>
                                                function filterTests(type) {
                                                    const testCards = document.querySelectorAll('.test-card');

                                                    testCards.forEach(card => {
                                                        if (type === 'all') {
                                                            card.style.display = 'block';
                                                        } else {
                                                            const testType = card.getAttribute('data-test-type');
                                                            if (type === 'practice' && testType === 'true') {
                                                                card.style.display = 'block';
                                                            } else if (type === 'official' && testType === 'false') {
                                                                card.style.display = 'block';
                                                            } else {
                                                                card.style.display = 'none';
                                                            }
                                                        }
                                                    });
                                                }

                                                function removeTestFromCourse(testId, testName) {
                                                    if (!confirm('Are you sure you want to remove "' + testName + '" from this course?')) {
                                                        return;
                                                    }

                                                    const formData = new FormData();
                                                    formData.append('action', 'removeFromCourse');
                                                    formData.append('courseId', '${courseDetails.course_id}');
                                                    formData.append('testId', testId);

                                                    fetch('${pageContext.request.contextPath}/test', {
                                                        method: 'POST',
                                                        body: formData
                                                    })
                                                            .then(response => response.json())
                                                            .then(data => {
                                                                if (data.success) {
                                                                    location.reload();
                                                                } else {
                                                                    alert('Failed to remove test: ' + data.message);
                                                                }
                                                            })
                                                            .catch(error => {
                                                                console.error('Error:', error);
                                                                alert('An error occurred while removing the test');
                                                            });
                                                }

                                                function reorderTest(testId, direction) {
                                                    const formData = new FormData();
                                                    formData.append('action', 'reorderTest');
                                                    formData.append('courseId', '${courseDetails.course_id}');
                                                    formData.append('testId', testId);
                                                    formData.append('direction', direction);

                                                    fetch('${pageContext.request.contextPath}/test', {
                                                        method: 'POST',
                                                        body: formData
                                                    })
                                                            .then(response => response.json())
                                                            .then(data => {
                                                                if (data.success) {
                                                                    location.reload();
                                                                } else {
                                                                    alert('Failed to reorder test: ' + data.message);
                                                                }
                                                            })
                                                            .catch(error => {
                                                                console.error('Error:', error);
                                                                alert('An error occurred while reordering the test');
                                                            });
                                                }

                                                // Auto-dismiss alerts after 5 seconds
                                                setTimeout(function () {
                                                    const alerts = document.querySelectorAll('.alert');
                                                    alerts.forEach(alert => {
                                                        const bsAlert = new bootstrap.Alert(alert);
                                                        bsAlert.close();
                                                    });
                                                }, 5000);
        </script>
    </body>
</html>