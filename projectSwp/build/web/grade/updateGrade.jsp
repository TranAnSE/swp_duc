<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Update Grade</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="assets/css/nice-select.css" />
    <link rel="stylesheet" href="assets/css/style.css" />

    <style>
        .error-msg {
            color: red;
            font-size: 0.9em;
        }
    </style>

    <!-- jQuery + nice-select -->
    <script src="assets/js/vendor/jquery-1.12.4.min.js"></script>
    <script src="assets/js/jquery.nice-select.min.js"></script>
</head>

<body class="bg-light">
    <!-- ✅ Include Header -->
    <jsp:include page="../header.jsp" />

    <div class="container mt-5 mb-5">
        <h2 class="mb-4">Update Grade</h2>

        <c:if test="${empty grade}">
            <div class="alert alert-danger">Grade not found!</div>
            <a href="Grade" class="btn btn-secondary">Back to Grade List</a>
        </c:if>

        <c:if test="${not empty grade}">
            <form name="gradeForm" method="post" action="Grade" onsubmit="return validateForm()" class="needs-validation">
                <input type="hidden" name="action" value="update" />

                <div class="mb-3">
                    <label for="id" class="form-label">ID</label>
                    <input type="number" class="form-control" name="id" value="${grade.id}" readonly />
                </div>

                <div class="mb-3">
                    <label for="name" class="form-label">Name</label>
                    <input type="text" class="form-control" name="name" value="${grade.name}" />
                    <span id="nameError" class="error-msg"></span>
                </div>

                <div class="mb-3">
                    <label for="description" class="form-label">Description</label>
                    <input type="text" class="form-control" name="description" value="${grade.description}" />
                </div>

                <div class="mb-3">
                    <label for="teacher_id" class="form-label">Teacher</label>
                    <select name="teacher_id" class="form-select">
                        <option value="0">-- Select Teacher --</option>
                        <c:forEach var="teacher" items="${accounts}">
                            <option value="${teacher.id}" ${teacher.id == grade.teacher_id ? 'selected' : ''}>
                                ${teacher.full_name}
                            </option>
                        </c:forEach>
                    </select>
                    <span id="teacherError" class="error-msg"></span>
                </div>

                <button type="submit" class="btn btn-primary">Update Grade</button>
                <a href="Grade" class="btn btn-secondary ms-2">Cancel</a>
            </form>
        </c:if>
    </div>

    <!-- ✅ Include Footer -->
    <jsp:include page="../footer.jsp" />

    <!-- Form Validation -->
    <script>
        function validateForm() {
            let valid = true;

            const nameInput = document.forms["gradeForm"]["name"];
            const teacherSelect = document.forms["gradeForm"]["teacher_id"];
            const nameError = document.getElementById("nameError");
            const teacherError = document.getElementById("teacherError");

            nameError.textContent = "";
            teacherError.textContent = "";

            if (nameInput.value.trim() === "") {
                nameError.textContent = "You must input the name.";
                valid = false;
            }

            if (teacherSelect.value === "" || teacherSelect.value === "0") {
                teacherError.textContent = "You must select a teacher.";
                valid = false;
            }

            return valid;
        }

        $(document).ready(function () {
            $('select').niceSelect(); // Kích hoạt dropdown đẹp nếu dùng nice-select
        });
    </script>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
