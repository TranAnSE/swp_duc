<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
    <head>
        <title>Update Question</title>

        <!-- Bootstrap 5 CSS -->
        <link rel="stylesheet" href="/assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="/assets/css/fontawesome-all.min.css">

        <!-- Select2 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
        <link href="https://cdn.jsdelivr.net/npm/select2-bootstrap-5-theme@1.3.0/dist/select2-bootstrap-5-theme.min.css" rel="stylesheet" />

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

            .step-item.editable {
                border-color: #f59e0b;
                background: linear-gradient(135deg, #fefce8 0%, #fef3c7 100%);
                cursor: pointer;
            }

            .step-item.editable:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(245, 158, 11, 0.2);
            }

            .step-label {
                font-weight: 600;
                color: #374151;
                margin-bottom: 8px;
            }

            .step-content {
                color: #6b7280;
                font-size: 0.9rem;
            }

            .step-edit-icon {
                float: right;
                color: #f59e0b;
                cursor: pointer;
            }

            /* Edit Learning Path Section */
            .edit-path-section {
                background: linear-gradient(135deg, #fefce8 0%, #fef3c7 100%);
                border: 2px solid #f59e0b;
                border-radius: 16px;
                padding: 25px;
                margin-bottom: 30px;
                box-shadow: 0 4px 15px rgba(245, 158, 11, 0.1);
                display: none;
            }

            .edit-path-section.active {
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

            .edit-path-title {
                color: #92400e;
                font-weight: 700;
                font-size: 1.3rem;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            /* Select2 Custom Styling */
            .select2-container--bootstrap-5 .select2-selection {
                border: 2px solid #e2e8f0 !important;
                border-radius: 8px !important;
                min-height: 45px !important;
                padding: 5px 10px !important;
            }

            .select2-container--bootstrap-5 .select2-selection--single .select2-selection__rendered {
                line-height: 33px !important;
                padding-left: 0 !important;
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

            .select2-container {
                width: 100% !important;
            }

            .select2-container--open {
                z-index: 9999 !important;
            }

            .select2-dropdown {
                z-index: 9999 !important;
            }

            .btn-edit-path {
                background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
                border: 1px solid #f59e0b;
                color: #92400e;
                padding: 8px 16px;
                border-radius: 8px;
                font-size: 0.9rem;
                font-weight: 500;
                transition: all 0.3s ease;
            }

            .btn-edit-path:hover {
                background: linear-gradient(135deg, #fde68a 0%, #fcd34d 100%);
                color: #78350f;
                transform: translateY(-1px);
            }

            .btn-save-path {
                background: linear-gradient(135deg, #10b981 0%, #059669 100%);
                border: none;
                color: white;
                padding: 10px 20px;
                border-radius: 8px;
                font-weight: 500;
                transition: all 0.3s ease;
            }

            .btn-save-path:hover {
                background: linear-gradient(135deg, #059669 0%, #047857 100%);
                transform: translateY(-1px);
            }

            .btn-cancel-path {
                background: #6b7280;
                border: none;
                color: white;
                padding: 10px 20px;
                border-radius: 8px;
                font-weight: 500;
                transition: all 0.3s ease;
            }

            .btn-cancel-path:hover {
                background: #4b5563;
                transform: translateY(-1px);
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
                        <button type="button" class="btn btn-edit-path ms-auto" onclick="toggleEditPath()">
                            <i class="fas fa-edit me-1"></i>Edit Path
                        </button>
                    </div>

                    <div class="hierarchy-steps">
                        <div class="step-item completed">
                            <div class="step-label">Grade</div>
                            <div class="step-content">${selectedGrade.name}</div>
                        </div>
                        <c:if test="${not empty selectedSubject}">
                            <div class="step-item completed">
                                <div class="step-label">Subject</div>
                                <div class="step-content">${selectedSubject.name}</div>
                            </div>
                        </c:if>
                        <c:if test="${not empty selectedChapter}">
                            <div class="step-item completed">
                                <div class="step-label">Chapter</div>
                                <div class="step-content">${selectedChapter.name}</div>
                            </div>
                        </c:if>
                        <c:if test="${not empty selectedLesson}">
                            <div class="step-item completed">
                                <div class="step-label">Lesson</div>
                                <div class="step-content">${selectedLesson.name}</div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </c:if>

            <!-- Edit Learning Path Section -->
            <div class="edit-path-section" id="editPathSection">
                <div class="edit-path-title">
                    <i class="fas fa-edit"></i>
                    Edit Learning Path
                </div>

                <div class="hierarchy-steps">
                    <div class="step-item">
                        <div class="step-label">Grade</div>
                        <select id="gradeSelect" class="form-select select2-dropdown">
                            <option value="">-- Select Grade --</option>
                            <c:forEach var="grade" items="${gradeList}">
                                <option value="${grade.id}" ${selectedGrade != null && selectedGrade.id == grade.id ? 'selected' : ''}>
                                    ${grade.name}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="step-item">
                        <div class="step-label">Subject</div>
                        <select id="subjectSelect" class="form-select select2-dropdown" disabled>
                            <option value="">-- Select Subject --</option>
                        </select>
                    </div>

                    <div class="step-item">
                        <div class="step-label">Chapter</div>
                        <select id="chapterSelect" class="form-select select2-dropdown" disabled>
                            <option value="">-- Select Chapter --</option>
                        </select>
                    </div>

                    <div class="step-item">
                        <div class="step-label">Lesson</div>
                        <select id="lessonSelect" class="form-select select2-dropdown" disabled>
                            <option value="">-- Select Lesson --</option>
                        </select>
                    </div>
                </div>

                <div class="mt-3 d-flex gap-2">
                    <button type="button" class="btn-save-path" onclick="savePathChanges()">
                        <i class="fas fa-save me-1"></i>Save Changes
                    </button>
                    <button type="button" class="btn-cancel-path" onclick="cancelPathEdit()">
                        <i class="fas fa-times me-1"></i>Cancel
                    </button>
                </div>

                <div class="alert alert-info mt-3">
                    <i class="fas fa-info-circle me-2"></i>
                    Changing the learning path will update where this question is categorized in the system.
                </div>
            </div>

            <!-- Update Form -->
            <div class="card">
                <div class="card-body">
                    <form name="questionForm" method="post" action="Question" enctype="multipart/form-data" onsubmit="return validateForm()">
                        <input type="hidden" name="action" value="update" />
                        <input type="hidden" name="id" value="${question.id}" />
                        <input type="hidden" name="lesson_id" value="${question.lesson_id}" id="hiddenLessonId" />

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
        <!-- Select2 JS -->
        <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

        <script>
                        $(document).ready(function () {
                            let isEditingPath = false;
                            let originalLessonId = ${question.lesson_id};

                            // Initialize Select2 for any select elements
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

                            // Helper functions for AJAX calls
                            function loadSubjects(gradeId, targetSelector) {
                                $.get('Question', {
                                    action: 'getSubjectsByGrade',
                                    gradeId: gradeId
                                }, function (data) {
                                    const $select = $(targetSelector);
                                    $select.empty().append('<option value="">-- Select Subject --</option>');
                                    $.each(data, function (i, item) {
                                        $select.append('<option value="' + item.id + '">' + item.name + '</option>');
                                    });
                                    $select.prop('disabled', false);

                                    // Reinitialize Select2
                                    $select.select2('destroy');
                                    initializeSelect2(targetSelector);

                                    // Auto-select if editing existing question
            <c:if test="${not empty selectedSubject}">
                                    if (gradeId == ${selectedGrade.id}) {
                                        $select.val(${selectedSubject.id}).trigger('change');
                                    }
            </c:if>
                                }).fail(function () {
                                    console.error('Failed to load subjects');
                                });
                            }

                            function loadChapters(subjectId, targetSelector) {
                                $.get('Question', {
                                    action: 'getChaptersBySubject',
                                    subjectId: subjectId
                                }, function (data) {
                                    const $select = $(targetSelector);
                                    $select.empty().append('<option value="">-- Select Chapter --</option>');
                                    $.each(data, function (i, item) {
                                        $select.append('<option value="' + item.id + '">' + item.name + '</option>');
                                    });
                                    $select.prop('disabled', false);

                                    // Reinitialize Select2
                                    $select.select2('destroy');
                                    initializeSelect2(targetSelector);

                                    // Auto-select if editing existing question
            <c:if test="${not empty selectedChapter}">
                                    if (subjectId == ${selectedSubject.id}) {
                                        $select.val(${selectedChapter.id}).trigger('change');
                                    }
            </c:if>
                                }).fail(function () {
                                    console.error('Failed to load chapters');
                                });
                            }

                            function loadLessons(chapterId, targetSelector) {
                                $.get('Question', {
                                    action: 'getLessonsByChapter',
                                    chapterId: chapterId
                                }, function (data) {
                                    const $select = $(targetSelector);
                                    $select.empty().append('<option value="">-- Select Lesson --</option>');
                                    $.each(data, function (i, item) {
                                        $select.append('<option value="' + item.id + '">' + item.name + '</option>');
                                    });
                                    $select.prop('disabled', false);

                                    // Reinitialize Select2
                                    $select.select2('destroy');
                                    initializeSelect2(targetSelector);

                                    // Auto-select if editing existing question
            <c:if test="${not empty selectedLesson}">
                                    if (chapterId == ${selectedChapter.id}) {
                                        $select.val(${selectedLesson.id}).trigger('change');
                                    }
            </c:if>
                                }).fail(function () {
                                    console.error('Failed to load lessons');
                                });
                            }

                            // Event handlers for hierarchy selection
                            $('#gradeSelect').on('change', function () {
                                const gradeId = $(this).val();
                                if (gradeId) {
                                    loadSubjects(gradeId, '#subjectSelect');
                                    // Reset subsequent selects
                                    $('#chapterSelect').empty().append('<option value="">-- Select Chapter --</option>').prop('disabled', true);
                                    $('#lessonSelect').empty().append('<option value="">-- Select Lesson --</option>').prop('disabled', true);
                                }
                            });

                            $('#subjectSelect').on('change', function () {
                                const subjectId = $(this).val();
                                if (subjectId) {
                                    loadChapters(subjectId, '#chapterSelect');
                                    // Reset lesson select
                                    $('#lessonSelect').empty().append('<option value="">-- Select Lesson --</option>').prop('disabled', true);
                                }
                            });

                            $('#chapterSelect').on('change', function () {
                                const chapterId = $(this).val();
                                if (chapterId) {
                                    loadLessons(chapterId, '#lessonSelect');
                                }
                            });

                            // Initialize with current values if editing
            <c:if test="${not empty selectedGrade}">
                            $('#gradeSelect').val(${selectedGrade.id}).trigger('change');
            </c:if>

                            // Global functions
                            window.toggleEditPath = function () {
                                isEditingPath = !isEditingPath;
                                const section = $('#editPathSection');

                                if (isEditingPath) {
                                    section.addClass('active');
                                    // Scroll to edit section
                                    $('html, body').animate({
                                        scrollTop: section.offset().top - 100
                                    }, 500);
                                } else {
                                    section.removeClass('active');
                                }
                            };

                            window.savePathChanges = function () {
                                const lessonId = $('#lessonSelect').val();

                                if (!lessonId) {
                                    alert('Please select a complete learning path (Grade → Subject → Chapter → Lesson)');
                                    return;
                                }

                                // Update the hidden lesson_id field
                                $('#hiddenLessonId').val(lessonId);

                                // Show confirmation
                                if (confirm('Are you sure you want to change the learning path for this question?')) {
                                    // Update the display and hide edit section
                                    alert('Learning path updated! The changes will be saved when you update the question.');
                                    cancelPathEdit();
                                }
                            };

                            window.cancelPathEdit = function () {
                                // Reset to original values
                                $('#hiddenLessonId').val(originalLessonId);
                                $('#editPathSection').removeClass('active');
                                isEditingPath = false;

                                // Reset selects to original values
            <c:if test="${not empty selectedGrade}">
                                $('#gradeSelect').val(${selectedGrade.id}).trigger('change');
            </c:if>
                            };

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