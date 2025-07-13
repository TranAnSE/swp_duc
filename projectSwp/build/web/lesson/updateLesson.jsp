<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Cập nhật bài học</title>
        <meta charset="UTF-8">

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
        <link rel="stylesheet" href="/assets/css/style.css">
        <!-- Select2 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
        <style>
            html, body {
                height: 100%;
                margin: 0;
            }

            .page-wrapper {
                display: flex;
                flex-direction: column;
                min-height: 100vh;
                padding-top: 80px; /* tránh header che nội dung */
            }

            main {
                flex: 1;
            }

            footer {
                flex-shrink: 0;
            }

            .video-preview {
                max-width: 100%;
                margin-top: 10px;
            }

            .current-video {
                margin-top: 10px;
                padding: 10px;
                background-color: #f8f9fa;
                border-radius: 5px;
            }
        </style>
    </head>
    <body>

        <div class="page-wrapper">
            <jsp:include page="/header.jsp" />

            <main class="container py-5">
                <div class="row justify-content-center">
                    <div class="col-md-6">
                        <div class="card shadow-sm">
                            <div class="card-header bg-warning text-dark text-center">
                                <h5 class="mb-0">Cập nhật bài học</h5>
                            </div>
                            <div class="card-body">
                                <form action="LessonURL" method="post" enctype="multipart/form-data">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="id" value="${lesson.id}">
                                    <!-- Return navigation hidden fields -->
                                    <c:if test="${not empty returnTo}">
                                        <input type="hidden" name="returnTo" value="${returnTo}">
                                    </c:if>
                                    <c:if test="${not empty courseId}">
                                        <input type="hidden" name="courseId" value="${courseId}">
                                    </c:if>
                                    <div class="mb-3">
                                        <label for="name" class="form-label">Tên bài học</label>
                                        <input type="text" id="name" name="name" class="form-control" value="${lesson.name}" required>
                                    </div>

                                    <div class="mb-3">
                                        <label for="content" class="form-label">Nội dung</label>
                                        <textarea id="content" name="content" class="form-control" rows="4" required>${lesson.content}</textarea>
                                    </div>

                                    <div class="mb-3">
                                        <label for="chapter_id" class="form-label">Chapter</label>
                                        <select name="chapter_id" id="chapter_id" class="form-select" required>
                                            <c:forEach items="${chapter}" var="chap">
                                                <option value="${chap.id}" <c:if test="${lesson.chapter_id == chap.id}">selected</c:if>>
                                                    ${chap.name}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label">Video hiện tại</label>
                                        <c:if test="${not empty lesson.video_link}">
                                            <div class="current-video">
                                                <p><strong>Link:</strong> ${lesson.video_link}</p>
                                                <video class="video-preview" controls>
                                                    <source src="${lesson.video_link}" type="video/mp4">
                                                    Trình duyệt của bạn không hỗ trợ phát video.
                                                </video>
                                            </div>
                                        </c:if>
                                        <c:if test="${empty lesson.video_link}">
                                            <p class="text-muted">Chưa có video</p>
                                        </c:if>
                                    </div>

                                    <div class="mb-3">
                                        <label for="video_file" class="form-label">Thay thế video</label>
                                        <input type="file" id="video_file" name="video_file" class="form-control" accept="video/*" onchange="previewVideo(this)">
                                        <div class="form-text">Tải lên video mới để thay thế video hiện tại (nếu có)</div>
                                        <video id="videoPreview" class="video-preview" style="display: none;" controls></video>
                                    </div>

                                    <div class="d-grid gap-2">
                                        <button type="submit" class="btn btn-warning">
                                            <i class="fas fa-save"></i> Update Lesson
                                        </button>
                                        <c:choose>
                                            <c:when test="${not empty returnUrl}">
                                                <a href="${pageContext.request.contextPath}/${returnUrl}" class="btn btn-outline-secondary">
                                                    <i class="fas fa-arrow-left"></i> ${returnLabel}
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="LessonURL" class="btn btn-outline-secondary">
                                                    <i class="fas fa-arrow-left"></i> Back to Lesson List
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </main>

            <jsp:include page="/footer.jsp" />
        </div>
        <!-- Select2 JS -->
        <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
        <script src="assets/js/select2-utils.js"></script>
        <script>
                                            function previewVideo(input) {
                                                const videoPreview = document.getElementById('videoPreview');
                                                if (input.files && input.files[0]) {
                                                    const file = input.files[0];

                                                    // Check file size (max 100MB)
                                                    if (file.size > 100 * 1024 * 1024) {
                                                        alert("File quá lớn. Vui lòng chọn file nhỏ hơn 100MB.");
                                                        input.value = "";
                                                        videoPreview.style.display = "none";
                                                        return;
                                                    }

                                                    // Create URL for video preview
                                                    const videoURL = URL.createObjectURL(file);
                                                    videoPreview.src = videoURL;
                                                    videoPreview.style.display = "block";
                                                } else {
                                                    videoPreview.style.display = "none";
                                                }
                                            }

                                            $(document).ready(function () {
                                                initializeSelect2ForElement('#chapter_id', {
                                                    placeholder: '-- Chọn Chapter --'
                                                });
                                            });
        </script>
    </body>
</html>
