<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Course Management</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
        <!-- Select2 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
        <style>
            body {
                padding-top: 130px;
                background-color: #f8f9fa;
            }
            main {
                max-width: 1400px;
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

            /* Status badges */
            .status-badge {
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 0.8em;
                font-weight: bold;
                text-transform: uppercase;
            }
            .status-draft {
                background-color: #e2e3e5;
                color: #495057;
            }
            .status-pending_approval {
                background-color: #fff3cd;
                color: #856404;
            }
            .status-approved {
                background-color: #d4edda;
                color: #155724;
            }
            .status-rejected {
                background-color: #f8d7da;
                color: #721c24;
            }
            .active-badge {
                background-color: #d4edda;
                color: #155724;
            }
            .inactive-badge {
                background-color: #f8d7da;
                color: #721c24;
            }

            /* Course stats */
            .course-stats {
                font-size: 0.9em;
                color: #666;
            }
            .btn-group .btn {
                margin: 2px;
                font-size: 0.8em;
                padding: 4px 8px;
            }
            .hierarchy-path {
                font-size: 0.9em;
                color: #666;
            }
            .hierarchy-arrow {
                margin: 0 5px;
                color: #999;
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

            /* Responsive */
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

                .table-responsive {
                    font-size: 0.9em;
                }
            }
        </style>
    </head>
    <body>
        <%@include file="../header.jsp" %>

        <main>
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2><i class="fas fa-graduation-cap"></i> Course Management</h2>
                <div>
                    <c:if test="${sessionScope.account.role == 'admin' || sessionScope.account.role == 'teacher'}">
                        <a href="${pageContext.request.contextPath}/course?action=create" class="btn btn-success">
                            <i class="fas fa-plus"></i> Create New Course
                        </a>
                    </c:if>
                    <a href="${pageContext.request.contextPath}/subjects" class="btn btn-primary">
                        <i class="fas fa-book"></i> Manage Subjects
                    </a>
                </div>
            </div>

            <c:if test="${not empty message}">
                <div class="alert alert-success alert-dismissible fade show">
                    <i class="fas fa-check-circle"></i> ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show">
                    <i class="fas fa-exclamation-circle"></i> ${errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Filter Section -->
            <div class="filter-section">
                <form method="get" action="course" id="filterForm">
                    <div class="filter-row">
                        <div class="filter-group">
                            <label for="gradeFilter">Grade:</label>
                            <select id="gradeFilter" name="gradeId" onchange="loadSubjectsByGrade()">
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
                            <label for="subjectFilter">Subject:</label>
                            <select id="subjectFilter" name="subjectId">
                                <option value="">All Subjects</option>
                                <c:forEach items="${subjects}" var="subject">
                                    <option value="${subject.id}" 
                                            data-grade-id="${subject.grade_id}"
                                            ${selectedSubjectId != null && selectedSubjectId == subject.id ? 'selected' : ''}>
                                        ${subject.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <c:if test="${sessionScope.account.role == 'admin' || sessionScope.account.role == 'teacher'}">
                            <div class="filter-group">
                                <label for="statusFilter">Status:</label>
                                <select id="statusFilter" name="status">
                                    <option value="">All Status</option>
                                    <option value="DRAFT" ${selectedStatus == 'DRAFT' ? 'selected' : ''}>Draft</option>
                                    <option value="PENDING_APPROVAL" ${selectedStatus == 'PENDING_APPROVAL' ? 'selected' : ''}>Pending Approval</option>
                                    <option value="APPROVED" ${selectedStatus == 'APPROVED' ? 'selected' : ''}>Approved</option>
                                    <option value="REJECTED" ${selectedStatus == 'REJECTED' ? 'selected' : ''}>Rejected</option>
                                </select>
                            </div>
                        </c:if>

                        <div class="filter-group">
                            <label for="searchFilter">Search:</label>
                            <input type="text" id="searchFilter" name="search" 
                                   placeholder="Search courses..." 
                                   value="${searchKeyword}">
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
                        <c:when test="${totalCourses > 0}">
                            <div class="results-count">
                                <c:choose>
                                    <c:when test="${totalCourses > 0}">
                                        Showing ${displayStart} - ${displayEnd} of ${totalCourses} courses
                                    </c:when>
                                    <c:otherwise>
                                        No courses found
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:when>
                        <c:otherwise>
                            No courses found
                        </c:otherwise>
                    </c:choose>
                </div>

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
            </div>

            <!-- Course Table -->
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead class="table-dark">
                        <tr>
                            <th>ID</th>
                            <th>Hierarchy</th>
                            <th>Course Title</th>
                            <th>Price</th>
                            <th>Duration</th>
                            <th>Content</th>
                            <th>Status</th>
                            <th>Active</th>
                            <th>Created</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty courses}">
                                <c:forEach items="${courses}" var="course">
                                    <tr>
                                        <td><strong>#${course.course_id}</strong></td>
                                        <td>
                                            <div class="hierarchy-path">
                                                <small>
                                                    ${course.grade_name}
                                                    <i class="fas fa-arrow-right hierarchy-arrow"></i>
                                                    ${course.subject_name}
                                                </small>
                                            </div>
                                        </td>
                                        <td>
                                            <strong>${course.course_title}</strong>
                                            <c:if test="${not empty course.description}">
                                                <br><small class="text-muted">${course.description}</small>
                                            </c:if>
                                        </td>
                                        <td>
                                            <span class="fw-bold text-success">
                                                <fmt:formatNumber value="${course.price}" type="number" groupingUsed="true"/> VND
                                            </span>
                                        </td>
                                        <td>${course.duration_days} days</td>
                                        <td>
                                            <div class="course-stats">
                                                <div><i class="fas fa-book"></i> ${course.total_chapters} chapters</div>
                                                <div><i class="fas fa-play"></i> ${course.total_lessons} lessons</div>
                                                <div><i class="fas fa-question-circle"></i> ${course.total_tests} tests</div>
                                            </div>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${course.approval_status == 'APPROVED' && course.allow_edit_after_approval}">
                                                    <span class="status-badge status-approved-editable">
                                                        <i class="fas fa-edit"></i> Approved (Editable)
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge status-${course.approval_status.toLowerCase()}">
                                                        <c:choose>
                                                            <c:when test="${course.approval_status == 'DRAFT'}">
                                                                <i class="fas fa-draft2digital"></i> Draft
                                                            </c:when>
                                                            <c:when test="${course.approval_status == 'PENDING_APPROVAL'}">
                                                                <i class="fas fa-clock"></i> Pending
                                                            </c:when>
                                                            <c:when test="${course.approval_status == 'APPROVED'}">
                                                                <i class="fas fa-check"></i> Approved
                                                            </c:when>
                                                            <c:when test="${course.approval_status == 'REJECTED'}">
                                                                <i class="fas fa-times"></i> Rejected
                                                            </c:when>
                                                        </c:choose>
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <span class="status-badge ${course.is_active ? 'active-badge' : 'inactive-badge'}">
                                                ${course.is_active ? 'Active' : 'Inactive'}
                                            </span>
                                        </td>
                                        <td>
                                            <small>
                                                <fmt:formatDate value="${course.created_at}" pattern="dd/MM/yyyy"/>
                                                <br>by ${course.created_by_name}
                                            </small>
                                        </td>
                                        <td>
                                            <div class="btn-group-vertical" role="group">
                                                <!-- Build Course (for teachers and admin) -->
                                                <c:if test="${sessionScope.account.role == 'admin' || sessionScope.account.role == 'teacher'}">
                                                    <c:choose>
                                                        <c:when test="${course.approval_status == 'PENDING_APPROVAL'}">
                                                            <!-- Only admin can access pending courses -->
                                                            <c:if test="${sessionScope.account.role == 'admin'}">
                                                                <a href="${pageContext.request.contextPath}/course?action=build&id=${course.course_id}" 
                                                                   class="btn btn-sm btn-primary" title="Build Course">
                                                                    <i class="fas fa-cogs"></i> Build
                                                                </a>
                                                            </c:if>
                                                        </c:when>
                                                        <c:when test="${course.approval_status == 'APPROVED'}">
                                                            <!-- For approved courses, check edit permission -->
                                                            <c:choose>
                                                                <c:when test="${sessionScope.account.role == 'admin'}">
                                                                    <a href="${pageContext.request.contextPath}/course?action=build&id=${course.course_id}" 
                                                                       class="btn btn-sm btn-primary" title="Build Course">
                                                                        <i class="fas fa-cogs"></i> Build
                                                                    </a>
                                                                </c:when>
                                                                <c:when test="${course.allow_edit_after_approval}">
                                                                    <a href="${pageContext.request.contextPath}/course?action=build&id=${course.course_id}" 
                                                                       class="btn btn-sm btn-primary" title="Build Course">
                                                                        <i class="fas fa-cogs"></i> Build
                                                                    </a>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <button class="btn btn-sm btn-secondary" disabled title="Edit permission required">
                                                                        <i class="fas fa-lock"></i> Locked
                                                                    </button>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <!-- Draft or rejected courses -->
                                                            <a href="${pageContext.request.contextPath}/course?action=build&id=${course.course_id}" 
                                                               class="btn btn-sm btn-primary" title="Build Course">
                                                                <i class="fas fa-cogs"></i> Build
                                                            </a>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:if>

                                                <!-- Edit Course Info -->
                                                <c:if test="${sessionScope.account.role == 'admin' || sessionScope.account.role == 'teacher'}">
                                                    <c:choose>
                                                        <c:when test="${course.approval_status == 'DRAFT' || course.approval_status == 'REJECTED' || sessionScope.account.role == 'admin'}">
                                                            <a href="${pageContext.request.contextPath}/course?action=edit&id=${course.course_id}" 
                                                               class="btn btn-sm btn-secondary" title="Edit Course">
                                                                <i class="fas fa-edit"></i> Edit
                                                            </a>
                                                        </c:when>
                                                        <c:when test="${course.approval_status == 'APPROVED' && course.allow_edit_after_approval && sessionScope.account.role == 'teacher'}">
                                                            <a href="${pageContext.request.contextPath}/course?action=edit&id=${course.course_id}" 
                                                               class="btn btn-sm btn-secondary" title="Edit Course">
                                                                <i class="fas fa-edit"></i> Edit
                                                            </a>
                                                        </c:when>
                                                    </c:choose>
                                                </c:if>

                                                <!-- Submit/Resubmit for Approval (for teachers) -->
                                                <c:if test="${sessionScope.account.role == 'teacher'}">
                                                    <c:choose>
                                                        <c:when test="${course.approval_status == 'DRAFT'}">
                                                            <a href="${pageContext.request.contextPath}/course?action=submit&id=${course.course_id}" 
                                                               class="btn btn-sm btn-warning" title="Submit for Approval"
                                                               onclick="return confirm('Submit this course for approval?')">
                                                                <i class="fas fa-paper-plane"></i> Submit
                                                            </a>
                                                        </c:when>
                                                        <c:when test="${course.approval_status == 'REJECTED'}">
                                                            <a href="${pageContext.request.contextPath}/course?action=submit&id=${course.course_id}" 
                                                               class="btn btn-sm btn-warning" title="Resubmit for Approval"
                                                               onclick="return confirm('Resubmit this course for approval?')">
                                                                <i class="fas fa-paper-plane"></i> Resubmit
                                                            </a>
                                                        </c:when>
                                                        <c:when test="${course.approval_status == 'APPROVED' && course.allow_edit_after_approval}">
                                                            <a href="${pageContext.request.contextPath}/course?action=resubmit&id=${course.course_id}" 
                                                               class="btn btn-sm btn-warning" title="Resubmit for Approval"
                                                               onclick="return confirm('Resubmit this edited course for approval?')">
                                                                <i class="fas fa-paper-plane"></i> Resubmit
                                                            </a>
                                                        </c:when>
                                                    </c:choose>
                                                </c:if>

                                                <!-- Admin Actions -->
                                                <c:if test="${sessionScope.account.role == 'admin'}">
                                                    <c:if test="${course.approval_status == 'PENDING_APPROVAL'}">
                                                        <a href="${pageContext.request.contextPath}/course?action=approve&id=${course.course_id}" 
                                                           class="btn btn-sm btn-success" title="Approve Course"
                                                           onclick="return confirm('Approve this course?')">
                                                            <i class="fas fa-check"></i> Approve
                                                        </a>
                                                        <button type="button" class="btn btn-sm btn-danger" title="Reject Course"
                                                                onclick="showRejectModal(${course.course_id})">
                                                            <i class="fas fa-times"></i> Reject
                                                        </button>
                                                    </c:if>

                                                    <c:if test="${course.approval_status == 'APPROVED'}">
                                                        <!-- Edit Permission Management -->
                                                        <c:choose>
                                                            <c:when test="${course.allow_edit_after_approval}">
                                                                <a href="${pageContext.request.contextPath}/course?action=revokeEdit&id=${course.course_id}" 
                                                                   class="btn btn-sm btn-outline-warning" title="Revoke Edit Permission"
                                                                   onclick="return confirm('Revoke edit permission for this course?')">
                                                                    <i class="fas fa-lock"></i> Lock Edit
                                                                </a>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <a href="${pageContext.request.contextPath}/course?action=allowEdit&id=${course.course_id}" 
                                                                   class="btn btn-sm btn-outline-info" title="Allow Edit"
                                                                   onclick="return confirm('Allow teacher to edit this approved course?')">
                                                                    <i class="fas fa-unlock"></i> Allow Edit
                                                                </a>
                                                            </c:otherwise>
                                                        </c:choose>

                                                        <!-- Activate/Deactivate -->
                                                        <c:choose>
                                                            <c:when test="${course.is_active}">
                                                                <a href="${pageContext.request.contextPath}/course?action=deactivate&id=${course.course_id}" 
                                                                   class="btn btn-sm btn-warning" title="Deactivate Course"
                                                                   onclick="return confirm('Deactivate this course?')">
                                                                    <i class="fas fa-pause"></i> Deactivate
                                                                </a>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <a href="${pageContext.request.contextPath}/course?action=activate&id=${course.course_id}" 
                                                                   class="btn btn-sm btn-success" title="Activate Course"
                                                                   onclick="return confirm('Activate this course?')">
                                                                    <i class="fas fa-play"></i> Activate
                                                                </a>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:if>
                                                </c:if>

                                                <!-- View Detail (for all users) -->
                                                <c:if test="${course.approval_status == 'APPROVED' && course.is_active}">
                                                    <a href="${pageContext.request.contextPath}/course?action=detail&id=${course.course_id}" 
                                                       class="btn btn-sm btn-info" title="View Course">
                                                        <i class="fas fa-eye"></i> View
                                                    </a>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="10" class="text-center text-muted py-4">
                                        <i class="fas fa-graduation-cap fa-3x mb-3"></i>
                                        <br>No courses found.
                                        <c:if test="${sessionScope.account.role == 'admin' || sessionScope.account.role == 'teacher'}">
                                            <br><a href="${pageContext.request.contextPath}/course?action=create" class="btn btn-primary mt-2">
                                                <i class="fas fa-plus"></i> Create Your First Course
                                            </a>
                                        </c:if>
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

        <!-- Reject Course Modal -->
        <div class="modal fade" id="rejectModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Reject Course</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <form id="rejectForm" method="post" action="${pageContext.request.contextPath}/course">
                        <div class="modal-body">
                            <input type="hidden" name="action" value="reject">
                            <input type="hidden" name="id" id="rejectCourseId">
                            <div class="mb-3">
                                <label for="rejectionReason" class="form-label">Rejection Reason <span class="text-danger">*</span></label>
                                <textarea id="rejectionReason" name="rejectionReason" class="form-control" rows="4" 
                                          placeholder="Please provide a reason for rejection..." required></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-danger">Reject Course</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <%@include file="../footer.jsp" %>

        <!-- JS -->
        <script src="${pageContext.request.contextPath}/assets/js/vendor/jquery-1.12.4.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
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

                                    // Filter subjects based on selected grade on page load
                                    filterSubjectsByGrade();

                                    // Auto-submit form when Enter is pressed in search field
                                    $('#searchFilter').on('keypress', function (e) {
                                        if (e.which === 13) {
                                            $('#filterForm').submit();
                                        }
                                    });
                                });

                                function loadSubjectsByGrade() {
                                    filterSubjectsByGrade();
                                }

                                function filterSubjectsByGrade() {
                                    const selectedGradeId = $('#gradeFilter').val();
                                    const subjectSelect = $('#subjectFilter');
                                    const currentSubjectId = '${selectedSubjectId}';

                                    // Show all subjects first
                                    subjectSelect.find('option').show();

                                    if (selectedGradeId) {
                                        // Hide subjects that don't belong to selected grade
                                        subjectSelect.find('option[data-grade-id]').each(function () {
                                            const gradeId = $(this).data('grade-id');
                                            if (gradeId && gradeId != selectedGradeId) {
                                                $(this).hide();
                                            }
                                        });

                                        // Reset subject selection if current subject doesn't match grade
                                        const currentOption = subjectSelect.find('option[value="' + currentSubjectId + '"]');
                                        if (currentOption.length > 0) {
                                            const currentGradeId = currentOption.data('grade-id');
                                            if (currentGradeId && currentGradeId != selectedGradeId) {
                                                subjectSelect.val('').trigger('change');
                                            }
                                        }
                                    }

                                    // Refresh Select2
                                    subjectSelect.select2({
                                        placeholder: 'All Subjects',
                                        allowClear: true,
                                        width: '100%',
                                        dropdownParent: $('body')
                                    });
                                }

                                function clearFilters() {
                                    $('#gradeFilter').val('').trigger('change');
                                    $('#subjectFilter').val('').trigger('change');
                                    $('#statusFilter').val('').trigger('change');
                                    $('#searchFilter').val('');
                                    $('#filterForm').submit();
                                }

                                function changePageSize(newPageSize) {
                                    const form = $('#filterForm');
                                    form.find('input[name="pageSize"]').val(newPageSize);
                                    form.find('input[name="page"]').val(1); // Reset to first page
                                    form.submit();
                                }

                                function goToPage(pageNumber) {
                                    const form = $('#filterForm');
                                    form.find('input[name="page"]').val(pageNumber);
                                    form.submit();
                                }

                                function showRejectModal(courseId) {
                                    document.getElementById('rejectCourseId').value = courseId;
                                    document.getElementById('rejectionReason').value = '';
                                    new bootstrap.Modal(document.getElementById('rejectModal')).show();
                                }

                                // Auto-dismiss alerts after 5 seconds
                                setTimeout(function () {
                                    $('.alert').fadeOut('slow');
                                }, 5000);

                                // Handle URL parameters for direct linking from subjects page
                                $(document).ready(function () {
                                    const urlParams = new URLSearchParams(window.location.search);
                                    const subjectId = urlParams.get('subjectId');

                                    if (subjectId && subjectId !== '${selectedSubjectId}') {
                                        // If coming from subjects page with subjectId parameter
                                        $('#subjectFilter').val(subjectId).trigger('change');

                                        // Also set the corresponding grade
                                        const subjectOption = $('#subjectFilter option[value="' + subjectId + '"]');
                                        if (subjectOption.length > 0) {
                                            const gradeId = subjectOption.data('grade-id');
                                            if (gradeId) {
                                                $('#gradeFilter').val(gradeId).trigger('change');
                                            }
                                        }

                                        // Submit form to apply filter
                                        $('#filterForm').submit();
                                    }
                                });
        </script>
    </body>
</html>