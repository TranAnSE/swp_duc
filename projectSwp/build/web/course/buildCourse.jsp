<%-- 
    Document   : buildCourse
    Created on : Jul 3, 2025, 2:34:20 PM
    Author     : ankha
--%>

<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Build Course - ${courseDetails.course_title}</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <!-- Sortable.js for drag and drop -->
        <script src="https://cdn.jsdelivr.net/npm/sortablejs@1.15.0/Sortable.min.js"></script>

        <style>
            body {
                padding-top: 130px;
                background-color: #f8f9fa;
            }
            .build-container {
                max-width: 1200px;
                margin: 40px auto;
                background: white;
                border-radius: 12px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                overflow: hidden;
            }
            .course-header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 30px;
            }
            .hierarchy-path {
                font-size: 1.2em;
                display: flex;
                align-items: center;
                gap: 10px;
                margin-bottom: 15px;
            }
            .hierarchy-arrow {
                font-size: 1.3em;
            }
            .course-info {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 20px;
                margin-top: 20px;
            }
            .info-item {
                background: rgba(255,255,255,0.1);
                padding: 15px;
                border-radius: 8px;
            }
            .info-item h6 {
                margin-bottom: 5px;
                opacity: 0.8;
            }
            .content-section {
                padding: 30px;
            }
            .section-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
                padding-bottom: 10px;
                border-bottom: 2px solid #e9ecef;
            }
            .content-item {
                background: #f8f9fa;
                border: 1px solid #dee2e6;
                border-radius: 8px;
                padding: 15px;
                margin-bottom: 10px;
                cursor: move;
                transition: all 0.3s ease;
            }
            .content-item:hover {
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }
            .content-item.sortable-ghost {
                opacity: 0.5;
            }
            .content-item-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .content-type-badge {
                padding: 4px 8px;
                border-radius: 12px;
                font-size: 0.8em;
                font-weight: bold;
            }
            .badge-chapter {
                background-color: #e3f2fd;
                color: #1976d2;
            }
            .badge-lesson {
                background-color: #e8f5e8;
                color: #388e3c;
            }
            .badge-test {
                background-color: #fff3e0;
                color: #f57c00;
            }
            .add-content-section {
                background: #f8f9fa;
                border: 2px dashed #dee2e6;
                border-radius: 8px;
                padding: 30px;
                text-align: center;
                margin: 20px 0;
            }
            .quick-actions {
                display: flex;
                gap: 10px;
                flex-wrap: wrap;
                justify-content: center;
            }
            .btn-custom {
                padding: 10px 20px;
                border-radius: 6px;
                font-weight: 600;
                text-decoration: none;
                border: none;
                cursor: pointer;
                transition: all 0.3s ease;
            }
            .btn-primary-custom {
                background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
                color: white;
            }
            .btn-success-custom {
                background: linear-gradient(135deg, #28a745 0%, #1e7e34 100%);
                color: white;
            }
            .btn-warning-custom {
                background: linear-gradient(135deg, #ffc107 0%, #e0a800 100%);
                color: #212529;
            }
            .btn-info-custom {
                background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
                color: white;
            }
            .empty-state {
                text-align: center;
                padding: 40px;
                color: #6c757d;
            }
            .empty-state i {
                font-size: 3em;
                margin-bottom: 15px;
            }
            .publish-section {
                background: #fff3cd;
                border: 1px solid #ffeaa7;
                border-radius: 8px;
                padding: 20px;
                margin-top: 30px;
            }
            .publish-section.ready {
                background: #d4edda;
                border-color: #c3e6cb;
            }
            .chapter-content {
                margin-left: 20px;
                margin-top: 10px;
            }
            .lesson-item {
                background: #ffffff;
                border-left: 3px solid #28a745;
                margin-bottom: 5px;
            }
            .chapter-lessons {
                margin-top: 10px;
            }
            .add-lesson-btn {
                background: #e8f5e8;
                border: 1px dashed #28a745;
                color: #28a745;
                padding: 8px 12px;
                border-radius: 4px;
                font-size: 0.9em;
                margin-top: 5px;
            }
            .modal-content {
                border-radius: 8px;
            }
            .modal-header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                border-radius: 8px 8px 0 0;
            }
            /* Modal fallback styles */
            .modal {
                position: fixed;
                top: 0;
                left: 0;
                z-index: 1055;
                width: 100%;
                height: 100%;
                overflow-x: hidden;
                overflow-y: auto;
                outline: 0;
            }

            .modal.show {
                display: block !important;
            }

            .modal-backdrop {
                position: fixed;
                top: 0;
                left: 0;
                z-index: 1050;
                width: 100vw;
                height: 100vh;
                background-color: #000;
            }

            .modal-backdrop.fade {
                opacity: 0;
            }

            .modal-backdrop.show {
                opacity: 0.5;
            }

            .modal-open {
                overflow: hidden;
            }

            /* Sortable ghost styles */
            .sortable-ghost {
                opacity: 0.4;
                background: #f8f9fa;
            }

            .content-item {
                cursor: move;
                transition: all 0.3s ease;
            }

            .content-item:hover {
                background-color: #f8f9fa;
            }
            .position-fixed {
                position: fixed !important;
            }

            .alert {
                padding: 12px 20px;
                margin-bottom: 20px;
                border: 1px solid transparent;
                border-radius: 4px;
            }

            .alert-success {
                color: #155724;
                background-color: #d4edda;
                border-color: #c3e6cb;
            }

            .alert-info {
                color: #0c5460;
                background-color: #d1ecf1;
                border-color: #bee5eb;
            }

            .alert-danger {
                color: #721c24;
                background-color: #f8d7da;
                border-color: #f5c6cb;
            }

            .alert-dismissible {
                position: relative;
                padding-right: 4rem;
            }

            .alert-dismissible .close {
                position: absolute;
                top: 0;
                right: 0;
                padding: 12px 20px;
                color: inherit;
                background: none;
                border: none;
                font-size: 1.5rem;
                cursor: pointer;
            }

            .fade {
                transition: opacity 0.15s linear;
            }

            .show {
                opacity: 1;
            }
            /* Fix FontAwesome icons display */
            .fas, .fa {
                font-family: "Font Awesome 5 Free" !important;
                font-weight: 900 !important;
                -webkit-font-smoothing: antialiased;
                display: inline-block;
                font-style: normal;
                font-variant: normal;
                text-rendering: auto;
                line-height: 1;
            }

            /* Ensure buttons show icons properly */
            .btn i {
                margin-right: 4px;
                font-size: 0.875em;
            }

            .btn-sm i {
                margin-right: 2px;
                font-size: 0.8em;
            }

            /* Fix for trash icon specifically */
            .fa-trash:before {
                content: "\f2ed";
            }

            .fa-spinner:before {
                content: "\f110";
            }

            .fa-check:before {
                content: "\f00c";
            }

            .fa-plus:before {
                content: "\f067";
            }

            .fa-exclamation-triangle:before {
                content: "\f071";
            }

            /* Loading animation for spinner */
            .fa-spin {
                animation: fa-spin 2s infinite linear;
            }

            @keyframes fa-spin {
                0% {
                    transform: rotate(0deg);
                }
                100% {
                    transform: rotate(359deg);
                }
            }

            /* Enhanced button states */
            .btn-success {
                background-color: #28a745 !important;
                border-color: #28a745 !important;
            }

            .btn-danger {
                background-color: #dc3545 !important;
                border-color: #dc3545 !important;
            }

            .btn-outline-success {
                color: #28a745 !important;
                border-color: #28a745 !important;
            }

            .btn-outline-success:hover {
                background-color: #28a745 !important;
                color: white !important;
            }

            /* Smooth transitions for all buttons */
            .btn {
                transition: all 0.3s ease;
            }

            /* Badge styling */
            .badge {
                display: inline-flex;
                align-items: center;
                gap: 4px;
            }

            .badge i {
                margin: 0;
            }

            /* Content item animations */
            .content-item {
                transition: opacity 0.5s ease, transform 0.3s ease;
            }

            .content-item:hover {
                transform: translateY(-2px);
            }

            .content-item.removing {
                opacity: 0.5;
                transform: scale(0.95);
            }
            .lesson-item {
                background: #ffffff;
                border-left: 3px solid #28a745;
                margin-bottom: 5px;
                padding: 10px;
                border-radius: 4px;
            }

            .lesson-item:hover {
                background-color: #f8f9fa;
                transform: translateX(2px);
            }

            .lesson-item .content-type-badge {
                font-size: 0.7em;
            }

            .chapter-lessons {
                margin-top: 10px;
                padding-left: 15px;
                border-left: 2px solid #e9ecef;
            }

            .badge-lesson {
                background-color: #e8f5e8;
                color: #388e3c;
            }

            .text-primary {
                color: #007bff !important;
            }

            .small {
                font-size: 0.875em;
            }
            .test-section {
                margin-bottom: 25px;
                padding: 15px;
                border: 1px solid #e0e0e0;
                border-radius: 8px;
                background: #f9f9f9;
            }

            .test-section h6 {
                color: #495057;
                margin-bottom: 15px;
                font-weight: 600;
            }

            .lesson-test-section {
                margin-left: 20px;
                background: #ffffff;
                border-left: 3px solid #28a745;
            }

            .lesson-test-item {
                background: #ffffff;
                border-left: 3px solid #17a2b8;
            }

            .radio-option {
                display: block;
                margin-bottom: 10px;
                cursor: pointer;
                padding: 8px 12px;
                border-radius: 4px;
                transition: background-color 0.2s;
            }

            .radio-option:hover {
                background-color: #f8f9fa;
            }

            .radio-option input[type="radio"] {
                margin-right: 8px;
            }

            .form-group {
                margin-bottom: 20px;
            }

            .form-group label {
                font-weight: 600;
                margin-bottom: 8px;
                display: block;
            }
            .list-group-item {
                transition: all 0.2s ease;
            }

            .list-group-item:hover {
                background-color: #f8f9fa;
                transform: translateY(-1px);
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }

            .test-info-details {
                margin-top: 5px;
            }

            .test-info-details .badge {
                margin-right: 5px;
            }

            .test-type-practice {
                background-color: #28a745;
            }

            .test-type-official {
                background-color: #dc3545;
            }

            .test-creator {
                font-style: italic;
                color: #6c757d;
            }
            .lesson-actions {
                display: flex;
                gap: 5px;
                align-items: center;
            }

            .lesson-actions .btn {
                padding: 4px 8px;
                font-size: 0.75rem;
                border-radius: 4px;
                transition: all 0.2s ease;
            }

            .lesson-actions .btn:hover {
                transform: translateY(-1px);
            }

            .lesson-item .content-item-header {
                display: flex;
                justify-content: space-between;
                align-items: flex-start;
                gap: 10px;
            }

            .lesson-item .content-item-header > div:first-child {
                flex: 1;
                min-width: 0;
            }

            .lesson-item .content-item-header .lesson-actions {
                flex-shrink: 0;
            }

            /* Responsive adjustments for lesson actions */
            @media (max-width: 768px) {
                .lesson-actions {
                    flex-direction: column;
                    gap: 3px;
                }

                .lesson-actions .btn {
                    width: 100%;
                    font-size: 0.7rem;
                    padding: 3px 6px;
                }
            }
        </style>
    </head>
    <body>
        <%@include file="../header.jsp" %>

        <!-- Success/Error Messages -->
        <c:if test="${not empty param.message}">
            <div class="alert alert-success alert-dismissible fade show position-fixed" 
                 style="top: 120px; right: 20px; z-index: 1050; min-width: 300px;" role="alert">
                <i class="fas fa-check-circle mr-2"></i>
                ${param.message}
                <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>

            <script>
                // Auto-hide success message after 5 seconds
                setTimeout(function () {
                    $('.alert-success').fadeOut();
                }, 5000);
            </script>
        </c:if>

        <div class="build-container">
            <!-- Course Header -->
            <div class="course-header">
                <div class="row">
                    <div class="col-md-8">
                        <div class="hierarchy-path">
                            <span>${courseDetails.grade_name}</span>
                            <i class="fas fa-arrow-right hierarchy-arrow"></i>
                            <span>${courseDetails.subject_name}</span>
                            <i class="fas fa-arrow-right hierarchy-arrow"></i>
                            <span><strong>${courseDetails.course_title}</strong></span>
                        </div>

                        <div class="course-info">
                            <div class="info-item">
                                <h6>Price</h6>
                                <strong><fmt:formatNumber value="${courseDetails.price}" type="number" groupingUsed="true"/> VND</strong>
                            </div>
                            <div class="info-item">
                                <h6>Duration</h6>
                                <strong>${courseDetails.duration_days} days</strong>
                            </div>
                            <div class="info-item">
                                <h6>Status</h6>
                                <strong>
                                    <c:choose>
                                        <c:when test="${courseDetails.approval_status == 'DRAFT'}">Draft</c:when>
                                        <c:when test="${courseDetails.approval_status == 'PENDING_APPROVAL'}">Pending Approval</c:when>
                                        <c:when test="${courseDetails.approval_status == 'APPROVED'}">Approved</c:when>
                                        <c:when test="${courseDetails.approval_status == 'REJECTED'}">Rejected</c:when>
                                    </c:choose>
                                </strong>
                            </div>
                            <c:if test="${not empty courseDetails.description}">
                                <div class="info-item">
                                    <h6>Description</h6>
                                    <p>${courseDetails.description}</p>
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <!-- Add thumbnail display column -->
                    <div class="col-md-4 text-right">
                        <c:choose>
                            <c:when test="${not empty courseDetails.thumbnail_url}">
                                <div class="course-thumbnail-preview">
                                    <h6 style="color: rgba(255,255,255,0.8); margin-bottom: 10px;">Course Thumbnail</h6>
                                    <img src="${courseDetails.thumbnail_url}" alt="Course Thumbnail" 
                                         style="width: 150px; height: 100px; object-fit: cover; border-radius: 8px;
                                         border: 2px solid rgba(255,255,255,0.3); box-shadow: 0 4px 8px rgba(0,0,0,0.2);">
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="course-thumbnail-placeholder" 
                                     style="width: 150px; height: 100px; background-color: rgba(255,255,255,0.1);
                                     border: 2px dashed rgba(255,255,255,0.3); border-radius: 8px;
                                     display: flex; align-items: center; justify-content: center; margin-left: auto;">
                                    <div style="text-align: center; color: rgba(255,255,255,0.6);">
                                        <i class="fas fa-image fa-2x mb-2"></i>
                                        <br><small>No Thumbnail</small>
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <!-- Content Building Section -->
            <div class="content-section">
                <div class="section-header">
                    <h4><i class="fas fa-puzzle-piece"></i> Course Content</h4>
                    <div>
                        <button class="btn btn-outline-primary btn-sm" onclick="toggleAddContent()">
                            <i class="fas fa-plus"></i> Add Content
                        </button>
                        <a href="course?action=edit&id=${courseId}" class="btn btn-outline-secondary btn-sm">
                            <i class="fas fa-edit"></i> Edit Course Info
                        </a>
                    </div>
                </div>

                <!-- Add Content Section (Initially Hidden) -->
                <div id="addContentSection" class="add-content-section" style="display: none;">
                    <h5><i class="fas fa-plus-circle"></i> Add New Content</h5>
                    <p class="text-muted">Choose what type of content you want to add to your course</p>

                    <div class="quick-actions">
                        <a href="${pageContext.request.contextPath}/chapter?service=add&returnTo=course&courseId=${courseId}" 
                           class="btn-custom btn-primary-custom">
                            <i class="fas fa-book"></i> Create Chapter
                        </a>
                        <a href="${pageContext.request.contextPath}/LessonURL?action=addForm&returnTo=course&courseId=${courseId}" 
                           class="btn-custom btn-success-custom">
                            <i class="fas fa-play"></i> Create Lesson
                        </a>
                        <a href="${pageContext.request.contextPath}/Question?action=addForm&returnTo=course&courseId=${courseId}" 
                           class="btn-custom btn-warning-custom">
                            <i class="fas fa-question-circle"></i> Create Questions
                        </a>
                        <a href="${pageContext.request.contextPath}/test?action=createForCourse&courseId=${courseId}"
                           class="btn-custom btn-info-custom">
                            <i class="fas fa-clipboard-check"></i> Create Test
                        </a>
                    </div>

                    <hr class="my-4">

                    <!-- Existing Content Selection -->
                    <div class="row">
                        <div class="col-md-6">
                            <h6>Available Chapters</h6>
                            <c:choose>
                                <c:when test="${not empty availableChapters}">
                                    <div class="list-group" style="max-height: 200px; overflow-y: auto;">
                                        <c:forEach items="${availableChapters}" var="chapter" varStatus="status">
                                            <div class="list-group-item d-flex justify-content-between align-items-center">
                                                <div>
                                                    <strong>${chapter.name}</strong>
                                                    <c:if test="${not empty chapter.description}">
                                                        <br><small class="text-muted">${chapter.description}</small>
                                                    </c:if>
                                                </div>
                                                <c:choose>
                                                    <c:when test="${addedChapterIds.contains(chapter.id)}">
                                                        <span class="badge bg-success">
                                                            <i class="fas fa-check"></i> Added
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button class="btn btn-sm btn-outline-primary" 
                                                                onclick="addChapterToCourse(${chapter.id})"
                                                                type="button">
                                                            <i class="fas fa-plus"></i> Add
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-muted">No chapters available for this subject. 
                                        <a href="${pageContext.request.contextPath}/chapter?service=add&returnTo=course&courseId=${courseId}">Create one</a>
                                    </p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="col-md-6">
                            <h6>Quick Actions</h6>
                            <div class="d-grid gap-2">
                                <button class="btn btn-outline-info btn-sm" onclick="showLessonModal()">
                                    <i class="fas fa-search"></i> Browse Lessons
                                </button>
                                <button class="btn btn-outline-warning btn-sm" onclick="showTestModal()">
                                    <i class="fas fa-search"></i> Browse Tests
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Current Course Content -->
                <div id="courseContent">
                    <c:choose>
                        <c:when test="${empty courseChapters and empty courseLessons and empty courseTests}">
                            <div class="empty-state">
                                <i class="fas fa-book-open"></i>
                                <h5>No content added yet</h5>
                                <p>Start building your course by adding chapters, lessons, and tests.</p>
                                <button class="btn btn-primary" onclick="toggleAddContent()">
                                    <i class="fas fa-plus"></i> Add Your First Content
                                </button>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- Chapters with nested lessons -->
                            <c:if test="${not empty courseChapters}">
                                <h5><i class="fas fa-book"></i> Course Structure</h5>
                                <div id="chaptersList" class="sortable-list">
                                    <c:forEach items="${courseChapters}" var="chapter">
                                        <div class="content-item" data-id="${chapter.chapter_id}" data-type="chapter">
                                            <div class="content-item-header">
                                                <div>
                                                    <span class="content-type-badge badge-chapter">Chapter</span>
                                                    <strong>${chapter.chapter_name}</strong>
                                                </div>
                                                <div>
                                                    <button class="btn btn-sm btn-outline-success" 
                                                            onclick="showAddLessonModal(${chapter.chapter_id}, '${fn:escapeXml(chapter.chapter_name)}')">
                                                        <i class="fas fa-plus"></i> Add Lesson
                                                    </button>
                                                    <button class="btn btn-sm btn-outline-danger" 
                                                            onclick="removeFromCourse('chapter', ${chapter.chapter_id})">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </div>
                                            </div>
                                            <c:if test="${not empty chapter.chapter_description}">
                                                <p class="text-muted mb-2">${chapter.chapter_description}</p>
                                            </c:if>

                                            <!-- Lessons in this chapter -->
                                            <div class="chapter-lessons">
                                                <c:set var="chapterLessons" value="${chapterLessonsMap[chapter.chapter_id]}" />
                                                <c:if test="${not empty chapterLessons}">
                                                    <c:forEach items="${courseLessons}" var="lesson">
                                                        <c:if test="${lesson.chapter_id == chapter.chapter_id}">
                                                            <div class="content-item lesson-item" data-id="${lesson.lesson_id}" data-type="lesson">
                                                                <div class="content-item-header">
                                                                    <div>
                                                                        <span class="content-type-badge badge-lesson">Lesson</span>
                                                                        <strong>${lesson.lesson_name}</strong>
                                                                        <c:if test="${not empty lesson.video_link}">
                                                                            <i class="fas fa-video text-primary ml-2" title="Has video"></i>
                                                                        </c:if>
                                                                    </div>
                                                                    <div class="lesson-actions">
                                                                        <!-- View Lesson Button -->
                                                                        <a href="/video-viewer?courseId=${courseId}&lessonId=${lesson.lesson_id}&returnTo=buildCourse"
                                                                           class="btn btn-sm btn-outline-info" title="View Lesson">
                                                                            <i class="fas fa-eye"></i>
                                                                        </a>
                                                                        <!-- Edit Lesson Button -->
                                                                        <a href="${pageContext.request.contextPath}/LessonURL?action=updateForm&id=${lesson.lesson_id}&returnTo=buildCourse&courseId=${courseId}"
                                                                           class="btn btn-sm btn-outline-warning" title="Edit Lesson">
                                                                            <i class="fas fa-edit"></i>
                                                                        </a>
                                                                        <!-- Remove Lesson Button -->
                                                                        <button class="btn btn-sm btn-outline-danger"
                                                                                onclick="removeFromCourse('lesson', ${lesson.lesson_id})" title="Remove from Course">
                                                                            <i class="fas fa-trash"></i>
                                                                        </button>
                                                                    </div>
                                                                </div>
                                                                <c:if test="${not empty lesson.lesson_content}">
                                                                    <p class="text-muted mb-0 small">${fn:substring(lesson.lesson_content, 0, 100)}...</p>
                                                                </c:if>
                                                            </div>
                                                        </c:if>
                                                    </c:forEach>
                                                </c:if>
                                                <!-- Show message if no lessons in chapter -->
                                                <c:if test="${empty chapterLessons}">
                                                    <div class="text-muted small mt-2">
                                                        <i class="fas fa-info-circle"></i> No lessons added to this chapter yet.
                                                    </div>
                                                </c:if>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:if>

                            <!-- Tests Section -->
                            <c:if test="${not empty courseTests}">
                                <h5><i class="fas fa-clipboard-check"></i> Tests (${courseTests.size()})</h5>
                                <div class="alert alert-info">
                                    <i class="fas fa-info-circle"></i>
                                    Tests can be positioned at course level, chapter level, or lesson level. Drag to reorder within each section.
                                </div>

                                <!-- Course Level Tests -->
                                <c:set var="courseLevelTests" value="${courseTests.stream().filter(t -> t.position_context == 'course').toList()}" />
                                <c:if test="${not empty courseLevelTests}">
                                    <div class="test-section">
                                        <h6><i class="fas fa-graduation-cap"></i> Course Level Tests</h6>
                                        <div id="courseLevelTests" class="sortable-list test-sortable" data-context="course">
                                            <c:forEach items="${courseLevelTests}" var="test">
                                                <div class="content-item test-item" data-id="${test.test_id}" data-type="test" 
                                                     data-chapter-id="" data-lesson-id="">
                                                    <div class="content-item-header">
                                                        <div>
                                                            <span class="content-type-badge badge-test">
                                                                ${test.is_practice ? 'Practice' : 'Official'} Test
                                                            </span>
                                                            <strong>${test.test_name}</strong>
                                                            <span class="text-info ml-2">
                                                                <i class="fas fa-clock"></i> ${test.duration_minutes}min
                                                                <i class="fas fa-question-circle ml-1"></i> ${test.num_questions}q
                                                            </span>
                                                        </div>
                                                        <div>
                                                            <button class="btn btn-sm btn-outline-secondary" 
                                                                    onclick="showTestPositionModal(${test.test_id}, '${fn:escapeXml(test.test_name)}', 'course', null, null)">
                                                                <i class="fas fa-arrows-alt"></i> Move
                                                            </button>
                                                            <button class="btn btn-sm btn-outline-primary" 
                                                                    onclick="editTest(${test.test_id})">
                                                                <i class="fas fa-edit"></i> Edit
                                                            </button>
                                                            <button class="btn btn-sm btn-outline-danger" 
                                                                    onclick="removeFromCourse('test', ${test.test_id})">
                                                                <i class="fas fa-trash"></i>
                                                            </button>
                                                        </div>
                                                    </div>
                                                    <c:if test="${not empty test.test_description}">
                                                        <p class="text-muted mb-0">${test.test_description}</p>
                                                    </c:if>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </c:if>

                                <!-- Chapter Level Tests -->
                                <c:forEach items="${courseChapters}" var="chapter">
                                    <c:set var="chapterTests" value="${courseTests.stream().filter(t -> t.chapter_id != null && t.chapter_id == chapter.chapter_id && t.position_context == 'chapter').toList()}" />
                                    <c:if test="${not empty chapterTests}">
                                        <div class="test-section">
                                            <h6><i class="fas fa-bookmark"></i> ${chapter.chapter_name} Tests</h6>
                                            <div id="chapterTests_${chapter.chapter_id}" class="sortable-list test-sortable" 
                                                 data-context="chapter" data-chapter-id="${chapter.chapter_id}">
                                                <c:forEach items="${chapterTests}" var="test">
                                                    <div class="content-item test-item" data-id="${test.test_id}" data-type="test" 
                                                         data-chapter-id="${chapter.chapter_id}" data-lesson-id="">
                                                        <div class="content-item-header">
                                                            <div>
                                                                <span class="content-type-badge badge-test">
                                                                    ${test.is_practice ? 'Practice' : 'Official'} Test
                                                                </span>
                                                                <strong>${test.test_name}</strong>
                                                                <span class="text-info ml-2">
                                                                    <i class="fas fa-clock"></i> ${test.duration_minutes}min
                                                                    <i class="fas fa-question-circle ml-1"></i> ${test.num_questions}q
                                                                </span>
                                                            </div>
                                                            <div>
                                                                <button class="btn btn-sm btn-outline-secondary" 
                                                                        onclick="showTestPositionModal(${test.test_id}, '${fn:escapeXml(test.test_name)}', 'chapter', ${chapter.chapter_id}, null)">
                                                                    <i class="fas fa-arrows-alt"></i> Move
                                                                </button>
                                                                <button class="btn btn-sm btn-outline-primary" 
                                                                        onclick="editTest(${test.test_id})">
                                                                    <i class="fas fa-edit"></i> Edit
                                                                </button>
                                                                <button class="btn btn-sm btn-outline-danger" 
                                                                        onclick="removeFromCourse('test', ${test.test_id})">
                                                                    <i class="fas fa-trash"></i>
                                                                </button>
                                                            </div>
                                                        </div>
                                                        <c:if test="${not empty test.test_description}">
                                                            <p class="text-muted mb-0">${test.test_description}</p>
                                                        </c:if>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </c:if>

                                    <!-- Lesson Level Tests for this chapter -->
                                    <c:forEach items="${courseLessons}" var="lesson">
                                        <c:if test="${lesson.chapter_id == chapter.chapter_id}">
                                            <c:set var="lessonTests" value="${courseTests.stream().filter(t -> t.lesson_id != null && t.lesson_id == lesson.lesson_id).toList()}" />
                                            <c:if test="${not empty lessonTests}">
                                                <div class="test-section lesson-test-section">
                                                    <h6><i class="fas fa-play"></i> ${lesson.lesson_name} Tests</h6>
                                                    <div id="lessonTests_${lesson.lesson_id}" class="sortable-list test-sortable" 
                                                         data-context="lesson" data-chapter-id="${chapter.chapter_id}" data-lesson-id="${lesson.lesson_id}">
                                                        <c:forEach items="${lessonTests}" var="test">
                                                            <div class="content-item test-item lesson-test-item" data-id="${test.test_id}" data-type="test" 
                                                                 data-chapter-id="${chapter.chapter_id}" data-lesson-id="${lesson.lesson_id}">
                                                                <div class="content-item-header">
                                                                    <div>
                                                                        <span class="content-type-badge badge-test">
                                                                            ${test.is_practice ? 'Practice' : 'Official'} Test
                                                                        </span>
                                                                        <strong>${test.test_name}</strong>
                                                                        <span class="text-info ml-2">
                                                                            <i class="fas fa-clock"></i> ${test.duration_minutes}min
                                                                            <i class="fas fa-question-circle ml-1"></i> ${test.num_questions}q
                                                                        </span>
                                                                    </div>
                                                                    <div>
                                                                        <button class="btn btn-sm btn-outline-secondary" 
                                                                                onclick="showTestPositionModal(${test.test_id}, '${fn:escapeXml(test.test_name)}', 'lesson', ${chapter.chapter_id}, ${lesson.lesson_id})">
                                                                            <i class="fas fa-arrows-alt"></i> Move
                                                                        </button>
                                                                        <button class="btn btn-sm btn-outline-primary" 
                                                                                onclick="editTest(${test.test_id})">
                                                                            <i class="fas fa-edit"></i> Edit
                                                                        </button>
                                                                        <button class="btn btn-sm btn-outline-danger" 
                                                                                onclick="removeFromCourse('test', ${test.test_id})">
                                                                            <i class="fas fa-trash"></i>
                                                                        </button>
                                                                    </div>
                                                                </div>
                                                                <c:if test="${not empty test.test_description}">
                                                                    <p class="text-muted mb-0">${test.test_description}</p>
                                                                </c:if>
                                                            </div>
                                                        </c:forEach>
                                                    </div>
                                                </div>
                                            </c:if>
                                        </c:if>
                                    </c:forEach>
                                </c:forEach>
                            </c:if>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Publish Section -->
                <div class="publish-section ${(not empty courseChapters or not empty courseLessons) ? 'ready' : ''}">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h5>
                                <i class="fas fa-rocket"></i> 
                                <c:choose>
                                    <c:when test="${courseDetails.approval_status == 'DRAFT'}">Ready to Publish?</c:when>
                                    <c:when test="${courseDetails.approval_status == 'PENDING_APPROVAL'}">
                                        <i class="fas fa-clock text-warning"></i> Pending Approval - Editing Locked
                                    </c:when>
                                    <c:when test="${courseDetails.approval_status == 'APPROVED'}">
                                        <c:choose>
                                            <c:when test="${courseDetails.allow_edit_after_approval}">
                                                <i class="fas fa-edit text-info"></i> Course Approved - Edit Mode Enabled
                                            </c:when>
                                            <c:otherwise>
                                                <i class="fas fa-lock text-success"></i> Course Approved - Locked
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:when test="${courseDetails.approval_status == 'REJECTED'}">
                                        <i class="fas fa-times text-danger"></i> Course Rejected
                                    </c:when>
                                </c:choose>
                            </h5>
                            <p class="mb-0">
                                <c:choose>
                                    <c:when test="${courseDetails.approval_status == 'DRAFT'}">
                                        Submit your course for admin approval to make it available to students.
                                    </c:when>
                                    <c:when test="${courseDetails.approval_status == 'PENDING_APPROVAL'}">
                                        <span class="text-warning">
                                            <strong>Your course is waiting for admin approval.</strong><br>
                                            All editing functions are locked while pending approval. You cannot modify content, add/remove chapters, lessons, or tests.
                                        </span>
                                    </c:when>
                                    <c:when test="${courseDetails.approval_status == 'APPROVED'}">
                                        <c:choose>
                                            <c:when test="${courseDetails.allow_edit_after_approval}">
                                                <span class="text-info">
                                                    <strong>Edit permission granted!</strong><br>
                                                    Your course is approved but you have special permission to edit. Remember to resubmit after making changes!
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-success">
                                                    <strong>Your course has been approved and is available to students!</strong><br>
                                                    Course content is locked to maintain quality. Contact admin if you need to make changes.
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:when test="${courseDetails.approval_status == 'REJECTED'}">
                                        <span class="text-danger">
                                            <strong>Your course was rejected.</strong><br>
                                            Reason: ${courseDetails.rejection_reason}<br>
                                            Please address the issues and resubmit for approval.
                                        </span>
                                    </c:when>
                                </c:choose>
                            </p>
                        </div>
                        <div>
                            <c:choose>
                                <c:when test="${courseDetails.approval_status == 'DRAFT'}">
                                    <c:if test="${not empty courseChapters or not empty courseLessons}">
                                        <button class="btn btn-warning btn-lg" onclick="submitForApproval()">
                                            <i class="fas fa-paper-plane"></i> Submit for Approval
                                        </button>
                                    </c:if>
                                </c:when>
                                <c:when test="${courseDetails.approval_status == 'REJECTED'}">
                                    <button class="btn btn-warning btn-lg" onclick="resubmitAfterReject()">
                                        <i class="fas fa-paper-plane"></i> Resubmit for Approval
                                    </button>
                                </c:when>
                                <c:when test="${courseDetails.approval_status == 'APPROVED' && courseDetails.allow_edit_after_approval}">
                                    <button class="btn btn-warning btn-lg" onclick="resubmitForApproval()">
                                        <i class="fas fa-paper-plane"></i> Resubmit Changes
                                    </button>
                                </c:when>
                                <c:when test="${courseDetails.approval_status == 'PENDING_APPROVAL'}">
                                    <button class="btn btn-secondary btn-lg" disabled>
                                        <i class="fas fa-clock"></i> Waiting for Approval
                                    </button>
                                </c:when>
                                <c:when test="${courseDetails.approval_status == 'APPROVED' && not courseDetails.allow_edit_after_approval}">
                                    <button class="btn btn-success btn-lg" disabled>
                                        <i class="fas fa-check"></i> Course Approved
                                    </button>
                                </c:when>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="d-flex justify-content-between mt-4">
                    <a href="${pageContext.request.contextPath}/course" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to Course List
                    </a>
                    <div>
                        <button class="btn btn-info" onclick="previewCourse()">
                            <i class="fas fa-eye"></i> Preview Course
                        </button>
                        <button class="btn btn-success" onclick="saveDraft()">
                            <i class="fas fa-save"></i> Save Draft
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Add Lesson Modal -->
        <div class="modal fade" id="addLessonModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Add Lesson to Chapter</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div id="chapterInfo" class="alert alert-info"></div>
                        <div id="availableLessons">
                            <div class="text-center">
                                <div class="spinner-border" role="status">
                                    <span class="visually-hidden">Loading...</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <a id="createLessonBtn" href="#" class="btn btn-success">
                            <i class="fas fa-plus"></i> Create New Lesson
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <%@include file="../footer.jsp" %>

        <!-- JS -->
        <script src="${pageContext.request.contextPath}/assets/js/vendor/jquery-1.12.4.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
                            let currentChapterId = null;
                            let currentChapterName = '';
                            let currentTestId = null;
                            let currentTestName = '';

                            // Initialize when DOM is ready
                            document.addEventListener('DOMContentLoaded', function () {
                                console.log('DOM loaded, initializing...');

                                // Initialize sortable lists
                                initializeSortable();

                                // Initialize Bootstrap modal if exists
                                initializeModals();

                                // Set up event listeners
                                setupEventListeners();
                            });

                            function initializeSortable() {
                                try {
                                    const sortableLists = document.querySelectorAll('.sortable-list');
                                    console.log('Found sortable lists:', sortableLists.length);

                                    sortableLists.forEach(list => {
                                        if (typeof Sortable !== 'undefined') {
                                            new Sortable(list, {
                                                animation: 150,
                                                ghostClass: 'sortable-ghost',
                                                handle: '.content-item',
                                                onEnd: function (evt) {
                                                    if (evt.from.classList.contains('test-sortable')) {
                                                        reorderTestsInSection(evt.from);
                                                    } else if (evt.from.id === 'testsList') {
                                                        reorderTests();
                                                    } else {
                                                        updateContentOrder(evt.from);
                                                    }
                                                }
                                            });
                                        }
                                    });

                                    function reorderTestsInSection(container) {
                                        const testItems = container.querySelectorAll('.test-item');
                                        const testIds = Array.from(testItems).map(item => item.dataset.id).filter(id => id);

                                        if (testIds.length === 0) {
                                            return;
                                        }

                                        const params = new URLSearchParams();
                                        params.append('action', 'reorderTests');
                                        params.append('courseId', '${courseId}');
                                        testIds.forEach(id => params.append('testIds[]', id));

                                        fetch('${pageContext.request.contextPath}/course', {
                                            method: 'POST',
                                            headers: {
                                                'Content-Type': 'application/x-www-form-urlencoded',
                                                'X-Requested-With': 'XMLHttpRequest'
                                            },
                                            body: params.toString()
                                        })
                                                .then(response => response.json())
                                                .then(data => {
                                                    if (data.success) {
                                                        console.log('Tests reordered successfully in section.');
                                                    } else {
                                                        console.error('Failed to reorder tests:', data.message);
                                                    }
                                                })
                                                .catch(error => {
                                                    console.error('Error reordering tests:', error);
                                                });
                                    }

                                    // Initialize sortable for lesson lists within chapters
                                    const lessonLists = document.querySelectorAll('.chapter-lessons');
                                    lessonLists.forEach(list => {
                                        if (typeof Sortable !== 'undefined') {
                                            new Sortable(list, {
                                                animation: 150,
                                                ghostClass: 'sortable-ghost',
                                                handle: '.lesson-item',
                                                onEnd: function (evt) {
                                                    updateLessonOrder(evt.from);
                                                }
                                            });
                                        }
                                    });
                                } catch (error) {
                                    console.error('Error initializing sortable:', error);
                                }
                            }

                            function updateLessonOrder(container) {
                                const chapterId = container.closest('.content-item').dataset.id;
                                const lessonItems = container.querySelectorAll('.lesson-item');
                                const lessonIds = Array.from(lessonItems).map(item => item.dataset.id).filter(id => id);

                                if (lessonIds.length === 0) {
                                    return;
                                }

                                const params = new URLSearchParams();
                                params.append('action', 'reorderLessons');
                                params.append('courseId', '${courseId}');
                                params.append('chapterId', chapterId);
                                lessonIds.forEach(id => params.append('lessonIds', id));

                                fetch('${pageContext.request.contextPath}/course', {
                                    method: 'POST',
                                    headers: {
                                        'Content-Type': 'application/x-www-form-urlencoded',
                                        'X-Requested-With': 'XMLHttpRequest'
                                    },
                                    body: params.toString()
                                })
                                        .then(response => response.json())
                                        .then(data => {
                                            if (!data.success) {
                                                console.error('Failed to update lesson order:', data.message);
                                            }
                                        })
                                        .catch(error => {
                                            console.error('Error updating lesson order:', error);
                                        });
                            }

                            function initializeModals() {
                                try {
                                    if (typeof bootstrap !== 'undefined') {
                                        console.log('Bootstrap is available');
                                    } else if (typeof $ !== 'undefined' && typeof $.fn.modal !== 'undefined') {
                                        console.log('jQuery Bootstrap modal is available');
                                    } else {
                                        console.warn('No Bootstrap modal library detected');
                                    }
                                } catch (error) {
                                    console.error('Error checking Bootstrap:', error);
                                }
                            }

                            function setupEventListeners() {
                                console.log('Event listeners set up');
                            }

                            function toggleAddContent() {
                                const section = document.getElementById('addContentSection');
                                if (section) {
                                    section.style.display = section.style.display === 'none' ? 'block' : 'none';
                                }
                            }

                            function addChapterToCourse(chapterId) {
                                if (!chapterId) {
                                    console.error('Chapter ID is required');
                                    return;
                                }

                                console.log('Looking for button for chapter:', chapterId);

                                // Find the button using onclick attribute
                                let addButton = document.querySelector('button[onclick="addChapterToCourse(' + chapterId + ')"]');

                                if (!addButton) {
                                    // Try with different quote styles
                                    addButton = document.querySelector('button[onclick*="addChapterToCourse(' + chapterId + ')"]');
                                }

                                if (!addButton) {
                                    console.error('Add button not found for chapter:', chapterId);
                                    console.log('Available buttons with onclick:', document.querySelectorAll('button[onclick*="addChapterToCourse"]'));
                                    return;
                                }

                                const originalText = addButton.innerHTML;
                                addButton.disabled = true;
                                addButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Adding...';

                                console.log('Adding chapter to course:', chapterId);

                                var params = new URLSearchParams();
                                params.append('action', 'addChapter');
                                params.append('courseId', '<c:out value="${courseId}"/>');
                                params.append('chapterId', chapterId);

                                fetch('<c:url value="/course"/>', {
                                    method: 'POST',
                                    headers: {
                                        'Content-Type': 'application/x-www-form-urlencoded',
                                        'X-Requested-With': 'XMLHttpRequest'
                                    },
                                    body: params.toString()
                                })
                                        .then(function (response) {
                                            console.log('Response status:', response.status);
                                            console.log('Response headers:', response.headers.get('content-type'));

                                            if (!response.ok) {
                                                throw new Error('Network response was not ok: ' + response.status);
                                            }

                                            var contentType = response.headers.get('content-type');
                                            if (!contentType || !contentType.includes('application/json')) {
                                                return response.text().then(function (text) {
                                                    console.error('Expected JSON but got:', text.substring(0, 500));
                                                    throw new Error('Server returned HTML instead of JSON');
                                                });
                                            }

                                            return response.json();
                                        })
                                        .then(function (data) {
                                            console.log('Response data:', data);

                                            addButton.disabled = false;

                                            if (data.success) {
                                                addButton.innerHTML = '<i class="fas fa-check"></i> Added!';
                                                addButton.classList.remove('btn-outline-primary');
                                                addButton.classList.add('btn-success');

                                                setTimeout(() => {
                                                    const listItem = addButton.closest('.list-group-item');
                                                    if (listItem) {
                                                        listItem.style.display = 'none';
                                                    }
                                                }, 1000);

                                                setTimeout(function () {
                                                    location.reload();
                                                }, 1500);
                                            } else {
                                                addButton.innerHTML = '<i class="fas fa-exclamation-triangle"></i> Error';
                                                addButton.classList.add('btn-danger');

                                                setTimeout(() => {
                                                    addButton.innerHTML = originalText;
                                                    addButton.classList.remove('btn-danger');
                                                    addButton.classList.add('btn-outline-primary');
                                                }, 2000);

                                                alert('Failed to add chapter: ' + (data.message || 'Unknown error'));
                                            }
                                        })
                                        .catch(function (error) {
                                            console.error('Error:', error);

                                            addButton.disabled = false;
                                            addButton.innerHTML = '<i class="fas fa-exclamation-triangle"></i> Error';
                                            addButton.classList.add('btn-danger');

                                            setTimeout(() => {
                                                addButton.innerHTML = originalText;
                                                addButton.classList.remove('btn-danger');
                                                addButton.classList.add('btn-outline-primary');
                                            }, 2000);

                                            alert('An error occurred while adding the chapter: ' + error.message);
                                        });
                            }

                            function showAddLessonModal(chapterId, chapterName) {
                                if (!chapterId || !chapterName) {
                                    console.error('Chapter ID and name are required');
                                    return;
                                }

                                currentChapterId = chapterId;
                                currentChapterName = chapterName;

                                const chapterInfo = document.getElementById('chapterInfo');
                                if (chapterInfo) {
                                    chapterInfo.innerHTML = '<strong>Adding lesson to chapter:</strong> ' + escapeHtml(chapterName);
                                }

                                const createLessonBtn = document.getElementById('createLessonBtn');
                                if (createLessonBtn) {
                                    createLessonBtn.href = '${pageContext.request.contextPath}/LessonURL?action=addForm&returnTo=course&courseId=${courseId}&chapterId=' + chapterId;
                                }

                                loadAvailableLessons(chapterId);
                                showModal('addLessonModal');
                            }

                            function showModal(modalId) {
                                const modalElement = document.getElementById(modalId);
                                if (!modalElement) {
                                    console.error('Modal element not found:', modalId);
                                    return;
                                }

                                try {
                                    if (typeof bootstrap !== 'undefined' &&
                                            typeof bootstrap.Modal !== 'undefined' &&
                                            typeof bootstrap.Modal.getInstance === 'function') {

                                        let modalInstance = bootstrap.Modal.getInstance(modalElement);
                                        if (!modalInstance) {
                                            modalInstance = new bootstrap.Modal(modalElement);
                                        }
                                        modalInstance.show();
                                        return;
                                    }

                                    if (typeof bootstrap !== 'undefined' && typeof bootstrap.Modal !== 'undefined') {
                                        const modalInstance = new bootstrap.Modal(modalElement);
                                        modalInstance.show();
                                        return;
                                    }

                                    if (typeof $ !== 'undefined' && typeof $.fn.modal !== 'undefined') {
                                        $(modalElement).modal('show');
                                        return;
                                    }

                                    modalElement.style.display = 'block';
                                    modalElement.classList.add('show');
                                    modalElement.setAttribute('aria-hidden', 'false');

                                    let backdrop = document.querySelector('.modal-backdrop');
                                    if (!backdrop) {
                                        backdrop = document.createElement('div');
                                        backdrop.className = 'modal-backdrop fade show';
                                        document.body.appendChild(backdrop);
                                    }

                                    document.body.classList.add('modal-open');
                                    console.log('Modal shown using manual fallback');

                                } catch (error) {
                                    console.error('Error showing modal:', error);
                                    modalElement.style.display = 'block';
                                }
                            }

                            function hideModal(modalId) {
                                const modalElement = document.getElementById(modalId);
                                if (!modalElement) {
                                    console.error('Modal element not found:', modalId);
                                    return;
                                }

                                try {
                                    if (typeof bootstrap !== 'undefined' &&
                                            typeof bootstrap.Modal !== 'undefined' &&
                                            typeof bootstrap.Modal.getInstance === 'function') {

                                        const modalInstance = bootstrap.Modal.getInstance(modalElement);
                                        if (modalInstance) {
                                            modalInstance.hide();
                                            return;
                                        }
                                    }

                                    if (typeof $ !== 'undefined' && typeof $.fn.modal !== 'undefined') {
                                        $(modalElement).modal('hide');
                                        return;
                                    }

                                    modalElement.style.display = 'none';
                                    modalElement.classList.remove('show');
                                    modalElement.setAttribute('aria-hidden', 'true');

                                    const backdrop = document.querySelector('.modal-backdrop');
                                    if (backdrop) {
                                        backdrop.remove();
                                    }

                                    document.body.classList.remove('modal-open');
                                    console.log('Modal hidden using manual fallback');

                                } catch (error) {
                                    console.error('Error hiding modal:', error);
                                    modalElement.style.display = 'none';
                                }
                            }

                            function loadAvailableLessons(chapterId) {
                                const container = document.getElementById('availableLessons');
                                if (!container) {
                                    console.error('Available lessons container not found');
                                    return;
                                }

                                container.innerHTML = '<div class="text-center"><div class="spinner-border" role="status"></div></div>';

                                fetch('${pageContext.request.contextPath}/course?action=getLessonsForCourse&chapterId=' + chapterId + '&courseId=${courseId}')
                                        .then(response => {
                                            if (!response.ok) {
                                                throw new Error('Network response was not ok');
                                            }
                                            return response.json();
                                        })
                                        .then(lessons => {
                                            if (lessons.length === 0) {
                                                container.innerHTML = '<p class="text-muted">No lessons available for this chapter. <a href="${pageContext.request.contextPath}/LessonURL?action=addForm&returnTo=course&courseId=${courseId}&chapterId=' + chapterId + '">Create one</a></p>';
                                            } else {
                                                let html = '<div class="list-group">';
                                                lessons.forEach((lesson, index) => {
                                                    const lessonName = escapeHtml(lesson.name || '');
                                                    const lessonContent = lesson.content ? escapeHtml(lesson.content.substring(0, 100)) + '...' : '';
                                                    const isAdded = lesson.isAdded;

                                                    html += '<div class="list-group-item d-flex justify-content-between align-items-center">';
                                                    html += '<div>';
                                                    html += '<strong>' + lessonName + '</strong>';
                                                    if (lessonContent) {
                                                        html += '<br><small class="text-muted">' + lessonContent + '</small>';
                                                    }
                                                    html += '</div>';

                                                    if (isAdded) {
                                                        html += '<span class="badge bg-success"><i class="fas fa-check"></i> Added</span>';
                                                    } else {
                                                        html += '<button class="btn btn-sm btn-outline-primary" ';
                                                        html += 'onclick="addLessonToCourse(' + lesson.id + ', ' + chapterId + ')" ';
                                                        html += 'data-lesson-id="' + lesson.id + '" data-chapter-id="' + chapterId + '">';
                                                        html += '<i class="fas fa-plus"></i> Add';
                                                        html += '</button>';
                                                    }
                                                    html += '</div>';
                                                });
                                                html += '</div>';
                                                container.innerHTML = html;

                                                console.log('Loaded lessons, buttons created:', container.querySelectorAll('button[onclick*="addLessonToCourse"]').length);
                                            }
                                        })
                                        .catch(error => {
                                            console.error('Error loading lessons:', error);
                                            container.innerHTML = '<p class="text-danger">Error loading lessons</p>';
                                        });
                            }

                            function addLessonToCourse(lessonId, chapterId) {
                                if (!lessonId || !chapterId) {
                                    console.error('Lesson ID and Chapter ID are required');
                                    return;
                                }

                                console.log('Looking for button for lesson:', lessonId, 'in chapter:', chapterId);

                                // Since the button is created dynamically, we need to find it differently
                                let addButton = null;

                                // First try to find by data attributes (if we set them)
                                addButton = document.querySelector(`button[data-lesson-id="${lessonId}"][data-chapter-id="${chapterId}"]`);

                                if (!addButton) {
                                    // Try to find by onclick attribute
                                    addButton = document.querySelector(`button[onclick*="addLessonToCourse(${lessonId}, ${chapterId})"]`);
                                }

                                if (!addButton) {
                                    // Try to find in the modal context
                                    const modal = document.getElementById('addLessonModal');
                                    if (modal) {
                                        addButton = modal.querySelector(`button[onclick*="addLessonToCourse(${lessonId}"]`);
                                    }
                                }

                                if (!addButton) {
                                    console.error('Add button not found for lesson:', lessonId);
                                    console.log('Available lesson buttons:', document.querySelectorAll('button[onclick*="addLessonToCourse"]'));
                                    console.log('Modal buttons:', document.querySelectorAll('#addLessonModal button'));
                                    return;
                                }

                                const originalText = addButton.innerHTML;
                                addButton.disabled = true;
                                addButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Adding...';

                                var params = new URLSearchParams();
                                params.append('action', 'addLesson');
                                params.append('courseId', '${courseId}');
                                params.append('lessonId', lessonId);
                                params.append('chapterId', chapterId);

                                fetch('${pageContext.request.contextPath}/course', {
                                    method: 'POST',
                                    headers: {
                                        'Content-Type': 'application/x-www-form-urlencoded',
                                        'X-Requested-With': 'XMLHttpRequest'
                                    },
                                    body: params.toString()
                                })
                                        .then(function (response) {
                                            if (!response.ok) {
                                                throw new Error('Network response was not ok: ' + response.status);
                                            }

                                            var contentType = response.headers.get('content-type');
                                            if (!contentType || !contentType.includes('application/json')) {
                                                return response.text().then(function (text) {
                                                    console.error('Expected JSON but got:', text.substring(0, 500));
                                                    throw new Error('Server returned HTML instead of JSON');
                                                });
                                            }

                                            return response.json();
                                        })
                                        .then(function (data) {
                                            console.log('Add lesson response:', data);

                                            if (data.success) {
                                                addButton.innerHTML = '<i class="fas fa-check"></i> Added!';
                                                addButton.classList.remove('btn-outline-primary');
                                                addButton.classList.add('btn-success');

                                                setTimeout(() => {
                                                    addButton.outerHTML = '<span class="badge bg-success"><i class="fas fa-check"></i> Added</span>';
                                                }, 1000);

                                                setTimeout(function () {
                                                    hideModal('addLessonModal');
                                                    location.reload();
                                                }, 1500);
                                            } else {
                                                addButton.disabled = false;
                                                addButton.innerHTML = '<i class="fas fa-exclamation-triangle"></i> Error';
                                                addButton.classList.add('btn-danger');

                                                setTimeout(() => {
                                                    addButton.innerHTML = originalText;
                                                    addButton.classList.remove('btn-danger');
                                                    addButton.classList.add('btn-outline-primary');
                                                }, 2000);

                                                alert('Failed to add lesson: ' + (data.message || 'Unknown error'));
                                            }
                                        })
                                        .catch(function (error) {
                                            console.error('Error adding lesson:', error);

                                            addButton.disabled = false;
                                            addButton.innerHTML = '<i class="fas fa-exclamation-triangle"></i> Error';
                                            addButton.classList.add('btn-danger');

                                            setTimeout(() => {
                                                addButton.innerHTML = originalText;
                                                addButton.classList.remove('btn-danger');
                                                addButton.classList.add('btn-outline-primary');
                                            }, 2000);

                                            alert('An error occurred while adding the lesson: ' + error.message);
                                        });
                            }

                            function removeFromCourse(type, id) {
                                if (!type || !id) {
                                    console.error('Type and ID are required');
                                    return;
                                }

                                if (!confirm('Are you sure you want to remove this ' + type + ' from the course?')) {
                                    return;
                                }

                                var removeButtons = document.querySelectorAll('button[onclick*="removeFromCourse(\'' + type + '\', ' + id + ')"]');
                                const originalContent = [];

                                for (var i = 0; i < removeButtons.length; i++) {
                                    originalContent[i] = removeButtons[i].innerHTML;
                                    removeButtons[i].disabled = true;
                                    removeButtons[i].innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
                                }

                                var actionMap = {
                                    'chapter': 'removeChapter',
                                    'lesson': 'removeLesson',
                                    'test': 'removeTest'
                                };

                                var paramMap = {
                                    'chapter': 'chapterId',
                                    'lesson': 'lessonId',
                                    'test': 'testId'
                                };

                                if (!actionMap[type] || !paramMap[type]) {
                                    console.error('Invalid type:', type);
                                    for (var i = 0; i < removeButtons.length; i++) {
                                        removeButtons[i].disabled = false;
                                        removeButtons[i].innerHTML = originalContent[i];
                                    }
                                    return;
                                }

                                var params = new URLSearchParams();
                                params.append('action', actionMap[type]);
                                params.append('courseId', '${courseId}');
                                params.append(paramMap[type], id);

                                fetch('${pageContext.request.contextPath}/course', {
                                    method: 'POST',
                                    headers: {
                                        'Content-Type': 'application/x-www-form-urlencoded',
                                        'X-Requested-With': 'XMLHttpRequest'
                                    },
                                    body: params.toString()
                                })
                                        .then(function (response) {
                                            if (!response.ok) {
                                                throw new Error('Network response was not ok: ' + response.status);
                                            }

                                            var contentType = response.headers.get('content-type');
                                            if (!contentType || !contentType.includes('application/json')) {
                                                return response.text().then(function (text) {
                                                    console.error('Expected JSON but got:', text.substring(0, 500));
                                                    throw new Error('Server returned HTML instead of JSON');
                                                });
                                            }

                                            return response.json();
                                        })
                                        .then(function (data) {
                                            console.log('Remove ' + type + ' response:', data);

                                            if (data.success) {
                                                for (var i = 0; i < removeButtons.length; i++) {
                                                    removeButtons[i].innerHTML = '<i class="fas fa-check"></i>';
                                                    removeButtons[i].classList.add('btn-success');
                                                }

                                                const itemElement = document.querySelector(`[data-id="${id}"][data-type="${type}"]`);
                                                if (itemElement) {
                                                    itemElement.style.transition = 'opacity 0.5s ease';
                                                    itemElement.style.opacity = '0.5';
                                                }

                                                setTimeout(function () {
                                                    location.reload();
                                                }, 1000);
                                            } else {
                                                for (var i = 0; i < removeButtons.length; i++) {
                                                    removeButtons[i].disabled = false;
                                                    removeButtons[i].innerHTML = originalContent[i];
                                                }
                                                alert('Failed to remove ' + type + ': ' + (data.message || 'Unknown error'));
                                            }
                                        })
                                        .catch(function (error) {
                                            console.error('Error removing ' + type + ':', error);

                                            for (var i = 0; i < removeButtons.length; i++) {
                                                removeButtons[i].disabled = false;
                                                removeButtons[i].innerHTML = originalContent[i];
                                            }

                                            alert('An error occurred while removing the ' + type + ': ' + error.message);
                                        });
                            }

                            function updateContentOrder(container) {
                                if (!container) {
                                    console.error('Container is required');
                                    return;
                                }

                                const items = container.querySelectorAll('.content-item');
                                const contentIds = Array.from(items).map(item => item.dataset.id).filter(id => id);
                                const contentType = items.length > 0 ? items[0].dataset.type : '';

                                if (contentIds.length === 0 || !contentType) {
                                    console.log('No content to reorder');
                                    return;
                                }

                                const params = new URLSearchParams();
                                params.append('action', 'reorderContent');
                                params.append('courseId', '${courseId}');
                                params.append('contentType', contentType);
                                contentIds.forEach(id => params.append('contentIds', id));

                                fetch('${pageContext.request.contextPath}/course', {
                                    method: 'POST',
                                    headers: {
                                        'Content-Type': 'application/x-www-form-urlencoded',
                                        'X-Requested-With': 'XMLHttpRequest'
                                    },
                                    body: params.toString()
                                })
                                        .then(response => {
                                            if (!response.ok) {
                                                throw new Error('Network response was not ok');
                                            }

                                            const contentType = response.headers.get('content-type');
                                            if (contentType && contentType.includes('application/json')) {
                                                return response.json();
                                            } else {
                                                return {success: true};
                                            }
                                        })
                                        .then(data => {
                                            if (!data.success) {
                                                console.error('Failed to update order:', data.message);
                                            }
                                        })
                                        .catch(error => {
                                            console.error('Error updating order:', error);
                                        });
                            }

                            function submitForApproval() {
                                var approvalStatus = '${courseDetails.approval_status}';

                                if (approvalStatus === 'DRAFT') {
                                    if (!confirm('Are you sure you want to submit this course for approval? You will not be able to edit it while it is pending approval.')) {
                                        return;
                                    }
                                    window.location.href = '${pageContext.request.contextPath}/course?action=submit&id=${courseId}';
                                            } else {
                                                console.error('submitForApproval called with invalid status:', approvalStatus);
                                                alert('Invalid operation. Please refresh the page and try again.');
                                            }
                                        }

                                        function previewCourse() {
                                            window.open('${pageContext.request.contextPath}/course?action=detail&id=${courseId}', '_blank');
                                                }

                                                function saveDraft() {
                                                    const params = new URLSearchParams();
                                                    params.append('action', 'saveDraft');
                                                    params.append('courseId', '${courseId}');

                                                    const saveButtons = document.querySelectorAll('button[onclick*="saveDraft"]');
                                                    const originalTexts = [];

                                                    saveButtons.forEach((btn, index) => {
                                                        originalTexts[index] = btn.innerHTML;
                                                        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Saving...';
                                                        btn.disabled = true;
                                                    });

                                                    fetch('${pageContext.request.contextPath}/course', {
                                                        method: 'POST',
                                                        headers: {
                                                            'Content-Type': 'application/x-www-form-urlencoded',
                                                            'X-Requested-With': 'XMLHttpRequest'
                                                        },
                                                        body: params.toString()
                                                    })
                                                            .then(response => {
                                                                if (!response.ok) {
                                                                    throw new Error('Network response was not ok');
                                                                }

                                                                const contentType = response.headers.get('content-type');
                                                                if (!contentType || !contentType.includes('application/json')) {
                                                                    return response.text().then(text => {
                                                                        console.error('Expected JSON but got:', text.substring(0, 500));
                                                                        throw new Error('Server returned HTML instead of JSON');
                                                                    });
                                                                }

                                                                return response.json();
                                                            })
                                                            .then(data => {
                                                                if (data.success) {
                                                                    saveButtons.forEach((btn, index) => {
                                                                        btn.innerHTML = '<i class="fas fa-check"></i> Saved!';
                                                                        btn.classList.remove('btn-success');
                                                                        btn.classList.add('btn-outline-success');
                                                                        btn.disabled = false;

                                                                        setTimeout(() => {
                                                                            btn.innerHTML = originalTexts[index];
                                                                            btn.classList.remove('btn-outline-success');
                                                                            btn.classList.add('btn-success');
                                                                        }, 2000);
                                                                    });
                                                                } else {
                                                                    saveButtons.forEach((btn, index) => {
                                                                        btn.innerHTML = originalTexts[index];
                                                                        btn.disabled = false;
                                                                    });
                                                                    alert('Failed to save draft: ' + (data.message || 'Unknown error'));
                                                                }
                                                            })
                                                            .catch(error => {
                                                                console.error('Error:', error);

                                                                saveButtons.forEach((btn, index) => {
                                                                    btn.innerHTML = originalTexts[index];
                                                                    btn.disabled = false;
                                                                });
                                                                alert('An error occurred while saving the draft: ' + error.message);
                                                            });
                                                }

                                                // Utility function to escape HTML
                                                function escapeHtml(text) {
                                                    if (!text)
                                                        return '';
                                                    const div = document.createElement('div');
                                                    div.textContent = text;
                                                    return div.innerHTML;
                                                }

                                                // Auto-save every 5 minutes
                                                setInterval(function () {
                                                    const courseContent = document.getElementById('courseContent');
                                                    if (courseContent && courseContent.children.length > 0) {
                                                        console.log('Auto-saving draft...');
                                                        saveDraft();
                                                    }
                                                }, 300000); // 5 minutes

                                                // Close modal when clicking outside or on close button
                                                document.addEventListener('click', function (event) {
                                                    if (event.target.classList.contains('modal') ||
                                                            event.target.classList.contains('modal-backdrop') ||
                                                            event.target.classList.contains('btn-close') ||
                                                            event.target.getAttribute('data-bs-dismiss') === 'modal') {

                                                        const openModals = document.querySelectorAll('.modal.show');
                                                        openModals.forEach(modal => {
                                                            hideModal(modal.id);
                                                        });
                                                    }
                                                });

                                                // Handle escape key to close modals
                                                document.addEventListener('keydown', function (event) {
                                                    if (event.key === 'Escape') {
                                                        const openModals = document.querySelectorAll('.modal.show');
                                                        openModals.forEach(modal => {
                                                            hideModal(modal.id);
                                                        });
                                                    }
                                                });

                                                // Debug function to check what buttons are available
                                                function debugButtons() {
                                                    console.log('=== DEBUG INFO ===');
                                                    console.log('Chapter buttons with onclick:', document.querySelectorAll('button[onclick*="addChapterToCourse"]'));
                                                    console.log('Lesson buttons with onclick:', document.querySelectorAll('button[onclick*="addLessonToCourse"]'));
                                                    console.log('All buttons with onclick:', document.querySelectorAll('button[onclick]'));

                                                    // Log all chapter buttons with their data
                                                    document.querySelectorAll('button[onclick*="addChapterToCourse"]').forEach((btn, index) => {
                                                        console.log(`Chapter button ${index}:`, {
                                                            element: btn,
                                                            onclick: btn.getAttribute('onclick'),
                                                            text: btn.textContent
                                                        });
                                                    });

                                                    // Log lesson buttons in modal
                                                    const modal = document.getElementById('addLessonModal');
                                                    if (modal) {
                                                        console.log('Lesson buttons in modal:', modal.querySelectorAll('button[onclick*="addLessonToCourse"]'));
                                                    }
                                                }


                                                // Call debug function after DOM is ready
                                                document.addEventListener('DOMContentLoaded', function () {
                                                    setTimeout(debugButtons, 1000); // Wait 1 second then debug
                                                });

                                                function showTestModal() {
                                                    // Load available tests
                                                    fetch('${pageContext.request.contextPath}/course?action=getAvailableTests&courseId=${courseId}')
                                                                    .then(response => {
                                                                        if (!response.ok) {
                                                                            throw new Error('Network response was not ok');
                                                                        }
                                                                        return response.json();
                                                                    })
                                                                    .then(tests => {
                                                                        console.log('Tests loaded:', tests); // Debug log
                                                                        displayAvailableTests(tests);
                                                                        showModal('browseTestModal');
                                                                    })
                                                                    .catch(error => {
                                                                        console.error('Error loading tests:', error);
                                                                        alert('Failed to load available tests: ' + error.message);
                                                                    });
                                                        }

                                                        function displayAvailableTests(tests) {
                                                            console.log('displayAvailableTests called with:', tests);

                                                            const container = document.getElementById('availableTestsList');
                                                            if (!container) {
                                                                console.error('availableTestsList container not found');
                                                                return;
                                                            }

                                                            container.innerHTML = '';

                                                            if (!tests || tests.length === 0) {
                                                                container.innerHTML = '<p class="text-muted">No tests available</p>';
                                                                return;
                                                            }

                                                            tests.forEach(test => {
                                                                console.log('Processing test:', test);

                                                                const testDiv = document.createElement('div');
                                                                testDiv.className = 'list-group-item d-flex justify-content-between align-items-center';

                                                                // Create test info section
                                                                const testInfo = document.createElement('div');

                                                                // Test name
                                                                const testName = document.createElement('strong');
                                                                testName.textContent = test.name || 'Unnamed Test';
                                                                testInfo.appendChild(testName);

                                                                // Line break
                                                                testInfo.appendChild(document.createElement('br'));

                                                                // Test description
                                                                if (test.description && test.description.trim() !== '') {
                                                                    const testDesc = document.createElement('small');
                                                                    testDesc.className = 'text-muted';
                                                                    testDesc.textContent = test.description;
                                                                    testInfo.appendChild(testDesc);
                                                                    testInfo.appendChild(document.createElement('br'));
                                                                }

                                                                // Test details with proper values
                                                                const testDetails = document.createElement('small');
                                                                testDetails.className = 'text-info';

                                                                // Extract values with proper fallbacks
                                                                const testType = test.is_practice ? 'Practice' : 'Official';
                                                                const duration = test.duration_minutes || 30;
                                                                const totalQuestions = test.total_questions || test.num_questions || 0;
                                                                const createdBy = test.created_by_name || 'Unknown';

                                                                console.log('Test details:', {
                                                                    testType,
                                                                    duration,
                                                                    totalQuestions,
                                                                    createdBy,
                                                                    raw_test: test
                                                                });

                                                                // Use string concatenation instead of template literal in textContent
                                                                testDetails.textContent = testType + ' | ' + duration + ' min | ' + totalQuestions + ' questions | by ' + createdBy;
                                                                testInfo.appendChild(testDetails);

                                                                // Create action section
                                                                const actionDiv = document.createElement('div');
                                                                if (test.is_in_course) {
                                                                    const badge = document.createElement('span');
                                                                    badge.className = 'badge bg-success';
                                                                    badge.innerHTML = '<i class="fas fa-check"></i> Added';
                                                                    actionDiv.appendChild(badge);
                                                                } else {
                                                                    const addBtn = document.createElement('button');
                                                                    addBtn.className = 'btn btn-sm btn-outline-primary';
                                                                    addBtn.innerHTML = '<i class="fas fa-plus"></i> Add';
                                                                    addBtn.onclick = () => addTestToCourse(test.id, test.name);
                                                                    actionDiv.appendChild(addBtn);
                                                                }

                                                                testDiv.appendChild(testInfo);
                                                                testDiv.appendChild(actionDiv);
                                                                container.appendChild(testDiv);
                                                            });
                                                        }

                                                        function addTestToCourse(testId, testName) {
                                                            const params = new URLSearchParams();
                                                            params.append('action', 'addToCourse');
                                                            params.append('courseId', '${courseId}');
                                                            params.append('testId', testId);

                                                            fetch('${pageContext.request.contextPath}/test', {
                                                                method: 'POST',
                                                                headers: {
                                                                    'Content-Type': 'application/x-www-form-urlencoded',
                                                                    'X-Requested-With': 'XMLHttpRequest'
                                                                },
                                                                body: params.toString()
                                                            })
                                                                    .then(response => response.json())
                                                                    .then(data => {
                                                                        if (data.success) {
                                                                            hideModal('browseTestModal');
                                                                            location.reload();
                                                                        } else {
                                                                            alert('Failed to add test: ' + data.message);
                                                                        }
                                                                    })
                                                                    .catch(error => {
                                                                        console.error('Error:', error);
                                                                        alert('An error occurred while adding the test');
                                                                    });
                                                        }

                                                        function reorderTests() {
                                                            const testItems = document.querySelectorAll('#testsList .content-item[data-type="test"]');
                                                            const testIds = Array.from(testItems).map(item => item.dataset.id).filter(id => id);

                                                            if (testIds.length === 0) {
                                                                return;
                                                            }

                                                            // Use URLSearchParams for easier parameter handling
                                                            const params = new URLSearchParams();
                                                            params.append('action', 'reorderTests');
                                                            params.append('courseId', '${courseId}');
                                                            testIds.forEach(id => params.append('testIds[]', id)); // Use [] to indicate an array

                                                            fetch('${pageContext.request.contextPath}/course', {
                                                                method: 'POST',
                                                                headers: {
                                                                    'Content-Type': 'application/x-www-form-urlencoded',
                                                                    'X-Requested-With': 'XMLHttpRequest'
                                                                },
                                                                body: params.toString()
                                                            })
                                                                    .then(response => response.json())
                                                                    .then(data => {
                                                                        if (data.success) {
                                                                            console.log('Tests reordered successfully.');
                                                                            // Optionally show a success toast/message
                                                                        } else {
                                                                            console.error('Failed to reorder tests:', data.message);
                                                                            alert('Error: Could not reorder tests.');
                                                                        }
                                                                    })
                                                                    .catch(error => {
                                                                        console.error('Error reordering tests:', error);
                                                                        alert('A network error occurred while reordering tests.');
                                                                    });
                                                        }

                                                        function editTest(testId) {
                                                            window.open('${pageContext.request.contextPath}/test?action=edit&id=' + testId, '_blank');
                                                        }

                                                        function showTestPositionModal(testId, testName, currentLevel, currentChapterId, currentLessonId) {
                                                            currentTestId = testId;
                                                            currentTestName = testName;

                                                            document.getElementById('testPositionInfo').innerHTML =
                                                                    '<strong>Moving test:</strong> ' + testName + '<br>' +
                                                                    '<strong>Current position:</strong> ' + currentLevel + ' level';

                                                            // Set current position
                                                            document.querySelector(`input[name="positionLevel"][value="${currentLevel}"]`).checked = true;

                                                            if (currentChapterId) {
                                                                document.getElementById('chapterSelect').value = currentChapterId;
                                                            }

                                                            updatePositionOptions();

                                                            if (currentLessonId) {
                                                                updateLessonOptions().then(() => {
                                                                    document.getElementById('lessonSelect').value = currentLessonId;
                                                                });
                                                            }

                                                            showModal('testPositionModal');
                                                        }

                                                        function updatePositionOptions() {
                                                            const level = document.querySelector('input[name="positionLevel"]:checked').value;
                                                            const chapterSelection = document.getElementById('chapterSelection');
                                                            const lessonSelection = document.getElementById('lessonSelection');

                                                            if (level === 'course') {
                                                                chapterSelection.style.display = 'none';
                                                                lessonSelection.style.display = 'none';
                                                            } else if (level === 'chapter') {
                                                                chapterSelection.style.display = 'block';
                                                                lessonSelection.style.display = 'none';
                                                            } else if (level === 'lesson') {
                                                                chapterSelection.style.display = 'block';
                                                                lessonSelection.style.display = 'block';
                                                            }
                                                        }

                                                        function updateLessonOptions() {
                                                            return new Promise((resolve) => {
                                                                const chapterId = document.getElementById('chapterSelect').value;
                                                                const lessonSelect = document.getElementById('lessonSelect');

                                                                if (!chapterId) {
                                                                    lessonSelect.innerHTML = '<option value="">-- Select Chapter First --</option>';
                                                                    resolve();
                                                                    return;
                                                                }

                                                                lessonSelect.innerHTML = '<option value="">-- Loading lessons... --</option>';

                                                                fetch('${pageContext.request.contextPath}/course?action=getLessonsForCourse&chapterId=' + chapterId + '&courseId=${courseId}')
                                                                        .then(response => response.json())
                                                                        .then(lessons => {
                                                                            lessonSelect.innerHTML = '<option value="">-- Select Lesson --</option>';
                                                                            lessons.forEach(lesson => {
                                                                                if (!lesson.isAdded)
                                                                                    return; // Only show lessons that are in the course
                                                                                const option = document.createElement('option');
                                                                                option.value = lesson.id;
                                                                                option.textContent = lesson.name;
                                                                                lessonSelect.appendChild(option);
                                                                            });
                                                                            resolve();
                                                                        })
                                                                        .catch(error => {
                                                                            console.error('Error loading lessons:', error);
                                                                            lessonSelect.innerHTML = '<option value="">-- Error loading lessons --</option>';
                                                                            resolve();
                                                                        });
                                                            });
                                                        }

                                                        function updateTestPosition() {
                                                            if (!currentTestId) {
                                                                alert('No test selected');
                                                                return;
                                                            }

                                                            const level = document.querySelector('input[name="positionLevel"]:checked').value;
                                                            let chapterId = null;
                                                            let lessonId = null;

                                                            if (level === 'chapter' || level === 'lesson') {
                                                                chapterId = document.getElementById('chapterSelect').value;
                                                                if (!chapterId) {
                                                                    alert('Please select a chapter');
                                                                    return;
                                                                }
                                                            }

                                                            if (level === 'lesson') {
                                                                lessonId = document.getElementById('lessonSelect').value;
                                                                if (!lessonId) {
                                                                    alert('Please select a lesson');
                                                                    return;
                                                                }
                                                            }

                                                            const params = new URLSearchParams();
                                                            params.append('action', 'updateTestPosition');
                                                            params.append('courseId', '${courseId}');
                                                            params.append('testId', currentTestId);
                                                            params.append('displayOrder', 1); // Will be recalculated on server

                                                            if (chapterId) {
                                                                params.append('chapterId', chapterId);
                                                            }
                                                            if (lessonId) {
                                                                params.append('lessonId', lessonId);
                                                            }

                                                            fetch('${pageContext.request.contextPath}/course', {
                                                                method: 'POST',
                                                                headers: {
                                                                    'Content-Type': 'application/x-www-form-urlencoded',
                                                                    'X-Requested-With': 'XMLHttpRequest'
                                                                },
                                                                body: params.toString()
                                                            })
                                                                    .then(response => response.json())
                                                                    .then(data => {
                                                                        if (data.success) {
                                                                            hideModal('testPositionModal');
                                                                            location.reload();
                                                                        } else {
                                                                            alert('Failed to move test: ' + data.message);
                                                                        }
                                                                    })
                                                                    .catch(error => {
                                                                        console.error('Error:', error);
                                                                        alert('An error occurred while moving the test');
                                                                    });
                                                        }

                                                        function resubmitForApproval() {
                                                            if (!confirm('Are you sure you want to resubmit this course for approval? This will reset the approval status and you will not be able to edit until admin reviews again.')) {
                                                                return;
                                                            }

                                                            const params = new URLSearchParams();
                                                            params.append('action', 'resubmit');
                                                            params.append('courseId', '${courseId}');

                                                            const resubmitButtons = document.querySelectorAll('button[onclick*="resubmitForApproval"]');
                                                            const originalTexts = [];

                                                            resubmitButtons.forEach((btn, index) => {
                                                                originalTexts[index] = btn.innerHTML;
                                                                btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Resubmitting...';
                                                                btn.disabled = true;
                                                            });

                                                            fetch('${pageContext.request.contextPath}/course', {
                                                                method: 'POST',
                                                                headers: {
                                                                    'Content-Type': 'application/x-www-form-urlencoded',
                                                                    'X-Requested-With': 'XMLHttpRequest'
                                                                },
                                                                body: params.toString()
                                                            })
                                                                    .then(response => {
                                                                        if (!response.ok) {
                                                                            throw new Error('Network response was not ok');
                                                                        }

                                                                        const contentType = response.headers.get('content-type');
                                                                        if (!contentType || !contentType.includes('application/json')) {
                                                                            return response.text().then(text => {
                                                                                console.error('Expected JSON but got:', text.substring(0, 500));
                                                                                throw new Error('Server returned HTML instead of JSON');
                                                                            });
                                                                        }

                                                                        return response.json();
                                                                    })
                                                                    .then(data => {
                                                                        if (data.success) {
                                                                            resubmitButtons.forEach((btn, index) => {
                                                                                btn.innerHTML = '<i class="fas fa-check"></i> Resubmitted!';
                                                                                btn.classList.remove('btn-warning');
                                                                                btn.classList.add('btn-success');
                                                                            });

                                                                            setTimeout(function () {
                                                                                window.location.href = '${pageContext.request.contextPath}/course';
                                                                            }, 2000);
                                                                        } else {
                                                                            resubmitButtons.forEach((btn, index) => {
                                                                                btn.innerHTML = originalTexts[index];
                                                                                btn.disabled = false;
                                                                            });
                                                                            alert('Failed to resubmit course: ' + (data.message || 'Unknown error'));
                                                                        }
                                                                    })
                                                                    .catch(error => {
                                                                        console.error('Error:', error);

                                                                        resubmitButtons.forEach((btn, index) => {
                                                                            btn.innerHTML = originalTexts[index];
                                                                            btn.disabled = false;
                                                                        });
                                                                        alert('An error occurred while resubmitting the course: ' + error.message);
                                                                    });
                                                        }
                                                        function resubmitAfterReject() {
                                                            if (!confirm('Are you sure you want to resubmit this course for approval? The rejection reason will be cleared and the course will be pending approval again.')) {
                                                                return;
                                                            }

                                                            // Redirect to controller with specific action for resubmit after reject
                                                            window.location.href = '${pageContext.request.contextPath}/course?action=resubmitAfterReject&id=${courseId}';
                                                                }

                                                                // Update sidebar lesson links to preserve return navigation
                                                                function updateLessonLinksForReturn() {
                                                                    if (window.location.search.includes('returnTo=buildCourse')) {
                                                                        const lessonLinks = document.querySelectorAll('.lesson-item[href*="video-viewer"]');
                                                                        lessonLinks.forEach(link => {
                                                                            const href = link.getAttribute('href');
                                                                            if (href && !href.includes('returnTo=buildCourse')) {
                                                                                const separator = href.includes('?') ? '&' : '?';
                                                                                link.setAttribute('href', href + separator + 'returnTo=buildCourse');
                                                                            }
                                                                        });
                                                                    }
                                                                }

                                                                // Call on page load
                                                                document.addEventListener('DOMContentLoaded', updateLessonLinksForReturn);
        </script>
        <!-- Browse Tests Modal -->
        <div class="modal fade" id="browseTestModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Browse Available Tests</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="alert alert-info">
                            <i class="fas fa-info-circle"></i>
                            Select tests to add to your course. Tests already in the course are marked as "Added".
                        </div>
                        <div id="availableTestsList" class="list-group">
                            <div class="text-center">
                                <div class="spinner-border" role="status">
                                    <span class="visually-hidden">Loading...</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <a href="${pageContext.request.contextPath}/test?action=createForCourse&courseId=${courseId}" 
                           class="btn btn-success">
                            <i class="fas fa-plus"></i> Create New Test
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Test Position Modal -->
        <div class="modal fade" id="testPositionModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Move Test Position</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div id="testPositionInfo" class="alert alert-info"></div>

                        <div class="form-group">
                            <label>Position Level:</label>
                            <div>
                                <label class="radio-option">
                                    <input type="radio" name="positionLevel" value="course" onchange="updatePositionOptions()">
                                    <i class="fas fa-graduation-cap"></i> Course Level
                                </label>
                                <label class="radio-option">
                                    <input type="radio" name="positionLevel" value="chapter" onchange="updatePositionOptions()">
                                    <i class="fas fa-bookmark"></i> Chapter Level
                                </label>
                                <label class="radio-option">
                                    <input type="radio" name="positionLevel" value="lesson" onchange="updatePositionOptions()">
                                    <i class="fas fa-play"></i> Lesson Level
                                </label>
                            </div>
                        </div>

                        <div id="chapterSelection" class="form-group" style="display: none;">
                            <label>Select Chapter:</label>
                            <select id="chapterSelect" class="form-control" onchange="updateLessonOptions()">
                                <option value="">-- Select Chapter --</option>
                                <c:forEach items="${courseChapters}" var="chapter">
                                    <option value="${chapter.chapter_id}">${chapter.chapter_name}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div id="lessonSelection" class="form-group" style="display: none;">
                            <label>Select Lesson:</label>
                            <select id="lessonSelect" class="form-control">
                                <option value="">-- Select Lesson --</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-primary" onclick="updateTestPosition()">Move Test</button>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>