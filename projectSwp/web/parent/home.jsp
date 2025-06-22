<%-- 
    Document   : home
    Created on : May 17, 2025, 3:49:02 PM
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
        <title>Parent Dashboard</title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- CSS Libraries -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fontawesome-all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">

        <!-- Chart.js -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

        <style>
            body {
                background-color: #f8f9fa;
                padding-top: 100px;
            }

            .dashboard-header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 2rem 0;
                margin-bottom: 2rem;
                border-radius: 10px;
            }

            .stat-card {
                background: white;
                border-radius: 10px;
                padding: 1.5rem;
                margin-bottom: 1.5rem;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                transition: transform 0.3s ease;
                height: 180px;
                display: flex;
                flex-direction: column;
                justify-content: center;
            }

            .stat-card:hover {
                transform: translateY(-5px);
            }

            .stat-icon {
                font-size: 2.5rem;
                margin-bottom: 1rem;
            }

            .stat-number {
                font-size: 2rem;
                font-weight: bold;
                margin-bottom: 0.5rem;
            }

            .stat-label {
                color: #6c757d;
                font-size: 0.9rem;
            }

            .chart-container {
                background: white;
                border-radius: 10px;
                padding: 1.5rem;
                margin-bottom: 1.5rem;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                position: relative;
            }

            .chart-title {
                font-size: 1.2rem;
                font-weight: 600;
                margin-bottom: 1rem;
                color: #495057;
            }

            /* Fixed height containers for charts */
            .chart-wrapper {
                position: relative;
                height: 300px;
                width: 100%;
            }

            .chart-wrapper-small {
                position: relative;
                height: 250px;
                width: 100%;
            }

            .chart-wrapper-medium {
                position: relative;
                height: 280px;
                width: 100%;
            }

            /* Ensure canvas doesn't exceed container */
            .chart-wrapper canvas,
            .chart-wrapper-small canvas,
            .chart-wrapper-medium canvas {
                max-height: 100% !important;
                max-width: 100% !important;
            }

            .activity-item {
                padding: 1rem;
                border-bottom: 1px solid #dee2e6;
                transition: background-color 0.3s ease;
            }

            .activity-item:hover {
                background-color: #f8f9fa;
            }

            .activity-item:last-child {
                border-bottom: none;
            }

            .quick-action-btn {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                border: none;
                color: white;
                padding: 0.75rem 1.5rem;
                border-radius: 25px;
                margin: 0.25rem;
                transition: all 0.3s ease;
            }

            .quick-action-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 15px rgba(0,0,0,0.2);
                color: white;
            }

            .performance-badge {
                padding: 0.25rem 0.75rem;
                border-radius: 15px;
                font-size: 0.8rem;
                font-weight: 600;
            }

            .performance-excellent {
                background-color: #d4edda;
                color: #155724;
            }

            .performance-good {
                background-color: #d1ecf1;
                color: #0c5460;
            }

            .performance-average {
                background-color: #fff3cd;
                color: #856404;
            }

            .performance-needs-improvement {
                background-color: #f8d7da;
                color: #721c24;
            }

            .invoice-status-paid {
                color: #28a745;
                font-weight: 600;
            }

            .invoice-status-pending {
                color: #ffc107;
                font-weight: 600;
            }

            .invoice-status-overdue {
                color: #dc3545;
                font-weight: 600;
            }

            .chart-row {
                margin-bottom: 1rem;
            }

            .chart-col {
                margin-bottom: 1rem;
            }

            /* Activities container with fixed height and scroll */
            .activities-container {
                max-height: 400px;
                overflow-y: auto;
            }

            /* Side panel containers */
            .side-panel {
                height: 100%;
            }

            .side-panel .chart-container {
                margin-bottom: 1rem;
            }

            /* No data message styling */
            .no-data-message {
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                height: 200px;
                color: #6c757d;
                text-align: center;
            }

            .no-data-message i {
                font-size: 3rem;
                margin-bottom: 1rem;
                opacity: 0.5;
            }

            @media (max-width: 768px) {
                .chart-wrapper,
                .chart-wrapper-small,
                .chart-wrapper-medium {
                    height: 250px;
                }

                .stat-card {
                    height: 150px;
                    margin-bottom: 1rem;
                }

                .stat-icon {
                    font-size: 2rem;
                }

                .stat-number {
                    font-size: 1.5rem;
                }

                .activities-container {
                    max-height: 300px;
                }
            }

            @media (max-width: 576px) {
                .chart-wrapper,
                .chart-wrapper-small,
                .chart-wrapper-medium {
                    height: 200px;
                }

                .quick-action-btn {
                    padding: 0.5rem 1rem;
                    margin: 0.1rem;
                    font-size: 0.9rem;
                }
            }
        </style>
    </head>

    <body>
        <jsp:include page="../header.jsp" />

        <div class="container-fluid">
            <!-- Dashboard Header -->
            <div class="dashboard-header">
                <div class="container">
                    <div class="row align-items-center">
                        <div class="col-md-8">
                            <h1 class="mb-0">Welcome back, ${parent.full_name}!</h1>
                            <p class="mb-0 mt-2">Here's what's happening with your children's learning progress</p>
                        </div>
                        <div class="col-md-4 text-right">
                            <p class="mb-0"><i class="fas fa-calendar-alt"></i> <fmt:formatDate value="<%=new java.util.Date()%>" pattern="EEEE, MMMM dd, yyyy" /></p>
                        </div>
                    </div>
                </div>
            </div>

            <div class="container">
                <!-- Quick Stats Row -->
                <div class="row">
                    <div class="col-lg-3 col-md-6">
                        <div class="stat-card text-center">
                            <div class="stat-icon text-primary">
                                <i class="fas fa-users"></i>
                            </div>
                            <div class="stat-number text-primary">${dashboardData.childrenStats.totalChildren}</div>
                            <div class="stat-label">Total Children</div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <div class="stat-card text-center">
                            <div class="stat-icon text-success">
                                <i class="fas fa-check-circle"></i>
                            </div>
                            <div class="stat-number text-success">${dashboardData.childrenStats.completedTests}</div>
                            <div class="stat-label">Tests Completed</div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <div class="stat-card text-center">
                            <div class="stat-icon text-info">
                                <i class="fas fa-chart-line"></i>
                            </div>
                            <div class="stat-number text-info">${dashboardData.childrenStats.avgScore}%</div>
                            <div class="stat-label">Average Score</div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <div class="stat-card text-center">
                            <div class="stat-icon text-warning">
                                <i class="fas fa-clock"></i>
                            </div>
                            <div class="stat-number text-warning">${dashboardData.childrenStats.testsToday}</div>
                            <div class="stat-label">Tests Today</div>
                        </div>
                    </div>
                </div>

                <!-- Quick Actions -->
                <div class="row">
                    <div class="col-12">
                        <div class="chart-container">
                            <div class="chart-title">
                                <i class="fas fa-bolt"></i> Quick Actions
                            </div>
                            <div class="text-center">
                                <a href="${pageContext.request.contextPath}/parent?action=myChildren" class="btn quick-action-btn">
                                    <i class="fas fa-users"></i> View My Children
                                </a>
                                <a href="${pageContext.request.contextPath}/invoice" class="btn quick-action-btn">
                                    <i class="fas fa-file"></i> View Invoices
                                </a>
                                <a href="${pageContext.request.contextPath}/study_package" class="btn quick-action-btn">
                                    <i class="fas fa-archive"></i> Study Packages
                                </a>
                                <a href="${pageContext.request.contextPath}/Grade" class="btn quick-action-btn">
                                    <i class="fas fa-graduation-cap"></i> Grades & Progress
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Charts Row 1 -->
                <div class="row chart-row">
                    <div class="col-lg-8 chart-col">
                        <div class="chart-container">
                            <div class="chart-title">
                                <i class="fas fa-chart-line"></i> Monthly Progress Overview
                            </div>
                            <div class="chart-wrapper">
                                <canvas id="monthlyProgressChart"></canvas>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-4 chart-col">
                        <div class="chart-container">
                            <div class="chart-title">
                                <i class="fas fa-chart-pie"></i> Grade Distribution
                            </div>
                            <div class="chart-wrapper-small">
                                <canvas id="gradeDistributionChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Charts Row 2 -->
                <div class="row chart-row">
                    <div class="col-lg-6 chart-col">
                        <div class="chart-container">
                            <div class="chart-title">
                                <i class="fas fa-chart-bar"></i> Subject Performance
                            </div>
                            <div class="chart-wrapper-medium">
                                <canvas id="subjectPerformanceChart"></canvas>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-6 chart-col">
                        <div class="chart-container">
                            <div class="chart-title">
                                <i class="fas fa-user"></i> Children Performance Comparison
                            </div>
                            <div class="chart-wrapper-medium">
                                <canvas id="childrenPerformanceChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Recent Activities and Invoice Summary -->
                <div class="row">
                    <div class="col-lg-8">
                        <div class="chart-container">
                            <div class="chart-title">
                                <i class="fas fa-history"></i> Recent Test Activities
                            </div>
                            <div class="activities-container">
                                <c:choose>
                                    <c:when test="${not empty dashboardData.recentActivities}">
                                        <c:forEach var="activity" items="${dashboardData.recentActivities}" varStatus="status">
                                            <c:if test="${status.index < 8}">
                                                <div class="activity-item">
                                                    <div class="row align-items-center">
                                                        <div class="col-md-4">
                                                            <strong>${activity.studentName}</strong>
                                                        </div>
                                                        <div class="col-md-4">
                                                            <span class="text-muted">${activity.testName}</span>
                                                            <span class="badge badge-${activity.testType == 'Practice' ? 'info' : 'primary'} ml-2">
                                                                ${activity.testType}
                                                            </span>
                                                        </div>
                                                        <div class="col-md-2">
                                                            <c:choose>
                                                                <c:when test="${activity.score != null}">
                                                                    <span class="performance-badge
                                                                          <c:choose>
                                                                              <c:when test="${activity.score >= 90}">performance-excellent</c:when>
                                                                              <c:when test="${activity.score >= 75}">performance-good</c:when>
                                                                              <c:when test="${activity.score >= 60}">performance-average</c:when>
                                                                              <c:otherwise>performance-needs-improvement</c:otherwise>
                                                                          </c:choose>">
                                                                        <fmt:formatNumber value="${activity.score}" maxFractionDigits="1"/>%
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">In Progress</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                        <div class="col-md-2 text-right">
                                                            <small class="text-muted">
                                                                <c:choose>
                                                                    <c:when test="${activity.finishAt != null}">
                                                                        <fmt:formatDate value="${activity.finishAt}" pattern="MMM dd, HH:mm"/>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <fmt:formatDate value="${activity.startedAt}" pattern="MMM dd, HH:mm"/>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </small>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="no-data-message">
                                            <i class="fas fa-inbox"></i>
                                            <p>No recent test activities found.</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-4">
                        <div class="side-panel">
                            <!-- Invoice Summary -->
                            <div class="chart-container">
                                <div class="chart-title">
                                    <i class="fas fa-credit-card"></i> Invoice Summary
                                </div>
                                <div class="row text-center mb-3">
                                    <div class="col-6">
                                        <div class="stat-number text-success">${dashboardData.invoiceSummary.paidInvoices}</div>
                                        <div class="stat-label">Paid</div>
                                    </div>
                                    <div class="col-6">
                                        <div class="stat-number text-warning">${dashboardData.invoiceSummary.pendingInvoices}</div>
                                        <div class="stat-label">Pending</div>
                                    </div>
                                </div>
                                <div class="row text-center mb-3">
                                    <div class="col-12">
                                        <div class="stat-number text-primary">$<fmt:formatNumber value="${dashboardData.invoiceSummary.totalPaidAmount}" maxFractionDigits="2"/></div>
                                        <div class="stat-label">Total Paid</div>
                                    </div>
                                </div>

                                <h6 class="mt-4 mb-3">Recent Invoices</h6>
                                <c:choose>
                                    <c:when test="${not empty dashboardData.invoiceSummary.recentInvoices}">
                                        <c:forEach var="invoice" items="${dashboardData.invoiceSummary.recentInvoices}">
                                            <div class="d-flex justify-content-between align-items-center mb-2">
                                                <div>
                                                    <small class="text-muted">#${invoice.id}</small>
                                                </div>
                                                <div>
                                                    <span class="invoice-status-${invoice.status}">${invoice.status}</span>
                                                </div>
                                                <div>
                                                    <small>$${invoice.amount}</small>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center text-muted">
                                            <small>No recent invoices</small>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- Children Performance Summary -->
                            <div class="chart-container">
                                <div class="chart-title">
                                    <i class="fas fa-trophy"></i> Top Performers
                                </div>
                                <c:choose>
                                    <c:when test="${not empty dashboardData.testPerformance}">
                                        <c:forEach var="performance" items="${dashboardData.testPerformance}" varStatus="status">
                                            <c:if test="${status.index < 3}">
                                                <div class="d-flex justify-content-between align-items-center mb-3">
                                                    <div>
                                                        <div class="font-weight-bold">${performance.studentName}</div>
                                                        <small class="text-muted">${performance.gradeName}</small>
                                                    </div>
                                                    <div class="text-right">
                                                        <div class="font-weight-bold text-primary">
                                                            <fmt:formatNumber value="${performance.avgScore}" maxFractionDigits="1"/>%
                                                        </div>
                                                        <small class="text-muted">${performance.completedTests} tests</small>
                                                    </div>
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center text-muted">
                                            <small>No performance data available</small>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="../footer.jsp" />

        <!-- Scripts -->
        <script src="${pageContext.request.contextPath}/assets/js/vendor/jquery-1.12.4.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>

        <script>
            // Chart.js configuration with fixed aspect ratio
            const baseChartOptions = {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: true,
                        position: 'top'
                    }
                }
            };

            // Function to create empty chart message
            function createEmptyChart(canvasId, message = 'No data available') {
                const canvas = document.getElementById(canvasId);
                if (canvas) {
                    const ctx = canvas.getContext('2d');
                    const container = canvas.parentElement;

                    // Clear canvas
                    ctx.clearRect(0, 0, canvas.width, canvas.height);

                    // Set canvas size to container size
                    canvas.width = container.offsetWidth;
                    canvas.height = container.offsetHeight;

                    // Draw message
                    ctx.font = '16px Arial';
                    ctx.fillStyle = '#6c757d';
                    ctx.textAlign = 'center';
                    ctx.textBaseline = 'middle';
                    ctx.fillText(message, canvas.width / 2, canvas.height / 2);
            }
            }

            // Monthly Progress Chart
            const monthlyProgressData = ${monthlyProgressJson};
            if (monthlyProgressData && monthlyProgressData.length > 0) {
                const ctx1 = document.getElementById('monthlyProgressChart').getContext('2d');
                new Chart(ctx1, {
                    type: 'line',
                    data: {
                        labels: monthlyProgressData.map(item => item.month || 'N/A'),
                        datasets: [{
                                label: 'Tests Completed',
                                data: monthlyProgressData.map(item => item.testsCompleted || 0),
                                borderColor: 'rgb(75, 192, 192)',
                                backgroundColor: 'rgba(75, 192, 192, 0.2)',
                                tension: 0.4,
                                yAxisID: 'y'
                            }, {
                                label: 'Average Score (%)',
                                data: monthlyProgressData.map(item => item.avgScore || 0),
                                borderColor: 'rgb(255, 99, 132)',
                                backgroundColor: 'rgba(255, 99, 132, 0.2)',
                                tension: 0.4,
                                yAxisID: 'y1'
                            }]
                    },
                    options: {
                        ...baseChartOptions,
                        scales: {
                            y: {
                                type: 'linear',
                                display: true,
                                position: 'left',
                                title: {
                                    display: true,
                                    text: 'Tests Completed'
                                }
                            },
                            y1: {
                                type: 'linear',
                                display: true,
                                position: 'right',
                                title: {
                                    display: true,
                                    text: 'Average Score (%)'
                                },
                                grid: {
                                    drawOnChartArea: false,
                                },
                            }
                        }
                    }
                });
            } else {
                createEmptyChart('monthlyProgressChart', 'No monthly progress data');
            }

            // Subject Performance Chart
            const subjectPerformanceData = ${subjectPerformanceJson};
            if (subjectPerformanceData && subjectPerformanceData.length > 0) {
                const ctx2 = document.getElementById('subjectPerformanceChart').getContext('2d');
                new Chart(ctx2, {
                    type: 'bar',
                    data: {
                        labels: subjectPerformanceData.map(item => item.subjectName || 'Unknown'),
                        datasets: [{
                                label: 'Average Score (%)',
                                data: subjectPerformanceData.map(item => item.avgScore || 0),
                                backgroundColor: [
                                    'rgba(255, 99, 132, 0.8)',
                                    'rgba(54, 162, 235, 0.8)',
                                    'rgba(255, 205, 86, 0.8)',
                                    'rgba(75, 192, 192, 0.8)',
                                    'rgba(153, 102, 255, 0.8)',
                                    'rgba(255, 159, 64, 0.8)'
                                ],
                                borderColor: [
                                    'rgba(255, 99, 132, 1)',
                                    'rgba(54, 162, 235, 1)',
                                    'rgba(255, 205, 86, 1)',
                                    'rgba(75, 192, 192, 1)',
                                    'rgba(153, 102, 255, 1)',
                                    'rgba(255, 159, 64, 1)'
                                ],
                                borderWidth: 1
                            }]
                    },
                    options: {
                        ...baseChartOptions,
                        scales: {
                            y: {
                                beginAtZero: true,
                                max: 100,
                                title: {
                                    display: true,
                                    text: 'Score (%)'
                                }
                            }
                        }
                    }
                });
            } else {
                createEmptyChart('subjectPerformanceChart', 'No subject performance data');
            }

            // Grade Distribution Chart
            const gradeDistributionData = ${gradeDistributionJson};
            if (gradeDistributionData && gradeDistributionData.gradeData && gradeDistributionData.gradeData.length > 0) {
                const ctx3 = document.getElementById('gradeDistributionChart').getContext('2d');
                new Chart(ctx3, {
                    type: 'doughnut',
                    data: {
                        labels: gradeDistributionData.gradeData.map(item => item.gradeName || 'Unknown'),
                        datasets: [{
                                data: gradeDistributionData.gradeData.map(item => item.studentCount || 0),
                                backgroundColor: [
                                    'rgba(255, 99, 132, 0.8)',
                                    'rgba(54, 162, 235, 0.8)',
                                    'rgba(255, 205, 86, 0.8)',
                                    'rgba(75, 192, 192, 0.8)',
                                    'rgba(153, 102, 255, 0.8)'
                                ],
                                borderColor: [
                                    'rgba(255, 99, 132, 1)',
                                    'rgba(54, 162, 235, 1)',
                                    'rgba(255, 205, 86, 1)',
                                    'rgba(75, 192, 192, 1)',
                                    'rgba(153, 102, 255, 1)'
                                ],
                                borderWidth: 2
                            }]
                    },
                    options: {
                        ...baseChartOptions,
                        plugins: {
                            legend: {
                                position: 'bottom'
                            }
                        }
                    }
                });
            } else {
                createEmptyChart('gradeDistributionChart', 'No grade distribution data');
            }

            // Children Performance Comparison Chart
            const testPerformanceData = ${testPerformanceJson};
            if (testPerformanceData && testPerformanceData.length > 0) {
                const ctx4 = document.getElementById('childrenPerformanceChart').getContext('2d');
                new Chart(ctx4, {
                    type: 'radar',
                    data: {
                        labels: ['Average Score', 'Tests Completed', 'Best Score', 'Completion Rate'],
                        datasets: testPerformanceData.slice(0, 3).map((student, index) => {
                            const colors = [
                                'rgba(255, 99, 132, 0.6)',
                                'rgba(54, 162, 235, 0.6)',
                                'rgba(255, 205, 86, 0.6)'
                            ];
                            const completionRate = student.totalTests > 0 ? (student.completedTests / student.totalTests) * 100 : 0;
                            return {
                                label: student.studentName || 'Unknown',
                                data: [
                                    student.avgScore || 0,
                                    Math.min((student.completedTests || 0) * 10, 100), // Scale for visualization
                                    student.bestScore || 0,
                                    completionRate
                                ],
                                backgroundColor: colors[index],
                                borderColor: colors[index].replace('0.6', '1'),
                                borderWidth: 2
                            };
                        })
                    },
                    options: {
                        ...baseChartOptions,
                        scales: {
                            r: {
                                beginAtZero: true,
                                max: 100,
                                ticks: {
                                    stepSize: 20
                                }
                            }
                        }
                    }
                });
            } else {
                createEmptyChart('childrenPerformanceChart', 'No performance comparison data');
            }

            // Resize charts when window is resized
            window.addEventListener('resize', function () {
                // Chart.js automatically handles resize when responsive: true
                // But we can force update if needed
                Chart.helpers.each(Chart.instances, function (instance) {
                    instance.resize();
                });
            });

            // Initialize tooltips if using Bootstrap tooltips
            $(function () {
                $('[data-toggle="tooltip"]').tooltip();
            });
        </script>
    </body>
</html>
