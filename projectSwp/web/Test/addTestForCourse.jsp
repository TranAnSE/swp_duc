<%-- 
    Document   : addTestForCourse
    Created on : Jul 8, 2025, 6:09:43 PM
    Author     : ankha
--%>

<%-- web/Test/addTestForCourse.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Create Test for Course - ${courseDetails.course_title}</title>

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
            body {
                padding-top: 80px;
                background-color: #f9f9f9;
            }
            
            .page-wrapper {
                display: flex;
                flex-direction: column;
                min-height: 100vh;
            }

            .content {
                max-width: 1000px;
                width: 100%;
                margin: 0 auto;
                padding: 20px;
            }

            .form-container {
                background-color: #fff;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                margin-bottom: 20px;
            }

            .course-context {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 20px;
                border-radius: 8px;
                margin-bottom: 20px;
            }

            .course-context h4 {
                margin-bottom: 10px;
                font-weight: 600;
            }

            .course-path {
                display: flex;
                align-items: center;
                gap: 10px;
                font-size: 0.9em;
                opacity: 0.9;
            }

            .form-section {
                margin-bottom: 25px;
                padding: 20px;
                border: 1px solid #e0e0e0;
                border-radius: 8px;
                background-color: #f9f9f9;
            }

            .form-section h5 {
                color: #007BFF;
                margin-bottom: 15px;
                font-weight: 600;
            }

            .form-row {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 20px;
                margin-bottom: 15px;
            }

            .form-group {
                display: flex;
                flex-direction: column;
            }

            .form-group label {
                font-weight: 600;
                color: #333;
                margin-bottom: 5px;
            }

            .form-group input,
            .form-group select,
            .form-group textarea {
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 5px;
                font-size: 14px;
            }

            .form-group input:focus,
            .form-group select:focus,
            .form-group textarea:focus {
                border-color: #007BFF;
                outline: none;
                box-shadow: 0 0 0 2px rgba(0, 123, 255, 0.25);
            }

            .test-type-selector {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 15px;
                margin-bottom: 20px;
            }

            .test-type-option {
                padding: 15px;
                border: 2px solid #e0e0e0;
                border-radius: 8px;
                cursor: pointer;
                transition: all 0.3s ease;
                text-align: center;
            }

            .test-type-option:hover {
                border-color: #007BFF;
                background-color: #f8f9fa;
            }

            .test-type-option.selected {
                border-color: #007BFF;
                background-color: #e3f2fd;
            }

            .test-type-option input[type="radio"] {
                display: none;
            }

            .test-type-option .type-title {
                font-weight: 600;
                color: #333;
                margin-bottom: 5px;
            }

            .test-type-option .type-description {
                font-size: 0.9em;
                color: #666;
            }

            .chapter-selector {
                background: #f0f9ff;
                border: 1px solid #0ea5e9;
                border-radius: 8px;
                padding: 15px;
                margin-bottom: 20px;
            }

            .chapter-selector h6 {
                color: #0c4a6e;
                margin-bottom: 10px;
                font-weight: 600;
            }

            .chapter-options {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 10px;
            }

            .chapter-option {
                padding: 10px;
                border: 1px solid #e0e0e0;
                border-radius: 6px;
                cursor: pointer;
                transition: all 0.2s ease;
                background: white;
            }

            .chapter-option:hover {
                border-color: #0ea5e9;
                background-color: #f0f9ff;
            }

            .chapter-option.selected {
                border-color: #0ea5e9;
                background-color: #e0f2fe;
            }

            .chapter-option input[type="radio"] {
                display: none;
            }

            .btn-primary {
                background: linear-gradient(135deg, #007BFF 0%, #0056b3 100%);
                border: none;
                padding: 12px 24px;
                border-radius: 6px;
                color: white;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(0, 123, 255, 0.3);
            }

            .btn-secondary {
                background: #6c757d;
                border: none;
                padding: 12px 24px;
                border-radius: 6px;
                color: white;
                font-weight: 600;
                text-decoration: none;
                display: inline-block;
                transition: all 0.3s ease;
            }

            .btn-secondary:hover {
                background: #5a6268;
                color: white;
                text-decoration: none;
            }

            .alert {
                padding: 12px 16px;
                border-radius: 6px;
                margin-bottom: 20px;
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

            .question-generation-section {
                background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
                border: 2px solid #f59e0b;
                border-radius: 12px;
                padding: 20px;
                margin-bottom: 20px;
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

            @media (max-width: 768px) {
                .test-type-selector {
                    grid-template-columns: 1fr;
                }
                
                .form-row {
                    grid-template-columns: 1fr;
                }
                
                .chapter-options {
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </head>
    <body>
        <div class="page-wrapper">
            <jsp:include page="/header.jsp" />

            <div class="content">
                <!-- Course Context -->
                <div class="course-context">
                    <h4><i class="fas fa-clipboard-check"></i> Create Test for Course</h4>
                    <div class="course-path">
                        <span>${courseDetails.grade_name}</span>
                        <i class="fas fa-arrow-right"></i>
                        <span>${courseDetails.subject_name}</span>
                        <i class="fas fa-arrow-right"></i>
                        <span><strong>${courseDetails.course_title}</strong></span>
                        <c:if test="${selectedChapterId != null}">
                            <i class="fas fa-arrow-right"></i>
                            <span>Chapter Test</span>
                        </c:if>
                    </div>
                </div>

                <form action="${pageContext.request.contextPath}/test" method="post" id="testForm">
                    <input type="hidden" name="action" value="add" />
                    <input type="hidden" name="courseId" value="${courseDetails.course_id}" />
                    <input type="hidden" name="chapterId" value="${selectedChapterId}" />
                    <input type="hidden" name="testOrder" value="${test.test_order}" />

                    <!-- Basic Test Information -->
                    <div class="form-container">
                        <div class="form-section">
                            <h5><i class="fas fa-info-circle"></i> Test Information</h5>

                            <div class="form-row">
                                <div class="form-group">
                                    <label for="name">Test Name *</label>
                                    <input type="text" id="name" name="name" required 
                                           placeholder="e.g., Chapter 1 Quiz, Midterm Exam" />
                                </div>

                                <div class="form-group">
                                    <label for="duration">Duration (minutes) *</label>
                                    <input type="number" id="duration" name="duration" min="5" max="180" 
                                           value="30" required />
                                </div>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label for="numQuestions">Number of Questions *</label>
                                    <input type="number" id="numQuestions" name="numQuestions" 
                                           min="1" max="100" value="10" required />
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="description">Description</label>
                                <textarea id="description" name="description" rows="3" 
                                          placeholder="Describe what this test covers..."></textarea>
                            </div>
                        </div>
                    </div>

                    <!-- Test Type Selection -->
                    <div class="form-container">
                        <div class="form-section">
                            <h5><i class="fas fa-cogs"></i> Test Type</h5>
                            <div class="alert alert-info">
                                <i class="fas fa-info-circle"></i>
                                Choose the type of test you want to create.
                            </div>

                            <div class="test-type-selector">
                                <div class="test-type-option selected" onclick="selectTestType('practice')">
                                    <input type="radio" name="practice" value="true" checked />
                                    <div class="type-title">
                                        <i class="fas fa-play-circle text-success"></i> Practice Test
                                    </div>
                                    <div class="type-description">
                                        Students can retake multiple times. Good for chapter reviews and practice.
                                    </div>
                                </div>

                                <div class="test-type-option" onclick="selectTestType('official')">
                                    <input type="radio" name="practice" value="false" />
                                    <div class="type-title">
                                        <i class="fas fa-certificate text-danger"></i> Official Test
                                    </div>
                                    <div class="type-description">
                                        Students can only take once. Used for graded assessments and exams.
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Chapter Selection (if not pre-selected) -->
                    <c:if test="${selectedChapterId == null}">
                        <div class="form-container">
                            <div class="form-section">
                                <h5><i class="fas fa-layer-group"></i> Test Scope</h5>
                                <div class="chapter-selector">
                                    <h6>Choose Test Level:</h6>
                                    <div class="chapter-options">
                                        <div class="chapter-option selected" onclick="selectChapter(null)">
                                            <input type="radio" name="chapterScope" value="" checked />
                                            <strong>Course-Level Test</strong>
                                            <div style="font-size: 0.9em; color: #666; margin-top: 5px;">
                                                Covers the entire course content
                                            </div>
                                        </div>
                                        
                                        <c:forEach var="chapter" items="${courseChapters}">
                                            <div class="chapter-option" onclick="selectChapter(${chapter.chapter_id})">
                                                <input type="radio" name="chapterScope" value="${chapter.chapter_id}" />
                                                <strong>${chapter.chapter_name}</strong>
                                                <div style="font-size: 0.9em; color: #666; margin-top: 5px;">
                                                    Chapter-specific test
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <!-- Question Selection -->
                    <div class="form-container">
                        <div class="form-section">
                            <h5><i class="fas fa-question-circle"></i> Question Selection</h5>
                            <div class="alert alert-warning">
                                <i class="fas fa-lightbulb"></i>
                                After creating the test, you'll be able to add questions from the course content or create new ones.
                            </div>

                            <div class="question-generation-section">
                                <h6><i class="fas fa-magic"></i> Smart Question Generation</h6>
                                <p>You can automatically generate questions based on course content after the test is created.</p>
                                
                                <div class="generation-controls">
                                    <div class="control-group">
                                        <label>Difficulty Level</label>
                                        <select class="form-control" disabled>
                                            <option>Easy</option>
                                            <option selected>Medium</option>
                                            <option>Hard</option>
                                        </select>
                                    </div>

                                    <div class="control-group">
                                        <label>Question Category</label>
                                        <select class="form-control" disabled>
                                            <option selected>Conceptual</option>
                                            <option>Application</option>
                                            <option>Analysis</option>
                                        </select>
                                    </div>
                                </div>

                                <div style="text-align: center;">
                                    <button type="button" class="btn-generate" disabled>
                                        <i class="fas fa-dice"></i> Available After Test Creation
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Submit Buttons -->
                    <div style="text-align: center; margin-top: 30px;">
                        <button type="submit" class="btn-primary">
                            <i class="fas fa-plus"></i> Create Test
                        </button>
                        <a href="${pageContext.request.contextPath}/course?action=build&id=${courseDetails.course_id}" 
                           class="btn-secondary" style="margin-left: 15px;">
                            <i class="fas fa-arrow-left"></i> Back to Course Builder
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

        <script>
            function selectTestType(type) {
                // Remove selected class from all options
                document.querySelectorAll('.test-type-option').forEach(option => {
                    option.classList.remove('selected');
                });
                
                // Add selected class to clicked option
                event.currentTarget.classList.add('selected');
                
                // Update radio button
                if (type === 'practice') {
                    document.querySelector('input[name="practice"][value="true"]').checked = true;
                } else {
                    document.querySelector('input[name="practice"][value="false"]').checked = true;
                }
            }

            function selectChapter(chapterId) {
                // Remove selected class from all options
                document.querySelectorAll('.chapter-option').forEach(option => {
                    option.classList.remove('selected');
                });
                
                // Add selected class to clicked option
                event.currentTarget.classList.add('selected');
                
                // Update hidden input and radio button
                if (chapterId) {
                    document.querySelector('input[name="chapterScope"][value="' + chapterId + '"]').checked = true;
                    // Update the hidden chapterId field
                    let hiddenChapter = document.querySelector('input[name="chapterId"]');
                    if (hiddenChapter) {
                        hiddenChapter.value = chapterId;
                    }
                } else {
                    document.querySelector('input[name="chapterScope"][value=""]').checked = true;
                    // Clear the hidden chapterId field
                    let hiddenChapter = document.querySelector('input[name="chapterId"]');
                    if (hiddenChapter) {
                        hiddenChapter.value = '';
                    }
                }
            }

            // Form validation
            document.getElementById('testForm').addEventListener('submit', function(e) {
                const name = document.getElementById('name').value.trim();
                const duration = parseInt(document.getElementById('duration').value);
                const numQuestions = parseInt(document.getElementById('numQuestions').value);

                if (!name) {
                    alert('Please enter a test name');
                    e.preventDefault();
                    return;
                }

                if (duration < 5 || duration > 180) {
                    alert('Duration must be between 5 and 180 minutes');
                    e.preventDefault();
                    return;
                }

                if (numQuestions < 1 || numQuestions > 100) {
                    alert('Number of questions must be between 1 and 100');
                    e.preventDefault();
                    return;
                }

                // Show loading state
                const submitBtn = document.querySelector('button[type="submit"]');
                submitBtn.disabled = true;
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Creating Test...';
            });

            // Auto-generate test name based on context
            document.addEventListener('DOMContentLoaded', function() {
                const nameInput = document.getElementById('name');
                const courseTitle = '${courseDetails.course_title}';
                const chapterId = '${selectedChapterId}';
                
                if (chapterId && chapterId !== 'null') {
                    nameInput.placeholder = 'Chapter Test - ' + courseTitle;
                } else {
                    nameInput.placeholder = 'Course Test - ' + courseTitle;
                }
            });
        </script>
    </body>
</html>