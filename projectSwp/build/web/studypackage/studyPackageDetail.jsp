<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Study Package Details</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
        <style>
            body {
                padding-top: 130px;
                background-color: #f8f9fa;
            }
            main {
                max-width: 800px;
                margin: 40px auto;
                background: #ffffff;
                padding: 40px;
                border-radius: 12px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            h2 {
                text-align: center;
                margin-bottom: 30px;
                font-weight: bold;
                color: #343a40;
                border-bottom: 3px solid #007bff;
                padding-bottom: 15px;
            }
            .detail-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 20px;
                margin: 30px 0;
            }
            .detail-item {
                background-color: #f8f9fa;
                padding: 20px;
                border-radius: 8px;
                border-left: 4px solid #007bff;
            }
            .detail-label {
                font-weight: bold;
                color: #666;
                font-size: 0.9em;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                margin-bottom: 8px;
            }
            .detail-value {
                color: #333;
                font-size: 1.1em;
            }
            .price-highlight {
                font-size: 1.5em;
                font-weight: bold;
                color: #28a745;
            }
            .package-type-badge {
                display: inline-block;
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 0.9em;
                font-weight: bold;
            }
            .type-combo {
                background-color: #e3f2fd;
                color: #1976d2;
            }
            .type-grade {
                background-color: #e8f5e8;
                color: #388e3c;
            }
            .status-badge {
                display: inline-block;
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 0.9em;
                font-weight: bold;
            }
            .status-active {
                background-color: #d4edda;
                color: #155724;
            }
            .status-inactive {
                background-color: #f8d7da;
                color: #721c24;
            }
            .description-section {
                background-color: #f8f9fa;
                padding: 25px;
                border-radius: 8px;
                margin: 25px 0;
                border-left: 4px solid #28a745;
            }
            .btn-container {
                display: flex;
                gap: 15px;
                justify-content: center;
                margin-top: 40px;
            }
            .btn {
                padding: 12px 25px;
                border-radius: 6px;
                border: none;
                text-decoration: none;
                font-size: 16px;
                transition: all 0.3s ease;
                cursor: pointer;
            }
            .btn-success {
                background-color: #28a745;
                color: white;
            }
            .btn-success:hover {
                background-color: #218838;
                color: white;
            }
            .btn-secondary {
                background-color: #6c757d;
                color: white;
            }
            .btn-secondary:hover {
                background-color: #5a6268;
                color: white;
            }
            .assignment-info {
                background-color: #fff3cd;
                border: 1px solid #ffeaa7;
                padding: 15px;
                border-radius: 6px;
                margin: 20px 0;
                color: #856404;
            }
        </style>
    </head>
    <body>

        <%@include file="../header.jsp" %>

        <main>
            <h2>Study Package Details</h2>

            <c:if test="${not empty studyPackageDetail}">
                <div class="detail-grid">
                    <c:if test="${studyPackageDetail.type == 'SUBJECT_COMBO'}">
                        <div class="description-section">
                            <div class="detail-label">
                                <i class="fas fa-layer-group"></i> Included Subjects
                            </div>
                            <div class="detail-value" style="margin-top: 10px;" id="packageSubjects">
                                <div class="text-center">
                                    <i class="fas fa-spinner fa-spin"></i> Loading subjects...
                                </div>
                            </div>
                        </div>
                    </c:if>
                    <div class="detail-item">
                        <div class="detail-label">Package ID</div>
                        <div class="detail-value">#${studyPackageDetail.id}</div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Package Name</div>
                        <div class="detail-value">${studyPackageDetail.name}</div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Package Type</div>
                        <div class="detail-value">
                            <span class="package-type-badge ${studyPackageDetail.type == 'GRADE_ALL' ? 'type-grade' : 'type-combo'}">
                                <c:choose>
                                    <c:when test="${studyPackageDetail.type == 'GRADE_ALL'}">
                                        <i class="fas fa-graduation-cap"></i> All Subjects in Grade
                                    </c:when>
                                    <c:otherwise>
                                        <i class="fas fa-layer-group"></i> Subject Combo
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Target Grade</div>
                        <div class="detail-value">
                            <c:if test="${studyPackageDetail.grade_id != null}">
                                <c:forEach items="${grades}" var="grade">
                                    <c:if test="${grade.id == studyPackageDetail.grade_id}">
                                        <i class="fas fa-school"></i> ${grade.name}
                                    </c:if>
                                </c:forEach>
                            </c:if>
                            <c:if test="${studyPackageDetail.grade_id == null}">
                                <span class="text-muted">Not specified</span>
                            </c:if>
                        </div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Price</div>
                        <div class="detail-value price-highlight">
                            <i class="fas fa-money-bill-wave"></i> ${studyPackageDetail.price} VND
                        </div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Maximum Students</div>
                        <div class="detail-value">
                            <i class="fas fa-users"></i> ${studyPackageDetail.max_students} student(s)
                        </div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Duration</div>
                        <div class="detail-value">
                            <i class="fas fa-calendar-alt"></i> ${studyPackageDetail.duration_days} days
                        </div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Status</div>
                        <div class="detail-value">
                            <span class="status-badge ${studyPackageDetail.is_active ? 'status-active' : 'status-inactive'}">
                                <i class="fas fa-${studyPackageDetail.is_active ? 'check-circle' : 'times-circle'}"></i>
                                ${studyPackageDetail.is_active ? 'Active' : 'Inactive'}
                            </span>
                        </div>
                    </div>
                </div>

                <c:if test="${not empty studyPackageDetail.description}">
                    <div class="description-section">
                        <div class="detail-label">
                            <i class="fas fa-info-circle"></i> Package Description
                        </div>
                        <div class="detail-value" style="margin-top: 10px;">
                            ${studyPackageDetail.description}
                        </div>
                    </div>
                </c:if>

                <c:if test="${not empty assignedCount}">
                    <div class="assignment-info">
                        <i class="fas fa-info-circle"></i>
                        <strong>Current Assignments:</strong> ${assignedCount} out of ${studyPackageDetail.max_students} students assigned to this package.
                    </div>
                </c:if>

                <div class="btn-container">
                    <c:if test="${sessionScope.account.role == 'parent' && studyPackageDetail.is_active}">
                        <a href="study_package?service=checkout&id=${studyPackageDetail.id}" 
                           class="btn btn-success"
                           onclick="return confirm('Do you want to purchase this study package?');">
                            <i class="fas fa-shopping-cart"></i> Purchase Package
                        </a>
                    </c:if>
                    <c:if test="${sessionScope.account.role == 'admin' || sessionScope.account.role == 'teacher'}">
                        <a href="study_package?service=edit&editId=${studyPackageDetail.id}" 
                           class="btn btn-success">
                            <i class="fas fa-edit"></i> Edit Package
                        </a>
                    </c:if>
                    <a href="study_package" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to List
                    </a>
                </div>
            </c:if>

            <c:if test="${empty studyPackageDetail}">
                <div class="alert alert-warning text-center">
                    <i class="fas fa-exclamation-triangle fa-2x mb-3"></i>
                    <h4>Package Not Found</h4>
                    <p>The requested study package could not be found.</p>
                    <a href="study_package" class="btn btn-primary">
                        <i class="fas fa-arrow-left"></i> Back to Packages
                    </a>
                </div>
            </c:if>
        </main>

        <%@include file="../footer.jsp" %>

        <!-- JS -->
        <script src="${pageContext.request.contextPath}/assets/js/vendor/jquery-1.12.4.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
        <script>
                               $(document).ready(function () {
            <c:if test="${studyPackageDetail.type == 'SUBJECT_COMBO'}">
                                   // Load subjects for this package
                                   $.ajax({
                                       url: 'study_package',
                                       type: 'GET',
                                       data: {
                                           service: 'getSubjectsByPackage',
                                           packageId: ${studyPackageDetail.id}
                                       },
                                       dataType: 'json',
                                       success: function (subjects) {
                                           let html = '';
                                           if (subjects && subjects.length > 0) {
                                               html = '<div class="row">';
                                               subjects.forEach(function (subject, index) {
                                                   if (index % 2 === 0 && index > 0) {
                                                       html += '</div><div class="row">';
                                                   }
                                                   html += '<div class="col-md-6 mb-2">' +
                                                           '<span class="badge badge-primary" style="font-size: 14px; padding: 8px 12px;">' +
                                                           '<i class="fas fa-book"></i> ' + subject.name +
                                                           '</span></div>';
                                               });
                                               html += '</div>';
                                           } else {
                                               html = '<div class="alert alert-info">No subjects configured for this package.</div>';
                                           }
                                           $('#packageSubjects').html(html);
                                       },
                                       error: function () {
                                           $('#packageSubjects').html('<div class="alert alert-danger">Error loading subjects.</div>');
                                       }
                                   });
            </c:if>
                               });
        </script>
    </body>
</html>