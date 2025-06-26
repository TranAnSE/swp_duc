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
    <link rel="stylesheet" href="/assets/css/style.css">
    <style>
        body {
            padding-top: 120px;
            background-color: #f8f9fa;
        }
        .preview-container {
            max-width: 1200px;
            margin: 0 auto;
        }
        .question-card {
            background: white;
            border-radius: 10px;
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border-left: 4px solid #007bff;
        }
        .question-header {
            display: flex;
            justify-content: between;
            align-items: center;
            margin-bottom: 20px;
        }
        .question-number {
            background: #007bff;
            color: white;
            border-radius: 50%;
            width: 35px;
            height: 35px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
        }
        .question-text {
            flex: 1;
            margin-left: 15px;
            font-size: 1.1rem;
            font-weight: 500;
        }
        .question-controls {
            display: flex;
            gap: 10px;
        }
        .option-list {
            margin: 15px 0;
        }
        .option-item {
            padding: 10px 15px;
            margin: 5px 0;
            border: 1px solid #dee2e6;
            border-radius: 5px;
            background-color: #f8f9fa;
        }
        .option-item.correct {
            background-color: #d4edda;
            border-color: #c3e6cb;
            color: #155724;
        }
        .explanation-box {
            background-color: #e7f3ff;
            border: 1px solid #b8daff;
            border-radius: 5px;
            padding: 15px;
            margin-top: 15px;
        }
        .chat-section {
            position: fixed;
            right: 20px;
            top: 150px;
            width: 350px;
            height: 400px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.2);
            display: none;
            z-index: 1000;
        }
        .chat-header {
            background: #007bff;
            color: white;
            padding: 15px;
            border-radius: 10px 10px 0 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .chat-messages {
            height: 250px;
            overflow-y: auto;
            padding: 15px;
            border-bottom: 1px solid #dee2e6;
        }
        .chat-input {
            padding: 15px;
        }
        .message {
            margin-bottom: 10px;
            padding: 8px 12px;
            border-radius: 15px;
            max-width: 80%;
        }
        .message.user {
            background-color: #007bff;
            color: white;
            margin-left: auto;
        }
        .message.ai {
            background-color: #f1f3f4;
            color: #333;
        }
        .floating-chat-btn {
            position: fixed;
            right: 30px;
            bottom: 30px;
            width: 60px;
            height: 60px;
            background: #007bff;
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            cursor: pointer;
            box-shadow: 0 4px 12px rgba(0,123,255,0.3);
            z-index: 999;
        }
        .approve-section {
            background: white;
            padding: 20px;
            border-radius: 10px;
            margin-top: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .edit-mode {
            border: 2px dashed #ffc107;
            background-color: #fff3cd;
        }
        .edit-controls {
            margin-top: 15px;
            display: none;
        }
        .edit-mode .edit-controls {
            display: block;
        }
    </style>
</head>
<body>
    <jsp:include page="/header.jsp" />
    
    <div class="container preview-container">
        <div class="row">
            <div class="col-lg-8">
                <h2 class="mb-4">
                    <i class="fas fa-robot text-primary"></i>
                    AI Generated Questions Preview
                </h2>
                
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>
                
                <form action="/ai-question" method="post" id="approveForm">
                    <input type="hidden" name="action" value="approve">
                    
                    <c:forEach var="question" items="${generatedQuestions}" varStatus="status">
                        <div class="question-card" id="question-${status.index}">
                            <div class="question-header">
                                <div class="question-number">${status.index + 1}</div>
                                <div class="question-text" id="questionText-${status.index}">
                                    ${question.question}
                                </div>
                                <div class="question-controls">
                                    <button type="button" class="btn btn-sm btn-outline-primary edit-btn" 
                                            data-index="${status.index}">
                                        <i class="fas fa-edit"></i> Edit
                                    </button>
                                    <div class="form-check">
                                        <input type="checkbox" name="approved" value="${status.index}" 
                                               class="form-check-input" id="approve-${status.index}" checked>
                                        <label class="form-check-label" for="approve-${status.index}">
                                            Approve
                                        </label>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Editable Question Text -->
                            <div class="edit-controls">
                                <label>Edit Question:</label>
                                <textarea name="question_text" class="form-control mb-3" rows="3">${question.question}</textarea>
                            </div>
                            
                            <!-- Options -->
                            <div class="option-list">
                                <c:forEach var="option" items="${question.options}" varStatus="optStatus">
                                    <div class="option-item ${optStatus.index == question.correctAnswerIndex ? 'correct' : ''}">
                                        <strong>${optStatus.index == 0 ? 'A' : (optStatus.index == 1 ? 'B' : (optStatus.index == 2 ? 'C' : 'D'))}.</strong>
                                        ${option}
                                        <c:if test="${optStatus.index == question.correctAnswerIndex}">
                                            <i class="fas fa-check-circle text-success float-right"></i>
                                        </c:if>
                                    </div>
                                </c:forEach>
                            </div>
                            
                            <!-- Explanation -->
                            <div class="explanation-box">
                                <strong><i class="fas fa-lightbulb"></i> Explanation:</strong>
                                <div id="explanationText-${status.index}">${question.explanation}</div>
                                
                                <!-- Editable Explanation -->
                                <div class="edit-controls mt-2">
                                    <label>Edit Explanation:</label>
                                    <textarea name="explanation" class="form-control" rows="2">${question.explanation}</textarea>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                    
                    <!-- Approve Section -->
                    <div class="approve-section">
                        <h4><i class="fas fa-check-circle text-success"></i> Approve Questions</h4>
                        <p class="text-muted">
                            Review the generated questions above. You can edit them directly or use the AI chat to refine them.
                            Only checked questions will be added to your question bank.
                        </p>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <button type="button" class="btn btn-outline-primary" id="selectAllBtn">
                                    <i class="fas fa-check-double"></i> Select All
                                </button>
                                <button type="button" class="btn btn-outline-secondary" id="deselectAllBtn">
                                    <i class="fas fa-times"></i> Deselect All
                                </button>
                            </div>
                            <div class="col-md-6 text-right">
                                <button type="submit" class="btn btn-success btn-lg">
                                    <i class="fas fa-save"></i> Save Approved Questions
                                </button>
                                <a href="/ai-question?action=form" class="btn btn-outline-secondary btn-lg ml-2">
                                    <i class="fas fa-arrow-left"></i> Back
                                </a>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            
            <!-- AI Assistant Sidebar -->
            <div class="col-lg-4">
                <div class="card sticky-top" style="top: 140px;">
                    <div class="card-header bg-primary text-white">
                        <h5><i class="fas fa-robot"></i> AI Assistant</h5>
                    </div>
                    <div class="card-body">
                        <p class="text-muted">
                            Need help refining the questions? Chat with AI to get suggestions for improvements.
                        </p>
                        <button type="button" class="btn btn-primary btn-block" id="openChatBtn">
                            <i class="fas fa-comments"></i> Chat with AI
                        </button>
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
            <span><i class="fas fa-robot"></i> AI Assistant</span>
            <button type="button" class="btn btn-sm btn-outline-light" id="closeChatBtn">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <div class="chat-messages" id="chatMessages">
            <div class="message ai">
                <strong>AI:</strong> Hello! I'm here to help you refine the generated questions. 
                You can ask me to modify questions, suggest better options, or explain concepts.
            </div>
        </div>
        <div class="chat-input">
            <div class="input-group">
                <input type="text" class="form-control" id="chatInput" 
                       placeholder="Ask AI to improve questions...">
                <div class="input-group-append">
                    <button type="button" class="btn btn-primary" id="sendChatBtn">
                        <i class="fas fa-paper-plane"></i>
                    </button>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="/footer.jsp" />
    
    <script src="/assets/js/vendor/jquery-1.12.4.min.js"></script>
    <script src="/assets/js/bootstrap.min.js"></script>
    <script>
        $(document).ready(function() {
            // Edit functionality
            $('.edit-btn').click(function() {
                const index = $(this).data('index');
                const questionCard = $('#question-' + index);
                
                if (questionCard.hasClass('edit-mode')) {
                    // Exit edit mode
                    questionCard.removeClass('edit-mode');
                    $(this).html('<i class="fas fa-edit"></i> Edit');
                } else {
                    // Enter edit mode
                    questionCard.addClass('edit-mode');
                    $(this).html('<i class="fas fa-save"></i> Done');
                }
            });
            
            // Select/Deselect all
            $('#selectAllBtn').click(function() {
                $('input[name="approved"]').prop('checked', true);
            });
            
            $('#deselectAllBtn').click(function() {
                $('input[name="approved"]').prop('checked', false);
            });
            
            // Chat functionality
            $('#openChatBtn, #floatingChatBtn').click(function() {
                $('#chatSection').show();
            });
            
            $('#closeChatBtn').click(function() {
                $('#chatSection').hide();
            });
            
            // Send chat message
            function sendMessage() {
                const message = $('#chatInput').val().trim();
                if (!message) return;
                
                // Add user message
                $('#chatMessages').append(`
                    <div class="message user">
                        <strong>You:</strong> ${message}
                    </div>
                `);
                
                $('#chatInput').val('');
                
                // Show loading
                $('#chatMessages').append(`
                    <div class="message ai" id="loadingMessage">
                        <strong>AI:</strong> <i class="fas fa-spinner fa-spin"></i> Thinking...
                    </div>
                `);
                
                // Scroll to bottom
                $('#chatMessages').scrollTop($('#chatMessages')[0].scrollHeight);
                
                // Send to AI
                $.post('/ai-question', {
                    action: 'chat',
                    message: message
                })
                .done(function(response) {
                    $('#loadingMessage').remove();
                    $('#chatMessages').append(`
                        <div class="message ai">
                            <strong>AI:</strong> ${response.response}
                        </div>
                    `);
                    $('#chatMessages').scrollTop($('#chatMessages')[0].scrollHeight);
                })
                .fail(function() {
                    $('#loadingMessage').remove();
                    $('#chatMessages').append(`
                        <div class="message ai">
                            <strong>AI:</strong> Sorry, I'm having trouble responding right now. Please try again.
                        </div>
                    `);
                    $('#chatMessages').scrollTop($('#chatMessages')[0].scrollHeight);
                });
            }
            
            $('#sendChatBtn').click(sendMessage);
            
            $('#chatInput').keypress(function(e) {
                if (e.which === 13) {
                    sendMessage();
                }
            });
            
            // Form submission validation
            $('#approveForm').submit(function(e) {
                const checkedBoxes = $('input[name="approved"]:checked');
                if (checkedBoxes.length === 0) {
                    alert('Please select at least one question to approve and save.');
                    e.preventDefault();
                    return false;
                }
                
                if (!confirm(`Are you sure you want to save ${checkedBoxes.length} question(s) to the question bank?`)) {
                    e.preventDefault();
                    return false;
                }
                
                // Show loading state
                $(this).find('button[type="submit"]').prop('disabled', true)
                    .html('<i class="fas fa-spinner fa-spin"></i> Saving Questions...');
            });
        });
    </script>
</body>
</html>

