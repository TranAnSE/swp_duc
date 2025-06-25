<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!doctype html>
<html class="no-js" lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>EduLearn - Modern Online Learning Platform</title>
    <meta name="description" content="Transform your future with quality online education. Interactive courses, expert instructors, and comprehensive learning paths.">
    <meta name="keywords" content="online learning, education, courses, study packages, interactive lessons, certificates">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="manifest" href="site.webmanifest">
    <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/img/favicon.ico">
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
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
        /* Modern Color Palette & Typography */
        :root {
            --primary-color: #4F46E5;
            --primary-dark: #3730A3;
            --primary-light: #6366F1;
            --secondary-color: #06B6D4;
            --secondary-dark: #0891B2;
            --accent-color: #F59E0B;
            --success-color: #10B981;
            --warning-color: #F59E0B;
            --error-color: #EF4444;
            --dark-color: #1F2937;
            --gray-900: #111827;
            --gray-800: #1F2937;
            --gray-700: #374151;
            --gray-600: #4B5563;
            --gray-500: #6B7280;
            --gray-400: #9CA3AF;
            --gray-300: #D1D5DB;
            --gray-200: #E5E7EB;
            --gray-100: #F3F4F6;
            --gray-50: #F9FAFB;
            --white: #FFFFFF;
            --gradient-primary: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            --gradient-secondary: linear-gradient(135deg, var(--secondary-color) 0%, var(--primary-color) 100%);
            --gradient-accent: linear-gradient(135deg, var(--accent-color) 0%, var(--warning-color) 100%);
            --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
            --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            --shadow-xl: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
            --border-radius: 12px;
            --border-radius-lg: 16px;
            --border-radius-xl: 20px;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            line-height: 1.6;
            color: var(--gray-800);
            background-color: var(--white);
        }

        h1, h2, h3, h4, h5, h6 {
            font-family: 'Poppins', sans-serif;
            font-weight: 600;
            line-height: 1.3;
            color: var(--gray-900);
        }

        /* Hero Section - Modern Design */
        .hero-section {
            background: var(--gradient-primary);
            color: var(--white);
            padding: 120px 0 80px;
            position: relative;
            overflow: hidden;
            min-height: 100vh;
            display: flex;
            align-items: center;
        }

        .hero-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1000 1000"><defs><radialGradient id="a" cx="50%" cy="50%"><stop offset="0%" stop-color="%23ffffff" stop-opacity="0.1"/><stop offset="100%" stop-color="%23ffffff" stop-opacity="0"/></radialGradient></defs><circle cx="200" cy="200" r="100" fill="url(%23a)"/><circle cx="800" cy="300" r="150" fill="url(%23a)"/><circle cx="400" cy="700" r="120" fill="url(%23a)"/></svg>') no-repeat center/cover;
            opacity: 0.3;
            z-index: 1;
        }

        .hero-content {
            position: relative;
            z-index: 2;
        }

        .hero-title {
            font-size: clamp(2.5rem, 5vw, 4rem);
            font-weight: 800;
            margin-bottom: 1.5rem;
            line-height: 1.1;
            background: linear-gradient(135deg, var(--white) 0%, #E0E7FF 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .hero-subtitle {
            font-size: 1.25rem;
            margin-bottom: 2.5rem;
            opacity: 0.95;
            font-weight: 400;
            max-width: 600px;
        }

        .hero-buttons {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
            margin-bottom: 3rem;
        }

        .hero-stats {
            display: flex;
            gap: 2rem;
            flex-wrap: wrap;
            align-items: center;
        }

        .hero-stat-item {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            background: rgba(255, 255, 255, 0.1);
            padding: 0.75rem 1.25rem;
            border-radius: var(--border-radius);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .hero-stat-icon {
            font-size: 1.5rem;
            color: var(--accent-color);
        }

        .hero-stat-text {
            font-size: 0.875rem;
            font-weight: 500;
        }

        /* Modern Button Styles */
        .btn-modern {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            padding: 1rem 2rem;
            border-radius: var(--border-radius);
            font-weight: 600;
            font-size: 1rem;
            text-decoration: none;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            border: none;
            cursor: pointer;
            position: relative;
            overflow: hidden;
        }

        .btn-modern::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: left 0.5s;
        }

        .btn-modern:hover::before {
            left: 100%;
        }

        .btn-primary {
            background: var(--white);
            color: var(--primary-color);
            box-shadow: var(--shadow-lg);
        }

        .btn-primary:hover {
            background: var(--gray-50);
            color: var(--primary-dark);
            transform: translateY(-2px);
            box-shadow: var(--shadow-xl);
            text-decoration: none;
        }

        .btn-outline {
            background: transparent;
            color: var(--white);
            border: 2px solid rgba(255, 255, 255, 0.3);
            backdrop-filter: blur(10px);
        }

        .btn-outline:hover {
            background: rgba(255, 255, 255, 0.1);
            color: var(--white);
            border-color: rgba(255, 255, 255, 0.5);
            text-decoration: none;
        }

        /* Stats Section */
        .stats-section {
            background: var(--gray-50);
            padding: 80px 0;
            margin-top: -40px;
            position: relative;
            z-index: 3;
        }

        .stats-container {
            background: var(--white);
            border-radius: var(--border-radius-xl);
            padding: 3rem 2rem;
            box-shadow: var(--shadow-xl);
            margin: -60px auto 0;
            max-width: 1200px;
        }

        .stat-item {
            text-align: center;
            padding: 2rem 1rem;
            border-radius: var(--border-radius-lg);
            transition: all 0.3s ease;
            position: relative;
        }

        .stat-item:hover {
            transform: translateY(-5px);
        }

        .stat-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 60px;
            height: 4px;
            background: var(--gradient-primary);
            border-radius: 2px;
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .stat-item:hover::before {
            opacity: 1;
        }

        .stat-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
            background: var(--gradient-primary);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .stat-number {
            font-size: 3rem;
            font-weight: 800;
            color: var(--gray-900);
            display: block;
            margin-bottom: 0.5rem;
            font-family: 'Poppins', sans-serif;
        }

        .stat-label {
            font-size: 1rem;
            color: var(--gray-600);
            font-weight: 500;
        }

        /* Section Styling */
        .section-modern {
            padding: 100px 0;
        }

        .section-title {
            text-align: center;
            margin-bottom: 4rem;
            max-width: 800px;
            margin-left: auto;
            margin-right: auto;
        }

        .section-title h2 {
            font-size: clamp(2rem, 4vw, 3rem);
            font-weight: 700;
            margin-bottom: 1.5rem;
            background: var(--gradient-primary);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .section-title p {
            font-size: 1.125rem;
            color: var(--gray-600);
            line-height: 1.7;
        }

        /* Card Designs */
        .card-modern {
            background: var(--white);
            border-radius: var(--border-radius-lg);
            box-shadow: var(--shadow-md);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            border: 1px solid var(--gray-200);
            overflow: hidden;
            height: 100%;
        }

        .card-modern:hover {
            transform: translateY(-8px);
            box-shadow: var(--shadow-xl);
            border-color: var(--primary-color);
        }

        .card-header-modern {
            padding: 1.5rem;
            border-bottom: 1px solid var(--gray-200);
            background: var(--gray-50);
        }

        .card-body-modern {
            padding: 2rem;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
        }

        /* Course Cards */
        .course-card {
            position: relative;
        }

        .course-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }

        .course-badge {
            background: var(--gradient-primary);
            color: var(--white);
            padding: 0.5rem 1rem;
            border-radius: 50px;
            font-size: 0.875rem;
            font-weight: 600;
        }

        .course-stats {
            display: flex;
            gap: 1rem;
            font-size: 0.875rem;
            color: var(--gray-500);
        }

        .course-title {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 1rem;
            color: var(--gray-900);
        }

        .course-description {
            color: var(--gray-600);
            margin-bottom: 1.5rem;
            flex-grow: 1;
        }

        .course-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 1rem;
            border-top: 1px solid var(--gray-200);
        }

        /* Package Cards */
        .package-card {
            position: relative;
            background: var(--white);
            border-radius: var(--border-radius-lg);
            overflow: hidden;
            box-shadow: var(--shadow-lg);
            transition: all 0.3s ease;
        }

        .package-card.popular {
            transform: scale(1.05);
            border: 2px solid var(--primary-color);
        }

        .package-card.popular::before {
            content: 'Most Popular';
            position: absolute;
            top: 1rem;
            right: -2rem;
            background: var(--accent-color);
            color: var(--white);
            padding: 0.5rem 3rem;
            font-size: 0.875rem;
            font-weight: 600;
            transform: rotate(45deg);
            z-index: 2;
        }

        .package-header {
            background: var(--gradient-primary);
            color: var(--white);
            padding: 2.5rem 2rem;
            text-align: center;
        }

        .package-type {
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .package-price {
            font-size: 3.5rem;
            font-weight: 800;
            margin-bottom: 0.5rem;
            font-family: 'Poppins', sans-serif;
        }

        .package-description {
            opacity: 0.9;
            font-size: 1rem;
        }

        .package-features {
            padding: 2rem;
        }

        .feature-list {
            list-style: none;
            padding: 0;
            margin-bottom: 2rem;
        }

        .feature-list li {
            padding: 0.75rem 0;
            border-bottom: 1px solid var(--gray-200);
            position: relative;
            padding-left: 2rem;
            color: var(--gray-700);
        }

        .feature-list li:last-child {
            border-bottom: none;
        }

        .feature-list li::before {
            content: '✓';
            position: absolute;
            left: 0;
            color: var(--success-color);
            font-weight: bold;
            font-size: 1.25rem;
        }

        /* Feature Items */
        .feature-item {
            text-align: center;
            padding: 3rem 2rem;
            background: var(--white);
            border-radius: var(--border-radius-lg);
            box-shadow: var(--shadow-md);
            transition: all 0.3s ease;
            border: 1px solid var(--gray-200);
        }

        .feature-item:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-xl);
            border-color: var(--primary-color);
        }

        .feature-icon {
            font-size: 4rem;
            margin-bottom: 1.5rem;
            background: var(--gradient-primary);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .feature-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 1rem;
            color: var(--gray-900);
        }

        .feature-description {
            color: var(--gray-600);
            line-height: 1.6;
        }

        /* Testimonials */
        .testimonial-section {
            background: var(--gradient-primary);
            color: var(--white);
            padding: 100px 0;
            position: relative;
            overflow: hidden;
        }

        .testimonial-card {
            background: rgba(255, 255, 255, 0.1);
            border-radius: var(--border-radius-lg);
            padding: 2.5rem 2rem;
            text-align: center;
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            transition: all 0.3s ease;
        }

        .testimonial-card:hover {
            background: rgba(255, 255, 255, 0.15);
            transform: translateY(-5px);
        }

        .testimonial-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            margin: 0 auto 1.5rem;
            background: var(--accent-color);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            font-weight: 700;
            color: var(--white);
        }

        .testimonial-content {
            font-size: 1.125rem;
            line-height: 1.7;
            margin-bottom: 1.5rem;
            font-style: italic;
        }

        .testimonial-author {
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .testimonial-role {
            opacity: 0.8;
            font-size: 0.875rem;
        }

        /* CTA Section */
        .cta-section {
            background: var(--gradient-secondary);
            color: var(--white);
            padding: 100px 0;
            text-align: center;
        }

        .cta-title {
            font-size: clamp(2rem, 4vw, 3.5rem);
            font-weight: 800;
            margin-bottom: 1.5rem;
        }

        .cta-description {
            font-size: 1.25rem;
            margin-bottom: 2.5rem;
            opacity: 0.9;
            max-width: 800px;
            margin-left: auto;
            margin-right: auto;
        }

        .cta-buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
            margin-bottom: 2rem;
        }

        .cta-features {
            display: flex;
            gap: 2rem;
            justify-content: center;
            flex-wrap: wrap;
            font-size: 0.875rem;
            opacity: 0.8;
        }

        .cta-feature {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .hero-section {
                padding: 80px 0 60px;
                text-align: center;
            }

            .hero-buttons {
                justify-content: center;
            }

            .hero-stats {
                justify-content: center;
            }

            .stats-container {
                margin: -40px 1rem 0;
                padding: 2rem 1rem;
            }

            .section-modern {
                padding: 60px 0;
            }

            .package-card.popular {
                transform: none;
                margin-top: 2rem;
            }

            .cta-buttons {
                flex-direction: column;
                align-items: center;
            }

            .cta-features {
                flex-direction: column;
                align-items: center;
            }
        }

        /* Animation Classes */
        .fade-in-up {
            opacity: 0;
            transform: translateY(30px);
            transition: all 0.6s ease;
        }

        .fade-in-up.animate {
            opacity: 1;
            transform: translateY(0);
        }

        .fade-in-left {
            opacity: 0;
            transform: translateX(-30px);
            transition: all 0.6s ease;
        }

        .fade-in-left.animate {
            opacity: 1;
            transform: translateX(0);
        }

        .fade-in-right {
            opacity: 0;
            transform: translateX(30px);
            transition: all 0.6s ease;
        }

        .fade-in-right.animate {
            opacity: 1;
            transform: translateX(0);
        }

        /* Loading States */
        .loading-skeleton {
            background: linear-gradient(90deg, var(--gray-200) 25%, var(--gray-100) 50%, var(--gray-200) 75%);
            background-size: 200% 100%;
            animation: loading 1.5s infinite;
        }

        @keyframes loading {
            0% {
                background-position: 200% 0;
            }
            100% {
                background-position: -200% 0;
            }
        }

        /* Utility Classes */
        .text-gradient {
            background: var(--gradient-primary);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .bg-gradient {
            background: var(--gradient-primary);
        }

        .shadow-modern {
            box-shadow: var(--shadow-xl);
        }

        .border-modern {
            border: 1px solid var(--gray-200);
        }

        .rounded-modern {
            border-radius: var(--border-radius-lg);
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
                    <img src="${pageContext.request.contextPath}/assets/img/logo/loder.png" alt="Loading">
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
                        <div class="hero-content fade-in-left">
                            <h1 class="hero-title">
                                Transform Your Future with 
                                <span style="color: #FCD34D;">Quality Education</span>
                            </h1>
                            <p class="hero-subtitle">
                                Join over <strong>${stats.totalStudents}</strong> students worldwide in our comprehensive online learning platform. 
                                Master new skills, earn certificates, and advance your career with expert-led courses.
                            </p>
                            <div class="hero-buttons">
                                <a href="${pageContext.request.contextPath}/login" class="btn-modern btn-primary">
                                    <i class="fas fa-rocket"></i>
                                    Start Learning Now
                                </a>
                                <a href="#why-choose" class="btn-modern btn-outline">
                                    <i class="fas fa-play-circle"></i>
                                    Watch Demo
                                </a>
                            </div>
                            <div class="hero-stats">
                                <div class="hero-stat-item">
                                    <i class="fas fa-star hero-stat-icon"></i>
                                    <div class="hero-stat-text">
                                        <strong>${stats.satisfaction}</strong> rating from students
                                    </div>
                                </div>
                                <div class="hero-stat-item">
                                    <i class="fas fa-certificate hero-stat-icon"></i>
                                    <div class="hero-stat-text">
                                        <strong>${stats.completionRate}</strong> success rate
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-6">
                        <div class="hero-image fade-in-right">
                            <div style="position: relative; text-align: center;">
                                <div style="background: rgba(255,255,255,0.1); border-radius: 20px; padding: 3rem; backdrop-filter: blur(10px); border: 1px solid rgba(255,255,255,0.2);">
                                    <i class="fas fa-graduation-cap" style="font-size: 8rem; color: #FCD34D; margin-bottom: 2rem; display: block;"></i>
                                    <div class="row text-center">
                                        <div class="col-4">
                                            <div style="padding: 1rem;">
                                                <i class="fas fa-book" style="font-size: 2rem; color: #FCD34D; margin-bottom: 0.5rem; display: block;"></i>
                                                <div style="font-size: 1.25rem; font-weight: 600;">${stats.totalLessons}+</div>
                                                <div style="font-size: 0.875rem; opacity: 0.8;">Lessons</div>
                                            </div>
                                        </div>
                                        <div class="col-4">
                                            <div style="padding: 1rem;">
                                                <i class="fas fa-users" style="font-size: 2rem; color: #FCD34D; margin-bottom: 0.5rem; display: block;"></i>
                                                <div style="font-size: 1.25rem; font-weight: 600;">${stats.totalStudents}</div>
                                                <div style="font-size: 0.875rem; opacity: 0.8;">Students</div>
                                            </div>
                                        </div>
                                        <div class="col-4">
                                            <div style="padding: 1rem;">
                                                <i class="fas fa-award" style="font-size: 2rem; color: #FCD34D; margin-bottom: 0.5rem; display: block;"></i>
                                                <div style="font-size: 1.25rem; font-weight: 600;">${stats.completionRate}</div>
                                                <div style="font-size: 0.875rem; opacity: 0.8;">Success</div>
                                            </div>
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
                <div class="stats-container">
                    <div class="row">
                        <div class="col-lg-3 col-md-6 col-sm-6">
                            <div class="stat-item fade-in-up">
                                <i class="fas fa-book stat-icon"></i>
                                <span class="stat-number">${stats.totalSubjects}</span>
                                <div class="stat-label">Subjects Available</div>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-6 col-sm-6">
                            <div class="stat-item fade-in-up" style="animation-delay: 0.1s;">
                                <i class="fas fa-play-circle stat-icon"></i>
                                <span class="stat-number">${stats.totalLessons}</span>
                                <div class="stat-label">Interactive Lessons</div>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-6 col-sm-6">
                            <div class="stat-item fade-in-up" style="animation-delay: 0.2s;">
                                <i class="fas fa-users stat-icon"></i>
                                <span class="stat-number">${stats.totalStudents}</span>
                                <div class="stat-label">Happy Students</div>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-6 col-sm-6">
                            <div class="stat-item fade-in-up" style="animation-delay: 0.3s;">
                                <i class="fas fa-trophy stat-icon"></i>
                                <span class="stat-number">${stats.completionRate}</span>
                                <div class="stat-label">Success Rate</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <!-- Stats Section End -->

        <!-- Featured Subjects Section Start -->
        <section class="section-modern">
            <div class="container">
                <div class="section-title fade-in-up">
                    <h2>Popular Subjects</h2>
                    <p>Discover our most sought-after subjects, carefully designed by expert educators to provide comprehensive learning experiences that prepare you for success.</p>
                </div>
                <div class="row">
                    <c:forEach var="subjectInfo" items="${featuredSubjects}" varStatus="status">
                        <div class="col-lg-4 col-md-6 mb-4">
                            <div class="card-modern course-card fade-in-up" style="animation-delay: ${status.index * 0.1}s;">
                                <div class="card-body-modern">
                                    <div class="course-meta">
                                        <div class="course-badge">${subjectInfo.grade.name}</div>
                                        <div class="course-stats">
                                            <span><i class="fas fa-book"></i> ${subjectInfo.chapterCount}</span>
                                            <span><i class="fas fa-play"></i> ${subjectInfo.lessonCount}</span>
                                        </div>
                                    </div>
                                    <h5 class="course-title">${subjectInfo.subject.name}</h5>
                                    <p class="course-description">${subjectInfo.subject.description}</p>
                                    <div class="course-footer">
                                        <a href="${pageContext.request.contextPath}/subjects" class="btn-modern btn-primary">
                                            <i class="fas fa-arrow-right"></i>
                                            Explore Subject
                                        </a>
                                        <div class="text-muted small">
                                            <i class="fas fa-clock"></i> Self-paced
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                <div class="text-center mt-5 fade-in-up">
                    <a href="${pageContext.request.contextPath}/subjects" class="btn-modern btn-primary">
                        <i class="fas fa-th-large"></i>
                        View All Subjects
                    </a>
                </div>
            </div>
        </section>
        <!-- Featured Subjects Section End -->

        <!-- Why Choose Us Section Start -->
        <section id="why-choose" class="section-modern" style="background: var(--gray-50);">
            <div class="container">
                <div class="section-title fade-in-up">
                    <h2>Why Choose Our Platform?</h2>
                    <p>We're committed to providing the best online learning experience with innovative features, expert support, and cutting-edge technology.</p>
                </div>
                <div class="row">
                    <c:forEach var="feature" items="${features}" varStatus="status">
                        <div class="col-lg-4 col-md-6 mb-4">
                            <div class="feature-item fade-in-up" style="animation-delay: ${status.index * 0.1}s;">
                                <div class="feature-icon">
                                    <i class="${feature.icon}"></i>
                                </div>
                                <h5 class="feature-title">${feature.title}</h5>
                                <p class="feature-description">${feature.description}</p>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </section>
        <!-- Why Choose Us Section End -->

        <!-- Study Packages Section Start -->
        <section class="section-modern">
            <div class="container">
                <div class="section-title fade-in-up">
                    <h2>Choose Your Learning Package</h2>
                    <p>Select the perfect package that matches your learning goals and budget. All packages include lifetime access, certificates, and premium support.</p>
                </div>
                <div class="row">
                    <c:forEach var="packageInfo" items="${enhancedPackages}" varStatus="status">
                        <div class="col-lg-3 col-md-6 mb-4">
                            <div class="package-card ${packageInfo.popular ? 'popular' : ''} fade-in-up" style="animation-delay: ${status.index * 0.1}s;">
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
                                        <a href="${pageContext.request.contextPath}/study_package?service=detail&id=${packageInfo.pkg.id}" class="btn-modern btn-primary w-100">
                                            Choose ${packageInfo.type}
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                <div class="text-center mt-5 fade-in-up">
                    <div class="mb-4">
                        <div class="cta-features">
                            <div class="cta-feature">
                                <i class="fas fa-shield-alt" style="color: var(--success-color);"></i>
                                30-day money-back guarantee
                            </div>
                            <div class="cta-feature">
                                <i class="fas fa-sync" style="color: var(--primary-color);"></i>
                                Lifetime access
                            </div>
                            <div class="cta-feature">
                                <i class="fas fa-mobile-alt" style="color: var(--secondary-color);"></i>
                                Mobile learning support
                            </div>
                        </div>
                    </div>
                    <a href="${pageContext.request.contextPath}/study_package" class="btn-modern btn-outline">
                        Compare All Packages
                    </a>
                </div>
            </div>
        </section>
        <!-- Study Packages Section End -->

        <!-- Recent Lessons Section Start -->
        <section class="section-modern" style="background: var(--gray-50);">
            <div class="container">
                <div class="section-title fade-in-up">
                    <h2>Latest Lessons</h2>
                    <p>Stay updated with our newest educational content, created by expert instructors and designed for maximum learning impact.</p>
                </div>
                <div class="row">
                    <c:forEach var="lessonInfo" items="${recentLessonsWithInfo}" varStatus="status">
                        <div class="col-lg-3 col-md-6 mb-4">
                            <div class="card-modern fade-in-up" style="animation-delay: ${status.index * 0.1}s;">
                                <div class="card-body-modern">
                                    <div class="course-meta">
                                        <span class="badge badge-${lessonInfo.difficulty.toLowerCase() == 'beginner' ? 'success' : lessonInfo.difficulty.toLowerCase() == 'intermediate' ? 'warning' : 'danger'}">
                                            ${lessonInfo.difficulty}
                                        </span>
                                        <span class="text-muted small">
                                            <i class="fas fa-clock"></i> ${lessonInfo.duration} min
                                        </span>
                                    </div>
                                    <h6 class="course-title">${lessonInfo.lesson.name}</h6>
                                    <div class="text-primary small mb-2">
                                        <i class="fas fa-folder"></i> ${lessonInfo.subject.name} > ${lessonInfo.chapter.name}
                                    </div>
                                    <p class="course-description">
                                        ${fn:length(lessonInfo.lesson.content) > 80 ? 
                                          fn:substring(lessonInfo.lesson.content, 0, 80).concat("...") : 
                                          lessonInfo.lesson.content}
                                    </p>
                                    <div class="course-footer">
                                        <a href="${pageContext.request.contextPath}/video-viewer?lessonId=${lessonInfo.lesson.id}" class="btn-modern btn-primary">
                                            <i class="fas fa-play"></i> Watch
                                        </a>
                                        <small class="text-muted">${lessonInfo.grade.name}</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                <div class="text-center mt-5 fade-in-up">
                    <a href="${pageContext.request.contextPath}/LessonURL" class="btn-modern btn-primary">
                        <i class="fas fa-play-circle"></i>
                        Browse All Lessons
                    </a>
                </div>
            </div>
        </section>
        <!-- Recent Lessons Section End -->

        <!-- Testimonials Section Start -->
        <section id="testimonials" class="testimonial-section">
            <div class="container">
                <div class="section-title fade-in-up">
                    <h2 style="color: white;">What Our Students Say</h2>
                    <p style="color: rgba(255,255,255,0.9);">Real success stories from our learning community around the world</p>
                </div>
                <div class="row">
                    <c:forEach var="testimonial" items="${testimonials}" varStatus="status">
                        <div class="col-lg-3 col-md-6 mb-4">
                            <div class="testimonial-card fade-in-up" style="animation-delay: ${status.index * 0.1}s;">
                                <div class="testimonial-avatar">
                                    ${fn:substring(testimonial.name, 0, 1)}
                                </div>
                                <div class="testimonial-content">
                                    "${testimonial.content}"
                                </div>
                                <div class="testimonial-author">${testimonial.name}</div>
                                <div class="testimonial-role">${testimonial.role}</div>
                                <div class="mt-3">
                                    <i class="fas fa-star" style="color: #FCD34D;"></i>
                                    <i class="fas fa-star" style="color: #FCD34D;"></i>
                                    <i class="fas fa-star" style="color: #FCD34D;"></i>
                                    <i class="fas fa-star" style="color: #FCD34D;"></i>
                                    <i class="fas fa-star" style="color: #FCD34D;"></i>
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
                    <div class="col-lg-8 text-center fade-in-up">
                        <h2 class="cta-title">Ready to Start Your Learning Journey?</h2>
                        <p class="cta-description">
                            Join thousands of successful students who have transformed their careers with our comprehensive learning platform. 
                            Start your free trial today and unlock your potential!
                        </p>
                        <div class="cta-buttons">
                            <a href="${pageContext.request.contextPath}/register.jsp" class="btn-modern btn-primary">
                                <i class="fas fa-rocket"></i>
                                Start Free Trial
                            </a>
                            <a href="${pageContext.request.contextPath}/contact" class="btn-modern btn-outline">
                                <i class="fas fa-phone"></i>
                                Talk to an Expert
                            </a>
                        </div>
                        <div class="cta-features">
                            <div class="cta-feature">
                                <i class="fas fa-check-circle"></i>
                                No credit card required
                            </div>
                            <div class="cta-feature">
                                <i class="fas fa-times-circle"></i>
                                Cancel anytime
                            </div>
                            <div class="cta-feature">
                                <i class="fas fa-shield-alt"></i>
                                100% secure
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <!-- CTA Section End -->
    </main>

    <!-- Footer Start -->
    <jsp:include page="footer.jsp" />
    <!-- Footer End -->

    <!-- Back to Top Button -->
    <div id="back-top" style="position: fixed; right: 20px; bottom: 20px; z-index: 9998; opacity: 0; visibility: hidden; transition: all 0.3s ease;">
        <a title="Go to Top" href="#" style="display: flex; align-items: center; justify-content: center;
            width: 50px; height: 50px; background: var(--gradient-primary); color: white;
            border-radius: 50%; box-shadow: var(--shadow-lg); text-decoration: none; transition: all 0.3s ease;">
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

    <!-- Enhanced Custom JavaScript -->
    <script>
        $(document).ready(function() {
            // Initialize animations and interactions
            initializeAnimations();
            initializeCounters();
            initializeScrollEffects();
            initializeInteractions();
        });

        // Animation System
        function initializeAnimations() {
            // Intersection Observer for scroll animations
            const observerOptions = {
                threshold: 0.1,
                rootMargin: '0px 0px -50px 0px'
            };

            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.classList.add('animate');
                        observer.unobserve(entry.target);
                    }
                });
            }, observerOptions);

            // Observe all animation elements
            document.querySelectorAll('.fade-in-up, .fade-in-left, .fade-in-right').forEach(el => {
                observer.observe(el);
            });
        }

        // Counter Animation
        function initializeCounters() {
            const counters = document.querySelectorAll('.stat-number');
            
            const countObserver = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        const counter = entry.target;
                        const target = parseInt(counter.textContent.replace(/[^0-9]/g, ''));
                        const originalText = counter.textContent;
                        
                        if (target > 0) {
                            animateCounter(counter, target, originalText);
                        }
                        countObserver.unobserve(counter);
                    }
                });
            }, { threshold: 0.5 });

            counters.forEach(counter => countObserver.observe(counter));
        }

        function animateCounter(element, target, originalText) {
            let current = 0;
            const increment = target / 50;
            const timer = setInterval(() => {
                current += increment;
                if (current >= target) {
                    element.textContent = originalText;
                    clearInterval(timer);
                } else {
                    const suffix = originalText.replace(/[0-9]/g, '');
                    element.textContent = Math.floor(current) + suffix;
                }
            }, 40);
        }

        // Scroll Effects
        function initializeScrollEffects() {
            // Smooth scrolling for anchor links
            $('a[href^="#"]').on('click', function(event) {
                const target = $(this.getAttribute('href'));
                if(target.length) {
                    event.preventDefault();
                    $('html, body').stop().animate({
                        scrollTop: target.offset().top - 100
                    }, 800, 'easeInOutCubic');
                }
            });

            // Back to top button
            $(window).scroll(function() {
                const scrollTop = $(window).scrollTop();
                const backToTop = $('#back-top');
                
                if (scrollTop > 300) {
                    backToTop.css({
                        'opacity': '1',
                        'visibility': 'visible'
                    });
                } else {
                    backToTop.css({
                        'opacity': '0',
                        'visibility': 'hidden'
                    });
                }
            });

            $('#back-top a').click(function(e) {
                e.preventDefault();
                $('html, body').animate({scrollTop: 0}, 800);
            });

            // Parallax effect for hero section
            $(window).scroll(function() {
                const scrolled = $(window).scrollTop();
                const hero = $('.hero-section');
                const speed = scrolled * 0.3;
                
                hero.css('transform', `translateY(${speed}px)`);
            });
        }

        // Interactive Elements
        function initializeInteractions() {
            // Card hover effects
            $('.card-modern, .feature-item, .testimonial-card').hover(
                function() {
                    $(this).css('transform', 'translateY(-8px) scale(1.02)');
                },
                function() {
                    $(this).css('transform', 'translateY(0) scale(1)');
                }
            );

            // Button interactions
            $('.btn-modern').each(function() {
                $(this).on('mouseenter', function() {
                    $(this).css('transform', 'translateY(-2px)');
                }).on('mouseleave', function() {
                    $(this).css('transform', 'translateY(0)');
                });
            });

            // Package card selection
            $('.package-card').click(function() {
                $('.package-card').removeClass('selected');
                $(this).addClass('selected');
            });

            // Loading states for buttons
            $('.btn-modern').click(function(e) {
                const btn = $(this);
                const originalText = btn.html();
                
                btn.html('<i class="fas fa-spinner fa-spin"></i> Loading...');
                btn.prop('disabled', true);
                
                // Simulate loading (remove this in production)
                setTimeout(() => {
                    btn.html(originalText);
                    btn.prop('disabled', false);
                }, 1000);
            });

            // Tooltip initialization
            $('[data-toggle="tooltip"]').tooltip({
                trigger: 'hover',
                placement: 'top'
            });

            // Mobile menu enhancements
            $('.mobile_menu').slicknav({
                prependTo: '.mobile_menu',
                closeOnClick: true,
                allowParentLinks: true,
                brand: 'EduLearn'
            });
        }

        // Performance optimizations
        window.addEventListener('load', function() {
            // Remove preloader
            $('#preloader-active').fadeOut('slow');
            
            // Initialize lazy loading
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
        });

        // Custom easing function
        $.easing.easeInOutCubic = function (x, t, b, c, d) {
            if ((t/=d/2) < 1) return c/2*t*t*t + b;
            return c/2*((t-=2)*t*t + 2) + b;
        };

        // Error handling
        window.addEventListener('error', function(e) {
            console.error('JavaScript error:', e.error);
        });

        // Analytics tracking (placeholder)
        function trackEvent(category, action, label) {
            // Implement your analytics tracking here
            console.log('Event tracked:', category, action, label);
        }

        // Course card click tracking
        $('.course-card').click(function() {
            const courseName = $(this).find('.course-title').text();
            trackEvent('Course', 'View', courseName);
        });

        // Package selection tracking
        $('.package-card .btn-modern').click(function() {
            const packageType = $(this).closest('.package-card').find('.package-type').text();
            trackEvent('Package', 'Select', packageType);
        });
    </script>

    <!-- Schema.org structured data for SEO -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "EducationalOrganization",
        "name": "EduLearn - Modern Online Learning Platform",
        "description": "Transform your future with quality online education. Interactive courses, expert instructors, and comprehensive learning paths.",
        "url": "${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/",
        "logo": "${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/assets/img/logo/logo.png",
        "contactPoint": {
            "@type": "ContactPoint",
            "telephone": "+1-555-123-4567",
            "contactType": "customer service",
            "availableLanguage": ["English", "Vietnamese"]
        },
        "offers": {
            "@type": "Offer",
            "category": "Education",
            "availability": "https://schema.org/InStock"
        },
        "aggregateRating": {
            "@type": "AggregateRating",
            "ratingValue": "${stats.satisfaction}",
            "reviewCount": "${stats.totalStudents}"
        }
    }
    </script>

</body>
</html>
