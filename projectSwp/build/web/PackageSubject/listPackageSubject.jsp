<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Danh sách PackageSubject</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
        <style>
            body {
                padding-top: 130px;
            }
            main {
                max-width: 1000px;
                margin: 0 auto;
                background-color: #f8f9fa;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            }
            h2 {
                text-align: center;
                font-weight: 700;
                color: #343a40;
                margin-bottom: 30px;
            }
            .btn-custom {
                margin: 0 5px;
            }
        </style>
    </head>
    <body>
        <%@include file="../header.jsp" %>
        <main>
            <h2>Danh sách PackageSubject</h2>

            <c:if test="${not empty error}">
                <div class="alert alert-danger text-center">${error}</div>
            </c:if>
            <c:if test="${not empty message}">
                <div class="alert alert-success text-center">${message}</div>
            </c:if>

            <div class="mb-3 text-right">
                <a href="packageSubjectURL?action=addForm" class="btn btn-success">+ Thêm mới</a>
            </div>

            <div class="table-responsive">
                <table class="table table-bordered table-hover bg-white">
                    <thead class="thead-dark">
                        <tr>
                            <th>Package ID</th>
                            <th>Subject Name</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty list}">
                                <c:forEach var="item" items="${list}">
                                    <tr>
                                        <td>${item.package_id}</td>
                                        <td>
                                            <c:forEach var="sub" items="${subject}">
                                                <c:if test="${item.subject_id eq sub.id}">
                                                    ${sub.name}
                                                </c:if>
                                            </c:forEach>
                                        </td>
                                        <td>
                                            <a href="packageSubjectURL?action=updateForm&package_id=${item.package_id}&subject_id=${item.subject_id}" 
                                               class="btn btn-primary btn-sm btn-custom">Sửa</a>

                                            <a href="packageSubjectURL?action=delete&package_id=${item.package_id}&subject_id=${item.subject_id}"
                                               onclick="return confirm('Bạn có chắc chắn muốn xóa không?')"
                                               class="btn btn-danger btn-sm btn-custom">Xóa</a>
                                            <a href="study_package?service=detail&id=${item.package_id}"
                                               class="btn btn-info btn-sm btn-custom">Xem Gói</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="3" class="text-center">Không có dữ liệu.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </main>
        <%@include file="../footer.jsp" %>
        <!-- JS -->
        <script src="${pageContext.request.contextPath}/assets/js/vendor/modernizr-3.5.0.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/vendor/jquery-1.12.4.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/popper.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.slicknav.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/owl.carousel.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/slick.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/wow.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/animated.headline.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.magnific-popup.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/gijgo.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.nice-select.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.sticky.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.barfiller.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.counterup.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/waypoints.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.countdown.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/hover-direction-snake.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/contact.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.form.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.validate.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/mail-script.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.ajaxchimp.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/plugins.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>

    </body>
</html>