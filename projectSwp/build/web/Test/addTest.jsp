<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Enhanced Test Creation</title>

        <!-- CSS -->
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

        <!-- Select2 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
        <link href="https://cdn.jsdelivr.net/npm/select2-bootstrap-5-theme@1.3.0/dist/select2-bootstrap-5-theme.min.css" rel="stylesheet" />

        <style>
            html, body {
                margin: 0;
                padding-top: 50px;
                height: 100%;
                font-family: Arial, sans-serif;
                background-color: #f9f9f9;
            }

            body {
                padding-top: 80px;
                display: flex;
                flex-direction: column;
                min-height: 100vh;
            }

            .page-wrapper {
                flex: 1;
                display: flex;
                flex-direction: column;
            }

            .content {
                max-width: 1000px;
                width: 100%;
                margin: 0 auto;
                padding: 20px;
            }

            h3 {
                color: #333;
                border-bottom: 2px solid #007BFF;
                padding-bottom: 8px;
                margin-bottom: 20px;
            }

            .form-container {
                background-color: #fff;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                margin-bottom: 20px;
            }

            .form-section {
                margin-bottom: 25px;
                padding: 20px;
                border: 1px solid #e0e0e0;
                border-radius: 8px;
                background-color: #f9f9f9;
            }

            .form-section h4 {
                color: #007BFF;
                margin-bottom: 15px;
                font-weight: 600;
            }

            .hierarchy-section {
                background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
                border: 2px solid #0ea5e9;
                border-radius: 12px;
                padding: 20px;
                margin-bottom: 20px;
            }

            .hierarchy-steps {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 15px;
                margin-bottom: 20px;
            }

            .step-item {
                background: white;
                padding: 15px;
                border-radius: 8px;
                border: 1px solid #e2e8f0;
            }

            .step-item label {
                font-weight: 600;
                color: #374151;
                margin-bottom: 8px;
                display: block;
            }

            .question-generation-section {
                background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
                border: 2px solid #f59e0b;
                border-radius: 12px;
                padding: 20px;
                margin-bottom: 20px;
                display: none;
            }

            .question-generation-section.active {
                display: block;
                animation: slideDown 0.3s ease;
            }

            @keyframes slideDown {
                from {
                    opacity: 0;
                    transform: translateY(-10px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .generation-controls {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
                gap: 15px;
                margin-bottom: 20px;
            }

            .control-group {
                background: white;
                padding: 15px;
                border-radius: 8px;
                border: 1px solid #e2e8f0;
            }

            .control-group label {
                font-weight: 600;
                color: #374151;
                margin-bottom: 8px;
                display: block;
            }

            .btn-generate {
                background: linear-gradient(135deg, #10b981 0%, #059669 100%);
                border: none;
                color: white;
                padding: 12px 24px;
                border-radius: 8px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .btn-generate:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
            }

            .questions-preview {
                background: white;
                border: 1px solid #e2e8f0;
                border-radius: 8px;
                padding: 20px;
                margin-top: 20px;
                max-height: 400px;
                overflow-y: auto;
                display: none;
            }

            .questions-preview.active {
                display: block;
                animation: fadeIn 0.3s ease;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                }
                to {
                    opacity: 1;
                }
            }

            .question-item {
                background: #f8fafc;
                border: 1px solid #e2e8f0;
                border-radius: 6px;
                padding: 15px;
                margin-bottom: 10px;
                display: flex;
                align-items: flex-start;
                gap: 10px;
            }

            .question-item.selected {
                border-color: #10b981;
                background: #ecfdf5;
            }

            .question-checkbox {
                margin-top: 5px;
            }

            .question-content {
                flex: 1;
            }

            .question-text {
                font-weight: 500;
                margin-bottom: 5px;
            }

            .question-meta {
                font-size: 0.875rem;
                color: #6b7280;
                display: flex;
                gap: 15px;
                flex-wrap: wrap;
            }

            .meta-badge {
                padding: 2px 8px;
                border-radius: 12px;
                font-size: 0.75rem;
                font-weight: 500;
            }

            .difficulty-easy {
                background: #d1fae5;
                color: #065f46;
            }
            .difficulty-medium {
                background: #fef3c7;
                color: #92400e;
            }
            .difficulty-hard {
                background: #fee2e2;
                color: #991b1b;
            }

            .category-badge {
                background: #e0e7ff;
                color: #3730a3;
            }
            .ai-badge {
                background: #f3e8ff;
                color: #6b21a8;
            }

            .manual-selection {
                background: white;
                border: 1px solid #e2e8f0;
                border-radius: 8px;
                padding: 20px;
                max-height: 400px;
                overflow-y: auto;
                margin-top: 20px;
            }

            .selection-stats {
                background: #f0f9ff;
                border: 1px solid #0ea5e9;
                border-radius: 6px;
                padding: 10px 15px;
                margin-bottom: 15px;
                font-weight: 500;
                color: #0c4a6e;
            }

            .bulk-actions {
                margin-bottom: 15px;
                display: flex;
                gap: 10px;
                flex-wrap: wrap;
            }

            .btn-bulk {
                padding: 6px 12px;
                border: 1px solid #d1d5db;
                background: white;
                border-radius: 4px;
                cursor: pointer;
                font-size: 0.875rem;
                transition: all 0.2s ease;
            }

            .btn-bulk:hover {
                background: #f3f4f6;
                border-color: #9ca3af;
            }

            /* Select2 Custom Styling */
            .select2-container--bootstrap-5 .select2-selection {
                border: 2px solid #e2e8f0 !important;
                border-radius: 8px !important;
                min-height: 45px !important;
                padding: 5px 10px !important;
            }

            .select2-container--bootstrap-5.select2-container--focus .select2-selection {
                border-color: #0ea5e9 !important;
                box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.1) !important;
            }

            .select2-dropdown {
                border: 2px solid #0ea5e9 !important;
                border-radius: 8px !important;
                box-shadow: 0 4px 12px rgba(0,0,0,0.15) !important;
            }

            input[type="text"],
            select:not(.select2-hidden-accessible) {
                width: 100%;
                padding: 10px;
                margin-bottom: 15px;
                border: 1px solid #ccc;
                border-radius: 5px;
            }

            input[type="checkbox"] {
                margin-right: 5px;
            }

            input[type="submit"] {
                background-color: #007BFF;
                color: white;
                border: none;
                padding: 12px 24px;
                border-radius: 5px;
                cursor: pointer;
                font-weight: 600;
            }

            input[type="submit"]:hover {
                background-color: #0056b3;
            }

            .alert {
                padding: 12px 16px;
                border-radius: 6px;
                margin-bottom: 15px;
            }

            .alert-info {
                background: #e0f2fe;
                border: 1px solid #0ea5e9;
                color: #0c4a6e;
            }

            .alert-warning {
                background: #fef3c7;
                border: 1px solid #f59e0b;
                color: #92400e;
            }
        </style>
    </head>
    <body>
        <div class="page-wrapper">
            <jsp:include page="/header.jsp" />

            <div class="content">
                <h3>Enhanced Test Creation</h3>

                <form action="${pageContext.request.contextPath}/test" method="post" id="testForm">
                    <input type="hidden" name="action" value="add" />

                    <!-- Basic Test Information -->
                    <div class="form-container">
                        <div class="form-section">
                            <h4><i class="fas fa-info-circle"></i> Basic Information</h4>

                            <label for="name">Test Name:</label>
                            <input type="text" id="name" name="name" value="${test != null ? test.name : ''}" required />

                            <label for="description">Description:</label>
                            <input type="text" id="description" name="description" value="${test != null ? test.description : ''}" required />

                            <label>
                                <input type="checkbox" name="practice" value="true" /> 
                                Practice Test (uncheck for official test)
                            </label>

                            <label for="category">Category:</label>
                            <select id="category" name="categoryId" required>
                                <option value="" disabled selected>-- Select Category --</option>
                                <c:forEach var="entry" items="${categoryMap}">
                                    <option value="${entry.key}">${entry.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <!-- Enhanced Question Selection -->
                    <div class="form-container">
                        <div class="form-section">
                            <h4><i class="fas fa-cogs"></i> Question Selection Method</h4>
                            <div class="alert alert-info">
                                <i class="fas fa-lightbulb"></i>
                                Choose how you want to add questions to your test. You can manually select questions or use smart generation based on lesson content.
                            </div>

                            <div style="margin-bottom: 20px;">
                                <label>
                                    <input type="radio" name="selectionMethod" value="manual" checked onchange="toggleSelectionMethod()"> 
                                    Manual Selection - Browse and select questions manually
                                </label><br>
                                <label>
                                    <input type="radio" name="selectionMethod" value="smart" onchange="toggleSelectionMethod()"> 
                                    Smart Generation - Auto-generate based on lesson and criteria
                                </label>
                            </div>
                        </div>

                        <!-- Learning Path Selection -->
                        <div class="hierarchy-section" id="hierarchySection">
                            <h4><i class="fas fa-sitemap"></i> Select Learning Path</h4>
                            <div class="alert alert-info">
                                <i class="fas fa-route"></i>
                                Navigate through Grade → Subject → Chapter → Lesson to find questions
                            </div>

                            <div class="hierarchy-steps">
                                <div class="step-item">
                                    <label for="gradeSelect">Grade</label>
                                    <select id="gradeSelect" class="form-select select2-dropdown">
                                        <option value="">-- Select Grade --</option>
                                        <c:forEach var="grade" items="${gradeList}">
                                            <option value="${grade.id}">${grade.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="step-item">
                                    <label for="subjectSelect">Subject</label>
                                    <select id="subjectSelect" class="form-select select2-dropdown" disabled>
                                        <option value="">-- Select Subject --</option>
                                    </select>
                                </div>

                                <div class="step-item">
                                    <label for="chapterSelect">Chapter</label>
                                    <select id="chapterSelect" class="form-select select2-dropdown" disabled>
                                        <option value="">-- Select Chapter --</option>
                                    </select>
                                </div>

                                <div class="step-item">
                                    <label for="lessonSelect">Lesson</label>
                                    <select id="lessonSelect" class="form-select select2-dropdown" disabled>
                                        <option value="">-- Select Lesson --</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <!-- Smart Question Generation -->
                        <div class="question-generation-section" id="smartGenerationSection">
                            <h4><i class="fas fa-magic"></i> Smart Question Generation</h4>
                            <div class="alert alert-warning">
                                <i class="fas fa-robot"></i>
                                Configure criteria and let the system automatically select questions from the chosen lesson
                            </div>

                            <div class="generation-controls">
                                <div class="control-group">
                                    <label for="questionCount">Number of Questions</label>
                                    <input type="number" id="questionCount" min="1" max="50" value="10" class="form-control">
                                </div>

                                <div class="control-group">
                                    <label for="difficultyFilter">Difficulty Level</label>
                                    <select id="difficultyFilter" class="form-control">
                                        <option value="all">All Levels</option>
                                        <option value="easy">Easy</option>
                                        <option value="medium" selected>Medium</option>
                                        <option value="hard">Hard</option>
                                    </select>
                                </div>

                                <div class="control-group">
                                    <label for="categoryFilter">Question Category</label>
                                    <select id="categoryFilter" class="form-control">
                                        <option value="all">All Categories</option>
                                        <option value="conceptual">Conceptual</option>
                                        <option value="application">Application</option>
                                        <option value="analysis">Analysis</option>
                                        <option value="synthesis">Synthesis</option>
                                        <option value="evaluation">Evaluation</option>
                                    </select>
                                </div>
                            </div>

                            <div style="text-align: center; margin-bottom: 20px;">
                                <button type="button" class="btn-generate" onclick="generateRandomQuestions()">
                                    <i class="fas fa-dice"></i> Generate Random Questions
                                </button>
                            </div>

                            <div class="questions-preview" id="generatedQuestionsPreview">
                                <h5>Generated Questions Preview</h5>
                                <div class="selection-stats" id="generatedStats"></div>
                                <div class="bulk-actions">
                                    <button type="button" class="btn-bulk" onclick="selectAllGenerated()">
                                        <i class="fas fa-check-square"></i> Select All
                                    </button>
                                    <button type="button" class="btn-bulk" onclick="deselectAllGenerated()">
                                        <i class="fas fa-square"></i> Deselect All
                                    </button>
                                    <button type="button" class="btn-bulk" onclick="regenerateQuestions()">
                                        <i class="fas fa-sync"></i> Regenerate
                                    </button>
                                </div>
                                <div id="generatedQuestionsList"></div>
                            </div>
                        </div>

                        <!-- Manual Question Selection -->
                        <div class="manual-selection" id="manualSelectionSection">
                            <h5><i class="fas fa-list"></i> Available Questions</h5>
                            <div class="alert alert-info" id="manualSelectionAlert" style="display: none;">
                                <i class="fas fa-info-circle"></i>
                                Select a lesson from the hierarchy above to view available questions
                            </div>

                            <div class="selection-stats" id="manualStats" style="display: none;"></div>
                            <div class="bulk-actions" id="manualBulkActions" style="display: none;">
                                <button type="button" class="btn-bulk" onclick="selectAllManual()">
                                    <i class="fas fa-check-square"></i> Select All
                                </button>
                                <button type="button" class="btn-bulk" onclick="deselectAllManual()">
                                    <i class="fas fa-square"></i> Deselect All
                                </button>
                                <button type="button" class="btn-bulk" onclick="filterByDifficulty()">
                                    <i class="fas fa-filter"></i> Filter
                                </button>
                            </div>
                            <div id="manualQuestionsList"></div>
                        </div>
                    </div>

                    <div style="text-align: center; margin-top: 30px;">
                        <input type="submit" value="Create Test" />
                        <a href="${pageContext.request.contextPath}/test" style="margin-left: 15px; color: #007BFF; text-decoration: none;">
                            ← Back to Test List
                        </a>
                    </div>
                </form>
            </div>

            <jsp:include page="/footer.jsp" />
        </div>

        <!-- JS -->
        <script src="${pageContext.request.contextPath}/assets/js/vendor/modernizr-3.5.0.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/vendor/jquery-1.12.4.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/popper.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>

        <!-- Select2 JS -->
        <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

        <script src="${pageContext.request.contextPath}/assets/js/jquery.slicknav.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/owl.carousel.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/slick.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/wow.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/animated.headline.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.magnific-popup.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/gijgo.min.js"></script>
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
                                        let currentLessonId = null;
                                        let allQuestions = [];
                                        let selectedQuestions = new Set();

                                        // Initialize Select2
                                        function initializeSelect2(selector) {
                                            $(selector).select2({
                                                theme: 'bootstrap-5',
                                                width: '100%',
                                                allowClear: false,
                                                dropdownParent: $('body')
                                            });
                                        }

                                        // Initialize all select2 dropdowns
                                        $('.select2-dropdown').each(function () {
                                            initializeSelect2('#' + $(this).attr('id'));
                                        });

                                        // Define global functions that are called from HTML onchange events
                                        window.updateManualStats = function () {
                                            const total = $('#manualQuestionsList .question-checkbox').length;
                                            const selected = $('#manualQuestionsList .question-checkbox:checked').length;
                                            $('#manualStats').html(`<i class="fas fa-chart-bar"></i> Selected: ${selected} / ${total} questions`);

                                            // Update visual selection
                                            $('#manualQuestionsList .question-item').each(function () {
                                                if ($(this).find('.question-checkbox').is(':checked')) {
                                                    $(this).addClass('selected');
                                                } else {
                                                    $(this).removeClass('selected');
                                                }
                                            });
                                        };

                                        window.updateGeneratedStats = function () {
                                            const total = $('#generatedQuestionsList .question-checkbox').length;
                                            const selected = $('#generatedQuestionsList .question-checkbox:checked').length;
                                            $('#generatedStats').html(`<i class="fas fa-chart-bar"></i> Selected: ${selected} / ${total} generated questions`);

                                            // Update visual selection
                                            $('#generatedQuestionsList .question-item').each(function () {
                                                if ($(this).find('.question-checkbox').is(':checked')) {
                                                    $(this).addClass('selected');
                                                } else {
                                                    $(this).removeClass('selected');
                                                }
                                            });
                                        };

                                        // Toggle selection method
                                        window.toggleSelectionMethod = function () {
                                            const method = $('input[name="selectionMethod"]:checked').val();
                                            if (method === 'smart') {
                                                $('#smartGenerationSection').addClass('active');
                                                $('#manualSelectionAlert').show();
                                                $('#manualStats, #manualBulkActions').hide();
                                                $('#manualQuestionsList').empty();
                                            } else {
                                                $('#smartGenerationSection').removeClass('active');
                                                $('#generatedQuestionsPreview').removeClass('active');
                                                $('#manualSelectionAlert').show();
                                            }
                                        };

                                        // Hierarchy selection handlers
                                        $('#gradeSelect').on('change', function () {
                                            const gradeId = $(this).val();
                                            if (gradeId) {
                                                loadSubjects(gradeId);
                                                resetSubsequentSelects(['#subjectSelect', '#chapterSelect', '#lessonSelect']);
                                                clearQuestionDisplay();
                                            }
                                        });

                                        $('#subjectSelect').on('change', function () {
                                            const subjectId = $(this).val();
                                            if (subjectId) {
                                                loadChapters(subjectId);
                                                resetSubsequentSelects(['#chapterSelect', '#lessonSelect']);
                                                clearQuestionDisplay();
                                            }
                                        });

                                        $('#chapterSelect').on('change', function () {
                                            const chapterId = $(this).val();
                                            if (chapterId) {
                                                loadLessons(chapterId);
                                                resetSubsequentSelects(['#lessonSelect']);
                                                clearQuestionDisplay();
                                            }
                                        });

                                        $('#lessonSelect').on('change', function () {
                                            const lessonId = $(this).val();
                                            if (lessonId) {
                                                currentLessonId = lessonId;
                                                loadQuestions(lessonId);
                                            }
                                        });

                                        // Helper functions
                                        function resetSubsequentSelects(selectors) {
                                            selectors.forEach(selector => {
                                                $(selector).empty().append('<option value="">-- Select --</option>').prop('disabled', true);
                                                $(selector).select2('destroy');
                                                initializeSelect2(selector);
                                            });
                                        }

                                        function clearQuestionDisplay() {
                                            $('#manualQuestionsList').empty();
                                            $('#manualStats, #manualBulkActions').hide();
                                            $('#manualSelectionAlert').show();
                                            $('#generatedQuestionsPreview').removeClass('active');
                                            selectedQuestions.clear();
                                        }

                                        // AJAX functions
                                        function loadSubjects(gradeId) {
                                            $.get('test', {
                                                action: 'getSubjectsByGrade',
                                                gradeId: gradeId
                                            }, function (data) {
                                                populateSelect('#subjectSelect', data, '-- Select Subject --');
                                            }).fail(function () {
                                                console.error('Failed to load subjects');
                                            });
                                        }

                                        function loadChapters(subjectId) {
                                            $.get('test', {
                                                action: 'getChaptersBySubject',
                                                subjectId: subjectId
                                            }, function (data) {
                                                populateSelect('#chapterSelect', data, '-- Select Chapter --');
                                            }).fail(function () {
                                                console.error('Failed to load chapters');
                                            });
                                        }

                                        function loadLessons(chapterId) {
                                            $.get('test', {
                                                action: 'getLessonsByChapter',
                                                chapterId: chapterId
                                            }, function (data) {
                                                populateSelect('#lessonSelect', data, '-- Select Lesson --');
                                            }).fail(function () {
                                                console.error('Failed to load lessons');
                                            });
                                        }

                                        function loadQuestions(lessonId) {
                                            console.log('Loading questions for lesson:', lessonId);
                                            $.get('test', {
                                                action: 'getQuestionsByLesson',
                                                lessonId: lessonId
                                            }, function (data) {
                                                console.log('Questions loaded:', data);
                                                allQuestions = data;
                                                displayManualQuestions(data);
                                                $('#manualSelectionAlert').hide();
                                                $('#manualStats, #manualBulkActions').show();
                                                updateManualStats();
                                            }).fail(function (xhr, status, error) {
                                                console.error('Failed to load questions:', error);
                                                console.error('Response:', xhr.responseText);
                                                $('#manualSelectionAlert').show().html('<i class="fas fa-exclamation-triangle"></i> Failed to load questions for this lesson: ' + error);
                                            });
                                        }

                                        function populateSelect(selector, data, placeholder) {
                                            const $select = $(selector);
                                            $select.empty().append('<option value="">' + placeholder + '</option>');
                                            $.each(data, function (i, item) {
                                                $select.append('<option value="' + item.id + '">' + item.name + '</option>');
                                            });
                                            $select.prop('disabled', false);
                                            $select.select2('destroy');
                                            initializeSelect2(selector);
                                        }

                                        // Question display functions
                                        function displayManualQuestions(questions) {
                                            const container = $('#manualQuestionsList');
                                            container.empty();

                                            if (questions.length === 0) {
                                                container.html('<div class="alert alert-warning"><i class="fas fa-info-circle"></i> No questions found for this lesson</div>');
                                                return;
                                            }

                                            questions.forEach(function (question, index) {
                                                // Ensure all properties have default values
                                                const difficulty = question.difficulty || 'medium';
                                                const category = question.category || 'conceptual';
                                                const type = question.type || 'SINGLE';
                                                const isAI = question.isAI || false;

                                                const questionHtml = `
                <div class="question-item" data-question-id="${question.id}" data-difficulty="${difficulty}" data-category="${category}" data-source="${isAI ? 'ai' : 'manual'}">
                    <input type="checkbox" name="questionIds" value="${question.id}" 
                           class="question-checkbox" onchange="updateManualStats()">
                    <div class="question-content">
                        <div class="question-text">${question.question}</div>
                        <div class="question-meta">
                            <span class="meta-badge difficulty-${difficulty}">${difficulty}</span>
                            <span class="meta-badge category-badge">${category}</span>
                            <span class="meta-badge">${type}</span>
            ${isAI ? '<span class="meta-badge ai-badge">AI Generated</span>' : '<span class="meta-badge">Manual</span>'}
                        </div>
                    </div>
                </div>
            `;
                                                container.append(questionHtml);
                                            });
                                        }

                                        function displayGeneratedQuestions(questions) {
                                            const container = $('#generatedQuestionsList');
                                            container.empty();

                                            questions.forEach(function (question, index) {
                                                // Ensure all properties have default values
                                                const difficulty = question.difficulty || 'medium';
                                                const category = question.category || 'conceptual';
                                                const type = question.type || 'SINGLE';
                                                const isAI = question.isAI || false;

                                                const questionHtml = `
                <div class="question-item selected" data-question-id="${question.id}" data-difficulty="${difficulty}" data-category="${category}" data-source="${isAI ? 'ai' : 'manual'}">
                    <input type="checkbox" name="questionIds" value="${question.id}" 
                           class="question-checkbox" checked onchange="updateGeneratedStats()">
                    <div class="question-content">
                        <div class="question-text">${question.question}</div>
                        <div class="question-meta">
                            <span class="meta-badge difficulty-${difficulty}">${difficulty}</span>
                            <span class="meta-badge category-badge">${category}</span>
                            <span class="meta-badge">${type}</span>
            ${isAI ? '<span class="meta-badge ai-badge">AI Generated</span>' : '<span class="meta-badge">Manual</span>'}
                        </div>
                    </div>
                </div>
            `;
                                                container.append(questionHtml);
                                            });

                                            $('#generatedQuestionsPreview').addClass('active');
                                            updateGeneratedStats();
                                        }

                                        // Smart generation functions
                                        window.generateRandomQuestions = function () {
                                            if (!currentLessonId) {
                                                alert('Please select a lesson first');
                                                return;
                                            }

                                            const count = $('#questionCount').val();
                                            const difficulty = $('#difficultyFilter').val();
                                            const category = $('#categoryFilter').val();

                                            console.log('Generating random questions:', {lessonId: currentLessonId, count, difficulty, category});

                                            $.get('test', {
                                                action: 'getRandomQuestions',
                                                lessonId: currentLessonId,
                                                count: count,
                                                difficulty: difficulty,
                                                category: category
                                            }, function (data) {
                                                console.log('Random questions generated:', data);
                                                if (data.length > 0) {
                                                    displayGeneratedQuestions(data);
                                                } else {
                                                    alert('No questions found matching your criteria');
                                                }
                                            }).fail(function (xhr, status, error) {
                                                console.error('Failed to generate questions:', error);
                                                console.error('Response:', xhr.responseText);
                                                alert('Failed to generate questions: ' + error);
                                            });
                                        };

                                        window.regenerateQuestions = function () {
                                            generateRandomQuestions();
                                        };

                                        // Bulk selection functions
                                        window.selectAllManual = function () {
                                            $('#manualQuestionsList .question-checkbox').prop('checked', true);
                                            updateManualStats();
                                        };

                                        window.deselectAllManual = function () {
                                            $('#manualQuestionsList .question-checkbox').prop('checked', false);
                                            updateManualStats();
                                        };

                                        window.selectAllGenerated = function () {
                                            $('#generatedQuestionsList .question-checkbox').prop('checked', true);
                                            updateGeneratedStats();
                                        };

                                        window.deselectAllGenerated = function () {
                                            $('#generatedQuestionsList .question-checkbox').prop('checked', false);
                                            updateGeneratedStats();
                                        };

                                        window.filterByDifficulty = function () {
                                            const difficulty = prompt('Enter difficulty level (easy, medium, hard):');
                                            if (difficulty) {
                                                $('#manualQuestionsList .question-item').each(function () {
                                                    const questionDifficulty = $(this).find('.difficulty-' + difficulty).length > 0;
                                                    $(this).find('.question-checkbox').prop('checked', questionDifficulty);
                                                });
                                                updateManualStats();
                                            }
                                        };

                                        // Apply filters function
                                        window.applyFilters = function () {
                                            const difficultyFilter = $('#difficultyFilter').val();
                                            const categoryFilter = $('#categoryFilter').val();
                                            const sourceFilter = $('#sourceFilter').val();

                                            $('#manualQuestionsList .question-item').each(function () {
                                                const $item = $(this);
                                                const difficulty = $item.data('difficulty');
                                                const category = $item.data('category');
                                                const source = $item.data('source');

                                                let show = true;

                                                if (difficultyFilter !== 'all' && difficulty !== difficultyFilter) {
                                                    show = false;
                                                }
                                                if (categoryFilter !== 'all' && category !== categoryFilter) {
                                                    show = false;
                                                }
                                                if (sourceFilter !== 'all' && source !== sourceFilter) {
                                                    show = false;
                                                }

                                                if (show) {
                                                    $item.show();
                                                } else {
                                                    $item.hide();
                                                }
                                            });

                                            updateManualStats();
                                        };

                                        // Form submission validation
                                        $('#testForm').on('submit', function (e) {
                                            const selectedCount = $('input[name="questionIds"]:checked').length;
                                            if (selectedCount === 0) {
                                                e.preventDefault();
                                                alert('Please select at least one question for the test');
                                                return false;
                                            }

                                            // Show loading state
                                            $('input[type="submit"]').prop('disabled', true).val('Creating Test...');
                                            return true;
                                        });

                                        // Initialize page state
                                        toggleSelectionMethod();
                                    });
        </script>
    </body>
</html>
