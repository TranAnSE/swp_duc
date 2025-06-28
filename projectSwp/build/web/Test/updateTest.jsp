<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
    <head>
        <title>Test Update</title>
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
            html, body {
                margin: 0;
                padding: 0;
                height: 100%;
                font-family: Arial, sans-serif;
                background-color: #f9f9f9;
            }

            .page-wrapper {
                display: flex;
                flex-direction: column;
                min-height: 100vh;
            }

            header, footer {
                flex-shrink: 0;
            }

            main {
                flex: 1;
                padding: 100px 20px 20px 20px;
                display: flex;
                justify-content: center;
            }

            .form-container {
                background-color: #fff;
                padding: 30px;
                border-radius: 12px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                max-width: 1200px;
                width: 100%;
            }

            h3 {
                color: #333;
                margin-bottom: 30px;
                border-bottom: 3px solid #007BFF;
                padding-bottom: 10px;
                font-weight: 600;
            }

            .form-section {
                margin-bottom: 30px;
                padding: 25px;
                border: 1px solid #e0e0e0;
                border-radius: 10px;
                background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
            }

            .form-section h4 {
                color: #007BFF;
                margin-bottom: 20px;
                font-weight: 600;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .context-info {
                background: linear-gradient(135deg, #e0f2fe 0%, #f0f9ff 100%);
                border: 2px solid #0ea5e9;
                border-radius: 8px;
                padding: 15px;
                margin-bottom: 20px;
                font-weight: 500;
                color: #0c4a6e;
            }

            .selected-questions-section {
                background: linear-gradient(135deg, #ecfdf5 0%, #f0fdf4 100%);
                border: 2px solid #10b981;
                border-radius: 12px;
                padding: 25px;
                margin-bottom: 25px;
            }

            .smart-adding-section {
                background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
                border: 2px solid #f59e0b;
                border-radius: 12px;
                padding: 25px;
                margin-bottom: 25px;
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

            .question-list {
                background: white;
                border: 1px solid #e2e8f0;
                border-radius: 10px;
                padding: 20px;
                max-height: 400px;
                overflow-y: auto;
            }

            .question-item {
                background: #f8fafc;
                border: 1px solid #e2e8f0;
                border-radius: 8px;
                padding: 15px;
                margin-bottom: 12px;
                display: flex;
                align-items: flex-start;
                gap: 12px;
                transition: all 0.2s ease;
            }

            .question-item:hover {
                background: #f1f5f9;
                border-color: #cbd5e1;
            }

            .question-item.selected {
                border-color: #10b981;
                background: #ecfdf5;
            }

            .question-item.to-remove {
                border-color: #ef4444;
                background: #fef2f2;
            }

            .question-checkbox {
                margin-top: 5px;
                transform: scale(1.2);
            }

            .question-content {
                flex: 1;
            }

            .question-text {
                font-weight: 500;
                margin-bottom: 8px;
                color: #1f2937;
                line-height: 1.4;
            }

            .question-meta {
                display: flex;
                gap: 12px;
                flex-wrap: wrap;
                align-items: center;
            }

            .lesson-name {
                font-size: 0.875rem;
                color: #6b7280;
                font-weight: 500;
            }

            .meta-badge {
                padding: 3px 8px;
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
            .manual-badge {
                background: #f3f4f6;
                color: #374151;
            }

            .selection-stats {
                background: #f0f9ff;
                border: 1px solid #0ea5e9;
                border-radius: 8px;
                padding: 12px 16px;
                margin-bottom: 15px;
                font-weight: 500;
                color: #0c4a6e;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .bulk-actions {
                margin-bottom: 20px;
                display: flex;
                gap: 10px;
                flex-wrap: wrap;
            }

            .btn-bulk {
                padding: 8px 16px;
                border: 1px solid #d1d5db;
                background: white;
                border-radius: 6px;
                cursor: pointer;
                font-size: 0.875rem;
                transition: all 0.2s ease;
                display: flex;
                align-items: center;
                gap: 5px;
            }

            .btn-bulk:hover {
                background: #f3f4f6;
                border-color: #9ca3af;
                transform: translateY(-1px);
            }

            .btn-bulk.primary {
                background: #007BFF;
                color: white;
                border-color: #007BFF;
            }
            .btn-bulk.primary:hover {
                background: #0056b3;
                border-color: #0056b3;
            }
            .btn-bulk.danger {
                background: #ef4444;
                color: white;
                border-color: #ef4444;
            }
            .btn-bulk.danger:hover {
                background: #dc2626;
                border-color: #dc2626;
            }
            .btn-bulk.success {
                background: #10b981;
                color: white;
                border-color: #10b981;
            }
            .btn-bulk.success:hover {
                background: #059669;
                border-color: #059669;
            }

            input[type="text"], select {
                width: 100%;
                padding: 12px;
                margin: 6px 0 15px 0;
                border: 2px solid #e2e8f0;
                border-radius: 8px;
                transition: border-color 0.2s ease;
            }

            input[type="text"]:focus, select:focus {
                border-color: #0ea5e9;
                outline: none;
                box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.1);
            }

            input[type="checkbox"] {
                margin-right: 8px;
                transform: scale(1.1);
            }

            input[type="submit"] {
                background: linear-gradient(135deg, #007BFF 0%, #0056b3 100%);
                color: white;
                border: none;
                padding: 14px 28px;
                border-radius: 8px;
                cursor: pointer;
                font-weight: 600;
                font-size: 1rem;
                transition: all 0.3s ease;
            }

            input[type="submit"]:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(0, 123, 255, 0.3);
            }

            .alert {
                padding: 12px 16px;
                border-radius: 8px;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 10px;
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
            .alert-success {
                background: #ecfdf5;
                border: 1px solid #10b981;
                color: #065f46;
            }

            .back-link {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                margin-top: 20px;
                text-decoration: none;
                color: #007BFF;
                font-weight: 500;
                transition: color 0.2s ease;
            }

            .back-link:hover {
                color: #0056b3;
                text-decoration: none;
            }

            @media (max-width: 768px) {
                .generation-controls {
                    grid-template-columns: 1fr;
                }
                .bulk-actions {
                    flex-direction: column;
                }
                .selection-stats {
                    flex-direction: column;
                    gap: 10px;
                    text-align: center;
                }
            }
        </style>
    </head>
    <body>
        <div class="page-wrapper">
            <jsp:include page="/header.jsp" />

            <main>
                <div class="form-container">
                    <h3><i class="fas fa-edit"></i> Enhanced Test Update</h3>

                    <form action="${pageContext.request.contextPath}/test" method="post" id="updateTestForm">
                        <input type="hidden" name="action" value="update"/>
                        <input type="hidden" name="id" value="${test.id}"/>

                        <!-- Basic Test Information -->
                        <div class="form-section">
                            <h4><i class="fas fa-info-circle"></i> Test Information</h4>

                            <label for="name">Test Name:</label>
                            <input type="text" name="name" value="${test.name}" required/>

                            <label for="description">Description:</label>
                            <input type="text" name="description" value="${test.description}" required/>

                            <label>
                                <input type="checkbox" name="practice" value="true"
                                       <c:if test="${test.is_practice}">checked</c:if> />
                                       Practice Test (uncheck for official test)
                                </label>

                                <label for="category">Category:</label>
                                <select id="category" name="categoryId" required>
                                    <option value="" disabled>-- Select Category --</option>
                                <c:forEach var="entry" items="${categoryMap}">
                                    <option value="${entry.key}" ${test.category_id == entry.key ? 'selected' : ''}>${entry.value}</option>
                                </c:forEach>
                            </select>

                            <!-- Context Information -->
                            <c:if test="${not empty contextInfo}">
                                <div class="context-info">
                                    <i class="fas fa-map-marker-alt"></i>
                                    <strong>Test Context:</strong> ${contextInfo}
                                    <input type="hidden" id="contextLessonId" value="${contextLessonId}" />
                                </div>
                            </c:if>
                        </div>

                        <!-- Currently Selected Questions -->
                        <div class="selected-questions-section">
                            <h4><i class="fas fa-check-circle"></i> Currently Selected Questions</h4>
                            <div class="alert alert-success">
                                <i class="fas fa-info-circle"></i>
                                These are the questions currently assigned to this test. Uncheck questions you want to remove.
                            </div>

                            <div class="selection-stats" id="currentSelectionStats">
                                <span>
                                    <i class="fas fa-chart-bar"></i> 
                                    Currently selected: <span id="currentSelectedCount">${selectedQuestions.size()}</span> questions
                                </span>
                            </div>

                            <div class="bulk-actions">
                                <button type="button" class="btn-bulk danger" id="removeAllBtn">
                                    <i class="fas fa-trash"></i> Remove All Selected
                                </button>
                                <button type="button" class="btn-bulk" id="selectAllCurrentBtn">
                                    <i class="fas fa-check-square"></i> Keep All Questions
                                </button>
                                <button type="button" class="btn-bulk" id="deselectAllCurrentBtn">
                                    <i class="fas fa-square"></i> Remove All Questions
                                </button>
                            </div>

                            <div class="question-list" id="currentQuestionsList">
                                <c:if test="${empty selectedQuestions}">
                                    <div class="alert alert-warning">
                                        <i class="fas fa-exclamation-triangle"></i>
                                        No questions currently selected for this test.
                                    </div>
                                </c:if>
                                <c:if test="${not empty selectedQuestions}">
                                    <c:forEach var="q" items="${selectedQuestions}">
                                        <div class="question-item" data-question-id="${q.id}">
                                            <input type="checkbox" name="questionIds" value="${q.id}" 
                                                   class="question-checkbox current-question-checkbox" checked />
                                            <div class="question-content">
                                                <div class="question-text">${q.question}</div>
                                                <div class="question-meta">
                                                    <span class="lesson-name">
                                                        <i class="fas fa-book"></i>
                                                        ${lessonNameMap[q.lesson_id] != null ? lessonNameMap[q.lesson_id] : 'Unknown Lesson'}
                                                    </span>
                                                    <span class="meta-badge difficulty-${q.difficulty != null ? q.difficulty : 'medium'}">
                                                        ${q.difficulty != null ? q.difficulty : 'medium'}
                                                    </span>
                                                    <span class="meta-badge category-badge">
                                                        ${q.category != null ? q.category : 'conceptual'}
                                                    </span>
                                                    <span class="meta-badge">
                                                        ${q.question_type}
                                                    </span>
                                                    <c:choose>
                                                        <c:when test="${q.AIGenerated}">
                                                            <span class="meta-badge ai-badge">AI Generated</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="meta-badge manual-badge">Manual</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:if>
                            </div>
                        </div>

                        <!-- Smart Adding Section -->
                        <c:if test="${not empty contextLessonId}">
                            <div class="smart-adding-section">
                                <h4><i class="fas fa-magic"></i> Smart Question Adding</h4>
                                <div class="alert alert-warning">
                                    <i class="fas fa-robot"></i>
                                    Add more questions from the same lesson context with intelligent filtering
                                </div>

                                <div class="generation-controls">
                                    <div class="control-group">
                                        <label for="questionCount">Number of Questions</label>
                                        <input type="number" id="questionCount" min="1" max="20" value="5" class="form-control">
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
                                    <button type="button" class="btn-generate" id="generateSmartBtn">
                                        <i class="fas fa-dice"></i> Generate Smart Questions
                                    </button>
                                </div>

                                <div class="questions-preview" id="smartQuestionsPreview">
                                    <h5>Smart Generated Questions Preview</h5>
                                    <div class="selection-stats" id="smartStats"></div>
                                    <div class="bulk-actions">
                                        <button type="button" class="btn-bulk success" id="selectAllSmartBtn">
                                            <i class="fas fa-check-square"></i> Select All
                                        </button>
                                        <button type="button" class="btn-bulk" id="deselectAllSmartBtn">
                                            <i class="fas fa-square"></i> Deselect All
                                        </button>
                                        <button type="button" class="btn-bulk primary" id="regenerateSmartBtn">
                                            <i class="fas fa-sync"></i> Regenerate
                                        </button>
                                    </div>
                                    <div id="smartQuestionsList"></div>
                                </div>
                            </div>
                        </c:if>

                        <div style="text-align: center; margin-top: 30px;">
                            <input type="submit" value="Update Test" />
                            <a href="${pageContext.request.contextPath}/test" class="back-link">
                                <i class="fas fa-arrow-left"></i> Back to Test List
                            </a>
                        </div>
                    </form>
                </div>
            </main>

            <jsp:include page="/footer.jsp" />
        </div>

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
// Declare all global functions first, before document ready
            let contextLessonId;
            let currentlySelectedIds = new Set();

// Global function definitions
            function updateCurrentSelectionStats() {
                const totalCurrent = $('.current-question-checkbox').length;
                const selectedCurrent = $('.current-question-checkbox:checked').length;
                $('#currentSelectedCount').text(selectedCurrent);

                // Update visual selection for current questions
                $('#currentQuestionsList .question-item').each(function () {
                    const $item = $(this);
                    if ($item.find('.current-question-checkbox').is(':checked')) {
                        $item.removeClass('to-remove');
                    } else {
                        $item.addClass('to-remove');
                    }
                });
            }

            function updateSmartStats() {
                const total = $('#smartQuestionsList .question-checkbox').length;
                const selected = $('#smartQuestionsList .question-checkbox:checked').length;

                const statsHtml = `<i class="fas fa-chart-bar"></i> Selected: ${selected} / ${total} smart questions`;
                $('#smartStats').html(statsHtml);

                // Update visual selection
                $('#smartQuestionsList .question-item').each(function () {
                    const $item = $(this);
                    if ($item.find('.question-checkbox').is(':checked')) {
                        $item.addClass('selected');
                    } else {
                        $item.removeClass('selected');
                    }
                });
            }

// Bulk selection functions for current questions
            function selectAllCurrent() {
                $('.current-question-checkbox').prop('checked', true);
                updateCurrentSelectionStats();
            }

            function deselectAllCurrent() {
                $('.current-question-checkbox').prop('checked', false);
                updateCurrentSelectionStats();
            }

            function removeAllSelected() {
                if (confirm('Are you sure you want to remove all currently selected questions from this test?')) {
                    $('.current-question-checkbox').prop('checked', false);
                    updateCurrentSelectionStats();
                }
            }

// Smart questions functions
            function selectAllSmart() {
                $('#smartQuestionsList .question-checkbox').prop('checked', true);
                updateSmartStats();
            }

            function deselectAllSmart() {
                $('#smartQuestionsList .question-checkbox').prop('checked', false);
                updateSmartStats();
            }

            function regenerateSmartQuestions() {
                generateSmartQuestions();
            }

// Smart question generation
            function generateSmartQuestions() {
                if (!contextLessonId) {
                    alert('No lesson context found for this test');
                    return;
                }

                const count = $('#questionCount').val() || 5;
                const difficulty = $('#difficultyFilter').val();
                const category = $('#categoryFilter').val();

                console.log('Generating smart questions with params:', {
                    lessonId: contextLessonId,
                    count: count,
                    difficulty: difficulty,
                    category: category,
                    excludeIds: Array.from(currentlySelectedIds)
                });

                // Show loading state
                $('#smartQuestionsList').html('<div class="alert alert-info"><i class="fas fa-spinner fa-spin"></i> Generating smart questions...</div>');
                $('#smartQuestionsPreview').addClass('active');

                $.ajax({
                    url: 'test',
                    method: 'GET',
                    data: {
                        action: 'getSmartQuestions',
                        lessonId: contextLessonId,
                        count: count,
                        difficulty: difficulty,
                        category: category,
                        excludeIds: Array.from(currentlySelectedIds).join(',')
                    },
                    success: function (data) {
                        console.log('Smart questions received:', data);
                        displaySmartQuestions(data);
                    },
                    error: function (xhr, status, error) {
                        console.error('Failed to generate smart questions:', error);
                        $('#smartQuestionsList').html(
                                '<div class="alert alert-danger">' +
                                '<i class="fas fa-exclamation-triangle"></i> ' +
                                'Failed to generate smart questions. Please try again.' +
                                '</div>'
                                );
                    }
                });
            }

            function displaySmartQuestions(questions) {
                const container = $('#smartQuestionsList');
                container.empty();

                if (!questions || questions.length === 0) {
                    container.html(
                            '<div class="alert alert-warning">' +
                            '<i class="fas fa-info-circle"></i> ' +
                            'No additional questions found matching your criteria. Try adjusting the filters.' +
                            '</div>'
                            );
                    updateSmartStats();
                    return;
                }

                questions.forEach(function (question) {
                    // Double-check to avoid duplicates
                    if (currentlySelectedIds.has(question.id)) {
                        return;
                    }

                    const difficulty = question.difficulty || 'medium';
                    const category = question.category || 'conceptual';
                    const type = question.question_type || 'SINGLE';
                    const isAI = question.AIGenerated || false;
                    const questionText = question.question || 'No question text';

                    const aiGeneratedBadge = isAI ?
                            '<span class="meta-badge ai-badge">AI Generated</span>' :
                            '<span class="meta-badge manual-badge">Manual</span>';

                    const questionDiv = $('<div></div>')
                            .addClass('question-item')
                            .attr('data-question-id', question.id)
                            .attr('data-difficulty', difficulty)
                            .attr('data-category', category)
                            .attr('data-source', isAI ? 'ai' : 'manual');

                    const checkbox = $('<input>')
                            .attr('type', 'checkbox')
                            .attr('name', 'questionIds')
                            .attr('value', question.id)
                            .addClass('question-checkbox')
                            .prop('checked', true) // Auto-select generated questions
                            .on('change', updateSmartStats);

                    const contentDiv = $('<div></div>').addClass('question-content');
                    const textDiv = $('<div></div>').addClass('question-text').text(questionText);

                    const metaDiv = $('<div></div>').addClass('question-meta');
                    metaDiv.append($('<span></span>').addClass('lesson-name').html('<i class="fas fa-book"></i> Smart Generated'));
                    metaDiv.append($('<span></span>').addClass('meta-badge difficulty-' + difficulty).text(difficulty));
                    metaDiv.append($('<span></span>').addClass('meta-badge category-badge').text(category));
                    metaDiv.append($('<span></span>').addClass('meta-badge').text(type));
                    metaDiv.append($(aiGeneratedBadge));
                    metaDiv.append($('<span></span>').addClass('meta-badge').css({
                        'background': '#10b981',
                        'color': 'white'
                    }).text('Smart'));

                    contentDiv.append(textDiv).append(metaDiv);
                    questionDiv.append(checkbox).append(contentDiv);

                    container.append(questionDiv);
                });

                updateSmartStats();

                // Scroll to show generated questions
                $('#smartQuestionsPreview')[0].scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }

            // Document ready function
            $(document).ready(function () {
                // Initialize global variables
                contextLessonId = $('#contextLessonId').val();
                currentlySelectedIds = new Set();

                // Initialize currently selected question IDs
                $('.current-question-checkbox:checked').each(function () {
                    currentlySelectedIds.add(parseInt($(this).val()));
                });

                console.log('Context Lesson ID:', contextLessonId);
                console.log('Currently selected question IDs:', Array.from(currentlySelectedIds));

                // Initialize selection stats
                updateCurrentSelectionStats();

                // Form submission validation
                $('#updateTestForm').on('submit', function (e) {
                    const totalSelected = $('input[name="questionIds"]:checked').length;
                    if (totalSelected === 0) {
                        e.preventDefault();
                        alert('Please select at least one question for the test');
                        return false;
                    }

                    // Collect all selected question IDs
                    const selectedIds = [];
                    $('input[name="questionIds"]:checked').each(function () {
                        selectedIds.push($(this).val());
                    });

                    console.log('Submitting test with question IDs:', selectedIds);

                    // Show loading state
                    $('input[type="submit"]').prop('disabled', true).val('Updating Test...');
                    return true;
                });

                // Enhanced visual feedback
                $('.question-item').on('mouseenter', function () {
                    $(this).css('transform', 'translateY(-2px)');
                }).on('mouseleave', function () {
                    $(this).css('transform', 'translateY(0)');
                });

                // Question text expansion for long questions
                $('.question-text').on('click', function () {
                    const fullText = $(this).text();
                    if (fullText.length > 100) {
                        const isExpanded = $(this).hasClass('expanded');
                        if (isExpanded) {
                            $(this).removeClass('expanded').css({
                                'max-height': '3em',
                                'overflow': 'hidden'
                            });
                        } else {
                            $(this).addClass('expanded').css({
                                'max-height': 'none',
                                'overflow': 'visible'
                            });
                        }
                    }
                });

                // Initialize long question text truncation
                $('.question-text').each(function () {
                    const text = $(this).text();
                    if (text.length > 150) {
                        $(this).css({
                            'max-height': '3em',
                            'overflow': 'hidden',
                            'cursor': 'pointer',
                            'position': 'relative'
                        }).attr('title', 'Click to expand/collapse');
                    }
                });

                // Keyboard shortcuts
                $(document).on('keydown', function (e) {
                    // Ctrl+S: Submit form
                    if (e.ctrlKey && e.key === 's') {
                        e.preventDefault();
                        $('#updateTestForm').submit();
                    }
                    // Ctrl+G: Generate smart questions
                    if (e.ctrlKey && e.key === 'g') {
                        e.preventDefault();
                        if (contextLessonId) {
                            generateSmartQuestions();
                        }
                    }
                });

                $('#removeAllBtn').on('click', removeAllSelected);
                $('#selectAllCurrentBtn').on('click', selectAllCurrent);
                $('#deselectAllCurrentBtn').on('click', deselectAllCurrent);
                $('#generateSmartBtn').on('click', generateSmartQuestions);
                $('#selectAllSmartBtn').on('click', selectAllSmart);
                $('#deselectAllSmartBtn').on('click', deselectAllSmart);
                $('#regenerateSmartBtn').on('click', regenerateSmartQuestions);

                // Add event handler for current question checkboxes
                $(document).on('change', '.current-question-checkbox', function () {
                    updateCurrentSelectionStats();
                });
                console.log('Enhanced Test Update page initialized successfully');
            });
        </script>
    </body>
</html>
