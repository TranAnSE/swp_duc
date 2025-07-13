<%-- 
    Document   : myPackages
    Created on : Jun 29, 2025, 3:21:51 AM
    Author     : ankha
--%>

<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>My Study Packages</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
        <style>
            body {
                padding-top: 130px;
                background-color: #f8f9fa;
            }
            main {
                max-width: 1200px;
                margin: 40px auto;
                padding: 20px;
            }
            .package-card {
                background: white;
                border-radius: 12px;
                padding: 25px;
                margin-bottom: 25px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
                border-left: 5px solid #007bff;
            }
            .package-card.expired {
                border-left-color: #dc3545;
                opacity: 0.7;
            }
            .package-card.active {
                border-left-color: #28a745;
            }
            .package-header {
                display: flex;
                justify-content: between;
                align-items: center;
                margin-bottom: 15px;
            }
            .package-title {
                font-size: 1.3em;
                font-weight: bold;
                color: #333;
            }
            .status-badge {
                padding: 5px 12px;
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
            .package-info {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 15px;
                margin: 15px 0;
            }
            .info-item {
                background-color: #f8f9fa;
                padding: 12px;
                border-radius: 6px;
            }
            .info-label {
                font-weight: bold;
                color: #666;
                font-size: 0.9em;
            }
            .info-value {
                color: #333;
                margin-top: 5px;
            }
            .no-packages {
                text-align: center;
                padding: 60px 20px;
                background: white;
                border-radius: 12px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            .btn-group {
                display: flex;
                gap: 10px;
                margin-top: 15px;
            }
        </style>
    </head>
    <body>

        <%@include file="../header.jsp" %>

        <main>
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2><i class="fas fa-box"></i> My Study Packages</h2>
                <div>
                    <a href="${pageContext.request.contextPath}/study_package?service=myPackagesDetailed" class="btn btn-info">
                        <i class="fas fa-cog"></i> Detailed Management
                    </a>
                    <a href="${pageContext.request.contextPath}/study_package" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Purchase New Package
                    </a>
                </div>
            </div>

            <c:choose>
                <c:when test="${empty studentPackages}">
                    <div class="no-packages">
                        <i class="fas fa-box-open fa-3x text-muted mb-3"></i>
                        <h4>No Study Packages Yet</h4>
                        <p>You haven't purchased any study packages for your children yet.</p>
                        <a href="${pageContext.request.contextPath}/study_package" class="btn btn-primary">
                            <i class="fas fa-shopping-cart"></i> Browse Packages
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${studentPackages}" var="studentPackage">
                        <div class="package-card ${studentPackage.statusClass}">
                            <div class="package-header">
                                <div class="package-title">
                                    ${studentPackage.package_name}
                                </div>
                            </div>

                            <div class="package-info">
                                <div class="info-item">
                                    <div class="info-label">Student</div>
                                    <div class="info-value">${studentPackage.student_name}</div>
                                </div>
                                <div class="info-item">
                                    <div class="info-label">Purchased Date</div>
                                    <div class="info-value">${studentPackage.formattedPurchasedAt}</div>
                                </div>
                                <div class="info-item">
                                    <div class="info-label">Expires Date</div>
                                    <div class="info-value">${studentPackage.formattedExpiresAt}</div>
                                </div>
                                <div class="info-item">
                                    <div class="info-label">Days Remaining</div>
                                    <div class="info-value">
                                        <c:choose>
                                            <c:when test="${studentPackage.active}">
                                                <span class="text-success">${studentPackage.daysRemaining} days</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-danger">Expired</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>

                            <div class="btn-group">
                                <a href="${pageContext.request.contextPath}/study_package?service=detail&id=${studentPackage.package_id}" 
                                   class="btn btn-info btn-sm">
                                    <i class="fas fa-eye"></i> View Package Details
                                </a>
                                <c:if test="${studentPackage.active}">
                                    <a href="${pageContext.request.contextPath}/video-viewer?courseId=${studentPackage.package_id}" 
                                       class="btn btn-success btn-sm">
                                        <i class="fas fa-play"></i> Start Learning
                                    </a>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </main>

        <%@include file="../footer.jsp" %>

        <script src="${pageContext.request.contextPath}/assets/js/vendor/jquery-1.12.4.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>

    </body>
</html>