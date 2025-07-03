<%-- 
    Document   : courseList
    Created on : Jul 3, 2025, 10:36:05 AM
    Author     : ankha
--%>

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
            .course-thumbnail {
                width: 60px;
                height: 40px;
                object-fit: cover;
                border-radius: 4px;
            }
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
                                            <span class="status-badge status-${course.approval_status.toLowerCase()}">
                                                <c:choose>
                                                    <c:when test="${course.approval_status == 'DRAFT'}">Draft</c:when>
                                                    <c:when test="${course.approval_status == 'PENDING_APPROVAL'}">Pending</c:when>
                                                    <c:when test="${course.approval_status == 'APPROVED'}">Approved</c:when>
                                                    <c:when test="${course.approval_status == 'REJECTED'}">Rejected</c:when>
                                                </c:choose>
                                            </span>
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
                                                    <c:if test="${course.approval_status != 'PENDING_APPROVAL' || sessionScope.account.role == 'admin'}">
                                                        <a href="${pageContext.request.contextPath}/course?action=build&id=${course.course_id}" 
                                                           class="btn btn-sm btn-primary" title="Build Course">
                                                            <i class="fas fa-cogs"></i> Build
                                                        </a>
                                                    </c:if>
                                                </c:if>

                                                <!-- Edit Course Info -->
                                                <c:if test="${sessionScope.account.role == 'admin' || sessionScope.account.role == 'teacher'}">
                                                    <c:if test="${course.approval_status == 'DRAFT' || course.approval_status == 'REJECTED' || sessionScope.account.role == 'admin'}">
                                                        <a href="${pageContext.request.contextPath}/course?action=edit&id=${course.course_id}" 
                                                           class="btn btn-sm btn-secondary" title="Edit Course">
                                                            <i class="fas fa-edit"></i> Edit
                                                        </a>
                                                    </c:if>
                                                </c:if>

                                                <!-- Submit for Approval (for teachers) -->
                                                <c:if test="${sessionScope.account.role == 'teacher' && (course.approval_status == 'DRAFT' || course.approval_status == 'REJECTED')}">
                                                    <a href="${pageContext.request.contextPath}/course?action=submit&id=${course.course_id}" 
                                                       class="btn btn-sm btn-warning" title="Submit for Approval"
                                                       onclick="return confirm('Submit this course for approval?')">
                                                        <i class="fas fa-paper-plane"></i> Submit
                                                    </a>
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
        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>

        <script>
                                                                       function showRejectModal(courseId) {
                                                                           document.getElementById('rejectCourseId').value = courseId;
                                                                           document.getElementById('rejectionReason').value = '';
                                                                           new bootstrap.Modal(document.getElementById('rejectModal')).show();
                                                                       }

                                                                       // Auto-dismiss alerts after 5 seconds
                                                                       setTimeout(function () {
                                                                           $('.alert').fadeOut('slow');
                                                                       }, 5000);
        </script>
    </body>
</html>