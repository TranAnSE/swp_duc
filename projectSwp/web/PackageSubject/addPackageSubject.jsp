<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Thêm PackageSubject</title>

    <!-- CSS -->
    <link rel="stylesheet" href="/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="/assets/css/nice-select.css">
    <link rel="stylesheet" href="/assets/css/style.css">

    <style>
        html, body {
            height: 100%;
            margin: 0;
            padding: 0;
        }

        body {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            background-color: #f8f9fa;
        }

        main {
            flex: 1;
            padding-top: 80px;
        }

        .card {
            margin-bottom: 40px;
        }

        .text-danger {
            font-size: 0.875rem;
        }
    </style>
</head>
<body>

<%@include file="../header.jsp" %>

<main>
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card shadow-sm">
                    <div class="card-header bg-success text-white text-center">
                        <h5 class="mb-0">Thêm PackageSubject Mới</h5>
                    </div>
                    <div class="card-body">
                        <form id="packageForm" action="packageSubjectURL" method="post" onsubmit="return validatePackageForm()">
                            <input type="hidden" name="action" value="insert">

                            <div class="mb-3">
                                <label for="package_id" class="form-label">Package ID</label>
                                <input type="number" class="form-control" id="package_id" name="package_id" placeholder="Nhập ID của package">
                                <div id="packageError" class="text-danger"></div>
                            </div>

                            <div class="mb-3">
                                <label for="subject_id" class="form-label">Subject</label>
                                <select id="subject_id" name="subject_id" class="form-select nice-select wide">
                                    <option value="">-- Chọn Subject --</option>
                                    <c:forEach items="${subjectName}" var="sub">
                                        <option value="${sub.id}">${sub.name}</option>
                                    </c:forEach>
                                </select>
                                <div id="subjectError" class="text-danger"></div>
                            </div>

                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-success">Thêm</button>
                                <a href="packageSubjectURL" class="btn btn-outline-secondary">Quay lại danh sách</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<%@include file="../footer.jsp" %>

<!-- JS -->
<script src="/assets/js/jquery-1.12.4.min.js"></script>
<script src="/assets/js/bootstrap.min.js"></script>
<script src="/assets/js/jquery.nice-select.min.js"></script>
<script>
    $(document).ready(function () {
        $('select').niceSelect();
    });

    function validatePackageForm() {
        let isValid = true;

        document.getElementById("packageError").innerText = "";
        document.getElementById("subjectError").innerText = "";

        const packageId = document.getElementById("package_id").value.trim();
        const subjectId = document.getElementById("subject_id").value;

        if (packageId === "") {
            document.getElementById("packageError").innerText = "Vui lòng nhập Package ID.";
            isValid = false;
        }

        if (subjectId === "") {
            document.getElementById("subjectError").innerText = "Vui lòng chọn một Subject.";
            isValid = false;
        }

        return isValid;
    }
</script>

</body>
</html>
