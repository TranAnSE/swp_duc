<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!doctype html>
<html class="no-js" lang="zxx">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Kết quả - ${test.name}</title>
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
            .result-header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 30px;
                border-radius: 8px;
                margin-bottom: 30px;
                text-align: center;
            }
            
            body {
                padding-top: 130px; /* Tăng khoảng cách để không bị che */
            }

            .score-container {
                background: white;
                border-radius: 8px;
                padding: 40px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
                margin-bottom: 30px;
                text-align: center;
            }

            .score-circle {
                width: 150px;
                height: 150px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 20px;
                font-size: 2.5em;
                font-weight: bold;
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

            .test-info-card {
                background: white;
                border-radius: 8px;
                padding: 25px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                margin-bottom: 20px;
            }

            .info-row {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 10px 0;
                border-bottom: 1px solid #f1f1f1;
            }

            .info-row:last-child {
                border-bottom: none;
            }

            .info-label {
                font-weight: 600;
                color: #666;
            }

            .info-value {
                color: #333;
                font-weight: 500;
            }

            .action-buttons {
                text-align: center;
                margin-top: 30px;
            }

            .action-buttons .btn {
                margin: 0 10px;
                min-width: 150px;
            }

            .badge-practice {
                background-color: #28a745;
            }

            .badge-official {
                background-color: #dc3545;
            }

            .congratulations {
                background: linear-gradient(45deg, #ff9a9e 0%, #fecfef 50%, #fecfef 100%);
                color: #333;
                padding: 20px;
                border-radius: 8px;
                margin-bottom: 20px;
                text-align: center;
            }

            .improvement-tip {
                background: #e3f2fd;
                border-left: 4px solid #2196f3;
                padding: 15px;
                border-radius: 4px;
                margin-top: 20px;
            }

            /* Styles for question details */
            .question-details {
                margin-top: 30px;
            }

            .question-card {
                background: white;
                border-radius: 8px;
                padding: 20px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                margin-bottom: 20px;
                position: relative;
            }

            .question-number {
                position: absolute;
                top: -15px;
                left: 20px;
                background: #007bff;
                color: white;
                width: 30px;
                height: 30px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: bold;
            }

            .question-content {
                margin-top: 10px;
                margin-bottom: 15px;
                font-weight: 500;
            }

            .option-item {
                padding: 10px;
                border-radius: 4px;
                margin-bottom: 8px;
                border: 1px solid #e9ecef;
            }

            .option-correct {
                background-color: #d4edda;
                border-color: #c3e6cb;
            }

            .option-incorrect {
                background-color: #f8d7da;
                border-color: #f5c6cb;
            }

            .option-regular {
                background-color: #f8f9fa;
            }

            .option-selected {
                border-left: 4px solid #007bff;
            }

            .correct-indicator {
                float: right;
                font-weight: bold;
            }

            .correct-answer {
                color: #28a745;
            }

            .incorrect-answer {
                color: #dc3545;
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
                        <li class="breadcrumb-item active">Kết quả</li>
                    </ol>
                </nav>

                <!-- Result Header -->
                <div class="result-header">
                    <h2><i class="fa fa-trophy"></i> Kết quả bài làm</h2>
                    <h4>${test.name}</h4>

                    <c:choose>
                        <c:when test="${test.is_practice}">
                            <span class="badge badge-practice badge-lg">Practice</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge badge-official badge-lg">Official Test</span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Congratulations Message -->
                <c:if test="${testRecord.score >= 8.0}">
                    <div class="congratulations">
                        <h4><i class="fa fa-star text-warning"></i> Chúc mừng!</h4>
                        <p class="mb-0">Bạn đã hoàn thành xuất sắc bài làm này!</p>
                    </div>
                </c:if>

                <!-- Score info saved successfully -->

                <!-- Score Display -->
                <div class="score-container">
                    <c:choose>
                        <c:when test="${testRecord.score >= 8.0}">
                            <div class="score-circle score-excellent">
                                <fmt:formatNumber value="${testRecord.score}" maxFractionDigits="1"/>
                            </div>
                            <h3 class="text-success">Xuất sắc!</h3>
                            <p class="text-muted">Kết quả tuyệt vời, hãy tiếp tục phát huy!</p>
                        </c:when>
                        <c:when test="${testRecord.score >= 6.5}">
                            <div class="score-circle score-good">
                                <fmt:formatNumber value="${testRecord.score}" maxFractionDigits="1"/>
                            </div>
                            <h3 class="text-info">Tốt!</h3>
                            <p class="text-muted">Kết quả khá tốt, bạn có thể làm tốt hơn nữa!</p>
                        </c:when>
                        <c:when test="${testRecord.score >= 5.0}">
                            <div class="score-circle score-average">
                                <fmt:formatNumber value="${testRecord.score}" maxFractionDigits="1"/>
                            </div>
                            <h3 class="text-warning">Trung bình</h3>
                            <p class="text-muted">Kết quả ở mức trung bình, hãy cố gắng luyện tập thêm!</p>
                        </c:when>
                        <c:otherwise>
                            <div class="score-circle score-poor">
                                <fmt:formatNumber value="${testRecord.score}" maxFractionDigits="1"/>
                            </div>
                            <h3 class="text-danger">Cần cải thiện</h3>
                            <p class="text-muted">Hãy ôn luyện thêm và thử lại nhé!</p>
                        </c:otherwise>
                    </c:choose>

                    <div class="score-details mt-3">
                        <h5>Điểm số: <span class="text-primary">
                                <fmt:formatNumber value="${testRecord.score}" maxFractionDigits="1"/>/10
                            </span></h5>
                    </div>
                </div>

                <!-- Test Information -->
                <div class="test-info-card">
                    <h5 class="mb-3"><i class="fa fa-info-circle text-primary"></i> Thông tin chi tiết</h5>

                    <div class="info-row">
                        <span class="info-label">Tên bài test:</span>
                        <span class="info-value">${test.name}</span>
                    </div>

                    <div class="info-row">
                        <span class="info-label">Loại test:</span>
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${test.is_practice}">
                                    <span class="badge badge-success">Luyện tập</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-danger">Kiểm tra chính thức</span>
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>

                    <div class="info-row">
                        <span class="info-label">Thời gian bắt đầu:</span>
                        <span class="info-value">
                            <fmt:formatDate value="${testRecord.startedAtAsDate}" pattern="dd/MM/yyyy HH:mm"/>
                        </span>
                    </div>

                    <div class="info-row">
                        <span class="info-label">Thời gian hoàn thành:</span>
                        <span class="info-value">
                            <fmt:formatDate value="${testRecord.finishAtAsDate}" pattern="dd/MM/yyyy HH:mm"/>
                        </span>
                    </div>

                    <div class="info-row">
                        <span class="info-label">Điểm số:</span>
                        <span class="info-value">
                            <strong><fmt:formatNumber value="${testRecord.score}" maxFractionDigits="1"/>/10</strong>
                        </span>
                    </div>
                </div>

                <!-- Question Details Section -->
                <h4 class="mt-5 mb-4"><i class="fa fa-list-ol text-primary"></i> Chi tiết câu trả lời</h4>
                <c:set var="questionIndex" value="0" />
                <c:forEach var="questionId" items="${questionRecordMap.keySet()}">
                    <c:set var="records" value="${questionRecordMap[questionId]}" />
                    <div class="question-card">
                        <div class="question-number">${questionIndex + 1}</div>
                        <c:set var="questionIndex" value="${questionIndex + 1}" />
                        <div class="question-content">
                            ${questionMap[questionId].question}
                        </div>
                        <!-- Question Image (if exists) -->
                        <c:if test="${questionMap[questionId].image_id != null && questionMap[questionId].image_id > 0}">
                            <c:forEach var="img" items="${images}">
                                <c:if test="${img.id == questionMap[questionId].image_id}">
                                    <img src="data:image/jpg;base64, ${img.image_data}" alt="Question Image" class="question-image mb-3" style="max-height: 200px;">
                                </c:if>
                            </c:forEach>
                        </c:if>
                        <!-- Options -->
                        <div class="options-container">
                            <c:forEach var="option" items="${optionsMap[questionId]}" varStatus="oStatus">
                                <c:set var="isCorrect" value="${option.is_correct}" />
                                <c:set var="isSelected" value="false" />
                                <c:forEach var="rec" items="${records}">
                                    <c:if test="${option.id == rec.option_id}">
                                        <c:set var="isSelected" value="true" />
                                    </c:if>
                                </c:forEach>
                                <div class="option-item
                                     <c:choose>
                                         <c:when test="${isCorrect}"> option-correct</c:when>
                                         <c:when test="${!isCorrect && isSelected}"> option-incorrect</c:when>
                                         <c:otherwise> option-regular</c:otherwise>
                                     </c:choose>
                                     <c:if test="${isSelected}"> option-selected</c:if>">
                                    <strong>${oStatus.index + 1}.</strong> ${option.content}
                                    <c:if test="${isSelected}">
                                        <span class="correct-indicator
                                              <c:choose>
                                                  <c:when test="${isCorrect}">correct-answer</c:when>
                                                  <c:otherwise>incorrect-answer</c:otherwise>
                                              </c:choose>">
                                            <i class="fa
                                               <c:choose>
                                                   <c:when test="${isCorrect}">fa-check</c:when>
                                                   <c:otherwise>fa-times</c:otherwise>
                                               </c:choose>"></i>
                                            <c:choose>
                                                <c:when test="${isCorrect}">Đúng</c:when>
                                                <c:otherwise>Sai</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </c:if>
                                    <c:if test="${isCorrect && !isSelected}">
                                        <span class="correct-indicator correct-answer">
                                            <i class="fa fa-check"></i> Đáp án đúng
                                        </span>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:forEach>

                <!-- Improvement Tips -->
                <c:if test="${testRecord.score < 7.0}">
                    <div class="improvement-tip">
                        <h6><i class="fa fa-lightbulb text-primary"></i> Gợi ý cải thiện:</h6>
                        <ul class="mb-0">
                            <li>Ôn lại các kiến thức cơ bản trong bài học</li>
                            <li>Luyện tập thêm với các bài practice khác</li>
                            <li>Đọc kỹ đề bài trước khi trả lời</li>
                            <li>Quản lý thời gian làm bài hiệu quả hơn</li>
                        </ul>
                    </div>
                </c:if>

                <!-- Action Buttons -->
                <div class="action-buttons">
                    <a href="${pageContext.request.contextPath}/student/taketest" 
                       class="btn btn-primary">
                        <i class="fa fa-list"></i> Danh sách test
                    </a>

                    <c:if test="${test.is_practice}">
                        <a href="${pageContext.request.contextPath}/student/taketest?action=start&testId=${test.id}" 
                           class="btn btn-success">
                            <i class="fa fa-redo"></i> Làm lại
                        </a>
                    </c:if>

                    <a href="${pageContext.request.contextPath}/student/taketest?action=history" 
                       class="btn btn-info">
                        <i class="fa fa-history"></i> Lịch sử làm bài
                    </a>
                </div>
            </section>
        </main>

        <%@include file="../footer.jsp" %>

        <!-- JS Libraries -->
        <script src="${pageContext.request.contextPath}/assets/js/vendor/jquery-1.12.4.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>

        <script>
            // Auto redirect after 30 seconds for official tests
            <c:if test="${!test.is_practice}">
            setTimeout(function () {
                if (confirm('Bạn có muốn quay về danh sách test không?')) {
                    window.location.href = '${pageContext.request.contextPath}/student/taketest';
                }
            }, 30000);
            </c:if>
        </script>
        
        <!-- Scroll Up -->
        <div id="back-top" >
            <a title="Go to Top" href="#"> <i class="fas fa-level-up-alt"></i></a>
        </div>

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