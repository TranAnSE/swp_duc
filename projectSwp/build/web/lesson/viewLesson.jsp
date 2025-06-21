<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
    <head>
        <title>${lesson.name}</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <!-- Bootstrap & Style -->
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
            html, body {
                height: 100%;
                margin: 0;
                padding: 0;
            }

            .page-wrapper {
                display: flex;
                flex-direction: column;
                min-height: 100vh;
                padding-top: 80px;
            }

            main {
                flex: 1;
            }

            footer {
                flex-shrink: 0;
            }
            
            .lesson-video {
                width: 100%;
                max-height: 500px;
                margin-bottom: 20px;
                border-radius: 8px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            }
            
            .lesson-content {
                background-color: #fff;
                padding: 25px;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                margin-bottom: 20px;
            }
            
            .lesson-title {
                margin-bottom: 25px;
                border-bottom: 2px solid #f0f0f0;
                padding-bottom: 15px;
                color: #333;
            }
            
            .content-text {
                font-size: 16px;
                line-height: 1.8;
                color: #444;
                white-space: pre-line;
            }
            
            .action-buttons {
                margin-top: 30px;
            }
        </style>
    </head>
    <body>
        <div class="page-wrapper">
            <jsp:include page="/header.jsp" />

            <main class="container py-4">
                <div class="row">
                    <div class="col-12">
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="LessonURL">Danh sách bài học</a></li>
                                <li class="breadcrumb-item active" aria-current="page">${lesson.name}</li>
                            </ol>
                        </nav>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col-lg-8 mx-auto">
                        <div class="lesson-content">
                            <h2 class="lesson-title">${lesson.name}</h2>
                            
                            <!-- Video Section -->
                            <c:if test="${not empty lesson.video_link}">
                                <div class="video-container">
                                    <video class="lesson-video" controls>
                                        <source src="${lesson.video_link}" type="video/mp4">
                                        Trình duyệt của bạn không hỗ trợ phát video.
                                    </video>
                                </div>
                            </c:if>
                            
                            <!-- Content Section -->
                            <div class="content-text">
                                ${lesson.content}
                            </div>
                            
                            <!-- Action Buttons -->
                            <div class="action-buttons d-flex justify-content-between">
                                <a href="LessonURL" class="btn btn-outline-secondary">
                                    <i class="fas fa-arrow-left"></i> Quay lại danh sách
                                </a>
                                
                                <c:if test="${sessionScope.account.role eq 'TEACHER' or sessionScope.account.role eq 'ADMIN'}">
                                    <a href="LessonURL?action=updateForm&id=${lesson.id}" class="btn btn-warning">
                                        <i class="fas fa-edit"></i> Chỉnh sửa
                                    </a>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </main>

            <jsp:include page="/footer.jsp" />
        </div>

        <script src="/assets/js/bootstrap.min.js"></script>
    </body>
</html> 