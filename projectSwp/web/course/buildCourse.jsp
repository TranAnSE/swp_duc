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
                justify-content: between;
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
                justify-content: between;
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
                    <h6>Or select from existing content:</h6>
                    <div class="row">
                        <div class="col-md-6">
                            <h6>Available Chapters</h6>
                            <c:choose>
                                <c:when test="${not empty availableChapters}">
                                    <div class="list-group" style="max-height: 200px; overflow-y: auto;">
                                        <c:forEach items="${availableChapters}" var="chapter">
                                            <div class="list-group-item d-flex justify-content-between align-items-center">
                                                <span>${chapter.name}</span>
                                                <button class="btn btn-sm btn-outline-primary" 
                                                        onclick="addChapterToCourse(${chapter.id})">
                                                    <i class="fas fa-plus"></i> Add
                                                </button>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-muted">No chapters available for this subject. <a href="${pageContext.request.contextPath}/chapter?service=add&returnTo=course&courseId=${courseId}">Create one</a></p>
                                </c:otherwise>
                            </c:choose>
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
                            <!-- Chapters -->
                            <c:if test="${not empty courseChapters}">
                                <h5><i class="fas fa-book"></i> Chapters (${courseChapters.size()})</h5>
                                <div id="chaptersList" class="sortable-list">
                                    <c:forEach items="${courseChapters}" var="chapter">
                                        <div class="content-item" data-id="${chapter.chapter_id}" data-type="chapter">
                                            <div class="content-item-header">
                                                <div>
                                                    <span class="content-type-badge badge-chapter">Chapter</span>
                                                    <strong>${chapter.chapter_name}</strong>
                                                </div>
                                                <div>
                                                    <button class="btn btn-sm btn-outline-danger" 
                                                            onclick="removeFromCourse('chapter', ${chapter.chapter_id})">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </div>
                                            </div>
                                            <p class="text-muted mb-0">${chapter.chapter_description}</p>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:if>

                            <!-- Lessons -->
                            <c:if test="${not empty courseLessons}">
                                <h5><i class="fas fa-play"></i> Lessons (${courseLessons.size()})</h5>
                                <div id="lessonsList" class="sortable-list">
                                    <c:forEach items="${courseLessons}" var="lesson">
                                        <div class="content-item" data-id="${lesson.lesson_id}" data-type="lesson">
                                            <div class="content-item-header">
                                                <div>
                                                    <span class="content-type-badge badge-lesson">Lesson</span>
                                                    <strong>${lesson.lesson_name}</strong>
                                                    <small class="text-muted">(${lesson.chapter_name})</small>
                                                </div>
                                                <div>
                                                    <button class="btn btn-sm btn-outline-danger" 
                                                            onclick="removeFromCourse('lesson', ${lesson.lesson_id})">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </div>
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
                                            <p class="text-muted mb-0">${test.test_description}</p>
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

        <%@include file="../footer.jsp" %>

        <!-- JS -->
        <script src="${pageContext.request.contextPath}/assets/js/vendor/jquery-1.12.4.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>

        <script>
                            // Initialize sortable lists
                            document.addEventListener('DOMContentLoaded', function () {
                                const sortableLists = document.querySelectorAll('.sortable-list');
                                sortableLists.forEach(list => {
                                    new Sortable(list, {
                                        animation: 150,
                                        ghostClass: 'sortable-ghost',
                                        onEnd: function (evt) {
                                            updateContentOrder();
                                        }
                                    });
                                });
                            });

                            function toggleAddContent() {
                                const section = document.getElementById('addContentSection');
                                section.style.display = section.style.display === 'none' ? 'block' : 'none';
                            }

                            function addChapterToCourse(chapterId) {
                                fetch('${pageContext.request.contextPath}/course', {
                                    method: 'POST',
                                    headers: {
                                        'Content-Type': 'application/x-www-form-urlencoded',
                                    },
                                    body: `action=addChapter&courseId=${courseId}&chapterId=${chapterId}`
                                })
                                        .then(response => response.json())
                                        .then(data => {
                                            if (data.success) {
                                                location.reload();
                                            } else {
                                                alert('Failed to add chapter: ' + data.message);
                                            }
                                        })
                                        .catch(error => {
                                            console.error('Error:', error);
                                            alert('An error occurred while adding the chapter.');
                                        });
                            }

                            function removeFromCourse(type, id) {
                                if (!confirm('Are you sure you want to remove this ' + type + ' from the course?')) {
                                    return;
                                }

                                fetch('${pageContext.request.contextPath}/course', {
                                    method: 'POST',
                                    headers: {
                                        'Content-Type': 'application/x-www-form-urlencoded',
                                    },
                                    body: `action=removeContent&courseId=${courseId}&contentType=${type}&contentId=${id}`
                                })
                                        .then(response => response.json())
                                        .then(data => {
                                            if (data.success) {
                                                location.reload();
                                            } else {
                                                alert('Failed to remove ' + type + ': ' + data.message);
                                            }
                                        })
                                        .catch(error => {
                                            console.error('Error:', error);
                                            alert('An error occurred while removing the ' + type + '.');
                                        });
                            }

                            function updateContentOrder() {
                                const chapters = Array.from(document.querySelectorAll('#chaptersList .content-item')).map((item, index) => ({
                                        id: item.dataset.id,
                                        type: 'chapter',
                                        order: index + 1
                                    }));

                                const lessons = Array.from(document.querySelectorAll('#lessonsList .content-item')).map((item, index) => ({
                                        id: item.dataset.id,
                                        type: 'lesson',
                                        order: index + 1
                                    }));

                                const tests = Array.from(document.querySelectorAll('#testsList .content-item')).map((item, index) => ({
                                        id: item.dataset.id,
                                        type: 'test',
                                        order: index + 1
                                    }));

                                const orderData = [...chapters, ...lessons, ...tests];

                                fetch('${pageContext.request.contextPath}/course', {
                                    method: 'POST',
                                    headers: {
                                        'Content-Type': 'application/json',
                                    },
                                    body: JSON.stringify({
                                        action: 'reorderContent',
                                        courseId: ${courseId},
                                        contentOrder: orderData
                                    })
                                })
                                        .then(response => response.json())
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
                                if (!confirm('Are you sure you want to submit this course for approval? You will not be able to edit it while it\'s pending approval.')) {
                                    return;
                                }

                                window.location.href = '${pageContext.request.contextPath}/course?action=submit&id=${courseId}';
                                    }

                                    function previewCourse() {
                                        window.open('${pageContext.request.contextPath}/course?action=detail&id=${courseId}', '_blank');
                                            }

                                            function saveDraft() {
                                                // Auto-save functionality
                                                fetch('${pageContext.request.contextPath}/course', {
                                                    method: 'POST',
                                                    headers: {
                                                        'Content-Type': 'application/x-www-form-urlencoded',
                                                    },
                                                    body: `action=saveDraft&courseId=${courseId}`
                                                })
                                                        .then(response => response.json())
                                                        .then(data => {
                                                            if (data.success) {
                                                                // Show temporary success message
                                                                const btn = event.target;
                                                                const originalText = btn.innerHTML;
                                                                btn.innerHTML = '<i class="fas fa-check"></i> Saved!';
                                                                btn.classList.remove('btn-success');
                                                                btn.classList.add('btn-outline-success');

                                                                setTimeout(() => {
                                                                    btn.innerHTML = originalText;
                                                                    btn.classList.remove('btn-outline-success');
                                                                    btn.classList.add('btn-success');
                                                                }, 2000);
                                                            } else {
                                                                alert('Failed to save draft: ' + data.message);
                                                            }
                                                        })
                                                        .catch(error => {
                                                            console.error('Error:', error);
                                                            alert('An error occurred while saving the draft.');
                                                        });
                                            }

                                            // Auto-save every 5 minutes
                                            setInterval(function () {
                                                if (document.getElementById('courseContent').children.length > 0) {
                                                    saveDraft();
                                                }
                                            }, 300000); // 5 minutes
        </script>
    </body>
</html>