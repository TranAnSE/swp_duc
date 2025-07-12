<%-- 
    Document   : videoViewer
    Created on : Jun 22, 2025, 6:33:41 PM
    Author     : ankha
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${currentLesson.lesson_name} - ${courseStructure.course.course_title}</title>

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
            }

            body {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                font-family: 'Inter', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            .main-container {
                padding-top: 100px;
                min-height: 100vh;
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
            }

            .content-wrapper {
                padding: 20px 0;
            }

            /* Course Progress Header */
            .course-progress-header {
                background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
                color: white;
                padding: 20px;
                border-radius: 16px;
                margin-bottom: 20px;
                box-shadow: var(--shadow-lg);
            }

            .progress-info {
                display: flex;
                justify-content: space-between;
                align-items: center;
                flex-wrap: wrap;
                gap: 20px;
            }

            .course-title-section h2 {
                margin: 0 0 5px 0;
                font-size: 1.5rem;
                font-weight: 700;
            }

            .teacher-info {
                font-size: 0.9rem;
                opacity: 0.9;
            }

            .progress-stats {
                display: flex;
                gap: 30px;
                align-items: center;
            }

            .progress-item {
                text-align: center;
            }

            .progress-number {
                font-size: 1.5rem;
                font-weight: 700;
                display: block;
            }

            .progress-label {
                font-size: 0.8rem;
                opacity: 0.9;
            }

            .progress-bar-container {
                width: 100%;
                margin-top: 15px;
            }

            .progress-bar-custom {
                height: 8px;
                background: rgba(255, 255, 255, 0.3);
                border-radius: 4px;
                overflow: hidden;
            }

            .progress-bar-fill {
                height: 100%;
                background: linear-gradient(90deg, #10b981 0%, #059669 100%);
                border-radius: 4px;
                transition: width 0.3s ease;
            }

            /* Sidebar Styles */
            .course-sidebar {
                background: #fff;
                border-radius: 16px;
                box-shadow: var(--shadow-lg);
                padding: 24px;
                height: calc(100vh - 200px);
                overflow-y: auto;
                position: sticky;
                top: 120px;
                border: 1px solid var(--border-color);
            }

            .sidebar-header {
                border-bottom: 2px solid var(--border-color);
                padding-bottom: 16px;
                margin-bottom: 24px;
                text-align: center;
            }

            .sidebar-header h5 {
                color: var(--text-primary);
                font-weight: 700;
                margin: 0;
                font-size: 1.1rem;
            }

            /* Course Tree Styles */
            .course-tree {
                list-style: none;
                padding: 0;
                margin: 0;
            }

            .chapter-item {
                margin-bottom: 16px;
            }

            .chapter-header {
                background: linear-gradient(135deg, var(--warning-color) 0%, #d97706 100%);
                color: white;
                padding: 12px 16px;
                border-radius: 8px;
                cursor: pointer;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                justify-content: space-between;
                font-weight: 600;
                box-shadow: var(--shadow-sm);
                border: none;
                width: 100%;
                text-align: left;
            }

            .chapter-header:hover {
                background: linear-gradient(135deg, #d97706 0%, #b45309 100%);
                color: white;
                transform: translateY(-1px);
                box-shadow: var(--shadow-md);
            }

            .chapter-header i.fa-chevron-down {
                transition: transform 0.3s ease;
            }

            .chapter-header[aria-expanded="false"] i.fa-chevron-down {
                transform: rotate(-90deg);
            }

            .chapter-content {
                background: linear-gradient(135deg, #fefefe 0%, #f9fafb 100%);
                border-radius: 0 0 8px 8px;
                padding: 12px;
                border: 1px solid var(--border-color);
                border-top: none;
            }

            /* Lesson Items */
            .lesson-item, .test-item {
                padding: 10px 14px;
                margin: 6px 0;
                border-radius: 6px;
                cursor: pointer;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                text-decoration: none;
                color: var(--text-secondary);
                font-size: 0.9rem;
                border: 1px solid transparent;
                position: relative;
            }

            .lesson-item {
                background: rgba(255, 255, 255, 0.8);
            }

            .lesson-item:hover {
                background: linear-gradient(135deg, #e0f2fe 0%, #bae6fd 100%);
                color: var(--primary-color);
                text-decoration: none;
                transform: translateX(4px);
                border-color: rgba(79, 70, 229, 0.2);
                box-shadow: var(--shadow-sm);
            }

            .lesson-item.active {
                background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
                color: white;
                font-weight: 600;
                box-shadow: var(--shadow-md);
            }

            .lesson-item.completed {
                background: linear-gradient(135deg, var(--success-color) 0%, #059669 100%);
                color: white;
            }

            .lesson-item.completed::after {
                content: '\f00c';
                font-family: 'Font Awesome 5 Free';
                font-weight: 900;
                position: absolute;
                right: 10px;
                font-size: 0.8rem;
            }

            .test-item {
                background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
                color: #92400e;
                border: 1px solid #f59e0b;
            }

            .test-item:hover {
                background: linear-gradient(135deg, #fde68a 0%, #fcd34d 100%);
                color: #92400e;
                text-decoration: none;
                transform: translateX(4px);
            }

            .lesson-item i, .test-item i {
                margin-right: 10px;
                width: 16px;
                text-align: center;
            }

            /* Video Player Styles */
            .video-container {
                background: #fff;
                border-radius: 16px;
                box-shadow: var(--shadow-lg);
                overflow: hidden;
                margin-bottom: 24px;
                border: 1px solid var(--border-color);
            }

            .video-player {
                width: 100%;
                height: 450px;
                background: #000;
                border-radius: 16px 16px 0 0;
            }

            .video-placeholder {
                height: 450px;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                text-align: center;
            }

            .video-info {
                padding: 24px;
            }

            .video-title {
                font-size: 1.75rem;
                font-weight: 700;
                color: var(--text-primary);
                margin-bottom: 16px;
                line-height: 1.3;
            }

            .breadcrumb-nav {
                margin-bottom: 16px;
            }

            .breadcrumb-nav .breadcrumb {
                background: var(--light-color);
                border-radius: 8px;
                padding: 8px 16px;
                margin: 0;
            }

            .breadcrumb-nav .breadcrumb-item a {
                color: var(--primary-color);
                text-decoration: none;
            }

            .breadcrumb-nav .breadcrumb-item.active {
                color: var(--text-secondary);
            }

            .video-meta {
                display: flex;
                flex-wrap: wrap;
                gap: 20px;
                margin-bottom: 20px;
            }

            .meta-item {
                display: flex;
                align-items: center;
                color: var(--text-secondary);
                font-size: 0.9rem;
                background: var(--light-color);
                padding: 8px 12px;
                border-radius: 20px;
                border: 1px solid var(--border-color);
            }

            .meta-item i {
                margin-right: 8px;
                color: var(--primary-color);
            }

            .video-description {
                background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
                padding: 20px;
                border-radius: 12px;
                border-left: 4px solid var(--primary-color);
                margin-top: 20px;
            }

            .video-description h6 {
                color: var(--text-primary);
                font-weight: 600;
                margin-bottom: 12px;
            }

            .video-description p {
                color: var(--text-secondary);
                line-height: 1.6;
                margin: 0;
            }

            /* Navigation Buttons */
            .lesson-navigation {
                display: flex;
                gap: 15px;
                margin-top: 20px;
            }

            .nav-btn {
                flex: 1;
                padding: 12px 20px;
                border-radius: 8px;
                text-decoration: none;
                text-align: center;
                font-weight: 600;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
            }

            .nav-btn.prev {
                background: #6c757d;
                color: white;
            }

            .nav-btn.next {
                background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
                color: white;
            }

            .nav-btn:hover {
                text-decoration: none;
                color: white;
                transform: translateY(-2px);
                box-shadow: var(--shadow-md);
            }

            .nav-btn:disabled {
                opacity: 0.5;
                cursor: not-allowed;
                transform: none;
            }

            /* Responsive Design */
            @media (max-width: 992px) {
                .main-container {
                    padding-top: 90px;
                }

                .course-sidebar {
                    position: static;
                    height: auto;
                    margin-bottom: 24px;
                    max-height: 400px;
                }

                .video-player, .video-placeholder {
                    height: 350px;
                }

                .progress-stats {
                    gap: 20px;
                }
            }

            @media (max-width: 768px) {
                .progress-info {
                    flex-direction: column;
                    text-align: center;
                }

                .progress-stats {
                    justify-content: center;
                    gap: 15px;
                }

                .video-player, .video-placeholder {
                    height: 250px;
                }

                .video-info {
                    padding: 16px;
                }

                .video-title {
                    font-size: 1.25rem;
                }

                .lesson-navigation {
                    flex-direction: column;
                }
            }

            /* Custom Scrollbar */
            .course-sidebar::-webkit-scrollbar {
                width: 6px;
            }

            .course-sidebar::-webkit-scrollbar-track {
                background: var(--light-color);
                border-radius: 3px;
            }

            .course-sidebar::-webkit-scrollbar-thumb {
                background: var(--border-color);
                border-radius: 3px;
            }

            .course-sidebar::-webkit-scrollbar-thumb:hover {
                background: var(--text-secondary);
            }

            /* Progress indicator for lessons */
            .lesson-progress {
                font-size: 0.7rem;
                opacity: 0.8;
                margin-left: auto;
            }
        </style>
    </head>
    <body>
        <jsp:include page="/header.jsp" />

        <div class="main-container">
            <div class="content-wrapper">
                <div class="container-fluid">
                    <!-- Course Progress Header (only for students) -->
                    <c:if test="${isTrackingEnabled && not empty courseProgress}">
                        <div class="course-progress-header">
                            <div class="progress-info">
                                <div class="course-title-section">
                                    <h2>${courseStructure.course.course_title}</h2>
                                    <div class="teacher-info">
                                        <i class="fas fa-user-tie mr-2"></i>
                                        Instructor: ${courseProgress.teacherName}
                                    </div>
                                </div>
                                <div class="progress-stats">
                                    <div class="progress-item">
                                        <span class="progress-number">${courseProgress.completedLessons}</span>
                                        <span class="progress-label">Completed</span>
                                    </div>
                                    <div class="progress-item">
                                        <span class="progress-number">${courseProgress.totalLessons}</span>
                                        <span class="progress-label">Total Lessons</span>
                                    </div>
                                    <div class="progress-item">
                                        <span class="progress-number">
                                            <fmt:formatNumber value="${courseProgress.completionPercentage}" maxFractionDigits="1"/>%
                                        </span>
                                        <span class="progress-label">Progress</span>
                                    </div>
                                </div>
                            </div>
                            <div class="progress-bar-container">
                                <div class="progress-bar-custom">
                                    <div class="progress-bar-fill" style="width: ${courseProgress.completionPercentage}%"></div>
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <div class="row">
                        <!-- Sidebar -->
                        <div class="col-xl-3 col-lg-4 col-md-12">
                            <div class="course-sidebar">
                                <div class="sidebar-header">
                                    <h5><i class="fas fa-book-open mr-2"></i>Course Content</h5>
                                </div>

                                <ul class="course-tree">
                                    <c:forEach var="chapter" items="${courseStructure.chapters}">
                                        <li class="chapter-item">
                                            <button class="chapter-header" type="button" 
                                                    data-toggle="collapse" 
                                                    data-target="#chapter-${chapter.chapter_id}"
                                                    aria-expanded="false"
                                                    aria-controls="chapter-${chapter.chapter_id}">
                                                <span><i class="fas fa-folder mr-2"></i>${chapter.chapter_name}</span>
                                                <i class="fas fa-chevron-down"></i>
                                            </button>

                                            <div class="collapse" id="chapter-${chapter.chapter_id}">
                                                <div class="chapter-content">
                                                    <!-- Lessons -->
                                                    <c:forEach var="lesson" items="${chapter.lessons}">
                                                        <c:set var="lessonProgress" value="${lessonProgressMap[lesson.lesson_id]}" />
                                                        <c:set var="isCurrentLesson" value="${lesson.lesson_id == currentLesson.lesson_id}" />
                                                        <c:set var="isCompleted" value="${lessonProgress != null && lessonProgress.completed}" />

                                                        <a href="/video-viewer?courseId=${courseId}&lessonId=${lesson.lesson_id}" 
                                                           class="lesson-item ${isCurrentLesson ? 'active' : ''} ${isCompleted ? 'completed' : ''}">
                                                            <i class="fas ${not empty lesson.video_link ? 'fa-play-circle' : 'fa-file-text'}"></i>
                                                            <span>${lesson.lesson_name}</span>
                                                            <c:if test="${isTrackingEnabled && lessonProgress != null}">
                                                                <span class="lesson-progress">
                                                                    <fmt:formatNumber value="${lessonProgress.completionPercentage}" maxFractionDigits="0"/>%
                                                                </span>
                                                            </c:if>
                                                        </a>
                                                    </c:forEach>

                                                    <!-- Tests -->
                                                    <c:forEach var="test" items="${chapter.tests}">
                                                        <a href="/student/taketest?action=start&testId=${test.test_id}" 
                                                           class="test-item">
                                                            <i class="fas ${test.is_practice ? 'fa-dumbbell' : 'fa-clipboard-check'}"></i>
                                                            <span>${test.test_name}</span>
                                                            <c:if test="${test.is_practice}">
                                                                <small class="ml-2">(Practice)</small>
                                                            </c:if>
                                                        </a>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                        </li>
                                    </c:forEach>

                                    <!-- Course-level tests -->
                                    <c:if test="${not empty courseStructure.courseLevelTests}">
                                        <li class="chapter-item">
                                            <button class="chapter-header" type="button" 
                                                    data-toggle="collapse" 
                                                    data-target="#course-tests"
                                                    aria-expanded="false"
                                                    aria-controls="course-tests">
                                                <span><i class="fas fa-clipboard-list mr-2"></i>Course Tests</span>
                                                <i class="fas fa-chevron-down"></i>
                                            </button>

                                            <div class="collapse" id="course-tests">
                                                <div class="chapter-content">
                                                    <c:forEach var="test" items="${courseStructure.courseLevelTests}">
                                                        <a href="/student/taketest?action=start&testId=${test.test_id}" 
                                                           class="test-item">
                                                            <i class="fas ${test.is_practice ? 'fa-dumbbell' : 'fa-clipboard-check'}"></i>
                                                            <span>${test.test_name}</span>
                                                            <c:if test="${test.is_practice}">
                                                                <small class="ml-2">(Practice)</small>
                                                            </c:if>
                                                        </a>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                        </li>
                                    </c:if>
                                </ul>
                            </div>
                        </div>

                        <!-- Main Content -->
                        <div class="col-xl-9 col-lg-8 col-md-12">
                            <!-- Breadcrumb Navigation -->
                            <div class="breadcrumb-nav">
                                <nav aria-label="breadcrumb">
                                    <ol class="breadcrumb">
                                        <li class="breadcrumb-item">
                                            <a href="/student/home.jsp"><i class="fas fa-home mr-1"></i>Home</a>
                                        </li>
                                        <li class="breadcrumb-item">
                                            <a href="/video-viewer?courseId=${courseId}">${courseStructure.course.course_title}</a>
                                        </li>
                                        <li class="breadcrumb-item">
                                            <a href="#">${currentLesson.chapter_name}</a>
                                        </li>
                                        <li class="breadcrumb-item active" aria-current="page">
                                            ${currentLesson.lesson_name}
                                        </li>
                                    </ol>
                                </nav>
                            </div>

                            <!-- Video Player Section -->
                            <div class="video-container">
                                <c:choose>
                                    <c:when test="${not empty currentLesson.video_link}">
                                        <video class="video-player" controls preload="metadata" id="mainVideo"
                                               data-lesson-id="${currentLesson.lesson_id}"
                                               data-course-id="${courseId}"
                                               data-tracking-enabled="${isTrackingEnabled}">
                                            <source src="${currentLesson.video_link}" type="video/mp4">
                                            <source src="${currentLesson.video_link}" type="video/webm">
                                            <source src="${currentLesson.video_link}" type="video/ogg">
                                            Your browser does not support the video tag.
                                        </video>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="video-placeholder">
                                            <div class="text-center">
                                                <i class="fas fa-file-text fa-4x mb-3"></i>
                                                <h4>Text-Based Lesson</h4>
                                                <p class="mb-0">This lesson contains text content only.</p>
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                                <div class="video-info">
                                    <h1 class="video-title">${currentLesson.lesson_name}</h1>

                                    <div class="video-meta">
                                        <div class="meta-item">
                                            <i class="fas fa-folder"></i>
                                            <span>${currentLesson.chapter_name}</span>
                                        </div>
                                        <c:if test="${not empty currentLesson.video_link}">
                                            <div class="meta-item">
                                                <i class="fas fa-play-circle"></i>
                                                <span>Video Lesson</span>
                                            </div>
                                        </c:if>
                                        <c:if test="${isTrackingEnabled}">
                                            <c:set var="currentProgress" value="${lessonProgressMap[currentLesson.lesson_id]}" />
                                            <c:if test="${currentProgress != null}">
                                                <div class="meta-item">
                                                    <i class="fas fa-chart-line"></i>
                                                    <span>Progress: <fmt:formatNumber value="${currentProgress.completionPercentage}" maxFractionDigits="1"/>%</span>
                                                </div>
                                            </c:if>
                                        </c:if>
                                    </div>

                                    <c:if test="${not empty currentLesson.lesson_content}">
                                        <div class="video-description">
                                            <h6><i class="fas fa-info-circle mr-2"></i>Lesson Content</h6>
                                            <p>${currentLesson.lesson_content}</p>
                                        </div>
                                    </c:if>

                                    <!-- Navigation Buttons -->
                                    <div class="lesson-navigation">
                                        <c:choose>
                                            <c:when test="${not empty navigation.previousLesson}">
                                                <a href="/video-viewer?courseId=${courseId}&lessonId=${navigation.previousLesson.lesson_id}" 
                                                   class="nav-btn prev">
                                                    <i class="fas fa-arrow-left"></i>
                                                    <span>Previous: ${navigation.previousLesson.lesson_name}</span>
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="nav-btn prev" style="opacity: 0.5; cursor: not-allowed;">
                                                    <i class="fas fa-arrow-left"></i>
                                                    <span>No Previous Lesson</span>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>

                                        <c:choose>
                                            <c:when test="${not empty navigation.nextLesson}">
                                                <a href="/video-viewer?courseId=${courseId}&lessonId=${navigation.nextLesson.lesson_id}" 
                                                   class="nav-btn next">
                                                    <span>Next: ${navigation.nextLesson.lesson_name}</span>
                                                    <i class="fas fa-arrow-right"></i>
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="nav-btn next" style="opacity: 0.5; cursor: not-allowed;">
                                                    <span>Course Complete</span>
                                                    <i class="fas fa-check"></i>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="/footer.jsp" />

        <script src="/assets/js/vendor/jquery-1.12.4.min.js"></script>
        <script src="/assets/js/bootstrap.min.js"></script>

        <script>
            $(document).ready(function () {
                // Auto-expand current lesson's chapter
                $('.lesson-item.active').parents('.collapse').addClass('show');
                $('.lesson-item.active').parents('.collapse').each(function () {
                    const targetId = $(this).attr('id');
                    const trigger = $('[data-target="#' + targetId + '"]');
                    trigger.attr('aria-expanded', 'true');
                });

                // Handle collapse events for proper icon rotation
                $('.collapse').on('show.bs.collapse', function () {
                    const targetId = $(this).attr('id');
                    const trigger = $('[data-target="#' + targetId + '"]');
                    trigger.attr('aria-expanded', 'true');
                });

                $('.collapse').on('hide.bs.collapse', function () {
                    const targetId = $(this).attr('id');
                    const trigger = $('[data-target="#' + targetId + '"]');
                    trigger.attr('aria-expanded', 'false');
                });

                // Video progress tracking
                const video = document.getElementById('mainVideo');
                if (video && video.dataset.trackingEnabled === 'true') {
                    const lessonId = parseInt(video.dataset.lessonId);
                    const courseId = parseInt(video.dataset.courseId);
                    let progressUpdateInterval;
                    let lastSavedPosition = 0;
                    let hasStartedWatching = false;

                    // Prevent seeking beyond watched position initially
                    let maxWatchedPosition = 0;
                    const savedProgress = localStorage.getItem(`lesson_${lessonId}_progress`);
                    if (savedProgress) {
                        const progressData = JSON.parse(savedProgress);
                        maxWatchedPosition = progressData.maxPosition || 0;

                        // Restore last position if significant progress was made
                        if (progressData.lastPosition > 10) {
                            video.currentTime = progressData.lastPosition;
                        }
                    }

                    video.addEventListener('loadedmetadata', function () {
                        console.log('Video loaded, duration:', video.duration);
                    });

                    video.addEventListener('play', function () {
                        if (!hasStartedWatching) {
                            hasStartedWatching = true;
                            console.log('Started watching lesson:', lessonId);
                        }

                        // Update progress every 5 seconds while playing
                        progressUpdateInterval = setInterval(function () {
                            updateProgress();
                        }, 5000);
                    });

                    video.addEventListener('pause', function () {
                        if (progressUpdateInterval) {
                            clearInterval(progressUpdateInterval);
                        }
                        updateProgress();
                    });

                    video.addEventListener('ended', function () {
                        if (progressUpdateInterval) {
                            clearInterval(progressUpdateInterval);
                        }
                        updateProgress();
                    });

                    // Prevent skipping ahead (anti-cheat mechanism)
                    video.addEventListener('seeking', function () {
                        if (video.currentTime > maxWatchedPosition + 10) {
                            console.log('Preventing skip ahead from', video.currentTime, 'to max allowed:', maxWatchedPosition + 10);
                            video.currentTime = maxWatchedPosition;

                            // Show warning message
                            showWarningMessage('You cannot skip ahead in the video. Please watch the content sequentially.');
                        }
                    });

                    video.addEventListener('timeupdate', function () {
                        // Update max watched position
                        if (video.currentTime > maxWatchedPosition) {
                            maxWatchedPosition = video.currentTime;

                            // Save to localStorage for persistence
                            const progressData = {
                                lastPosition: video.currentTime,
                                maxPosition: maxWatchedPosition,
                                timestamp: Date.now()
                            };
                            localStorage.setItem(`lesson_${lessonId}_progress`, JSON.stringify(progressData));
                        }
                    });

                    function updateProgress() {
                        if (!video.duration || video.duration === 0)
                            return;

                        const watchDuration = Math.floor(video.currentTime);
                        const totalDuration = Math.floor(video.duration);
                        const lastPosition = Math.floor(video.currentTime);

                        // Only update if there's meaningful progress
                        if (Math.abs(lastPosition - lastSavedPosition) < 5 && watchDuration < totalDuration * 0.95) {
                            return;
                        }

                        lastSavedPosition = lastPosition;

                        $.ajax({
                            url: '/progress',
                            method: 'POST',
                            data: {
                                action: 'updateProgress',
                                lessonId: lessonId,
                                courseId: courseId,
                                watchDuration: watchDuration,
                                totalDuration: totalDuration,
                                lastPosition: lastPosition
                            },
                            success: function (response) {
                                if (response.success) {
                                    console.log('Progress updated successfully');

                                    // Check if lesson was just completed
                                    const completionPercentage = (watchDuration / totalDuration) * 100;
                                    if (completionPercentage >= 30) {
                                        markLessonAsCompleted(lessonId);
                                    }
                                } else {
                                    console.error('Failed to update progress:', response.message);
                                }
                            },
                            error: function (xhr, status, error) {
                                console.error('Error updating progress:', error);
                            }
                        });
                    }

                    function markLessonAsCompleted(lessonId) {
                        const lessonItem = $(`.lesson-item[href*="lessonId=${lessonId}"]`);
                        if (!lessonItem.hasClass('completed')) {
                            lessonItem.addClass('completed');

                            // Show completion message
                            showSuccessMessage('Lesson completed! Great job!');

                            // Update course progress display if visible
                            setTimeout(function () {
                                location.reload();
                            }, 2000);
                        }
                    }

                    // Save progress when leaving page
                    $(window).on('beforeunload', function () {
                        if (video.currentTime > 0) {
                            updateProgress();
                        }
                    });
                }

                // Keyboard navigation
                $(document).keydown(function (e) {
                    if (e.target.tagName.toLowerCase() !== 'input' && e.target.tagName.toLowerCase() !== 'textarea') {
                        // Space bar to play/pause video
                        if (e.which === 32 && video) {
                            e.preventDefault();
                            if (video.paused) {
                                video.play();
                            } else {
                                video.pause();
                            }
                        }
                        // Arrow keys for navigation
                        if (e.which === 37) { // Left arrow - previous lesson
                            const prevBtn = $('.nav-btn.prev[href]');
                            if (prevBtn.length) {
                                window.location.href = prevBtn.attr('href');
                            }
                        }
                        if (e.which === 39) { // Right arrow - next lesson
                            const nextBtn = $('.nav-btn.next[href]');
                            if (nextBtn.length) {
                                window.location.href = nextBtn.attr('href');
                            }
                        }
                    }
                });

                // Mobile responsive adjustments
                function adjustForMobile() {
                    if ($(window).width() < 768) {
                        // Collapse sidebar by default on mobile except for current lesson
                        $('.course-sidebar .collapse').not(':has(.lesson-item.active)').removeClass('show');
                    }
                }

                adjustForMobile();
                $(window).resize(adjustForMobile);
            });

            function showWarningMessage(message) {
                // Create and show warning toast
                const toast = $(`
                    <div class="alert alert-warning alert-dismissible fade show" role="alert" style="position: fixed; top: 120px; right: 20px; z-index: 9999; min-width: 300px;">
                        <i class="fas fa-exclamation-triangle mr-2"></i>
            ${message}
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                `);

                $('body').append(toast);

                setTimeout(function () {
                    toast.fadeOut();
                }, 5000);
            }

            function showSuccessMessage(message) {
                // Create and show success toast
                const toast = $(`
                    <div class="alert alert-success alert-dismissible fade show" role="alert" style="position: fixed; top: 120px; right: 20px; z-index: 9999; min-width: 300px;">
                        <i class="fas fa-check-circle mr-2"></i>
            ${message}
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                `);

                $('body').append(toast);

                setTimeout(function () {
                    toast.fadeOut();
                }, 5000);
            }
        </script>
    </body>
</html>