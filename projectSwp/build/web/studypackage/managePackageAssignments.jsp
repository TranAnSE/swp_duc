<%-- 
    Document   : managePackageAssignments
    Created on : Jun 29, 2025, 3:42:53 PM
    Author     : ankha
--%>

<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
            .manage-container {
                max-width: 1200px;
                margin: 40px auto;
                padding: 20px;
            }
            .package-info-card {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 25px;
                border-radius: 12px;
                margin-bottom: 30px;
            }
            .package-info-card h4 {
                margin-bottom: 15px;
                font-weight: bold;
            }
            .info-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
                gap: 15px;
                margin-top: 15px;
            }
            .info-item {
                text-align: center;
                padding: 10px;
                background: rgba(255,255,255,0.1);
                border-radius: 8px;
            }
            .info-number {
                font-size: 1.3em;
                font-weight: bold;
            }
            .info-label {
                font-size: 0.9em;
                opacity: 0.9;
            }
            .section-card {
                background: white;
                border-radius: 12px;
                padding: 25px;
                margin-bottom: 25px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            .assignment-item {
                background-color: #f8f9fa;
                padding: 20px;
                border-radius: 8px;
                margin-bottom: 15px;
                border-left: 4px solid #28a745;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .assignment-item.expired {
                border-left-color: #dc3545;
                opacity: 0.7;
            }
            .assignment-item.inactive {
                border-left-color: #6c757d;
                opacity: 0.6;
            }
            .assignment-info h6 {
                margin-bottom: 8px;
                color: #333;
            }
            .assignment-details {
                font-size: 0.9em;
                color: #666;
            }
            .assignment-actions {
                display: flex;
                gap: 10px;
            }
            .unassigned-child {
                background-color: #e3f2fd;
                padding: 15px;
                border-radius: 8px;
                margin-bottom: 10px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                border-left: 4px solid #2196f3;
            }
            .child-info h6 {
                margin-bottom: 5px;
                color: #333;
            }
            .child-details {
                font-size: 0.9em;
                color: #666;
            }
            .no-items {
                text-align: center;
                padding: 40px 20px;
                color: #666;
            }
            .status-badge {
                padding: 4px 8px;
                border-radius: 12px;
                font-size: 0.8em;
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
                background-color: #e2e3e5;
                color: #495057;
            }
        </style>
    </head>
    <body>

        <%@include file="../header.jsp" %>

        <div class="manage-container">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2><i class="fas fa-cog"></i> Manage Package Assignments</h2>
                <a href="${pageContext.request.contextPath}/study_package?service=myPackagesDetailed" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Back to My Packages
                </a>
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

            <!-- Package Information -->
            <div class="package-info-card">
                <h4><i class="fas fa-box"></i> ${studyPackage.name}</h4>
                <p>${studyPackage.description}</p>
                <div class="info-grid">
                    <div class="info-item">
                        <div class="info-number">${studyPackage.max_students}</div>
                        <div class="info-label">Max Per Parent</div>
                    </div>
                    <div class="info-item">
                        <div class="info-number">${fn:length(assignments)}</div>
                        <div class="info-label">Your Assignments</div>
                    </div>
                    <div class="info-item">
                        <div class="info-number">${availableSlots}</div>
                        <div class="info-label">Your Available Slots</div>
                    </div>
                    <div class="info-item">
                        <div class="info-number">${studyPackage.duration_days}</div>
                        <div class="info-label">Duration (Days)</div>
                    </div>
                </div>
            </div>

            <!-- Current Assignments -->
            <div class="section-card">
                <h5><i class="fas fa-users"></i> Current Student Assignments</h5>
                <c:choose>
                    <c:when test="${not empty assignments}">
                        <c:forEach items="${assignments}" var="assignment">
                            <div class="assignment-item ${assignment.status == 'ACTIVE' ? '' : (assignment.status == 'EXPIRED' ? 'expired' : 'inactive')}">
                                <div class="assignment-info">
                                    <h6><i class="fas fa-user"></i> ${assignment.studentName}</h6>
                                    <div class="assignment-details">
                                        <div><strong>Username:</strong> ${assignment.studentUsername}</div>
                                        <div><strong>Grade:</strong> ${assignment.gradeName}</div>
                                        <div><strong>Purchased:</strong> 
                                            <fmt:formatDate value="${assignment.purchasedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </div>
                                        <div><strong>Expires:</strong> 
                                            <fmt:formatDate value="${assignment.expiresAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </div>
                                        <c:if test="${assignment.status == 'ACTIVE'}">
                                            <div><strong>Days Remaining:</strong> ${assignment.daysRemaining}</div>
                                        </c:if>
                                    </div>
                                </div>
                                <div class="assignment-actions">
                                    <span class="status-badge status-${assignment.status == 'ACTIVE' ? 'active' : (assignment.status == 'EXPIRED' ? 'expired' : 'inactive')}">
                                        ${assignment.status}
                                    </span>
                                    <c:if test="${assignment.status == 'ACTIVE'}">
                                        <button class="btn btn-warning btn-sm" 
                                                onclick="removeAssignment(${assignment.assignmentId}, '${assignment.studentName}')"
                                                title="Remove Assignment">
                                            <i class="fas fa-user-minus"></i> Remove
                                        </button>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="no-items">
                            <i class="fas fa-users-slash fa-2x mb-3"></i>
                            <p>No students assigned to this package yet.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Available Children to Assign -->
            <c:if test="${availableSlots > 0}">
                <div class="section-card">
                    <h5><i class="fas fa-user-plus"></i> Assign Additional Students 
                        <small class="text-muted">(${availableSlots} slot(s) available)</small>
                    </h5>
                    <c:choose>
                        <c:when test="${not empty unassignedChildren}">
                            <c:forEach items="${unassignedChildren}" var="child">
                                <div class="unassigned-child">
                                    <div class="child-info">
                                        <h6><i class="fas fa-user"></i> ${child.fullName}</h6>
                                        <div class="child-details">
                                            <strong>Username:</strong> ${child.username} | 
                                            <strong>Grade:</strong> ${child.gradeName}
                                        </div>
                                    </div>
                                    <button class="btn btn-success btn-sm" 
                                            onclick="assignStudent(${child.id}, '${child.fullName}')"
                                            title="Assign to Package">
                                        <i class="fas fa-plus"></i> Assign
                                    </button>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="no-items">
                                <i class="fas fa-info-circle fa-2x mb-3"></i>
                                <p>All your children are already assigned to this package or you have no additional children to assign.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>

            <c:if test="${availableSlots <= 0 && fn:length(assignments) >= studyPackage.max_students}">
                <div class="section-card">
                    <div class="alert alert-info">
                        <i class="fas fa-info-circle"></i>
                        <strong>Parent Limit Reached:</strong> You have reached your maximum limit of ${studyPackage.max_students} student(s) for this package. 
                        To assign more students, you would need to remove existing assignments first.
                    </div>
                </div>
            </c:if>
        </div>

        <%@include file="../footer.jsp" %>

        <script src="${pageContext.request.contextPath}/assets/js/vendor/jquery-1.12.4.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>

        <script>
                                                function assignStudent(studentId, studentName) {
                                                    if (confirm('Are you sure you want to assign "' + studentName + '" to this package?')) {
                                                        // Create a form and submit
                                                        var form = document.createElement('form');
                                                        form.method = 'POST';
                                                        form.action = 'study_package';

                                                        var serviceInput = document.createElement('input');
                                                        serviceInput.type = 'hidden';
                                                        serviceInput.name = 'service';
                                                        serviceInput.value = 'assignAdditionalStudent';
                                                        form.appendChild(serviceInput);

                                                        var packageIdInput = document.createElement('input');
                                                        packageIdInput.type = 'hidden';
                                                        packageIdInput.name = 'packageId';
                                                        packageIdInput.value = '${packageId}';
                                                        form.appendChild(packageIdInput);

                                                        var studentIdInput = document.createElement('input');
                                                        studentIdInput.type = 'hidden';
                                                        studentIdInput.name = 'studentId';
                                                        studentIdInput.value = studentId;
                                                        form.appendChild(studentIdInput);

                                                        document.body.appendChild(form);
                                                        form.submit();
                                                    }
                                                }

                                                function removeAssignment(assignmentId, studentName) {
                                                    if (confirm('Are you sure you want to remove "' + studentName + '" from this package?\n\nThis will immediately revoke their access to the package content.')) {
                                                        // Create a form and submit
                                                        var form = document.createElement('form');
                                                        form.method = 'POST';
                                                        form.action = 'study_package';

                                                        var serviceInput = document.createElement('input');
                                                        serviceInput.type = 'hidden';
                                                        serviceInput.name = 'service';
                                                        serviceInput.value = 'removeStudentAssignment';
                                                        form.appendChild(serviceInput);

                                                        var packageIdInput = document.createElement('input');
                                                        packageIdInput.type = 'hidden';
                                                        packageIdInput.name = 'packageId';
                                                        packageIdInput.value = '${packageId}';
                                                        form.appendChild(packageIdInput);

                                                        var assignmentIdInput = document.createElement('input');
                                                        assignmentIdInput.type = 'hidden';
                                                        assignmentIdInput.name = 'assignmentId';
                                                        assignmentIdInput.value = assignmentId;
                                                        form.appendChild(assignmentIdInput);

                                                        document.body.appendChild(form);
                                                        form.submit();
                                                    }
                                                }
        </script>

    </body>
</html>
