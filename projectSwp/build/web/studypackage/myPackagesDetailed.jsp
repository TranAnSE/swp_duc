<%-- 
    Document   : myPackagesDetailed
    Created on : Jun 29, 2025, 3:42:07 PM
    Author     : ankha
--%>

<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>My Study Packages - Detailed Management</title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="manifest" href="site.webmanifest">
        <link rel="shortcut icon" type="image/x-icon" href="assets/img/favicon.ico">

        <!-- CSS here -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/owl.carousel.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/slicknav.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/flaticon.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/progressbar_barfiller.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/gijgo.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/animate.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/animated-headline.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/magnific-popup.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fontawesome-all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/themify-icons.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/slick.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/nice-select.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">

        <style>
            .header-area {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                z-index: 1000;
                background-color: white;
                border-bottom: 1px solid #ddd;
            }

            body {
                padding-top: 130px;
                background-color: #f8f9fa;
            }

            main {
                max-width: 1400px;
                margin: 40px auto;
                padding: 20px;
                background-color: #f8f9fa;
            }

            .page-title {
                text-align: center;
                font-weight: 700;
                color: #343a40;
                margin-bottom: 30px;
                padding-bottom: 15px;
                border-bottom: 3px solid #007bff;
            }

            .action-buttons {
                display: flex;
                gap: 15px;
                justify-content: center;
                margin-bottom: 30px;
                flex-wrap: wrap;
            }

            .btn-custom {
                padding: 12px 20px;
                border-radius: 6px;
                text-decoration: none;
                font-size: 14px;
                font-weight: 600;
                transition: all 0.3s ease;
                border: none;
                cursor: pointer;
            }

            .btn-primary-custom {
                background-color: #007bff;
                color: white;
            }

            .btn-primary-custom:hover {
                background-color: #0056b3;
                color: white;
                transform: translateY(-2px);
            }

            .btn-secondary-custom {
                background-color: #6c757d;
                color: white;
            }

            .btn-secondary-custom:hover {
                background-color: #5a6268;
                color: white;
                transform: translateY(-2px);
            }

            .btn-info-custom {
                background-color: #17a2b8;
                color: white;
            }

            .btn-info-custom:hover {
                background-color: #138496;
                color: white;
                transform: translateY(-2px);
            }

            .package-card {
                background: white;
                border-radius: 15px;
                padding: 30px;
                margin-bottom: 30px;
                box-shadow: 0 8px 25px rgba(0,0,0,0.1);
                border-left: 6px solid #007bff;
                transition: all 0.3s ease;
            }

            .package-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 12px 35px rgba(0,0,0,0.15);
            }

            .package-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 25px;
                padding-bottom: 20px;
                border-bottom: 2px solid #e9ecef;
            }

            .package-title {
                font-size: 1.5em;
                font-weight: bold;
                color: #333;
                margin-bottom: 8px;
            }

            .package-subtitle {
                font-size: 0.9em;
                color: #666;
                line-height: 1.4;
            }

            .package-price {
                font-size: 1.2em;
                font-weight: bold;
                color: #28a745;
                margin-top: 5px;
            }

            .manage-btn {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                border: none;
                padding: 10px 18px;
                border-radius: 8px;
                text-decoration: none;
                font-size: 0.9em;
                font-weight: 600;
                transition: all 0.3s ease;
                box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
            }

            .manage-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(102, 126, 234, 0.6);
                color: white;
            }

            .package-stats {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
                gap: 20px;
                margin: 25px 0;
            }

            .stat-item {
                text-align: center;
                padding: 20px 15px;
                background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
                border-radius: 12px;
                border: 1px solid #dee2e6;
                transition: all 0.3s ease;
            }

            .stat-item:hover {
                transform: translateY(-3px);
                box-shadow: 0 6px 20px rgba(0,0,0,0.1);
            }

            .stat-number {
                font-size: 1.8em;
                font-weight: bold;
                color: #007bff;
                margin-bottom: 5px;
            }

            .stat-label {
                font-size: 0.85em;
                color: #666;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .assignments-section {
                margin-top: 30px;
            }

            .section-title {
                font-size: 1.1em;
                font-weight: bold;
                color: #333;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .assignment-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                gap: 20px;
            }

            .student-assignment {
                background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
                padding: 20px;
                border-radius: 12px;
                border-left: 5px solid #28a745;
                transition: all 0.3s ease;
                box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            }

            .student-assignment:hover {
                transform: translateY(-3px);
                box-shadow: 0 6px 20px rgba(0,0,0,0.15);
            }

            .student-assignment.expired {
                border-left-color: #dc3545;
                background: linear-gradient(135deg, #f8d7da 0%, #ffffff 100%);
            }

            .student-assignment.inactive {
                border-left-color: #6c757d;
                background: linear-gradient(135deg, #e2e3e5 0%, #ffffff 100%);
                opacity: 0.8;
            }

            .student-name {
                font-weight: bold;
                color: #333;
                margin-bottom: 12px;
                font-size: 1.1em;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .assignment-info {
                font-size: 0.9em;
                color: #666;
                line-height: 1.6;
            }

            .assignment-info div {
                margin-bottom: 6px;
            }

            .status-badge {
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 0.8em;
                font-weight: bold;
                margin-top: 12px;
                display: inline-block;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .status-active {
                background-color: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }

            .status-expired {
                background-color: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
            }

            .status-inactive {
                background-color: #e2e3e5;
                color: #495057;
                border: 1px solid #d6d8db;
            }

            .no-assignments {
                text-align: center;
                padding: 40px 20px;
                color: #666;
                background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
                border-radius: 12px;
                border: 2px dashed #dee2e6;
            }

            .no-assignments i {
                font-size: 3em;
                color: #dee2e6;
                margin-bottom: 15px;
            }

            .no-packages {
                text-align: center;
                padding: 80px 20px;
                background: white;
                border-radius: 15px;
                box-shadow: 0 8px 25px rgba(0,0,0,0.1);
                margin: 40px 0;
            }

            .no-packages i {
                font-size: 4em;
                color: #dee2e6;
                margin-bottom: 20px;
            }

            .no-packages h4 {
                color: #333;
                margin-bottom: 15px;
            }

            .no-packages p {
                color: #666;
                margin-bottom: 25px;
            }

            .package-actions {
                display: flex;
                gap: 10px;
                justify-content: center;
                margin-top: 25px;
                flex-wrap: wrap;
            }

            .btn-sm-custom {
                padding: 8px 15px;
                font-size: 0.85em;
                border-radius: 6px;
                text-decoration: none;
                font-weight: 600;
                transition: all 0.3s ease;
                border: none;
                cursor: pointer;
            }

            .btn-info-sm {
                background-color: #17a2b8;
                color: white;
            }

            .btn-info-sm:hover {
                background-color: #138496;
                color: white;
                transform: translateY(-1px);
            }

            .btn-success-sm {
                background-color: #28a745;
                color: white;
            }

            .btn-success-sm:hover {
                background-color: #218838;
                color: white;
                transform: translateY(-1px);
            }

            .alert-custom {
                border-radius: 10px;
                padding: 15px 20px;
                margin-bottom: 25px;
                border: none;
                box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            }

            .alert-success-custom {
                background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
                color: #155724;
                border-left: 4px solid #28a745;
            }

            .alert-danger-custom {
                background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%);
                color: #721c24;
                border-left: 4px solid #dc3545;
            }

            .days-remaining {
                font-weight: bold;
                color: #28a745;
            }

            .days-remaining.warning {
                color: #ffc107;
            }

            .days-remaining.danger {
                color: #dc3545;
            }

            @media (max-width: 768px) {
                .package-header {
                    flex-direction: column;
                    text-align: center;
                    gap: 15px;
                }

                .action-buttons {
                    flex-direction: column;
                    align-items: center;
                }

                .package-stats {
                    grid-template-columns: repeat(2, 1fr);
                }

                .assignment-grid {
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </head>
    <body>
        <!-- Preloader Start -->
        <div id="preloader-active">
            <div class="preloader d-flex align-items-center justify-content-center">
                <div class="preloader-inner position-relative">
                    <div class="preloader-circle"></div>
                    <div class="preloader-img pere-text">
                        <img src="${pageContext.request.contextPath}/assets/img/logo/loder.png" alt="">
                    </div>
                </div>
            </div>
        </div>
        <!-- Preloader End -->

        <%@include file="../header.jsp" %>

        <main>
            <h2 class="page-title">
                <i class="fas fa-boxes"></i> My Study Packages - Detailed Management
            </h2>

            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/study_package" class="btn-custom btn-primary-custom">
                    <i class="fas fa-plus"></i> Purchase New Package
                </a>
                <a href="${pageContext.request.contextPath}/study_package?service=myPackages" class="btn-custom btn-secondary-custom">
                    <i class="fas fa-list"></i> Simple View
                </a>
                <a href="${pageContext.request.contextPath}/study_package" class="btn-custom btn-info-custom">
                    <i class="fas fa-arrow-left"></i> Back to Packages
                </a>
            </div>

            <c:if test="${not empty message}">
                <div class="alert-custom alert-success-custom">
                    <i class="fas fa-check-circle"></i> ${message}
                </div>
            </c:if>

            <c:if test="${not empty errorMessage}">
                <div class="alert-custom alert-danger-custom">
                    <i class="fas fa-exclamation-circle"></i> ${errorMessage}
                </div>
            </c:if>

            <c:choose>
                <c:when test="${empty parentPackages}">
                    <div class="no-packages">
                        <i class="fas fa-box-open"></i>
                        <h4>No Study Packages Yet</h4>
                        <p>You haven't purchased any study packages for your children yet. Start exploring our available packages to enhance your children's learning experience.</p>
                        <a href="${pageContext.request.contextPath}/study_package" class="btn-custom btn-primary-custom">
                            <i class="fas fa-shopping-cart"></i> Browse Available Packages
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${parentPackages}" var="packageInfo">
                        <div class="package-card">
                            <div class="package-header">
                                <div>
                                    <div class="package-title">
                                        <i class="fas fa-box"></i> ${packageInfo.packageName}
                                    </div>
                                    <div class="package-subtitle">
                                        Duration: ${packageInfo.durationDays} days per assignment<br>
                                        <span class="package-price">
                                            <i class="fas fa-money-bill-wave"></i>${packageInfo.price} VND
                                        </span>
                                    </div>
                                </div>
                                <div>
                                    <a href="study_package?service=managePackageAssignments&packageId=${packageInfo.packageId}" 
                                       class="manage-btn">
                                        <i class="fas fa-cog"></i> Manage Assignments
                                    </a>
                                </div>
                            </div>

                            <!-- Package Statistics -->
                            <div class="package-stats">
                                <div class="stat-item">
                                    <div class="stat-number">${packageInfo.maxStudents}</div>
                                    <div class="stat-label">Slots Per Purchase</div>
                                </div>
                                <div class="stat-item">
                                    <div class="stat-number">
                                        <c:set var="totalSlots" value="0"/>
                                        <c:forEach items="${packageInfo.purchaseHistory}" var="purchase">
                                            <c:set var="totalSlots" value="${totalSlots + purchase.maxAssignableStudents}"/>
                                        </c:forEach>
                                        ${totalSlots}
                                    </div>
                                    <div class="stat-label">Total Purchased Slots</div>
                                </div>
                                <div class="stat-item">
                                    <div class="stat-number">${packageInfo.activeAssignments}</div>
                                    <div class="stat-label">Currently Assigned</div>
                                </div>
                                <div class="stat-item">
                                    <div class="stat-number">${totalSlots - packageInfo.activeAssignments}</div>
                                    <div class="stat-label">Available Slots</div>
                                </div>
                            </div>

                            <!-- Purchase History Section -->
                            <c:if test="${not empty packageInfo.purchaseHistory}">
                                <div class="assignments-section">
                                    <div class="section-title">
                                        <i class="fas fa-receipt"></i> Purchase History (${fn:length(packageInfo.purchaseHistory)} purchases)
                                    </div>
                                    <div class="assignment-grid">
                                        <c:forEach items="${packageInfo.purchaseHistory}" var="purchase">
                                            <div class="student-assignment" style="border-left-color: #17a2b8;">
                                                <div class="student-name">
                                                    <i class="fas fa-shopping-cart"></i> Purchase #${purchase.purchaseId}
                                                </div>
                                                <div class="assignment-info">
                                                    <div><strong>Date:</strong> 
                                                        <fmt:formatDate value="${purchase.purchaseDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                    </div>
                                                    <div><strong>Amount:</strong> ${purchase.totalAmount} VND</div>
                                                    <div><strong>Slots Purchased:</strong> ${purchase.maxAssignableStudents}</div>
                                                    <div><strong>Students Assigned:</strong> ${purchase.studentsAssigned}</div>
                                                    <div><strong>Available:</strong> ${purchase.maxAssignableStudents - purchase.studentsAssigned}</div>
                                                </div>
                                                <span class="status-badge status-${purchase.status == 'COMPLETED' ? 'active' : 'inactive'}">
                                                    ${purchase.status}
                                                </span>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </c:if>

                            <!-- Student Assignments -->
                            <div class="assignments-section">
                                <c:choose>
                                    <c:when test="${not empty packageInfo.assignments}">
                                        <div class="section-title">
                                            <i class="fas fa-users"></i> Student Assignments (${fn:length(packageInfo.assignments)} students)
                                        </div>
                                        <div class="assignment-grid">
                                            <c:forEach items="${packageInfo.assignments}" var="assignment">
                                                <div class="student-assignment ${assignment.status == 'ACTIVE' ? '' : (assignment.status == 'EXPIRED' ? 'expired' : 'inactive')}">
                                                    <div class="student-name">
                                                        <i class="fas fa-user"></i> ${assignment.studentName}
                                                    </div>
                                                    <div class="assignment-info">
                                                        <div><strong>Username:</strong> ${assignment.studentUsername}</div>
                                                        <div><strong>Grade:</strong> ${assignment.gradeName}</div>
                                                        <div><strong>Purchased:</strong> 
                                                            <fmt:formatDate value="${assignment.purchasedAt}" pattern="dd/MM/yyyy"/>
                                                        </div>
                                                        <div><strong>Expires:</strong> 
                                                            <fmt:formatDate value="${assignment.expiresAt}" pattern="dd/MM/yyyy"/>
                                                        </div>
                                                        <c:if test="${assignment.status == 'ACTIVE'}">
                                                            <div><strong>Days Remaining:</strong> 
                                                                <span class="days-remaining ${assignment.daysRemaining <= 7 ? 'danger' : (assignment.daysRemaining <= 30 ? 'warning' : '')}">
                                                                    ${assignment.daysRemaining} days
                                                                </span>
                                                            </div>
                                                        </c:if>
                                                    </div>
                                                    <span class="status-badge status-${assignment.status == 'ACTIVE' ? 'active' : (assignment.status == 'EXPIRED' ? 'expired' : 'inactive')}">
                                                        ${assignment.status}
                                                    </span>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="section-title">
                                            <i class="fas fa-info-circle"></i> No Student Assignments
                                        </div>
                                        <div class="no-assignments">
                                            <i class="fas fa-user-plus"></i>
                                            <h5>No students assigned yet</h5>
                                            <p>This package hasn't been assigned to any students yet. Click "Manage Assignments" to assign students to this package.</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- Action Buttons -->
                            <div class="package-actions">
                                <a href="study_package?service=detail&id=${packageInfo.packageId}" 
                                   class="btn-sm-custom btn-info-sm">
                                    <i class="fas fa-eye"></i> View Package Details
                                </a>
                                <c:if test="${packageInfo.activeAssignments < packageInfo.maxStudents}">
                                    <a href="study_package?service=managePackageAssignments&packageId=${packageInfo.packageId}" 
                                       class="btn-sm-custom btn-success-sm">
                                        <i class="fas fa-user-plus"></i> Assign More Students (${packageInfo.maxStudents - packageInfo.activeAssignments} slots available)
                                    </a>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </main>

        <%@include file="../footer.jsp" %>
        <div id="back-top">
            <a title="Go to Top" href="#"> <i class="fas fa-level-up-alt"></i></a>
        </div>

        <!-- JS here -->
        <script src="${pageContext.request.contextPath}/assets/js/vendor/modernizr-3.5.0.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/vendor/jquery-1.12.4.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/popper.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.slicknav.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/owl.carousel.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/slick.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/wow.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/animated.headline.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.magnific-popup.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/gijgo.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.nice-select.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.sticky.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.barfiller.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.counterup.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/waypoints.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.countdown.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/hover-direction-snake.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/contact.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.form.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.validate.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/mail-script.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.ajaxchimp.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/plugins.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>

        <script>
            $(document).ready(function () {
                // Initialize nice-select for any select elements
                $('select').niceSelect();

                // Add smooth scrolling to anchor links
                $('a[href^="#"]').on('click', function (event) {
                    var target = $(this.getAttribute('href'));
                    if (target.length) {
                        event.preventDefault();
                        $('html, body').stop().animate({
                            scrollTop: target.offset().top - 100
                        }, 1000);
                    }
                });

                // Add loading state to manage buttons
                $('.manage-btn').on('click', function () {
                    var $btn = $(this);
                    var originalText = $btn.html();
                    $btn.html('<i class="fas fa-spinner fa-spin"></i> Loading...');

                    // Reset button after 3 seconds if page doesn't change
                    setTimeout(function () {
                        $btn.html(originalText);
                    }, 3000);
                });

                // Highlight packages with expiring assignments
                $('.days-remaining.danger').each(function () {
                    $(this).closest('.student-assignment').addClass('border-danger');
                });

                // Add tooltips to status badges
                $('.status-badge').each(function () {
                    var status = $(this).text().trim();
                    var tooltip = '';

                    switch (status) {
                        case 'ACTIVE':
                            tooltip = 'Student has active access to this package';
                            break;
                        case 'EXPIRED':
                            tooltip = 'Student\'s access to this package has expired';
                            break;
                        case 'INACTIVE':
                            tooltip = 'Student\'s access has been deactivated';
                            break;
                    }

                    $(this).attr('title', tooltip);
                });
            });
        </script>
    </body>
</html>