<%-- 
    Document   : aiQuestionForm
    Created on : Jun 26, 2025, 10:21:36 PM
    Author     : ankha
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <title>AI Question Generator</title>
        <link rel="stylesheet" href="/assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="/assets/css/fontawesome-all.min.css">
        <link rel="stylesheet" href="/assets/css/nice-select.css">
        <link rel="stylesheet" href="/assets/css/style.css">
        <style>
            :root {
                --primary-color: #4f46e5;
                --secondary-color: #06b6d4;
                --success-color: #10b981;
                --warning-color: #f59e0b;
                --danger-color: #ef4444;
                --dark-color: #1f2937;
                --light-color: #f8fafc;
                --border-color: #e5e7eb;
                --text-primary: #111827;
                --text-secondary: #6b7280;
                --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
                --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
                --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
                --gradient-primary: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                --gradient-secondary: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            }

            body {
                padding-top: 120px;
                background: var(--gradient-primary);
                min-height: 100vh;
                font-family: 'Inter', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            .ai-form-container {
                max-width: 900px;
                margin: 0 auto;
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                padding: 40px;
                border-radius: 20px;
                box-shadow: var(--shadow-lg);
                border: 1px solid rgba(255, 255, 255, 0.2);
            }

            .page-header {
                text-align: center;
                margin-bottom: 40px;
                position: relative;
            }

            .page-header::before {
                content: '';
                position: absolute;
                top: -20px;
                left: 50%;
                transform: translateX(-50%);
                width: 100px;
                height: 4px;
                background: var(--gradient-secondary);
                border-radius: 2px;
            }

            .page-header h2 {
                color: var(--text-primary);
                font-weight: 700;
                font-size: 2.5rem;
                margin-bottom: 10px;
                background: var(--gradient-primary);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
            }

            .page-header p {
                color: var(--text-secondary);
                font-size: 1.1rem;
                margin: 0;
            }

            /* FIX: Remove overflow hidden and add padding for dropdown space */
            .form-section {
                margin-bottom: 35px;
                padding: 25px 25px 60px 25px; /* Add extra bottom padding for dropdown */
                border: 1px solid var(--border-color);
                border-radius: 16px;
                background: linear-gradient(135deg, #fafbff 0%, #f8fafc 100%);
                transition: all 0.3s ease;
                position: relative;
                /* Remove overflow: hidden to allow dropdown to show */
            }

            .form-section::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                height: 3px;
                background: var(--gradient-primary);
                opacity: 0;
                transition: opacity 0.3s ease;
            }

            .form-section:hover::before {
                opacity: 1;
            }

            .form-section:hover {
                transform: translateY(-2px);
                box-shadow: var(--shadow-md);
                border-color: var(--primary-color);
            }

            /* Special styling for sections with dropdowns */
            .form-section.has-dropdown {
                overflow: visible !important;
                padding-bottom: 80px; /* Extra space for dropdown */
            }

            .section-title {
                font-weight: 700;
                color: var(--text-primary);
                margin-bottom: 20px;
                font-size: 1.25rem;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .section-title i {
                color: var(--primary-color);
                font-size: 1.1em;
            }

            .form-control, .form-select {
                border: 2px solid var(--border-color);
                border-radius: 12px;
                padding: 12px 16px;
                font-size: 1rem;
                transition: all 0.3s ease;
                background: white;
            }

            .form-control:focus, .form-select:focus {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
                outline: none;
            }

            /* Enhanced nice-select styling with higher z-index */
            .nice-select {
                border: 2px solid var(--border-color) !important;
                border-radius: 12px !important;
                padding: 12px 16px !important;
                font-size: 1rem !important;
                background: white !important;
                height: auto !important;
                line-height: 1.5 !important;
                min-height: 48px !important;
                transition: all 0.3s ease !important;
                position: relative !important;
                z-index: 100 !important; /* Higher z-index */
                width: 100% !important;
                box-sizing: border-box !important;
            }

            .nice-select:focus,
            .nice-select.open {
                border-color: var(--primary-color) !important;
                box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1) !important;
                outline: none !important;
                z-index: 1000 !important; /* Even higher when open */
            }

            .nice-select .current {
                color: var(--text-primary) !important;
                font-size: 1rem !important;
                line-height: 1.5 !important;
                padding-right: 30px !important; /* Space for arrow */
            }

            .nice-select .list {
                background: white !important;
                border: 2px solid var(--primary-color) !important;
                border-radius: 12px !important;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2) !important; /* Stronger shadow */
                margin-top: 5px !important;
                max-height: 250px !important; /* Increased height */
                overflow-y: auto !important;
                z-index: 9999 !important; /* Very high z-index */
                position: absolute !important;
                top: 100% !important;
                left: 0 !important;
                right: 0 !important;
                display: none !important;
                width: 100% !important;
                box-sizing: border-box !important;
            }

            .nice-select.open .list {
                display: block !important;
            }

            .nice-select .option {
                padding: 12px 16px !important;
                font-size: 1rem !important;
                color: var(--text-primary) !important;
                cursor: pointer !important;
                transition: background-color 0.2s ease !important;
                border-bottom: 1px solid rgba(0, 0, 0, 0.05) !important;
            }

            .nice-select .option:last-child {
                border-bottom: none !important;
            }

            .nice-select .option:hover {
                background-color: rgba(79, 70, 229, 0.1) !important;
                color: var(--primary-color) !important;
            }

            .nice-select .option.selected {
                background-color: var(--primary-color) !important;
                color: white !important;
            }

            .nice-select::after {
                border-color: var(--text-secondary) transparent transparent !important;
                right: 16px !important;
                top: 50% !important;
                transform: translateY(-50%) !important;
                transition: transform 0.3s ease !important;
            }

            .nice-select.open::after {
                transform: translateY(-50%) rotate(180deg) !important;
            }

            /* Ensure dropdown container has proper stacking context */
            .dropdown-container {
                position: relative;
                z-index: 100;
            }

            .question-type-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 20px;
                margin-top: 15px;
            }

            .question-type-card {
                background: white;
                border: 2px solid var(--border-color);
                border-radius: 16px;
                padding: 20px;
                cursor: pointer;
                transition: all 0.3s ease;
                text-align: center;
                position: relative;
                overflow: hidden;
            }

            .question-type-card::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(79, 70, 229, 0.1), transparent);
                transition: left 0.5s ease;
            }

            .question-type-card:hover::before {
                left: 100%;
            }

            .question-type-card:hover {
                transform: translateY(-5px);
                box-shadow: var(--shadow-lg);
                border-color: var(--primary-color);
            }

            .question-type-card.selected {
                border-color: var(--primary-color);
                background: linear-gradient(135deg, rgba(79, 70, 229, 0.1) 0%, rgba(6, 182, 212, 0.1) 100%);
                box-shadow: var(--shadow-md);
            }

            .question-type-card input[type="radio"] {
                display: none;
            }

            .question-type-icon {
                font-size: 2.5rem;
                color: var(--primary-color);
                margin-bottom: 15px;
                display: block;
            }

            .question-type-title {
                font-weight: 600;
                color: var(--text-primary);
                margin-bottom: 8px;
                font-size: 1.1rem;
            }

            .question-type-description {
                color: var(--text-secondary);
                font-size: 0.9rem;
                line-height: 1.4;
            }

            .difficulty-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
                gap: 15px;
                margin-top: 15px;
            }

            .difficulty-option {
                background: white;
                border: 2px solid var(--border-color);
                border-radius: 12px;
                padding: 15px 10px;
                cursor: pointer;
                transition: all 0.3s ease;
                text-align: center;
                position: relative;
            }

            .difficulty-option:hover {
                transform: translateY(-2px);
                box-shadow: var(--shadow-sm);
            }

            .difficulty-option.selected {
                border-color: var(--primary-color);
                background: var(--primary-color);
                color: white;
            }

            .difficulty-option input[type="radio"] {
                display: none;
            }

            .difficulty-label {
                font-weight: 600;
                font-size: 0.95rem;
            }

            .lesson-preview {
                background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
                border: 1px solid #bae6fd;
                border-radius: 12px;
                padding: 20px;
                margin-top: 15px;
                max-height: 200px;
                overflow-y: auto;
            }

            .lesson-preview::-webkit-scrollbar {
                width: 6px;
            }

            .lesson-preview::-webkit-scrollbar-track {
                background: #f1f5f9;
                border-radius: 3px;
            }

            .lesson-preview::-webkit-scrollbar-thumb {
                background: #cbd5e1;
                border-radius: 3px;
            }

            .generate-btn {
                background: var(--gradient-primary);
                border: none;
                padding: 16px 40px;
                font-size: 1.2rem;
                font-weight: 600;
                border-radius: 50px;
                color: white;
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;
                box-shadow: var(--shadow-md);
            }

            .generate-btn::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
                transition: left 0.5s ease;
            }

            .generate-btn:hover::before {
                left: 100%;
            }

            .generate-btn:hover {
                transform: translateY(-3px);
                box-shadow: var(--shadow-lg);
            }

            .generate-btn:active {
                transform: translateY(-1px);
            }

            .btn-secondary {
                background: white;
                border: 2px solid var(--border-color);
                color: var(--text-secondary);
                padding: 12px 24px;
                border-radius: 12px;
                font-weight: 500;
                transition: all 0.3s ease;
            }

            .btn-secondary:hover {
                border-color: var(--primary-color);
                color: var(--primary-color);
                background: rgba(79, 70, 229, 0.05);
            }

            .form-text {
                color: var(--text-secondary);
                font-size: 0.9rem;
                margin-top: 8px;
                line-height: 1.4;
            }

            .alert {
                border: none;
                border-radius: 12px;
                padding: 16px 20px;
                margin-bottom: 25px;
            }

            .alert-danger {
                background: linear-gradient(135deg, #fef2f2 0%, #fee2e2 100%);
                color: #dc2626;
                border-left: 4px solid #ef4444;
            }

            @media (max-width: 768px) {
                .ai-form-container {
                    margin: 20px;
                    padding: 25px;
                    border-radius: 16px;
                }

                .page-header h2 {
                    font-size: 2rem;
                }

                .question-type-grid {
                    grid-template-columns: 1fr;
                }

                .difficulty-grid {
                    grid-template-columns: repeat(2, 1fr);
                }

                .generate-btn {
                    width: 100%;
                    padding: 14px 20px;
                    font-size: 1.1rem;
                }
            }

            @media (max-width: 480px) {
                body {
                    padding-top: 100px;
                }

                .ai-form-container {
                    margin: 15px;
                    padding: 20px;
                }

                .form-section {
                    padding: 20px;
                    margin-bottom: 25px;
                }

                .form-section.has-dropdown {
                    padding-bottom: 70px;
                }

                .difficulty-grid {
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </head>
    <body>
        <jsp:include page="/header.jsp" />

        <div class="container">
            <div class="ai-form-container">
                <div class="page-header">
                    <h2><i class="fas fa-robot"></i> AI Question Generator</h2>
                    <p>Generate intelligent questions with AI assistance for your lessons</p>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        ${error}
                    </div>
                </c:if>

                <form action="/ai-question" method="post" id="aiQuestionForm">
                    <input type="hidden" name="action" value="generate">

                    <!-- Lesson Selection -->
                    <div class="form-section has-dropdown">
                        <div class="section-title">
                            <i class="fas fa-book-open"></i>
                            Select Lesson
                        </div>
                        <div class="dropdown-container">
                            <select name="lesson_id" class="form-select wide" required id="lessonSelect">
                                <option value="">-- Choose a lesson to generate questions --</option>
                                <c:forEach var="lesson" items="${lessons}">
                                    <option value="${lesson.id}" data-content="${lesson.content}">
                                        ${lesson.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-text">
                            <i class="fas fa-info-circle me-1"></i>
                            Select the lesson for which you want to generate questions
                        </div>
                    </div>

                    <!-- Lesson Content Preview -->
                    <div class="form-section" id="lessonPreview" style="display: none;">
                        <div class="section-title">
                            <i class="fas fa-eye"></i>
                            Lesson Content Preview
                        </div>
                        <div id="lessonContent" class="lesson-preview">
                        </div>
                    </div>

                    <!-- Question Type Selection -->
                    <div class="form-section">
                        <div class="section-title">
                            <i class="fas fa-question-circle"></i>
                            Question Type
                        </div>
                        <div class="question-type-grid">
                            <div class="question-type-card" data-type="single_choice">
                                <input type="radio" name="question_type" value="single_choice" id="typeSingle" checked>
                                <label for="typeSingle">
                                    <i class="fas fa-dot-circle question-type-icon"></i>
                                    <div class="question-type-title">Single Choice</div>
                                    <div class="question-type-description">
                                        Multiple options with only one correct answer
                                    </div>
                                </label>
                            </div>

                            <div class="question-type-card" data-type="multiple_choice">
                                <input type="radio" name="question_type" value="multiple_choice" id="typeMultiple">
                                <label for="typeMultiple">
                                    <i class="fas fa-check-square question-type-icon"></i>
                                    <div class="question-type-title">Multiple Choice</div>
                                    <div class="question-type-description">
                                        Multiple options with multiple correct answers
                                    </div>
                                </label>
                            </div>

                            <div class="question-type-card" data-type="true_false">
                                <input type="radio" name="question_type" value="true_false" id="typeTrueFalse">
                                <label for="typeTrueFalse">
                                    <i class="fas fa-balance-scale question-type-icon"></i>
                                    <div class="question-type-title">True / False</div>
                                    <div class="question-type-description">
                                        Simple true or false questions
                                    </div>
                                </label>
                            </div>
                        </div>
                    </div>

                    <!-- Question Settings -->
                    <div class="form-section has-dropdown">
                        <div class="section-title">
                            <i class="fas fa-cogs"></i>
                            Question Settings
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <label for="numberOfQuestions" class="form-label">Number of Questions</label>
                                <input type="number" name="number_of_questions" id="numberOfQuestions" 
                                       class="form-control" min="1" max="20" value="5" required>
                                <div class="form-text">Generate between 1-20 questions</div>
                            </div>
                            <div class="col-md-6">
                                <label for="questionCategory" class="form-label">Question Category</label>
                                <div class="dropdown-container">
                                    <select name="question_category" id="questionCategory" class="form-select wide" required>
                                        <option value="conceptual">Conceptual Understanding</option>
                                        <option value="application">Practical Application</option>
                                        <option value="analysis">Critical Analysis</option>
                                        <option value="synthesis">Knowledge Synthesis</option>
                                        <option value="evaluation">Evaluation & Assessment</option>
                                    </select>
                                </div>
                                <div class="form-text">Choose the cognitive level for questions</div>
                            </div>
                        </div>
                    </div>

                    <!-- Difficulty Level -->
                    <div class="form-section">
                        <div class="section-title">
                            <i class="fas fa-chart-line"></i>
                            Difficulty Level
                        </div>
                        <div class="difficulty-grid">
                            <div class="difficulty-option" data-difficulty="easy">
                                <input type="radio" name="difficulty" value="easy" id="diffEasy" checked>
                                <label for="diffEasy" class="difficulty-label">
                                    <i class="fas fa-seedling d-block mb-2"></i>
                                    Easy
                                </label>
                            </div>
                            <div class="difficulty-option" data-difficulty="medium">
                                <input type="radio" name="difficulty" value="medium" id="diffMedium">
                                <label for="diffMedium" class="difficulty-label">
                                    <i class="fas fa-mountain d-block mb-2"></i>
                                    Medium
                                </label>
                            </div>
                            <div class="difficulty-option" data-difficulty="hard">
                                <input type="radio" name="difficulty" value="hard" id="diffHard">
                                <label for="diffHard" class="difficulty-label">
                                    <i class="fas fa-fire d-block mb-2"></i>
                                    Hard
                                </label>
                            </div>
                            <div class="difficulty-option" data-difficulty="mixed">
                                <input type="radio" name="difficulty" value="mixed" id="diffMixed">
                                <label for="diffMixed" class="difficulty-label">
                                    <i class="fas fa-dice d-block mb-2"></i>
                                    Mixed
                                </label>
                            </div>
                        </div>
                    </div>

                    <!-- Additional Instructions -->
                    <div class="form-section">
                        <div class="section-title">
                            <i class="fas fa-edit"></i>
                            Additional Instructions
                            <span class="badge bg-secondary ms-2">Optional</span>
                        </div>
                        <textarea name="additional_instructions" class="form-control" rows="4" 
                                  placeholder="Provide specific instructions for the AI about the type of questions you want...&#10;&#10;Examples:&#10;• Focus on practical applications&#10;• Include real-world examples&#10;• Avoid complex calculations&#10;• Emphasize key concepts from the lesson"></textarea>
                        <div class="form-text">
                            <i class="fas fa-lightbulb me-1"></i>
                            Give the AI specific guidance to generate better questions tailored to your needs
                        </div>
                    </div>

                    <!-- Generate Button -->
                    <div class="text-center">
                        <button type="submit" class="generate-btn">
                            <i class="fas fa-magic me-2"></i>
                            Generate Questions with AI
                        </button>
                        <div class="mt-3">
                            <a href="/Question" class="btn btn-secondary">
                                <i class="fas fa-arrow-left me-2"></i>
                                Back to Question List
                            </a>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <jsp:include page="/footer.jsp" />

        <script src="/assets/js/vendor/jquery-1.12.4.min.js"></script>
        <script src="/assets/js/jquery.nice-select.min.js"></script>
        <script src="/assets/js/bootstrap.min.js"></script>
        <script>
            $(document).ready(function () {
                // Initialize nice-select with proper configuration
                $('select.wide').niceSelect();

                // Handle lesson selection with nice-select compatibility
                $('#lessonSelect').on('change', function () {
                    const selectedValue = $(this).val();
                    const selectedOption = $(this).find('option[value="' + selectedValue + '"]');
                    const content = selectedOption.data('content');

                    if (content && selectedValue) {
                        $('#lessonContent').text(content);
                        $('#lessonPreview').slideDown(300);
                    } else {
                        $('#lessonPreview').slideUp(300);
                    }
                });

                // Handle question type selection
                $('.question-type-card').click(function () {
                    $('.question-type-card').removeClass('selected');
                    $(this).addClass('selected');
                    $(this).find('input[type="radio"]').prop('checked', true);

                    // Add animation effect
                    $(this).addClass('animate__animated animate__pulse');
                    setTimeout(() => {
                        $(this).removeClass('animate__animated animate__pulse');
                    }, 600);
                });

                // Handle difficulty selection
                $('.difficulty-option').click(function () {
                    $('.difficulty-option').removeClass('selected');
                    $(this).addClass('selected');
                    $(this).find('input[type="radio"]').prop('checked', true);
                });

                // Initialize selected states
                $('input[name="question_type"]:checked').closest('.question-type-card').addClass('selected');
                $('input[name="difficulty"]:checked').closest('.difficulty-option').addClass('selected');

                // Enhanced dropdown click handling
                $(document).on('click', '.nice-select', function (e) {
                    e.stopPropagation();
                    $('.nice-select').not(this).removeClass('open');
                    $(this).toggleClass('open');
                });

                // Close dropdown when clicking outside
                $(document).on('click', function (e) {
                    if (!$(e.target).closest('.nice-select').length) {
                        $('.nice-select').removeClass('open');
                    }
                });

                // Form validation and submission
                $('#aiQuestionForm').submit(function (e) {
                    const lessonId = $('#lessonSelect').val();
                    const numberOfQuestions = $('#numberOfQuestions').val();

                    if (!lessonId) {
                        e.preventDefault();
                        showAlert('Please select a lesson', 'danger');
                        $('#lessonSelect').focus();
                        return false;
                    }

                    if (numberOfQuestions < 1 || numberOfQuestions > 20) {
                        e.preventDefault();
                        showAlert('Number of questions must be between 1 and 20', 'danger');
                        $('#numberOfQuestions').focus();
                        return false;
                    }

                    // Show loading state
                    const submitBtn = $(this).find('button[type="submit"]');
                    const originalText = submitBtn.html();
                    submitBtn.prop('disabled', true)
                            .html('<i class="fas fa-spinner fa-spin me-2"></i>Generating Questions...');

                    // Add loading overlay
                    $('body').append(`
                        <div id="loadingOverlay" style="
                            position: fixed;
                            top: 0;
                            left: 0;
                            width: 100%;
                            height: 100%;
                            background: rgba(0, 0, 0, 0.5);
                            display: flex;
                            justify-content: center;
                            align-items: center;
                            z-index: 9999;
                        ">
                            <div style="
                                background: white;
                                padding: 30px;
                                border-radius: 15px;
                                text-align: center;
                                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
                            ">
                                <i class="fas fa-robot fa-3x text-primary mb-3"></i>
                                <h4>AI is generating your questions...</h4>
                                <p class="text-muted">This may take a few moments</p>
                                <div class="spinner-border text-primary" role="status">
                                    <span class="visually-hidden">Loading...</span>
                                </div>
                            </div>
                        </div>
                    `);

                    // If form submission fails, restore button
                    setTimeout(() => {
                        if ($('#loadingOverlay').length) {
                            $('#loadingOverlay').remove();
                            submitBtn.prop('disabled', false).html(originalText);
                        }
                    }, 30000); // 30 second timeout
                });

                // Smooth animations on scroll
                const observer = new IntersectionObserver((entries) => {
                    entries.forEach(entry => {
                        if (entry.isIntersecting) {
                            entry.target.style.opacity = '1';
                            entry.target.style.transform = 'translateY(0)';
                        }
                    });
                });

                $('.form-section').each(function () {
                    this.style.opacity = '0';
                    this.style.transform = 'translateY(20px)';
                    this.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
                    observer.observe(this);
                });

                // Helper function to show alerts
                function showAlert(message, type) {
                    const alertHtml = `
                        <div class="alert alert-${type} alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-triangle me-2"></i>
            ${message}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    `;
                    $('.ai-form-container').prepend(alertHtml);

                    // Auto dismiss after 5 seconds
                    setTimeout(() => {
                        $('.alert').fadeOut();
                    }, 5000);
                }

                // Add hover effects for better UX
                $('.form-control, .form-select').on('focus', function () {
                    $(this).closest('.form-section').addClass('focused');
                }).on('blur', function () {
                    $(this).closest('.form-section').removeClass('focused');
                });

                // Fix for nice-select dropdown positioning
                $('.nice-select').each(function () {
                    const $this = $(this);
                    const $list = $this.find('.list');

                    $this.on('click', function () {
                        setTimeout(() => {
                            if ($this.hasClass('open')) {
                                // Calculate if dropdown goes below viewport
                                const dropdownBottom = $this.offset().top + $this.outerHeight() + $list.outerHeight();
                                const viewportBottom = $(window).scrollTop() + $(window).height();

                                if (dropdownBottom > viewportBottom) {
                                    // Position dropdown above the select
                                    $list.css({
                                        'top': 'auto',
                                        'bottom': '100%',
                                        'margin-top': '0',
                                        'margin-bottom': '5px'
                                    });
                                } else {
                                    // Position dropdown below the select (default)
                                    $list.css({
                                        'top': '100%',
                                        'bottom': 'auto',
                                        'margin-top': '5px',
                                        'margin-bottom': '0'
                                    });
                                }
                            }
                        }, 10);
                    });
                });

                // Ensure proper z-index stacking
                $('.form-section.has-dropdown').each(function (index) {
                    $(this).css('z-index', 100 - index);
                });
            });
        </script>
    </body>
</html>
