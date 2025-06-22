<%-- 
    Document   : student
    Created on : May 21, 2025, 9:01:36 PM
    Author     : BuiNgocLinh
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Student Dashboard</title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- CSS Libraries - Use your existing ones -->
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

        <!-- Chart.js - Use compatible version -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js@3.9.1/dist/chart.min.js"></script>

        <style>
            /* Override any conflicting styles */
            .dashboard-container {
                background-color: #f8f9fa;
                min-height: 100vh;
                padding-top: 120px; /* Account for fixed header */
                color: #333 !important; /* Force dark text */
            }

            .dashboard-header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white !important;
                padding: 2rem 0;
                margin-bottom: 2rem;
                border-radius: 10px;
            }

            .dashboard-header h1,
            .dashboard-header p,
            .dashboard-header .h4,
            .dashboard-header small {
                color: white !important;
            }

            .stat-card {
                background: white;
                border-radius: 10px;
                padding: 1.5rem;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                transition: transform 0.3s ease;
                height: 100%;
                color: #333 !important;
            }

            .stat-card:hover {
                transform: translateY(-5px);
            }

            .stat-icon {
                width: 60px;
                height: 60px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 24px;
                margin-bottom: 1rem;
            }

            .stat-value {
                font-size: 2rem;
                font-weight: bold;
                color: #333 !important;
            }

            .stat-label {
                color: #666 !important;
                font-size: 0.9rem;
            }

            .chart-container {
                background: white;
                border-radius: 10px;
                padding: 1.5rem;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                margin-bottom: 2rem;
                height: 400px;
                color: #333 !important;
            }

            .chart-title {
                font-size: 1.2rem;
                font-weight: bold;
                margin-bottom: 1rem;
                color: #333 !important;
            }

            .quick-action-card {
                background: white;
                border-radius: 10px;
                padding: 1rem;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                text-align: center;
                transition: transform 0.3s ease;
                height: 100%;
                color: #333 !important;
            }

            .quick-action-card:hover {
                transform: translateY(-3px);
            }

            .quick-action-icon {
                font-size: 2rem;
                margin-bottom: 0.5rem;
            }

            .activity-item {
                background: white;
                border-radius: 8px;
                padding: 1rem;
                margin-bottom: 0.5rem;
                box-shadow: 0 1px 5px rgba(0,0,0,0.1);
                color: #333 !important;
            }

            .activity-item h6,
            .activity-item small,
            .activity-item p {
                color: inherit !important;
            }

            .progress-bar-custom {
                height: 8px;
                border-radius: 4px;
            }

            .badge-practice {
                background-color: #28a745 !important;
                color: white !important;
            }

            .badge-official {
                background-color: #007bff !important;
                color: white !important;
            }

            .text-primary {
                color: #007bff !important;
            }
            .text-success {
                color: #28a745 !important;
            }
            .text-info {
                color: #17a2b8 !important;
            }
            .text-warning {
                color: #ffc107 !important;
            }
            .text-danger {
                color: #dc3545 !important;
            }
            .text-muted {
                color: #6c757d !important;
            }

            .bg-primary-light {
                background-color: rgba(0,123,255,0.1) !important;
            }
            .bg-success-light {
                background-color: rgba(40,167,69,0.1) !important;
            }
            .bg-info-light {
                background-color: rgba(23,162,184,0.1) !important;
            }
            .bg-warning-light {
                background-color: rgba(255,193,7,0.1) !important;
            }
            .bg-danger-light {
                background-color: rgba(220,53,69,0.1) !important;
            }

            /* Card overrides */
            .card {
                background: white !important;
                color: #333 !important;
                border: 1px solid #dee2e6;
            }

            .card-header {
                background-color: #f8f9fa !important;
                border-bottom: 1px solid #dee2e6;
                color: #333 !important;
            }

            .card-header h5 {
                color: #333 !important;
            }

            .card-body {
                color: #333 !important;
            }

            /* Text decoration fix */
            a.text-decoration-none {
                text-decoration: none !important;
            }

            a.text-decoration-none:hover {
                text-decoration: none !important;
            }

            /* Font weight fix */
            .font-weight-bold {
                font-weight: bold !important;
            }

            .font-weight-medium {
                font-weight: 500 !important;
            }

            /* Chart canvas container */
            .chart-canvas-container {
                position: relative;
                height: 300px;
                width: 100%;
            }

            /* Empty state styling */
            .empty-state {
                text-align: center;
                padding: 3rem 1rem;
                color: #6c757d !important;
            }

            .empty-state i {
                color: #6c757d !important;
                margin-bottom: 1rem;
            }

            .empty-state p {
                color: #6c757d !important;
                margin: 0;
            }
        </style>
    </head>

    <body>
        <!-- Include header -->
        <jsp:include page="../header.jsp" />

        <div class="dashboard-container">
            <div class="container-fluid">
                <!-- Dashboard Header -->
                <div class="dashboard-header">
                    <div class="container">
                        <div class="row align-items-center">
                            <div class="col-md-8">
                                <h1 class="mb-0">Welcome back, ${student.full_name}!</h1>
                                <p class="mb-0 mt-2">Here's your learning progress overview</p>
                            </div>
                            <div class="col-md-4 text-right">
                                <div class="d-flex justify-content-end">
                                    <div class="text-center mr-3">
                                        <div class="h4 mb-0">${dashboardData.studentStats.currentStreak}</div>
                                        <small>Day Streak</small>
                                    </div>
                                    <div class="text-center">
                                        <div class="h4 mb-0">${dashboardData.studentStats.completionRate}%</div>
                                        <small>Completion Rate</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Statistics Cards -->
                <div class="row mb-4">
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stat-card">
                            <div class="stat-icon bg-primary-light text-primary">
                                <i class="fas fa-clipboard"></i>
                            </div>
                            <div class="stat-value">${dashboardData.studentStats.totalTestsTaken}</div>
                            <div class="stat-label">Total Tests Taken</div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stat-card">
                            <div class="stat-icon bg-success-light text-success">
                                <i class="fas fa-check-circle"></i>
                            </div>
                            <div class="stat-value">${dashboardData.studentStats.completedTests}</div>
                            <div class="stat-label">Completed Tests</div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stat-card">
                            <div class="stat-icon bg-warning-light text-warning">
                                <i class="fas fa-star"></i>
                            </div>
                            <div class="stat-value">${dashboardData.studentStats.avgScore}/10</div>
                            <div class="stat-label">Average Score</div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-3">
                        <div class="stat-card">
                            <div class="stat-icon bg-info-light text-info">
                                <i class="fas fa-trophy"></i>
                            </div>
                            <div class="stat-value">${dashboardData.studentStats.bestScore}/10</div>
                            <div class="stat-label">Best Score</div>
                        </div>
                    </div>
                </div>

                <!-- Charts Row -->
                <div class="row mb-4">
                    <!-- Test Performance Chart -->
                    <div class="col-lg-8 mb-3">
                        <div class="chart-container">
                            <div class="chart-title">
                                <i class="fas fa-chart-line mr-2"></i>Test Performance Over Time
                            </div>
                            <div class="chart-canvas-container">
                                <canvas id="testPerformanceChart"></canvas>
                            </div>
                        </div>
                    </div>

                    <!-- Test Type Distribution -->
                    <div class="col-lg-4 mb-3">
                        <div class="chart-container">
                            <div class="chart-title">
                                <i class="fas fa-chart-pie mr-2"></i>Test Type Distribution
                            </div>
                            <div class="chart-canvas-container">
                                <canvas id="testTypeChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Subject Performance and Monthly Activity -->
                <div class="row mb-4">
                    <!-- Subject Performance -->
                    <div class="col-lg-6 mb-3">
                        <div class="chart-container">
                            <div class="chart-title">
                                <i class="fas fa-book mr-2"></i>Subject Performance
                            </div>
                            <div class="chart-canvas-container">
                                <canvas id="subjectPerformanceChart"></canvas>
                            </div>
                        </div>
                    </div>

                    <!-- Monthly Activity -->
                    <div class="col-lg-6 mb-3">
                        <div class="chart-container">
                            <div class="chart-title">
                                <i class="fas fa-calendar-alt mr-2"></i>Monthly Activity
                            </div>
                            <div class="chart-canvas-container">
                                <canvas id="monthlyActivityChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Quick Actions and Recent Activities -->
                <div class="row mb-4">
                    <!-- Quick Actions -->
                    <div class="col-lg-4 mb-3">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="mb-0"><i class="fas fa-bolt mr-2"></i>Quick Actions</h5>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-6 mb-3">
                                        <a href="/student/taketest" class="text-decoration-none">
                                            <div class="quick-action-card">
                                                <div class="quick-action-icon text-primary">
                                                    <i class="fas fa-play-circle"></i>
                                                </div>
                                                <div class="font-weight-bold">Take Test</div>
                                            </div>
                                        </a>
                                    </div>
                                    <div class="col-6 mb-3">
                                        <a href="/student/taketest?action=history" class="text-decoration-none">
                                            <div class="quick-action-card">
                                                <div class="quick-action-icon text-info">
                                                    <i class="fas fa-history"></i>
                                                </div>
                                                <div class="font-weight-bold">Test History</div>
                                            </div>
                                        </a>
                                    </div>
                                    <div class="col-6 mb-3">
                                        <a href="/LessonURL" class="text-decoration-none">
                                            <div class="quick-action-card">
                                                <div class="quick-action-icon text-success">
                                                    <i class="fas fa-book"></i>
                                                </div>
                                                <div class="font-weight-bold">Study Lessons</div>
                                            </div>
                                        </a>
                                    </div>
                                    <div class="col-6 mb-3">
                                        <a href="/subjects" class="text-decoration-none">
                                            <div class="quick-action-card">
                                                <div class="quick-action-icon text-warning">
                                                    <i class="fas fa-graduation-cap"></i>
                                                </div>
                                                <div class="font-weight-bold">My Subjects</div>
                                            </div>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Recent Activities -->
                    <div class="col-lg-8 mb-3">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="mb-0"><i class="fas fa-clock mr-2"></i>Recent Activities</h5>
                            </div>
                            <div class="card-body" style="max-height: 400px; overflow-y: auto;">
                                <c:forEach var="activity" items="${dashboardData.recentActivities}" varStatus="status">
                                    <div class="activity-item">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <h6 class="mb-1">${activity.testName}</h6>
                                                <small class="text-muted">
                                                    <c:choose>
                                                        <c:when test="${activity.finishAt != null}">
                                                            Completed on <fmt:formatDate value="${activity.finishAt}" pattern="MMM dd, yyyy HH:mm"/>
                                                        </c:when>
                                                        <c:otherwise>
                                                            Started on <fmt:formatDate value="${activity.startedAt}" pattern="MMM dd, yyyy HH:mm"/>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </small>
                                            </div>
                                            <div class="text-right">
                                                <c:if test="${activity.score != null}">
                                                    <div class="font-weight-bold text-primary">${activity.score}/10</div>
                                                </c:if>
                                                <span class="badge ${activity.testType == 'Practice' ? 'badge-practice' : 'badge-official'}">
                                                    ${activity.testType}
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>

                                <c:if test="${empty dashboardData.recentActivities}">
                                    <div class="empty-state">
                                        <i class="fas fa-inbox fa-3x"></i>
                                        <p>No recent activities yet. Start taking tests to see your progress!</p>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Available Tests and Study Progress -->
                <div class="row mb-4">
                    <!-- Available Tests -->
                    <div class="col-lg-6 mb-3">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="mb-0"><i class="fas fa-list-ul mr-2"></i>Available Tests</h5>
                            </div>
                            <div class="card-body" style="max-height: 400px; overflow-y: auto;">
                                <c:forEach var="test" items="${dashboardData.availableTests}" varStatus="status">
                                    <div class="activity-item">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div class="flex-grow-1">
                                                <h6 class="mb-1">${test.testName}</h6>
                                                <small class="text-muted">${test.categoryName} • ${test.duration} minutes</small>
                                                <c:if test="${not empty test.description}">
                                                    <p class="mb-0 mt-1 small">${test.description}</p>
                                                </c:if>
                                            </div>
                                            <div class="text-right ml-3">
                                                <span class="badge ${test.testType == 'Practice' ? 'badge-practice' : 'badge-official'} mb-2">
                                                    ${test.testType}
                                                </span>
                                                <br>
                                                <c:choose>
                                                    <c:when test="${test.alreadyTaken && test.testType == 'Official'}">
                                                        <span class="badge badge-secondary">Completed</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a href="/student/taketest?action=start&testId=${test.testId}" class="btn btn-sm btn-primary">
                                                            <i class="fas fa-play mr-1"></i>Start
                                                        </a>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>

                                <c:if test="${empty dashboardData.availableTests}">
                                    <div class="empty-state">
                                        <i class="fas fa-clipboard-list fa-3x"></i>
                                        <p>No tests available at the moment.</p>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <!-- Study Progress -->
                    <div class="col-lg-6 mb-3">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="mb-0"><i class="fas fa-chart-bar mr-2"></i>Study Progress</h5>
                            </div>
                            <div class="card-body">
                                <!-- Overall Progress -->
                                <div class="mb-4">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <h6 class="mb-0">Overall Progress</h6>
                                        <span class="text-primary font-weight-bold">${dashboardData.studyProgress.progressPercentage}%</span>
                                    </div>
                                    <div class="progress progress-bar-custom">
                                        <div class="progress-bar bg-primary" role="progressbar" 
                                             style="width: ${dashboardData.studyProgress.progressPercentage}%"></div>
                                    </div>
                                    <small class="text-muted">
                                        ${dashboardData.studyProgress.completedLessons} of ${dashboardData.studyProgress.totalLessons} lessons completed
                                    </small>
                                </div>

                                <!-- Subject Progress -->
                                <h6 class="mb-3">Subject Progress</h6>
                                <div style="max-height: 250px; overflow-y: auto;">
                                    <c:forEach var="subject" items="${dashboardData.studyProgress.subjectProgress}">
                                        <div class="mb-3">
                                            <div class="d-flex justify-content-between align-items-center mb-1">
                                                <span class="font-weight-medium">${subject.subjectName}</span>
                                                <span class="text-primary small">${subject.progressPercentage}%</span>
                                            </div>
                                            <div class="progress progress-bar-custom">
                                                <div class="progress-bar bg-success" role="progressbar" 
                                                     style="width: ${subject.progressPercentage}%"></div>
                                            </div>
                                            <small class="text-muted">
                                                ${subject.completedLessons}/${subject.totalLessons} lessons
                                            </small>
                                        </div>
                                    </c:forEach>

                                    <c:if test="${empty dashboardData.studyProgress.subjectProgress}">
                                        <div class="text-center text-muted py-3">
                                            <p class="mb-0">No subjects available for your grade.</p>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Include footer -->
        <jsp:include page="../footer.jsp" />

        <!-- JavaScript -->
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
            // Wait for DOM to be ready
            $(document).ready(function () {
                console.log('Dashboard loaded, initializing charts...');

                // Chart.js configuration for version 3.x
                Chart.defaults.responsive = true;
                Chart.defaults.maintainAspectRatio = false;
                Chart.defaults.font.family = "'Segoe UI', Tahoma, Geneva, Verdana, sans-serif";

                // Test Performance Over Time Chart
                const testPerformanceData = ${testPerformanceJson};
                console.log('Test Performance Data:', testPerformanceData);

                if (testPerformanceData && testPerformanceData.length > 0) {
                    const ctx1 = document.getElementById('testPerformanceChart');
                    if (ctx1) {
                        new Chart(ctx1, {
                            type: 'line',
                            data: {
                                labels: testPerformanceData.map(item => {
                                    const date = new Date(item.testDate);
                                    return date.toLocaleDateString('en-US', {month: 'short', day: 'numeric'});
                                }).reverse(),
                                datasets: [{
                                        label: 'Score (%)',
                                        data: testPerformanceData.map(item => item.score).reverse(),
                                        borderColor: '#007bff',
                                        backgroundColor: 'rgba(0, 123, 255, 0.1)',
                                        borderWidth: 3,
                                        fill: true,
                                        tension: 0.4,
                                        pointBackgroundColor: '#007bff',
                                        pointBorderColor: '#fff',
                                        pointBorderWidth: 2,
                                        pointRadius: 6
                                    }]
                            },
                            options: {
                                responsive: true,
                                maintainAspectRatio: false,
                                scales: {
                                    y: {
                                        beginAtZero: true,
                                        max: 10,
                                        ticks: {
                                            callback: function (value) {
                                                return value + '/10';
                                            }
                                        }
                                    }
                                },
                                plugins: {
                                    legend: {
                                        display: false
                                    },
                                    tooltip: {
                                        callbacks: {
                                            title: function (context) {
                                                const index = context[0].dataIndex;
                                                const reversedIndex = testPerformanceData.length - 1 - index;
                                                return testPerformanceData[reversedIndex].testName;
                                            },
                                            label: function (context) {
                                                return 'Score: ' + context.parsed.y + '/10';
                                            }
                                        }
                                    }
                                }
                            }
                        });
                    }
                } else {
                    const container = document.getElementById('testPerformanceChart').closest('.chart-container');
                    if (container) {
                        container.innerHTML = '<div class="empty-state"><i class="fas fa-chart-line fa-3x"></i><p>No test performance data available yet.</p></div>';
                    }
                }

                // Test Type Distribution Chart
                const testTypeData = ${testTypeDistributionJson};
                console.log('Test Type Data:', testTypeData);

                if (testTypeData && testTypeData.typeData && testTypeData.typeData.length > 0) {
                    const ctx2 = document.getElementById('testTypeChart');
                    if (ctx2) {
                        new Chart(ctx2, {
                            type: 'doughnut',
                            data: {
                                labels: testTypeData.typeData.map(item => item.testType),
                                datasets: [{
                                        data: testTypeData.typeData.map(item => item.testCount),
                                        backgroundColor: ['#28a745', '#007bff'],
                                        borderWidth: 0
                                    }]
                            },
                            options: {
                                responsive: true,
                                maintainAspectRatio: false,
                                plugins: {
                                    legend: {
                                        position: 'bottom',
                                        labels: {
                                            padding: 20,
                                            usePointStyle: true
                                        }
                                    }
                                }
                            }
                        });
                    }
                } else {
                    const container = document.getElementById('testTypeChart').closest('.chart-container');
                    if (container) {
                        container.innerHTML = '<div class="empty-state"><i class="fas fa-chart-pie fa-3x"></i><p>No test type data available yet.</p></div>';
                    }
                }

                // Subject Performance Chart
                const subjectPerformanceData = ${subjectPerformanceJson};
                console.log('Subject Performance Data:', subjectPerformanceData);

                if (subjectPerformanceData && subjectPerformanceData.length > 0) {
                    const ctx3 = document.getElementById('subjectPerformanceChart');
                    if (ctx3) {
                        new Chart(ctx3, {
                            type: 'bar',
                            data: {
                                labels: subjectPerformanceData.map(item => item.subjectName),
                                datasets: [{
                                        label: 'Average Score (/10)',
                                        data: subjectPerformanceData.map(item => item.avgScore),
                                        backgroundColor: 'rgba(40, 167, 69, 0.8)',
                                        borderColor: '#28a745',
                                        borderWidth: 1
                                    }]
                            },
                            options: {
                                responsive: true,
                                maintainAspectRatio: false,
                                scales: {
                                    y: {
                                        beginAtZero: true,
                                        max: 10,
                                        ticks: {
                                            callback: function (value) {
                                                return value + '/10';
                                            }
                                        }
                                    }
                                },
                                plugins: {
                                    legend: {
                                        display: false
                                    }
                                }
                            }
                        });
                    }
                } else {
                    const container = document.getElementById('subjectPerformanceChart').closest('.chart-container');
                    if (container) {
                        container.innerHTML = '<div class="empty-state"><i class="fas fa-book fa-3x"></i><p>No subject performance data available yet.</p></div>';
                    }
                }

                // Monthly Activity Chart
                const monthlyActivityData = ${monthlyActivityJson};
                console.log('Monthly Activity Data:', monthlyActivityData);

                if (monthlyActivityData && monthlyActivityData.length > 0) {
                    const ctx4 = document.getElementById('monthlyActivityChart');
                    if (ctx4) {
                        new Chart(ctx4, {
                            type: 'bar',
                            data: {
                                labels: monthlyActivityData.map(item => {
                                    const [year, month] = item.month.split('-');
                                    const date = new Date(year, month - 1);
                                    return date.toLocaleDateString('en-US', {month: 'short', year: 'numeric'});
                                }).reverse(),
                                datasets: [{
                                        label: 'Tests Completed',
                                        data: monthlyActivityData.map(item => item.testsCompleted).reverse(),
                                        backgroundColor: 'rgba(23, 162, 184, 0.8)',
                                        borderColor: '#17a2b8',
                                        borderWidth: 1
                                    }]
                            },
                            options: {
                                responsive: true,
                                maintainAspectRatio: false,
                                scales: {
                                    y: {
                                        beginAtZero: true,
                                        ticks: {
                                            stepSize: 1
                                        }
                                    }
                                },
                                plugins: {
                                    legend: {
                                        display: false
                                    }
                                }
                            }
                        });
                    }
                } else {
                    const container = document.getElementById('monthlyActivityChart').closest('.chart-container');
                    if (container) {
                        container.innerHTML = '<div class="empty-state"><i class="fas fa-calendar-alt fa-3x"></i><p>No monthly activity data available yet.</p></div>';
                    }
                }

                console.log('All charts initialized successfully');
            });
        </script>
    </body>
</html>
