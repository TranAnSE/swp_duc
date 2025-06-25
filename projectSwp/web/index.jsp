<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!doctype html>
<html class="no-js" lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>Online Learning Platform - Quality Education for Everyone</title>
    <meta name="description" content="Discover quality online courses, interactive lessons, and comprehensive study packages. Join thousands of students advancing their education with expert instructors.">
    <meta name="keywords" content="online learning, education, courses, study packages, interactive lessons, certificates">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="manifest" href="site.webmanifest">
    <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/img/favicon.ico">
    
    <!-- CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/owl.carousel.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/slicknav.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/flaticon.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/progressbar_barfiller.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/gijgo.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/animate.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/animated-headline.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/magnific-popup.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fontawesome-all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/themify-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/slick.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/nice-select.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    
    <style>
        /* Enhanced Custom Styles */
        .hero-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 120px 0;
            position: relative;
            overflow: hidden;
        }
        
        .hero-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0,0,0,0.4);
            z-index: 1;
        }
        
        .hero-content {
            position: relative;
            z-index: 2;
        }
        
        .hero-title {
            font-size: 3.5rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
            line-height: 1.2;
        }
        
        .hero-subtitle {
            font-size: 1.3rem;
            margin-bottom: 2rem;
            opacity: 0.9;
        }
        
        .stats-section {
            background: #f8f9fa;
            padding: 80px 0;
        }
        
        .stat-item {
            text-align: center;
            padding: 30px 20px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            margin-bottom: 30px;
            transition: transform 0.3s ease;
        }
        
        .stat-item:hover {
            transform: translateY(-5px);
        }
        
        .stat-number {
            font-size: 3rem;
            font-weight: bold;
            color: #007bff;
            display: block;
            margin-bottom: 10px;
        }
        
        .stat-label {
            font-size: 1.1rem;
            color: #6c757d;
            font-weight: 500;
        }
        
        .section-title {
            text-align: center;
            margin-bottom: 60px;
        }
        
        .section-title h2 {
            font-size: 2.8rem;
            font-weight: bold;
            color: #333;
            margin-bottom: 20px;
        }
        
        .section-title p {
            font-size: 1.2rem;
            color: #6c757d;
            max-width: 700px;
            margin: 0 auto;
            line-height: 1.6;
        }
        
        .course-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            margin-bottom: 30px;
            overflow: hidden;
            border: 2px solid transparent;
        }
        
        .course-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.15);
            border-color: #007bff;
        }
        
        .course-card-body {
            padding: 30px;
        }
        
        .course-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
        
        .course-grade {
            background: linear-gradient(45deg, #007bff, #0056b3);
            color: white;
            padding: 8px 15px;
            border-radius: 25px;
            font-size: 0.85rem;
            font-weight: 600;
        }
        
        .course-stats {
            font-size: 0.9rem;
            color: #6c757d;
        }
        
        .course-title {
            font-size: 1.4rem;
            font-weight: bold;
            color: #333;
            margin-bottom: 15px;
            line-height: 1.3;
        }
        
        .package-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            margin-bottom: 30px;
            overflow: hidden;
            border: 2px solid transparent;
            position: relative;
        }
        
        .package-card.popular::before {
            content: 'Most Popular';
            position: absolute;
            top: 20px;
            right: -30px;
            background: #28a745;
            color: white;
            padding: 5px 40px;
            font-size: 0.8rem;
            font-weight: 600;
            transform: rotate(45deg);
            z-index: 2;
        }
        
        .package-card:hover {
            transform: translateY(-8px);
            border-color: #007bff;
            box-shadow: 0 15px 35px rgba(0,0,0,0.15);
        }
        
        .package-header {
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
            padding: 30px;
            text-align: center;
        }
        
        .package-type {
            font-size: 1.5rem;
            font-weight: bold;
            margin-bottom: 10px;
        }
        
        .package-price {
            font-size: 3rem;
            font-weight: bold;
            margin-bottom: 10px;
        }
        
        .package-description {
            opacity: 0.9;
            font-size: 1rem;
        }
        
        .package-features {
            padding: 30px;
        }
        
        .feature-list {
            list-style: none;
            padding: 0;
            margin-bottom: 30px;
        }
        
        .feature-list li {
            padding: 10px 0;
            border-bottom: 1px solid #eee;
            position: relative;
            padding-left: 30px;
        }
        
        .feature-list li:before {
            content: '✓';
            position: absolute;
            left: 0;
            color: #28a745;
            font-weight: bold;
            font-size: 1.2rem;
        }
        
        .lesson-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            margin-bottom: 25px;
            overflow: hidden;
        }
        
        .lesson-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
        }
        
        .lesson-card-body {
            padding: 25px;
        }
        
        .lesson-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
        
        .lesson-difficulty {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }
        
        .lesson-difficulty.beginner {
            background: #d4edda;
            color: #155724;
        }
        
        .lesson-difficulty.intermediate {
            background: #fff3cd;
            color: #856404;
        }
        
        .lesson-difficulty.advanced {
            background: #f8d7da;
            color: #721c24;
        }
        
        .lesson-duration {
            color: #6c757d;
            font-size: 0.9rem;
        }
        
        .lesson-title {
            font-size: 1.2rem;
            font-weight: 600;
            color: #333;
            margin-bottom: 10px;
            line-height: 1.4;
        }
        
        .lesson-path {
            color: #007bff;
            font-size: 0.9rem;
            margin-bottom: 15px;
        }
        
        .why-choose-section {
            background: #f8f9fa;
            padding: 100px 0;
        }
        
        .feature-item {
            text-align: center;
            padding: 40px 20px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            margin-bottom: 30px;
            transition: all 0.3s ease;
        }
        
        .feature-item:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
        }
        
        .feature-icon {
            font-size: 3.5rem;
            color: #007bff;
            margin-bottom: 25px;
        }
        
        .feature-title {
            font-size: 1.3rem;
            font-weight: bold;
            color: #333;
            margin-bottom: 15px;
        }
        
        .learning-path-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            margin-bottom: 30px;
            overflow: hidden;
            border-left: 5px solid #007bff;
        }
        
        .learning-path-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.15);
        }
        
        .path-card-body {
            padding: 30px;
        }
        
        .path-icon {
            font-size: 2.5rem;
            color: #007bff;
            margin-bottom: 20px;
        }
        
        .testimonial-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 100px 0;
        }
        
        .testimonial-card {
            background: rgba(255,255,255,0.1);
            border-radius: 15px;
            padding: 40px 30px;
            text-align: center;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255,255,255,0.2);
            margin-bottom: 30px;
        }
        
        .testimonial-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            margin: 0 auto 20px;
            background: #007bff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            color: white;
        }
        
        .testimonial-content {
            font-size: 1.1rem;
            line-height: 1.6;
            margin-bottom: 20px;
            font-style: italic;
        }
        
        .testimonial-author {
            font-weight: bold;
            margin-bottom: 5px;
        }
        
        .testimonial-role {
            opacity: 0.8;
            font-size: 0.9rem;
        }
        
        .cta-section {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            padding: 100px 0;
            text-align: center;
        }
        
        .btn-custom {
            background: linear-gradient(45deg, #007bff, #0056b3);
            color: white;
            border: none;
            padding: 15px 35px;
            border-radius: 30px;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            box-shadow: 0 4px 15px rgba(0,123,255,0.3);
        }
        
        .btn-custom:hover {
            background: linear-gradient(45deg, #0056b3, #004085);
            color: white;
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0,123,255,0.4);
            text-decoration: none;
        }
        
        .btn-outline-custom {
            border: 2px solid white;
            color: white;
            background: transparent;
            padding: 15px 35px;
            border-radius: 30px;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-outline-custom:hover {
            background: white;
            color: #007bff;
            transform: translateY(-3px);
            text-decoration: none;
        }
        
        /* Responsive adjustments */
        @media (max-width: 768px) {
            .hero-title {
                font-size: 2.5rem;
            }
            
            .section-title h2 {
                font-size: 2.2rem;
            }
            
            .stat-number {
                font-size: 2.5rem;
            }
        }
    </style>
</head>

<body>
    <!-- Preloader Start -->
    <div id="preloader-active">
        <div class="preloader d-flex align-items-center justify-content-center">
            <div class="preloader-inner position-relative">
                <div class="preloader-circle"></div>
                <div class="preloader-img pere-text">
                    <img src="${pageContext.request.contextPath}/assets/img/logo/loder.png" alt="">
                </div>
            </div>
        </div>
    </div>
    <!-- Preloader End -->

    <!-- Header Start -->
    <jsp:include page="header.jsp" />
    <!-- Header End -->

    <main>
        <!-- Hero Section Start -->
        <section class="hero-section">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-lg-6">
                        <div class="hero-content">
                            <h1 class="hero-title">
                                Transform Your Future with 
                                <span style="color: #ffd700;">Quality Education</span>
                            </h1>
                            <p class="hero-subtitle">
                                Join over ${stats.totalStudents} students worldwide in our comprehensive online learning platform. 
                                Master new skills, earn certificates, and advance your career with expert-led courses.
                            </p>
                            <div class="hero-buttons mt-4">
                                <a href="${pageContext.request.contextPath}/login" class="btn-custom mr-3">
                                    <i class="fas fa-play mr-2"></i>Start Learning Now
                                </a>
                                <a href="#why-choose" class="btn-outline-custom">
                                    <i class="fas fa-info-circle mr-2"></i>Learn More
                                </a>
                            </div>
                            <div class="mt-4">
                                <small style="opacity: 0.8;">
                                    <i class="fas fa-star text-warning"></i>
                                    <i class="fas fa-star text-warning"></i>
                                    <i class="fas fa-star text-warning"></i>
                                    <i class="fas fa-star text-warning"></i>
                                    <i class="fas fa-star text-warning"></i>
                                    ${stats.satisfaction} rating from ${stats.totalStudents} students
                                </small>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-6">
                        <div class="hero-image text-center">
                            <div style="position: relative;">
                                <i class="fas fa-graduation-cap" style="font-size: 12rem; opacity: 0.3; color: #ffd700;"></i>
                                <div style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%);">
                                    <div class="d-flex justify-content-center">
                                        <div class="text-center mx-3">
                                            <i class="fas fa-book" style="font-size: 2rem; color: #ffd700;"></i>
                                            <div style="font-size: 0.9rem; margin-top: 5px;">${stats.totalLessons}+ Lessons</div>
                                        </div>
                                        <div class="text-center mx-3">
                                            <i class="fas fa-users" style="font-size: 2rem; color: #ffd700;"></i>
                                            <div style="font-size: 0.9rem; margin-top: 5px;">${stats.totalStudents} Students</div>
                                        </div>
                                        <div class="text-center mx-3">
                                            <i class="fas fa-certificate" style="font-size: 2rem; color: #ffd700;"></i>
                                            <div style="font-size: 0.9rem; margin-top: 5px;">${stats.completionRate} Success</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <!-- Hero Section End -->

        <!-- Stats Section Start -->
        <section class="stats-section">
            <div class="container">
                <div class="row">
                    <div class="col-lg-3 col-md-6">
                        <div class="stat-item">
                            <i class="fas fa-book mb-3" style="font-size: 2.5rem; color: #007bff;"></i>
                            <span class="stat-number">${stats.totalSubjects}</span>
                            <div class="stat-label">Subjects Available</div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <div class="stat-item">
                            <i class="fas fa-play-circle mb-3" style="font-size: 2.5rem; color: #28a745;"></i>
                            <span class="stat-number">${stats.totalLessons}</span>
                            <div class="stat-label">Interactive Lessons</div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <div class="stat-item">
                            <i class="fas fa-users mb-3" style="font-size: 2.5rem; color: #ffc107;"></i>
                            <span class="stat-number">${stats.totalStudents}</span>
                            <div class="stat-label">Happy Students</div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <div class="stat-item">
                            <i class="fas fa-trophy mb-3" style="font-size: 2.5rem; color: #dc3545;"></i>
                            <span class="stat-number">${stats.completionRate}</span>
                            <div class="stat-label">Success Rate</div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <!-- Stats Section End -->

        <!-- Featured Subjects Section Start -->
        <section class="py-5" style="padding: 100px 0;">
            <div class="container">
                <div class="section-title">
                    <h2>Popular Subjects</h2>
                    <p>Discover our most sought-after subjects, carefully designed by expert educators to provide comprehensive learning experiences</p>
                </div>
                <div class="row">
                    <c:forEach var="subjectInfo" items="${featuredSubjects}">
                        <div class="col-lg-4 col-md-6">
                            <div class="course-card">
                                <div class="course-card-body">
                                    <div class="course-meta">
                                        <div class="course-grade">${subjectInfo.grade.name}</div>
                                        <div class="course-stats">
                                            <i class="fas fa-book"></i> ${subjectInfo.chapterCount} Chapters
                                            <span class="ml-2"><i class="fas fa-play"></i> ${subjectInfo.lessonCount} Lessons</span>
                                        </div>
                                    </div>
                                    <h5 class="course-title">${subjectInfo.subject.name}</h5>
                                    <p class="text-muted mb-4">${subjectInfo.subject.description}</p>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <a href="${pageContext.request.contextPath}/subjects" class="btn-custom">Explore Subject</a>
                                        <div class="text-muted small">
                                            <i class="fas fa-clock"></i> Self-paced
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                <div class="text-center mt-5">
                    <a href="${pageContext.request.contextPath}/subjects" class="btn-custom">
                        <i class="fas fa-th-large mr-2"></i>View All Subjects
                    </a>
                </div>
            </div>
        </section>
        <!-- Featured Subjects Section End -->

        <!-- Why Choose Us Section Start -->
        <section id="why-choose" class="why-choose-section">
            <div class="container">
                <div class="section-title">
                    <h2>Why Choose Our Platform?</h2>
                    <p>We're committed to providing the best online learning experience with innovative features and expert support</p>
                </div>
                <div class="row">
                    <c:forEach var="feature" items="${features}">
                        <div class="col-lg-4 col-md-6">
                            <div class="feature-item">
                                <div class="feature-icon">
                                    <i class="${feature.icon}"></i>
                                </div>
                                <h5 class="feature-title">${feature.title}</h5>
                                <p class="text-muted">${feature.description}</p>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </section>
        <!-- Why Choose Us Section End -->

        <!-- Study Packages Section Start -->
        <section class="py-5" style="padding: 100px 0;">
            <div class="container">
                <div class="section-title">
                    <h2>Choose Your Learning Package</h2>
                    <p>Select the perfect package that matches your learning goals and budget. All packages include lifetime access and certificates</p>
                </div>
                <div class="row">
                    <c:forEach var="packageInfo" items="${enhancedPackages}">
                        <div class="col-lg-3 col-md-6">
                            <div class="package-card ${packageInfo.popular ? 'popular' : ''}">
                                <div class="package-header">
                                    <div class="package-type">${packageInfo.type}</div>
                                    <div class="package-price">$${packageInfo.pkg.price}</div>
                                    <div class="package-description">${packageInfo.description}</div>
                                </div>
                                <div class="package-features">
                                    <ul class="feature-list">
                                        <c:forEach var="feature" items="${packageInfo.features}">
                                            <li>${feature}</li>
                                        </c:forEach>
                                    </ul>
                                    <div class="text-center">
                                        <a href="${pageContext.request.contextPath}/study_package?service=detail&id=${packageInfo.pkg.id}" class="btn-custom">
                                            Choose ${packageInfo.type}
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                <div class="text-center mt-5">
                    <p class="text-muted mb-3">
                        <i class="fas fa-shield-alt text-success"></i> 30-day money-back guarantee
                        <span class="mx-3"><i class="fas fa-sync text-primary"></i> Lifetime access</span>
                        <i class="fas fa-mobile-alt text-info"></i> Mobile learning support
                    </p>
                    <a href="${pageContext.request.contextPath}/study_package" class="btn-outline-custom">Compare All Packages</a>
                </div>
            </div>
        </section>
        <!-- Study Packages Section End -->

        <!-- Learning Paths Section Start -->
        <section id="learning-paths" class="py-5 bg-light" style="padding: 100px 0;">
            <div class="container">
                <div class="section-title">
                    <h2>Structured Learning Paths</h2>
                    <p>Follow our expertly designed learning paths to master subjects systematically and efficiently</p>
                </div>
                <div class="row">
                    <c:forEach var="path" items="${learningPaths}">
                        <div class="col-lg-6">
                            <div class="learning-path-card">
                                <div class="path-card-body">
                                    <div class="d-flex align-items-start">
                                        <div class="path-icon mr-4">
                                            <i class="${path.icon}"></i>
                                        </div>
                                        <div class="flex-grow-1">
                                            <h5 class="font-weight-bold mb-2">${path.title}</h5>
                                            <p class="text-muted mb-3">${path.description}</p>
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div>
                                                    <span class="badge badge-primary">${path.courseCount}</span>
                                                    <span class="badge badge-outline-secondary ml-2">${path.level}</span>
                                                </div>
                                                <a href="${pageContext.request.contextPath}/subjects" class="btn btn-outline-primary btn-sm">
                                                    Start Path <i class="fas fa-arrow-right ml-1"></i>
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </section>
        <!-- Learning Paths Section End -->

        <!-- Recent Lessons Section Start -->
        <section class="py-5" style="padding: 100px 0;">
            <div class="container">
                <div class="section-title">
                    <h2>Latest Lessons</h2>
                    <p>Stay updated with our newest educational content, created by expert instructors</p>
                </div>
                <div class="row">
                    <c:forEach var="lessonInfo" items="${recentLessonsWithInfo}">
                        <div class="col-lg-3 col-md-6">
                            <div class="lesson-card">
                                <div class="lesson-card-body">
                                    <div class="lesson-meta">
                                        <span class="lesson-difficulty ${lessonInfo.difficulty.toLowerCase()}">${lessonInfo.difficulty}</span>
                                        <span class="lesson-duration">
                                            <i class="fas fa-clock"></i> ${lessonInfo.duration} min
                                        </span>
                                    </div>
                                    <h6 class="lesson-title">${lessonInfo.lesson.name}</h6>
                                    <div class="lesson-path">
                                        <i class="fas fa-folder"></i> ${lessonInfo.subject.name} > ${lessonInfo.chapter.name}
                                    </div>
                                    <p class="text-muted small mb-3">
                                        ${fn:length(lessonInfo.lesson.content) > 80 ? 
                                          fn:substring(lessonInfo.lesson.content, 0, 80).concat("...") : 
                                          lessonInfo.lesson.content}
                                    </p>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <a href="${pageContext.request.contextPath}/video-viewer?lessonId=${lessonInfo.lesson.id}" class="btn btn-primary btn-sm">
                                            <i class="fas fa-play"></i> Watch
                                        </a>
                                        <small class="text-muted">${lessonInfo.grade.name}</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                <div class="text-center mt-5">
                    <a href="${pageContext.request.contextPath}/LessonURL" class="btn-custom">
                        <i class="fas fa-play-circle mr-2"></i>Browse All Lessons
                    </a>
                </div>
            </div>
        </section>
        <!-- Recent Lessons Section End -->

        <!-- Testimonials Section Start -->
        <section id="testimonials" class="testimonial-section">
            <div class="container">
                <div class="section-title">
                    <h2 style="color: white;">What Our Students Say</h2>
                    <p style="color: rgba(255,255,255,0.9);">Real success stories from our learning community</p>
                </div>
                <div class="row">
                    <c:forEach var="testimonial" items="${testimonials}">
                        <div class="col-lg-3 col-md-6">
                            <div class="testimonial-card">
                                <div class="testimonial-avatar">
                                    ${fn:substring(testimonial.name, 0, 1)}
                                </div>
                                <div class="testimonial-content">
                                    "${testimonial.content}"
                                </div>
                                <div class="testimonial-author">${testimonial.name}</div>
                                <div class="testimonial-role">${testimonial.role}</div>
                                <div class="mt-2">
                                    <i class="fas fa-star text-warning"></i>
                                    <i class="fas fa-star text-warning"></i>
                                    <i class="fas fa-star text-warning"></i>
                                    <i class="fas fa-star text-warning"></i>
                                    <i class="fas fa-star text-warning"></i>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </section>
        <!-- Testimonials Section End -->

        <!-- CTA Section Start -->
        <section class="cta-section">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-lg-8 text-center">
                        <h2 class="display-4 font-weight-bold mb-4">Ready to Start Your Learning Journey?</h2>
                        <p class="lead mb-4">
                            Join thousands of successful students who have transformed their careers with our comprehensive learning platform. 
                            Start your free trial today!
                        </p>
                        <div class="mb-4">
                            <a href="${pageContext.request.contextPath}/register.jsp" class="btn-outline-custom mr-3">
                                <i class="fas fa-rocket mr-2"></i>Start Free Trial
                            </a>
                            <a href="${pageContext.request.contextPath}/contact" class="btn-outline-custom">
                                <i class="fas fa-phone mr-2"></i>Talk to an Expert
                            </a>
                        </div>
                        <small style="opacity: 0.8;">
                            <i class="fas fa-check-circle mr-2"></i>No credit card required
                            <span class="mx-3"><i class="fas fa-times-circle mr-2"></i>Cancel anytime</span>
                            <i class="fas fa-shield-alt mr-2"></i>100% secure
                        </small>
                    </div>
                </div>
            </div>
        </section>
        <!-- CTA Section End -->
    </main>

    <!-- Footer Start -->
    <jsp:include page="footer.jsp" />
    <!-- Footer End -->

    <!-- Scroll Up -->
    <div id="back-top" style="position: fixed; right: 20px; bottom: 20px; z-index: 9998;">
        <a title="Go to Top" href="#" style="display: flex; align-items: center; justify-content: center;
            width: 50px; height: 50px; background: linear-gradient(45deg, #007bff, #0056b3); color: white;
            border-radius: 50%; box-shadow: 0 4px 15px rgba(0,123,255,0.3); text-decoration: none; transition: all 0.3s ease;">
            <i class="fas fa-chevron-up" style="font-size: 18px;"></i>
        </a>
    </div>

    <!-- JS -->
    <script src="${pageContext.request.contextPath}/assets/js/vendor/modernizr-3.5.0.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/vendor/jquery-1.12.4.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/popper.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.slicknav.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/owl.carousel.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/slick.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/wow.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/animated.headline.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.magnific-popup.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/gijgo.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.nice-select.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.sticky.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.barfiller.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.counterup.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/waypoints.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.countdown.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/hover-direction-snake.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/contact.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.form.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.validate.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/mail-script.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.ajaxchimp.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/plugins.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>

    <!-- Custom JS for enhanced homepage -->
    <script>
        $(document).ready(function() {
            // Enhanced stats counter animation
            $('.stat-number').each(function() {
                var $this = $(this);
                var countTo = $this.text().replace(/[^0-9]/g, '');
                var originalText = $this.text();
                
                if (countTo) {
                    $({ countNum: 0 }).animate({
                        countNum: countTo
                    }, {
                        duration: 2500,
                        easing: 'swing',
                        step: function() {
                            $this.text(Math.floor(this.countNum) + originalText.replace(/[0-9]/g, '').replace(/\+/g, ''));
                        },
                        complete: function() {
                            $this.text(originalText);
                        }
                    });
                }
            });

            // Smooth scrolling for anchor links
            $('a[href^="#"]').on('click', function(event) {
                var target = $(this.getAttribute('href'));
                if(target.length) {
                    event.preventDefault();
                    $('html, body').stop().animate({
                        scrollTop: target.offset().top - 100
                    }, 1000, 'easeInOutExpo');
                }
            });

            // Enhanced scroll animations
            $(window).scroll(function() {
                var scrollTop = $(window).scrollTop();
                var windowHeight = $(window).height();
                
                $('.course-card, .package-card, .lesson-card, .feature-item, .learning-path-card, .testimonial-card').each(function() {
                    var elementTop = $(this).offset().top;
                    var elementHeight = $(this).outerHeight();
                    
                    if (scrollTop + windowHeight > elementTop + 100) {
                        $(this).addClass('animate__animated animate__fadeInUp');
                    }
                });
            });

            // Package card hover effects
            $('.package-card').hover(
                function() {
                    $(this).find('.package-header').css('transform', 'scale(1.02)');
                },
                function() {
                    $(this).find('.package-header').css('transform', 'scale(1)');
                }
            );

            // Testimonial rotation
            let testimonialIndex = 0;
            const testimonials = $('.testimonial-card');
            
            setInterval(function() {
                testimonials.removeClass('active');
                testimonials.eq(testimonialIndex).addClass('active');
                testimonialIndex = (testimonialIndex + 1) % testimonials.length;
            }, 5000);

            // Parallax effect for hero section
            $(window).scroll(function() {
                var scrolled = $(window).scrollTop();
                var parallax = $('.hero-section');
                var speed = scrolled * 0.5;
                
                parallax.css('background-position', 'center ' + speed + 'px');
            });

            // Loading animation for cards
            $('.course-card, .package-card, .lesson-card').each(function(index) {
                $(this).css('animation-delay', (index * 0.1) + 's');
            });

            // Enhanced button hover effects
            $('.btn-custom, .btn-outline-custom').hover(
                function() {
                    $(this).css('transform', 'translateY(-2px) scale(1.05)');
                },
                function() {
                    $(this).css('transform', 'translateY(0) scale(1)');
                }
            );

            // Tooltip initialization
            $('[data-toggle="tooltip"]').tooltip();

            // Back to top button functionality
            $(window).scroll(function() {
                if ($(this).scrollTop() > 300) {
                    $('#back-top').fadeIn();
                } else {
                    $('#back-top').fadeOut();
                }
            });

            $('#back-top a').click(function(e) {
                e.preventDefault();
                $('html, body').animate({scrollTop: 0}, 800);
            });

            // Mobile menu enhancements
            $('.mobile_menu').slicknav({
                prependTo: '.mobile_menu',
                closeOnClick: true,
                allowParentLinks: true
            });

            // Search functionality (if search box exists)
            $('#search-input').on('keyup', function() {
                var value = $(this).val().toLowerCase();
                $('.course-card, .lesson-card').filter(function() {
                    $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1);
                });
            });

            // Newsletter subscription (if form exists)
            $('#newsletter-form').on('submit', function(e) {
                e.preventDefault();
                var email = $('#newsletter-email').val();
                
                if (email) {
                    // Show success message
                    alert('Thank you for subscribing! We\'ll keep you updated with our latest courses and offers.');
                    $('#newsletter-email').val('');
                }
            });

            // Course card click tracking
            $('.course-card').click(function() {
                var courseName = $(this).find('.course-title').text();
                console.log('Course clicked:', courseName);
                // Add analytics tracking here if needed
            });

            // Package selection tracking
            $('.package-card .btn-custom').click(function() {
                var packageType = $(this).closest('.package-card').find('.package-type').text();
                console.log('Package selected:', packageType);
                // Add conversion tracking here if needed
            });
        });

        // Lazy loading for images (if implemented)
        if ('IntersectionObserver' in window) {
            const imageObserver = new IntersectionObserver((entries, observer) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        const img = entry.target;
                        img.src = img.dataset.src;
                        img.classList.remove('lazy');
                        imageObserver.unobserve(img);
                    }
                });
            });

            document.querySelectorAll('img[data-src]').forEach(img => {
                imageObserver.observe(img);
            });
        }

        // Performance optimization
        window.addEventListener('load', function() {
            // Remove preloader
            $('#preloader-active').fadeOut('slow');
            
            // Initialize animations
            $('.animate__animated').css('visibility', 'visible');
        });
    </script>

    <!-- Schema.org structured data for SEO -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "EducationalOrganization",
        "name": "Online Learning Platform",
        "description": "Quality online education platform offering comprehensive courses, interactive lessons, and expert instruction",
        "url": "${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/",
        "logo": "${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/assets/img/logo/logo.png",
        "contactPoint": {
            "@type": "ContactPoint",
            "telephone": "+1-555-123-4567",
            "contactType": "customer service",
            "availableLanguage": "English"
        },
        "sameAs": [
            "https://facebook.com/yourpage",
            "https://twitter.com/yourpage",
            "https://linkedin.com/company/yourpage"
        ],
        "offers": {
            "@type": "Offer",
            "category": "Education",
            "availability": "https://schema.org/InStock"
        }
    }
    </script>

</body>
</html>