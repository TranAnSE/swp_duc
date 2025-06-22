<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Danh sách bài học</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- CSS -->
        <link rel="stylesheet" href="/assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="/assets/css/style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
        <style>
            .content-preview {
                max-width: 250px;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
            }
        </style>
    </head>
    <body>
        <jsp:include page="/header.jsp" />

        <!-- Thêm khoảng cách tránh bị header che -->
        <div style="height: 100px;"></div>

        <main class="container my-4">
            <h2 class="mb-4 text-primary">Danh sách bài học</h2>

            <!-- Search -->
            <form method="get" action="LessonURL" class="row g-2 mb-3">
                <div class="col-auto">
                    <input type="text" name="name" class="form-control" placeholder="Tìm theo tên">
                </div>
                <div class="col-auto">
                    <button type="submit" class="btn btn-primary">Tìm</button>
                </div>
            </form>

            <!-- Alerts -->
            <c:if test="${not empty message}">
                <div class="alert alert-success">${message}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <!-- Add New -->
            <div class="mb-3">
                <a href="LessonURL?action=addForm" class="btn btn-success">Thêm bài học mới</a>
            </div>

            <!-- Table -->
            <table class="table table-bordered table-hover bg-white">
                <thead class="table-primary">
                    <tr>
                        <th>ID</th>
                        <th>Tên</th>
                        <th>Nội dung</th>
                        <th>Chapter</th>
                        <th>Video</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="lesson" items="${lessonList}">
                        <tr>
                            <td>${lesson.id}</td>
                            <td>${lesson.name}</td>
                            <td>
                                <div class="content-preview">${lesson.content}</div>
                            </td>
                            <td>
                                <c:forEach var="chap" items="${chapter}">
                                    <c:if test="${lesson.chapter_id eq chap.id}">
                                        ${chap.name}
                                    </c:if>
                                </c:forEach>
                            </td>
                            <td>
                                <c:if test="${not empty lesson.video_link}">
                                    <span class="badge bg-success"><i class="fas fa-video"></i> Có video</span>
                                </c:if>
                                <c:if test="${empty lesson.video_link}">
                                    <span class="badge bg-secondary">Không có video</span>
                                </c:if>
                            </td>
                            <td>
                                <c:if test="${not empty lesson.video_link}">
                                    <a href="/video-viewer?lessonId=${lesson.id}" class="btn btn-sm btn-success">
                                        <i class="fas fa-play"></i> Watch
                                    </a>
                                </c:if>
                                <a href="LessonURL?action=view&id=${lesson.id}" class="btn btn-sm btn-info">
                                    <i class="fas fa-eye"></i> View
                                </a>
                                <a href="LessonURL?action=updateForm&id=${lesson.id}" class="btn btn-sm btn-warning">
                                    <i class="fas fa-edit"></i> Edit
                                </a>
                                <a href="LessonURL?action=delete&id=${lesson.id}" class="btn btn-sm btn-danger"
                                   onclick="return confirm('Are you sure you want to delete this lesson?')">
                                    <i class="fas fa-trash"></i> Delete
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </main>

        <jsp:include page="/footer.jsp" />

        <!-- JS -->
        <script src="/assets/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
