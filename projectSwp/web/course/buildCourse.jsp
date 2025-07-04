<%-- 
    Document   : buildCourse
    Created on : Jul 3, 2025, 2:34:20 PM
    Author     : ankha
--%>

<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Build Course - ${courseDetails.course_title}</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">

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
        </style>
    </head>
    <body>
        <%@include file="../header.jsp" %>

        <div class="build-container">
            <!-- Course Header -->
            <div class="course-header">
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
                        <a href="${pageContext.request.contextPath}/test?action=create&returnTo=course&courseId=${courseId}" 
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
                                        <c:forEach items="${availableChapters}" var="chapter">
                                            <div class="list-group-item d-flex justify-content-between align-items-center">
                                                <div>
                                                    <strong>${chapter.name}</strong>
                                                    <c:if test="${not empty chapter.description}">
                                                        <br><small class="text-muted">${chapter.description}</small>
                                                    </c:if>
                                                </div>
                                                <button class="btn btn-sm btn-outline-primary" 
                                                        onclick="addChapterToCourse(${chapter.id})">
                                                    <i class="fas fa-plus"></i> Add
                                                </button>
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
                                                            onclick="showAddLessonModal(${chapter.chapter_id}, '${chapter.chapter_name}')">
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
                                                <c:forEach items="${courseLessons}" var="lesson">
                                                    <c:if test="${lesson.chapter_id == chapter.chapter_id}">
                                                        <div class="content-item lesson-item" data-id="${lesson.lesson_id}" data-type="lesson">
                                                            <div class="content-item-header">
                                                                <div>
                                                                    <span class="content-type-badge badge-lesson">Lesson</span>
                                                                    <strong>${lesson.lesson_name}</strong>
                                                                </div>
                                                                <div>
                                                                    <button class="btn btn-sm btn-outline-danger" 
                                                                            onclick="removeFromCourse('lesson', ${lesson.lesson_id})">
                                                                        <i class="fas fa-trash"></i>
                                                                    </button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </c:if>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:if>

                            <!-- Tests -->
                            <c:if test="${not empty courseTests}">
                                <h5><i class="fas fa-clipboard-check"></i> Tests (${courseTests.size()})</h5>
                                <div id="testsList" class="sortable-list">
                                    <c:forEach items="${courseTests}" var="test">
                                        <div class="content-item" data-id="${test.test_id}" data-type="test">
                                            <div class="content-item-header">
                                                <div>
                                                    <span class="content-type-badge badge-test">${test.test_type} Test</span>
                                                    <strong>${test.test_name}</strong>
                                                    <c:if test="${not empty test.chapter_name}">
                                                        <small class="text-muted">(${test.chapter_name})</small>
                                                    </c:if>
                                                </div>
                                                <div>
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
                                    <c:when test="${courseDetails.approval_status == 'PENDING_APPROVAL'}">Pending Approval</c:when>
                                    <c:when test="${courseDetails.approval_status == 'APPROVED'}">Course Approved</c:when>
                                    <c:when test="${courseDetails.approval_status == 'REJECTED'}">Course Rejected</c:when>
                                </c:choose>
                            </h5>
                            <p class="mb-0">
                                <c:choose>
                                    <c:when test="${courseDetails.approval_status == 'DRAFT'}">
                                        Submit your course for admin approval to make it available to students.
                                    </c:when>
                                    <c:when test="${courseDetails.approval_status == 'PENDING_APPROVAL'}">
                                        Your course is waiting for admin approval. You cannot edit while pending.
                                    </c:when>
                                    <c:when test="${courseDetails.approval_status == 'APPROVED'}">
                                        Your course has been approved and is available to students!
                                    </c:when>
                                    <c:when test="${courseDetails.approval_status == 'REJECTED'}">
                                        Your course was rejected. Reason: ${courseDetails.rejection_reason}
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
                                    <button class="btn btn-warning btn-lg" onclick="submitForApproval()">
                                        <i class="fas fa-paper-plane"></i> Resubmit for Approval
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
        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>

        <script>
                            let currentChapterId = null;
                            let currentChapterName = '';

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
                                                onEnd: function (evt) {
                                                    updateContentOrder(evt.from);
                                                }
                                            });
                                        }
                                    });
                                } catch (error) {
                                    console.error('Error initializing sortable:', error);
                                }
                            }

                            function initializeModals() {
                                try {
                                    // Check Bootstrap version and availability
                                    if (typeof bootstrap !== 'undefined') {
                                        console.log('Bootstrap is available');

                                        // Check if Modal.getInstance exists
                                        if (typeof bootstrap.Modal !== 'undefined' && typeof bootstrap.Modal.getInstance === 'function') {
                                            console.log('Bootstrap Modal.getInstance is available');
                                        } else {
                                            console.log('Bootstrap Modal.getInstance not available, using fallback');
                                        }
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
                                // Set up any additional event listeners here
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

                                console.log('Adding chapter to course:', chapterId);

                                // Use URLSearchParams for proper form encoding
                                const params = new URLSearchParams();
                                params.append('action', 'addChapter');
                                params.append('courseId', '${courseId}');
                                params.append('chapterId', chapterId);

                                fetch('${pageContext.request.contextPath}/course', {
                                    method: 'POST',
                                    headers: {
                                        'Content-Type': 'application/x-www-form-urlencoded',
                                        'X-Requested-With': 'XMLHttpRequest'
                                    },
                                    body: params.toString()
                                })
                                        .then(response => {
                                            console.log('Response status:', response.status);
                                            console.log('Response headers:', response.headers.get('content-type'));

                                            if (!response.ok) {
                                                throw new Error('Network response was not ok: ' + response.status);
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
                                            console.log('Response data:', data);
                                            if (data.success) {
                                                location.reload();
                                            } else {
                                                alert('Failed to add chapter: ' + (data.message || 'Unknown error'));
                                            }
                                        })
                                        .catch(error => {
                                            console.error('Error:', error);
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

                                // Update create lesson button URL
                                const createLessonBtn = document.getElementById('createLessonBtn');
                                if (createLessonBtn) {
                                    createLessonBtn.href = '${pageContext.request.contextPath}/LessonURL?action=addForm&returnTo=course&courseId=${courseId}&chapterId=' + chapterId;
                                }

                                // Load available lessons for this chapter
                                loadAvailableLessons(chapterId);

                                // Show modal with multiple fallback methods
                                showModal('addLessonModal');
                            }

                            // Universal modal show function with fallbacks
                            function showModal(modalId) {
                                const modalElement = document.getElementById(modalId);
                                if (!modalElement) {
                                    console.error('Modal element not found:', modalId);
                                    return;
                                }

                                try {
                                    // Method 1: Bootstrap 5 with getInstance
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

                                    // Method 2: Bootstrap 5 without getInstance
                                    if (typeof bootstrap !== 'undefined' && typeof bootstrap.Modal !== 'undefined') {
                                        const modalInstance = new bootstrap.Modal(modalElement);
                                        modalInstance.show();
                                        return;
                                    }

                                    // Method 3: jQuery Bootstrap
                                    if (typeof $ !== 'undefined' && typeof $.fn.modal !== 'undefined') {
                                        $(modalElement).modal('show');
                                        return;
                                    }

                                    // Method 4: Manual fallback
                                    modalElement.style.display = 'block';
                                    modalElement.classList.add('show');
                                    modalElement.setAttribute('aria-hidden', 'false');

                                    // Add backdrop
                                    let backdrop = document.querySelector('.modal-backdrop');
                                    if (!backdrop) {
                                        backdrop = document.createElement('div');
                                        backdrop.className = 'modal-backdrop fade show';
                                        document.body.appendChild(backdrop);
                                    }

                                    // Add modal-open class to body
                                    document.body.classList.add('modal-open');

                                    console.log('Modal shown using manual fallback');

                                } catch (error) {
                                    console.error('Error showing modal:', error);
                                    // Last resort - just show the modal element
                                    modalElement.style.display = 'block';
                                }
                            }

                            // Universal modal hide function with fallbacks
                            function hideModal(modalId) {
                                const modalElement = document.getElementById(modalId);
                                if (!modalElement) {
                                    console.error('Modal element not found:', modalId);
                                    return;
                                }

                                try {
                                    // Method 1: Bootstrap 5 with getInstance
                                    if (typeof bootstrap !== 'undefined' &&
                                            typeof bootstrap.Modal !== 'undefined' &&
                                            typeof bootstrap.Modal.getInstance === 'function') {

                                        const modalInstance = bootstrap.Modal.getInstance(modalElement);
                                        if (modalInstance) {
                                            modalInstance.hide();
                                            return;
                                        }
                                    }

                                    // Method 2: jQuery Bootstrap
                                    if (typeof $ !== 'undefined' && typeof $.fn.modal !== 'undefined') {
                                        $(modalElement).modal('hide');
                                        return;
                                    }

                                    // Method 3: Manual fallback
                                    modalElement.style.display = 'none';
                                    modalElement.classList.remove('show');
                                    modalElement.setAttribute('aria-hidden', 'true');

                                    // Remove backdrop
                                    const backdrop = document.querySelector('.modal-backdrop');
                                    if (backdrop) {
                                        backdrop.remove();
                                    }

                                    // Remove modal-open class from body
                                    document.body.classList.remove('modal-open');

                                    console.log('Modal hidden using manual fallback');

                                } catch (error) {
                                    console.error('Error hiding modal:', error);
                                    // Last resort - just hide the modal element
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

                                fetch('${pageContext.request.contextPath}/course?action=getLessons&chapterId=' + chapterId)
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
                                                lessons.forEach(lesson => {
                                                    const lessonName = escapeHtml(lesson.name || '');
                                                    const lessonContent = lesson.content ? escapeHtml(lesson.content.substring(0, 100)) + '...' : '';
                                                    html += '<div class="list-group-item d-flex justify-content-between align-items-center">';
                                                    html += '<div>';
                                                    html += '<strong>' + lessonName + '</strong>';
                                                    if (lessonContent) {
                                                        html += '<br><small class="text-muted">' + lessonContent + '</small>';
                                                    }
                                                    html += '</div>';
                                                    html += '<button class="btn btn-sm btn-outline-primary" onclick="addLessonToCourse(' + lesson.id + ', ' + chapterId + ')">';
                                                    html += '<i class="fas fa-plus"></i> Add';
                                                    html += '</button>';
                                                    html += '</div>';
                                                });
                                                html += '</div>';
                                                container.innerHTML = html;
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

                                const params = new URLSearchParams();
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
                                                // Close modal using universal hide function
                                                hideModal('addLessonModal');
                                                location.reload();
                                            } else {
                                                alert('Failed to add lesson: ' + (data.message || 'Unknown error'));
                                            }
                                        })
                                        .catch(error => {
                                            console.error('Error:', error);
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

                                const actionMap = {
                                    'chapter': 'removeChapter',
                                    'lesson': 'removeLesson',
                                    'test': 'removeTest'
                                };

                                const paramMap = {
                                    'chapter': 'chapterId',
                                    'lesson': 'lessonId',
                                    'test': 'testId'
                                };

                                if (!actionMap[type] || !paramMap[type]) {
                                    console.error('Invalid type:', type);
                                    return;
                                }

                                const params = new URLSearchParams();
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
                                                location.reload();
                                            } else {
                                                alert('Failed to remove ' + type + ': ' + (data.message || 'Unknown error'));
                                            }
                                        })
                                        .catch(error => {
                                            console.error('Error:', error);
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
                                                return {success: true}; // Assume success if not JSON
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
                                if (!confirm('Are you sure you want to submit this course for approval? You will not be able to edit it while it is pending approval.')) {
                                    return;
                                }

                                window.location.href = '${pageContext.request.contextPath}/course?action=submit&id=${courseId}';
                                    }

                                    function previewCourse() {
                                        window.open('${pageContext.request.contextPath}/course?action=detail&id=${courseId}', '_blank');
                                            }

                                            function saveDraft() {
                                                const params = new URLSearchParams();
                                                params.append('action', 'saveDraft');
                                                params.append('courseId', '${courseId}');

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
                                                                // Find the save button and show success feedback
                                                                const saveButtons = document.querySelectorAll('button[onclick*="saveDraft"]');
                                                                if (saveButtons.length > 0) {
                                                                    const btn = saveButtons[0];
                                                                    const originalText = btn.innerHTML;
                                                                    btn.innerHTML = '<i class="fas fa-check"></i> Saved!';
                                                                    btn.classList.remove('btn-success');
                                                                    btn.classList.add('btn-outline-success');

                                                                    setTimeout(() => {
                                                                        btn.innerHTML = originalText;
                                                                        btn.classList.remove('btn-outline-success');
                                                                        btn.classList.add('btn-success');
                                                                    }, 2000);
                                                                }
                                                            } else {
                                                                alert('Failed to save draft: ' + (data.message || 'Unknown error'));
                                                            }
                                                        })
                                                        .catch(error => {
                                                            console.error('Error:', error);
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
        </script>
    </body>
</html>