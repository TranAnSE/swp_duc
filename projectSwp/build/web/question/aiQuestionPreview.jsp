<%-- 
    Document   : aiQuestionPreview
    Created on : Jun 26, 2025, 10:22:14 PM
    Author     : ankha
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
    <head>
        <title>AI Generated Questions - Preview</title>
        <link rel="stylesheet" href="/assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="/assets/css/fontawesome-all.min.css">
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

            .preview-container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 20px;
            }

            .preview-header {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                padding: 30px;
                border-radius: 20px;
                box-shadow: var(--shadow-lg);
                border: 1px solid rgba(255, 255, 255, 0.2);
                margin-bottom: 30px;
                text-align: center;
            }

            .preview-header h2 {
                color: var(--text-primary);
                font-weight: 700;
                font-size: 2.5rem;
                margin-bottom: 10px;
                background: var(--gradient-primary);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
            }

            .preview-stats {
                display: flex;
                justify-content: center;
                gap: 30px;
                margin-top: 20px;
                flex-wrap: wrap;
            }

            .stat-card {
                background: linear-gradient(135deg, rgba(79, 70, 229, 0.1) 0%, rgba(6, 182, 212, 0.1) 100%);
                border: 1px solid rgba(79, 70, 229, 0.2);
                border-radius: 12px;
                padding: 15px 20px;
                text-align: center;
                min-width: 120px;
            }

            .stat-number {
                font-size: 1.5rem;
                font-weight: 700;
                color: var(--primary-color);
                display: block;
            }

            .stat-label {
                font-size: 0.9rem;
                color: var(--text-secondary);
                margin-top: 5px;
            }

            .question-card {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                border-radius: 16px;
                padding: 25px;
                margin-bottom: 25px;
                box-shadow: var(--shadow-md);
                border: 1px solid rgba(255, 255, 255, 0.2);
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;
            }

            .question-card::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                height: 4px;
                background: var(--gradient-primary);
                opacity: 0;
                transition: opacity 0.3s ease;
            }

            .question-card:hover::before {
                opacity: 1;
            }

            .question-card:hover {
                transform: translateY(-2px);
                box-shadow: var(--shadow-lg);
            }

            .question-header {
                display: flex;
                justify-content: space-between;
                align-items: flex-start;
                margin-bottom: 20px;
                flex-wrap: wrap;
                gap: 15px;
            }

            .question-number {
                background: var(--gradient-primary);
                color: white;
                padding: 8px 16px;
                border-radius: 20px;
                font-weight: 600;
                font-size: 0.9rem;
                min-width: 80px;
                text-align: center;
            }

            .question-type-badge {
                padding: 6px 12px;
                border-radius: 15px;
                font-size: 0.8rem;
                font-weight: 600;
                text-transform: uppercase;
            }

            .type-single {
                background: linear-gradient(135deg, #ecfdf5 0%, #d1fae5 100%);
                color: #065f46;
                border: 1px solid #10b981;
            }

            .type-multiple {
                background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
                color: #92400e;
                border: 1px solid #f59e0b;
            }

            .type-true-false {
                background: linear-gradient(135deg, #e0e7ff 0%, #c7d2fe 100%);
                color: #3730a3;
                border: 1px solid #6366f1;
            }

            .question-content {
                background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
                border: 1px solid #e2e8f0;
                border-radius: 12px;
                padding: 20px;
                margin-bottom: 20px;
            }

            .question-text {
                font-size: 1.1rem;
                font-weight: 500;
                color: var(--text-primary);
                line-height: 1.6;
                margin-bottom: 15px;
            }

            .options-list {
                list-style: none;
                padding: 0;
                margin: 0;
            }

            .option-item {
                background: white;
                border: 2px solid #e5e7eb;
                border-radius: 8px;
                padding: 12px 16px;
                margin-bottom: 8px;
                display: flex;
                align-items: center;
                gap: 12px;
                transition: all 0.2s ease;
            }

            .option-item:hover {
                border-color: var(--primary-color);
                background: rgba(79, 70, 229, 0.02);
            }

            .option-item.correct {
                border-color: var(--success-color);
                background: linear-gradient(135deg, #ecfdf5 0%, #d1fae5 100%);
            }

            .option-letter {
                background: var(--primary-color);
                color: white;
                width: 24px;
                height: 24px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: 600;
                font-size: 0.8rem;
                flex-shrink: 0;
            }

            .option-item.correct .option-letter {
                background: var(--success-color);
            }

            .correct-indicator {
                margin-left: auto;
                color: var(--success-color);
                font-weight: 600;
                font-size: 0.9rem;
            }

            .question-actions {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding-top: 20px;
                border-top: 1px solid #e5e7eb;
                flex-wrap: wrap;
                gap: 15px;
            }

            .approve-checkbox {
                display: flex;
                align-items: center;
                gap: 10px;
                background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
                border: 1px solid #0ea5e9;
                border-radius: 8px;
                padding: 10px 15px;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .approve-checkbox:hover {
                background: linear-gradient(135deg, #e0f2fe 0%, #bae6fd 100%);
            }

            .approve-checkbox input[type="checkbox"] {
                width: 18px;
                height: 18px;
                accent-color: var(--primary-color);
            }

            .approve-checkbox label {
                font-weight: 600;
                color: #0c4a6e;
                cursor: pointer;
                margin: 0;
            }

            .edit-section {
                background: linear-gradient(135deg, #fefce8 0%, #fef3c7 100%);
                border: 1px solid #f59e0b;
                border-radius: 12px;
                padding: 20px;
                margin-top: 15px;
                display: none;
            }

            .edit-section.active {
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

            .edit-section h6 {
                color: #92400e;
                font-weight: 600;
                margin-bottom: 15px;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .form-control, .form-select {
                border: 2px solid #e5e7eb;
                border-radius: 8px;
                padding: 10px 12px;
                transition: all 0.3s ease;
            }

            .form-control:focus, .form-select:focus {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
                outline: none;
            }

            .action-buttons {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                padding: 25px;
                border-radius: 16px;
                box-shadow: var(--shadow-md);
                border: 1px solid rgba(255, 255, 255, 0.2);
                margin-top: 30px;
                text-align: center;
            }

            .btn-approve {
                background: var(--gradient-primary);
                border: none;
                padding: 14px 30px;
                font-size: 1.1rem;
                font-weight: 600;
                border-radius: 25px;
                color: white;
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;
                box-shadow: var(--shadow-md);
            }

            .btn-approve::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
                transition: left 0.5s ease;
            }

            .btn-approve:hover::before {
                left: 100%;
            }

            .btn-approve:hover {
                transform: translateY(-2px);
                box-shadow: var(--shadow-lg);
            }

            .btn-secondary {
                background: white;
                border: 2px solid #e5e7eb;
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

            .btn-edit {
                background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
                border: 1px solid #f59e0b;
                color: #92400e;
                padding: 8px 16px;
                border-radius: 8px;
                font-size: 0.9rem;
                font-weight: 500;
                transition: all 0.3s ease;
            }

            .btn-edit:hover {
                background: linear-gradient(135deg, #fde68a 0%, #fcd34d 100%);
                color: #78350f;
            }

            .ai-chat-section {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                border-radius: 16px;
                padding: 25px;
                margin-bottom: 30px;
                box-shadow: var(--shadow-md);
                border: 1px solid rgba(255, 255, 255, 0.2);
            }

            .chat-header {
                display: flex;
                align-items: center;
                gap: 12px;
                margin-bottom: 20px;
                padding-bottom: 15px;
                border-bottom: 1px solid #e5e7eb;
            }

            .chat-header h4 {
                color: var(--text-primary);
                font-weight: 600;
                margin: 0;
            }

            .chat-input-group {
                display: flex;
                gap: 10px;
                align-items: flex-end;
            }

            .chat-input {
                flex: 1;
                border: 2px solid #e5e7eb;
                border-radius: 12px;
                padding: 12px 16px;
                resize: vertical;
                min-height: 50px;
                transition: all 0.3s ease;
            }

            .chat-input:focus {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
                outline: none;
            }

            .btn-chat {
                background: var(--primary-color);
                border: none;
                color: white;
                padding: 12px 20px;
                border-radius: 12px;
                font-weight: 500;
                transition: all 0.3s ease;
                height: 50px;
            }

            .btn-chat:hover {
                background: #3730a3;
                transform: translateY(-1px);
            }

            .chat-response {
                background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
                border: 1px solid #0ea5e9;
                border-radius: 12px;
                padding: 15px;
                margin-top: 15px;
                display: none;
            }

            .chat-response.active {
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
                .preview-container {
                    padding: 15px;
                }

                .preview-header {
                    padding: 20px;
                    margin-bottom: 20px;
                }

                .preview-header h2 {
                    font-size: 2rem;
                }

                .preview-stats {
                    gap: 15px;
                }

                .question-card {
                    padding: 20px;
                    margin-bottom: 20px;
                }

                .question-header {
                    flex-direction: column;
                    align-items: stretch;
                    gap: 10px;
                }

                .question-actions {
                    flex-direction: column;
                    align-items: stretch;
                    gap: 10px;
                }

                .action-buttons {
                    padding: 20px;
                }

                .btn-approve {
                    width: 100%;
                    padding: 12px 20px;
                    font-size: 1rem;
                }

                .chat-input-group {
                    flex-direction: column;
                    gap: 10px;
                }

                .btn-chat {
                    width: 100%;
                }
            }

            @media (max-width: 480px) {
                body {
                    padding-top: 100px;
                }

                .preview-container {
                    padding: 10px;
                }

                .preview-header {
                    padding: 15px;
                }

                .question-card {
                    padding: 15px;
                }

                .ai-chat-section {
                    padding: 20px;
                }
            }
        </style>
    </head>
    <body>
        <jsp:include page="/header.jsp" />

        <div class="preview-container">
            <div class="preview-header">
                <h2><i class="fas fa-robot me-3"></i>AI Generated Questions</h2>
                <p class="text-muted">Review and approve the questions generated by AI</p>

                <div class="preview-stats">
                    <div class="stat-card">
                        <span class="stat-number">${fn:length(generatedQuestions)}</span>
                        <div class="stat-label">Generated</div>
                    </div>
                    <div class="stat-card">
                        <span class="stat-number" id="approvedCount">0</span>
                        <div class="stat-label">Approved</div>
                    </div>
                    <div class="stat-card">
                        <span class="stat-number" id="editedCount">0</span>
                        <div class="stat-label">Edited</div>
                    </div>
                </div>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    ${error}
                </div>
            </c:if>

            <!-- AI Chat Assistant -->
            <div class="ai-chat-section">
                <div class="chat-header">
                    <i class="fas fa-comments text-primary fa-lg"></i>
                    <h4>Chat with AI Assistant</h4>
                    <span class="badge bg-primary">Beta</span>
                </div>
                <div class="chat-input-group">
                    <textarea id="chatInput" class="chat-input" 
                              placeholder="Ask AI to modify questions, explain concepts, or generate additional questions...&#10;&#10;Examples:&#10;• Make question 3 easier&#10;• Add more options to question 1&#10;• Explain the concept behind question 2"></textarea>
                    <button type="button" class="btn-chat" onclick="chatWithAI()">
                        <i class="fas fa-paper-plane me-2"></i>Send
                    </button>
                </div>
                <div id="chatResponse" class="chat-response"></div>
            </div>

            <!-- Questions Preview -->
            <form action="/ai-question" method="post" id="approveForm">
                <input type="hidden" name="action" value="approve">

                <c:forEach var="question" items="${generatedQuestions}" varStatus="status">
                    <div class="question-card" data-question-index="${status.index}">
                        <div class="question-header">
                            <div class="question-number">
                                Question ${status.index + 1}
                            </div>
                            <div class="question-type-badge type-${question.questionType.toLowerCase().replace('_', '-')}">
                                <c:choose>
                                    <c:when test="${question.questionType == 'single_choice'}">Single Choice</c:when>
                                    <c:when test="${question.questionType == 'multiple_choice'}">Multiple Choice</c:when>
                                    <c:when test="${question.questionType == 'true_false'}">True/False</c:when>
                                    <c:otherwise>${question.questionType}</c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="question-content">
                            <div class="question-text" id="questionText${status.index}">
                                ${question.question}
                            </div>

                            <ul class="options-list">
                                <c:forEach var="option" items="${question.options}" varStatus="optStatus">
                                    <li class="option-item ${question.correctAnswers.contains(optStatus.index) || question.correctAnswerIndex == optStatus.index ? 'correct' : ''}">
                                        <div class="option-letter">
                                            <%=String.valueOf((char)(65 + ${optStatus.index}))%>
                                        </div>
                                        <span class="option-text">${option}</span>
                                        <c:if test="${question.correctAnswers.contains(optStatus.index) || question.correctAnswerIndex == optStatus.index}">
                                            <span class="correct-indicator">
                                                <i class="fas fa-check-circle me-1"></i>Correct
                                            </span>
                                        </c:if>
                                    </li>
                                </c:forEach>
                            </ul>

                            <c:if test="${not empty question.explanation}">
                                <div class="mt-3 p-3 bg-light rounded">
                                    <strong><i class="fas fa-lightbulb me-2 text-warning"></i>Explanation:</strong>
                                    <div class="mt-2" id="questionExplanation${status.index}">${question.explanation}</div>
                                </div>
                            </c:if>
                        </div>

                        <div class="question-actions">
                            <div class="approve-checkbox">
                                <input type="checkbox" name="approved" value="${status.index}" 
                                       id="approve${status.index}" onchange="updateApprovedCount()">
                                <label for="approve${status.index}">
                                    <i class="fas fa-check-circle me-1"></i>
                                    Approve this question
                                </label>
                            </div>

                            <button type="button" class="btn-edit" onclick="toggleEdit(${status.index})">
                                <i class="fas fa-edit me-1"></i>Edit Question
                            </button>
                        </div>

                        <!-- Edit Section -->
                        <div class="edit-section" id="editSection${status.index}">
                            <h6>
                                <i class="fas fa-edit"></i>
                                Edit Question ${status.index + 1}
                            </h6>

                            <div class="mb-3">
                                <label class="form-label">Question Text</label>
                                <textarea name="question_text" class="form-control" rows="3" 
                                          onchange="updateEditedCount()">${question.question}</textarea>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Explanation</label>
                                <textarea name="explanation" class="form-control" rows="2" 
                                          onchange="updateEditedCount()">${question.explanation}</textarea>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <label class="form-label">Difficulty</label>
                                    <select class="form-select" name="difficulty" onchange="updateEditedCount()">
                                        <option value="easy" ${question.difficulty == 'easy' ? 'selected' : ''}>Easy</option>
                                        <option value="medium" ${question.difficulty == 'medium' ? 'selected' : ''}>Medium</option>
                                        <option value="hard" ${question.difficulty == 'hard' ? 'selected' : ''}>Hard</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Category</label>
                                    <select class="form-select" name="category" onchange="updateEditedCount()">
                                        <option value="conceptual">Conceptual</option>
                                        <option value="application">Application</option>
                                        <option value="analysis">Analysis</option>
                                        <option value="synthesis">Synthesis</option>
                                        <option value="evaluation">Evaluation</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>

                <div class="action-buttons">
                    <div class="d-flex justify-content-center gap-3 flex-wrap">
                        <button type="submit" class="btn-approve" id="approveBtn" disabled>
                            <i class="fas fa-check-double me-2"></i>
                            Save Approved Questions
                        </button>
                        <a href="/ai-question?action=form" class="btn btn-secondary">
                            <i class="fas fa-arrow-left me-2"></i>
                            Generate More Questions
                        </a>
                        <a href="/Question" class="btn btn-secondary">
                            <i class="fas fa-list me-2"></i>
                            Back to Question List
                        </a>
                    </div>

                    <div class="mt-3 text-muted">
                        <i class="fas fa-info-circle me-1"></i>
                        Select the questions you want to add to your question bank, then click "Save Approved Questions"
                    </div>
                </div>
            </form>
        </div>

        <jsp:include page="/footer.jsp" />

        <script src="/assets/js/vendor/jquery-1.12.4.min.js"></script>
        <script src="/assets/js/bootstrap.min.js"></script>
        <script>
                                        let editedQuestions = new Set();

                                        function updateApprovedCount() {
                                            const approvedCheckboxes = document.querySelectorAll('input[name="approved"]:checked');
                                            const count = approvedCheckboxes.length;
                                            document.getElementById('approvedCount').textContent = count;
                                            document.getElementById('approveBtn').disabled = count === 0;
                                        }

                                        function updateEditedCount() {
                                            document.getElementById('editedCount').textContent = editedQuestions.size;
                                        }

                                        function toggleEdit(index) {
                                            const editSection = document.getElementById('editSection' + index);
                                            const isActive = editSection.classList.contains('active');

                                            if (isActive) {
                                                editSection.classList.remove('active');
                                            } else {
                                                editSection.classList.add('active');
                                                editedQuestions.add(index);
                                                updateEditedCount();
                                            }
                                        }

                                        function chatWithAI() {
                                            const chatInput = document.getElementById('chatInput');
                                            const chatResponse = document.getElementById('chatResponse');
                                            const message = chatInput.value.trim();

                                            if (!message) {
                                                alert('Please enter a message to chat with AI');
                                                return;
                                            }

                                            // Show loading state
                                            chatResponse.innerHTML = `
                    <div class="d-flex align-items-center">
                        <div class="spinner-border spinner-border-sm text-primary me-3" role="status">
                            <span class="visually-hidden">Loading...</span>
                        </div>
                        <span>AI is thinking...</span>
                    </div>
                `;
                                            chatResponse.classList.add('active');

                                            // Send request to AI
                                            fetch('/ai-question', {
                                                method: 'POST',
                                                headers: {
                                                    'Content-Type': 'application/x-www-form-urlencoded',
                                                },
                                                body: new URLSearchParams({
                                                    'action': 'chat',
                                                    'message': message
                                                })
                                            })
                                                    .then(response => response.json())
                                                    .then(data => {
                                                        if (data.error) {
                                                            chatResponse.innerHTML = `
                            <div class="text-danger">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                Error: ${data.error}
                            </div>
                        `;
                                                        } else {
                                                            chatResponse.innerHTML = `
                            <div class="d-flex align-items-start">
                                <i class="fas fa-robot text-primary me-3 mt-1"></i>
                                <div>
                                    <strong class="text-primary">AI Assistant:</strong>
                                    <div class="mt-2">' + data.response.replace(/\\n/g, '<br>') + '</div>
                                </div>
                            </div>
                        `;
                                                        }
                                                    })
                                                    .catch(error => {
                                                        chatResponse.innerHTML = `
                        <div class="text-danger">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            Failed to get AI response. Please try again.
                        </div>
                    `;
                                                    })
                                                    .finally(() => {
                                                        chatInput.value = '';
                                                    });
                                        }

                                        // Allow Enter key to send chat message
                                        document.getElementById('chatInput').addEventListener('keydown', function (e) {
                                            if (e.key === 'Enter' && !e.shiftKey) {
                                                e.preventDefault();
                                                chatWithAI();
                                            }
                                        });

                                        // Form submission with loading state
                                        document.getElementById('approveForm').addEventListener('submit', function (e) {
                                            const approvedCount = document.querySelectorAll('input[name="approved"]:checked').length;

                                            if (approvedCount === 0) {
                                                e.preventDefault();
                                                alert('Please select at least one question to approve');
                                                return;
                                            }

                                            // Show loading overlay
                                            const submitBtn = document.getElementById('approveBtn');
                                            const originalText = submitBtn.innerHTML;
                                            submitBtn.disabled = true;
                                            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Saving Questions...';

                                            // Add loading overlay
                                            document.body.insertAdjacentHTML('beforeend', `
                    <div id="savingOverlay" style="
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
                            <i class="fas fa-save fa-3x text-success mb-3"></i>
                            <h4>Saving Questions to Database...</h4>
                            <p class="text-muted">Processing ${approvedCount} approved questions</p>
                            <div class="spinner-border text-success" role="status">
                                <span class="visually-hidden">Loading...</span>
                            </div>
                        </div>
                    </div>
                `);

                                            // If saving fails, restore button (timeout fallback)
                                            setTimeout(() => {
                                                const overlay = document.getElementById('savingOverlay');
                                                if (overlay) {
                                                    overlay.remove();
                                                    submitBtn.disabled = false;
                                                    submitBtn.innerHTML = originalText;
                                                }
                                            }, 30000); // 30 second timeout
                                        });

                                        // Smooth scroll animations
                                        const observer = new IntersectionObserver((entries) => {
                                            entries.forEach(entry => {
                                                if (entry.isIntersecting) {
                                                    entry.target.style.opacity = '1';
                                                    entry.target.style.transform = 'translateY(0)';
                                                }
                                            });
                                        });

                                        document.querySelectorAll('.question-card').forEach(card => {
                                            card.style.opacity = '0';
                                            card.style.transform = 'translateY(20px)';
                                            card.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
                                            observer.observe(card);
                                        });

                                        // Auto-scroll to first question on load
                                        setTimeout(() => {
                                            const firstQuestion = document.querySelector('.question-card');
                                            if (firstQuestion) {
                                                firstQuestion.scrollIntoView({
                                                    behavior: 'smooth',
                                                    block: 'start',
                                                    inline: 'nearest'
                                                });
                                            }
                                        }, 500);

                                        // Keyboard shortcuts
                                        document.addEventListener('keydown', function (e) {
                                            // Ctrl/Cmd + A: Select all questions
                                            if ((e.ctrlKey || e.metaKey) && e.key === 'a' && e.target.tagName !== 'INPUT' && e.target.tagName !== 'TEXTAREA') {
                                                e.preventDefault();
                                                const checkboxes = document.querySelectorAll('input[name="approved"]');
                                                const allChecked = Array.from(checkboxes).every(cb => cb.checked);

                                                checkboxes.forEach(cb => {
                                                    cb.checked = !allChecked;
                                                });
                                                updateApprovedCount();
                                            }

                                            // Ctrl/Cmd + S: Save approved questions
                                            if ((e.ctrlKey || e.metaKey) && e.key === 's') {
                                                e.preventDefault();
                                                const approveBtn = document.getElementById('approveBtn');
                                                if (!approveBtn.disabled) {
                                                    document.getElementById('approveForm').submit();
                                                }
                                            }

                                            // Escape: Close all edit sections
                                            if (e.key === 'Escape') {
                                                document.querySelectorAll('.edit-section.active').forEach(section => {
                                                    section.classList.remove('active');
                                                });
                                            }
                                        });

                                        // Initialize tooltips for better UX
                                        const tooltips = [
                                            {selector: '.question-type-badge', title: 'Question type generated by AI'},
                                            {selector: '.correct-indicator', title: 'This is the correct answer'},
                                            {selector: '.approve-checkbox', title: 'Check to include this question in your question bank'},
                                            {selector: '.btn-edit', title: 'Click to modify this question before saving'}
                                        ];

                                        tooltips.forEach(tooltip => {
                                            document.querySelectorAll(tooltip.selector).forEach(element => {
                                                element.setAttribute('title', tooltip.title);
                                                element.setAttribute('data-bs-toggle', 'tooltip');
                                            });
                                        });

                                        // Initialize Bootstrap tooltips if available
                                        if (typeof bootstrap !== 'undefined' && bootstrap.Tooltip) {
                                            const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
                                            tooltipTriggerList.map(function (tooltipTriggerEl) {
                                                return new bootstrap.Tooltip(tooltipTriggerEl);
                                            });
                                        }
        </script>
    </body>
</html>