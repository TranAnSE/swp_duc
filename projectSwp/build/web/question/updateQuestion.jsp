<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
    <head>
        <title>Update Question</title>

        <!-- Bootstrap 5 CSS -->
        <link rel="stylesheet" href="/assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="/assets/css/fontawesome-all.min.css">
        <link rel="stylesheet" href="/assets/css/nice-select.css">
        <link rel="stylesheet" href="/assets/css/style.css">

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

            /* Hierarchy Section Styles */
            .hierarchy-section {
                background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
                border: 2px solid #0ea5e9;
                border-radius: 16px;
                padding: 25px;
                margin-bottom: 30px;
                box-shadow: 0 4px 15px rgba(14, 165, 233, 0.1);
            }

            .hierarchy-title {
                color: #0c4a6e;
                font-weight: 700;
                font-size: 1.3rem;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .hierarchy-steps {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 20px;
            }

            .step-item {
                background: white;
                border: 2px solid #e2e8f0;
                border-radius: 12px;
                padding: 15px;
                transition: all 0.3s ease;
            }

            .step-item.completed {
                border-color: #10b981;
                background: linear-gradient(135deg, #ecfdf5 0%, #d1fae5 100%);
            }

            .step-label {
                font-weight: 600;
                color: #374151;
                margin-bottom: 8px;
            }
        </style>
    </head>

    <body class="bg-light">
        <jsp:include page="/header.jsp" />

        <div class="container mt-5 mb-5">
            <h2 class="mb-4">Update Question</h2>

            <!-- Current Learning Path Display -->
            <c:if test="${not empty selectedGrade}">
                <div class="hierarchy-section">
                    <div class="hierarchy-title">
                        <i class="fas fa-sitemap"></i>
                        Current Learning Path
                    </div>

                    <div class="hierarchy-steps">
                        <div class="step-item completed">
                            <div class="step-label">Grade</div>
                            <div>${selectedGrade.name}</div>
                        </div>
                        <c:if test="${not empty selectedSubject}">
                            <div class="step-item completed">
                                <div class="step-label">Subject</div>
                                <div>${selectedSubject.name}</div>
                            </div>
                        </c:if>
                        <c:if test="${not empty selectedChapter}">
                            <div class="step-item completed">
                                <div class="step-label">Chapter</div>
                                <div>${selectedChapter.name}</div>
                            </div>
                        </c:if>
                        <c:if test="${not empty selectedLesson}">
                            <div class="step-item completed">
                                <div class="step-label">Lesson</div>
                                <div>${selectedLesson.name}</div>
                            </div>
                        </c:if>
                    </div>

                    <div class="alert alert-info mt-3">
                        <i class="fas fa-info-circle me-2"></i>
                        To change the learning path, please create a new question or contact administrator.
                    </div>
                </div>
            </c:if>

            <!-- Update Form -->
            <div class="card">
                <div class="card-body">
                    <form name="questionForm" method="post" action="Question" enctype="multipart/form-data" onsubmit="return validateForm()">
                        <input type="hidden" name="action" value="update" />
                        <input type="hidden" name="id" value="${question.id}" />
                        <input type="hidden" name="lesson_id" value="${question.lesson_id}" />

                        <div class="mb-3">
                            <label class="form-label">Question</label>
                            <input type="text" class="form-control" name="question" value="${question.question}" />
                            <span id="questionError" class="error-msg"></span>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Upload New Image (Optional)</label>
                            <input type="file" class="form-control" name="image_file" accept="image/*" />
                            <div class="form-text">Leave empty to keep current image</div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Question Type</label>
                            <div>
                                <input type="radio" id="single" name="question_type" value="SINGLE" 
                                       ${question.question_type == 'SINGLE' ? 'checked' : ''}>
                                <label for="single">Single Choice</label>
                                <input type="radio" id="multiple" name="question_type" value="MULTIPLE" 
                                       ${question.question_type == 'MULTIPLE' ? 'checked' : ''}>
                                <label for="multiple">Multiple Choice</label>
                            </div>
                        </div>

                        <!-- Options Section -->
                        <div class="mb-3">
                            <label class="form-label">Options</label>
                            <div id="options-container">
                                <c:forEach var="option" items="${options}" varStatus="status">
                                    <div class="option-row d-flex align-items-center mb-2">
                                        <input type="text" name="optionContent" class="form-control me-2 option-content" 
                                               value="${option.content}" required style="max-width: 350px;">
                                        <c:choose>
                                            <c:when test="${question.question_type == 'SINGLE'}">
                                                <input type="radio" name="correctOption" class="form-check-input me-1 option-correct" 
                                                       value="${status.index}" ${option.is_correct ? 'checked' : ''}>
                                            </c:when>
                                            <c:otherwise>
                                                <input type="checkbox" name="correctOption${status.index}" 
                                                       class="form-check-input me-1 option-correct" 
                                                       value="true" ${option.is_correct ? 'checked' : ''}>
                                            </c:otherwise>
                                        </c:choose>
                                        <span class="me-2 correct-label">Correct</span>
                                        <button type="button" class="btn btn-danger btn-sm btn-remove-option" 
                                                ${fn:length(options) <= 2 ? 'disabled' : ''}>&times;</button>
                                    </div>
                                </c:forEach>
                            </div>
                            <button type="button" class="btn btn-success btn-sm mt-2" id="btn-add-option">+ Add Option</button>
                            <span id="optionError" class="error-msg"></span>
                        </div>

                        <button type="submit" class="btn btn-primary">Update Question</button>
                        <a href="Question" class="btn btn-secondary ms-2">Back to Question List</a>
                    </form>
                </div>
            </div>
        </div>

        <jsp:include page="/footer.jsp" />

        <!-- JS Libraries -->
        <script src="${pageContext.request.contextPath}/assets/js/vendor/jquery-1.12.4.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>

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

                            // Add option
                            $('#btn-add-option').click(function () {
                                const type = $('input[name="question_type"]:checked').val();
                                const options = $('#options-container .option-row');
                                const idx = options.length;
                                if (type === 'SINGLE') {
                                    var newOption = `<div class="option-row d-flex align-items-center mb-2">
                        <input type="text" name="optionContent" class="form-control me-2 option-content" placeholder="Option content" required style="max-width: 350px;">
                        <input type="radio" name="correctOption" class="form-check-input me-1 option-correct" value="${idx}">
                        <span class="me-2 correct-label">Correct</span>
                        <button type="button" class="btn btn-danger btn-sm btn-remove-option">&times;</button>
                    </div>`;
                                } else {
                                    var newOption = `<div class="option-row d-flex align-items-center mb-2">
                        <input type="text" name="optionContent" class="form-control me-2 option-content" placeholder="Option content" required style="max-width: 350px;">
                        <input type="checkbox" name="correctOption${idx}" class="form-check-input me-1 option-correct" value="true">
                        <span class="me-2 correct-label">Correct</span>
                        <button type="button" class="btn btn-danger btn-sm btn-remove-option">&times;</button>
                    </div>`;
                                }
                                $('#options-container').append(newOption);
                                updateRemoveButtons();
                                updateOptionInputs();
                            });

                            // Remove option
                            $('#options-container').on('click', '.btn-remove-option', function () {
                                if ($('#options-container .option-row').length > 2) {
                                    $(this).closest('.option-row').remove();
                                    updateRemoveButtons();
                                    updateOptionInputs();
                                }
                            });

                            // Change question type
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

                        function validateForm() {
                            let valid = true;

                            const form = document.forms["questionForm"];
                            const questionInput = form["question"];
                            const questionError = document.getElementById("questionError");
                            const optionError = document.getElementById("optionError");

                            questionError.textContent = "";
                            optionError.textContent = "";

                            if (questionInput.value.trim() === "") {
                                questionError.textContent = "You must input the question.";
                                valid = false;
                            }

                            // Validate options
                            const options = document.querySelectorAll('.option-row');
                            if (options.length < 2) {
                                optionError.textContent = "Must have at least 2 options.";
                                valid = false;
                            }
                            let hasCorrect = false;
                            const type = document.querySelector('input[name="question_type"]:checked').value;
                            if (type === 'SINGLE') {
                                hasCorrect = document.querySelector('input[name="correctOption"]:checked') !== null;
                            } else {
                                options.forEach(function (opt, i) {
                                    if (opt.querySelector('.option-correct').checked)
                                        hasCorrect = true;
                                });
                            }
                            if (!hasCorrect) {
                                optionError.textContent = "Must select at least 1 correct answer.";
                                valid = false;
                            }
                            return valid;
                        }
        </script>
    </body>
</html>