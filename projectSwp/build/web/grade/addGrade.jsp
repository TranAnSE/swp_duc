<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
    <head>
        <title>Add Grade</title>

        <!-- Bootstrap CSS + Plugin CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
        <link rel="stylesheet" href="assets/css/style.css" />
        <!-- Select2 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
        <style>
            .error-msg {
                color: red;
                font-size: 0.9em;
            }
        </style>

        <script src="assets/js/vendor/jquery-1.12.4.min.js"></script>
    </head>

    <body>
        <!-- Include header -->
        <jsp:include page="../header.jsp" />

        <div class="container mt-5">
            <h2 class="mb-4">Add New Grade</h2>

            <form name="gradeForm" method="post" action="Grade" onsubmit="return validateForm()">
                <input type="hidden" name="action" value="insert" />

                <div class="mb-3">
                    <label for="name" class="form-label">Name</label>
                    <input type="text" class="form-control" name="name" />
                    <span id="nameError" class="error-msg"></span>
                </div>

                <div class="mb-3">
                    <label for="description" class="form-label">Description</label>
                    <input type="text" class="form-control" name="description" />
                </div>

                <div class="mb-3">
                    <label for="teacher_id" class="form-label">Teacher</label>
                    <select name="teacher_id" class="form-select nice-select">
                        <option value="">-- Select Teacher --</option>
                        <c:forEach var="acc" items="${accounts}">
                            <option value="${acc.id}">${acc.full_name}</option>
                        </c:forEach>
                    </select>
                    <span id="teacherError" class="error-msg"></span>
                </div>

                <button type="submit" class="btn btn-success">Add Grade</button>
                <a href="Grade" class="btn btn-secondary ms-2">Back to Grade List</a>
            </form>
        </div>

        <!-- Include footer -->
        <jsp:include page="../footer.jsp" />
        <!-- Select2 JS -->
        <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
        <script src="assets/js/select2-utils.js"></script>
        <!-- Gọi lại nice-select sau khi footer và toàn trang đã load -->
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

                    if (teacherSelect.value === "") {
                        teacherError.textContent = "You must select a teacher.";
                        valid = false;
                    }

                    return valid;
                }

                // Initialize Select2 when document is ready
                $(document).ready(function () {
                    initializeSelect2ForElement('select[name="teacher_id"]', {
                        placeholder: '-- Select Teacher --'
                    });
                });
        </script>
    </body>
</html>
