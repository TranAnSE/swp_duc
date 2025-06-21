<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
    <head>
        <title>Update Question</title>

        <!-- Bootstrap 5 CSS -->
         <!-- jQuery + nice-select -->
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

        <jsp:include page="/header.jsp" />

        <style>
            .error-msg {
                color: red;
                font-size: 0.875em;
            }
            
            body {
                display: flex;
                flex-direction: column;
                min-height: 100vh;
                font-family: Arial, sans-serif;
                background-color: #f9f9f9;
                padding-top: 120px;
            }
        </style>

        <script>
            function validateForm() {
                let valid = true;

                const form = document.forms["updateForm"];
                const questionInput = form["question"];
                const lessonSelect = form["lesson_id"];
                const questionError = document.getElementById("questionError");
                const lessonError = document.getElementById("lessonError");

                questionError.textContent = "";
                lessonError.textContent = "";

                if (questionInput.value.trim() === "") {
                    questionError.textContent = "You must input the question.";
                    valid = false;
                }

                if (lessonSelect.value === "") {
                    lessonError.textContent = "You must select a lesson.";
                    valid = false;
                }

                return valid;
            }
        </script>
    </head>

    <body class="bg-light">
                <jsp:include page="/header.jsp" />

        <div class="container mt-5 mb-5">
            <h2 class="mb-4">Update Question</h2>

            <form name="updateForm" method="post" action="Question" enctype="multipart/form-data" onsubmit="return validateForm()">
                <input type="hidden" name="action" value="update" />

                <div class="mb-3">
                    <label class="form-label">ID</label>
                    <input type="number" name="id" class="form-control" value="${question.id}" readonly />
                </div>

                <div class="mb-3">
                    <label class="form-label">Question</label>
                    <input type="text" name="question" class="form-control" value="${question.question}" />
                    <span id="questionError" class="error-msg"></span>
                </div>

                <div class="mb-3">
                    <label class="form-label">Upload New Image (optional)</label>
                    <input type="file" name="image_file" class="form-control" accept="image/*" />
                </div>

                <div class="mb-3">
                    <label class="form-label">Lesson</label>
                    <select name="lesson_id" class="form-select">
                        <option value="">-- Select Lesson --</option>
                        <c:forEach var="l" items="${les}">
                            <option value="${l.id}" <c:if test="${l.id == question.lesson_id}">selected</c:if>>${l.name}</option>
                        </c:forEach>
                    </select>
                    <span id="lessonError" class="error-msg"></span>
                </div>

                <div class="mb-3">
                    <label class="form-label">Loại câu hỏi</label>
                    <div>
                        <input type="radio" id="single" name="question_type" value="SINGLE" <c:if test="${question.question_type == 'SINGLE'}">checked</c:if>>
                            <label for="single">Single Choice</label>
                            <input type="radio" id="multiple" name="question_type" value="MULTIPLE" <c:if test="${question.question_type == 'MULTIPLE'}">checked</c:if>>
                            <label for="multiple">Multiple Choice</label>
                        </div>
                    </div>

                    <!-- Option List -->
                    <div class="mb-3">
                        <label class="form-label">Options</label>
                        <div id="options-container">
                        <c:forEach var="opt" items="${options}" varStatus="oStatus">
                            <div class="option-row d-flex align-items-center mb-2">
                                <input type="text" name="optionContent" class="form-control me-2 option-content" placeholder="Option content" required style="max-width: 350px;" value="${opt.content}">
                                <c:choose>
                                    <c:when test="${question.question_type == 'SINGLE'}">
                                        <input type="radio" name="correctOption" class="form-check-input me-1 option-correct" value="${oStatus.index}" <c:if test="${opt.is_correct}">checked</c:if>>
                                    </c:when>
                                    <c:otherwise>
                                        <input type="checkbox" name="correctOption${oStatus.index}" class="form-check-input me-1 option-correct" value="true" <c:if test="${opt.is_correct}">checked</c:if>>
                                    </c:otherwise>
                                </c:choose>
                                <span class="me-2 correct-label">Đúng</span>
                                <button type="button" class="btn btn-danger btn-sm btn-remove-option" <c:if test="${fn:length(options) <= 2}">disabled</c:if>>&times;</button>
                                </div>
                        </c:forEach>
                    </div>
                    <button type="button" class="btn btn-success btn-sm mt-2" id="btn-add-option">+ Thêm option</button>
                    <span id="optionError" class="error-msg"></span>
                </div>

                <button type="submit" class="btn btn-primary">Update Question</button>
                <a href="Question" class="btn btn-secondary ms-2">Back to Question List</a>
            </form>
        </div>

        <jsp:include page="/footer.jsp" />

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="../assets/js/vendor/jquery-1.12.4.min.js"></script>
        <script>
                $(document).ready(function () {
                    // Option dynamic logic
                    function updateOptionInputs() {
                        const type = $('input[name="question_type"]:checked').val();
                        const options = $('#options-container .option-row');
                        if (type === 'SINGLE') {
                            options.find('.option-correct').each(function (i, el) {
                                $(el).attr('type', 'radio');
                                $(el).attr('name', 'correctOption');
                                $(el).val(i);
                            });
                        } else {
                            options.find('.option-correct').each(function (i, el) {
                                $(el).attr('type', 'checkbox');
                                $(el).attr('name', 'correctOption' + i);
                                $(el).val('true');
                            });
                        }
                    }
                    // Thêm option mới
                    $('#btn-add-option').click(function () {
                        const type = $('input[name="question_type"]:checked').val();
                        const options = $('#options-container .option-row');
                        const idx = options.length;
                        if (type === 'SINGLE') {
                            var newOption = `<div class="option-row d-flex align-items-center mb-2">
                            <input type="text" name="optionContent" class="form-control me-2 option-content" placeholder="Option content" required style="max-width: 350px;">
                            <input type="radio" name="correctOption" class="form-check-input me-1 option-correct" value="${idx}">
                            <span class="me-2 correct-label">Đúng</span>
                            <button type="button" class="btn btn-danger btn-sm btn-remove-option">&times;</button>
                        </div>`;
                        } else {
                            var newOption = `<div class="option-row d-flex align-items-center mb-2">
                            <input type="text" name="optionContent" class="form-control me-2 option-content" placeholder="Option content" required style="max-width: 350px;">
                            <input type="checkbox" name="correctOption${idx}" class="form-check-input me-1 option-correct" value="true">
                            <span class="me-2 correct-label">Đúng</span>
                            <button type="button" class="btn btn-danger btn-sm btn-remove-option">&times;</button>
                        </div>`;
                        }
                        $('#options-container').append(newOption);
                        updateRemoveButtons();
                        updateOptionInputs();
                    });
                    // Xóa option
                    $('#options-container').on('click', '.btn-remove-option', function () {
                        if ($('#options-container .option-row').length > 2) {
                            $(this).closest('.option-row').remove();
                            updateRemoveButtons();
                            updateOptionInputs();
                        }
                    });
                    // Đổi loại câu hỏi
                    $('input[name="question_type"]').change(function () {
                        updateOptionInputs();
                    });
                    function updateRemoveButtons() {
                        const options = $('#options-container .option-row');
                        if (options.length <= 2) {
                            options.find('.btn-remove-option').prop('disabled', true);
                        } else {
                            options.find('.btn-remove-option').prop('disabled', false);
                        }
                    }
                    updateRemoveButtons();
                    updateOptionInputs();
                });
        </script>
        <!-- JS Libraries -->
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
        
    </body>
</html>
