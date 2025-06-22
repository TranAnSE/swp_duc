<%-- 
    Document   : videoViewer
    Created on : Jun 22, 2025, 6:33:41 PM
    Author     : ankha
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
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
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .main-container {
            padding-top: 100px;
            min-height: 100vh;
        }
        
        /* Sidebar Styles */
        .course-sidebar {
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            padding: 20px;
            height: calc(100vh - 120px);
            overflow-y: auto;
            position: sticky;
            top: 120px;
        }
        
        .sidebar-header {
            border-bottom: 2px solid #e9ecef;
            padding-bottom: 15px;
            margin-bottom: 20px;
        }
        
        .sidebar-header h5 {
            color: #2c3e50;
            font-weight: 600;
            margin: 0;
        }
        
        /* Course Tree Styles */
        .course-tree {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        
        .grade-item {
            margin-bottom: 15px;
        }
        
        .grade-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 12px 15px;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        
        .grade-header:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        
        .grade-header i {
            transition: transform 0.3s ease;
        }
        
        .grade-header.collapsed i {
            transform: rotate(-90deg);
        }
        
        .subject-list {
            background: #f8f9fa;
            border-radius: 0 0 8px 8px;
            padding: 10px;
        }
        
        .subject-item {
            margin-bottom: 10px;
        }
        
        .subject-header {
            background: #e9ecef;
            padding: 8px 12px;
            border-radius: 6px;
            cursor: pointer;
            transition: background 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        
        .subject-header:hover {
            background: #dee2e6;
        }
        
        .chapter-list {
            padding: 8px 0 0 15px;
        }
        
        .chapter-item {
            margin-bottom: 8px;
        }
        
        .chapter-header {
            padding: 6px 10px;
            background: #fff;
            border-left: 3px solid #007bff;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .chapter-header:hover {
            background: #f1f3f4;
            border-left-color: #0056b3;
        }
        
        .lesson-list {
            padding: 5px 0 0 20px;
        }
        
        .lesson-item {
            padding: 5px 10px;
            margin: 2px 0;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
        }
        
        .lesson-item:hover {
            background: #e3f2fd;
        }
        
        .lesson-item.active {
            background: #2196f3;
            color: white;
        }
        
        .lesson-item i {
            margin-right: 8px;
            width: 16px;
        }
        
        /* Video Player Styles */
        .video-container {
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            overflow: hidden;
            margin-bottom: 20px;
        }
        
        .video-player {
            width: 100%;
            height: 400px;
            background: #000;
        }
        
        .video-info {
            padding: 20px;
        }
        
        .video-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 10px;
        }
        
        .video-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-bottom: 15px;
        }
        
        .meta-item {
            display: flex;
            align-items: center;
            color: #6c757d;
            font-size: 0.9rem;
        }
        
        .meta-item i {
            margin-right: 5px;
        }
        
        .video-description {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            border-left: 4px solid #007bff;
        }
        
        /* Related Lessons */
        .related-lessons {
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            padding: 20px;
        }
        
        .related-lesson-item {
            display: flex;
            align-items: center;
            padding: 10px;
            border-radius: 8px;
            margin-bottom: 10px;
            transition: all 0.3s ease;
            text-decoration: none;
            color: inherit;
        }
        
        .related-lesson-item:hover {
            background: #f8f9fa;
            text-decoration: none;
            color: inherit;
        }
        
        .related-lesson-icon {
            width: 40px;
            height: 40px;
            background: #007bff;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            margin-right: 15px;
        }
        
        .related-lesson-content h6 {
            margin: 0;
            font-weight: 600;
        }
        
        .related-lesson-content small {
            color: #6c757d;
        }
        
        /* Responsive Design */
        @media (max-width: 768px) {
            .main-container {
                padding-top: 80px;
            }
            
            .course-sidebar {
                position: static;
                height: auto;
                margin-bottom: 20px;
            }
            
            .video-player {
                height: 250px;
            }
        }
        
        /* Custom Scrollbar */
        .course-sidebar::-webkit-scrollbar {
            width: 6px;
        }
        
        .course-sidebar::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 3px;
        }
        
        .course-sidebar::-webkit-scrollbar-thumb {
            background: #c1c1c1;
            border-radius: 3px;
        }
        
        .course-sidebar::-webkit-scrollbar-thumb:hover {
            background: #a8a8a8;
        }
    </style>
