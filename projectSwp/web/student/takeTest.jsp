<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html class="no-js" lang="zxx">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Làm bài - ${test.name}</title>
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
            /* Main layout styles */
            .test-layout {
                display: flex;
                min-height: calc(100vh - 200px);
                gap: 20px;
            }

            /* Sidebar styles */
            .question-sidebar {
                width: 280px;
                background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
                border-radius: 12px;
                padding: 20px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
                position: sticky;
                top: 120px;
                height: fit-content;
                max-height: calc(100vh - 140px);
                overflow-y: auto;
                border: 1px solid #dee2e6;
            }

            .sidebar-title {
                font-size: 1.1em;
                font-weight: bold;
                color: #495057;
                margin-bottom: 15px;
                text-align: center;
                border-bottom: 2px solid #6c757d;
                padding-bottom: 10px;
            }

            .question-grid {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 10px;
                margin-bottom: 20px;
            }

            .question-nav-btn {
                width: 42px;
                height: 42px;
                border: 2px solid #ced4da;
                background: #ffffff;
                border-radius: 8px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: 600;
                font-size: 0.9em;
                cursor: pointer;
                transition: all 0.3s ease;
                position: relative;
                color: #495057;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }

            .question-nav-btn:hover {
                border-color: #007bff;
                background: #e3f2fd;
                transform: translateY(-1px);
                box-shadow: 0 4px 8px rgba(0,0,0,0.15);
            }

            .question-nav-btn.active {
                background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
                color: white;
                border-color: #0056b3;
                box-shadow: 0 4px 12px rgba(0,123,255,0.3);
            }

            .question-nav-btn.answered {
                background: linear-gradient(135deg, #28a745 0%, #1e7e34 100%);
                color: white;
                border-color: #1e7e34;
                box-shadow: 0 3px 8px rgba(40,167,69,0.3);
            }

            .question-nav-btn.marked {
                background: linear-gradient(135deg, #ffc107 0%, #e0a800 100%);
                color: #212529;
                border-color: #d39e00;
                font-weight: 700;
                box-shadow: 0 3px 8px rgba(255,193,7,0.3);
            }

            .question-nav-btn.answered.marked {
                background: linear-gradient(45deg, #28a745 0%, #28a745 45%, #ffc107 55%, #ffc107 100%);
                color: #212529;
                font-weight: 700;
                border: 2px solid #d39e00;
                box-shadow: 0 4px 12px rgba(255,193,7,0.4);
            }

            /* Mark icon - Improved visibility */
            .question-nav-btn .mark-icon {
                position: absolute;
                top: -8px;
                right: -8px;
                background: #dc3545;
                color: white;
                border-radius: 50%;
                width: 18px;
                height: 18px;
                font-size: 10px;
                display: none;
                align-items: center;
                justify-content: center;
                border: 2px solid white;
                box-shadow: 0 2px 4px rgba(0,0,0,0.2);
            }

            .question-nav-btn.marked .mark-icon {
                display: flex;
            }

            /* Legend */
            .sidebar-legend {
                border-top: 1px solid #dee2e6;
                padding-top: 15px;
                margin-top: 15px;
                background: rgba(255,255,255,0.7);
                border-radius: 8px;
                padding: 15px;
            }

            .legend-item {
                display: flex;
                align-items: center;
                margin-bottom: 10px;
                font-size: 0.85em;
                color: #495057;
            }

            .legend-color {
                width: 18px;
                height: 18px;
                border-radius: 4px;
                margin-right: 10px;
                border: 1px solid #dee2e6;
                box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            }

            .legend-color.current {
                background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
            }

            .legend-color.answered {
                background: linear-gradient(135deg, #28a745 0%, #1e7e34 100%);
            }

            .legend-color.marked {
                background: linear-gradient(135deg, #ffc107 0%, #e0a800 100%);
            }

            .legend-color.unanswered {
                background: #ffffff;
            }

            /* Main content area */
            .test-content {
                flex: 1;
                background: #ffffff;
                border-radius: 12px;
                padding: 30px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
                border: 1px solid #dee2e6;
            }

            /* Test header */
            .test-header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 25px;
                border-radius: 12px;
                margin-bottom: 25px;
                text-align: center;
                box-shadow: 0 4px 15px rgba(102,126,234,0.3);
                border: 1px solid rgba(255,255,255,0.1);
            }


            .test-header h3 {
                margin-bottom: 10px;
                font-size: 1.6rem;
                font-weight: 600;
                color: white;
                text-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }

            .test-header .badge {
                font-size: 0.95rem;
                padding: 8px 16px;
                border-radius: 20px;
                font-weight: 600;
                box-shadow: 0 2px 6px rgba(0,0,0,0.2);
                border: 2px solid rgba(255,255,255,0.2);
            }

            .test-header .badge-success {
                background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
                color: white;
            }

            .test-header .badge-danger {
                background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
                color: white;
            }

            .question-container {
                min-height: 400px;
                margin-bottom: 20px;
            }

            .question-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
                padding-bottom: 15px;
                border-bottom: 2px solid #e9ecef;
            }

            .question-number {
                background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
                color: white;
                width: 45px;
                height: 45px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: bold;
                font-size: 1.1em;
                box-shadow: 0 3px 8px rgba(0,123,255,0.3);
            }

            .question-info {
                flex: 1;
                margin-left: 15px;
            }

            .question-counter {
                font-size: 1em;
                color: #6c757d;
                font-weight: 500;
            }

            .question-actions {
                display: flex;
                gap: 10px;
                align-items: center;
            }

            .mark-button {
                background: linear-gradient(135deg, #ffc107 0%, #e0a800 100%);
                color: #212529;
                border: none;
                padding: 8px 15px;
                border-radius: 20px;
                font-size: 0.9em;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                gap: 5px;
                box-shadow: 0 2px 6px rgba(255,193,7,0.3);
            }

            .mark-button:hover {
                background: linear-gradient(135deg, #e0a800 0%, #d39e00 100%);
                transform: translateY(-1px);
                box-shadow: 0 4px 10px rgba(255,193,7,0.4);
            }

            .mark-button.marked {
                background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
                color: white;
                box-shadow: 0 2px 6px rgba(220,53,69,0.3);
            }

            .mark-button.marked:hover {
                background: linear-gradient(135deg, #c82333 0%, #bd2130 100%);
                box-shadow: 0 4px 10px rgba(220,53,69,0.4);
            }

            .question-text {
                font-size: 1.1em;
                color: #212529;
                margin-bottom: 25px;
                line-height: 1.6;
                background: #f8f9fa;
                padding: 20px;
                border-radius: 8px;
                border-left: 4px solid #007bff;
            }

            .option-container {
                margin-bottom: 15px;
            }

            .option-label {
                display: block;
                padding: 15px 20px;
                border: 2px solid #e9ecef;
                border-radius: 10px;
                cursor: pointer;
                transition: all 0.3s ease;
                background: #f8f9fa;
                color: #495057;
            }

            .option-label:hover {
                border-color: #007bff;
                background: #e3f2fd;
                transform: translateX(5px);
                box-shadow: 0 3px 8px rgba(0,123,255,0.2);
            }

            .option-input:checked + .option-label {
                border-color: #007bff;
                background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
                color: white;
                font-weight: 600;
                box-shadow: 0 4px 12px rgba(0,123,255,0.3);
            }

            .option-input {
                display: none;
            }

            .question-image {
                max-width: 100%;
                height: auto;
                border-radius: 10px;
                margin: 20px 0;
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            }

            .question-type-label {
                margin-bottom: 20px;
            }

            .question-type-label .badge {
                font-size: 0.9rem;
                padding: 8px 15px;
                border-radius: 20px;
            }

            .badge-primary {
                background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
            }

            .badge-warning {
                background: linear-gradient(135deg, #ffc107 0%, #e0a800 100%);
                color: #212529;
            }

            .progress-container {
                margin-bottom: 25px;
                background: #f8f9fa;
                padding: 15px;
                border-radius: 8px;
                border: 1px solid #dee2e6;
            }

            .progress {
                height: 8px;
                border-radius: 10px;
                background: #e9ecef;
            }

            .progress-bar {
                background: linear-gradient(90deg, #28a745 0%, #20c997 100%);
                border-radius: 10px;
                transition: width 0.3s ease;
            }

            .navigation-container {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-top: 30px;
                padding-top: 20px;
                border-top: 1px solid #dee2e6;
            }

            .btn-navigation {
                min-width: 120px;
                margin: 0 10px;
                border-radius: 25px;
                font-weight: 600;
                padding: 10px 20px;
                transition: all 0.3s ease;
            }

            .btn-navigation:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(0,0,0,0.2);
            }

            /* Timer styles */
            .timer-container {
                position: fixed;
                top: 90px;
                right: 20px;
                background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
                color: white;
                border-radius: 12px;
                padding: 15px 20px;
                box-shadow: 0 4px 20px rgba(220,53,69,0.3);
                z-index: 999;
                display: flex;
                flex-direction: column;
                align-items: center;
                min-width: 160px;
                border: 2px solid rgba(255,255,255,0.2);
            }

            .timer-label {
                font-size: 0.85em;
                margin-bottom: 5px;
                opacity: 0.9;
            }

            .timer-display {
                font-size: 1.8em;
                font-weight: bold;
                font-family: 'Courier New', monospace;
            }

            .timer-warning {
                animation: pulse 1s infinite;
            }

            .submit-section {
                text-align: center;
                margin-top: 40px;
                padding: 30px;
                background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
                border-radius: 12px;
                border: 2px dashed #007bff;
            }

            .submit-section h5 {
                color: #007bff;
                margin-bottom: 15px;
                font-weight: 600;
            }

            .submit-section .btn {
                border-radius: 25px;
                padding: 12px 30px;
                font-weight: 600;
                font-size: 1.1rem;
                box-shadow: 0 4px 15px rgba(40,167,69,0.3);
                transition: all 0.3s ease;
            }

            .submit-section .btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(40,167,69,0.4);
            }

            /* Responsive design */
            @media (max-width: 768px) {
                .test-layout {
                    flex-direction: column;
                }

                .question-sidebar {
                    width: 100%;
                    position: relative;
                    top: 0;
                    max-height: none;
                    margin-bottom: 20px;
                }

                .question-grid {
                    grid-template-columns: repeat(6, 1fr);
                }

                .timer-container {
                    position: relative;
                    top: 0;
                    right: 0;
                    margin-bottom: 20px;
                }
            }

            @keyframes pulse {
                0% {
                    opacity: 1;
                }
                50% {
                    opacity: 0.6;
                }
                100% {
                    opacity: 1;
                }
            }

            /* Additional improvements */
            .breadcrumb {
                background: #f8f9fa;
                border-radius: 8px;
                padding: 10px 15px;
            }

            .breadcrumb-item + .breadcrumb-item::before {
                color: #6c757d;
            }

            .alert {
                border-radius: 8px;
                border: none;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }
        </style>

        <!-- Truyền dữ liệu JSP vào JavaScript -->
        <script>
            var TOTAL_QUESTIONS = parseInt("${totalQuestions}");
            var TEST_DURATION = parseInt("${duration}");
            var TEST_START_TIME = parseInt("${startTime}");
            var IS_PRACTICE = ${isPractice};

            console.log("TOTAL_QUESTIONS:", TOTAL_QUESTIONS);
            console.log("TEST_DURATION:", TEST_DURATION, "phút");
            console.log("TEST_START_TIME:", TEST_START_TIME, "->", new Date(TEST_START_TIME));
            console.log("IS_PRACTICE:", IS_PRACTICE);
        </script>
    </head>
    <body>

        <main>
            <section class="container-fluid mt-4">
                <!-- Breadcrumb -->
                <nav aria-label="breadcrumb" class="mb-4">
                    <div class="d-flex align-items-center justify-content-between">
                        <a href="/student/taketest" class="btn btn-outline-secondary btn-sm">
                            <i class="fas fa-arrow-left"></i> Quay lại
                        </a>
                        <h4 class="m-0 font-weight-bold text-center flex-grow-1 text-muted">${test.name}</h4>
                        <div style="width: 100px;"></div>
                    </div>
                </nav>

                <!-- Timer - Chỉ hiển thị cho bài test thực sự -->
                <c:if test="${not isPractice}">
                    <div class="timer-container">
                        <div class="timer-label">Thời gian còn lại</div>
                        <div id="timer" class="timer-display">--:--</div>
                    </div>
                </c:if>

                <!-- Test Header -->
                <div class="test-header">
                    <h3>${test.name}</h3>
                    <c:choose>
                        <c:when test="${test.is_practice}">
                            <span class="badge badge-success">Luyện tập</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge badge-danger">Kiểm tra chính thức</span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Error message if exists -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger" role="alert">
                        ${error}
                    </div>
                </c:if>

                <!-- Progress Bar -->
                <div class="progress-container">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <small class="text-muted font-weight-600">
                            <i class="fas fa-chart-line"></i> Tiến độ hoàn thành
                        </small>
                        <small class="text-muted font-weight-600">
                            Đã trả lời: <span id="answeredCount" class="text-primary font-weight-bold">0</span> / ${totalQuestions}
                        </small>
                    </div>
                    <div class="progress">
                        <div class="progress-bar" role="progressbar" 
                             style="width: 0%"
                             id="progressBar"
                             aria-valuenow="0" 
                             aria-valuemin="0" 
                             aria-valuemax="${totalQuestions}">
                        </div>
                    </div>
                </div>

                <!-- Main Test Layout -->
                <div class="test-layout">
                    <!-- Question Navigation Sidebar -->
                    <div class="question-sidebar">
                        <div class="sidebar-title">
                            <i class="fas fa-list-ol"></i> Danh sách câu hỏi
                        </div>

                        <div class="question-grid" id="questionGrid">
                            <c:forEach var="question" items="${questions}" varStatus="qStatus">
                                <button class="question-nav-btn" 
                                        id="nav-btn-${qStatus.index}" 
                                        onclick="navigateToQuestion(${qStatus.index})"
                                        title="Câu ${qStatus.index + 1}">
                                    ${qStatus.index + 1}
                                    <span class="mark-icon">
                                        <i class="fas fa-star"></i>
                                    </span>
                                </button>
                            </c:forEach>
                        </div>

                        <div class="sidebar-legend">
                            <div class="legend-item">
                                <div class="legend-color current"></div>
                                <span>Đang làm</span>
                            </div>
                            <div class="legend-item">
                                <div class="legend-color answered"></div>
                                <span>Đã trả lời</span>
                            </div>
                            <div class="legend-item">
                                <div class="legend-color marked"></div>
                                <span>Đã đánh dấu</span>
                            </div>
                            <div class="legend-item">
                                <div class="legend-color unanswered"></div>
                                <span>Chưa trả lời</span>
                            </div>
                        </div>

                        <div class="mt-3 text-center">
                            <button type="button" class="btn btn-outline-info btn-sm" onclick="showMarkedQuestions()">
                                <i class="fas fa-star"></i> Xem câu đã đánh dấu
                            </button>
                        </div>
                    </div>

                    <!-- Test Content Area -->
                    <div class="test-content">
                        <form method="post" action="${pageContext.request.contextPath}/student/taketest" id="allQuestionsForm">
                            <input type="hidden" name="action" value="submit">

                            <c:forEach var="question" items="${questions}" varStatus="qStatus">
                                <div class="question-container" id="question-${qStatus.index}" style="display: none;">
                                    <div class="question-header">
                                        <div class="question-number">
                                            ${qStatus.index + 1}
                                        </div>
                                        <div class="question-info">
                                            <div class="question-counter">
                                                Câu hỏi ${qStatus.index + 1} / ${totalQuestions}
                                            </div>
                                        </div>
                                        <div class="question-actions">
                                            <button type="button" class="mark-button" 
                                                    id="mark-btn-${qStatus.index}"
                                                    onclick="toggleMark(${qStatus.index})">
                                                <i class="fas fa-star"></i>
                                                <span class="mark-text">Đánh dấu</span>
                                            </button>
                                        </div>
                                    </div>

                                    <div class="question-text">
                                        ${question.question}
                                    </div>

                                    <!-- Question Image (if exists) -->
                                    <c:if test="${question.image_id != null && question.image_id > 0}">
                                        <c:forEach var="img" items="${images}">
                                            <c:if test="${img.id == question.image_id}">
                                                <img src="data:image/jpg;base64, ${img.image_data}" alt="Question Image" class="question-image">
                                            </c:if>
                                        </c:forEach>
                                    </c:if>

                                    <!-- Question Type Label -->
                                    <div class="question-type-label mb-3">
                                        <c:choose>
                                            <c:when test="${question.question_type == 'SINGLE'}">
                                                <span class="badge badge-primary">Chọn 1 đáp án đúng</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-warning text-dark">Chọn tất cả đáp án đúng</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <!-- Options -->
                                    <input type="hidden" name="questionId${qStatus.index}" value="${question.id}">

                                    <c:forEach var="option" items="${allOptions[question.id]}" varStatus="oStatus">
                                        <div class="option-container">
                                            <c:choose>
                                                <c:when test="${question.question_type == 'SINGLE'}">
                                                    <input type="radio" 
                                                           id="option_${question.id}_${option.id}" 
                                                           name="optionId${qStatus.index}" 
                                                           value="${option.id}"
                                                           class="option-input"
                                                           data-question-index="${qStatus.index}"
                                                           onchange="updateQuestionStatus(${qStatus.index})"
                                                           <c:if test="${previousAnswers[question.id] == option.id}">checked</c:if>>
                                                </c:when>
                                                <c:otherwise>
                                                    <input type="checkbox" 
                                                           id="option_${question.id}_${option.id}" 
                                                           name="optionId${qStatus.index}" 
                                                           value="${option.id}"
                                                           class="option-input"
                                                           data-question-index="${qStatus.index}"
                                                           onchange="updateQuestionStatus(${qStatus.index})"
                                                           <c:if test="${previousAnswers[question.id] != null && previousAnswers[question.id].contains(option.id)}">checked</c:if>>
                                                </c:otherwise>
                                            </c:choose>
                                            <label for="option_${question.id}_${option.id}" class="option-label">
                                                <strong>${oStatus.index + 1}.</strong> ${option.content}
                                            </label>
                                        </div>
                                    </c:forEach>

                                    <!-- Navigation Buttons -->
                                    <div class="navigation-container">
                                        <button type="button" class="btn btn-outline-primary btn-navigation" 
                                                onclick="previousQuestion()" 
                                                ${qStatus.index == 0 ? 'disabled' : ''}>
                                            <i class="fas fa-chevron-left"></i> Câu trước
                                        </button>

                                        <div class="text-center">
                                            <span class="badge badge-pill badge-light p-3">
                                                Câu ${qStatus.index + 1} / ${totalQuestions}
                                            </span>
                                        </div>

                                        <button type="button" class="btn btn-outline-primary btn-navigation" 
                                                onclick="nextQuestion()"
                                                ${qStatus.index == totalQuestions - 1 ? 'disabled' : ''}>
                                            Câu tiếp <i class="fas fa-chevron-right"></i>
                                        </button>
                                    </div>
                                </div>
                            </c:forEach>

                            <!-- Submit Section -->
                            <div class="submit-section">
                                <h5><i class="fas fa-paper-plane"></i> Hoàn thành bài làm</h5>
                                <p class="text-muted mb-3">Hãy kiểm tra lại các câu trả lời trước khi nộp bài</p>
                                <button type="button" class="btn btn-success btn-lg px-5" onclick="validateAndSubmit()">
                                    <i class="fas fa-check"></i> Nộp bài
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </section>
        </main>
        <%@include file="../footer.jsp" %>

        <!-- JS Libraries -->
        <script src="${pageContext.request.contextPath}/assets/js/vendor/jquery-1.12.4.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>

        <!-- Custom Script -->
        <script>
                                    // Global variables
                                    let currentQuestionIndex = 0;
                                    let markedQuestions = new Set(); // Store marked question indices
                                    let timerInterval;
                                    let remainingTime;

                                    // Initialize when page loads
                                    document.addEventListener('DOMContentLoaded', function () {
                                        initializeQuestionStates();
                                        navigateToQuestion(0);
                                        updateProgress();
                                        initializeTimer();
                                    });

                                    // Navigate to specific question
                                    function navigateToQuestion(index) {
                                        if (index < 0 || index >= TOTAL_QUESTIONS)
                                            return;

                                        // Hide all questions
                                        document.querySelectorAll('.question-container').forEach(container => {
                                            container.style.display = 'none';
                                        });

                                        // Show selected question
                                        const questionContainer = document.getElementById('question-' + index);
                                        if (questionContainer) {
                                            questionContainer.style.display = 'block';
                                        }

                                        // Update current question index
                                        currentQuestionIndex = index;

                                        // Update navigation buttons states
                                        updateNavigationButtons();

                                        // Update sidebar navigation
                                        updateSidebarNavigation();

                                        // Scroll to top of content
                                        document.querySelector('.test-content').scrollTop = 0;
                                    }

                                    // Update sidebar navigation states
                                    function updateSidebarNavigation() {
                                        document.querySelectorAll('.question-nav-btn').forEach((btn, index) => {
                                            btn.classList.remove('active');
                                            if (index === currentQuestionIndex) {
                                                btn.classList.add('active');
                                            }
                                        });
                                    }

                                    // Update navigation buttons
                                    function updateNavigationButtons() {
                                        const prevBtn = document.querySelector('button[onclick="previousQuestion()"]');
                                        const nextBtn = document.querySelector('button[onclick="nextQuestion()"]');

                                        if (prevBtn) {
                                            prevBtn.disabled = (currentQuestionIndex === 0);
                                        }
                                        if (nextBtn) {
                                            nextBtn.disabled = (currentQuestionIndex === TOTAL_QUESTIONS - 1);
                                        }
                                    }

                                    // Navigate to next question
                                    function nextQuestion() {
                                        if (currentQuestionIndex < TOTAL_QUESTIONS - 1) {
                                            navigateToQuestion(currentQuestionIndex + 1);
                                        }
                                    }

                                    // Navigate to previous question
                                    function previousQuestion() {
                                        if (currentQuestionIndex > 0) {
                                            navigateToQuestion(currentQuestionIndex - 1);
                                        }
                                    }

                                    // Toggle mark for question
                                    function toggleMark(questionIndex) {
                                        const markBtn = document.getElementById('mark-btn-' + questionIndex);
                                        const navBtn = document.getElementById('nav-btn-' + questionIndex);
                                        const markText = markBtn.querySelector('.mark-text');

                                        if (markedQuestions.has(questionIndex)) {
                                            // Unmark
                                            markedQuestions.delete(questionIndex);
                                            markBtn.classList.remove('marked');
                                            navBtn.classList.remove('marked');
                                            markText.textContent = 'Đánh dấu';
                                        } else {
                                            // Mark
                                            markedQuestions.add(questionIndex);
                                            markBtn.classList.add('marked');
                                            navBtn.classList.add('marked');
                                            markText.textContent = 'Bỏ đánh dấu';
                                        }
                                    }

                                    // Show marked questions
                                    function showMarkedQuestions() {
                                        if (markedQuestions.size === 0) {
                                            alert('Bạn chưa đánh dấu câu hỏi nào!');
                                            return;
                                        }

                                        const markedList = Array.from(markedQuestions).sort((a, b) => a - b);
                                        const message = 'Các câu đã đánh dấu: ' + markedList.map(i => 'Câu ' + (i + 1)).join(', ') +
                                                '\n\nBạn có muốn chuyển đến câu đầu tiên đã đánh dấu không?';

                                        if (confirm(message)) {
                                            navigateToQuestion(markedList[0]);
                                        }
                                    }

                                    // Update question status when answer changes
                                    function updateQuestionStatus(questionIndex) {
                                        const questionContainer = document.getElementById('question-' + questionIndex);
                                        const navBtn = document.getElementById('nav-btn-' + questionIndex);

                                        // Check if question is answered
                                        const radioInputs = questionContainer.querySelectorAll('input[type="radio"]');
                                        const checkboxInputs = questionContainer.querySelectorAll('input[type="checkbox"]');

                                        let isAnswered = false;

                                        if (radioInputs.length > 0) {
                                            isAnswered = Array.from(radioInputs).some(input => input.checked);
                                        } else if (checkboxInputs.length > 0) {
                                            isAnswered = Array.from(checkboxInputs).some(input => input.checked);
                                        }

                                        // Update navigation button state
                                        if (isAnswered) {
                                            navBtn.classList.add('answered');
                                        } else {
                                            navBtn.classList.remove('answered');
                                        }

                                        // Update progress
                                        updateProgress();
                                    }

                                    // Initialize question states based on previous answers
                                    function initializeQuestionStates() {
                                        document.querySelectorAll('.question-container').forEach((container, index) => {
                                            updateQuestionStatus(index);
                                        });
                                    }

                                    // Update progress bar
                                    function updateProgress() {
                                        let answeredCount = 0;

                                        document.querySelectorAll('.question-container').forEach((container, index) => {
                                            const radioInputs = container.querySelectorAll('input[type="radio"]');
                                            const checkboxInputs = container.querySelectorAll('input[type="checkbox"]');

                                            let isAnswered = false;

                                            if (radioInputs.length > 0) {
                                                isAnswered = Array.from(radioInputs).some(input => input.checked);
                                            } else if (checkboxInputs.length > 0) {
                                                isAnswered = Array.from(checkboxInputs).some(input => input.checked);
                                            }

                                            if (isAnswered) {
                                                answeredCount++;
                                            }
                                        });

                                        document.getElementById('answeredCount').textContent = answeredCount;
                                        const progressPercent = (answeredCount / TOTAL_QUESTIONS) * 100;

                                        const progressBar = document.getElementById('progressBar');
                                        progressBar.style.width = progressPercent + '%';
                                        progressBar.setAttribute('aria-valuenow', answeredCount);
                                    }

                                    // Validate and submit form
                                    function validateAndSubmit() {
                                        let answeredCount = 0;
                                        let unansweredQuestions = [];

                                        document.querySelectorAll('.question-container').forEach((container, index) => {
                                            const radioInputs = container.querySelectorAll('input[type="radio"]');
                                            const checkboxInputs = container.querySelectorAll('input[type="checkbox"]');

                                            let isAnswered = false;

                                            if (radioInputs.length > 0) {
                                                isAnswered = Array.from(radioInputs).some(input => input.checked);
                                            } else if (checkboxInputs.length > 0) {
                                                isAnswered = Array.from(checkboxInputs).some(input => input.checked);
                                            }

                                            if (isAnswered) {
                                                answeredCount++;
                                            } else {
                                                unansweredQuestions.push(index + 1);
                                            }
                                        });

                                        if (answeredCount < TOTAL_QUESTIONS) {
                                            const message = `Bạn chưa trả lời ${TOTAL_QUESTIONS - answeredCount} câu hỏi.\n` +
                                                    `Các câu chưa trả lời: ${unansweredQuestions.join(', ')}\n\n` +
                                                    `Bạn có muốn chuyển đến câu đầu tiên chưa trả lời không?`;

                                            if (confirm(message)) {
                                                navigateToQuestion(unansweredQuestions[0] - 1);
                                            }
                                            return false;
                                        }

                                        // Show marked questions summary before submit
                                        if (markedQuestions.size > 0) {
                                            const markedList = Array.from(markedQuestions).sort((a, b) => a - b);
                                            const markedMessage = `Bạn đã đánh dấu ${markedQuestions.size} câu hỏi: ` +
                                                    markedList.map(i => 'Câu ' + (i + 1)).join(', ') +
                                                    '\n\nBạn có muốn kiểm tra lại các câu đã đánh dấu trước khi nộp bài không?';

                                            if (confirm(markedMessage)) {
                                                navigateToQuestion(markedList[0]);
                                                return false;
                                            }
                                        }

                                        if (confirm('Bạn có chắc chắn muốn nộp bài không?')) {
                                            document.getElementById('allQuestionsForm').submit();
                                        }
                                    }

                                    // Timer functions
                                    function initializeTimer() {
                                        if (IS_PRACTICE) {
                                            console.log("Practice test - no timer needed");
                                            return;
                                        }

                                        if (isNaN(TEST_DURATION) || TEST_DURATION <= 0) {
                                            console.log("Invalid TEST_DURATION:", TEST_DURATION, "- setting to 60 minutes");
                                            TEST_DURATION = 60;
                                        }

                                        if (isNaN(TEST_START_TIME) || TEST_START_TIME <= 0) {
                                            console.log("Invalid TEST_START_TIME:", TEST_START_TIME, "- setting to current time");
                                            TEST_START_TIME = new Date().getTime();
                                        }

                                        const currentTime = new Date().getTime();
                                        const elapsedTime = currentTime - TEST_START_TIME;
                                        const totalTime = TEST_DURATION * 60 * 1000;

                                        if (TEST_DURATION <= 0) {
                                            console.log("Invalid test duration: " + TEST_DURATION + " minutes. Setting to 60 minutes default.");
                                            remainingTime = 60 * 60 * 1000;
                                        } else {
                                            remainingTime = totalTime - elapsedTime;

                                            if (remainingTime <= 0) {
                                                console.log("Invalid remaining time: " + remainingTime / 60000 + " minutes. Resetting start time.");
                                                remainingTime = totalTime;
                                            }
                                        }

                                        console.log("Remaining time:", remainingTime / 60000, "minutes");

                                        updateTimerDisplay();
                                        timerInterval = setInterval(updateTimerDisplay, 1000);
                                    }

                                    function updateTimerDisplay() {
                                        remainingTime -= 1000;

                                        if (remainingTime <= 0) {
                                            clearInterval(timerInterval);
                                            autoSubmitDueToTimeout();
                                            return;
                                        }

                                        const minutes = Math.floor(remainingTime / (60 * 1000));
                                        const seconds = Math.floor((remainingTime % (60 * 1000)) / 1000);

                                        const minutesStr = (minutes < 10) ? "0" + minutes : minutes.toString();
                                        const secondsStr = (seconds < 10) ? "0" + seconds : seconds.toString();
                                        const timeString = minutesStr + ":" + secondsStr;

                                        const timerElement = document.getElementById('timer');
                                        if (timerElement) {
                                            timerElement.textContent = timeString;

                                            if (remainingTime < 5 * 60 * 1000) {
                                                timerElement.classList.add('timer-warning');
                                            }
                                        } else {
                                            console.error("Timer element not found!");
                                            clearInterval(timerInterval);
                                        }
                                    }

                                    function autoSubmitDueToTimeout() {
                                        if (IS_PRACTICE) {
                                            return;
                                        }

                                        const timerElement = document.getElementById('timer');
                                        if (timerElement) {
                                            timerElement.textContent = "00:00";
                                            timerElement.classList.add('timer-warning');
                                        }

                                        alert('Hết thời gian làm bài! Bài làm của bạn sẽ được tự động nộp.');
                                        document.getElementById('allQuestionsForm').submit();
                                    }

                                    // Keyboard shortcuts
                                    document.addEventListener('keydown', function (e) {
                                        // Only work when not typing in input fields
                                        if (e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA') {
                                            return;
                                        }

                                        switch (e.key) {
                                            case 'ArrowLeft':
                                                e.preventDefault();
                                                previousQuestion();
                                                break;
                                            case 'ArrowRight':
                                                e.preventDefault();
                                                nextQuestion();
                                                break;
                                            case 'm':
                                            case 'M':
                                                e.preventDefault();
                                                toggleMark(currentQuestionIndex);
                                                break;
                                            case 's':
                                            case 'S':
                                                if (e.ctrlKey) {
                                                    e.preventDefault();
                                                    showMarkedQuestions();
                                                }
                                                break;
                                        }
                                    });
        </script>
    </body>
</html>