<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi tiết Gói Học</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        body {
            padding-top: 130px;
            background-color: #f8f9fa;
        }
        main {
            max-width: 600px;
            margin: 40px auto;
            background: #ffffff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h2 {
            text-align: center;
            margin-bottom: 30px;
            font-weight: bold;
            color: #343a40;
        }
        .form-label {
            font-weight: bold;
        }
    </style>
</head>
<body>

<%@include file="../header.jsp" %>

<main>
    <h2>Chi tiết Gói Học</h2>

    <c:if test="${not empty studyPackageDetail}">
        <div class="mb-3">
            <label class="form-label">ID:</label>
            <div class="form-control">${studyPackageDetail.id}</div>
        </div>
        <div class="mb-3">
            <label class="form-label">Tên:</label>
            <div class="form-control">${studyPackageDetail.name}</div>
        </div>
        <div class="mb-3">
            <label class="form-label">Giá:</label>
            <div class="form-control">${studyPackageDetail.price} VNĐ</div>
        </div>

        <form action="study_package" method="post" onsubmit="return confirm('Xác nhận thanh toán?')">
            <input type="hidden" name="service" value="checkout" />
            <input type="hidden" name="id" value="${studyPackageDetail.id}" />
            <div class="d-grid gap-2 mt-4">
                <button type="submit" class="btn btn-success">Thanh toán</button>
                <a href="study_package" class="btn btn-outline-secondary">← Quay lại danh sách</a>
            </div>
        </form>
    </c:if>

    <c:if test="${empty studyPackageDetail}">
        <div class="alert alert-warning text-center">
            Không tìm thấy thông tin gói học.
        </div>
    </c:if>
</main>

<%@include file="../footer.jsp" %>

<!-- JS -->
<script src="${pageContext.request.contextPath}/assets/js/vendor/jquery-1.12.4.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
