<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html class="no-js" lang="zxx">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Danh sách Bài Kiểm Tra</title>
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
            .course-section {
                background: white;
                border-radius: 12px;
                padding: 25px;
                margin-bottom: 30px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
                border-left: 4px solid #007bff;
            }

            .course-header {
                background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
                color: white;
                padding: 15px 20px;
                border-radius: 8px;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                justify-content: space-between;
            }

            .course-title {
                font-size: 1.3rem;
                font-weight: 600;
                margin: 0;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .test-card {
                border: 1px solid #e9ecef;
                border-radius: 10px;
                padding: 20px;
                margin-bottom: 15px;
                transition: all 0.3s ease;
                background: #f8f9fa;
                position: relative;
            }

            .test-card:hover {
                box-shadow: 0 6px 20px rgba(0,0,0,0.15);
                transform: translateY(-2px);
            }

            .practice-card {
                border-left: 4px solid #28a745;
            }

            .practice-card .test-card-header {
                background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            }

            .official-card {
                border-left: 4px solid #dc3545;
            }

            .official-card .test-card-header {
                background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            }

            .taken-card {
                background-color: #f1f3f4;
                opacity: 0.8;
            }

            .taken-card .test-card-header {
                background: linear-gradient(135deg, #6c757d 0%, #5a6268 100%);
            }

            .test-card-header {
                color: white;
                padding: 12px 15px;
                border-radius: 6px;
                margin: -10px -10px 15px -10px;
                display: flex;
                justify-content: between;
                align-items: center;
            }

            .test-title {
                font-size: 1.1rem;
                font-weight: 600;
                margin: 0;
                flex: 1;
            }

            .test-badges {
                display: flex;
                gap: 8px;
                align-items: center;
            }

            .test-info {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 15px;
                font-size: 0.9rem;
                color: #6c757d;
            }

            .test-meta {
                display: flex;
                gap: 15px;
            }

            .test-meta span {
                display: flex;
                align-items: center;
                gap: 5px;
            }

            .test-description {
                color: #495057;
                margin-bottom: 15px;
                font-size: 0.95rem;
                line-height: 1.5;
            }

            .chapter-info {
                background: #e3f2fd;
                color: #1976d2;
                padding: 5px 10px;
                border-radius: 15px;
                font-size: 0.8rem;
                font-weight: 500;
            }

            .btn-start {
                width: 100%;
                font-weight: 600;
                padding: 10px;
                border-radius: 25px;
                transition: all 0.3s ease;
            }

            .btn-start:hover {
                transform: translateY(-1px);
                box-shadow: 0 4px 12px rgba(0,0,0,0.2);
            }

            .section-title {
                color: #333;
                border-bottom: 3px solid #007bff;
                padding-bottom: 10px;
                margin-bottom: 25px;
                font-weight: 600;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .nav-buttons {
                background: white;
                border-radius: 8px;
                padding: 20px;
                margin-bottom: 30px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.05);
                text-align: center;
            }

            .badge-practice {
                background: linear-gradient(45deg, #28a745, #20c997);
                color: white;
                padding: 4px 8px;
                border-radius: 12px;
                font-size: 0.75rem;
                font-weight: 600;
            }

            .badge-official {
                background: linear-gradient(45deg, #dc3545, #c82333);
                color: white;
                padding: 4px 8px;
                border-radius: 12px;
                font-size: 0.75rem;
                font-weight: 600;
            }

            .badge-taken {
                background: linear-gradient(45deg, #6c757d, #5a6268);
                color: white;
                padding: 4px 8px;
                border-radius: 12px;
                font-size: 0.75rem;
                font-weight: 600;
            }

            .empty-state {
                text-align: center;
                padding: 60px 20px;
                color: #6c757d;
                background: white;
                border-radius: 12px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            }

            .empty-state i {
                font-size: 4em;
                margin-bottom: 20px;
                color: #dee2e6;
            }

            .page-header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 30px;
                border-radius: 12px;
                margin-bottom: 30px;
                text-align: center;
            }

            .stats-info {
                background: #e8f4f8;
                border-left: 4px solid #17a2b8;
                padding: 15px;
                border-radius: 8px;
                margin-bottom: 20px;
            }

            @media (max-width: 768px) {
                .test-info {
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 10px;
                }

                .test-meta {
                    flex-wrap: wrap;
                }

                .course-title {
                    font-size: 1.1rem;
                }
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
                        <li class="breadcrumb-item"><a href="/">Trang chủ</a></li>
                        <li class="breadcrumb-item active">Bài Kiểm Tra</li>
                    </ol>
                </nav>

                <!-- Page Header -->
                <div class="page-header">
                    <h2><i class="fas fa-clipboard-list"></i> Danh Sách Bài Kiểm Tra</h2>
                    <p class="mb-0">Thực hiện các bài kiểm tra và luyện tập theo khóa học của bạn</p>
                </div>

                <!-- Navigation Buttons -->
                <div class="nav-buttons">
                    <a href="${pageContext.request.contextPath}/student/taketest?action=history" 
                       class="btn btn-info btn-lg">
                        <i class="fas fa-history"></i> Lịch sử làm bài
                    </a>
                </div>

                <!-- Error message if exists -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-triangle"></i> ${error}
                        <button type="button" class="close" data-dismiss="alert">
                            <span>&times;</span>
                        </button>
                    </div>
                </c:if>

                <!-- Course-based Tests -->
                <c:if test="${not empty testsByCourse}">
                    <c:forEach var="courseEntry" items="${testsByCourse}">
                        <div class="course-section">
                            <div class="course-header">
                                <h3 class="course-title">
                                    <i class="fas fa-graduation-cap"></i>
                                    ${courseEntry.key}
                                </h3>
                                <span class="badge badge-light">
                                    ${courseEntry.value.size()} bài kiểm tra
                                </span>
                            </div>

                            <div class="row">
                                <c:forEach var="test" items="${courseEntry.value}">
                                    <div class="col-lg-6 col-md-12">
                                        <div class="test-card
                                             <c:choose>
                                                 <c:when test="${test.has_taken}">taken-card</c:when>
                                                 <c:when test="${test.is_practice}">practice-card</c:when>
                                                 <c:otherwise>official-card</c:otherwise>
                                             </c:choose>">

                                            <div class="test-card-header">
                                                <h5 class="test-title">${test.test_name}</h5>
                                                <div class="test-badges">
                                                    <c:choose>
                                                        <c:when test="${test.has_taken}">
                                                            <span class="badge-taken">Đã hoàn thành</span>
                                                        </c:when>
                                                        <c:when test="${test.is_practice}">
                                                            <span class="badge-practice">Luyện tập</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge-official">Kiểm tra</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>

                                            <div class="test-info">
                                                <div class="test-meta">
                                                    <c:if test="${test.duration_minutes > 0}">
                                                        <span>
                                                            <i class="fas fa-clock text-primary"></i>
                                                            ${test.duration_minutes} phút
                                                        </span>
                                                    </c:if>
                                                    <c:if test="${test.num_questions > 0}">
                                                        <span>
                                                            <i class="fas fa-question-circle text-info"></i>
                                                            ${test.num_questions} câu hỏi
                                                        </span>
                                                    </c:if>
                                                </div>
                                                <c:if test="${not empty test.chapter_name}">
                                                    <div class="chapter-info">
                                                        <i class="fas fa-book"></i> ${test.chapter_name}
                                                    </div>
                                                </c:if>
                                            </div>

                                            <c:if test="${not empty test.test_description}">
                                                <p class="test-description">${test.test_description}</p>
                                            </c:if>

                                            <c:choose>
                                                <c:when test="${test.has_taken}">
                                                    <button class="btn btn-secondary btn-start" disabled>
                                                        <i class="fas fa-check-circle"></i> Đã hoàn thành
                                                    </button>
                                                </c:when>
                                                <c:when test="${test.is_practice}">
                                                    <a href="${pageContext.request.contextPath}/student/taketest?action=start&testId=${test.test_id}" 
                                                       class="btn btn-success btn-start">
                                                        <i class="fas fa-play"></i> Bắt đầu luyện tập
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="${pageContext.request.contextPath}/student/taketest?action=start&testId=${test.test_id}" 
                                                       class="btn btn-danger btn-start"
                                                       onclick="return confirm('Bài kiểm tra chính thức chỉ được làm 1 lần. Bạn có chắc chắn muốn bắt đầu?')">
                                                        <i class="fas fa-edit"></i> Bắt đầu kiểm tra
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </c:forEach>
                </c:if>

                <!-- Standalone Tests -->
                <c:if test="${not empty standalonePracticeTests or not empty standaloneOfficialTests}">
                    <div class="course-section">
                        <div class="course-header" style="background: linear-gradient(135deg, #6f42c1 0%, #5a32a3 100%);">
                            <h3 class="course-title">
                                <i class="fas fa-tasks"></i>
                                Bài Kiểm Tra Tổng Hợp
                            </h3>
                            <span class="badge badge-light">
                                ${standalonePracticeTests.size() + standaloneOfficialTests.size()} bài kiểm tra
                            </span>
                        </div>

                        <!-- Standalone Practice Tests -->
                        <c:if test="${not empty standalonePracticeTests}">
                            <h4 class="section-title">
                                <i class="fas fa-play-circle text-success"></i> 
                                Luyện Tập
                            </h4>
                            <div class="row">
                                <c:forEach var="test" items="${standalonePracticeTests}">
                                    <div class="col-lg-6 col-md-12">
                                        <div class="test-card practice-card">
                                            <div class="test-card-header">
                                                <h5 class="test-title">${test.test_name}</h5>
                                                <div class="test-badges">
                                                    <span class="badge-practice">Luyện tập</span>
                                                </div>
                                            </div>

                                            <div class="test-info">
                                                <div class="test-meta">
                                                    <c:if test="${test.duration_minutes > 0}">
                                                        <span>
                                                            <i class="fas fa-clock text-primary"></i>
                                                            ${test.duration_minutes} phút
                                                        </span>
                                                    </c:if>
                                                    <c:if test="${test.num_questions > 0}">
                                                        <span>
                                                            <i class="fas fa-question-circle text-info"></i>
                                                            ${test.num_questions} câu hỏi
                                                        </span>
                                                    </c:if>
                                                </div>
                                            </div>

                                            <c:if test="${not empty test.test_description}">
                                                <p class="test-description">${test.test_description}</p>
                                            </c:if>

                                            <a href="${pageContext.request.contextPath}/student/taketest?action=start&testId=${test.test_id}" 
                                               class="btn btn-success btn-start">
                                                <i class="fas fa-play"></i> Bắt đầu luyện tập
                                            </a>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:if>

                        <!-- Standalone Official Tests -->
                        <c:if test="${not empty standaloneOfficialTests}">
                            <h4 class="section-title">
                                <i class="fas fa-certificate text-danger"></i> 
                                Kiểm Tra Chính Thức
                            </h4>
                            <div class="row">
                                <c:forEach var="test" items="${standaloneOfficialTests}">
                                    <div class="col-lg-6 col-md-12">
                                        <div class="test-card ${test.has_taken ? 'taken-card' : 'official-card'}">
                                            <div class="test-card-header">
                                                <h5 class="test-title">${test.test_name}</h5>
                                                <div class="test-badges">
                                                    <c:choose>
                                                        <c:when test="${test.has_taken}">
                                                            <span class="badge-taken">Đã hoàn thành</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge-official">Kiểm tra</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>

                                            <div class="test-info">
                                                <div class="test-meta">
                                                    <c:if test="${test.duration_minutes > 0}">
                                                        <span>
                                                            <i class="fas fa-clock text-primary"></i>
                                                            ${test.duration_minutes} phút
                                                        </span>
                                                    </c:if>
                                                    <c:if test="${test.num_questions > 0}">
                                                        <span>
                                                            <i class="fas fa-question-circle text-info"></i>
                                                            ${test.num_questions} câu hỏi
                                                        </span>
                                                    </c:if>
                                                </div>
                                            </div>

                                            <c:if test="${not empty test.test_description}">
                                                <p class="test-description">${test.test_description}</p>
                                            </c:if>

                                            <c:choose>
                                                <c:when test="${test.has_taken}">
                                                    <button class="btn btn-secondary btn-start" disabled>
                                                        <i class="fas fa-check-circle"></i> Đã hoàn thành
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="${pageContext.request.contextPath}/student/taketest?action=start&testId=${test.test_id}" 
                                                       class="btn btn-danger btn-start"
                                                       onclick="return confirm('Bài kiểm tra chính thức chỉ được làm 1 lần. Bạn có chắc chắn muốn bắt đầu?')">
                                                        <i class="fas fa-edit"></i> Bắt đầu kiểm tra
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:if>
                    </div>
                </c:if>

                <!-- Empty State -->
                <c:if test="${empty testsByCourse and empty standalonePracticeTests and empty standaloneOfficialTests}">
                    <div class="empty-state">
                        <i class="fas fa-clipboard-list"></i>
                        <h4>Chưa có bài kiểm tra nào</h4>
                        <p class="text-muted">
                            Hiện tại bạn chưa có quyền truy cập vào bài kiểm tra nào.<br>
                            Vui lòng liên hệ với phụ huynh để mua khóa học hoặc gói học tập.
                        </p>
                        <a href="${pageContext.request.contextPath}/dashboard?action=student" 
                           class="btn btn-primary mt-3">
                            <i class="fas fa-home"></i> Về trang chủ
                        </a>
                    </div>
                </c:if>

                <!-- Info Box -->
                <div class="stats-info">
                    <h6><i class="fas fa-info-circle"></i> Thông tin quan trọng:</h6>
                    <ul class="mb-0">
                        <li><strong>Bài luyện tập:</strong> Có thể làm nhiều lần để rèn luyện kỹ năng</li>
                        <li><strong>Bài kiểm tra chính thức:</strong> Chỉ được làm 1 lần duy nhất</li>
                        <li><strong>Thời gian làm bài:</strong> Được hiển thị rõ ràng cho từng bài kiểm tra</li>
                        <li><strong>Kết quả:</strong> Xem lại trong mục "Lịch sử làm bài"</li>
                    </ul>
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