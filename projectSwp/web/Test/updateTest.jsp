<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
    <head>
        <title>Enhanced Test Update</title>
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

        <!-- Select2 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
        <link href="https://cdn.jsdelivr.net/npm/select2-bootstrap-5-theme@1.3.0/dist/select2-bootstrap-5-theme.min.css" rel="stylesheet" />

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

            .hierarchy-section {
                background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
                border: 2px solid #0ea5e9;
                border-radius: 12px;
                padding: 25px;
                margin-bottom: 25px;
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
                transition: all 0.3s ease;
            }

            .step-item:hover {
                box-shadow: 0 2px 8px rgba(14, 165, 233, 0.1);
            }

            .step-item label {
                font-weight: 600;
                color: #374151;
                margin-bottom: 8px;
                display: block;
            }

            .enhanced-question-list {
                background: white;
                border: 1px solid #e2e8f0;
                border-radius: 10px;
                padding: 20px;
                max-height: 500px;
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

            .filter-section {
                background: #fef3c7;
                border: 1px solid #f59e0b;
                border-radius: 8px;
                padding: 15px;
                margin-bottom: 20px;
            }

            .filter-controls {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
                gap: 15px;
                margin-bottom: 15px;
            }

            .filter-group {
                display: flex;
                flex-direction: column;
                gap: 5px;
            }

            .filter-group label {
                font-weight: 600;
                color: #92400e;
                font-size: 0.875rem;
            }

            .filter-group select {
                padding: 6px 10px;
                border: 1px solid #d1d5db;
                border-radius: 4px;
                font-size: 0.875rem;
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

            input[type="text"], select:not(.select2-hidden-accessible) {
                width: 100%;
                padding: 12px;
                margin: 6px 0 15px 0;
                border: 2px solid #e2e8f0;
                border-radius: 8px;
                transition: border-color 0.2s ease;
            }

            input[type="text"]:focus, select:not(.select2-hidden-accessible):focus {
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
                .hierarchy-steps {
                    grid-template-columns: 1fr;
                }

                .filter-controls {
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
                        </div>

                        <!-- Enhanced Question Management -->
                        <div class="form-section">
                            <h4><i class="fas fa-cogs"></i> Question Management</h4>

                            <div class="alert alert-info">
                                <i class="fas fa-lightbulb"></i>
                                Use the hierarchy below to find and add more questions, or manage currently selected questions
                            </div>

                            <!-- Learning Path Selection for Adding More Questions -->
                            <div class="hierarchy-section">
                                <h5><i class="fas fa-sitemap"></i> Add Questions by Learning Path</h5>
                                <div class="alert alert-info">
                                    <i class="fas fa-route"></i>
                                    Navigate through Grade → Subject → Chapter → Lesson to find additional questions
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

                            <!-- Question Filtering -->
                            <div class="filter-section" id="filterSection" style="display: none;">
                                <h5><i class="fas fa-filter"></i> Filter Available Questions</h5>
                                <div class="filter-controls">
                                    <div class="filter-group">
                                        <label for="difficultyFilter">Difficulty</label>
                                        <select id="difficultyFilter" onchange="applyFilters()">
                                            <option value="all">All Levels</option>
                                            <option value="easy">Easy</option>
                                            <option value="medium">Medium</option>
                                            <option value="hard">Hard</option>
                                        </select>
                                    </div>
                                    <div class="filter-group">
                                        <label for="categoryFilter">Category</label>
                                        <select id="categoryFilter" onchange="applyFilters()">
                                            <option value="all">All Categories</option>
                                            <option value="conceptual">Conceptual</option>
                                            <option value="application">Application</option>
                                            <option value="analysis">Analysis</option>
                                            <option value="synthesis">Synthesis</option>
                                            <option value="evaluation">Evaluation</option>
                                        </select>
                                    </div>
                                    <div class="filter-group">
                                        <label for="sourceFilter">Source</label>
                                        <select id="sourceFilter" onchange="applyFilters()">
                                            <option value="all">All Sources</option>
                                            <option value="ai">AI Generated</option>
                                            <option value="manual">Manual</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <!-- Question List Display -->
                            <div class="enhanced-question-list">
                                <div class="selection-stats">
                                    <span id="selectionInfo">
                                        <i class="fas fa-chart-bar"></i> 
                                        Selected: <span id="selectedCount">0</span> questions
                                    </span>
                                    <span id="lessonInfo" style="display: none;">
                                        <i class="fas fa-map-marker-alt"></i>
                                        Viewing: <span id="currentLessonName"></span>
                                    </span>
                                </div>

                                <div class="bulk-actions">
                                    <button type="button" class="btn-bulk" onclick="selectAllQuestions()">
                                        <i class="fas fa-check-square"></i> Select All
                                    </button>
                                    <button type="button" class="btn-bulk" onclick="deselectAllQuestions()">
                                        <i class="fas fa-square"></i> Deselect All
                                    </button>
                                    <button type="button" class="btn-bulk" onclick="selectByDifficulty()">
                                        <i class="fas fa-layer-group"></i> Select by Difficulty
                                    </button>
                                    <button type="button" class="btn-bulk primary" onclick="addRandomQuestions()" id="randomBtn" style="display: none;">
                                        <i class="fas fa-dice"></i> Add Random Questions
                                    </button>
                                </div>

                                <div id="questionsList">
                                    <c:if test="${empty questionList}">
                                        <div class="alert alert-warning">
                                            <i class="fas fa-exclamation-triangle"></i>
                                            No questions available in the question bank.
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty questionList}">
                                        <c:forEach var="q" items="${questionList}">
                                            <div class="question-item ${selectedQuestionIds.contains(q.id) ? 'selected' : ''}" data-question-id="${q.id}">
                                                <input type="checkbox" name="questionIds" value="${q.id}" 
                                                       class="question-checkbox"
                                                       ${selectedQuestionIds.contains(q.id) ? 'checked' : ''}
                                                       onchange="updateSelectionStats()" />
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
                        </div>

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
                                                               let currentLessonQuestions = [];
                                                               let allAvailableQuestions = [];

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

                                                               // Initialize selection stats
                                                               updateSelectionStats();

                                                               // Hierarchy selection handlers
                                                               $('#gradeSelect').on('change', function () {
                                                                   const gradeId = $(this).val();
                                                                   if (gradeId) {
                                                                       loadSubjects(gradeId);
                                                                       resetSubsequentSelects(['#subjectSelect', '#chapterSelect', '#lessonSelect']);
                                                                       hideFiltersAndRandom();
                                                                   }
                                                               });

                                                               $('#subjectSelect').on('change', function () {
                                                                   const subjectId = $(this).val();
                                                                   if (subjectId) {
                                                                       loadChapters(subjectId);
                                                                       resetSubsequentSelects(['#chapterSelect', '#lessonSelect']);
                                                                       hideFiltersAndRandom();
                                                                   }
                                                               });

                                                               $('#chapterSelect').on('change', function () {
                                                                   const chapterId = $(this).val();
                                                                   if (chapterId) {
                                                                       loadLessons(chapterId);
                                                                       resetSubsequentSelects(['#lessonSelect']);
                                                                       hideFiltersAndRandom();
                                                                   }
                                                               });

                                                               $('#lessonSelect').on('change', function () {
                                                                   const lessonId = $(this).val();
                                                                   if (lessonId) {
                                                                       loadLessonQuestions(lessonId);
                                                                       showFiltersAndRandom();
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

                                                               function hideFiltersAndRandom() {
                                                                   $('#filterSection').hide();
                                                                   $('#randomBtn').hide();
                                                                   $('#lessonInfo').hide();
                                                               }

                                                               function showFiltersAndRandom() {
                                                                   $('#filterSection').show();
                                                                   $('#randomBtn').show();
                                                                   $('#lessonInfo').show();
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

                                                               function loadLessonQuestions(lessonId) {
                                                                   $.get('test', {
                                                                       action: 'getQuestionsByLesson',
                                                                       lessonId: lessonId
                                                                   }, function (data) {
                                                                       currentLessonQuestions = data;
                                                                       allAvailableQuestions = data;

                                                                       // Update lesson info
                                                                       const lessonName = $('#lessonSelect option:selected').text();
                                                                       $('#currentLessonName').text(lessonName);

                                                                       displayAvailableQuestions(data);
                                                                       applyFilters(); // Apply current filters
                                                                   }).fail(function () {
                                                                       console.error('Failed to load questions');
                                                                       alert('Failed to load questions for this lesson');
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
                                                               function displayAvailableQuestions(questions) {
                                                                   if (questions.length === 0) {
                                                                       $('#questionsList').append(`
            <div class="alert alert-info">
                <i class="fas fa-info-circle"></i>
                No questions available for this lesson
            </div>
        `);
                                                                       return;
                                                                   }

                                                                   questions.forEach(function (question) {
                                                                       // Check if question is already selected
                                                                       const isSelected = $(`input[name="questionIds"][value="` + question.id + `"]`).length > 0;

                                                                       if (!isSelected) {
                                                                           const lessonName = $('#lessonSelect option:selected').text();
                                                                           const aiGeneratedBadge = question.isAI ?
                                                                                   '<span class="meta-badge ai-badge">AI Generated</span>' :
                                                                                   '<span class="meta-badge manual-badge">Manual</span>';

                                                                           const questionHtml = `
                <div class="question-item" data-question-id="` + question.id + `" data-difficulty="` + question.difficulty + `" data-category="` + question.category + `" data-source="` + (question.isAI ? 'ai' : 'manual') + `">
                    <input type="checkbox" name="questionIds" value="` + question.id + `" 
                           class="question-checkbox" onchange="updateSelectionStats()" />
                    <div class="question-content">
                        <div class="question-text">` + question.question + `</div>
                        <div class="question-meta">
                            <span class="lesson-name">
                                <i class="fas fa-book"></i>
                                ` + lessonName + `
                            </span>
                            <span class="meta-badge difficulty-` + question.difficulty + `">` + question.difficulty + `</span>
                            <span class="meta-badge category-badge">` + question.category + `</span>
                            <span class="meta-badge">` + question.type + `</span>
                            ` + aiGeneratedBadge + `
                        </div>
                    </div>
                </div>
            `;
                                                                           $('#questionsList').append(questionHtml);
                                                                       }
                                                                   });
                                                               }

                                                               window.addRandomQuestions = function () {
                                                                   const count = prompt('How many random questions to add?', '5');
                                                                   if (count && !isNaN(count) && count > 0) {
                                                                       const lessonId = $('#lessonSelect').val();
                                                                       if (!lessonId) {
                                                                           alert('Please select a lesson first');
                                                                           return;
                                                                       }

                                                                       const difficulty = $('#difficultyFilter').val();
                                                                       const category = $('#categoryFilter').val();

                                                                       $.get('test', {
                                                                           action: 'getRandomQuestions',
                                                                           lessonId: lessonId,
                                                                           count: count,
                                                                           difficulty: difficulty,
                                                                           category: category
                                                                       }, function (data) {
                                                                           if (data.length > 0) {
                                                                               data.forEach(function (question) {
                                                                                   // Check if question is already in the list
                                                                                   if ($(`input[name="questionIds"][value="` + question.id + `"]`).length === 0) {
                                                                                       const lessonName = $('#lessonSelect option:selected').text();
                                                                                       const aiGeneratedBadge = question.isAI ?
                                                                                               '<span class="meta-badge ai-badge">AI Generated</span>' :
                                                                                               '<span class="meta-badge manual-badge">Manual</span>';

                                                                                       const questionHtml = `
                            <div class="question-item selected" data-question-id="` + question.id + `" data-difficulty="` + question.difficulty + `" data-category="` + question.category + `" data-source="` + (question.isAI ? 'ai' : 'manual') + `">
                                <input type="checkbox" name="questionIds" value="` + question.id + `" 
                                       class="question-checkbox" checked onchange="updateSelectionStats()" />
                                <div class="question-content">
                                    <div class="question-text">` + question.question + `</div>
                                    <div class="question-meta">
                                        <span class="lesson-name">
                                            <i class="fas fa-book"></i>
                                            ` + lessonName + `
                                        </span>
                                        <span class="meta-badge difficulty-` + question.difficulty + `">` + question.difficulty + `</span>
                                        <span class="meta-badge category-badge">` + question.category + `</span>
                                        <span class="meta-badge">` + question.type + `</span>
                                        ` + aiGeneratedBadge + `
                                        <span class="meta-badge" style="background: #10b981; color: white;">Random</span>
                                    </div>
                                </div>
                            </div>
                        `;
                                                                                       $('#questionsList').append(questionHtml);
                                                                                   }
                                                                               });
                                                                               updateSelectionStats();

                                                                               // Scroll to show new questions
                                                                               $('.enhanced-question-list').animate({
                                                                                   scrollTop: $('.enhanced-question-list')[0].scrollHeight
                                                                               }, 500);
                                                                           } else {
                                                                               alert('No questions found matching your criteria');
                                                                           }
                                                                       }).fail(function () {
                                                                           alert('Failed to load random questions');
                                                                       });
                                                                   }
                                                               };

                                                               // Selection management functions
                                                               window.updateSelectionStats = function () {
                                                                   const totalSelected = $('input[name="questionIds"]:checked').length;
                                                                   $('#selectedCount').text(totalSelected);

                                                                   // Update visual selection
                                                                   $('.question-item').each(function () {
                                                                       if ($(this).find('.question-checkbox').is(':checked')) {
                                                                           $(this).addClass('selected');
                                                                       } else {
                                                                           $(this).removeClass('selected');
                                                                       }
                                                                   });
                                                               };

                                                               window.selectAllQuestions = function () {
                                                                   $('#questionsList .question-checkbox:visible').prop('checked', true);
                                                                   updateSelectionStats();
                                                               };

                                                               window.deselectAllQuestions = function () {
                                                                   $('#questionsList .question-checkbox:visible').prop('checked', false);
                                                                   updateSelectionStats();
                                                               };

                                                               window.selectByDifficulty = function () {
                                                                   const difficulty = prompt('Select questions by difficulty (easy, medium, hard):');
                                                                   if (difficulty && ['easy', 'medium', 'hard'].includes(difficulty.toLowerCase())) {
                                                                       $('#questionsList .question-item:visible').each(function () {
                                                                           const itemDifficulty = $(this).data('difficulty');
                                                                           if (itemDifficulty === difficulty.toLowerCase()) {
                                                                               $(this).find('.question-checkbox').prop('checked', true);
                                                                           }
                                                                       });
                                                                       updateSelectionStats();
                                                                   }
                                                               };

                                                               window.addRandomQuestions = function () {
                                                                   const count = prompt('How many random questions to add?', '5');
                                                                   if (count && !isNaN(count) && count > 0) {
                                                                       const lessonId = $('#lessonSelect').val();
                                                                       if (!lessonId) {
                                                                           alert('Please select a lesson first');
                                                                           return;
                                                                       }

                                                                       const difficulty = $('#difficultyFilter').val();
                                                                       const category = $('#categoryFilter').val();

                                                                       $.get('test', {
                                                                           action: 'getRandomQuestions',
                                                                           lessonId: lessonId,
                                                                           count: count,
                                                                           difficulty: difficulty,
                                                                           category: category
                                                                       }, function (data) {
                                                                           if (data.length > 0) {
                                                                               data.forEach(function (question) {
                                                                                   // Check if question is already in the list
                                                                                   if ($(`input[name="questionIds"][value="` + question.id + `"]`).length === 0) {
                                                                                       const lessonName = $('#lessonSelect option:selected').text();
                                                                                       const aiGeneratedBadge = question.isAI ?
                                                                                               '<span class="meta-badge ai-badge">AI Generated</span>' :
                                                                                               '<span class="meta-badge manual-badge">Manual</span>';

                                                                                       const questionHtml = `
                            <div class="question-item selected" data-question-id="` + question.id + `" data-difficulty="` + question.difficulty + `" data-category="` + question.category + `" data-source="` + (question.isAI ? 'ai' : 'manual') + `">
                                <input type="checkbox" name="questionIds" value="` + question.id + `" 
                                       class="question-checkbox" checked onchange="updateSelectionStats()" />
                                <div class="question-content">
                                    <div class="question-text">` + question.question + `</div>
                                    <div class="question-meta">
                                        <span class="lesson-name">
                                            <i class="fas fa-book"></i>
                                            ` + lessonName + `
                                        </span>
                                        <span class="meta-badge difficulty-` + question.difficulty + `">` + question.difficulty + `</span>
                                        <span class="meta-badge category-badge">` + question.category + `</span>
                                        <span class="meta-badge">` + question.type + `</span>
                                        ` + aiGeneratedBadge + `
                                        <span class="meta-badge" style="background: #10b981; color: white;">Random</span>
                                    </div>
                                </div>
                            </div>
                        `;
                                                                                       $('#questionsList').append(questionHtml);
                                                                                   }
                                                                               });
                                                                               updateSelectionStats();

                                                                               // Scroll to show new questions
                                                                               $('.enhanced-question-list').animate({
                                                                                   scrollTop: $('.enhanced-question-list')[0].scrollHeight
                                                                               }, 500);
                                                                           } else {
                                                                               alert('No questions found matching your criteria');
                                                                           }
                                                                       }).fail(function () {
                                                                           alert('Failed to load random questions');
                                                                       });
                                                                   }
                                                               };

                                                               // Mark original questions
                                                               $('.question-item').addClass('original-question');

                                                               // Form submission validation
                                                               $('#updateTestForm').on('submit', function (e) {
                                                                   const selectedCount = $('input[name="questionIds"]:checked').length;
                                                                   if (selectedCount === 0) {
                                                                       e.preventDefault();
                                                                       alert('Please select at least one question for the test');
                                                                       return false;
                                                                   }

                                                                   // Show loading state
                                                                   $('input[type="submit"]').prop('disabled', true).val('Updating Test...');
                                                                   return true;
                                                               });

                                                               // Initialize tooltips for better UX
                                                               $('[data-toggle="tooltip"]').tooltip();

                                                               // Add smooth scrolling for better UX
                                                               $('a[href^="#"]').on('click', function (event) {
                                                                   var target = $(this.getAttribute('href'));
                                                                   if (target.length) {
                                                                       event.preventDefault();
                                                                       $('html, body').stop().animate({
                                                                           scrollTop: target.offset().top - 100
                                                                       }, 1000);
                                                                   }
                                                               });

                                                               // Auto-save draft functionality (optional enhancement)
                                                               let autoSaveTimer;
                                                               $('input, select, textarea').on('change', function () {
                                                                   clearTimeout(autoSaveTimer);
                                                                   autoSaveTimer = setTimeout(function () {
                                                                       // Could implement auto-save draft here
                                                                       console.log('Auto-save triggered');
                                                                   }, 5000);
                                                               });

                                                               // Keyboard shortcuts for power users
                                                               $(document).on('keydown', function (e) {
                                                                   // Ctrl+A: Select all visible questions
                                                                   if (e.ctrlKey && e.key === 'a' && e.target.tagName !== 'INPUT' && e.target.tagName !== 'TEXTAREA') {
                                                                       e.preventDefault();
                                                                       selectAllQuestions();
                                                                   }

                                                                   // Ctrl+D: Deselect all questions
                                                                   if (e.ctrlKey && e.key === 'd' && e.target.tagName !== 'INPUT' && e.target.tagName !== 'TEXTAREA') {
                                                                       e.preventDefault();
                                                                       deselectAllQuestions();
                                                                   }

                                                                   // Ctrl+S: Submit form
                                                                   if (e.ctrlKey && e.key === 's') {
                                                                       e.preventDefault();
                                                                       $('#updateTestForm').submit();
                                                                   }
                                                               });

                                                               // Enhanced visual feedback
                                                               $('.question-item').on('mouseenter', function () {
                                                                   $(this).css('transform', 'translateY(-2px)');
                                                               }).on('mouseleave', function () {
                                                                   $(this).css('transform', 'translateY(0)');
                                                               });

                                                               // Question preview on click (optional enhancement)
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

                                                               console.log('Enhanced Test Update page initialized successfully');
                                                           });
        </script>
    </body>
</html>
