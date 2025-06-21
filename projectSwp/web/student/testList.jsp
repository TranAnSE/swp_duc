<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html class="no-js" lang="zxx">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Danh sách Test & Practice</title>
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
            .test-card {
                border: 1px solid #ddd;
                border-radius: 8px;
                padding: 20px;
                margin-bottom: 20px;
                transition: box-shadow 0.3s ease;
            }

            .test-card:hover {
                box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            }

            .practice-card {
                border-left: 4px solid #28a745;
            }

            .official-card {
                border-left: 4px solid #dc3545;
            }

            .taken-card {
                background-color: #f8f9fa;
                opacity: 0.7;
            }

            .btn-start {
                width: 100%;
                margin-top: 10px;
            }

            .section-title {
                color: #333;
                border-bottom: 2px solid #007bff;
                padding-bottom: 8px;
                margin-bottom: 20px;
            }

            .badge-practice {
                background-color: #28a745;
            }

            .badge-official {
                background-color: #dc3545;
            }

            .nav-buttons {
                margin-bottom: 30px;
            }
        </style>
    </head>
    <body>
        <%@include file="../header.jsp" %>
        <main>
            <!-- Test List Section -->
            <section class="container mt-4">
                <!-- Breadcrumb -->
                <nav aria-label="breadcrumb" class="mb-4">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="/">Home</a></li>
                        <li class="breadcrumb-item active">Tests & Practice</li>
                    </ol>
                </nav>

                <div class="row">
                    <div class="col-12">
                        <h2>Bài Test & Luyện Tập</h2>

                        <!-- Navigation Buttons -->
                        <div class="nav-buttons">
                            <a href="${pageContext.request.contextPath}/student/taketest?action=history" 
                               class="btn btn-info">
                                <i class="fa fa-history"></i> Lịch sử làm bài
                            </a>
                        </div>

                        <c:if test="${not empty error}">
                            <div class="alert alert-danger" role="alert">
                                ${error}
                            </div>
                        </c:if>

                        <!-- Practice Tests Section -->
                        <div class="row">
                            <div class="col-12">
                                <h3 class="section-title">
                                    <i class="fa fa-play-circle text-success"></i> 
                                    Luyện Tập (Practice)
                                </h3>

                                <c:if test="${empty practiceTests}">
                                    <div class="alert alert-info">
                                        Hiện tại chưa có bài luyện tập nào.
                                    </div>
                                </c:if>

                                <div class="row">
                                    <c:forEach var="test" items="${practiceTests}">
                                        <div class="col-lg-6 col-md-12">
                                            <div class="test-card practice-card">
                                                <div class="d-flex justify-content-between align-items-start">
                                                    <h5 class="card-title">${test.name}</h5>
                                                    <span class="badge badge-practice">Practice</span>
                                                </div>

                                                <p class="card-text text-muted">${test.description}</p>

                                                <div class="test-info">
                                                    <small class="text-muted">
                                                        <i class="fa fa-folder"></i> 
                                                        Danh mục: ${categoryMap[test.category_id]}
                                                    </small>
                                                </div>

                                                <a href="${pageContext.request.contextPath}/student/taketest?action=start&testId=${test.id}" 
                                                   class="btn btn-success btn-start">
                                                    <i class="fa fa-play"></i> Bắt đầu luyện tập
                                                </a>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>

                        <!-- Official Tests Section -->
                        <div class="row mt-4">
                            <div class="col-12">
                                <h3 class="section-title">
                                    <i class="fa fa-certificate text-danger"></i> 
                                    Kiểm Tra Chính Thức (Official Test)
                                </h3>

                                <c:if test="${empty officialTests}">
                                    <div class="alert alert-info">
                                        Hiện tại chưa có bài kiểm tra chính thức nào.
                                    </div>
                                </c:if>

                                <div class="row">
                                    <c:forEach var="test" items="${officialTests}">
                                        <div class="col-lg-6 col-md-12">
                                            <div class="test-card official-card ${takenTests[test.id] ? 'taken-card' : ''}">
                                                <div class="d-flex justify-content-between align-items-start">
                                                    <h5 class="card-title">${test.name}</h5>
                                                    <div>
                                                        <span class="badge badge-official">Official</span>
                                                        <c:if test="${takenTests[test.id]}">
                                                            <span class="badge badge-secondary ml-1">Đã làm</span>
                                                        </c:if>
                                                    </div>
                                                </div>

                                                <p class="card-text text-muted">${test.description}</p>

                                                <div class="test-info">
                                                    <small class="text-muted">
                                                        <i class="fa fa-folder"></i> 
                                                        Danh mục: ${categoryMap[test.category_id]}
                                                    </small>
                                                </div>

                                                <c:choose>
                                                    <c:when test="${takenTests[test.id]}">
                                                        <button class="btn btn-secondary btn-start" disabled>
                                                            <i class="fa fa-check"></i> Đã hoàn thành
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a href="${pageContext.request.contextPath}/student/taketest?action=start&testId=${test.id}" 
                                                           class="btn btn-danger btn-start"
                                                           onclick="return confirm('Bài kiểm tra chính thức chỉ được làm 1 lần. Bạn có chắc chắn muốn bắt đầu?')">
                                                            <i class="fa fa-edit"></i> Bắt đầu kiểm tra
                                                        </a>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
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