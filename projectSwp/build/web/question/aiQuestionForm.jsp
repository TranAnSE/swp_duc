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
    <link rel="stylesheet" href="/assets/css/style.css">
    <style>
        body {
            padding-top: 120px;
            background-color: #f8f9fa;
        }
        .ai-form-container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
        }
        .form-section {
            margin-bottom: 25px;
            padding: 20px;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            background-color: #f8f9fa;
        }
        .section-title {
            font-weight: bold;
            color: #495057;
            margin-bottom: 15px;
            font-size: 1.1rem;
        }
        .ai-icon {
            color: #007bff;
            margin-right: 10px;
        }
        .difficulty-options {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }
        .difficulty-option {
            padding: 8px 16px;
            border: 2px solid #dee2e6;
            border-radius: 20px;
            cursor: pointer;
            transition: all 0.3s;
        }
        .difficulty-option:hover {
            border-color: #007bff;
            background-color: #e7f3ff;
        }
        .difficulty-option input[type="radio"] {
            display: none;
        }
        .difficulty-option input[type="radio"]:checked + label {
            background-color: #007bff;
            color: white;
            border-color: #007bff;
        }
        .generate-btn {
            background: linear-gradient(45deg, #007bff, #0056b3);
            border: none;
            padding: 12px 30px;
            font-size: 1.1rem;
            border-radius: 25px;
            color: white;
            transition: all 0.3s;
        }
        .generate-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,123,255,0.3);
        }
    </style>
</head>
<body>
    <jsp:include page="/header.jsp" />
    
    <div class="container">
        <div class="ai-form-container">
            <h2 class="text-center mb-4">
                <i class="fas fa-robot ai-icon"></i>
                AI Question Generator
            </h2>
            
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>
            
            <form action="/ai-question" method="post" id="aiQuestionForm">
                <input type="hidden" name="action" value="generate">
                
                <!-- Lesson Selection -->
                <div class="form-section">
                    <div class="section-title">
                        <i class="fas fa-book"></i> Select Lesson
                    </div>
                    <select name="lesson_id" class="form-control" required id="lessonSelect">
                        <option value="">-- Choose Lesson --</option>
                        <c:forEach var="lesson" items="${lessons}">
                            <option value="${lesson.id}" data-content="${lesson.content}">
                                ${lesson.name}
                            </option>
                        </c:forEach>
                    </select>
                    <small class="form-text text-muted">
                        Select the lesson for which you want to generate questions
                    </small>
                </div>
                
                <!-- Lesson Content Preview -->
                <div class="form-section" id="lessonPreview" style="display: none;">
                    <div class="section-title">
                        <i class="fas fa-eye"></i> Lesson Content Preview
                    </div>
                    <div id="lessonContent" class="p-3 bg-light border rounded" style="max-height: 200px; overflow-y: auto;">
                    </div>
                </div>
                
                <!-- Question Settings -->
                <div class="form-section">
                    <div class="section-title">
                        <i class="fas fa-cog"></i> Question Settings
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <label for="numberOfQuestions">Number of Questions:</label>
                            <input type="number" name="number_of_questions" id="numberOfQuestions" 
                                   class="form-control" min="1" max="20" value="5" required>
                        </div>
                        <div class="col-md-6">
                            <label for="questionType">Question Type:</label>
                            <select name="question_type" id="questionType" class="form-control" required>
                                <option value="multiple_choice">Multiple Choice</option>
                                <option value="conceptual">Conceptual</option>
                                <option value="application">Application</option>
                                <option value="analysis">Analysis</option>
                            </select>
                        </div>
                    </div>
                </div>
                
                <!-- Difficulty Level -->
                <div class="form-section">
                    <div class="section-title">
                        <i class="fas fa-chart-line"></i> Difficulty Level
                    </div>
                    <div class="difficulty-options">
                        <div class="difficulty-option">
                            <input type="radio" name="difficulty" value="easy" id="diffEasy" checked>
                            <label for="diffEasy">Easy</label>
                        </div>
                        <div class="difficulty-option">
                            <input type="radio" name="difficulty" value="medium" id="diffMedium">
                            <label for="diffMedium">Medium</label>
                        </div>
                        <div class="difficulty-option">
                            <input type="radio" name="difficulty" value="hard" id="diffHard">
                            <label for="diffHard">Hard</label>
                        </div>
                        <div class="difficulty-option">
                            <input type="radio" name="difficulty" value="mixed" id="diffMixed">
                            <label for="diffMixed">Mixed</label>
                        </div>
                    </div>
                </div>
                
                <!-- Additional Instructions -->
                <div class="form-section">
                    <div class="section-title">
                        <i class="fas fa-comments"></i> Additional Instructions (Optional)
                    </div>
                    <textarea name="additional_instructions" class="form-control" rows="4" 
                              placeholder="Provide any specific instructions for the AI about the type of questions you want, focus areas, or special requirements..."></textarea>
                    <small class="form-text text-muted">
                        Example: "Focus on practical applications", "Include real-world examples", "Avoid complex calculations"
                    </small>
                </div>
                
                <!-- Generate Button -->
                <div class="text-center">
                    <button type="submit" class="btn generate-btn">
                        <i class="fas fa-magic"></i> Generate Questions with AI
                    </button>
                    <div class="mt-3">
                        <a href="/Question" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left"></i> Back to Question List
                        </a>
                    </div>
                </div>
            </form>
        </div>
    </div>
    
    <jsp:include page="/footer.jsp" />
    
    <script src="/assets/js/vendor/jquery-1.12.4.min.js"></script>
    <script src="/assets/js/bootstrap.min.js"></script>
    <script>
        $(document).ready(function() {
            // Handle lesson selection
            $('#lessonSelect').change(function() {
                const selectedOption = $(this).find('option:selected');
                const content = selectedOption.data('content');
                
                if (content) {
                    $('#lessonContent').text(content);
                    $('#lessonPreview').show();
                } else {
                    $('#lessonPreview').hide();
                }
            });
            
            // Handle difficulty selection
            $('.difficulty-option').click(function() {
                $(this).find('input[type="radio"]').prop('checked', true);
                $('.difficulty-option').removeClass('selected');
                $(this).addClass('selected');
            });
            
            // Form validation
            $('#aiQuestionForm').submit(function(e) {
                const lessonId = $('#lessonSelect').val();
                const numberOfQuestions = $('#numberOfQuestions').val();
                
                if (!lessonId) {
                    alert('Please select a lesson');
                    e.preventDefault();
                    return false;
                }
                
                if (numberOfQuestions < 1 || numberOfQuestions > 20) {
                    alert('Number of questions must be between 1 and 20');
                    e.preventDefault();
                    return false;
                }
                
                // Show loading state
                $(this).find('button[type="submit"]').prop('disabled', true)
                    .html('<i class="fas fa-spinner fa-spin"></i> Generating Questions...');
            });
        });
    </script>
</body>
</html>
