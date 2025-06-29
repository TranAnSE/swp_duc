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

        <!-- Select2 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
        <link href="https://cdn.jsdelivr.net/npm/select2-bootstrap-5-theme@1.3.0/dist/select2-bootstrap-5-theme.min.css" rel="stylesheet" />

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
                max-width: 1000px;
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

            .form-section {
                margin-bottom: 35px;
                padding: 25px;
                border: 1px solid var(--border-color);
                border-radius: 16px;
                background: linear-gradient(135deg, #fafbff 0%, #f8fafc 100%);
                transition: all 0.3s ease;
                position: relative;
                overflow: visible;
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

            /* Generation Mode Selection */
            .generation-mode-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 20px;
                margin-top: 15px;
            }

            .mode-card {
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

            .mode-card::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(79, 70, 229, 0.1), transparent);
                transition: left 0.5s ease;
            }

            .mode-card:hover::before {
                left: 100%;
            }

            .mode-card:hover {
                transform: translateY(-5px);
                box-shadow: var(--shadow-lg);
                border-color: var(--primary-color);
            }

            .mode-card.selected {
                border-color: var(--primary-color);
                background: linear-gradient(135deg, rgba(79, 70, 229, 0.1) 0%, rgba(6, 182, 212, 0.1) 100%);
                box-shadow: var(--shadow-md);
            }

            .mode-card input[type="radio"] {
                display: none;
            }

            .mode-icon {
                font-size: 2.5rem;
                color: var(--primary-color);
                margin-bottom: 15px;
                display: block;
            }

            .mode-title {
                font-weight: 600;
                color: var(--text-primary);
                margin-bottom: 8px;
                font-size: 1.1rem;
            }

            .mode-description {
                color: var(--text-secondary);
                font-size: 0.9rem;
                line-height: 1.4;
            }

            /* Hierarchy Selection */
            .hierarchy-selection {
                display: none;
                margin-top: 20px;
                padding: 20px;
                background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
                border-radius: 12px;
                border: 1px solid #0ea5e9;
            }

            .hierarchy-selection.active {
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

            .hierarchy-steps {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 15px;
                margin-bottom: 20px;
            }

            .hierarchy-step {
                background: white;
                padding: 15px;
                border-radius: 8px;
                border: 1px solid #e2e8f0;
            }

            .hierarchy-step label {
                font-weight: 600;
                color: #374151;
                margin-bottom: 8px;
                display: block;
            }

            /* Content Preview */
            .content-preview {
                background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
                border: 1px solid #bae6fd;
                border-radius: 12px;
                padding: 20px;
                margin-top: 15px;
                max-height: 300px;
                overflow-y: auto;
                display: none;
            }

            .content-preview.active {
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

            .content-stats {
                background: rgba(255, 255, 255, 0.8);
                padding: 10px 15px;
                border-radius: 8px;
                margin-bottom: 15px;
                display: flex;
                gap: 20px;
                font-size: 0.9rem;
            }

            .stat-item {
                display: flex;
                align-items: center;
                gap: 5px;
                color: var(--text-secondary);
            }

            .stat-item i {
                color: var(--primary-color);
            }

            /* Enhanced form controls */
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

            /* Enhanced Select2 Custom Styling */
            .select2-container--bootstrap-5 .select2-selection {
                border: 2px solid var(--border-color) !important;
                border-radius: 12px !important;
                min-height: 50px !important;
                padding: 8px 12px !important;
                font-size: 16px !important;
                transition: all 0.3s ease !important;
                background: white !important;
            }

            .select2-container--bootstrap-5 .select2-selection--single {
                height: 50px !important;
                display: flex !important;
                align-items: center !important;
            }

            .select2-container--bootstrap-5 .select2-selection--single .select2-selection__rendered {
                line-height: 34px !important;
                padding-left: 0 !important;
                padding-right: 30px !important;
                font-size: 16px !important;
                color: var(--text-primary) !important;
                text-align: center !important;
                width: 100% !important;
                display: block !important;
            }

            /* Center placeholder text specifically */
            .select2-container--bootstrap-5 .select2-selection--single .select2-selection__placeholder {
                color: var(--text-secondary) !important;
                font-size: 16px !important;
                text-align: center !important;
                width: 100% !important;
                display: block !important;
                font-style: italic !important;
            }

            .select2-container--bootstrap-5 .select2-selection__arrow {
                height: 48px !important;
                position: absolute !important;
                top: 1px !important;
                right: 10px !important;
                width: 20px !important;
            }

            .select2-container--bootstrap-5.select2-container--focus .select2-selection,
            .select2-container--bootstrap-5.select2-container--open .select2-selection {
                border-color: var(--primary-color) !important;
                box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1) !important;
                outline: none !important;
            }

            /* Dropdown styling */
            .select2-dropdown {
                background: white !important;
                border: 2px solid var(--primary-color) !important;
                border-radius: 12px !important;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2) !important;
                margin-top: 5px !important;
                z-index: 9999 !important;
                font-size: 16px !important;
            }

            .select2-container--bootstrap-5 .select2-dropdown .select2-results__options {
                max-height: 300px !important;
            }

            .select2-container--bootstrap-5 .select2-results__option {
                padding: 12px 16px !important;
                font-size: 16px !important;
                color: var(--text-primary) !important;
                text-align: center !important;
                cursor: pointer !important;
                transition: background-color 0.2s ease !important;
            }

            .select2-container--bootstrap-5 .select2-results__option:hover,
            .select2-container--bootstrap-5 .select2-results__option--highlighted {
                background-color: var(--primary-color) !important;
                color: white !important;
            }

            .select2-container--bootstrap-5 .select2-results__option[aria-selected="true"] {
                background-color: rgba(79, 70, 229, 0.1) !important;
                color: var(--primary-color) !important;
                font-weight: 600 !important;
            }

            /* Ensure proper width and z-index */
            .select2-container {
                width: 100% !important;
                z-index: 1000 !important;
            }

            .select2-container--open {
                z-index: 9999 !important;
            }

            /* Fix for disabled state */
            .select2-container--bootstrap-5.select2-container--disabled .select2-selection {
                background-color: #f3f4f6 !important;
                color: #9ca3af !important;
                cursor: not-allowed !important;
            }

            .select2-container--bootstrap-5.select2-container--disabled .select2-selection--single .select2-selection__rendered {
                color: #9ca3af !important;
            }

            /* Question type and difficulty grids */
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

                .generation-mode-grid,
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

                .hierarchy-steps {
                    grid-template-columns: 1fr;
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

                    <!-- Generation Mode Selection -->
                    <div class="form-section">
                        <div class="section-title">
                            <i class="fas fa-cogs"></i>
                            Content Scope Selection
                        </div>
                        <!-- Intelligent Assignment Info -->
                        <div class="form-section">
                            <div class="section-title">
                                <i class="fas fa-brain"></i>
                                Intelligent Question Assignment
                            </div>

                            <div class="alert alert-info">
                                <h6><i class="fas fa-lightbulb me-2"></i>Smart Lesson Assignment</h6>
                                <p class="mb-2">When generating questions for <strong>Entire Chapter</strong> or <strong>Full Subject</strong>, our AI system will:</p>
                                <ul class="mb-0">
                                    <li><strong>Analyze question content</strong> - Examine the question text and context</li>
                                    <li><strong>Match with lessons</strong> - Compare with available lesson content and topics</li>
                                    <li><strong>Assign intelligently</strong> - Place each question in the most relevant lesson</li>
                                    <li><strong>Ensure organization</strong> - Maintain proper categorization in your question bank</li>
                                </ul>
                            </div>

                            <div class="row">
                                <div class="col-md-4">
                                    <div class="text-center p-3 bg-light rounded">
                                        <i class="fas fa-book fa-2x text-primary mb-2"></i>
                                        <h6>Single Lesson</h6>
                                        <small class="text-muted">Direct assignment to selected lesson</small>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="text-center p-3 bg-light rounded">
                                        <i class="fas fa-folder fa-2x text-warning mb-2"></i>
                                        <h6>Entire Chapter</h6>
                                        <small class="text-muted">Smart distribution across chapter lessons</small>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="text-center p-3 bg-light rounded">
                                        <i class="fas fa-graduation-cap fa-2x text-success mb-2"></i>
                                        <h6>Full Subject</h6>
                                        <small class="text-muted">Intelligent assignment to all subject lessons</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="generation-mode-grid">
                            <div class="mode-card" data-mode="lesson">
                                <input type="radio" name="generation_mode" value="lesson" id="modeLesson">
                                <label for="modeLesson">
                                    <i class="fas fa-book mode-icon"></i>
                                    <div class="mode-title">Single Lesson</div>
                                    <div class="mode-description">
                                        Generate questions based on one specific lesson's content
                                    </div>
                                </label>
                            </div>

                            <div class="mode-card" data-mode="chapter">
                                <input type="radio" name="generation_mode" value="chapter" id="modeChapter">
                                <label for="modeChapter">
                                    <i class="fas fa-folder mode-icon"></i>
                                    <div class="mode-title">Entire Chapter</div>
                                    <div class="mode-description">
                                        Generate questions covering all lessons in a chapter
                                    </div>
                                </label>
                            </div>

                            <div class="mode-card" data-mode="subject">
                                <input type="radio" name="generation_mode" value="subject" id="modeSubject">
                                <label for="modeSubject">
                                    <i class="fas fa-graduation-cap mode-icon"></i>
                                    <div class="mode-title">Full Subject</div>
                                    <div class="mode-description">
                                        Generate questions covering entire subject curriculum
                                    </div>
                                </label>
                            </div>
                        </div>
                        <div class="form-text">
                            <i class="fas fa-info-circle me-1"></i>
                            Choose the scope of content you want to generate questions from
                        </div>
                    </div>

                    <!-- Hierarchy Selection -->
                    <div class="form-section">
                        <div class="section-title">
                            <i class="fas fa-sitemap"></i>
                            Learning Path Selection
                        </div>

                        <!-- Hierarchy for Lesson Mode -->
                        <div class="hierarchy-selection" id="lessonHierarchy">
                            <div class="hierarchy-steps">
                                <div class="hierarchy-step">
                                    <label for="gradeSelectLesson">Grade</label>
                                    <select id="gradeSelectLesson" class="form-select select2-dropdown">
                                        <option value="">-- Select Grade --</option>
                                        <c:forEach var="grade" items="${grades}">
                                            <option value="${grade.id}">${grade.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="hierarchy-step">
                                    <label for="subjectSelectLesson">Subject</label>
                                    <select id="subjectSelectLesson" class="form-select select2-dropdown" disabled>
                                        <option value="">-- Select Subject --</option>
                                    </select>
                                </div>
                                <div class="hierarchy-step">
                                    <label for="chapterSelectLesson">Chapter</label>
                                    <select id="chapterSelectLesson" class="form-select select2-dropdown" disabled>
                                        <option value="">-- Select Chapter --</option>
                                    </select>
                                </div>
                                <div class="hierarchy-step">
                                    <label for="lessonSelect">Lesson</label>
                                    <select name="lesson_id" id="lessonSelect" class="form-select select2-dropdown" disabled>
                                        <option value="">-- Select Lesson --</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <!-- Hierarchy for Chapter Mode -->
                        <div class="hierarchy-selection" id="chapterHierarchy">
                            <div class="hierarchy-steps">
                                <div class="hierarchy-step">
                                    <label for="gradeSelectChapter">Grade</label>
                                    <select id="gradeSelectChapter" class="form-select select2-dropdown">
                                        <option value="">-- Select Grade --</option>
                                        <c:forEach var="grade" items="${grades}">
                                            <option value="${grade.id}">${grade.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="hierarchy-step">
                                    <label for="subjectSelectChapter">Subject</label>
                                    <select id="subjectSelectChapter" class="form-select select2-dropdown" disabled>
                                        <option value="">-- Select Subject --</option>
                                    </select>
                                </div>
                                <div class="hierarchy-step">
                                    <label for="chapterSelect">Chapter</label>
                                    <select name="chapter_id" id="chapterSelect" class="form-select select2-dropdown" disabled>
                                        <option value="">-- Select Chapter --</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <!-- Hierarchy for Subject Mode -->
                        <div class="hierarchy-selection" id="subjectHierarchy">
                            <div class="hierarchy-steps">
                                <div class="hierarchy-step">
                                    <label for="gradeSelectSubject">Grade</label>
                                    <select id="gradeSelectSubject" class="form-select select2-dropdown">
                                        <option value="">-- Select Grade --</option>
                                        <c:forEach var="grade" items="${grades}">
                                            <option value="${grade.id}">${grade.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="hierarchy-step">
                                    <label for="subjectSelectMain">Subject</label>
                                    <select name="subject_id" id="subjectSelectMain" class="form-select select2-dropdown" disabled>
                                        <option value="">-- Select Subject --</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="form-text">
                            <i class="fas fa-lightbulb me-1"></i>
                            Select the learning path based on your chosen content scope above
                        </div>
                    </div>

                    <!-- Content Preview -->
                    <div class="form-section" id="contentPreviewSection" style="display: none;">
                        <div class="section-title">
                            <i class="fas fa-eye"></i>
                            Content Preview
                        </div>
                        <div class="content-preview" id="contentPreview">
                            <div class="content-stats" id="contentStats"></div>
                            <div id="contentText"></div>
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

                            <div class="question-type-card" data-type="mixed">
                                <input type="radio" name="question_type" value="mixed" id="typeMixed">
                                <label for="typeMixed">
                                    <i class="fas fa-random question-type-icon"></i>
                                    <div class="question-type-title">Mixed Types</div>
                                    <div class="question-type-description">
                                        Combination of different question types
                                    </div>
                                </label>
                            </div>
                        </div>
                    </div>


                    <!-- Question Settings -->
                    <div class="form-section">
                        <div class="section-title">
                            <i class="fas fa-cogs"></i>
                            Question Settings
                        </div>

                        <div class="row">
                            <div class="col-md-4">
                                <label for="numberOfQuestions" class="form-label">Number of Questions</label>
                                <input type="number" name="number_of_questions" id="numberOfQuestions" 
                                       class="form-control" min="1" max="50" value="5" required>
                                <div class="form-text">Generate between 1-50 questions</div>
                            </div>
                            <div class="col-md-4">
                                <label for="questionCategory" class="form-label">Question Focus</label>
                                <select name="question_category" id="questionCategory" class="form-select select2-dropdown" required>
                                    <option value="conceptual">Conceptual Understanding</option>
                                    <option value="application">Practical Application</option>
                                    <option value="analysis">Critical Analysis</option>
                                    <option value="synthesis">Knowledge Synthesis</option>
                                    <option value="evaluation">Evaluation & Assessment</option>
                                    <option value="mixed">Mixed (Recommended)</option>
                                </select>
                                <div class="form-text">Choose the cognitive level for questions</div>
                            </div>
                            <div class="col-md-4">
                                <label for="questionComplexity" class="form-label">Question Complexity</label>
                                <select name="question_complexity" id="questionComplexity" class="form-select select2-dropdown">
                                    <option value="simple">Simple & Direct</option>
                                    <option value="moderate">Moderate Complexity</option>
                                    <option value="complex">Complex & Detailed</option>
                                    <option value="adaptive">Adaptive (AI Choice)</option>
                                </select>
                                <div class="form-text">Control question complexity level</div>
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
                                    <i class="fas fa-leaf d-block mb-2"></i>
                                    Easy
                                </label>
                            </div>
                            <div class="difficulty-option" data-difficulty="medium">
                                <input type="radio" name="difficulty" value="medium" id="diffMedium">
                                <label for="diffMedium" class="difficulty-label">
                                    <i class="fas fa-wrench d-block mb-2"></i>
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
                                    <i class="fas fa-random d-block mb-2"></i>
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
                                  placeholder="Provide specific instructions for the AI about the type of questions you want...&#10;&#10;Examples:&#10;• Focus on practical applications&#10;• Include real-world examples&#10;• Avoid complex calculations&#10;• Emphasize key concepts from the content&#10;• Create questions that test understanding rather than memorization"></textarea>
                        <div class="form-text">
                            <i class="fas fa-lightbulb me-1"></i>
                            Give the AI specific guidance to generate better questions tailored to your needs
                        </div>
                    </div>

                    <!-- Generate Button -->
                    <div class="text-center">
                        <button type="submit" class="generate-btn" id="generateBtn" disabled>
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
        <!-- Select2 JS -->
        <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
        <script src="/assets/js/bootstrap.min.js"></script>

        <script>
            $(document).ready(function () {
                let currentMode = '';
                let selectedContent = null;
                let select2Initialized = new Set(); // Track initialized Select2 instances

                // Enhanced Select2 initialization function
                function initializeSelect2(selector) {
                    const $element = $(selector);

                    // Skip if already initialized
                    if (select2Initialized.has(selector)) {
                        return;
                    }

                    // Check if element exists and is not already a Select2
                    if ($element.length && !$element.hasClass('select2-hidden-accessible')) {
                        try {
                            $element.select2({
                                theme: 'bootstrap-5',
                                width: '100%',
                                placeholder: function () {
                                    return $(this).find('option:first').text();
                                },
                                allowClear: false,
                                dropdownParent: $('body'),
                                escapeMarkup: function (markup) {
                                    return markup;
                                }
                            });

                            // Mark as initialized
                            select2Initialized.add(selector);

                            console.log('Select2 initialized for:', selector);
                        } catch (error) {
                            console.error('Failed to initialize Select2 for', selector, error);
                        }
                    }
                }

                // Initialize all Select2 dropdowns on page load
                function initializeAllSelect2() {
                    $('.select2-dropdown').each(function () {
                        const selector = '#' + $(this).attr('id');
                        initializeSelect2(selector);
                    });
                }

                // Safely destroy Select2 instance
                function destroySelect2(selector) {
                    const $element = $(selector);
                    if ($element.hasClass('select2-hidden-accessible')) {
                        try {
                            $element.select2('destroy');
                            select2Initialized.delete(selector);
                            console.log('Select2 destroyed for:', selector);
                        } catch (error) {
                            console.error('Failed to destroy Select2 for', selector, error);
                        }
                    }
                }

                // Helper function to reset and populate select with proper Select2 handling
                function resetSelect(selector, placeholder) {
                    const $select = $(selector);

                    // Destroy existing Select2 instance
                    destroySelect2(selector);

                    // Reset select content
                    $select.empty().append('<option value="">' + placeholder + '</option>');
                    $select.prop('disabled', true);

                    // Reinitialize Select2
                    initializeSelect2(selector);
                }

                function populateSelect(selector, data, placeholder) {
                    const $select = $(selector);

                    // Destroy existing Select2 instance
                    destroySelect2(selector);

                    // Populate select
                    $select.empty().append('<option value="">' + placeholder + '</option>');
                    $.each(data, function (i, item) {
                        $select.append('<option value="' + item.id + '">' + item.name + '</option>');
                    });
                    $select.prop('disabled', false);

                    // Reinitialize Select2
                    initializeSelect2(selector);
                }

                // Initialize Select2 on page load
                initializeAllSelect2();

                // Handle generation mode selection
                $('.mode-card').click(function () {
                    $('.mode-card').removeClass('selected');
                    $(this).addClass('selected');
                    $(this).find('input[type="radio"]').prop('checked', true);

                    currentMode = $(this).data('mode');

                    // Hide all hierarchy selections
                    $('.hierarchy-selection').removeClass('active');

                    // Show appropriate hierarchy selection
                    $('#' + currentMode + 'Hierarchy').addClass('active');

                    // Reset content preview
                    $('#contentPreviewSection').hide();
                    $('#generateBtn').prop('disabled', true);

                    // Reset all selects in the active hierarchy
                    resetAllSelectsInHierarchy();
                });

                function resetAllSelectsInHierarchy() {
                    const activeHierarchy = $('.hierarchy-selection.active');
                    activeHierarchy.find('select').each(function () {
                        const $select = $(this);
                        const selector = '#' + $select.attr('id');
                        const placeholder = $select.find('option:first').text();

                        // Keep grade selects populated, reset others
                        if (!$select.attr('id').includes('grade')) {
                            resetSelect(selector, placeholder);
                        }
                    });
                }

                // Handle question type selection
                $('.question-type-card').click(function () {
                    $('.question-type-card').removeClass('selected');
                    $(this).addClass('selected');
                    $(this).find('input[type="radio"]').prop('checked', true);
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

                // Hierarchy selection handlers for Lesson Mode
                $('#gradeSelectLesson').on('change', function () {
                    const gradeId = $(this).val();
                    if (gradeId) {
                        loadSubjects(gradeId, '#subjectSelectLesson');
                        resetSelect('#chapterSelectLesson', '-- Select Chapter --');
                        resetSelect('#lessonSelect', '-- Select Lesson --');
                        hideContentPreview();
                    }
                });

                $('#subjectSelectLesson').on('change', function () {
                    const subjectId = $(this).val();
                    if (subjectId) {
                        loadChapters(subjectId, '#chapterSelectLesson');
                        resetSelect('#lessonSelect', '-- Select Lesson --');
                        hideContentPreview();
                    }
                });

                $('#chapterSelectLesson').on('change', function () {
                    const chapterId = $(this).val();
                    if (chapterId) {
                        loadLessons(chapterId, '#lessonSelect');
                        hideContentPreview();
                    }
                });

                $('#lessonSelect').on('change', function () {
                    const lessonId = $(this).val();
                    if (lessonId) {
                        loadLessonContent(lessonId);
                    }
                });

                // Hierarchy selection handlers for Chapter Mode
                $('#gradeSelectChapter').on('change', function () {
                    const gradeId = $(this).val();
                    if (gradeId) {
                        loadSubjects(gradeId, '#subjectSelectChapter');
                        resetSelect('#chapterSelect', '-- Select Chapter --');
                        hideContentPreview();
                    }
                });

                $('#subjectSelectChapter').on('change', function () {
                    const subjectId = $(this).val();
                    if (subjectId) {
                        loadChapters(subjectId, '#chapterSelect');
                        hideContentPreview();
                    }
                });

                $('#chapterSelect').on('change', function () {
                    const chapterId = $(this).val();
                    if (chapterId) {
                        loadChapterContent(chapterId);
                    }
                });

                // Hierarchy selection handlers for Subject Mode
                $('#gradeSelectSubject').on('change', function () {
                    const gradeId = $(this).val();
                    if (gradeId) {
                        loadSubjects(gradeId, '#subjectSelectMain');
                        hideContentPreview();
                    }
                });

                $('#subjectSelectMain').on('change', function () {
                    const subjectId = $(this).val();
                    if (subjectId) {
                        loadSubjectContent(subjectId);
                    }
                });

                // Helper functions for AJAX calls
                function loadSubjects(gradeId, targetSelector) {
                    $.get('/ai-question', {
                        action: 'getSubjectsByGrade',
                        gradeId: gradeId
                    }, function (data) {
                        populateSelect(targetSelector, data, '-- Select Subject --');
                    }).fail(function () {
                        console.error('Failed to load subjects');
                        resetSelect(targetSelector, '-- Select Subject --');
                        showAlert('Failed to load subjects. Please try again.', 'danger');
                    });
                }

                function loadChapters(subjectId, targetSelector) {
                    $.get('/ai-question', {
                        action: 'getChaptersBySubject',
                        subjectId: subjectId
                    }, function (data) {
                        populateSelect(targetSelector, data, '-- Select Chapter --');
                    }).fail(function () {
                        console.error('Failed to load chapters');
                        resetSelect(targetSelector, '-- Select Chapter --');
                        showAlert('Failed to load chapters. Please try again.', 'danger');
                    });
                }

                function loadLessons(chapterId, targetSelector) {
                    $.get('/ai-question', {
                        action: 'getLessonsByChapter',
                        chapterId: chapterId
                    }, function (data) {
                        populateSelect(targetSelector, data, '-- Select Lesson --');
                    }).fail(function () {
                        console.error('Failed to load lessons');
                        resetSelect(targetSelector, '-- Select Lesson --');
                        showAlert('Failed to load lessons. Please try again.', 'danger');
                    });
                }

                function loadLessonContent(lessonId) {
                    // For lesson mode, we'll show the lesson content directly
                    showContentPreview();
                    $('#contentStats').html('<div class="stat-item"><i class="fas fa-book-open"></i> Single Lesson Selected</div>');
                    $('#contentText').html('<p><i class="fas fa-info-circle"></i> Lesson content will be used for question generation.</p>');
                    $('#generateBtn').prop('disabled', false);
                }

                function loadChapterContent(chapterId) {
                    $.get('/ai-question', {
                        action: 'getChapterContent',
                        chapterId: chapterId
                    }, function (data) {
                        if (data.error) {
                            showAlert(data.error, 'danger');
                            return;
                        }

                        showContentPreview();
                        $('#contentStats').html(
                                '<div class="stat-item"><i class="fas fa-folder"></i> 1 Chapter</div>' +
                                '<div class="stat-item"><i class="fas fa-book-open"></i> ' + data.lessonCount + ' Lessons</div>'
                                );
                        $('#contentText').html('<pre style="white-space: pre-wrap; font-family: inherit;">' + data.content + '</pre>');
                        $('#generateBtn').prop('disabled', false);
                    }).fail(function () {
                        showAlert('Failed to load chapter content. Please try again.', 'danger');
                    });
                }

                function loadSubjectContent(subjectId) {
                    $.get('/ai-question', {
                        action: 'getSubjectContent',
                        subjectId: subjectId
                    }, function (data) {
                        if (data.error) {
                            showAlert(data.error, 'danger');
                            return;
                        }

                        showContentPreview();
                        $('#contentStats').html(
                                '<div class="stat-item"><i class="fas fa-graduation-cap"></i> 1 Subject</div>' +
                                '<div class="stat-item"><i class="fas fa-folder"></i> ' + data.chapterCount + ' Chapters</div>' +
                                '<div class="stat-item"><i class="fas fa-book-open"></i> ' + data.lessonCount + ' Lessons</div>'
                                );
                        $('#contentText').html('<pre style="white-space: pre-wrap; font-family: inherit;">' + data.content + '</pre>');
                        $('#generateBtn').prop('disabled', false);
                    }).fail(function () {
                        showAlert('Failed to load subject content. Please try again.', 'danger');
                    });
                }

                function showContentPreview() {
                    $('#contentPreviewSection').show();
                    $('#contentPreview').addClass('active');
                }

                function hideContentPreview() {
                    $('#contentPreviewSection').hide();
                    $('#contentPreview').removeClass('active');
                    $('#generateBtn').prop('disabled', true);
                }

                function showAlert(message, type) {
                    // Remove existing alerts
                    $('.alert').remove();

                    const alertHtml = `
                        <div class="alert alert-${type} alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-triangle me-2"></i>
            ${message}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    `;
                    $('.ai-form-container').prepend(alertHtml);

                    // Auto-hide after 5 seconds
                    setTimeout(() => {
                        $('.alert').fadeOut();
                    }, 5000);
                }

                // Form validation and submission
                $('#aiQuestionForm').submit(function (e) {
                    if (!currentMode) {
                        e.preventDefault();
                        showAlert('Please select a content scope first', 'danger');
                        return false;
                    }

                    const numberOfQuestions = $('#numberOfQuestions').val();
                    if (numberOfQuestions < 1 || numberOfQuestions > 50) {
                        e.preventDefault();
                        showAlert('Number of questions must be between 1 and 50', 'danger');
                        $('#numberOfQuestions').focus();
                        return false;
                    }

                    // Validate selection based on mode
                    let isValid = false;
                    if (currentMode === 'lesson') {
                        isValid = $('#lessonSelect').val() !== '';
                    } else if (currentMode === 'chapter') {
                        isValid = $('#chapterSelect').val() !== '';
                    } else if (currentMode === 'subject') {
                        isValid = $('#subjectSelectMain').val() !== '';
                    }

                    if (!isValid) {
                        e.preventDefault();
                        showAlert('Please complete your selection before generating questions', 'danger');
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
                                <p class="text-muted">This may take a few moments depending on content scope</p>
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
                    }, 60000); // 60 second timeout for larger content
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

                // Ensure proper z-index stacking for Select2 dropdowns
                $('.form-section').each(function (index) {
                    $(this).css('z-index', 100 - index);
                });

                // Handle Select2 dropdown positioning and prevent duplicates
                $(document).on('select2:open', function (e) {
                    const selectId = e.target.id;
                    const $dropdown = $('#select2-' + selectId + '-results').parent();
                    $dropdown.css('z-index', 9999);
                });

                // Cleanup on page unload
                $(window).on('beforeunload', function () {
                    $('.select2-dropdown').each(function () {
                        const selector = '#' + $(this).attr('id');
                        destroySelect2(selector);
                    });
                });
            });
        </script>
    </body>
</html>