</head>
<body>
    <jsp:include page="/header.jsp" />
    
    <div class="main-container">
        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar -->
                <div class="col-lg-3 col-md-4">
                    <div class="course-sidebar">
                        <div class="sidebar-header">
                            <h5><i class="fas fa-graduation-cap mr-2"></i>Course Navigation</h5>
                        </div>
                        
                        <ul class="course-tree">
                            <c:forEach var="gradeData" items="${courseStructure.grades}">
                                <li class="grade-item">
                                    <div class="grade-header" data-toggle="collapse" data-target="#grade-${gradeData.grade.id}">
                                        <span><i class="fas fa-layer-group mr-2"></i>${gradeData.grade.name}</span>
                                        <i class="fas fa-chevron-down"></i>
                                    </div>
                                    
                                    <div class="collapse show" id="grade-${gradeData.grade.id}">
                                        <div class="subject-list">
                                            <c:forEach var="subjectData" items="${gradeData.subjects}">
                                                <div class="subject-item">
                                                    <div class="subject-header" data-toggle="collapse" data-target="#subject-${subjectData.subject.id}">
                                                        <span><i class="fas fa-book mr-2"></i>${subjectData.subject.name}</span>
                                                        <i class="fas fa-chevron-down"></i>
                                                    </div>
                                                    
                                                    <div class="collapse" id="subject-${subjectData.subject.id}">
                                                        <div class="chapter-list">
                                                            <c:forEach var="chapterData" items="${subjectData.chapters}">
                                                                <div class="chapter-item">
                                                                    <div class="chapter-header" data-toggle="collapse" data-target="#chapter-${chapterData.chapter.id}">
                                                                        <span><i class="fas fa-folder mr-2"></i>${chapterData.chapter.name}</span>
                                                                        <i class="fas fa-chevron-down"></i>
                                                                    </div>
                                                                    
                                                                    <div class="collapse" id="chapter-${chapterData.chapter.id}">
                                                                        <div class="lesson-list">
                                                                            <c:forEach var="lesson" items="${chapterData.lessons}">
                                                                                <a href="/video-viewer?lessonId=${lesson.id}" class="lesson-item ${lesson.id == currentLesson.id ? 'active' : ''}">
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
                <div class="col-lg-9 col-md-8">
                    <!-- Video Player Section -->
                    <div class="video-container">
                        <c:choose>
                            <c:when test="${not empty currentLesson.video_link}">
                                <video class="video-player" controls>
                                    <source src="${currentLesson.video_link}" type="video/mp4">
                                    Your browser does not support the video tag.
                                </video>
                            </c:when>
                            <c:otherwise>
                                <div class="video-player d-flex align-items-center justify-content-center">
                                    <div class="text-center text-white">
                                        <i class="fas fa-video fa-3x mb-3"></i>
                                        <h4>No Video Available</h4>
                                        <p>This lesson doesn't have a video yet.</p>
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                        
                        <div class="video-info">
                            <h1 class="video-title">${currentLesson.name}</h1>
                            
                            <div class="video-meta">
                                <div class="meta-item">
                                    <i class="fas fa-book"></i>
                                    <span>${currentSubject.name}</span>
                                </div>
                                <div class="meta-item">
                                    <i class="fas fa-folder"></i>
                                    <span>${currentChapter.name}</span>
                                </div>
                                <div class="meta-item">
                                    <i class="fas fa-clock"></i>
                                    <span>${lessonStats.estimatedDuration}</span>
                                </div>
                                <div class="meta-item">
                                    <i class="fas fa-signal"></i>
                                    <span>${lessonStats.difficulty}</span>
                                </div>
                            </div>
                            
                            <div class="video-description">
                                <h6><i class="fas fa-info-circle mr-2"></i>Lesson Description</h6>
                                <p>${currentLesson.content}</p>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Related Lessons -->
                    <c:if test="${not empty relatedLessons}">
                        <div class="related-lessons">
                            <h5><i class="fas fa-list mr-2"></i>More Lessons in This Chapter</h5>
                            <div class="row">
                                <c:forEach var="relatedLesson" items="${relatedLessons}">
                                    <div class="col-md-6">
                                        <a href="/video-viewer?lessonId=${relatedLesson.id}" class="related-lesson-item">
                                            <div class="related-lesson-icon">
                                                <i class="fas ${not empty relatedLesson.video_link ? 'fa-play' : 'fa-file-text'}"></i>
                                            </div>
                                            <div class="related-lesson-content">
                                                <h6>${relatedLesson.name}</h6>
                                                <small>${not empty relatedLesson.video_link ? 'Video Lesson' : 'Text Lesson'}</small>
                                            </div>
                                        </a>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="/footer.jsp" />
    
    <!-- Bootstrap 4 JS -->
    <script src="/assets/js/vendor/jquery-1.12.4.min.js"></script>
    <script src="/assets/js/bootstrap.min.js"></script>
    
    <script>
        $(document).ready(function() {
            // Auto-expand current lesson's path
            $('.lesson-item.active').parents('.collapse').addClass('show');
            
            // Smooth scrolling for lesson navigation
            $('.lesson-item').click(function(e) {
                if ($(this).attr('href')) {
                    // Let the default navigation happen
                    return true;
                }
            });
            
            // Video player enhancements
            $('video').on('loadedmetadata', function() {
                console.log('Video loaded successfully');
            });
            
            $('video').on('error', function() {
                console.log('Error loading video');
                $(this).parent().html(`
                    <div class="video-player d-flex align-items-center justify-content-center">
                        <div class="text-center text-white">
                            <i class="fas fa-exclamation-triangle fa-3x mb-3"></i>
                            <h4>Video Loading Error</h4>
                            <p>There was an error loading this video. Please try again later.</p>
                        </div>
                    </div>
                `);
            });
            
            // Collapse/Expand animations
            $('.collapse').on('show.bs.collapse', function() {
                $(this).prev().find('.fa-chevron-down').removeClass('collapsed');
            });
            
            $('.collapse').on('hide.bs.collapse', function() {
                $(this).prev().find('.fa-chevron-down').addClass('collapsed');
            });
        });
    </script>
</body>
</html>
