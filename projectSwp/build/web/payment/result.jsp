<%-- 
    Document   : result
    Created on : Jun 29, 2025, 3:27:13 AM
    Author     : ankha
--%>

<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Payment Result</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
        <style>
            body {
                padding-top: 130px;
                background-color: #f8f9fa;
            }
            .result-container {
                max-width: 600px;
                margin: 60px auto;
                background: #ffffff;
                padding: 40px;
                border-radius: 12px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.1);
                text-align: center;
            }
            .success-icon {
                color: #28a745;
                font-size: 4em;
                margin-bottom: 20px;
            }
            .error-icon {
                color: #dc3545;
                font-size: 4em;
                margin-bottom: 20px;
            }
            .result-title {
                font-size: 1.8em;
                font-weight: bold;
                margin-bottom: 20px;
            }
            .success-title {
                color: #28a745;
            }
            .error-title {
                color: #dc3545;
            }
            .result-message {
                font-size: 1.1em;
                margin-bottom: 30px;
                line-height: 1.6;
            }
            .package-info {
                background-color: #f8f9fa;
                padding: 20px;
                border-radius: 8px;
                margin: 20px 0;
                border-left: 4px solid #28a745;
            }
            .btn-container {
                margin-top: 30px;
            }
            .btn {
                padding: 12px 25px;
                margin: 0 10px;
                border-radius: 6px;
                border: none;
                text-decoration: none;
                font-size: 16px;
                transition: all 0.3s ease;
            }
            .btn-primary {
                background-color: #007bff;
                color: white;
            }
            .btn-primary:hover {
                background-color: #0056b3;
                color: white;
            }
            .btn-success {
                background-color: #28a745;
                color: white;
            }
            .btn-success:hover {
                background-color: #218838;
                color: white;
            }
        </style>
    </head>
    <body>

        <%@include file="../header.jsp" %>

        <div class="result-container">
            <c:choose>
                <c:when test="${not empty message}">
                    <!-- Success -->
                    <div class="success-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <h2 class="result-title success-title">Payment Successful!</h2>
                    <div class="result-message">
                        ${message}
                    </div>

                    <c:if test="${not empty packageName}">
                        <div class="package-info">
                            <h5><i class="fas fa-box"></i> Package Details</h5>
                            <p><strong>Package:</strong> ${packageName}</p>
                            <p><strong>Assigned to:</strong> ${studentCount} student(s)</p>
                            <p><strong>Status:</strong> <span class="text-success">Active</span></p>
                        </div>
                    </c:if>

                    <div class="btn-container">
                        <a href="${pageContext.request.contextPath}/study_package?service=myPackages" class="btn btn-success">
                            <i class="fas fa-box"></i> View My Packages
                        </a>
                        <a href="${pageContext.request.contextPath}/video-viewer" class="btn btn-primary">
                            <i class="fas fa-play"></i> Start Learning
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- Error -->
                    <div class="error-icon">
                        <i class="fas fa-times-circle"></i>
                    </div>
                    <h2 class="result-title error-title">Payment Failed</h2>
                    <div class="result-message">
                        <c:choose>
                            <c:when test="${not empty errorMessage}">
                                ${errorMessage}
                            </c:when>
                            <c:otherwise>
                                Your payment could not be processed. Please try again or contact support if the problem persists.
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="btn-container">
                        <a href="${pageContext.request.contextPath}/study_package" class="btn btn-primary">
                            <i class="fas fa-arrow-left"></i> Back to Packages
                        </a>
                        <a href="${pageContext.request.contextPath}/contact" class="btn btn-success">
                            <i class="fas fa-phone"></i> Contact Support
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <%@include file="../footer.jsp" %>

        <script src="${pageContext.request.contextPath}/assets/js/vendor/jquery-1.12.4.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>

    </body>
</html>
