<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ page import="java.io.InputStream, java.util.Base64" %>
<%@ page import="jakarta.servlet.annotation.MultipartConfig" %>

<html>
    <head>
        <title>Add Question</title>

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />

        <!-- Select2 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
        <link href="https://cdn.jsdelivr.net/npm/select2-bootstrap-5-theme@1.3.0/dist/select2-bootstrap-5-theme.min.css" rel="stylesheet" />

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
                z-index: 1;
            }

            .step-item.active {
                border-color: #0ea5e9;
                box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.1);
                z-index: 2;
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

            /* Select2 Custom Styling */
            .select2-container--bootstrap-5 .select2-selection {
                border: 2px solid #e2e8f0 !important;
                border-radius: 8px !important;
                min-height: 50px !important;
                padding: 8px 12px !important;
                font-size: 16px !important;
            }

            .select2-container--bootstrap-5 .select2-selection--single {
                height: 50px !important;
                display: flex !important;
                align-items: center !important;
            }

            .select2-container--bootstrap-5 .select2-selection--single .select2-selection__rendered {
                line-height: 34px !important;
                padding-left: 0 !important;
                padding-right: 30px !important;
                font-size: 16px !important;
                color: #374151 !important;
                text-align: center !important;
                width: 100% !important;
                display: block !important;
            }

            /* Center placeholder text specifically */
            .select2-container--bootstrap-5 .select2-selection--single .select2-selection__placeholder {
                color: #6b7280 !important;
                font-size: 16px !important;
                text-align: center !important;
                width: 100% !important;
                display: block !important;
                font-style: italic !important;
            }

            .select2-container--bootstrap-5 .select2-selection__arrow {
                height: 48px !important;
                position: absolute !important;
                top: 1px !important;
                right: 10px !important;
                width: 20px !important;
            }

            .select2-container--bootstrap-5.select2-container--focus .select2-selection {
                border-color: #0ea5e9 !important;
                box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.1) !important;
            }

            /* Dropdown styling */
            .select2-dropdown {
                border: 2px solid #0ea5e9 !important;
                border-radius: 8px !important;
                box-shadow: 0 4px 12px rgba(0,0,0,0.15) !important;
                font-size: 16px !important;
            }

            .select2-container--bootstrap-5 .select2-dropdown .select2-results__options {
                max-height: 300px !important;
            }

            .select2-container--bootstrap-5 .select2-results__option {
                padding: 12px 16px !important;
                font-size: 16px !important;
                color: #374151 !important;
                text-align: center !important;
            }

            .select2-container--bootstrap-5 .select2-results__option--highlighted {
                background-color: #0ea5e9 !important;
                color: white !important;
            }

            .select2-container--bootstrap-5 .select2-results__option[aria-selected="true"] {
                background-color: #e0f2fe !important;
                color: #0c4a6e !important;
                font-weight: 600 !important;
            }

            /* Ensure proper width */
            .select2-container {
                width: 100% !important;
            }

            /* Ensure proper z-index for dropdowns */
            .select2-container--open {
                z-index: 9999 !important;
            }

            .select2-dropdown {
                z-index: 9999 !important;
            }

            /* Fix for disabled state */
            .select2-container--bootstrap-5.select2-container--disabled .select2-selection {
                background-color: #f3f4f6 !important;
                color: #9ca3af !important;
                cursor: not-allowed !important;
            }

            .select2-container--bootstrap-5.select2-container--disabled .select2-selection--single .select2-selection__rendered {
                color: #9ca3af !important;
            }

            /* Search box in dropdown (if enabled) */
            .select2-container--bootstrap-5 .select2-search--dropdown .select2-search__field {
                border: 1px solid #d1d5db !important;
                border-radius: 6px !important;
                padding: 8px 12px !important;
                font-size: 16px !important;
                margin: 8px !important;
                width: calc(100% - 16px) !important;
            }
        </style>

    </head>

    <body class="bg-light">
        <!-- Include header -->
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
                        <select id="gradeSelect" class="form-select select2-dropdown">
                            <option value="">-- Select Grade --</option>
                            <c:forEach var="grade" items="${gradeList}">
                                <option value="${grade.id}">${grade.name}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="step-item" id="subjectStep">
                        <div class="step-number">2</div>
                        <div class="step-label">Subject</div>
                        <select id="subjectSelect" class="form-select select2-dropdown" disabled>
                            <option value="">-- Select Subject --</option>
                        </select>
                    </div>

                    <div class="step-item" id="chapterStep">
                        <div class="step-number">3</div>
                        <div class="step-label">Chapter</div>
                        <select id="chapterSelect" class="form-select select2-dropdown" disabled>
                            <option value="">-- Select Chapter --</option>
                        </select>
                    </div>

                    <div class="step-item" id="lessonStep">
                        <div class="step-number">4</div>
                        <div class="step-label">Lesson</div>
                        <select id="lessonSelect" class="form-select select2-dropdown" disabled>
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
                            <!-- Option template -->
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

        <!-- Include footer -->
        <jsp:include page="/footer.jsp" />

        <!-- JS Libraries -->
        <script src="${pageContext.request.contextPath}/assets/js/vendor/jquery-1.12.4.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/popper.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>

        <!-- Select2 JS -->
        <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

        <!-- Other JS Libraries -->
        <script src="${pageContext.request.contextPath}/assets/js/jquery.slicknav.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/owl.carousel.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/slick.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/wow.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/animated.headline.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.magnific-popup.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/gijgo.min.js"></script>
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
                        // Global Select2 configuration
                        const select2Config = {
                            theme: 'bootstrap-5',
                            width: '100%',
                            allowClear: false,
                            dropdownParent: $('body')
                        };

                        // Helper function to safely initialize Select2
                        function safeInitSelect2(selector, customConfig = {}) {
                            const $element = $(selector);

                            // Check if Select2 is already initialized and destroy it first
                            if ($element.hasClass('select2-hidden-accessible')) {
                                $element.select2('destroy');
                            }

                            // Merge configurations
                            const config = {...select2Config, ...customConfig};

                            // Initialize Select2
                            $element.select2(config);
                        }

                        // Initialize all Select2 dropdowns on page load
                        safeInitSelect2('#gradeSelect', {
                            placeholder: '-- Select Grade --'
                        });

                        safeInitSelect2('#subjectSelect', {
                            placeholder: '-- Select Subject --'
                        });

                        safeInitSelect2('#chapterSelect', {
                            placeholder: '-- Select Chapter --'
                        });

                        safeInitSelect2('#lessonSelect', {
                            placeholder: '-- Select Lesson --'
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

                        function resetSelect(selector, placeholder) {
                            const $select = $(selector);
                            $select.empty().append('<option value="">' + placeholder + '</option>');
                            $select.prop('disabled', true);

                            // Safely reinitialize Select2
                            safeInitSelect2(selector, {
                                placeholder: placeholder
                            });
                        }

                        function populateSelect(selector, data, placeholder) {
                            const $select = $(selector);
                            $select.empty().append('<option value="">' + placeholder + '</option>');

                            $.each(data, function (i, item) {
                                $select.append('<option value="' + item.id + '">' + item.name + '</option>');
                            });

                            $select.prop('disabled', false);

                            // Safely reinitialize Select2
                            safeInitSelect2(selector, {
                                placeholder: placeholder
                            });
                        }

                        // Grade selection handler
                        $('#gradeSelect').on('change', function () {
                            const gradeId = $(this).val();
                            if (gradeId) {
                                updateStepStatus('gradeStep', 'completed');
                                updateStepStatus('subjectStep', 'active');
                                currentStep = 1;
                                updateProgress();

                                // Load subjects via AJAX
                                $.get('Question', {
                                    action: 'getSubjectsByGrade',
                                    gradeId: gradeId
                                }, function (data) {
                                    populateSelect('#subjectSelect', data, '-- Select Subject --');
                                }).fail(function () {
                                    console.error('Failed to load subjects');
                                    resetSelect('#subjectSelect', '-- Select Subject --');
                                });

                                // Reset subsequent selects
                                resetSelect('#chapterSelect', '-- Select Chapter --');
                                resetSelect('#lessonSelect', '-- Select Lesson --');
                                updateStepStatus('chapterStep', '');
                                updateStepStatus('lessonStep', '');
                                $('#questionFormSection').removeClass('active');
                            }
                        });

                        // Subject selection handler
                        $('#subjectSelect').on('change', function () {
                            const subjectId = $(this).val();
                            if (subjectId) {
                                updateStepStatus('subjectStep', 'completed');
                                updateStepStatus('chapterStep', 'active');
                                currentStep = 2;
                                updateProgress();

                                // Load chapters via AJAX
                                $.get('Question', {
                                    action: 'getChaptersBySubject',
                                    subjectId: subjectId
                                }, function (data) {
                                    populateSelect('#chapterSelect', data, '-- Select Chapter --');
                                }).fail(function () {
                                    console.error('Failed to load chapters');
                                    resetSelect('#chapterSelect', '-- Select Chapter --');
                                });

                                // Reset subsequent selects
                                resetSelect('#lessonSelect', '-- Select Lesson --');
                                updateStepStatus('lessonStep', '');
                                $('#questionFormSection').removeClass('active');
                            }
                        });

                        // Chapter selection handler
                        $('#chapterSelect').on('change', function () {
                            const chapterId = $(this).val();
                            if (chapterId) {
                                updateStepStatus('chapterStep', 'completed');
                                updateStepStatus('lessonStep', 'active');
                                currentStep = 3;
                                updateProgress();

                                // Load lessons via AJAX
                                $.get('Question', {
                                    action: 'getLessonsByChapter',
                                    chapterId: chapterId
                                }, function (data) {
                                    populateSelect('#lessonSelect', data, '-- Select Lesson --');
                                }).fail(function () {
                                    console.error('Failed to load lessons');
                                    resetSelect('#lessonSelect', '-- Select Lesson --');
                                });

                                $('#questionFormSection').removeClass('active');
                            }
                        });

                        // Lesson selection handler
                        $('#lessonSelect').on('change', function () {
                            const lessonId = $(this).val();
                            if (lessonId) {
                                updateStepStatus('lessonStep', 'completed');
                                currentStep = 4;
                                updateProgress();

                                $('#selectedLessonId').val(lessonId);
                                showQuestionForm();
                            }
                        });

                        // Dynamic option management functions
                        function updateOptionInputs() {
                            const type = $('input[name="question_type"]:checked').val();
                            const options = $('#options-container .option-row');

                            if (type === 'SINGLE') {
                                // For single choice, use radio buttons
                                options.find('.option-correct').each(function (i, el) {
                                    $(el).attr('type', 'radio');
                                    $(el).attr('name', 'correctOption');
                                    $(el).val(i);
                                });
                            } else {
                                // For multiple choice, use checkboxes
                                options.find('.option-correct').each(function (i, el) {
                                    $(el).attr('type', 'checkbox');
                                    $(el).attr('name', 'correctOption' + i);
                                    $(el).val('true');
                                });
                            }
                        }

                        // Add new option handler
                        $('#btn-add-option').click(function () {
                            const type = $('input[name="question_type"]:checked').val();
                            const options = $('#options-container .option-row');
                            const idx = options.length;

                            let newOption;
                            if (type === 'SINGLE') {
                                newOption = `<div class="option-row d-flex align-items-center mb-2">
                            <input type="text" name="optionContent" class="form-control me-2 option-content" placeholder="Option content" required style="max-width: 350px;">
                            <input type="radio" name="correctOption" class="form-check-input me-1 option-correct" value="${idx}">
                            <span class="me-2 correct-label">Correct</span>
                            <button type="button" class="btn btn-danger btn-sm btn-remove-option">&times;</button>
                        </div>`;
                            } else {
                                newOption = `<div class="option-row d-flex align-items-center mb-2">
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

                        // Remove option handler
                        $('#options-container').on('click', '.btn-remove-option', function () {
                            if ($('#options-container .option-row').length > 2) {
                                $(this).closest('.option-row').remove();
                                updateRemoveButtons();
                                updateOptionInputs();
                            }
                        });

                        // Question type change handler
                        $('input[name="question_type"]').change(function () {
                            updateOptionInputs();
                        });

                        // Update remove button states
                        function updateRemoveButtons() {
                            const options = $('#options-container .option-row');
                            if (options.length <= 2) {
                                options.find('.btn-remove-option').prop('disabled', true);
                            } else {
                                options.find('.btn-remove-option').prop('disabled', false);
                            }
                        }

                        // Initialize page state
                        updateRemoveButtons();
                        updateOptionInputs();
                        updateProgress();
                    });

                    // Form validation function
                    function validateForm() {
                        let valid = true;

                        const form = document.forms["questionForm"];
                        const questionInput = form["question"];
                        const lessonId = document.getElementById("selectedLessonId").value;
                        const questionError = document.getElementById("questionError");
                        const optionError = document.getElementById("optionError");

                        // Clear previous error messages
                        questionError.textContent = "";
                        optionError.textContent = "";

                        // Validate question input
                        if (questionInput.value.trim() === "") {
                            questionError.textContent = "You must input the question.";
                            valid = false;
                        }

                        // Validate lesson selection
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

                        // Validate correct answer selection
                        let hasCorrect = false;
                        const type = document.querySelector('input[name="question_type"]:checked').value;

                        if (type === 'SINGLE') {
                            hasCorrect = document.querySelector('input[name="correctOption"]:checked') !== null;
                        } else {
                            options.forEach(function (opt, i) {
                                if (opt.querySelector('.option-correct').checked) {
                                    hasCorrect = true;
                                }
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