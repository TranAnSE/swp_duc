<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ page import="java.io.InputStream, java.util.Base64" %>
<%@ page import="jakarta.servlet.annotation.MultipartConfig" %>

<html>
    <head>
        <title>Add Question</title>

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
        <link rel="stylesheet" href="assets/css/nice-select.css" />
        <link rel="stylesheet" href="assets/css/style.css" />

        <!-- CSS Libraries -->
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

            /* Hierarchy Selection Styles */
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
                margin-bottom: 20px;
            }

            .step-item {
                background: white;
                border: 2px solid #e2e8f0;
                border-radius: 12px;
                padding: 15px;
                transition: all 0.3s ease;
                position: relative;
            }

            .step-item.active {
                border-color: #0ea5e9;
                box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.1);
            }

            .step-item.completed {
                border-color: #10b981;
                background: linear-gradient(135deg, #ecfdf5 0%, #d1fae5 100%);
            }

            .step-number {
                position: absolute;
                top: -10px;
                left: 15px;
                background: #0ea5e9;
                color: white;
                width: 24px;
                height: 24px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 0.8rem;
                font-weight: 600;
            }

            .step-item.completed .step-number {
                background: #10b981;
            }

            .step-label {
                font-weight: 600;
                color: #374151;
                margin-bottom: 8px;
                margin-top: 5px;
            }

            .question-form-section {
                background: white;
                border-radius: 16px;
                padding: 30px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                display: none;
            }

            .question-form-section.active {
                display: block;
                animation: fadeInUp 0.5s ease;
            }

            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .progress-bar-custom {
                height: 6px;
                background: #e2e8f0;
                border-radius: 3px;
                overflow: hidden;
                margin-bottom: 20px;
            }

            .progress-fill {
                height: 100%;
                background: linear-gradient(90deg, #0ea5e9, #10b981);
                width: 0%;
                transition: width 0.5s ease;
            }

            .nice-select {
                position: relative !important;
                z-index: 999 !important;
            }

            .nice-select .list {
                position: absolute !important;
                top: 100% !important;
                left: 0 !important;
                right: 0 !important;
                background: white !important;
                border: 1px solid #ddd !important;
                border-radius: 4px !important;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1) !important;
                max-height: 200px !important;
                overflow-y: auto !important;
                display: none !important;
            }

            .nice-select.open .list {
                display: block !important;
            }

            .nice-select .option {
                padding: 8px 12px !important;
                cursor: pointer !important;
            }

            .nice-select .option:hover {
                background-color: #f8f9fa !important;
            }
        </style>
    </head>

    <body class="bg-light">
        <!-- ✅ Include header đúng chỗ -->
        <jsp:include page="/header.jsp" />

        <div class="container mt-5 mb-5">
            <h2 class="mb-4">Add New Question</h2>

            <!-- Method Selection -->
            <div class="text-center mb-4">
                <h3>Choose Question Creation Method</h3>
                <div class="btn-group" role="group">
                    <a href="Question?action=addForm" class="btn btn-outline-primary active">
                        <i class="fas fa-keyboard"></i> Manual Entry
                    </a>
                    <a href="/ai-question?action=form" class="btn btn-outline-primary">
                        <i class="fas fa-cogs"></i> AI Generator
                    </a>
                </div>
            </div>

            <!-- Hierarchy Selection Section -->
            <div class="hierarchy-section">
                <div class="hierarchy-title">
                    <i class="fas fa-sitemap"></i>
                    Step 1: Select Learning Path
                </div>

                <div class="progress-bar-custom">
                    <div class="progress-fill" id="hierarchyProgress"></div>
                </div>

                <div class="hierarchy-steps">
                    <div class="step-item" id="gradeStep">
                        <div class="step-number">1</div>
                        <div class="step-label">Grade</div>
                        <select id="gradeSelect" class="form-select">
                            <option value="">-- Select Grade --</option>
                            <c:forEach var="grade" items="${gradeList}">
                                <option value="${grade.id}">${grade.name}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="step-item" id="subjectStep">
                        <div class="step-number">2</div>
                        <div class="step-label">Subject</div>
                        <select id="subjectSelect" class="form-select" disabled>
                            <option value="">-- Select Subject --</option>
                        </select>
                    </div>

                    <div class="step-item" id="chapterStep">
                        <div class="step-number">3</div>
                        <div class="step-label">Chapter</div>
                        <select id="chapterSelect" class="form-select" disabled>
                            <option value="">-- Select Chapter --</option>
                        </select>
                    </div>

                    <div class="step-item" id="lessonStep">
                        <div class="step-number">4</div>
                        <div class="step-label">Lesson</div>
                        <select id="lessonSelect" class="form-select" disabled>
                            <option value="">-- Select Lesson --</option>
                        </select>
                    </div>
                </div>

                <div class="alert alert-info">
                    <i class="fas fa-info-circle me-2"></i>
                    Please complete the learning path selection above before creating your question.
                </div>
            </div>

            <!-- Question Form Section -->
            <div class="question-form-section" id="questionFormSection">
                <form name="questionForm" method="post" action="Question" enctype="multipart/form-data" onsubmit="return validateForm()">
                    <input type="hidden" name="action" value="insert" />
                    <input type="hidden" name="lesson_id" id="selectedLessonId" />

                    <div class="mb-3">
                        <label class="form-label">Question</label>
                        <input type="text" class="form-control" name="question" />
                        <span id="questionError" class="error-msg"></span>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Upload Image</label>
                        <input type="file" class="form-control" name="image_file" accept="image/*" />
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Question Type</label>
                        <div>
                            <input type="radio" id="single" name="question_type" value="SINGLE" checked>
                            <label for="single">Single Choice</label>
                            <input type="radio" id="multiple" name="question_type" value="MULTIPLE">
                            <label for="multiple">Multiple Choice</label>
                        </div>
                    </div>

                    <!-- Option List -->
                    <div class="mb-3">
                        <label class="form-label">Options</label>
                        <div id="options-container">
                            <!-- Option template, sẽ được clone bằng JS -->
                            <div class="option-row d-flex align-items-center mb-2">
                                <input type="text" name="optionContent" class="form-control me-2 option-content" placeholder="Option content" required style="max-width: 350px;">
                                <input type="radio" name="correctOption" class="form-check-input me-1 option-correct" value="0" checked>
                                <span class="me-2 correct-label">Correct</span>
                                <button type="button" class="btn btn-danger btn-sm btn-remove-option" disabled>&times;</button>
                            </div>
                            <div class="option-row d-flex align-items-center mb-2">
                                <input type="text" name="optionContent" class="form-control me-2 option-content" placeholder="Option content" required style="max-width: 350px;">
                                <input type="radio" name="correctOption" class="form-check-input me-1 option-correct" value="1">
                                <span class="me-2 correct-label">Correct</span>
                                <button type="button" class="btn btn-danger btn-sm btn-remove-option" disabled>&times;</button>
                            </div>
                        </div>
                        <button type="button" class="btn btn-success btn-sm mt-2" id="btn-add-option">+ Add Option</button>
                        <span id="optionError" class="error-msg"></span>
                    </div>

                    <button type="submit" class="btn btn-primary">Add Question</button>
                    <a href="Question" class="btn btn-secondary ms-2">Back to Question List</a>
                </form>
            </div>
        </div>

        <!-- ✅ Include footer đúng chỗ -->
        <jsp:include page="/footer.jsp" />

        <!-- JS Libraries -->
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

        <script>
                    $(document).ready(function () {
                        // Destroy existing nice-select instances
                        $('select').niceSelect('destroy');

                        // Reinitialize nice-select
                        $('select').niceSelect();

                        $('.nice-select').on('click', function () {
                            $(this).toggleClass('open');
                        });

                        // Hierarchy selection logic
                        let currentStep = 0;
                        const totalSteps = 4;

                        function updateProgress() {
                            const progress = (currentStep / totalSteps) * 100;
                            $('#hierarchyProgress').css('width', progress + '%');
                        }

                        function updateStepStatus(stepId, status) {
                            const step = $('#' + stepId);
                            step.removeClass('active completed');
                            if (status === 'active') {
                                step.addClass('active');
                            } else if (status === 'completed') {
                                step.addClass('completed');
                            }
                        }

                        function showQuestionForm() {
                            $('#questionFormSection').addClass('active');
                            $('html, body').animate({
                                scrollTop: $('#questionFormSection').offset().top - 100
                            }, 500);
                        }

                        // Grade selection
                        $('#gradeSelect').change(function () {
                            const gradeId = $(this).val();
                            if (gradeId) {
                                updateStepStatus('gradeStep', 'completed');
                                updateStepStatus('subjectStep', 'active');
                                currentStep = 1;
                                updateProgress();

                                // Load subjects
                                $.get('Question', {
                                    action: 'getSubjectsByGrade',
                                    gradeId: gradeId
                                }, function (data) {
                                    $('#subjectSelect').empty().append('<option value="">-- Select Subject --</option>');
                                    $.each(data, function (i, subject) {
                                        $('#subjectSelect').append('<option value="' + subject.id + '">' + subject.name + '</option>');
                                    });
                                    $('#subjectSelect').prop('disabled', false);
                                    $('select').niceSelect('destroy');
                                    $('select').niceSelect();
                                });

                                // Reset subsequent selects
                                $('#chapterSelect').empty().append('<option value="">-- Select Chapter --</option>').prop('disabled', true);
                                $('#lessonSelect').empty().append('<option value="">-- Select Lesson --</option>').prop('disabled', true);
                                updateStepStatus('chapterStep', '');
                                updateStepStatus('lessonStep', '');
                                $('#questionFormSection').removeClass('active');
                            }
                        });

                        // Subject selection
                        $('#subjectSelect').change(function () {
                            const subjectId = $(this).val();
                            if (subjectId) {
                                updateStepStatus('subjectStep', 'completed');
                                updateStepStatus('chapterStep', 'active');
                                currentStep = 2;
                                updateProgress();

                                // Load chapters
                                $.get('Question', {
                                    action: 'getChaptersBySubject',
                                    subjectId: subjectId
                                }, function (data) {
                                    $('#chapterSelect').empty().append('<option value="">-- Select Chapter --</option>');
                                    $.each(data, function (i, chapter) {
                                        $('#chapterSelect').append('<option value="' + chapter.id + '">' + chapter.name + '</option>');
                                    });
                                    $('#chapterSelect').prop('disabled', false);
                                    $('select').niceSelect('destroy');
                                    $('select').niceSelect();
                                });

                                // Reset subsequent selects
                                $('#lessonSelect').empty().append('<option value="">-- Select Lesson --</option>').prop('disabled', true);
                                updateStepStatus('lessonStep', '');
                                $('#questionFormSection').removeClass('active');
                            }
                        });

                        // Chapter selection
                        $('#chapterSelect').change(function () {
                            const chapterId = $(this).val();
                            if (chapterId) {
                                updateStepStatus('chapterStep', 'completed');
                                updateStepStatus('lessonStep', 'active');
                                currentStep = 3;
                                updateProgress();

                                // Load lessons
                                $.get('Question', {
                                    action: 'getLessonsByChapter',
                                    chapterId: chapterId
                                }, function (data) {
                                    $('#lessonSelect').empty().append('<option value="">-- Select Lesson --</option>');
                                    $.each(data, function (i, lesson) {
                                        $('#lessonSelect').append('<option value="' + lesson.id + '">' + lesson.name + '</option>');
                                    });
                                    $('#lessonSelect').prop('disabled', false);
                                    $('select').niceSelect('destroy');
                                    $('select').niceSelect();
                                });

                                $('#questionFormSection').removeClass('active');
                            }
                        });

                        // Lesson selection
                        $('#lessonSelect').change(function () {
                            const lessonId = $(this).val();
                            if (lessonId) {
                                updateStepStatus('lessonStep', 'completed');
                                currentStep = 4;
                                updateProgress();

                                $('#selectedLessonId').val(lessonId);
                                showQuestionForm();
                            }
                        });

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
                        updateProgress();
                    });

                    function validateForm() {
                        let valid = true;

                        const form = document.forms["questionForm"];
                        const questionInput = form["question"];
                        const lessonId = document.getElementById("selectedLessonId").value;
                        const questionError = document.getElementById("questionError");
                        const optionError = document.getElementById("optionError");

                        questionError.textContent = "";
                        optionError.textContent = "";

                        if (questionInput.value.trim() === "") {
                            questionError.textContent = "You must input the question.";
                            valid = false;
                        }

                        if (!lessonId) {
                            alert("Please complete the learning path selection first.");
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