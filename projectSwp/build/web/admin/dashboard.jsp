<%-- 
    Document   : dashboard
    Created on : Jun 22, 2025, 12:22:10 AM
    Author     : ankha
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Admin Dashboard</title>
    
    <!-- CSS -->
    <link rel="stylesheet" href="/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="/assets/css/fontawesome-all.min.css">
    <link rel="stylesheet" href="/assets/css/style.css">
    
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
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
            margin-bottom: 1.5rem;
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
            color: white;
            margin-bottom: 1rem;
        }
        
        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            color: #333;
        }
        
        .stat-label {
            color: #666;
            font-size: 0.9rem;
        }
        
        .chart-container {
            background: white;
            border-radius: 10px;
            padding: 1.5rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
        }
        
        .recent-activity {
            background: white;
            border-radius: 10px;
            padding: 1.5rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            max-height: 400px;
            overflow-y: auto;
        }
        
        .activity-item {
            padding: 0.75rem 0;
            border-bottom: 1px solid #eee;
        }
        
        .activity-item:last-child {
            border-bottom: none;
        }
        
        .bg-primary-gradient { background: linear-gradient(45deg, #007bff, #0056b3); }
        .bg-success-gradient { background: linear-gradient(45deg, #28a745, #1e7e34); }
        .bg-warning-gradient { background: linear-gradient(45deg, #ffc107, #d39e00); }
        .bg-info-gradient { background: linear-gradient(45deg, #17a2b8, #117a8b); }
        .bg-danger-gradient { background: linear-gradient(45deg, #dc3545, #bd2130); }
        .bg-purple-gradient { background: linear-gradient(45deg, #6f42c1, #59359a); }
        .bg-orange-gradient { background: linear-gradient(45deg, #fd7e14, #e55a00); }
        .bg-teal-gradient { background: linear-gradient(45deg, #20c997, #1aa179); }
    </style>
</head>
<body>
    <%@include file="../header.jsp" %>
    
    <div class="container-fluid">
        <!-- Dashboard Header -->
        <div class="dashboard-header text-center">
            <h1><i class="fas fa-tachometer-alt"></i> Admin Dashboard</h1>
            <p class="mb-0">Welcome back! Here's what's happening with your platform today.</p>
        </div>
        
        <!-- Statistics Cards -->
        <div class="row">
            <div class="col-xl-3 col-md-6">
                <div class="stat-card">
                    <div class="stat-icon bg-primary-gradient">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="stat-number">${dashboardData.totalUsers}</div>
                    <div class="stat-label">Total Users</div>
                </div>
            </div>
            
            <div class="col-xl-3 col-md-6">
                <div class="stat-card">
                    <div class="stat-icon bg-success-gradient">
                        <i class="fas fa-user"></i>
                    </div>
                    <div class="stat-number">${dashboardData.totalStudents}</div>
                    <div class="stat-label">Students</div>
                </div>
            </div>
            
            <div class="col-xl-3 col-md-6">
                <div class="stat-card">
                    <div class="stat-icon bg-warning-gradient">
                        <i class="fas fa-clipboard"></i>
                    </div>
                    <div class="stat-number">${dashboardData.totalTests}</div>
                    <div class="stat-label">Tests</div>
                </div>
            </div>
            
            <div class="col-xl-3 col-md-6">
                <div class="stat-card">
                    <div class="stat-icon bg-info-gradient">
                        <i class="fas fa-question-circle"></i>
                    </div>
                    <div class="stat-number">${dashboardData.totalQuestions}</div>
                    <div class="stat-label">Questions</div>
                </div>
            </div>
        </div>
        
        <!-- Second Row of Stats -->
        <div class="row">
            <div class="col-xl-3 col-md-6">
                <div class="stat-card">
                    <div class="stat-icon bg-purple-gradient">
                        <i class="fas fa-book"></i>
                    </div>
                    <div class="stat-number">${dashboardData.totalLessons}</div>
                    <div class="stat-label">Lessons</div>
                </div>
            </div>
            
            <div class="col-xl-3 col-md-6">
                <div class="stat-card">
                    <div class="stat-icon bg-orange-gradient">
                        <i class="fas fa-bookmark"></i>
                    </div>
                    <div class="stat-number">${dashboardData.totalSubjects}</div>
                    <div class="stat-label">Subjects</div>
                </div>
            </div>
            
            <div class="col-xl-3 col-md-6">
                <div class="stat-card">
                    <div class="stat-icon bg-teal-gradient">
                        <i class="fas fa-trophy"></i>
                    </div>
                    <div class="stat-number">${dashboardData.totalGrades}</div>
                    <div class="stat-label">Grades</div>
                </div>
            </div>
            
            <div class="col-xl-3 col-md-6">
                <div class="stat-card">
                    <div class="stat-icon bg-danger-gradient">
                        <i class="fas fa-dollar-sign"></i>
                    </div>
                    <div class="stat-number">
                        <fmt:formatNumber value="${dashboardData.totalRevenue}" type="currency" currencySymbol="$"/>
                    </div>
                    <div class="stat-label">Total Revenue</div>
                </div>
            </div>
        </div>
        
        <!-- Charts Row -->
        <div class="row">
            <!-- Test Activity Chart -->
            <div class="col-xl-8">
                <div class="chart-container">
                    <h5><i class="fas fa-chart-line"></i> Test Activity (Last 12 Months)</h5>
                    <canvas id="testActivityChart" height="100"></canvas>
                </div>
            </div>
            
            <!-- User Distribution Chart -->
            <div class="col-xl-4">
                <div class="chart-container">
                    <h5><i class="fas fa-chart-pie"></i> User Distribution</h5>
                    <canvas id="userDistributionChart"></canvas>
                </div>
            </div>
        </div>
        
        <!-- Performance Metrics -->
        <div class="row">
            <div class="col-xl-6">
                <div class="chart-container">
                    <h5><i class="fas fa-chart-bar"></i> User Registrations (Last 12 Months)</h5>
                    <canvas id="userRegistrationChart" height="120"></canvas>
                </div>
            </div>
            
            <div class="col-xl-6">
                <div class="chart-container">
                    <h5><i class="fas fa-chart-area"></i> Revenue Trend</h5>
                    <canvas id="revenueChart" height="120"></canvas>
                </div>
            </div>
        </div>
        
        <!-- Recent Activities -->
        <div class="row">
            <div class="col-xl-6">
                <div class="recent-activity">
                    <h5><i class="fas fa-clock"></i> Recent Test Activities</h5>
                    <c:forEach var="test" items="${dashboardData.recentTests}" varStatus="status">
                        <div class="activity-item">
                            <div class="d-flex justify-content-between">
                                <div>
                                    <strong>Student ID: ${test.student_id}</strong> completed Test ID: ${test.test_id}
                                    <br>
                                    <small class="text-muted">
                                        Score: <fmt:formatNumber value="${test.score}" pattern="##.##"/>%
                                    </small>
                                </div>
                                <small class="text-muted">
                                    <fmt:formatDate value="${test.finishAtAsDate}" pattern="MMM dd, HH:mm"/>
                                </small>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
            
            <div class="col-xl-6">
                <div class="recent-activity">
                    <h5><i class="fas fa-user-plus"></i> Recent Registrations</h5>
                    <c:forEach var="user" items="${dashboardData.recentRegistrations}" varStatus="status">
                        <div class="activity-item">
                            <div class="d-flex justify-content-between">
                                <div>
                                    <strong>${user.full_name}</strong>
                                    <br>
                                    <small class="text-muted">${user.email} - ${user.role}</small>
                                </div>
                                <span class="badge badge-primary">${user.role}</span>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
        
        <!-- Performance Summary -->
        <div class="row mt-4">
            <div class="col-12">
                <div class="chart-container">
                    <h5><i class="fas fa-trophy"></i> Performance Summary</h5>
                    <div class="row text-center">
                        <div class="col-md-4">
                            <div class="p-3">
                                <h3 class="text-primary">
                                    <fmt:formatNumber value="${dashboardData.averageTestScore}" pattern="##.##"/>%
                                </h3>
                                <p class="text-muted">Average Test Score</p>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="p-3">
                                <h3 class="text-success">
                                    <fmt:formatNumber value="${dashboardData.testCompletionRate}" pattern="##.##"/>%
                                </h3>
                                <p class="text-muted">Test Completion Rate</p>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="p-3">
                                <h3 class="text-info">${dashboardData.totalTests}</h3>
                                <p class="text-muted">Total Tests Created</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%@include file="../footer.jsp" %>

    <!-- JavaScript for Charts -->
    <script src="/assets/js/vendor/jquery-1.12.4.min.js"></script>
    <script src="/assets/js/bootstrap.min.js"></script>
    
    <script>
        // Test Activity Chart
        const testActivityCtx = document.getElementById('testActivityChart').getContext('2d');
        const testActivityChart = new Chart(testActivityCtx, {
            type: 'line',
            data: {
                labels: [
                    <c:forEach var="data" items="${dashboardData.monthlyTestData}" varStatus="status">
                        '${data.month}'<c:if test="${!status.last}">,</c:if>
                    </c:forEach>
                ],
                datasets: [{
                    label: 'Tests Started',
                    data: [
                        <c:forEach var="data" items="${dashboardData.monthlyTestData}" varStatus="status">
                            ${data.tests}<c:if test="${!status.last}">,</c:if>
                        </c:forEach>
                    ],
                    borderColor: 'rgb(75, 192, 192)',
                    backgroundColor: 'rgba(75, 192, 192, 0.2)',
                    tension: 0.1
                }, {
                    label: 'Tests Completed',
                    data: [
                        <c:forEach var="data" items="${dashboardData.monthlyTestData}" varStatus="status">
                            ${data.completions}<c:if test="${!status.last}">,</c:if>
                        </c:forEach>
                    ],
                    borderColor: 'rgb(255, 99, 132)',
                    backgroundColor: 'rgba(255, 99, 132, 0.2)',
                    tension: 0.1
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    title: {
                        display: true,
                        text: 'Test Activity Trends'
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });

        // User Distribution Pie Chart
        const userDistCtx = document.getElementById('userDistributionChart').getContext('2d');
        const userDistChart = new Chart(userDistCtx, {
            type: 'doughnut',
            data: {
                labels: [
                    <c:forEach var="entry" items="${dashboardData.usersByRole}" varStatus="status">
                        '${entry.key}'<c:if test="${!status.last}">,</c:if>
                    </c:forEach>
                ],
                datasets: [{
                    data: [
                        <c:forEach var="entry" items="${dashboardData.usersByRole}" varStatus="status">
                            ${entry.value}<c:if test="${!status.last}">,</c:if>
                        </c:forEach>
                    ],
                    backgroundColor: [
                        '#FF6384',
                        '#36A2EB',
                        '#FFCE56',
                        '#4BC0C0',
                        '#9966FF',
                        '#FF9F40'
                    ]
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                }
            }
        });

        // User Registration Chart
        const userRegCtx = document.getElementById('userRegistrationChart').getContext('2d');
        const userRegChart = new Chart(userRegCtx, {
            type: 'bar',
            data: {
                labels: [
                    <c:forEach var="data" items="${dashboardData.monthlyUserData}" varStatus="status">
                        '${data.month}'<c:if test="${!status.last}">,</c:if>
                    </c:forEach>
                ],
                datasets: [{
                    label: 'New Registrations',
                    data: [
                        <c:forEach var="data" items="${dashboardData.monthlyUserData}" varStatus="status">
                            ${data.registrations}<c:if test="${!status.last}">,</c:if>
                        </c:forEach>
                    ],
                    backgroundColor: 'rgba(54, 162, 235, 0.8)',
                    borderColor: 'rgba(54, 162, 235, 1)',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });

        // Revenue Chart
        const revenueCtx = document.getElementById('revenueChart').getContext('2d');
        const revenueChart = new Chart(revenueCtx, {
            type: 'area',
            data: {
                labels: [
                    <c:forEach var="data" items="${dashboardData.monthlyRevenue}" varStatus="status">
                        '${data.month}/${data.year}'<c:if test="${!status.last}">,</c:if>
                    </c:forEach>
                ],
                datasets: [{
                    label: 'Revenue ($)',
                    data: [
                        <c:forEach var="data" items="${dashboardData.monthlyRevenue}" varStatus="status">
                            ${data.revenue}<c:if test="${!status.last}">,</c:if>
                        </c:forEach>
                    ],
                    borderColor: 'rgb(75, 192, 192)',
                    backgroundColor: 'rgba(75, 192, 192, 0.3)',
                    fill: true,
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    title: {
                        display: true,
                        text: 'Monthly Revenue'
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return '$' + value.toLocaleString();
                            }
                        }
                    }
                }
            }
        });

        // Auto-refresh dashboard every 5 minutes
        setInterval(function() {
            location.reload();
        }, 300000);
    </script>
</body>
</html>