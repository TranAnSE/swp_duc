<%-- 
    Document   : videoViewer
    Created on : Jun 22, 2025, 6:33:41 PM
    Author     : ankha
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${currentLesson.name} - Video Learning</title>

        <!-- Bootstrap 4 CSS -->
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

            /* Header Adjustments */
            .content-wrapper {
                padding: 20px 0;
            }

            /* Sidebar Styles */
            .course-sidebar {
                background: #fff;
                border-radius: 16px;
                box-shadow: var(--shadow-lg);
                padding: 24px;
                height: calc(100vh - 140px);
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

            .user-role-badge {
                display: inline-block;
                padding: 4px 12px;
                border-radius: 20px;
                font-size: 0.75rem;
                font-weight: 600;
                margin-top: 8px;
            }

            .role-student {
                background: #dbeafe;
                color: #1d4ed8;
            }
            .role-teacher {
                background: #dcfce7;
                color: #166534;
            }
            .role-admin {
                background: #fef3c7;
                color: #92400e;
            }
            .role-parent {
                background: #fce7f3;
                color: #be185d;
            }

            /* Course Tree Styles */
            .course-tree {
                list-style: none;
                padding: 0;
                margin: 0;
            }

            .grade-item {
                margin-bottom: 16px;
            }

            .grade-header {
                background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
                color: white;
                padding: 12px 16px;
                border-radius: 12px;
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

            .grade-header:hover {
                transform: translateY(-2px);
                box-shadow: var(--shadow-md);
                background: linear-gradient(135deg, #6366f1 0%, #0891b2 100%);
            }

            .grade-header:focus {
                outline: none;
                box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.3);
            }

            .grade-header i.fa-chevron-down {
                transition: transform 0.3s ease;
            }

            .grade-header[aria-expanded="false"] i.fa-chevron-down {
                transform: rotate(-90deg);
            }

            .subject-list {
                background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
                border-radius: 0 0 12px 12px;
                padding: 12px;
                border: 1px solid var(--border-color);
                border-top: none;
            }

            .subject-item {
                margin-bottom: 12px;
            }

            .subject-header {
                background: linear-gradient(135deg, #10b981 0%, #059669 100%);
                color: white;
                padding: 10px 14px;
                border-radius: 8px;
                cursor: pointer;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                justify-content: space-between;
                border: none;
                font-weight: 500;
                width: 100%;
                text-align: left;
                box-shadow: var(--shadow-sm);
            }

            .subject-header:hover {
                background: linear-gradient(135deg, #059669 0%, #047857 100%);
                transform: translateY(-1px);
                box-shadow: var(--shadow-md);
                color: white;
            }

            .subject-header:focus {
                outline: none;
                box-shadow: 0 0 0 2px rgba(16, 185, 129, 0.3);
                color: white;
            }

            .subject-header i.fa-chevron-down {
                transition: transform 0.3s ease;
                color: rgba(255, 255, 255, 0.9);
            }

            .subject-header[aria-expanded="false"] i.fa-chevron-down {
                transform: rotate(-90deg);
            }

            .chapter-list {
                padding: 12px 0 0 16px;
                background: linear-gradient(135deg, #fefefe 0%, #f9fafb 100%);
                border-radius: 8px;
                margin-top: 8px;
            }

            .chapter-item {
                margin-bottom: 10px;
            }

            .chapter-header {
                padding: 8px 12px;
                background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
                color: white;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                transition: all 0.3s ease;
                box-shadow: var(--shadow-sm);
                font-weight: 500;
                width: 100%;
                text-align: left;
                display: flex;
                align-items: center;
                justify-content: space-between;
            }

            .chapter-header:hover {
                background: linear-gradient(135deg, #d97706 0%, #b45309 100%);
                color: white;
                transform: translateX(4px);
                box-shadow: var(--shadow-md);
            }

            .chapter-header:focus {
                outline: none;
                box-shadow: 0 0 0 2px rgba(245, 158, 11, 0.3);
                color: white;
            }

            .chapter-header i.fa-chevron-down {
                transition: transform 0.3s ease;
                color: rgba(255, 255, 255, 0.9);
            }

            .chapter-header[aria-expanded="false"] i.fa-chevron-down {
                transform: rotate(-90deg);
            }

            .lesson-list {
                padding: 8px 0 0 20px;
                background: rgba(255, 255, 255, 0.7);
                border-radius: 6px;
                margin-top: 6px;
                border-left: 3px solid #f59e0b;
            }

            .lesson-item {
                padding: 8px 12px;
                margin: 4px 0;
                border-radius: 6px;
                cursor: pointer;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                text-decoration: none;
                color: var(--text-secondary);
                font-size: 0.9rem;
                border: 1px solid transparent;
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
                border-color: transparent;
            }

            .lesson-item.active:hover {
                background: linear-gradient(135deg, #6366f1 0%, #0891b2 100%);
                color: white;
            }

            .lesson-item i {
                margin-right: 10px;
                width: 16px;
                text-align: center;
            }

            /* Enhanced hover effects for the entire tree structure */
            .grade-item:hover .grade-header {
                box-shadow: var(--shadow-lg);
            }

            .subject-item:hover .subject-header {
                box-shadow: var(--shadow-md);
            }

            .chapter-item:hover .chapter-header {
                box-shadow: var(--shadow-md);
            }

            /* Consistent spacing and visual hierarchy */
            .grade-header .fa-layer-group {
                color: rgba(255, 255, 255, 0.9);
            }

            .subject-header .fa-book {
                color: rgba(255, 255, 255, 0.9);
            }

            .chapter-header .fa-folder {
                color: rgba(255, 255, 255, 0.9);
            }

            /* Improved visual feedback for expanded states */
            .grade-header[aria-expanded="true"] {
                border-radius: 12px 12px 0 0;
                box-shadow: var(--shadow-md);
            }

            .subject-header[aria-expanded="true"] {
                border-radius: 8px 8px 0 0;
                box-shadow: var(--shadow-sm);
            }

            .chapter-header[aria-expanded="true"] {
                border-radius: 6px 6px 0 0;
                box-shadow: var(--shadow-sm);
            }

            /* Responsive adjustments for colors */
            @media (max-width: 768px) {
                .grade-header,
                .subject-header,
                .chapter-header {
                    padding: 10px 12px;
                }

                .lesson-item {
                    padding: 6px 10px;
                    font-size: 0.85rem;
                }
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

            /* Related Lessons */
            .related-lessons {
                background: #fff;
                border-radius: 16px;
                box-shadow: var(--shadow-lg);
                padding: 24px;
                border: 1px solid var(--border-color);
            }

            .related-lessons h5 {
                color: var(--text-primary);
                font-weight: 700;
                margin-bottom: 20px;
            }

            .related-lesson-item {
                display: flex;
                align-items: center;
                padding: 16px;
                border-radius: 12px;
                margin-bottom: 12px;
                transition: all 0.3s ease;
                text-decoration: none;
                color: inherit;
                border: 1px solid var(--border-color);
                background: #fff;
            }

            .related-lesson-item:hover {
                background: var(--light-color);
                text-decoration: none;
                color: inherit;
                transform: translateY(-2px);
                box-shadow: var(--shadow-md);
                border-color: var(--primary-color);
            }

            .related-lesson-icon {
                width: 48px;
                height: 48px;
                background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
                border-radius: 12px;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                margin-right: 16px;
                flex-shrink: 0;
            }

            .related-lesson-content h6 {
                margin: 0 0 4px 0;
                font-weight: 600;
                color: var(--text-primary);
            }

            .related-lesson-content small {
                color: var(--text-secondary);
            }

            /* Responsive Design */
            @media (max-width: 1200px) {
                .video-player, .video-placeholder {
                    height: 400px;
                }
            }

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

                .video-title {
                    font-size: 1.5rem;
                }
            }

            @media (max-width: 768px) {
                .main-container {
                    padding-top: 80px;
                }

                .content-wrapper {
                    padding: 15px 0;
                }

                .course-sidebar {
                    padding: 16px;
                    max-height: 300px;
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

                .video-meta {
                    gap: 12px;
                }

                .meta-item {
                    font-size: 0.8rem;
                    padding: 6px 10px;
                }

                .related-lessons {
                    padding: 16px;
                }

                .related-lesson-item {
                    padding: 12px;
                }

                .related-lesson-icon {
                    width: 40px;
                    height: 40px;
                    margin-right: 12px;
                }
            }

            @media (max-width: 576px) {
                .video-meta {
                    flex-direction: column;
                    gap: 8px;
                }

                .meta-item {
                    justify-content: center;
                }

                .breadcrumb {
                    font-size: 0.8rem;
                }

                .sidebar-header h5 {
                    font-size: 1rem;
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

            /* Loading Animation */
            .loading-spinner {
                display: inline-block;
                width: 20px;
                height: 20px;
                border: 3px solid rgba(255,255,255,.3);
                border-radius: 50%;
                border-top-color: #fff;
                animation: spin 1s ease-in-out infinite;
            }

            @keyframes spin {
                to {
                    transform: rotate(360deg);
                }
            }

            /* Smooth transitions */
            * {
                transition: color 0.3s ease, background-color 0.3s ease, border-color 0.3s ease;
            }
        </style>
    </head>
    <body>
        <jsp:include page="/header.jsp" />

        <div class="main-container">
            <div class="content-wrapper">
                <div class="container-fluid">
                    <div class="row">
                        <!-- Sidebar -->
                        <div class="col-xl-3 col-lg-4 col-md-12">
                            <div class="course-sidebar">
                                <div class="sidebar-header">
                                    <h5><i class="fas fa-graduation-cap mr-2"></i>Course Library</h5>
                                    <span class="user-role-badge role-${userRole}">
                                        <c:choose>
                                            <c:when test="${userRole == 'student'}">Student</c:when>
                                            <c:when test="${userRole == 'teacher'}">Teacher</c:when>
                                            <c:when test="${userRole == 'admin'}">Administrator</c:when>
                                            <c:when test="${userRole == 'parent'}">Parent</c:when>
                                            <c:otherwise>User</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>

                                <ul class="course-tree">
                                    <c:forEach var="gradeData" items="${courseStructure.grades}">
                                        <li class="grade-item">
                                            <button class="grade-header" type="button" 
                                                    data-toggle="collapse" 
                                                    data-target="#grade-${gradeData.grade.id}"
                                                    aria-expanded="false"
                                                    aria-controls="grade-${gradeData.grade.id}">
                                                <span><i class="fas fa-layer-group mr-2"></i>${gradeData.grade.name}</span>
                                                <i class="fas fa-chevron-down"></i>
                                            </button>

                                            <div class="collapse" id="grade-${gradeData.grade.id}">
                                                <div class="subject-list">
                                                    <c:forEach var="subjectData" items="${gradeData.subjects}">
                                                        <div class="subject-item">
                                                            <button class="subject-header" type="button"
                                                                    data-toggle="collapse" 
                                                                    data-target="#subject-${subjectData.subject.id}"
                                                                    aria-expanded="false"
                                                                    aria-controls="subject-${subjectData.subject.id}">
                                                                <span><i class="fas fa-book mr-2"></i>${subjectData.subject.name}</span>
                                                                <i class="fas fa-chevron-down"></i>
                                                            </button>

                                                            <div class="collapse" id="subject-${subjectData.subject.id}">
                                                                <div class="chapter-list">
                                                                    <c:forEach var="chapterData" items="${subjectData.chapters}">
                                                                        <div class="chapter-item">
                                                                            <button class="chapter-header" type="button"
                                                                                    data-toggle="collapse" 
                                                                                    data-target="#chapter-${chapterData.chapter.id}"
                                                                                    aria-expanded="false"
                                                                                    aria-controls="chapter-${chapterData.chapter.id}">
                                                                                <span><i class="fas fa-folder mr-2"></i>${chapterData.chapter.name}</span>
                                                                                <i class="fas fa-chevron-down"></i>
                                                                            </button>

                                                                            <div class="collapse" id="chapter-${chapterData.chapter.id}">
                                                                                <div class="lesson-list">
                                                                                    <c:forEach var="lesson" items="${chapterData.lessons}">
                                                                                        <a href="/video-viewer?lessonId=${lesson.id}" 
                                                                                           class="lesson-item ${lesson.id == currentLesson.id ? 'active' : ''}">
                                                                                            <i class="fas ${not empty lesson.video_link ? 'fa-play-circle' : 'fa-file-text'}"></i>
                                                                                            <span>${lesson.name}</span>
                                                                                        </a>
                                                                                    </c:forEach>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </c:forEach>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                        </li>
                                    </c:forEach>
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
                                            <a href="/"><i class="fas fa-home mr-1"></i>Home</a>
                                        </li>
                                        <c:if test="${not empty currentGrade}">
                                            <li class="breadcrumb-item">
                                                <a href="#">${currentGrade.name}</a>
                                            </li>
                                        </c:if>
                                        <c:if test="${not empty currentSubject}">
                                            <li class="breadcrumb-item">
                                                <a href="#">${currentSubject.name}</a>
                                            </li>
                                        </c:if>
                                        <c:if test="${not empty currentChapter}">
                                            <li class="breadcrumb-item">
                                                <a href="#">${currentChapter.name}</a>
                                            </li>
                                        </c:if>
                                        <li class="breadcrumb-item active" aria-current="page">
                                            ${currentLesson.name}
                                        </li>
                                    </ol>
                                </nav>
                            </div>

                            <!-- Video Player Section -->
                            <div class="video-container">
                                <c:choose>
                                    <c:when test="${not empty currentLesson.video_link}">
                                        <video class="video-player" controls preload="metadata" id="mainVideo">
                                            <source src="${currentLesson.video_link}" type="video/mp4">
                                            <source src="${currentLesson.video_link}" type="video/webm">
                                            <source src="${currentLesson.video_link}" type="video/ogg">
                                            Your browser does not support the video tag.
                                        </video>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="video-placeholder">
                                            <div class="text-center">
                                                <i class="fas fa-video fa-4x mb-3"></i>
                                                <h4>No Video Available</h4>
                                                <p class="mb-0">This lesson contains text content only.</p>
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                                <div class="video-info">
                                    <h1 class="video-title">${currentLesson.name}</h1>

                                    <div class="video-meta">
                                        <c:if test="${not empty currentSubject}">
                                            <div class="meta-item">
                                                <i class="fas fa-book"></i>
                                                <span>${currentSubject.name}</span>
                                            </div>
                                        </c:if>
                                        <c:if test="${not empty currentChapter}">
                                            <div class="meta-item">
                                                <i class="fas fa-folder"></i>
                                                <span>${currentChapter.name}</span>
                                            </div>
                                        </c:if>
                                        <div class="meta-item">
                                            <i class="fas fa-clock"></i>
                                            <span>${lessonStats.estimatedDuration}</span>
                                        </div>
                                        <c:if test="${lessonStats.hasVideo}">
                                            <div class="meta-item">
                                                <i class="fas fa-play-circle"></i>
                                                <span>Video Available</span>
                                            </div>
                                        </c:if>
                                    </div>

                                    <c:if test="${not empty currentLesson.content}">
                                        <div class="video-description">
                                            <h6><i class="fas fa-info-circle mr-2"></i>Lesson Content</h6>
                                            <p>${currentLesson.content}</p>
                                        </div>
                                    </c:if>
                                </div>
                            </div>

                            <!-- Related Lessons -->
                            <c:if test="${not empty relatedLessons}">
                                <div class="related-lessons">
                                    <h5><i class="fas fa-list mr-2"></i>More Lessons in This Chapter</h5>
                                    <div class="row">
                                        <c:forEach var="relatedLesson" items="${relatedLessons}" varStatus="status">
                                            <div class="col-lg-6 col-md-12">
                                                <a href="/video-viewer?lessonId=${relatedLesson.id}" class="related-lesson-item">
                                                    <div class="related-lesson-icon">
                                                        <i class="fas ${not empty relatedLesson.video_link ? 'fa-play' : 'fa-file-text'}"></i>
                                                    </div>
                                                    <div class="related-lesson-content">
                                                        <h6>${relatedLesson.name}</h6>
                                                        <small>
                                                            ${not empty relatedLesson.video_link ? 'Video Lesson' : 'Text Lesson'}
                                                            <c:if test="${not empty relatedLesson.content}">
                                                                • ${fn:length(relatedLesson.content) > 100 ? 'Long' : 'Short'} content
                                                            </c:if>
                                                        </small>
                                                    </div>
                                                </a>
                                            </div>
                                            <c:if test="${status.index % 2 == 1}">
                                            </div><div class="row">
                                            </c:if>
                                        </c:forEach>
                                    </div>
                                </div>
                            </c:if>

                            <!-- Navigation Buttons -->
                            <div class="row mt-4">
                                <div class="col-6">
                                    <c:if test="${not empty relatedLessons and fn:length(relatedLessons) > 0}">
                                        <a href="/video-viewer?lessonId=${relatedLessons[0].id}" class="btn btn-outline-primary btn-lg btn-block">
                                            <i class="fas fa-arrow-left mr-2"></i>Previous Lesson
                                        </a>
                                    </c:if>
                                </div>
                                <div class="col-6">
                                    <c:if test="${not empty relatedLessons and fn:length(relatedLessons) > 1}">
                                        <a href="/video-viewer?lessonId=${relatedLessons[1].id}" class="btn btn-primary btn-lg btn-block">
                                            Next Lesson<i class="fas fa-arrow-right ml-2"></i>
                                        </a>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="/footer.jsp" />

        <!-- Bootstrap 4 JS -->
        <script src="/assets/js/vendor/jquery-1.12.4.min.js"></script>
        <script src="/assets/js/bootstrap.min.js"></script>

        <script>
            $(document).ready(function () {
                // Auto-expand current lesson's path
                $('.lesson-item.active').parents('.collapse').addClass('show');

                // Set aria
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
                    trigger.find('.fa-chevron-down').removeClass('collapsed');
                });

                $('.collapse').on('hide.bs.collapse', function () {
                    const targetId = $(this).attr('id');
                    const trigger = $('[data-target="#' + targetId + '"]');
                    trigger.attr('aria-expanded', 'false');
                    trigger.find('.fa-chevron-down').addClass('collapsed');
                });

                // Smooth scrolling for lesson navigation
                $('.lesson-item').click(function (e) {
                    // Add loading state
                    if (!$(this).hasClass('active')) {
                        $(this).append('<span class="loading-spinner ml-2"></span>');
                    }
                });

                // Video player enhancements
                const video = document.getElementById('mainVideo');
                if (video) {
                    video.addEventListener('loadedmetadata', function () {
                        console.log('Video loaded successfully');
                        // Update duration in meta if needed
                        const duration = Math.ceil(video.duration / 60);
                        $('.meta-item:contains("minutes")').html('<i class="fas fa-clock"></i><span>' + duration + ' minutes</span>');
                    });

                    video.addEventListener('error', function () {
                        console.log('Error loading video');
                        $(video).parent().html(`
                            <div class="video-placeholder">
                                <div class="text-center">
                                    <i class="fas fa-exclamation-triangle fa-4x mb-3"></i>
                                    <h4>Video Loading Error</h4>
                                    <p class="mb-0">There was an error loading this video. Please try again later.</p>
                                    <button class="btn btn-outline-light mt-3" onclick="location.reload()">
                                        <i class="fas fa-redo mr-2"></i>Retry
                                    </button>
                                </div>
                            </div>
                        `);
                    });

                    // Save video progress (could be enhanced with AJAX)
                    video.addEventListener('timeupdate', function () {
                        if (video.currentTime > 0) {
                            localStorage.setItem('lesson_${currentLesson.id}_progress', video.currentTime);
                        }
                    });

                    // Restore video progress
                    const savedProgress = localStorage.getItem('lesson_${currentLesson.id}_progress');
                    if (savedProgress && savedProgress > 10) {
                        video.currentTime = parseFloat(savedProgress);
                    }
                }

                // Mobile responsive adjustments
                function adjustForMobile() {
                    if ($(window).width() < 768) {
                        // Collapse sidebar by default on mobile except for current lesson path
                        $('.course-sidebar .collapse').not('.lesson-item.active').parents('.collapse').removeClass('show');
                        $('.course-sidebar button[aria-expanded="true"]').not('.lesson-item.active').parents().find('button').attr('aria-expanded', 'false');
                    }
                }

                adjustForMobile();
                $(window).resize(adjustForMobile);

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
                            const prevBtn = $('.btn-outline-primary[href*="lessonId"]');
                            if (prevBtn.length) {
                                window.location.href = prevBtn.attr('href');
                            }
                        }
                        if (e.which === 39) { // Right arrow - next lesson
                            const nextBtn = $('.btn-primary[href*="lessonId"]');
                            if (nextBtn.length) {
                                window.location.href = nextBtn.attr('href');
                            }
                        }
                    }
                });

                // Smooth page transitions
                $('a[href*="video-viewer"]').click(function (e) {
                    const href = $(this).attr('href');
                    if (href && href !== window.location.href) {
                        $('body').fadeOut(200, function () {
                            window.location.href = href;
                        });
                        e.preventDefault();
                    }
                });

                // Show loading on page load
                $(window).on('beforeunload', function () {
                    $('body').fadeOut(200);
                });

                // Fix for nested collapse behavior
                $('.course-tree').on('click', 'button[data-toggle="collapse"]', function (e) {
                    e.stopPropagation();
                    const target = $($(this).data('target'));
                    const isExpanded = $(this).attr('aria-expanded') === 'true';

                    if (isExpanded) {
                        target.collapse('hide');
                    } else {
                        target.collapse('show');
                    }
                });

                // Prevent event bubbling on lesson clicks
                $('.lesson-item').click(function (e) {
                    e.stopPropagation();
                });
            });
        </script>
    </body>
</html>