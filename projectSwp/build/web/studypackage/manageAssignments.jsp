<%-- 
    Document   : manageAssignments
    Created on : Jun 29, 2025, 4:40:53 AM
    Author     : ankha
--%>

<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Manage Package Assignments</title>
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
            }
            .assignment-card {
                background: white;
                border-radius: 12px;
                padding: 20px;
                margin-bottom: 20px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            .package-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
                padding-bottom: 15px;
                border-bottom: 2px solid #e9ecef;
            }
            .package-title {
                font-size: 1.4em;
                font-weight: bold;
                color: #333;
            }
            .status-badge {
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 0.85em;
                font-weight: bold;
            }
            .status-active {
                background-color: #d4edda;
                color: #155724;
            }
            .status-expired {
                background-color: #f8d7da;
                color: #721c24;
            }
            .status-inactive {
                background-color: #f8d7da;
                color: #721c24;
            }
            .assignment-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                gap: 15px;
                margin-top: 15px;
            }
            .student-assignment {
                background-color: #f8f9fa;
                padding: 15px;
                border-radius: 8px;
                border-left: 4px solid #007bff;
            }
            .student-assignment.expired {
                border-left-color: #dc3545;
                opacity: 0.7;
            }
            .student-name {
                font-weight: bold;
                color: #333;
                margin-bottom: 5px;
            }
            .assignment-info {
                font-size: 0.9em;
                color: #666;
            }
            .stats-row {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
                gap: 15px;
                margin-bottom: 20px;
            }
            .stat-card {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 20px;
                border-radius: 10px;
                text-align: center;
            }
            .stat-card.success {
                background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            }
            .stat-card.warning {
                background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            }
            .stat-card.info {
                background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            }
            .stat-number {
                font-size: 2em;
                font-weight: bold;
                margin-bottom: 5px;
            }
            .stat-label {
                font-size: 0.9em;
                opacity: 0.9;
            }
            .search-filter {
                background: white;
                padding: 20px;
                border-radius: 12px;
                margin-bottom: 30px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            .filter-row {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 15px;
                align-items: end;
            }
            .btn-action {
                padding: 5px 10px;
                font-size: 0.8em;
                margin: 2px;
            }
            .no-assignments {
                text-align: center;
                padding: 60px 20px;
                background: white;
                border-radius: 12px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
        </style>
    </head>
    <body>

        <%@include file="../header.jsp" %>

        <main>
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2><i class="fas fa-users-cog"></i> Manage Package Assignments</h2>
                <div>
                    <a href="${pageContext.request.contextPath}/study_package" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to Packages
                    </a>
                    <a href="${pageContext.request.contextPath}/study_package?service=add" class="btn btn-success">
                        <i class="fas fa-plus"></i> Create New Package
                    </a>
                </div>
            </div>

            <!-- Statistics Overview -->
            <div class="stats-row">
                <div class="stat-card info">
                    <div class="stat-number">${totalPackages != null ? totalPackages : 0}</div>
                    <div class="stat-label">Total Packages</div>
                </div>
                <div class="stat-card success">
                    <div class="stat-number">${activeAssignments != null ? activeAssignments : 0}</div>
                    <div class="stat-label">Active Assignments</div>
                </div>
                <div class="stat-card warning">
                    <div class="stat-number">${expiredAssignments != null ? expiredAssignments : 0}</div>
                    <div class="stat-label">Expired Assignments</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">${totalStudents != null ? totalStudents : 0}</div>
                    <div class="stat-label">Students with Packages</div>
                </div>
            </div>

            <!-- Search and Filter -->
            <div class="search-filter">
                <h5><i class="fas fa-filter"></i> Filter Assignments</h5>
                <form method="get" action="study_package">
                    <input type="hidden" name="service" value="manageAssignments">
                    <div class="filter-row">
                        <div class="form-group">
                            <label for="packageName">Package Name</label>
                            <input type="text" id="packageName" name="packageName" class="form-control" 
                                   placeholder="Search by package name" value="${param.packageName}">
                        </div>
                        <div class="form-group">
                            <label for="studentName">Student Name</label>
                            <input type="text" id="studentName" name="studentName" class="form-control" 
                                   placeholder="Search by student name" value="${param.studentName}">
                        </div>
                        <div class="form-group">
                            <label for="status">Status</label>
                            <select id="status" name="status" class="form-control">
                                <option value="">All Status</option>
                                <option value="active" ${param.status == 'active' ? 'selected' : ''}>Active</option>
                                <option value="expired" ${param.status == 'expired' ? 'selected' : ''}>Expired</option>
                                <option value="inactive" ${param.status == 'inactive' ? 'selected' : ''}>Inactive</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-search"></i> Search
                            </button>
                            <a href="study_package?service=manageAssignments" class="btn btn-secondary">
                                <i class="fas fa-times"></i> Clear
                            </a>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Package Assignments List -->
            <c:choose>
                <c:when test="${not empty packageAssignments}">
                    <c:forEach items="${packageAssignments}" var="packageData">
                        <div class="assignment-card">
                            <div class="package-header">
                                <div>
                                    <div class="package-title">${packageData.packageName}</div>
                                    <small class="text-muted">
                                        Package ID: #${packageData.packageId} | 
                                        Type: ${packageData.packageType} | 
                                        Max Students: ${packageData.maxStudents}
                                    </small>
                                </div>
                                <div>
                                    <span class="badge badge-info">
                                        ${packageData.assignmentCount} / ${packageData.maxStudents} assigned
                                    </span>
                                    <a href="study_package?service=detail&id=${packageData.packageId}" 
                                       class="btn btn-sm btn-outline-primary">
                                        <i class="fas fa-eye"></i> View Package
                                    </a>
                                </div>
                            </div>

                            <c:choose>
                                <c:when test="${not empty packageData.assignments}">
                                    <div class="assignment-grid">
                                        <c:forEach items="${packageData.assignments}" var="assignment">
                                            <div class="student-assignment ${assignment.isActive && assignment.expiresAt.isAfter(java.time.LocalDateTime.now()) ? '' : 'expired'}">
                                                <div class="student-name">
                                                    <i class="fas fa-user"></i> ${assignment.studentName}
                                                </div>
                                                <div class="assignment-info">
                                                    <div><strong>Parent:</strong> ${assignment.parentName}</div>
                                                    <div><strong>Purchased:</strong> 
                                                        <fmt:formatDate value="${assignment.purchasedAt}" pattern="dd/MM/yyyy"/>
                                                    </div>
                                                    <div><strong>Expires:</strong> 
                                                        <fmt:formatDate value="${assignment.expiresAt}" pattern="dd/MM/yyyy"/>
                                                    </div>
                                                    <div>
                                                        <span class="status-badge ${assignment.isActive && assignment.expiresAt.isAfter(java.time.LocalDateTime.now()) ? 'status-active' : 'status-expired'}">
                                                            ${assignment.isActive && assignment.expiresAt.isAfter(java.time.LocalDateTime.now()) ? 'Active' : 'Expired'}
                                                        </span>
                                                    </div>
                                                </div>
                                                <div class="mt-2">
                                                    <c:if test="${assignment.isActive && assignment.expiresAt.isAfter(java.time.LocalDateTime.now())}">
                                                        <button class="btn btn-warning btn-action" 
                                                                onclick="deactivateAssignment(${assignment.id})"
                                                                title="Deactivate Assignment">
                                                            <i class="fas fa-ban"></i> Deactivate
                                                        </button>
                                                    </c:if>
                                                    <button class="btn btn-info btn-action" 
                                                            onclick="viewAssignmentDetails(${assignment.id})"
                                                            title="View Details">
                                                        <i class="fas fa-info-circle"></i> Details
                                                    </button>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center text-muted py-3">
                                        <i class="fas fa-inbox"></i> No assignments for this package
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="no-assignments">
                        <i class="fas fa-users-slash fa-3x text-muted mb-3"></i>
                        <h4>No Package Assignments Found</h4>
                        <p>No package assignments match your current filter criteria.</p>
                        <a href="study_package?service=manageAssignments" class="btn btn-primary">
                            <i class="fas fa-refresh"></i> View All Assignments
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </main>

        <!-- Assignment Details Modal -->
        <div class="modal fade" id="assignmentModal" tabindex="-1" role="dialog">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Assignment Details</h5>
                        <button type="button" class="close" data-dismiss="modal">
                            <span>&times;</span>
                        </button>
                    </div>
                    <div class="modal-body" id="assignmentModalBody">
                        <div class="text-center">
                            <i class="fas fa-spinner fa-spin"></i> Loading...
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>

        <%@include file="../footer.jsp" %>

        <script src="${pageContext.request.contextPath}/assets/js/vendor/jquery-1.12.4.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>

        <script>
                                                                function deactivateAssignment(assignmentId) {
                                                                    if (confirm('Are you sure you want to deactivate this assignment? The student will lose access to the package.')) {
                                                                        $.ajax({
                                                                            url: 'study_package',
                                                                            type: 'POST',
                                                                            data: {
                                                                                service: 'deactivateAssignment',
                                                                                assignmentId: assignmentId
                                                                            },
                                                                            success: function (response) {
                                                                                if (response.success) {
                                                                                    alert('Assignment deactivated successfully.');
                                                                                    location.reload();
                                                                                } else {
                                                                                    alert('Error: ' + response.message);
                                                                                }
                                                                            },
                                                                            error: function () {
                                                                                alert('Error deactivating assignment. Please try again.');
                                                                            }
                                                                        });
                                                                    }
                                                                }

                                                                function viewAssignmentDetails(assignmentId) {
                                                                    $('#assignmentModal').modal('show');
                                                                    $('#assignmentModalBody').html('<div class="text-center"><i class="fas fa-spinner fa-spin"></i> Loading assignment details...</div>');

                                                                    $.ajax({
                                                                        url: 'study_package',
                                                                        type: 'GET',
                                                                        data: {
                                                                            service: 'getAssignmentDetails',
                                                                            assignmentId: assignmentId
                                                                        },
                                                                        success: function (data) {
                                                                            let html = '<div class="assignment-details">';
                                                                            html += '<div class="row">';
                                                                            html += '<div class="col-md-6">';
                                                                            html += '<h6><i class="fas fa-user"></i> Student Information</h6>';
                                                                            html += '<p><strong>Name:</strong> ' + data.studentName + '</p>';
                                                                            html += '<p><strong>Username:</strong> ' + data.studentUsername + '</p>';
                                                                            html += '<p><strong>Grade:</strong> ' + data.gradeName + '</p>';
                                                                            html += '</div>';
                                                                            html += '<div class="col-md-6">';
                                                                            html += '<h6><i class="fas fa-box"></i> Package Information</h6>';
                                                                            html += '<p><strong>Package:</strong> ' + data.packageName + '</p>';
                                                                            html += '<p><strong>Type:</strong> ' + data.packageType + '</p>';
                                                                            html += '<p><strong>Price:</strong> ' + data.packagePrice + ' VND</p>';
                                                                            html += '</div>';
                                                                            html += '</div>';
                                                                            html += '<hr>';
                                                                            html += '<div class="row">';
                                                                            html += '<div class="col-md-6">';
                                                                            html += '<h6><i class="fas fa-calendar"></i> Assignment Timeline</h6>';
                                                                            html += '<p><strong>Purchased:</strong> ' + data.purchasedAt + '</p>';
                                                                            html += '<p><strong>Expires:</strong> ' + data.expiresAt + '</p>';
                                                                            html += '<p><strong>Days Remaining:</strong> ' + data.daysRemaining + '</p>';
                                                                            html += '</div>';
                                                                            html += '<div class="col-md-6">';
                                                                            html += '<h6><i class="fas fa-user-friends"></i> Parent Information</h6>';
                                                                            html += '<p><strong>Parent:</strong> ' + data.parentName + '</p>';
                                                                            html += '<p><strong>Email:</strong> ' + data.parentEmail + '</p>';
                                                                            html += '</div>';
                                                                            html += '</div>';
                                                                            if (data.accessLogs && data.accessLogs.length > 0) {
                                                                                html += '<hr>';
                                                                                html += '<h6><i class="fas fa-history"></i> Recent Access History</h6>';
                                                                                html += '<div class="table-responsive">';
                                                                                html += '<table class="table table-sm">';
                                                                                html += '<thead><tr><th>Date</th><th>Activity</th><th>Lesson</th></tr></thead>';
                                                                                html += '<tbody>';
                                                                                data.accessLogs.forEach(function (log) {
                                                                                    html += '<tr>';
                                                                                    html += '<td>' + log.accessedAt + '</td>';
                                                                                    html += '<td>' + log.accessType + '</td>';
                                                                                    html += '<td>' + (log.lessonName || '-') + '</td>';
                                                                                    html += '</tr>';
                                                                                });
                                                                                html += '</tbody></table>';
                                                                                html += '</div>';
                                                                            }
                                                                            html += '</div>';

                                                                            $('#assignmentModalBody').html(html);
                                                                        },
                                                                        error: function () {
                                                                            $('#assignmentModalBody').html('<div class="alert alert-danger">Error loading assignment details.</div>');
                                                                        }
                                                                    });
                                                                }

                                                                // Auto-refresh every 5 minutes to keep data current
                                                                setInterval(function () {
                                                                    if (document.visibilityState === 'visible') {
                                                                        location.reload();
                                                                    }
                                                                }, 300000); // 5 minutes
        </script>

    </body>
</html>