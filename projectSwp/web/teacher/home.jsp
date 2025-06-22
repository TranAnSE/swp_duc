<%-- 
    Document   : home
    Created on : May 21, 2025, 9:01:18 PM
    Author     : BuiNgocLinh
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Teacher Dashboard</title>
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
            }

            /* Header spacing fix */
            .main-content {
                margin-top: 100px; /* Adjust based on your header height */
                padding-bottom: 2rem;
            }

            .dashboard-header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 2rem 0;
                margin-bottom: 2rem;
                border-radius: 10px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            }

            .stats-card {
                background: white;
                border-radius: 10px;
                padding: 1.5rem;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                margin-bottom: 1.5rem;
                border: 1px solid #e9ecef;
            }

            .stats-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 25px rgba(0,0,0,0.15);
            }

            .stats-icon {
                width: 60px;
                height: 60px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.5rem;
                margin-bottom: 1rem;
            }

            .stats-icon.students {
                background-color: #e3f2fd;
                color: #1976d2;
            }
            .stats-icon.grades {
                background-color: #f3e5f5;
                color: #7b1fa2;
            }
            .stats-icon.subjects {
                background-color: #e8f5e8;
                color: #388e3c;
            }
            .stats-icon.lessons {
                background-color: #fff3e0;
                color: #f57c00;
            }
            .stats-icon.tests {
                background-color: #fce4ec;
                color: #c2185b;
            }

            .chart-container {
                background: white;
                border-radius: 10px;
                padding: 1.5rem;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                margin-bottom: 1.5rem;
                height: 400px;
                border: 1px solid #e9ecef;
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

            .quick-action-btn {
                background: linear-gradient(45deg, #667eea, #764ba2);
                border: none;
                color: white;
                padding: 0.75rem 1.5rem;
                border-radius: 25px;
                text-decoration: none;
                display: inline-block;
                margin: 0.25rem;
                transition: all 0.3s ease;
                font-weight: 500;
            }

            .quick-action-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 15px rgba(0,0,0,0.2);
                color: white;
                text-decoration: none;
            }

            .recent-activity {
                background: white;
                border-radius: 10px;
                padding: 1.5rem;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                height: 400px;
                overflow-y: auto;
                border: 1px solid #e9ecef;
            }

            .activity-item {
                padding: 0.75rem;
                border-bottom: 1px solid #eee;
                display: flex;
                align-items: center;
                transition: background-color 0.2s ease;
            }

            .activity-item:hover {
                background-color: #f8f9fa;
            }

            .activity-item:last-child {
                border-bottom: none;
            }

            .activity-icon {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                background-color: #e3f2fd;
                color: #1976d2;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-right: 1rem;
                flex-shrink: 0;
            }

            .welcome-section {
                text-align: center;
            }

            .chart-title {
                font-size: 1.2rem;
                font-weight: 600;
                margin-bottom: 1rem;
                color: #333;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .stats-number {
                font-size: 2rem;
                font-weight: bold;
                color: #333;
            }

            .stats-label {
                color: #6c757d;
                font-size: 0.9rem;
                font-weight: 500;
            }

            .badge {
                font-size: 0.75rem;
                padding: 0.25rem 0.5rem;
            }

            /* Responsive adjustments */
            @media (max-width: 768px) {
                .main-content {
                    margin-top: 80px;
                }

                .chart-container {
                    height: 350px;
                }

                .chart-wrapper {
                    height: 250px;
                }

                .recent-activity {
                    height: 350px;
                }

                .stats-card {
                    margin-bottom: 1rem;
                }

                .quick-action-btn {
                    margin: 0.2rem;
                    padding: 0.5rem 1rem;
                    font-size: 0.9rem;
                }
            }

            @media (max-width: 576px) {
                .dashboard-header {
                    padding: 1.5rem 0;
                }

                .stats-icon {
                    width: 50px;
                    height: 50px;
                    font-size: 1.2rem;
                }

                .stats-number {
                    font-size: 1.5rem;
                }
            }
        </style>
    </head>

    <body>
        <jsp:include page="../header.jsp" />

        <div class="main-content">
            <div class="container-fluid">
                <!-- Dashboard Header -->
                <div class="dashboard-header">
                    <div class="container">
                        <div class="welcome-section">
                            <h1><i class="fas fa-chalkboard-teacher"></i> Welcome, ${teacher.full_name}!</h1>
                            <p class="lead">Here's an overview of the system activities</p>
                        </div>
                    </div>
                </div>

                <!-- Statistics Cards -->
                <div class="container">
                    <div class="row">
                        <div class="col-lg-2 col-md-4 col-sm-6">
                            <div class="stats-card text-center">
                                <div class="stats-icon students mx-auto">
                                    <i class="fas fa-user"></i>
                                </div>
                                <div class="stats-number">${teacherData.students != null ? teacherData.students : 0}</div>
                                <div class="stats-label">Students</div>
                            </div>
                        </div>

                        <div class="col-lg-2 col-md-4 col-sm-6">
                            <div class="stats-card text-center">
                                <div class="stats-icon grades mx-auto">
                                    <i class="fas fa-cubes"></i>
                                </div>
                                <div class="stats-number">${teacherData.grades != null ? teacherData.grades : 0}</div>
                                <div class="stats-label">Grades</div>
                            </div>
                        </div>

                        <div class="col-lg-2 col-md-4 col-sm-6">
                            <div class="stats-card text-center">
                                <div class="stats-icon subjects mx-auto">
                                    <i class="fas fa-book"></i>
                                </div>
                                <div class="stats-number">${teacherData.subjects != null ? teacherData.subjects : 0}</div>
                                <div class="stats-label">Subjects</div>
                            </div>
                        </div>

                        <div class="col-lg-2 col-md-4 col-sm-6">
                            <div class="stats-card text-center">
                                <div class="stats-icon lessons mx-auto">
                                    <i class="fas fa-play-circle"></i>
                                </div>
                                <div class="stats-number">${teacherData.lessons != null ? teacherData.lessons : 0}</div>
                                <div class="stats-label">Lessons</div>
                            </div>
                        </div>

                        <div class="col-lg-2 col-md-4 col-sm-6">
                            <div class="stats-card text-center">
                                <div class="stats-icon tests mx-auto">
                                    <i class="fas fa-clipboard"></i>
                                </div>
                                <div class="stats-number">${teacherData.tests != null ? teacherData.tests : 0}</div>
                                <div class="stats-label">Tests</div>
                            </div>
                        </div>
                    </div>

                    <!-- Quick Actions -->
                    <div class="row mt-4">
                        <div class="col-12">
                            <div class="stats-card">
                                <h5 class="mb-3"><i class="fas fa-bolt"></i> Quick Actions</h5>
                                <div class="text-center">
                                    <a href="${pageContext.request.contextPath}/student" class="quick-action-btn">
                                        <i class="fas fa-users"></i> Manage Students
                                    </a>
                                    <a href="${pageContext.request.contextPath}/LessonURL" class="quick-action-btn">
                                        <i class="fas fa-video"></i> My Lessons
                                    </a>
                                    <a href="${pageContext.request.contextPath}/Question" class="quick-action-btn">
                                        <i class="fas fa-question-circle"></i> Question Bank
                                    </a>
                                    <a href="${pageContext.request.contextPath}/test" class="quick-action-btn">
                                        <i class="fas fa-clipboard"></i> Manage Tests
                                    </a>
                                    <a href="${pageContext.request.contextPath}/chapter" class="quick-action-btn">
                                        <i class="fas fa-book"></i> Chapters
                                    </a>
                                    <a href="${pageContext.request.contextPath}/category" class="quick-action-btn">
                                        <i class="fas fa-tags"></i> Categories
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Charts Row -->
                    <div class="row mt-4">
                        <!-- Grade Performance Chart -->
                        <div class="col-lg-6">
                            <div class="chart-container">
                                <h5 class="chart-title">
                                    <i class="fas fa-chart-bar"></i> 
                                    Grade Performance Overview
                                </h5>
                                <div class="chart-wrapper">
                                    <canvas id="performanceChart"></canvas>
                                </div>
                            </div>
                        </div>

                        <!-- Monthly Test Completions -->
                        <div class="col-lg-6">
                            <div class="chart-container">
                                <h5 class="chart-title">
                                    <i class="fas fa-chart-line"></i> 
                                    Monthly Test Completions
                                </h5>
                                <div class="chart-wrapper">
                                    <canvas id="monthlyChart"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Subject Distribution and Recent Activities -->
                    <div class="row mt-4">
                        <!-- Subject Distribution -->
                        <div class="col-lg-6">
                            <div class="chart-container">
                                <h5 class="chart-title">
                                    <i class="fas fa-chart-pie"></i> 
                                    Subject Distribution
                                </h5>
                                <div class="chart-wrapper">
                                    <canvas id="subjectChart"></canvas>
                                </div>
                            </div>
                        </div>

                        <!-- Recent Activities -->
                        <div class="col-lg-6">
                            <div class="recent-activity">
                                <h5 class="chart-title">
                                    <i class="fas fa-clock"></i> 
                                    Recent Test Activities
                                </h5>
                                <div class="activity-list">
                                    <c:choose>
                                        <c:when test="${not empty recentActivities}">
                                            <c:forEach var="activity" items="${recentActivities}" varStatus="status">
                                                <c:if test="${status.index < 8}">
                                                    <div class="activity-item">
                                                        <div class="activity-icon">
                                                            <i class="fas fa-user-check"></i>
                                                        </div>
                                                        <div class="flex-grow-1">
                                                            <div class="d-flex justify-content-between align-items-start">
                                                                <strong class="text-truncate">${activity.studentName}</strong>
                                                                <small class="text-muted ml-2">
                                                                    <fmt:formatDate value="${activity.finishAt}" pattern="MMM dd, HH:mm"/>
                                                                </small>
                                                            </div>
                                                            <div class="text-muted small">
                                                                Completed "${activity.testName}" 
                                                                <span class="badge badge-${activity.score >= 7.0 ? 'success' : activity.score >= 5.0 ? 'warning' : 'danger'} ml-1">
                                                                    ${activity.score}/10
                                                                </span>
                                                            </div>
                                                            <c:if test="${not empty activity.gradeName}">
                                                                <small class="text-muted">${activity.gradeName}</small>
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                </c:if>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="text-center text-muted py-4">
                                                <i class="fas fa-inbox fa-2x mb-2 d-block"></i>
                                                <p class="mb-0">No recent test activities</p>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="../footer.jsp" />

        <!-- JavaScript -->
        <script src="${pageContext.request.contextPath}/assets/js/vendor/jquery-1.12.4.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>

        <script>
            // Wait for DOM to be ready
            document.addEventListener('DOMContentLoaded', function () {
                // Chart data from server with null safety
                const gradePerformanceData = ${studentPerformanceJson != null ? studentPerformanceJson : '[]'};
                const monthlyCompletionsData = ${monthlyCompletionsJson != null ? monthlyCompletionsJson : '[]'};
                const subjectDistributionData = ${subjectDistributionJson != null ? subjectDistributionJson : '[]'};

                // Check if chart containers exist before creating charts
                const performanceCanvas = document.getElementById('performanceChart');
                const monthlyCanvas = document.getElementById('monthlyChart');
                const subjectCanvas = document.getElementById('subjectChart');

                // Grade Performance Chart (using getGradeDistribution data)
                if (performanceCanvas) {
                    if (gradePerformanceData && gradePerformanceData.length > 0) {
                        const performanceCtx = performanceCanvas.getContext('2d');
                        new Chart(performanceCtx, {
                            type: 'bar',
                            data: {
                                labels: gradePerformanceData.map(item => item.gradeName || 'Unknown'),
                                datasets: [{
                                        label: 'Average Score', // Changed label
                                        data: gradePerformanceData.map(item => item.avgScore || 0),
                                        backgroundColor: 'rgba(102, 126, 234, 0.6)',
                                        borderColor: 'rgba(102, 126, 234, 1)',
                                        borderWidth: 1,
                                        borderRadius: 4
                                    }, {
                                        label: 'Total Students',
                                        data: gradePerformanceData.map(item => item.totalStudents || 0),
                                        backgroundColor: 'rgba(118, 75, 162, 0.6)',
                                        borderColor: 'rgba(118, 75, 162, 1)',
                                        borderWidth: 1,
                                        borderRadius: 4,
                                        yAxisID: 'y1'
                                    }]
                            },
                            options: {
                                responsive: true,
                                maintainAspectRatio: false,
                                plugins: {
                                    legend: {
                                        display: true,
                                        position: 'top'
                                    },
                                    tooltip: {
                                        mode: 'index',
                                        intersect: false,
                                        callbacks: {
                                            label: function (context) {
                                                let label = context.dataset.label || '';
                                                if (label) {
                                                    label += ': ';
                                                }
                                                if (context.parsed.y !== null) {
                                                    if (context.dataset.label === 'Average Score') {
                                                        label += context.parsed.y.toFixed(1) + '/10';
                                                    } else {
                                                        label += context.parsed.y;
                                                    }
                                                }
                                                return label;
                                            }
                                        }
                                    }
                                },
                                scales: {
                                    y: {
                                        beginAtZero: true,
                                        max: 10,
                                        title: {
                                            display: true,
                                            text: 'Average Score'
                                        },
                                        grid: {
                                            color: 'rgba(0,0,0,0.1)'
                                        }
                                    },
                                    y1: {
                                        type: 'linear',
                                        display: true,
                                        position: 'right',
                                        beginAtZero: true,
                                        title: {
                                            display: true,
                                            text: 'Number of Students'
                                        },
                                        grid: {
                                            drawOnChartArea: false,
                                        },
                                    }
                                }
                            }
                        });
                    } else {
                        performanceCanvas.parentElement.innerHTML =
                                '<div class="text-center text-muted py-4">' +
                                '<i class="fas fa-chart-bar fa-2x mb-2 d-block"></i>' +
                                '<p class="mb-0">No grade performance data available</p>' +
                                '</div>';
                    }
                }

                // Monthly Completions Chart
                if (monthlyCanvas) {
                    if (monthlyCompletionsData && monthlyCompletionsData.length > 0) {
                        const monthlyCtx = monthlyCanvas.getContext('2d');
                        new Chart(monthlyCtx, {
                            type: 'line',
                            data: {
                                labels: monthlyCompletionsData.map(item => item.month || 'Unknown'),
                                datasets: [{
                                        label: 'Test Completions',
                                        data: monthlyCompletionsData.map(item => item.completions || 0),
                                        borderColor: 'rgba(102, 126, 234, 1)',
                                        backgroundColor: 'rgba(102, 126, 234, 0.1)',
                                        tension: 0.4,
                                        fill: true,
                                        pointBackgroundColor: 'rgba(102, 126, 234, 1)',
                                        pointBorderColor: '#fff',
                                        pointBorderWidth: 2,
                                        pointRadius: 5
                                    }]
                            },
                            options: {
                                responsive: true,
                                maintainAspectRatio: false,
                                plugins: {
                                    legend: {
                                        display: true,
                                        position: 'top'
                                    },
                                    tooltip: {
                                        mode: 'index',
                                        intersect: false
                                    }
                                },
                                scales: {
                                    y: {
                                        beginAtZero: true,
                                        title: {
                                            display: true,
                                            text: 'Number of Completions'
                                        },
                                        grid: {
                                            color: 'rgba(0,0,0,0.1)'
                                        }
                                    },
                                    x: {
                                        grid: {
                                            color: 'rgba(0,0,0,0.1)'
                                        }
                                    }
                                }
                            }
                        });
                    } else {
                        monthlyCanvas.parentElement.innerHTML =
                                '<div class="text-center text-muted py-4">' +
                                '<i class="fas fa-chart-line fa-2x mb-2 d-block"></i>' +
                                '<p class="mb-0">No monthly data available</p>' +
                                '</div>';
                    }
                }

                // Subject Distribution Chart
                if (subjectCanvas) {
                    if (subjectDistributionData && subjectDistributionData.length > 0) {
                        const subjectCtx = subjectCanvas.getContext('2d');
                        new Chart(subjectCtx, {
                            type: 'doughnut',
                            data: {
                                labels: subjectDistributionData.map(item => item.subjectName || 'Unknown'),
                                datasets: [{
                                        label: 'Lessons Count',
                                        data: subjectDistributionData.map(item => item.lessonCount || 0),
                                        backgroundColor: [
                                            'rgba(102, 126, 234, 0.8)',
                                            'rgba(118, 75, 162, 0.8)',
                                            'rgba(255, 99, 132, 0.8)',
                                            'rgba(54, 162, 235, 0.8)',
                                            'rgba(255, 205, 86, 0.8)',
                                            'rgba(75, 192, 192, 0.8)',
                                            'rgba(153, 102, 255, 0.8)',
                                            'rgba(255, 159, 64, 0.8)'
                                        ],
                                        borderColor: [
                                            'rgba(102, 126, 234, 1)',
                                            'rgba(118, 75, 162, 1)',
                                            'rgba(255, 99, 132, 1)',
                                            'rgba(54, 162, 235, 1)',
                                            'rgba(255, 205, 86, 1)',
                                            'rgba(75, 192, 192, 1)',
                                            'rgba(153, 102, 255, 1)',
                                            'rgba(255, 159, 64, 1)'
                                        ],
                                        borderWidth: 2
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
                                    },
                                    tooltip: {
                                        callbacks: {
                                            label: function (context) {
                                                const label = context.label || '';
                                                const value = context.parsed || 0;
                                                const total = context.dataset.data.reduce((a, b) => a + b, 0);
                                                const percentage = total > 0 ? ((value / total) * 100).toFixed(1) : 0;
                                                return `${label}: ${value} lessons (${percentage}%)`;
                                            }
                                        }
                                    }
                                }
                            }
                        });
                    } else {
                        subjectCanvas.parentElement.innerHTML =
                                '<div class="text-center text-muted py-4">' +
                                '<i class="fas fa-chart-pie fa-2x mb-2 d-block"></i>' +
                                '<p class="mb-0">No subject data available</p>' +
                                '</div>';
                    }
                }
            });
        </script>
    </body>
</html>