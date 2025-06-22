<%-- 
    Document   : home
    Created on : May 21, 2025, 9:01:09 PM
    Author     : BuiNgocLinh
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html class="no-js" lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Admin Dashboard | Education Platform</title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="manifest" href="site.webmanifest">
        <link rel="shortcut icon" type="image/x-icon" href="/assets/img/favicon.ico">

        <!-- CSS -->
        <link rel="stylesheet" href="/assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="/assets/css/owl.carousel.min.css">
        <link rel="stylesheet" href="/assets/css/slicknav.css">
        <link rel="stylesheet" href="/assets/css/flaticon.css">
        <link rel="stylesheet" href="/assets/css/progressbar_barfiller.css">
        <link rel="stylesheet" href="/assets/css/gijgo.css">
        <link rel="stylesheet" href="/assets/css/animate.min.css">
        <link rel="stylesheet" href="/assets/css/animated-headline.css">
        <link rel="stylesheet" href="/assets/css/magnific-popup.css">
        <link rel="stylesheet" href="/assets/css/fontawesome-all.min.css">
        <link rel="stylesheet" href="/assets/css/themify-icons.css">
        <link rel="stylesheet" href="/assets/css/slick.css">
        <link rel="stylesheet" href="/assets/css/nice-select.css">
        <link rel="stylesheet" href="/assets/css/style.css">

        <!-- Chart.js -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

        <style>
            body {
                background-color: #f8f9fa;
                padding-top: 100px;
            }

            .dashboard-container {
                padding: 20px;
                max-width: 1400px;
                margin: 0 auto;
            }

            .dashboard-header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 30px;
                border-radius: 15px;
                margin-bottom: 30px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            }

            .dashboard-header h1 {
                margin: 0;
                font-size: 2.5rem;
                font-weight: 700;
            }

            .dashboard-header p {
                margin: 10px 0 0 0;
                opacity: 0.9;
                font-size: 1.1rem;
            }

            .stats-card {
                background: white;
                border-radius: 15px;
                padding: 25px;
                margin-bottom: 20px;
                box-shadow: 0 5px 20px rgba(0,0,0,0.08);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                border-left: 4px solid;
                height: 120px;
                display: flex;
                flex-direction: column;
                justify-content: center;
            }

            .stats-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 15px 40px rgba(0,0,0,0.15);
            }

            .stats-card.primary {
                border-left-color: #007bff;
            }
            .stats-card.success {
                border-left-color: #28a745;
            }
            .stats-card.warning {
                border-left-color: #ffc107;
            }
            .stats-card.info {
                border-left-color: #17a2b8;
            }
            .stats-card.danger {
                border-left-color: #dc3545;
            }
            .stats-card.purple {
                border-left-color: #6f42c1;
            }
            .stats-card.orange {
                border-left-color: #fd7e14;
            }
            .stats-card.teal {
                border-left-color: #20c997;
            }

            .stats-number {
                font-size: 2.5rem;
                font-weight: 700;
                margin-bottom: 5px;
                line-height: 1;
            }

            .stats-label {
                color: #6c757d;
                font-size: 0.9rem;
                text-transform: uppercase;
                letter-spacing: 1px;
                font-weight: 600;
                margin: 0;
            }

            .stats-icon {
                font-size: 3rem;
                opacity: 0.1;
                position: absolute;
                right: 20px;
                top: 20px;
            }

            .chart-container {
                background: white;
                border-radius: 15px;
                padding: 25px;
                margin-bottom: 20px;
                box-shadow: 0 5px 20px rgba(0,0,0,0.08);
                position: relative;
            }

            .chart-container.small {
                height: 400px;
            }

            .chart-container.medium {
                height: 450px;
            }

            .chart-container.large {
                height: 500px;
            }

            .chart-title {
                font-size: 1.3rem;
                font-weight: 600;
                margin-bottom: 20px;
                color: #495057;
            }

            .chart-wrapper {
                position: relative;
                height: 300px;
                width: 100%;
            }

            .chart-wrapper canvas {
                position: absolute;
                top: 0;
                left: 0;
                width: 100% !important;
                height: 100% !important;
            }

            .activity-container {
                max-height: 400px;
                overflow-y: auto;
            }

            .activity-item {
                padding: 15px;
                border-bottom: 1px solid #e9ecef;
                display: flex;
                align-items: center;
                justify-content: space-between;
                transition: background-color 0.2s ease;
            }

            .activity-item:hover {
                background-color: #f8f9fa;
            }

            .activity-item:last-child {
                border-bottom: none;
            }

            .activity-info h6 {
                margin: 0;
                font-weight: 600;
                color: #495057;
                font-size: 0.95rem;
            }

            .activity-info small {
                color: #6c757d;
                font-size: 0.8rem;
            }

            .activity-score {
                background: #e7f3ff;
                color: #0066cc;
                padding: 5px 12px;
                border-radius: 20px;
                font-weight: 600;
                font-size: 0.85rem;
                min-width: 60px;
                text-align: center;
            }

            .metric-card {
                margin-bottom: 15px;
            }

            .metric-value {
                font-size: 2rem;
                font-weight: 700;
                line-height: 1;
                margin-bottom: 5px;
            }

            .metric-label {
                color: #6c757d;
                font-size: 0.9rem;
                margin-top: 5px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                font-weight: 600;
            }

            .progress-custom {
                height: 8px;
                border-radius: 10px;
                background-color: #e9ecef;
                margin-top: 10px;
                overflow: hidden;
            }

            .progress-custom .progress-bar {
                border-radius: 10px;
                transition: width 0.6s ease;
            }

            .error-message {
                background: #f8d7da;
                color: #721c24;
                padding: 15px;
                border-radius: 10px;
                border: 1px solid #f5c6cb;
                margin-bottom: 20px;
            }

            .package-sales-item {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 8px 0;
                border-bottom: 1px solid #e9ecef;
            }

            .package-sales-item:last-child {
                border-bottom: none;
            }

            .package-sales-item small {
                font-size: 0.85rem;
                color: #6c757d;
            }

            .package-sales-item small.text-success {
                font-weight: 600;
            }

            .badge {
                font-size: 0.75rem;
                padding: 4px 8px;
            }

            .quick-action-btn {
                height: 80px;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                text-decoration: none;
                border-radius: 10px;
                transition: all 0.3s ease;
                font-size: 0.85rem;
                font-weight: 600;
                border: none;
                width: 100%;
            }

            .quick-action-btn:hover {
                transform: translateY(-2px);
                text-decoration: none;
                color: white;
                box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            }

            .quick-action-btn i {
                font-size: 1.5rem;
                margin-bottom: 5px;
            }

            /* Package statistics specific styles */
            .package-stats-container {
                display: flex;
                flex-direction: column;
                height: 100%;
            }

            .package-stats-metrics {
                flex-shrink: 0;
            }

            .package-stats-list {
                flex: 1;
                min-height: 0;
            }

            .package-stats-scrollable {
                max-height: 200px;
                overflow-y: auto;
                border: 1px solid #e9ecef;
                border-radius: 8px;
                padding: 10px;
                background-color: #f8f9fa;
            }

            /* Responsive adjustments */
            @media (max-width: 768px) {
                .dashboard-container {
                    padding: 10px;
                }

                .dashboard-header {
                    padding: 20px;
                }

                .dashboard-header h1 {
                    font-size: 2rem;
                }

                .stats-card {
                    padding: 20px;
                    height: 100px;
                }

                .stats-number {
                    font-size: 2rem;
                }

                .chart-wrapper {
                    height: 250px;
                }

                .chart-container.small,
                .chart-container.medium,
                .chart-container.large {
                    height: auto;
                    min-height: 300px;
                }

                .quick-action-btn {
                    height: 70px;
                    font-size: 0.8rem;
                }

                .quick-action-btn i {
                    font-size: 1.2rem;
                }

                .metric-value {
                    font-size: 1.5rem;
                }
            }

            @media (max-width: 576px) {
                .stats-card {
                    height: 90px;
                }

                .stats-number {
                    font-size: 1.8rem;
                }

                .stats-label {
                    font-size: 0.8rem;
                }

                .chart-wrapper {
                    height: 200px;
                }
            }
        </style>
    </head>

    <body>
        <%@include file="../header.jsp" %>

        <div class="dashboard-container">
            <!-- Dashboard Header -->
            <div class="dashboard-header">
                <h1><i class="fas fa-tachometer-alt"></i> Admin Dashboard</h1>
                <p>Welcome back! Here's what's happening with your education platform today.</p>
            </div>

            <!-- Error Message -->
            <c:if test="${not empty error}">
                <div class="error-message">
                    <i class="fas fa-exclamation-triangle"></i> ${error}
                </div>
            </c:if>

            <!-- Statistics Cards -->
            <div class="row">
                <div class="col-xl-3 col-lg-6 col-md-6 col-sm-6">
                    <div class="stats-card primary position-relative">
                        <div class="stats-number text-primary">${totalCounts.accounts}</div>
                        <div class="stats-label">Total Accounts</div>
                        <i class="fas fa-users stats-icon text-primary"></i>
                    </div>
                </div>
                <div class="col-xl-3 col-lg-6 col-md-6 col-sm-6">
                    <div class="stats-card success position-relative">
                        <div class="stats-number text-success">${totalCounts.students}</div>
                        <div class="stats-label">Active Students</div>
                        <i class="fas fa-user stats-icon text-success"></i>
                    </div>
                </div>
                <div class="col-xl-3 col-lg-6 col-md-6 col-sm-6">
                    <div class="stats-card warning position-relative">
                        <div class="stats-number text-warning">${totalCounts.tests}</div>
                        <div class="stats-label">Total Tests</div>
                        <i class="fas fa-clipboard stats-icon text-warning"></i>
                    </div>
                </div>
                <div class="col-xl-3 col-lg-6 col-md-6 col-sm-6">
                    <div class="stats-card info position-relative">
                        <div class="stats-number text-info">${totalCounts.questions}</div>
                        <div class="stats-label">Questions Bank</div>
                        <i class="fas fa-question-circle stats-icon text-info"></i>
                    </div>
                </div>
            </div>

            <!-- Secondary Stats -->
            <div class="row">
                <div class="col-xl-3 col-lg-6 col-md-6 col-sm-6">
                    <div class="stats-card purple position-relative">
                        <div class="stats-number text-purple">${totalCounts.lessons}</div>
                        <div class="stats-label">Total Lessons</div>
                        <i class="fas fa-book stats-icon" style="color: #6f42c1;"></i>
                    </div>
                </div>
                <div class="col-xl-3 col-lg-6 col-md-6 col-sm-6">
                    <div class="stats-card orange position-relative">
                        <div class="stats-number text-orange">${totalCounts.subjects}</div>
                        <div class="stats-label">Subjects</div>
                        <i class="fas fa-graduation-cap stats-icon" style="color: #fd7e14;"></i>
                    </div>
                </div>
                <div class="col-xl-3 col-lg-6 col-md-6 col-sm-6">
                    <div class="stats-card teal position-relative">
                        <div class="stats-number text-teal">${totalCounts.grades}</div>
                        <div class="stats-label">Grade Levels</div>
                        <i class="fas fa-th stats-icon" style="color: #20c997;"></i>
                    </div>
                </div>
                <div class="col-xl-3 col-lg-6 col-md-6 col-sm-6">
                    <div class="stats-card danger position-relative">
                        <div class="stats-number text-danger">${totalCounts.packages}</div>
                        <div class="stats-label">Study Packages</div>
                        <i class="fas fa-archive stats-icon text-danger"></i>
                    </div>
                </div>
            </div>

            <!-- Charts Row -->
            <div class="row">
                <!-- User Distribution Chart -->
                <div class="col-xl-6 col-lg-6">
                    <div class="chart-container small">
                        <h5 class="chart-title"><i class="fas fa-chart-pie"></i> User Distribution by Role</h5>
                        <div class="chart-wrapper">
                            <canvas id="userRoleChart"></canvas>
                        </div>
                    </div>
                </div>

                <!-- Test Completion Trend -->
                <div class="col-xl-6 col-lg-6">
                    <div class="chart-container small">
                        <h5 class="chart-title"><i class="fas fa-chart-line"></i> Monthly Test Completions</h5>
                        <div class="chart-wrapper">
                            <canvas id="monthlyCompletionChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Grade Distribution & Test Statistics -->
            <div class="row">
                <div class="col-xl-6 col-lg-6">
                    <div class="chart-container small">
                        <h5 class="chart-title"><i class="fas fa-chart-bar"></i> Students by Grade</h5>
                        <div class="chart-wrapper">
                            <canvas id="gradeDistributionChart"></canvas>
                        </div>
                    </div>
                </div>

                <div class="col-xl-6 col-lg-6">
                    <div class="chart-container small">
                        <h5 class="chart-title"><i class="fas fa-chart-doughnut"></i> Test Types Distribution</h5>
                        <div class="chart-wrapper">
                            <canvas id="testTypesChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recent Activities & Package Statistics -->
            <div class="row">
                <!-- Recent Test Activities -->
                <div class="col-xl-8 col-lg-8">
                    <div class="chart-container medium">
                        <h5 class="chart-title"><i class="fas fa-clock"></i> Recent Test Activities</h5>
                        <div class="activity-container">
                            <c:choose>
                                <c:when test="${not empty recentActivities}">
                                    <c:forEach var="activity" items="${recentActivities}">
                                        <div class="activity-item">
                                            <div class="activity-info">
                                                <h6>${activity.studentName}</h6>
                                                <small class="text-muted">
                                                    Completed: ${activity.testName}
                                                    <br>
                                                    <fmt:formatDate value="${activity.finishAt}" pattern="MMM dd, yyyy HH:mm" />
                                                </small>
                                            </div>
                                            <div class="activity-score">
                                                <fmt:formatNumber value="${activity.score}" pattern="#.##" />/10
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center text-muted py-4">
                                        <i class="fas fa-inbox fa-3x mb-3"></i>
                                        <p>No recent test activities found.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <!-- Package Statistics -->
                <div class="col-xl-4 col-lg-4">
                    <div class="chart-container medium">
                        <h5 class="chart-title"><i class="fas fa-shopping-cart"></i> Package Statistics</h5>

                        <div class="package-stats-container">
                            <!-- Revenue Metrics -->
                            <div class="package-stats-metrics">
                                <!-- Total Revenue -->
                                <div class="metric-card">
                                    <div class="metric-value text-success">
                                        $<fmt:formatNumber value="${packageStats.totalRevenue}" pattern="#,##0.00" />
                                    </div>
                                    <div class="metric-label">Total Revenue</div>
                                </div>

                                <!-- Additional Metrics Row -->
                                <div class="row mb-3">
                                    <div class="col-6">
                                        <div class="text-center">
                                            <div class="metric-value text-info" style="font-size: 1.5rem;">
                                                ${packageStats.totalPaidInvoices}
                                            </div>
                                            <div class="metric-label" style="font-size: 0.8rem;">Paid Orders</div>
                                        </div>
                                    </div>
                                    <div class="col-6">
                                        <div class="text-center">
                                            <div class="metric-value text-warning" style="font-size: 1.5rem;">
                                                $<fmt:formatNumber value="${packageStats.averageOrderValue}" pattern="#,##0.00" />
                                            </div>
                                            <div class="metric-label" style="font-size: 0.8rem;">Avg Order</div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Additional Statistics -->
                                <div class="row mb-3">
                                    <div class="col-6">
                                        <div class="text-center">
                                            <div class="metric-value text-secondary" style="font-size: 1.2rem;">
                                                ${packageStats.totalPendingInvoices}
                                            </div>
                                            <div class="metric-label" style="font-size: 0.8rem;">Pending</div>
                                        </div>
                                    </div>
                                    <div class="col-6">
                                        <div class="text-center">
                                            <div class="metric-value text-primary" style="font-size: 1.2rem;">
                                                ${packageStats.totalInvoices}
                                            </div>
                                            <div class="metric-label" style="font-size: 0.8rem;">Total Orders</div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Package Sales List -->
                            <div class="package-stats-list">
                                <h6 class="mb-3"><i class="fas fa-list"></i> Package Sales</h6>
                                <div class="package-stats-scrollable">
                                    <c:choose>
                                        <c:when test="${not empty packageStats.packageSales}">
                                            <c:forEach var="packageSale" items="${packageStats.packageSales}">
                                                <div class="package-sales-item">
                                                    <div>
                                                        <small class="text-muted">${packageSale.packageName}</small>
                                                        <c:if test="${packageSale.packageRevenue > 0}">
                                                            <br>
                                                            <small class="text-success">
                                                                $<fmt:formatNumber value="${packageSale.packageRevenue}" pattern="#,##0.00" />
                                                            </small>
                                                        </c:if>
                                                    </div>
                                                    <span class="badge badge-primary">${packageSale.salesCount} sales</span>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="text-center text-muted py-3">
                                                <i class="fas fa-inbox fa-2x mb-2"></i>
                                                <p class="mb-0">No package sales data</p>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Quick Actions Section - Separate Row -->
            <div class="row">
                <div class="col-12">
                    <div class="chart-container">
                        <h5 class="chart-title"><i class="fas fa-bolt"></i> Quick Actions</h5>
                        <div class="row">
                            <div class="col-xl-2 col-lg-3 col-md-4 col-sm-6 mb-3">
                                <a href="/admin?action=createAccount" class="btn btn-primary quick-action-btn">
                                    <i class="fas fa-user-plus"></i>
                                    <span>Add Account</span>
                                </a>
                            </div>
                            <div class="col-xl-2 col-lg-3 col-md-4 col-sm-6 mb-3">
                                <a href="/test?action=create" class="btn btn-success quick-action-btn">
                                    <i class="fas fa-plus-circle"></i>
                                    <span>Create Test</span>
                                </a>
                            </div>
                            <div class="col-xl-2 col-lg-3 col-md-4 col-sm-6 mb-3">
                                <a href="/Question?action=addForm" class="btn btn-warning quick-action-btn">
                                    <i class="fas fa-question"></i>
                                    <span>Add Question</span>
                                </a>
                            </div>
                            <div class="col-xl-2 col-lg-3 col-md-4 col-sm-6 mb-3">
                                <a href="/LessonURL?action=addForm" class="btn btn-info quick-action-btn">
                                    <i class="fas fa-book"></i>
                                    <span>Add Lesson</span>
                                </a>
                            </div>
                            <div class="col-xl-2 col-lg-3 col-md-4 col-sm-6 mb-3">
                                <a href="/study_package?service=add" class="quick-action-btn" style="background-color: #6f42c1; border-color: #6f42c1; color: white;">
                                    <i class="fas fa-archive"></i>
                                    <span>Add Package</span>
                                </a>
                            </div>
                            <div class="col-xl-2 col-lg-3 col-md-4 col-sm-6 mb-3">
                                <a href="/category?action=addForm" class="btn btn-dark quick-action-btn">
                                    <i class="fas fa-tags"></i>
                                    <span>Add Category</span>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%@include file="../footer.jsp" %>

        <!-- Chart Scripts -->
        <script>
            // Chart.js default configuration
            Chart.defaults.font.family = 'Arial, sans-serif';
            Chart.defaults.color = '#495057';

            // Color palette
            const colors = {
                primary: '#007bff',
                success: '#28a745',
                warning: '#ffc107',
                danger: '#dc3545',
                info: '#17a2b8',
                purple: '#6f42c1',
                orange: '#fd7e14',
                teal: '#20c997'
            };

            // User Role Distribution Chart
            const userRoleData = ${usersByRoleJson};
            if (userRoleData && Object.keys(userRoleData).length > 0) {
                const ctx1 = document.getElementById('userRoleChart').getContext('2d');
                new Chart(ctx1, {
                    type: 'doughnut',
                    data: {
                        labels: Object.keys(userRoleData),
                        datasets: [{
                                data: Object.values(userRoleData),
                                backgroundColor: [
                                    colors.primary,
                                    colors.success,
                                    colors.warning,
                                    colors.danger,
                                    colors.info
                                ],
                                borderWidth: 0,
                                hoverOffset: 10
                            }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                position: 'bottom',
                                labels: {
                                    padding: 15,
                                    usePointStyle: true,
                                    font: {
                                        size: 12
                                    }
                                }
                            },
                            tooltip: {
                                callbacks: {
                                    label: function (context) {
                                        const total = context.dataset.data.reduce((a, b) => a + b, 0);
                                        const percentage = ((context.parsed / total) * 100).toFixed(1);
                                        return context.label + ': ' + context.parsed + ' (' + percentage + '%)';
                                    }
                                }
                            }
                        }
                    }
                });
            }

            // Monthly Completion Trend Chart
            const monthlyData = ${monthlyCompletionsJson};
            if (monthlyData && monthlyData.length > 0) {
                const ctx2 = document.getElementById('monthlyCompletionChart').getContext('2d');
                new Chart(ctx2, {
                    type: 'line',
                    data: {
                        labels: monthlyData.map(item => {
                            const date = new Date(item.month + '-01');
                            return date.toLocaleDateString('en-US', {month: 'short', year: 'numeric'});
                        }),
                        datasets: [{
                                label: 'Test Completions',
                                data: monthlyData.map(item => item.completions),
                                borderColor: colors.primary,
                                backgroundColor: colors.primary + '20',
                                borderWidth: 3,
                                fill: true,
                                tension: 0.4,
                                pointBackgroundColor: colors.primary,
                                pointBorderColor: '#fff',
                                pointBorderWidth: 2,
                                pointRadius: 5,
                                pointHoverRadius: 7
                            }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {
                            y: {
                                beginAtZero: true,
                                grid: {
                                    color: '#e9ecef'
                                },
                                ticks: {
                                    font: {
                                        size: 11
                                    }
                                }
                            },
                            x: {
                                grid: {
                                    display: false
                                },
                                ticks: {
                                    font: {
                                        size: 11
                                    }
                                }
                            }
                        },
                        plugins: {
                            legend: {
                                display: false
                            },
                            tooltip: {
                                mode: 'index',
                                intersect: false,
                                backgroundColor: 'rgba(0,0,0,0.8)',
                                titleColor: '#fff',
                                bodyColor: '#fff',
                                borderColor: colors.primary,
                                borderWidth: 1
                            }
                        },
                        interaction: {
                            mode: 'nearest',
                            axis: 'x',
                            intersect: false
                        }
                    }
                });
            }

            // Grade Distribution Chart
            const gradeData = ${gradeDistributionJson};
            if (gradeData && gradeData.length > 0) {
                const ctx3 = document.getElementById('gradeDistributionChart').getContext('2d');
                new Chart(ctx3, {
                    type: 'bar',
                    data: {
                        labels: gradeData.map(item => item.gradeName),
                        datasets: [{
                                label: 'Number of Students',
                                data: gradeData.map(item => item.totalStudents),
                                backgroundColor: colors.success + '80',
                                borderColor: colors.success,
                                borderWidth: 2,
                                borderRadius: 6,
                                borderSkipped: false
                            }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {
                            y: {
                                beginAtZero: true,
                                grid: {
                                    color: '#e9ecef'
                                },
                                ticks: {
                                    font: {
                                        size: 11
                                    },
                                    stepSize: 1
                                }
                            },
                            x: {
                                grid: {
                                    display: false
                                },
                                ticks: {
                                    font: {
                                        size: 11
                                    }
                                }
                            }
                        },
                        plugins: {
                            legend: {
                                display: false
                            },
                            tooltip: {
                                backgroundColor: 'rgba(0,0,0,0.8)',
                                titleColor: '#fff',
                                bodyColor: '#fff',
                                borderColor: colors.success,
                                borderWidth: 1,
                                callbacks: {
                                    afterBody: function (context) {
                                        const dataIndex = context[0].dataIndex;
                                        const avgScore = gradeData[dataIndex].avgScore;
                                        return avgScore > 0 ? 'Average Score: ' + avgScore + '/10' : '';
                                    }
                                }
                            }
                        }
                    }
                });
            }

            // Test Types Chart
            const testStats = ${testStatisticsJson};
            if (testStats && testStats.testsByType) {
                const testTypesData = testStats.testsByType;
                const ctx4 = document.getElementById('testTypesChart').getContext('2d');
                new Chart(ctx4, {
                    type: 'doughnut',
                    data: {
                        labels: Object.keys(testTypesData),
                        datasets: [{
                                data: Object.values(testTypesData),
                                backgroundColor: [
                                    colors.warning,
                                    colors.info
                                ],
                                borderWidth: 0,
                                hoverOffset: 10
                            }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                position: 'bottom',
                                labels: {
                                    padding: 15,
                                    usePointStyle: true,
                                    font: {
                                        size: 12
                                    }
                                }
                            },
                            tooltip: {
                                callbacks: {
                                    label: function (context) {
                                        const total = context.dataset.data.reduce((a, b) => a + b, 0);
                                        const percentage = ((context.parsed / total) * 100).toFixed(1);
                                        return context.label + ': ' + context.parsed + ' (' + percentage + '%)';
                                    }
                                }
                            }
                        }
                    }
                });
            }

            // Auto-refresh dashboard every 5 minutes
            setTimeout(function () {
                window.location.reload();
            }, 300000);

            // Add smooth loading animation
            document.addEventListener('DOMContentLoaded', function () {
                const chartContainers = document.querySelectorAll('.chart-container');
                chartContainers.forEach((container, index) => {
                    container.style.opacity = '0';
                    container.style.transform = 'translateY(20px)';
                    container.style.transition = 'all 0.5s ease-in-out';
                    setTimeout(() => {
                        container.style.opacity = '1';
                        container.style.transform = 'translateY(0)';
                    }, index * 100);
                });
            });
        </script>

        <!-- JS -->
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

    </body>
</html>