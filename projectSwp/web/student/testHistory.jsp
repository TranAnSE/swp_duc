<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!doctype html>
<html class="no-js" lang="zxx">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Lịch sử làm bài</title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="manifest" href="site.webmanifest">
        <link rel="shortcut icon" type="image/x-icon" href="assets/img/favicon.ico">

        <!-- CSS here -->
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

        <style>
            .history-header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 20px;
                border-radius: 8px;
                margin-bottom: 30px;
            }

            .history-table {
                background: white;
                border-radius: 8px;
                overflow: hidden;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }

            .table th {
                background-color: #f8f9fa;
                border-top: none;
                font-weight: 600;
                color: #333;
            }

            .score-badge {
                padding: 6px 12px;
                border-radius: 20px;
                font-weight: 600;
                color: white;
            }

            .score-excellent {
                background: linear-gradient(45deg, #28a745, #20c997);
            }

            .score-good {
                background: linear-gradient(45deg, #17a2b8, #007bff);
            }

            .score-average {
                background: linear-gradient(45deg, #ffc107, #fd7e14);
            }

            .score-poor {
                background: linear-gradient(45deg, #dc3545, #e83e8c);
            }

            .badge-practice {
                background-color: #28a745;
            }

            .badge-official {
                background-color: #dc3545;
            }

            .empty-state {
                text-align: center;
                padding: 60px 20px;
                color: #666;
            }

            .empty-state i {
                font-size: 4em;
                margin-bottom: 20px;
                color: #ddd;
            }

            .action-buttons {
                margin-bottom: 20px;
            }

            .stats-cards {
                margin-bottom: 30px;
            }

            .stat-card {
                background: white;
                border-radius: 8px;
                padding: 20px;
                text-align: center;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                margin-bottom: 20px;
            }

            .stat-number {
                font-size: 2em;
                font-weight: bold;
                color: #007bff;
            }

            .stat-label {
                color: #666;
                font-weight: 500;
            }
        </style>
    </head>
    <body>
        <%@include file="../header.jsp" %>
        <main>
            <section class="container mt-4">
                <!-- Breadcrumb -->
                <nav aria-label="breadcrumb" class="mb-4">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="/">Home</a></li>
                        <li class="breadcrumb-item"><a href="/student/taketest">Tests & Practice</a></li>
                        <li class="breadcrumb-item active">Lịch sử làm bài</li>
                    </ol>
                </nav>

                <!-- Header -->
                <div class="history-header">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h2><i class="fa fa-history"></i> Lịch sử làm bài</h2>
                            <p class="mb-0">Xem lại các kết quả test và practice đã hoàn thành</p>
                        </div>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="action-buttons">
                    <a href="${pageContext.request.contextPath}/student/taketest" 
                       class="btn btn-primary">
                        <i class="fa fa-edit"></i> Làm bài mới
                    </a>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger" role="alert">
                        ${error}
                    </div>
                </c:if>

                <!-- Statistics Cards -->
                <c:if test="${not empty testRecords}">
                    <div class="row stats-cards">
                        <div class="col-md-3 col-sm-6">
                            <div class="stat-card">
                                <div class="stat-number">${testRecords.size()}</div>
                                <div class="stat-label">Tổng số bài đã làm</div>
                            </div>
                        </div>

                        <div class="col-md-3 col-sm-6">
                            <div class="stat-card">
                                <div class="stat-number">
                                    <c:set var="avgScore" value="0"/>
                                    <c:set var="totalScore" value="0"/>
                                    <c:forEach var="record" items="${testRecords}">
                                        <c:set var="totalScore" value="${totalScore + record.score}"/>
                                    </c:forEach>
                                    <c:if test="${testRecords.size() > 0}">
                                        <c:set var="avgScore" value="${totalScore / testRecords.size()}"/>
                                    </c:if>
                                    <fmt:formatNumber value="${avgScore}" maxFractionDigits="1"/>
                                </div>
                                <div class="stat-label">Điểm trung bình</div>
                            </div>
                        </div>

                        <div class="col-md-3 col-sm-6">
                            <div class="stat-card">
                                <div class="stat-number">
                                    <c:set var="maxScore" value="0"/>
                                    <c:forEach var="record" items="${testRecords}">
                                        <c:if test="${record.score > maxScore}">
                                            <c:set var="maxScore" value="${record.score}"/>
                                        </c:if>
                                    </c:forEach>
                                    <fmt:formatNumber value="${maxScore}" maxFractionDigits="1"/>
                                </div>
                                <div class="stat-label">Điểm cao nhất</div>
                            </div>
                        </div>

                        <div class="col-md-3 col-sm-6">
                            <div class="stat-card">
                                <div class="stat-number">
                                    <c:set var="excellentCount" value="0"/>
                                    <c:forEach var="record" items="${testRecords}">
                                        <c:if test="${record.score >= 8.0}">
                                            <c:set var="excellentCount" value="${excellentCount + 1}"/>
                                        </c:if>
                                    </c:forEach>
                                    ${excellentCount}
                                </div>
                                <div class="stat-label">Bài xuất sắc (≥8.0)</div>
                            </div>
                        </div>
                    </div>
                </c:if>

                <!-- History Table -->
                <div class="history-table">
                    <c:choose>
                        <c:when test="${empty testRecords}">
                            <div class="empty-state">
                                <i class="fa fa-clipboard-list"></i>
                                <h4>Chưa có lịch sử làm bài</h4>
                                <p class="text-muted">Bạn chưa hoàn thành bài test hoặc practice nào.</p>
                                <a href="${pageContext.request.contextPath}/student/taketest" 
                                   class="btn btn-primary mt-3">
                                    <i class="fa fa-play"></i> Bắt đầu làm bài
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <table class="table table-hover mb-0">
                                <thead>
                                    <tr>
                                        <th>STT</th>
                                        <th>Tên bài test</th>
                                        <th>Loại</th>
                                        <th>Thời gian làm</th>
                                        <th>Điểm số</th>
                                        <th>Đánh giá</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="record" items="${testRecords}" varStatus="status">
                                        <tr>
                                            <td>${status.index + 1}</td>
                                            <td>
                                                <strong>${testMap[record.test_id]}</strong>
                                            </td>
                                            <td>
                                                <!-- This would need to be determined from test data -->
                                                <span class="badge badge-info">Test</span>
                                            </td>
                                            <td>
                                                <small class="text-muted">
                                                    <fmt:formatDate value="${record.startedAtAsDate}" pattern="dd/MM/yyyy"/>
                                                    <br>
                                                    <fmt:formatDate value="${record.startedAtAsDate}" pattern="HH:mm"/>
                                                </small>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${record.score >= 8.0}">
                                                        <span class="score-badge score-excellent">
                                                            <fmt:formatNumber value="${record.score}" maxFractionDigits="1"/>
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${record.score >= 6.5}">
                                                        <span class="score-badge score-good">
                                                            <fmt:formatNumber value="${record.score}" maxFractionDigits="1"/>
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${record.score >= 5.0}">
                                                        <span class="score-badge score-average">
                                                            <fmt:formatNumber value="${record.score}" maxFractionDigits="1"/>
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="score-badge score-poor">
                                                            <fmt:formatNumber value="${record.score}" maxFractionDigits="1"/>
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${record.score >= 8.0}">
                                                        <span class="text-success">
                                                            <i class="fa fa-star"></i> Xuất sắc
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${record.score >= 6.5}">
                                                        <span class="text-info">
                                                            <i class="fa fa-thumbs-up"></i> Tốt
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${record.score >= 5.0}">
                                                        <span class="text-warning">
                                                            <i class="fa fa-meh"></i> Trung bình
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-danger">
                                                            <i class="fa fa-frown"></i> Cần cải thiện
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/student/taketest?action=result&testRecordId=${record.id}" 
                                                   class="btn btn-sm btn-outline-primary">
                                                    <i class="fa fa-eye"></i> Xem chi tiết
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:otherwise>
                    </c:choose>
                </div>
            </section>
        </main>

        <%@include file="../footer.jsp" %>

        <!-- JS here -->
        <script src="${pageContext.request.contextPath}/assets/js/vendor/modernizr-3.5.0.min.js"></script>
        <!-- Jquery, Popper, Bootstrap -->
        <script src="${pageContext.request.contextPath}/assets/js/vendor/jquery-1.12.4.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/popper.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>
        <!-- Jquery Mobile Menu -->
        <script src="${pageContext.request.contextPath}/assets/js/jquery.slicknav.min.js"></script>

        <!-- Jquery Slick , Owl-Carousel Plugins -->
        <script src="${pageContext.request.contextPath}/assets/js/owl.carousel.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/slick.min.js"></script>
        <!-- One Page, Animated-HeadLin -->
        <script src="${pageContext.request.contextPath}/assets/js/wow.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/animated.headline.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.magnific-popup.js"></script>

        <!-- Date Picker -->
        <script src="${pageContext.request.contextPath}/assets/js/gijgo.min.js"></script>
        <!-- Nice-select, sticky -->
        <script src="${pageContext.request.contextPath}/assets/js/jquery.nice-select.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.sticky.js"></script>
        <!-- Progress -->
        <script src="${pageContext.request.contextPath}/assets/js/jquery.barfiller.js"></script>

        <!-- counter , waypoint,Hover Direction -->
        <script src="${pageContext.request.contextPath}/assets/js/jquery.counterup.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/waypoints.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.countdown.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/hover-direction-snake.min.js"></script>

        <!-- contact js -->
        <script src="${pageContext.request.contextPath}/assets/js/contact.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.form.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.validate.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/mail-script.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.ajaxchimp.min.js"></script>

        <!-- Jquery Plugins, main Jquery -->	
        <script src="${pageContext.request.contextPath}/assets/js/plugins.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>

    </body>
</html> 