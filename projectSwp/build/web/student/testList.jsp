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
            /* Body padding to account for fixed header */
            body {
                padding-top: 120px; /* Tăng từ 90px lên 120px để đảm bảo không bị che */
            }

            /* Main container styling */
            .course-section {
                background: #ffffff;
                border-radius: 15px;
                padding: 25px;
                margin-bottom: 30px;
                box-shadow: 0 8px 25px rgba(0,0,0,0.08);
                border: 1px solid #e8ecef;
                transition: all 0.3s ease;
            }

            .course-section:hover {
                box-shadow: 0 12px 35px rgba(0,0,0,0.12);
                transform: translateY(-2px);
            }

            /* Page header improvements - thêm margin-top để đẩy xuống */
            .page-header {
                background: linear-gradient(135deg, #4a90e2 0%, #357abd 100%);
                color: white;
                padding: 35px;
                border-radius: 15px;
                margin-top: 20px; /* Thêm margin-top */
                margin-bottom: 35px;
                text-align: center;
                box-shadow: 0 8px 25px rgba(74, 144, 226, 0.3);
            }

            .page-header h2 {
                margin-bottom: 10px;
                font-weight: 600;
                color: white;
            }

            .page-header p {
                opacity: 0.9;
                font-size: 1.1rem;
            }

            /* Breadcrumb styling - đảm bảo không bị che */
            .breadcrumb {
                background: rgba(248, 249, 250, 0.9);
                border-radius: 8px;
                padding: 12px 15px;
                margin-bottom: 20px;
                backdrop-filter: blur(10px);
                border: 1px solid rgba(0,0,0,0.1);
            }

            .breadcrumb-item + .breadcrumb-item::before {
                color: #6c757d;
            }

            /* Container spacing adjustment */
            .container {
                padding-top: 20px; /* Thêm padding-top cho container */
            }

            /* Course header with improved colors */
            .course-header {
                background: linear-gradient(135deg, #4a90e2 0%, #357abd 100%);
                color: white;
                padding: 20px 25px;
                border-radius: 12px;
                margin-bottom: 25px;
                display: flex;
                align-items: center;
                justify-content: space-between;
                box-shadow: 0 4px 15px rgba(74, 144, 226, 0.3);
            }

            .course-title {
                font-size: 1.4rem;
                font-weight: 600;
                margin: 0;
                display: flex;
                align-items: center;
                gap: 12px;
                color: white;
            }

            .course-title i {
                font-size: 1.2rem;
                opacity: 0.9;
            }

            /* Test card improvements */
            .test-card {
                border: 2px solid #f1f3f4;
                border-radius: 12px;
                padding: 20px;
                margin-bottom: 20px;
                transition: all 0.3s ease;
                background: #fafbfc;
                position: relative;
                overflow: hidden;
            }

            .test-card::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 4px;
                height: 100%;
                background: #ddd;
                transition: all 0.3s ease;
            }

            .test-card:hover {
                box-shadow: 0 8px 25px rgba(0,0,0,0.1);
                transform: translateY(-3px);
                border-color: #4a90e2;
            }

            /* Practice card styling */
            .practice-card::before {
                background: linear-gradient(180deg, #28a745 0%, #20c997 100%);
            }

            .practice-card .test-card-header {
                background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
                box-shadow: 0 3px 12px rgba(40, 167, 69, 0.25);
            }

            .practice-card:hover {
                border-color: #28a745;
            }

            /* Official card styling */
            .official-card::before {
                background: linear-gradient(180deg, #fd7e14 0%, #e55a4e 100%);
            }

            .official-card .test-card-header {
                background: linear-gradient(135deg, #fd7e14 0%, #e55a4e 100%);
                box-shadow: 0 3px 12px rgba(253, 126, 20, 0.25);
            }

            .official-card:hover {
                border-color: #fd7e14;
            }

            /* Taken card styling */
            .taken-card {
                background-color: #f8f9fa;
                opacity: 0.85;
            }

            .taken-card::before {
                background: linear-gradient(180deg, #6c757d 0%, #5a6268 100%);
            }

            .taken-card .test-card-header {
                background: linear-gradient(135deg, #6c757d 0%, #5a6268 100%);
                box-shadow: 0 3px 12px rgba(108, 117, 125, 0.2);
            }

            /* Test card header */
            .test-card-header {
                color: white;
                padding: 15px 18px;
                border-radius: 8px;
                margin: -10px -10px 20px -10px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .test-title {
                font-size: 1.15rem;
                font-weight: 600;
                margin: 0;
                flex: 1;
                color: white;
            }

            .test-badges {
                display: flex;
                gap: 8px;
                align-items: center;
            }

            /* Test information styling */
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
                gap: 20px;
                flex-wrap: wrap;
            }

            .test-meta span {
                display: flex;
                align-items: center;
                gap: 6px;
                padding: 4px 8px;
                background: rgba(74, 144, 226, 0.1);
                border-radius: 15px;
                font-size: 0.85rem;
                font-weight: 500;
            }

            .test-description {
                color: #495057;
                margin-bottom: 18px;
                font-size: 0.95rem;
                line-height: 1.6;
                background: rgba(74, 144, 226, 0.05);
                padding: 12px 15px;
                border-radius: 8px;
                border-left: 3px solid #4a90e2;
            }

            .chapter-info {
                background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
                color: #1565c0;
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 0.8rem;
                font-weight: 600;
                border: 1px solid rgba(21, 101, 192, 0.2);
            }

            /* Button styling */
            .btn-start {
                width: 100%;
                font-weight: 600;
                padding: 12px 20px;
                border-radius: 25px;
                transition: all 0.3s ease;
                font-size: 0.95rem;
                border: none;
                position: relative;
                overflow: hidden;
            }

            .btn-start::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
                transition: left 0.5s;
            }

            .btn-start:hover::before {
                left: 100%;
            }

            .btn-start:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(0,0,0,0.2);
            }

            /* Badge improvements */
            .badge-practice {
                background: linear-gradient(45deg, #28a745, #20c997);
                color: white;
                padding: 5px 10px;
                border-radius: 15px;
                font-size: 0.75rem;
                font-weight: 600;
                box-shadow: 0 2px 8px rgba(40, 167, 69, 0.3);
            }

            .badge-official {
                background: linear-gradient(45deg, #fd7e14, #e55a4e);
                color: white;
                padding: 5px 10px;
                border-radius: 15px;
                font-size: 0.75rem;
                font-weight: 600;
                box-shadow: 0 2px 8px rgba(253, 126, 20, 0.3);
            }

            .badge-taken {
                background: linear-gradient(45deg, #6c757d, #5a6268);
                color: white;
                padding: 5px 10px;
                border-radius: 15px;
                font-size: 0.75rem;
                font-weight: 600;
                box-shadow: 0 2px 8px rgba(108, 117, 125, 0.3);
            }

            /* Section title improvements */
            .section-title {
                color: #2c3e50;
                border-bottom: 3px solid #4a90e2;
                padding-bottom: 12px;
                margin-bottom: 25px;
                font-weight: 600;
                display: flex;
                align-items: center;
                gap: 12px;
                font-size: 1.3rem;
            }

            .section-title i {
                font-size: 1.2rem;
            }

            /* Navigation buttons */
            .nav-buttons {
                background: white;
                border-radius: 12px;
                padding: 25px;
                margin-bottom: 35px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.08);
                text-align: center;
                border: 1px solid #e8ecef;
            }

            .nav-buttons .btn {
                border-radius: 25px;
                padding: 12px 25px;
                font-weight: 600;
                transition: all 0.3s ease;
            }

            .nav-buttons .btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(0,0,0,0.15);
            }

            /* Empty state improvements */
            .empty-state {
                text-align: center;
                padding: 80px 30px;
                color: #6c757d;
                background: white;
                border-radius: 15px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.08);
                border: 1px solid #e8ecef;
            }

            .empty-state i {
                font-size: 5em;
                margin-bottom: 25px;
                color: #dee2e6;
                opacity: 0.7;
            }

            .empty-state h4 {
                color: #495057;
                margin-bottom: 15px;
                font-weight: 600;
            }

            /* Stats info improvements */
            .stats-info {
                background: linear-gradient(135deg, #e8f4f8 0%, #d1ecf1 100%);
                border-left: 4px solid #4a90e2;
                padding: 20px;
                border-radius: 10px;
                margin-bottom: 25px;
                box-shadow: 0 2px 10px rgba(74, 144, 226, 0.1);
            }

            .stats-info h6 {
                color: #2c3e50;
                font-weight: 600;
                margin-bottom: 15px;
            }

            .stats-info ul li {
                margin-bottom: 8px;
                color: #495057;
            }

            /* Course badge in header */
            .course-header .badge {
                background: rgba(255, 255, 255, 0.2);
                color: white;
                padding: 8px 15px;
                border-radius: 20px;
                font-weight: 600;
                border: 1px solid rgba(255, 255, 255, 0.3);
            }

            /* Alert styling */
            .alert {
                border-radius: 10px;
                border: none;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                margin-bottom: 25px;
            }

            /* Responsive improvements */
            @media (max-width: 768px) {
                body {
                    padding-top: 100px; /* Giảm padding cho mobile */
                }

                .page-header {
                    margin-top: 10px;
                    padding: 25px 20px;
                }

                .test-info {
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 12px;
                }

                .test-meta {
                    flex-wrap: wrap;
                    gap: 10px;
                }

                .course-title {
                    font-size: 1.2rem;
                }

                .course-header {
                    padding: 18px 20px;
                }

                .test-card {
                    padding: 18px;
                }

                .empty-state {
                    padding: 60px 20px;
                }

                .container {
                    padding-top: 10px;
                }
            }

            @media (max-width: 576px) {
                body {
                    padding-top: 90px; /* Padding nhỏ hơn cho mobile nhỏ */
                }

                .page-header {
                    margin-top: 5px;
                    padding: 20px 15px;
                }

                .course-header {
                    flex-direction: column;
                    gap: 10px;
                    text-align: center;
                }
            }

            /* Animation for course sections */
            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .course-section {
                animation: fadeInUp 0.6s ease-out;
            }

            .course-section:nth-child(2) {
                animation-delay: 0.1s;
            }
            .course-section:nth-child(3) {
                animation-delay: 0.2s;
            }
            .course-section:nth-child(4) {
                animation-delay: 0.3s;
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
                                <div class="d-flex align-items-center gap-2">
                                    <span class="badge">
                                        ${courseEntry.value.size()} bài kiểm tra
                                    </span>
                                    <c:if test="${not empty courseEntry.value}">
                                        <c:set var="firstTest" value="${courseEntry.value[0]}" />
                                        <c:if test="${firstTest.completed_tests_in_course > 0}">
                                            <span class="badge" style="background: rgba(255,255,255,0.3);">
                                                <i class="fas fa-check-circle"></i> 
                                                ${firstTest.completed_tests_in_course}/${firstTest.total_tests_in_course} hoàn thành
                                            </span>
                                        </c:if>
                                    </c:if>
                                </div>
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
        <script>
                                                           // Add smooth animations and interactions
                                                           $(document).ready(function () {
                                                               // Animate course sections on scroll
                                                               $(window).scroll(function () {
                                                                   $('.course-section').each(function () {
                                                                       var elementTop = $(this).offset().top;
                                                                       var elementBottom = elementTop + $(this).outerHeight();
                                                                       var viewportTop = $(window).scrollTop();
                                                                       var viewportBottom = viewportTop + $(window).height();

                                                                       if (elementBottom > viewportTop && elementTop < viewportBottom) {
                                                                           $(this).addClass('animate__animated animate__fadeInUp');
                                                                       }
                                                                   });
                                                               });

                                                               // Add hover effects for test cards
                                                               $('.test-card').hover(
                                                                       function () {
                                                                           $(this).find('.test-card-header').addClass('shadow-lg');
                                                                       },
                                                                       function () {
                                                                           $(this).find('.test-card-header').removeClass('shadow-lg');
                                                                       }
                                                               );

                                                               // Smooth scroll for navigation
                                                               $('a[href^="#"]').on('click', function (event) {
                                                                   var target = $(this.getAttribute('href'));
                                                                   if (target.length) {
                                                                       event.preventDefault();
                                                                       $('html, body').stop().animate({
                                                                           scrollTop: target.offset().top - 100
                                                                       }, 1000);
                                                                   }
                                                               });
                                                           });
        </script>
    </body>
</html>