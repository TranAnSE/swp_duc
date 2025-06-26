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
        <title>AI Generated Questions - Preview & Edit</title>
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
            }

            body {
                padding-top: 120px;
                background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
                min-height: 100vh;
                font-family: 'Inter', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            .preview-container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 20px;
            }

            .page-header {
                text-align: center;
                margin-bottom: 40px;
                background: rgba(255, 255, 255, 0.9);
                backdrop-filter: blur(10px);
                padding: 30px;
                border-radius: 20px;
                box-shadow: var(--shadow-lg);
            }

            .page-header h2 {
                color: var(--text-primary);
                font-weight: 700;
                font-size: 2.2rem;
                margin-bottom: 10px;
                background: var(--gradient-primary);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
            }

            .question-card {
                background: white;
                border-radius: 16px;
                padding: 30px;
                margin-bottom: 25px;
                box-shadow: var(--shadow-md);
                border: 1px solid var(--border-color);
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
            }

            .question-card:hover {
                transform: translateY(-2px);
                box-shadow: var(--shadow-lg);
            }

            .question-header {
                display: flex;
                justify-content: space-between;
                align-items: flex-start;
                margin-bottom: 25px;
                gap: 20px;
            }

            .question-number {
                background: var(--gradient-primary);
                color: white;
                border-radius: 50%;
                width: 45px;
                height: 45px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: 700;
                font-size: 1.1rem;
                flex-shrink: 0;
                box-shadow: var(--shadow-sm);
            }

            .question-text {
                flex: 1;
                font-size: 1.15rem;
                font-weight: 600;
                color: var(--text-primary);
                line-height: 1.5;
                margin-left: 15px;
            }

            .question-controls {
                display: flex;
                flex-direction: column;
                gap: 10px;
                align-items: flex-end;
            }

            .question-type-badge {
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 0.8rem;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .type-single {
                background: #dbeafe;
                color: #1d4ed8;
            }
            .type-multiple {
                background: #dcfce7;
                color: #166534;
            }
            .type-true-false {
                background: #fef3c7;
                color: #92400e;
            }

            .option-list {
                margin: 20px 0;
            }

            .option-item {
                padding: 15px 20px;
                margin: 8px 0;
                border: 2px solid var(--border-color);
                border-radius: 12px;
                background: #fafbff;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                gap: 12px;
            }

            .option-item:hover {
                background: #f1f5f9;
                border-color: var(--primary-color);
            }

            .option-item.correct {
                background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%);
                border-color: var(--success-color);
                color: #065f46;
                font-weight: 600;
            }

            .option-item.correct::after {
                content: '✓';
                color: var(--success-color);
                font-weight: bold;
                font-size: 1.2rem;
                margin-left: auto;
            }

            .option-letter {
                background: var(--primary-color);
                color: white;
                width: 28px;
                height: 28px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: 600;
                font-size: 0.9rem;
                flex-shrink: 0;
            }

            .option-item.correct .option-letter {
                background: var(--success-color);
            }

            .explanation-box {
                background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%);
                border: 1px solid #93c5fd;
                border-radius: 12px;
                padding: 20px;
                margin-top: 20px;
                position: relative;
            }

            .explanation-box::before {
                content: '💡';
                position: absolute;
                top: -10px;
                left: 20px;
                background: white;
                padding: 5px 10px;
                border-radius: 20px;
                font-size: 1.2rem;
            }

            .explanation-title {
                font-weight: 600;
                color: var(--primary-color);
                margin-bottom: 10px;
                margin-left: 30px;
            }

            .explanation-text {
                color: var(--text-primary);
                line-height: 1.6;
            }

            .edit-mode {
                border: 2px dashed var(--warning-color) !important;
                background: linear-gradient(135deg, #fffbeb 0%, #fef3c7 100%) !important;
            }

            .edit-controls {
                margin-top: 20px;
                padding: 20px;
                background: rgba(251, 191, 36, 0.1);
                border-radius: 12px;
                border: 1px solid var(--warning-color);
                display: none;
            }

            .edit-mode .edit-controls {
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

            .approve-section {
                background: white;
                padding: 30px;
                border-radius: 16px;
                margin-top: 40px;
                box-shadow: var(--shadow-lg);
                border: 1px solid var(--border-color);
            }

            .approve-header {
                display: flex;
                align-items: center;
                gap: 15px;
                margin-bottom: 20px;
            }

            .approve-icon {
                background: var(--gradient-primary);
                color: white;
                width: 50px;
                height: 50px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.5rem;
            }

            .btn-group-custom {
                display: flex;
                gap: 15px;
                flex-wrap: wrap;
            }

            .btn-custom {
                padding: 12px 24px;
                border-radius: 12px;
                font-weight: 600;
                transition: all 0.3s ease;
                border: 2px solid transparent;
            }

            .btn-primary-custom {
                background: var(--gradient-primary);
                color: white;
                box-shadow: var(--shadow-md);
            }

            .btn-primary-custom:hover {
                transform: translateY(-2px);
                box-shadow: var(--shadow-lg);
            }

            .btn-outline-custom {
                background: white;
                color: var(--text-secondary);
                border-color: var(--border-color);
            }

            .btn-outline-custom:hover {
                border-color: var(--primary-color);
                color: var(--primary-color);
                background: rgba(79, 70, 229, 0.05);
            }

            .ai-assistant-card {
                position: sticky;
                top: 140px;
                background: white;
                border-radius: 16px;
                padding: 25px;
                box-shadow: var(--shadow-lg);
                border: 1px solid var(--border-color);
            }

            .ai-assistant-header {
                background: var(--gradient-primary);
                color: white;
                padding: 15px 20px;
                border-radius: 12px;
                margin: -25px -25px 20px -25px;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .chat-section {
                position: fixed;
                right: 30px;
                top: 150px;
                width: 380px;
                height: 450px;
                background: white;
                border-radius: 16px;
                box-shadow: var(--shadow-lg);
                display: none;
                z-index: 1000;
                border: 1px solid var(--border-color);
                overflow: hidden;
            }

            .chat-header {
                background: var(--gradient-primary);
                color: white;
                padding: 20px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .chat-messages {
                height: 280px;
                overflow-y: auto;
                padding: 20px;
                background: #fafbff;
            }

            .chat-messages::-webkit-scrollbar {
                width: 6px;
            }

            .chat-messages::-webkit-scrollbar-track {
                background: #f1f5f9;
            }

            .chat-messages::-webkit-scrollbar-thumb {
                background: #cbd5e1;
                border-radius: 3px;
            }

            .message {
                margin-bottom: 15px;
                padding: 12px 16px;
                border-radius: 12px;
                max-width: 85%;
                line-height: 1.4;
            }

            .message.user {
                background: var(--primary-color);
                color: white;
                margin-left: auto;
                border-bottom-right-radius: 4px;
            }

            .message.ai {
                background: white;
                color: var(--text-primary);
                border: 1px solid var(--border-color);
                border-bottom-left-radius: 4px;
            }

            .chat-input {
                padding: 20px;
                border-top: 1px solid var(--border-color);
                background: white;
            }

            .floating-chat-btn {
                position: fixed;
                right: 30px;
                bottom: 30px;
                width: 60px;
                height: 60px;
                background: var(--gradient-primary);
                color: white;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 24px;
                cursor: pointer;
                box-shadow: var(--shadow-lg);
                z-index: 999;
                transition: all 0.3s ease;
            }

            .floating-chat-btn:hover {
                transform: scale(1.1);
                box-shadow: 0 8px 25px rgba(79, 70, 229, 0.4);
            }

            .form-check-custom {
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 10px 15px;
                background: rgba(79, 70, 229, 0.05);
                border-radius: 8px;
                border: 1px solid rgba(79, 70, 229, 0.2);
                transition: all 0.3s ease;
            }

            .form-check-custom:hover {
                background: rgba(79, 70, 229, 0.1);
            }

            .form-check-custom input[type="checkbox"] {
                width: 18px;
                height: 18px;
                accent-color: var(--primary-color);
            }

            @media (max-width: 1200px) {
                .chat-section {
                    right: 20px;
                    width: 350px;
                }
            }

            @media (max-width: 768px) {
                .preview-container {
                    padding: 15px;
                }

                .question-card {
                    padding: 20px;
                }

                .question-header {
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 15px;
                }

                .question-text {
                    margin-left: 0;
                    font-size: 1.1rem;
                }

                .question-controls {
                    align-items: flex-start;
                    flex-direction: row;
                    width: 100%;
                    justify-content: space-between;
                }

                .chat-section {
                    position: fixed;
                    top: 0;
                    left: 0;
                    right: 0;
                    bottom: 0;
                    width: 100%;
                    height: 100%;
                    border-radius: 0;
                }

                .floating-chat-btn {
                    right: 20px;
                    bottom: 20px;
                }

                .btn-group-custom {
                    flex-direction: column;
                }

                .btn-custom {
                    width: 100%;
                    text-align: center;
                }
            }
        </style>
    </head>
    <body>
        <jsp:include page="/header.jsp" />

        <div class="container preview-container">
            <div class="row">
                <div class="col-lg-8">
                    <div class="page-header">
                        <h2><i class="fas fa-robot me-3"></i>AI Generated Questions</h2>
                        <p class="text-muted mb-0">Review, edit, and approve your AI-generated questions</p>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            ${error}
                        </div>
                    </c:if>

                    <form action="/ai-question" method="post" id="approveForm">
                        <input type="hidden" name="action" value="approve">

                        <c:forEach var="question" items="${generatedQuestions}" varStatus="status">
                            <div class="question-card" id="question-${status.index}">
                                <div class="question-header">
                                    <div class="d-flex align-items-center">
                                        <div class="question-number">${status.index + 1}</div>
                                        <div class="question-text" id="questionText-${status.index}">
                                            ${question.question}
                                        </div>
                                    </div>
                                    <div class="question-controls">
                                        <span class="question-type-badge type-${question.questionType.replace('_', '-')}">
                                            <c:choose>
                                                <c:when test="${question.questionType == 'single_choice'}">Single Choice</c:when>
                                                <c:when test="${question.questionType == 'multiple_choice'}">Multiple Choice</c:when>
                                                <c:when test="${question.questionType == 'true_false'}">True/False</c:when>
                                                <c:otherwise>${question.questionType}</c:otherwise>
                                            </c:choose>
                                        </span>
                                        <button type="button" class="btn btn-outline-primary btn-sm edit-btn" 
                                                data-index="${status.index}">
                                            <i class="fas fa-edit me-1"></i> Edit
                                        </button>
                                        <div class="form-check-custom">
                                            <input type="checkbox" name="approved" value="${status.index}" 
                                                   class="form-check-input" id="approve-${status.index}" checked>
                                            <label class="form-check-label" for="approve-${status.index}">
                                                <strong>Approve</strong>
                                            </label>
                                        </div>
                                    </div>
                                </div>

                                <!-- Editable Question Text -->
                                <div class="edit-controls">
                                    <label class="form-label fw-bold">Edit Question:</label>
                                    <textarea name="question_text" class="form-control mb-3" rows="3">${question.question}</textarea>
                                </div>

                                <!-- Options -->
                                <div class="option-list">
                                    <c:forEach var="option" items="${question.options}" varStatus="optStatus">
                                        <c:set var="isCorrect" value="false" />
                                        <c:forEach var="correctIndex" items="${question.correctAnswers}">
                                            <c:if test="${correctIndex == optStatus.index}">
                                                <c:set var="isCorrect" value="true" />
                                            </c:if>
                                        </c:forEach>

                                        <div class="option-item ${isCorrect ? 'correct' : ''}">
                                            <div class="option-letter">
                                                <c:choose>
                                                    <c:when test="${question.questionType == 'true_false'}">
                                                        <c:choose>
                                                            <c:when test="${optStatus.index == 0}">T</c:when>
                                                            <c:otherwise>F</c:otherwise>
                                                        </c:choose>
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${optStatus.index == 0 ? 'A' : (optStatus.index == 1 ? 'B' : (optStatus.index == 2 ? 'C' : (optStatus.index == 3 ? 'D' : (optStatus.index == 4 ? 'E' : 'F'))))}
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <span class="option-content">${option}</span>
                                        </div>
                                    </c:forEach>
                                </div>

                                <!-- Explanation -->
                                <div class="explanation-box">
                                    <div class="explanation-title">Explanation</div>
                                    <div class="explanation-text" id="explanationText-${status.index}">
                                        ${question.explanation}
                                    </div>

                                    <!-- Editable Explanation -->
                                    <div class="edit-controls mt-3">
                                        <label class="form-label fw-bold">Edit Explanation:</label>
                                        <textarea name="explanation" class="form-control" rows="3">${question.explanation}</textarea>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>

                        <!-- Approve Section -->
                        <div class="approve-section">
                            <div class="approve-header">
                                <div class="approve-icon">
                                    <i class="fas fa-check-circle"></i>
                                </div>
                                <div>
                                    <h4 class="mb-1">Approve Questions</h4>
                                    <p class="text-muted mb-0">
                                        Review the generated questions above. You can edit them directly or use the AI chat to refine them.
                                        Only checked questions will be added to your question bank.
                                    </p>
                                </div>
                            </div>

                            <div class="row align-items-center">
                                <div class="col-md-6">
                                    <div class="btn-group-custom">
                                        <button type="button" class="btn btn-outline-custom" id="selectAllBtn">
                                            <i class="fas fa-check-double me-2"></i>Select All
                                        </button>
                                        <button type="button" class="btn btn-outline-custom" id="deselectAllBtn">
                                            <i class="fas fa-times me-2"></i>Deselect All
                                        </button>
                                    </div>
                                </div>
                                <div class="col-md-6 text-md-end mt-3 mt-md-0">
                                    <div class="btn-group-custom justify-content-end">
                                        <a href="/ai-question?action=form" class="btn btn-outline-custom">
                                            <i class="fas fa-arrow-left me-2"></i>Back
                                        </a>
                                        <button type="submit" class="btn btn-primary-custom">
                                            <i class="fas fa-save me-2"></i>Save Approved Questions
                                        </button>
                                    </div>
                                </div>
                            </div>

                            <!-- Selection Summary -->
                            <div class="mt-3 p-3 bg-light rounded">
                                <div class="d-flex align-items-center justify-content-between">
                                    <span class="fw-bold">Selected Questions: <span id="selectedCount">0</span> / ${fn:length(generatedQuestions)}</span>
                                    <div class="progress" style="width: 200px; height: 8px;">
                                        <div class="progress-bar bg-success" id="selectionProgress" style="width: 0%"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- AI Assistant Sidebar -->
                <div class="col-lg-4">
                    <div class="ai-assistant-card">
                        <div class="ai-assistant-header">
                            <i class="fas fa-robot"></i>
                            <h5 class="mb-0">AI Assistant</h5>
                        </div>
                        <div class="card-body p-0">
                            <p class="text-muted mb-3">
                                Need help refining the questions? Chat with AI to get suggestions for improvements.
                            </p>

                            <!-- Quick Actions -->
                            <div class="mb-3">
                                <h6 class="fw-bold mb-2">Quick Actions:</h6>
                                <div class="d-grid gap-2">
                                    <button type="button" class="btn btn-outline-primary btn-sm quick-action" 
                                            data-action="Make questions easier">
                                        <i class="fas fa-level-down-alt me-2"></i>Make Easier
                                    </button>
                                    <button type="button" class="btn btn-outline-primary btn-sm quick-action" 
                                            data-action="Make questions more challenging">
                                        <i class="fas fa-level-up-alt me-2"></i>Make Harder
                                    </button>
                                    <button type="button" class="btn btn-outline-primary btn-sm quick-action" 
                                            data-action="Add more real-world examples">
                                        <i class="fas fa-globe me-2"></i>Add Examples
                                    </button>
                                    <button type="button" class="btn btn-outline-primary btn-sm quick-action" 
                                            data-action="Improve question clarity">
                                        <i class="fas fa-search me-2"></i>Improve Clarity
                                    </button>
                                </div>
                            </div>

                            <button type="button" class="btn btn-primary w-100" id="openChatBtn">
                                <i class="fas fa-comments me-2"></i>Open AI Chat
                            </button>
                        </div>
                    </div>

                    <!-- Question Statistics -->
                    <div class="ai-assistant-card mt-4">
                        <h6 class="fw-bold mb-3">
                            <i class="fas fa-chart-bar me-2"></i>Question Statistics
                        </h6>
                        <div class="row text-center">
                            <div class="col-4">
                                <div class="fw-bold text-primary fs-4" id="totalQuestions">${fn:length(generatedQuestions)}</div>
                                <small class="text-muted">Total</small>
                            </div>
                            <div class="col-4">
                                <div class="fw-bold text-success fs-4" id="approvedQuestions">0</div>
                                <small class="text-muted">Approved</small>
                            </div>
                            <div class="col-4">
                                <div class="fw-bold text-warning fs-4" id="editedQuestions">0</div>
                                <small class="text-muted">Edited</small>
                            </div>
                        </div>

                        <!-- Question Type Breakdown -->
                        <div class="mt-3">
                            <h6 class="fw-bold mb-2">Question Types:</h6>
                            <c:set var="singleCount" value="0" />
                            <c:set var="multipleCount" value="0" />
                            <c:set var="trueFalseCount" value="0" />

                            <c:forEach var="question" items="${generatedQuestions}">
                                <c:choose>
                                    <c:when test="${question.questionType == 'single_choice'}">
                                        <c:set var="singleCount" value="${singleCount + 1}" />
                                    </c:when>
                                    <c:when test="${question.questionType == 'multiple_choice'}">
                                        <c:set var="multipleCount" value="${multipleCount + 1}" />
                                    </c:when>
                                    <c:when test="${question.questionType == 'true_false'}">
                                        <c:set var="trueFalseCount" value="${trueFalseCount + 1}" />
                                    </c:when>
                                </c:choose>
                            </c:forEach>

                            <div class="small">
                                <div class="d-flex justify-content-between mb-1">
                                    <span><i class="fas fa-dot-circle text-primary me-1"></i>Single Choice:</span>
                                    <span class="fw-bold">${singleCount}</span>
                                </div>
                                <div class="d-flex justify-content-between mb-1">
                                    <span><i class="fas fa-check-square text-success me-1"></i>Multiple Choice:</span>
                                    <span class="fw-bold">${multipleCount}</span>
                                </div>
                                <div class="d-flex justify-content-between">
                                    <span><i class="fas fa-balance-scale text-warning me-1"></i>True/False:</span>
                                    <span class="fw-bold">${trueFalseCount}</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Floating Chat Button -->
        <div class="floating-chat-btn" id="floatingChatBtn">
            <i class="fas fa-comments"></i>
        </div>

        <!-- Chat Section -->
        <div class="chat-section" id="chatSection">
            <div class="chat-header">
                <div class="d-flex align-items-center">
                    <i class="fas fa-robot me-2"></i>
                    <span class="fw-bold">AI Assistant</span>
                </div>
                <button type="button" class="btn btn-sm btn-outline-light" id="closeChatBtn">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="chat-messages" id="chatMessages">
                <div class="message ai">
                    <strong>AI Assistant:</strong> Hello! I'm here to help you refine the generated questions. 
                    You can ask me to modify questions, suggest better options, or explain concepts in different ways.
                </div>
            </div>
            <div class="chat-input">
                <div class="input-group">
                    <input type="text" class="form-control" id="chatInput" 
                           placeholder="Ask AI to improve questions...">
                    <button type="button" class="btn btn-primary" id="sendChatBtn">
                        <i class="fas fa-paper-plane"></i>
                    </button>
                </div>
            </div>
        </div>

        <jsp:include page="/footer.jsp" />

        <script src="/assets/js/vendor/jquery-1.12.4.min.js"></script>
        <script src="/assets/js/bootstrap.min.js"></script>
        <script>
            $(document).ready(function () {
                // Initialize counters
                updateStatistics();

                // Edit functionality
                $('.edit-btn').click(function () {
                    const index = $(this).data('index');
                    const questionCard = $('#question-' + index);

                    if (questionCard.hasClass('edit-mode')) {
                        // Exit edit mode
                        questionCard.removeClass('edit-mode');
                        $(this).html('<i class="fas fa-edit me-1"></i> Edit');
                        updateEditedCount();
                    } else {
                        // Enter edit mode
                        questionCard.addClass('edit-mode');
                        $(this).html('<i class="fas fa-save me-1"></i> Done');
                        updateEditedCount();

                        // Scroll to edit controls
                        questionCard.find('.edit-controls').first()[0].scrollIntoView({
                            behavior: 'smooth',
                            block: 'center'
                        });
                    }
                });

                // Select/Deselect all functionality
                $('#selectAllBtn').click(function () {
                    $('input[name="approved"]').prop('checked', true);
                    updateStatistics();
                    $(this).addClass('btn-success').removeClass('btn-outline-custom');
                    setTimeout(() => {
                        $(this).removeClass('btn-success').addClass('btn-outline-custom');
                    }, 1000);
                });

                $('#deselectAllBtn').click(function () {
                    $('input[name="approved"]').prop('checked', false);
                    updateStatistics();
                    $(this).addClass('btn-danger').removeClass('btn-outline-custom');
                    setTimeout(() => {
                        $(this).removeClass('btn-danger').addClass('btn-outline-custom');
                    }, 1000);
                });

                // Update statistics when checkboxes change
                $('input[name="approved"]').change(function () {
                    updateStatistics();

                    // Add visual feedback
                    const card = $(this).closest('.question-card');
                    if ($(this).is(':checked')) {
                        card.addClass('border-success');
                        setTimeout(() => card.removeClass('border-success'), 1000);
                    } else {
                        card.addClass('border-warning');
                        setTimeout(() => card.removeClass('border-warning'), 1000);
                    }
                });

                // Chat functionality
                $('#openChatBtn, #floatingChatBtn').click(function () {
                    $('#chatSection').fadeIn(300);
                    $('#chatInput').focus();
                });

                $('#closeChatBtn').click(function () {
                    $('#chatSection').fadeOut(300);
                });

                // Quick actions
                $('.quick-action').click(function () {
                    const action = $(this).data('action');
                    sendQuickMessage(action);
                });

                // Send chat message
                function sendMessage() {
                    const message = $('#chatInput').val().trim();
                    if (!message)
                        return;

                    // Add user message
                    $('#chatMessages').append(`
                        <div class="message user">
                            <strong>You:</strong> ${message}
                        </div>
                    `);

                    $('#chatInput').val('');

                    // Show loading
                    const loadingId = 'loading-' + Date.now();
                    $('#chatMessages').append(`
                        <div class="message ai" id="${loadingId}">
                            <strong>AI:</strong> <i class="fas fa-spinner fa-spin"></i> Thinking...
                        </div>
                    `);

                    // Scroll to bottom
                    scrollChatToBottom();

                    // Send to AI
                    $.post('/ai-question', {
                        action: 'chat',
                        message: message
                    })
                            .done(function (response) {
                                $(`#${loadingId}`).remove();
                                $('#chatMessages').append(`
                            <div class="message ai">
                                <strong>AI:</strong> ${response.response || response}
                            </div>
                        `);
                                scrollChatToBottom();
                            })
                            .fail(function () {
                                $(`#${loadingId}`).remove();
                                $('#chatMessages').append(`
                            <div class="message ai">
                                <strong>AI:</strong> Sorry, I'm having trouble responding right now. Please try again.
                            </div>
                        `);
                                scrollChatToBottom();
                            });
                }

                function sendQuickMessage(action) {
                    $('#chatInput').val(action);
                    sendMessage();
                    $('#chatSection').fadeIn(300);
                }

                $('#sendChatBtn').click(sendMessage);

                $('#chatInput').keypress(function (e) {
                    if (e.which === 13) {
                        sendMessage();
                    }
                });

                // Form submission validation
                $('#approveForm').submit(function (e) {
                    const checkedBoxes = $('input[name="approved"]:checked');
                    if (checkedBoxes.length === 0) {
                        e.preventDefault();
                        showAlert('Please select at least one question to approve and save.', 'warning');
                        return false;
                    }

                    if (!confirm(`Are you sure you want to save ${checkedBoxes.length} question(s) to the question bank?`)) {
                        e.preventDefault();
                        return false;
                    }

                    // Show loading state
                    const submitBtn = $(this).find('button[type="submit"]');
                    const originalText = submitBtn.html();
                    submitBtn.prop('disabled', true)
                            .html('<i class="fas fa-spinner fa-spin me-2"></i>Saving Questions...');

                    // Add loading overlay
                    $('body').append(`
                        <div id="saveOverlay" style="
                            position: fixed;
                            top: 0;
                            left: 0;
                            width: 100%;
                            height: 100%;
                            background: rgba(0, 0, 0, 0.7);
                            display: flex;
                            justify-content: center;
                            align-items: center;
                            z-index: 9999;
                        ">
                            <div style="
                                background: white;
                                padding: 40px;
                                border-radius: 20px;
                                text-align: center;
                                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
                                max-width: 400px;
                            ">
                                <i class="fas fa-save fa-3x text-success mb-3"></i>
                                <h4>Saving Questions...</h4>
                                <p class="text-muted">Adding approved questions to your question bank</p>
                                <div class="progress">
                                    <div class="progress-bar progress-bar-striped progress-bar-animated bg-success" 
                                         style="width: 100%"></div>
                                </div>
                            </div>
                        </div>
                    `);
                });

                // Helper functions
                function updateStatistics() {
                    const total = $('input[name="approved"]').length;
                    const approved = $('input[name="approved"]:checked').length;
                    const edited = $('.question-card.edit-mode').length;

                    $('#selectedCount').text(approved);
                    $('#approvedQuestions').text(approved);
                    $('#editedQuestions').text(edited);

                    const percentage = total > 0 ? (approved / total) * 100 : 0;
                    $('#selectionProgress').css('width', percentage + '%');
                }

                function updateEditedCount() {
                    const edited = $('.question-card.edit-mode').length;
                    $('#editedQuestions').text(edited);
                }

                function scrollChatToBottom() {
                    const chatMessages = $('#chatMessages');
                    chatMessages.scrollTop(chatMessages[0].scrollHeight);
                }

                function showAlert(message, type) {
                    const alertHtml = `
                        <div class="alert alert-${type} alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-triangle me-2"></i>
            ${message}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    `;
                    $('.preview-container').prepend(alertHtml);

                    // Auto dismiss after 5 seconds
                    setTimeout(() => {
                        $('.alert').fadeOut();
                    }, 5000);
                }

                // Smooth scroll animations
                const observer = new IntersectionObserver((entries) => {
                    entries.forEach(entry => {
                        if (entry.isIntersecting) {
                            entry.target.style.opacity = '1';
                            entry.target.style.transform = 'translateY(0)';
                        }
                    });
                });

                $('.question-card').each(function (index) {
                    this.style.opacity = '0';
                    this.style.transform = 'translateY(30px)';
                    this.style.transition = `opacity 0.6s ease ${index * 0.1}s, transform 0.6s ease ${index * 0.1}s`;
                    observer.observe(this);
                });

                // Close chat when clicking outside
                $(document).click(function (e) {
                    if (!$(e.target).closest('#chatSection, #openChatBtn, #floatingChatBtn, .quick-action').length) {
                        if ($('#chatSection').is(':visible')) {
                            $('#chatSection').fadeOut(300);
                        }
                    }
                });

                // Keyboard shortcuts
                $(document).keydown(function (e) {
                    // Ctrl/Cmd + A to select all
                    if ((e.ctrlKey || e.metaKey) && e.which === 65 && !$(e.target).is('input, textarea')) {
                        e.preventDefault();
                        $('#selectAllBtn').click();
                    }

                    // Ctrl/Cmd + D to deselect all
                    if ((e.ctrlKey || e.metaKey) && e.which === 68 && !$(e.target).is('input, textarea')) {
                        e.preventDefault();
                        $('#deselectAllBtn').click();
                    }

                    // Escape to close chat
                    if (e.which === 27) {
                        $('#chatSection').fadeOut(300);
                    }
                });
            });
        </script>
    </body>
</html>