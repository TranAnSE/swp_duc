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
                --primary-color: #667eea;
                --secondary-color: #764ba2;
                --accent-color: #f093fb;
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
                --glass-bg: rgba(255, 255, 255, 0.25);
                --glass-border: rgba(255, 255, 255, 0.3);
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

            /* Enhanced Course Progress Header with Glass Morphism */
            .course-progress-header {
                background: linear-gradient(135deg,
                    rgba(255, 255, 255, 0.25) 0%,
                    rgba(255, 255, 255, 0.15) 50%,
                    rgba(255, 255, 255, 0.1) 100%);
                backdrop-filter: blur(20px);
                -webkit-backdrop-filter: blur(20px);
                border: 1px solid rgba(255, 255, 255, 0.3);
                color: #1f2937;
                padding: 25px;
                border-radius: 20px;
                margin-bottom: 25px;
                box-shadow:
                    0 8px 32px rgba(0, 0, 0, 0.1),
                    inset 0 1px 0 rgba(255, 255, 255, 0.4);
                position: relative;
                overflow: hidden;
            }

            /* Add subtle animated background pattern */
            .course-progress-header::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background:
                    radial-gradient(circle at 20% 80%, rgba(120, 119, 198, 0.1) 0%, transparent 50%),
                    radial-gradient(circle at 80% 20%, rgba(255, 119, 198, 0.1) 0%, transparent 50%),
                    radial-gradient(circle at 40% 40%, rgba(120, 219, 255, 0.1) 0%, transparent 50%);
                z-index: -1;
                animation: backgroundShift 10s ease-in-out infinite alternate;
            }

            @keyframes backgroundShift {
                0% {
                    transform: translateX(0) translateY(0);
                }
                100% {
                    transform: translateX(-10px) translateY(-5px);
                }
            }

            .progress-info {
                display: flex;
                justify-content: space-between;
                align-items: center;
                flex-wrap: wrap;
                gap: 20px;
                position: relative;
                z-index: 1;
            }

            .course-title-section h2 {
                margin: 0 0 8px 0;
                font-size: 1.6rem;
                font-weight: 700;
                color: #1f2937;
                text-shadow: 0 1px 2px rgba(255, 255, 255, 0.5);
            }

            .teacher-info {
                font-size: 0.95rem;
                color: #4b5563;
                font-weight: 500;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .teacher-info i {
                color: var(--primary-color);
                font-size: 1rem;
            }

            .progress-stats {
                display: flex;
                gap: 35px;
                align-items: center;
            }

            .progress-item {
                text-align: center;
                background: rgba(255, 255, 255, 0.4);
                padding: 12px 18px;
                border-radius: 12px;
                backdrop-filter: blur(10px);
                border: 1px solid rgba(255, 255, 255, 0.3);
                min-width: 80px;
                transition: all 0.3s ease;
            }

            .progress-item:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
                background: rgba(255, 255, 255, 0.5);
            }

            .progress-number {
                font-size: 1.75rem;
                font-weight: 800;
                display: block;
                color: var(--primary-color);
                text-shadow: 0 1px 2px rgba(255, 255, 255, 0.5);
            }

            .progress-label {
                font-size: 0.85rem;
                color: #4b5563;
                font-weight: 600;
                margin-top: 4px;
            }

            .progress-bar-container {
                width: 100%;
                margin-top: 20px;
                position: relative;
                z-index: 1;
            }

            .progress-bar-custom {
                height: 10px;
                background: rgba(255, 255, 255, 0.4);
                border-radius: 6px;
                overflow: hidden;
                backdrop-filter: blur(10px);
                border: 1px solid rgba(255, 255, 255, 0.3);
                box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.1);
            }

            .progress-bar-fill {
                height: 100%;
                background: linear-gradient(90deg,
                    var(--success-color) 0%,
                    #34d399 50%,
                    #6ee7b7 100%);
                border-radius: 6px;
                transition: width 0.8s cubic-bezier(0.4, 0, 0.2, 1);
                position: relative;
                overflow: hidden;
            }

            /* Add shimmer effect to progress bar */
            .progress-bar-fill::after {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg,
                    transparent 0%,
                    rgba(255, 255, 255, 0.4) 50%,
                    transparent 100%);
                animation: shimmer 2s infinite;
            }

            @keyframes shimmer {
                0% {
                    left: -100%;
                }
                100% {
                    left: 100%;
                }
            }

            /* Sidebar Styles - Enhanced */
            .course-sidebar {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(20px);
                border-radius: 20px;
                box-shadow:
                    0 10px 40px rgba(0, 0, 0, 0.1),
                    0 1px 0 rgba(255, 255, 255, 0.5) inset;
                padding: 28px;
                height: calc(100vh - 200px);
                overflow-y: auto;
                position: sticky;
                top: 120px;
                border: 1px solid rgba(255, 255, 255, 0.3);
            }

            .sidebar-header {
                border-bottom: 2px solid rgba(102, 126, 234, 0.2);
                padding-bottom: 18px;
                margin-bottom: 28px;
                text-align: center;
                background: linear-gradient(135deg,
                    rgba(102, 126, 234, 0.1) 0%,
                    rgba(118, 75, 162, 0.1) 100%);
                margin: -28px -28px 28px -28px;
                padding: 20px 28px 18px 28px;
                border-radius: 20px 20px 0 0;
            }

            .sidebar-header h5 {
                color: var(--text-primary);
                font-weight: 700;
                margin: 0;
                font-size: 1.2rem;
                text-shadow: 0 1px 2px rgba(255, 255, 255, 0.5);
            }

            /* Course Tree Styles - Enhanced */
            .course-tree {
                list-style: none;
                padding: 0;
                margin: 0;
            }

            .chapter-item {
                margin-bottom: 18px;
            }

            .chapter-header {
                background: linear-gradient(135deg,
                    rgba(245, 158, 11, 0.9) 0%,
                    rgba(217, 119, 6, 0.9) 100%);
                color: white;
                padding: 14px 18px;
                border-radius: 12px;
                cursor: pointer;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                justify-content: space-between;
                font-weight: 600;
                box-shadow:
                    0 4px 12px rgba(245, 158, 11, 0.3),
                    0 1px 0 rgba(255, 255, 255, 0.2) inset;
                border: none;
                width: 100%;
                text-align: left;
                backdrop-filter: blur(10px);
            }

            .chapter-header:hover {
                background: linear-gradient(135deg,
                    rgba(217, 119, 6, 0.95) 0%,
                    rgba(180, 83, 9, 0.95) 100%);
                color: white;
                transform: translateY(-2px);
                box-shadow:
                    0 6px 20px rgba(245, 158, 11, 0.4),
                    0 1px 0 rgba(255, 255, 255, 0.3) inset;
            }

            .chapter-header i.fa-chevron-down {
                transition: transform 0.3s ease;
            }

            .chapter-header[aria-expanded="false"] i.fa-chevron-down {
                transform: rotate(-90deg);
            }

            .chapter-content {
                background: linear-gradient(135deg,
                    rgba(255, 255, 255, 0.8) 0%,
                    rgba(249, 250, 251, 0.8) 100%);
                border-radius: 0 0 12px 12px;
                padding: 16px;
                border: 1px solid rgba(229, 231, 235, 0.5);
                border-top: none;
                backdrop-filter: blur(10px);
            }

            /* Lesson Items - Enhanced */
            .lesson-item, .test-item {
                padding: 12px 16px;
                margin: 8px 0;
                border-radius: 10px;
                cursor: pointer;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                display: flex;
                align-items: center;
                text-decoration: none;
                color: var(--text-secondary);
                font-size: 0.9rem;
                border: 1px solid transparent;
                position: relative;
                backdrop-filter: blur(10px);
            }

            .lesson-item {
                background: rgba(255, 255, 255, 0.6);
                border: 1px solid rgba(255, 255, 255, 0.3);
            }

            .lesson-item:hover {
                background: linear-gradient(135deg,
                    rgba(224, 242, 254, 0.8) 0%,
                    rgba(186, 230, 253, 0.8) 100%);
                color: var(--primary-color);
                text-decoration: none;
                transform: translateX(6px) translateY(-1px);
                border-color: rgba(102, 126, 234, 0.3);
                box-shadow:
                    0 4px 12px rgba(102, 126, 234, 0.2),
                    0 1px 0 rgba(255, 255, 255, 0.5) inset;
            }

            .lesson-item.active {
                background: linear-gradient(135deg,
                    var(--primary-color) 0%,
                    var(--secondary-color) 100%);
                color: white;
                font-weight: 600;
                box-shadow:
                    0 6px 20px rgba(102, 126, 234, 0.4),
                    0 1px 0 rgba(255, 255, 255, 0.2) inset;
                transform: translateX(4px);
            }

            .lesson-item.completed {
                background: linear-gradient(135deg,
                    var(--success-color) 0%,
                    #059669 100%);
                color: white;
                box-shadow:
                    0 4px 12px rgba(16, 185, 129, 0.3),
                    0 1px 0 rgba(255, 255, 255, 0.2) inset;
            }

            .lesson-item.completed::after {
                content: '\f00c';
                font-family: 'Font Awesome 5 Free';
                font-weight: 900;
                position: absolute;
                right: 12px;
                font-size: 0.9rem;
                text-shadow: 0 1px 2px rgba(0, 0, 0, 0.2);
            }

            .test-item {
                background: linear-gradient(135deg,
                    rgba(254, 243, 199, 0.8) 0%,
                    rgba(253, 230, 138, 0.8) 100%);
                color: #92400e;
                border: 1px solid rgba(245, 158, 11, 0.3);
            }

            .test-item:hover {
                background: linear-gradient(135deg,
                    rgba(253, 230, 138, 0.9) 0%,
                    rgba(252, 211, 77, 0.9) 100%);
                color: #92400e;
                text-decoration: none;
                transform: translateX(6px) translateY(-1px);
                box-shadow:
                    0 4px 12px rgba(245, 158, 11, 0.3),
                    0 1px 0 rgba(255, 255, 255, 0.5) inset;
            }

            .lesson-item i, .test-item i {
                margin-right: 12px;
                width: 18px;
                text-align: center;
                font-size: 1rem;
            }

            /* Video Player Styles - Enhanced */
            .video-container {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(20px);
                border-radius: 20px;
                box-shadow:
                    0 10px 40px rgba(0, 0, 0, 0.1),
                    0 1px 0 rgba(255, 255, 255, 0.5) inset;
                overflow: hidden;
                margin-bottom: 28px;
                border: 1px solid rgba(255, 255, 255, 0.3);
            }

            .video-player {
                width: 100%;
                height: 450px;
                background: #000;
                border-radius: 20px 20px 0 0;
            }

            .video-placeholder {
                height: 450px;
                background: linear-gradient(135deg,
                    rgba(102, 126, 234, 0.9) 0%,
                    rgba(118, 75, 162, 0.9) 100%);
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                text-align: center;
                border-radius: 20px 20px 0 0;
            }

            .video-info {
                padding: 28px;
            }

            .video-title {
                font-size: 1.85rem;
                font-weight: 700;
                color: var(--text-primary);
                margin-bottom: 18px;
                line-height: 1.3;
                text-shadow: 0 1px 2px rgba(255, 255, 255, 0.5);
            }

            .breadcrumb-nav {
                margin-bottom: 18px;
            }

            .breadcrumb-nav .breadcrumb {
                background: linear-gradient(135deg,
                    rgba(248, 250, 252, 0.8) 0%,
                    rgba(241, 245, 249, 0.8) 100%);
                border-radius: 12px;
                padding: 10px 18px;
                margin: 0;
                backdrop-filter: blur(10px);
                border: 1px solid rgba(255, 255, 255, 0.3);
            }

            .breadcrumb-nav .breadcrumb-item a {
                color: var(--primary-color);
                text-decoration: none;
                font-weight: 500;
            }

            .breadcrumb-nav .breadcrumb-item.active {
                color: var(--text-secondary);
                font-weight: 600;
            }

            .video-meta {
                display: flex;
                flex-wrap: wrap;
                gap: 15px;
                margin-bottom: 22px;
            }

            .meta-item {
                display: flex;
                align-items: center;
                color: var(--text-secondary);
                font-size: 0.9rem;
                background: linear-gradient(135deg,
                    rgba(248, 250, 252, 0.8) 0%,
                    rgba(241, 245, 249, 0.8) 100%);
                padding: 10px 14px;
                border-radius: 25px;
                border: 1px solid rgba(229, 231, 235, 0.5);
                backdrop-filter: blur(10px);
                font-weight: 500;
            }

            .meta-item i {
                margin-right: 10px;
                color: var(--primary-color);
                font-size: 1rem;
            }

            .video-description {
                background: linear-gradient(135deg,
                    rgba(240, 249, 255, 0.8) 0%,
                    rgba(224, 242, 254, 0.8) 100%);
                padding: 22px;
                border-radius: 16px;
                border-left: 4px solid var(--primary-color);
                margin-top: 22px;
                backdrop-filter: blur(10px);
                border: 1px solid rgba(102, 126, 234, 0.2);
            }

            .video-description h6 {
                color: var(--text-primary);
                font-weight: 600;
                margin-bottom: 14px;
                font-size: 1.1rem;
            }

            .video-description p {
                color: var(--text-secondary);
                line-height: 1.7;
                margin: 0;
                font-size: 0.95rem;
            }

            /* Navigation Buttons - Enhanced */
            .lesson-navigation {
                display: flex;
                gap: 18px;
                margin-top: 25px;
            }

            .nav-btn {
                flex: 1;
                padding: 14px 22px;
                border-radius: 12px;
                text-decoration: none;
                text-align: center;
                font-weight: 600;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
                backdrop-filter: blur(10px);
                border: 1px solid rgba(255, 255, 255, 0.3);
                font-size: 0.95rem;
            }

            .nav-btn.prev {
                background: linear-gradient(135deg,
                    rgba(108, 117, 125, 0.9) 0%,
                    rgba(73, 80, 87, 0.9) 100%);
                color: white;
            }

            .nav-btn.next {
                background: linear-gradient(135deg,
                    var(--primary-color) 0%,
                    var(--secondary-color) 100%);
                color: white;
            }

            .nav-btn:hover {
                text-decoration: none;
                color: white;
                transform: translateY(-3px);
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
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
                    margin-bottom: 28px;
                    max-height: 450px;
                }

                .video-player, .video-placeholder {
                    height: 350px;
                }

                .progress-stats {
                    gap: 20px;
                }

                .course-progress-header {
                    padding: 20px;
                    border-radius: 16px;
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
                    padding: 20px;
                }

                .video-title {
                    font-size: 1.4rem;
                }

                .lesson-navigation {
                    flex-direction: column;
                }

                .course-progress-header {
                    padding: 18px;
                    border-radius: 14px;
                }

                .course-title-section h2 {
                    font-size: 1.4rem;
                }

                .progress-item {
                    padding: 10px 14px;
                    min-width: 70px;
                }

                .progress-number {
                    font-size: 1.5rem;
                }
            }

            /* Custom Scrollbar - Enhanced */
            .course-sidebar::-webkit-scrollbar {
                width: 8px;
            }

            .course-sidebar::-webkit-scrollbar-track {
                background: rgba(248, 250, 252, 0.5);
                border-radius: 4px;
            }

            .course-sidebar::-webkit-scrollbar-thumb {
                background: linear-gradient(135deg,
                    rgba(102, 126, 234, 0.6) 0%,
                    rgba(118, 75, 162, 0.6) 100%);
                border-radius: 4px;
            }

            .course-sidebar::-webkit-scrollbar-thumb:hover {
                background: linear-gradient(135deg,
                    rgba(102, 126, 234, 0.8) 0%,
                    rgba(118, 75, 162, 0.8) 100%);
            }

            /* Progress indicator for lessons - Enhanced */
            .lesson-progress {
                font-size: 0.75rem;
                opacity: 0.9;
                margin-left: auto;
                background: rgba(255, 255, 255, 0.2);
                padding: 2px 6px;
                border-radius: 10px;
                font-weight: 600;
            }

            /* Add subtle animations */
            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .course-progress-header,
            .video-container,
            .course-sidebar {
                animation: fadeInUp 0.6s ease-out;
            }

            .course-sidebar {
                animation-delay: 0.2s;
            }

            .video-container {
                animation-delay: 0.1s;
            }
            .chapter-header i.fa-chevron-down,
            .chapter-header i.fa-chevron-up {
                transition: transform 0.3s ease;
            }

            /* Ensure proper icon display */
            .chapter-header .fa-chevron-up {
                transform: rotate(180deg);
            }

            .chapter-header .fa-chevron-down {
                transform: rotate(0deg);
            }

            /* Better visual feedback for collapsible state */
            .chapter-header[aria-expanded="true"] {
                background: linear-gradient(135deg,
                    rgba(217, 119, 6, 0.95) 0%,
                    rgba(180, 83, 9, 0.95) 100%);
            }

            .chapter-header[aria-expanded="false"] {
                background: linear-gradient(135deg,
                    rgba(245, 158, 11, 0.9) 0%,
                    rgba(217, 119, 6, 0.9) 100%);
            }

            /* Smooth collapse animation */
            .collapse {
                transition: height 0.35s ease;
            }

            .collapsing {
                transition: height 0.35s ease;
            }
            /* Test item styling */
            .test-item-container {
                margin: 8px 0;
            }

            .test-item.practice-test {
                background: linear-gradient(135deg,
                    rgba(34, 197, 94, 0.1) 0%,
                    rgba(22, 163, 74, 0.1) 100%);
                border: 1px solid rgba(34, 197, 94, 0.3);
                color: #15803d;
            }

            .test-item.practice-test:hover {
                background: linear-gradient(135deg,
                    rgba(34, 197, 94, 0.2) 0%,
                    rgba(22, 163, 74, 0.2) 100%);
                color: #15803d;
                text-decoration: none;
            }

            .test-item.official-test {
                background: linear-gradient(135deg,
                    rgba(239, 68, 68, 0.1) 0%,
                    rgba(220, 38, 38, 0.1) 100%);
                border: 1px solid rgba(239, 68, 68, 0.3);
                color: #dc2626;
            }

            .test-item.official-test:hover {
                background: linear-gradient(135deg,
                    rgba(239, 68, 68, 0.2) 0%,
                    rgba(220, 38, 38, 0.2) 100%);
                color: #dc2626;
                text-decoration: none;
            }

            .test-item.official-test.completed {
                background: linear-gradient(135deg,
                    rgba(107, 114, 128, 0.1) 0%,
                    rgba(75, 85, 99, 0.1) 100%);
                border: 1px solid rgba(107, 114, 128, 0.3);
                color: #4b5563;
                cursor: default;
            }

            .test-status {
                display: flex;
                flex-direction: column;
                align-items: flex-end;
                margin-left: auto;
            }

            .test-type-badge {
                padding: 2px 8px;
                border-radius: 12px;
                font-size: 0.7rem;
                font-weight: 600;
                margin-bottom: 2px;
            }

            .practice-badge {
                background-color: rgba(34, 197, 94, 0.2);
                color: #15803d;
            }

            .official-badge {
                background-color: rgba(239, 68, 68, 0.2);
                color: #dc2626;
            }

            .test-score {
                font-size: 0.75rem;
                font-weight: 600;
                color: #059669;
            }

            .test-not-taken {
                font-size: 0.75rem;
                font-weight: 600;
                color: #dc2626;
            }

            /* Text lesson actions */
            .text-lesson-actions {
                margin: 25px 0;
                padding: 20px;
                background: linear-gradient(135deg,
                    rgba(240, 249, 255, 0.8) 0%,
                    rgba(224, 242, 254, 0.8) 100%);
                border-radius: 12px;
                border: 1px solid rgba(59, 130, 246, 0.2);
                text-align: center;
            }

            .completed-indicator {
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
                font-size: 1.1rem;
            }

            #markCompletedBtn {
                padding: 12px 30px;
                font-size: 1.1rem;
                font-weight: 600;
                border-radius: 8px;
                transition: all 0.3s ease;
            }

            #markCompletedBtn:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(34, 197, 94, 0.3);
            }
            /* Toast notification styles */
            .toast-notification {
                position: fixed;
                top: 120px;
                right: 20px;
                z-index: 10000; /* Increase z-index */
                min-width: 350px;
                max-width: 500px;
                padding: 16px 20px;
                border-radius: 12px;
                box-shadow:
                    0 10px 40px rgba(0, 0, 0, 0.15),
                    0 1px 0 rgba(255, 255, 255, 0.5) inset;
                backdrop-filter: blur(20px);
                -webkit-backdrop-filter: blur(20px);
                border: 1px solid rgba(255, 255, 255, 0.3);
                font-weight: 500;
                font-size: 0.95rem;
                display: flex;
                align-items: center;
                gap: 12px;
                opacity: 0;
                transform: translateX(100px);
                transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
                font-family: inherit; /* Ensure font inheritance */
                line-height: 1.4;
            }

            .toast-notification.show {
                opacity: 1;
                transform: translateX(0);
            }

            .toast-notification.success {
                background: linear-gradient(135deg,
                    rgba(16, 185, 129, 0.95) 0%,
                    rgba(5, 150, 105, 0.95) 100%);
                color: white !important; /* Force white color */
                border-color: rgba(255, 255, 255, 0.4);
            }

            .toast-notification.warning {
                background: linear-gradient(135deg,
                    rgba(245, 158, 11, 0.95) 0%,
                    rgba(217, 119, 6, 0.95) 100%);
                color: white !important; /* Force white color */
                border-color: rgba(255, 255, 255, 0.4);
            }

            .toast-notification.error {
                background: linear-gradient(135deg,
                    rgba(239, 68, 68, 0.95) 0%,
                    rgba(220, 38, 38, 0.95) 100%);
                color: white !important; /* Force white color */
                border-color: rgba(255, 255, 255, 0.4);
            }

            .toast-notification i {
                font-size: 1.2rem;
                text-shadow: 0 1px 2px rgba(0, 0, 0, 0.2);
                color: inherit !important; /* Inherit color from parent */
                flex-shrink: 0; /* Prevent icon from shrinking */
            }

            .toast-notification .close-btn {
                margin-left: auto;
                background: none;
                border: none;
                color: inherit !important; /* Inherit color from parent */
                font-size: 1.1rem;
                cursor: pointer;
                padding: 4px;
                border-radius: 4px;
                transition: all 0.2s ease;
                opacity: 0.8;
                flex-shrink: 0; /* Prevent button from shrinking */
            }

            .toast-notification .close-btn:hover {
                opacity: 1;
                background: rgba(255, 255, 255, 0.2);
            }

            .toast-notification .message {
                flex: 1;
                line-height: 1.4;
                text-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
                color: inherit !important; /* Inherit color from parent */
                font-weight: 500;
                word-wrap: break-word;
                overflow-wrap: break-word;
            }

            /* Ensure text is visible in all cases */
            .toast-notification * {
                color: inherit !important;
            }

            /* Responsive adjustments for mobile */
            @media (max-width: 768px) {
                .toast-notification {
                    top: 90px;
                    right: 15px;
                    left: 15px;
                    min-width: auto;
                    max-width: none;
                    font-size: 0.9rem;
                }
            }

            /* Animation for progress update */
            .progress-update-animation {
                animation: progressPulse 0.6s ease-out;
            }

            @keyframes progressPulse {
                0% {
                    transform: scale(1);
                }
                50% {
                    transform: scale(1.05);
                }
                100% {
                    transform: scale(1);
                }
            }

            /* Mark completed button loading state */
            #markCompletedBtn.loading {
                pointer-events: none;
                opacity: 0.7;
            }

            #markCompletedBtn.loading i {
                animation: spin 1s linear infinite;
            }

            @keyframes spin {
                0% {
                    transform: rotate(0deg);
                }
                100% {
                    transform: rotate(360deg);
                }
            }

            /* Completed lesson animation */
            .lesson-item.newly-completed {
                animation: completionGlow 1s ease-out;
            }

            @keyframes completionGlow {
                0% {
                    box-shadow: 0 0 0 rgba(16, 185, 129, 0.4);
                }
                50% {
                    box-shadow: 0 0 20px rgba(16, 185, 129, 0.6);
                }
                100% {
                    box-shadow: 0 0 0 rgba(16, 185, 129, 0.4);
                }
            }

            /* Responsive adjustments for mobile */
            @media (max-width: 768px) {
                .toast-notification {
                    top: 90px;
                    right: 15px;
                    left: 15px;
                    min-width: auto;
                    max-width: none;
                    font-size: 0.9rem;
                }

                .text-lesson-actions {
                    margin: 20px 0;
                    padding: 16px;
                }

                #markCompletedBtn {
                    padding: 10px 24px;
                    font-size: 1rem;
                }
            }
            .completion-prompt {
                text-align: center;
            }

            .completion-prompt h6 {
                color: var(--text-primary);
                font-weight: 600;
                margin-bottom: 15px;
            }

            .completion-prompt kbd {
                background-color: #f8f9fa;
                border: 1px solid #dee2e6;
                border-radius: 3px;
                box-shadow: 0 1px 0 rgba(0,0,0,.2), inset 0 0 0 2px #fff;
                color: #495057;
                display: inline-block;
                font-size: 0.8em;
                font-weight: 700;
                line-height: 1;
                padding: 2px 4px;
                white-space: nowrap;
            }

            .completion-prompt .text-muted {
                font-size: 0.85rem;
                opacity: 0.8;
            }

            /* Enhanced completed indicator */
            .completed-indicator {
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
                font-size: 1.1rem;
                padding: 15px;
                background: linear-gradient(135deg,
                    rgba(16, 185, 129, 0.1) 0%,
                    rgba(5, 150, 105, 0.1) 100%);
                border: 2px solid rgba(16, 185, 129, 0.3);
                border-radius: 12px;
            }

            .completed-indicator i {
                font-size: 1.3rem;
                color: #10b981;
            }
            /* Force text visibility in toast notifications */
            .toast-notification,
            .toast-notification *,
            .toast-notification .message,
            .toast-notification i,
            .toast-notification button {
                color: white !important;
                text-shadow: 0 1px 2px rgba(0, 0, 0, 0.3) !important;
            }

            /* Ensure proper font inheritance */
            .toast-notification {
                font-family: 'Inter', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif !important;
                font-size: 0.95rem !important;
                font-weight: 500 !important;
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
                                        <i class="fas fa-user-tie"></i>
                                        <span>Instructor: ${courseProgress.teacherName}</span>
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
                                                        <c:set var="testResult" value="${testResults[test.test_id]}" />
                                                        <c:set var="hasResult" value="${testResult != null && testResult.has_taken}" />

                                                        <div class="test-item-container">
                                                            <c:choose>
                                                                <c:when test="${test.is_practice}">
                                                                    <!-- Practice Test -->
                                                                    <a href="/student/taketest?action=start&testId=${test.test_id}" 
                                                                       class="test-item practice-test">
                                                                        <i class="fas fa-dumbbell"></i>
                                                                        <span>${test.test_name}</span>
                                                                        <small class="test-type-badge practice-badge">Practice</small>
                                                                    </a>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <!-- Official Test -->
                                                                    <c:choose>
                                                                        <c:when test="${hasResult}">
                                                                            <!-- Already taken -->
                                                                            <div class="test-item official-test completed">
                                                                                <i class="fas fa-clipboard-check"></i>
                                                                                <span>${test.test_name}</span>
                                                                                <div class="test-status">
                                                                                    <small class="test-type-badge official-badge">Official</small>
                                                                                    <small class="test-score">Score: <fmt:formatNumber value="${testResult.score}" maxFractionDigits="1"/>%</small>
                                                                                </div>
                                                                            </div>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <!-- Not taken yet -->
                                                                            <a href="/student/taketest?action=start&testId=${test.test_id}" 
                                                                               class="test-item official-test">
                                                                                <i class="fas fa-clipboard-check"></i>
                                                                                <span>${test.test_name}</span>
                                                                                <div class="test-status">
                                                                                    <small class="test-type-badge official-badge">Official</small>
                                                                                    <small class="test-not-taken">Not Taken</small>
                                                                                </div>
                                                                            </a>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
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
                                                        <c:set var="testResult" value="${testResults[test.test_id]}" />
                                                        <c:set var="hasResult" value="${testResult != null && testResult.has_taken}" />

                                                        <div class="test-item-container">
                                                            <c:choose>
                                                                <c:when test="${test.is_practice}">
                                                                    <!-- Practice Test -->
                                                                    <a href="/student/taketest?action=start&testId=${test.test_id}" 
                                                                       class="test-item practice-test">
                                                                        <i class="fas fa-dumbbell"></i>
                                                                        <span>${test.test_name}</span>
                                                                        <small class="test-type-badge practice-badge">Practice</small>
                                                                    </a>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <!-- Official Test -->
                                                                    <c:choose>
                                                                        <c:when test="${hasResult}">
                                                                            <!-- Already taken -->
                                                                            <div class="test-item official-test completed">
                                                                                <i class="fas fa-clipboard-check"></i>
                                                                                <span>${test.test_name}</span>
                                                                                <div class="test-status">
                                                                                    <small class="test-type-badge official-badge">Official</small>
                                                                                    <small class="test-score">Score: <fmt:formatNumber value="${testResult.score}" maxFractionDigits="1"/>%</small>
                                                                                </div>
                                                                            </div>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <!-- Not taken yet -->
                                                                            <a href="/student/taketest?action=start&testId=${test.test_id}" 
                                                                               class="test-item official-test">
                                                                                <i class="fas fa-clipboard-check"></i>
                                                                                <span>${test.test_name}</span>
                                                                                <div class="test-status">
                                                                                    <small class="test-type-badge official-badge">Official</small>
                                                                                    <small class="test-not-taken">Not Taken</small>
                                                                                </div>
                                                                            </a>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
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

                                    <c:if test="${empty currentLesson.video_link && isTrackingEnabled}">
                                        <c:set var="currentProgress" value="${lessonProgressMap[currentLesson.lesson_id]}" />
                                        <c:set var="isCompleted" value="${currentProgress != null && currentProgress.completed}" />

                                        <div class="text-lesson-actions">
                                            <c:choose>
                                                <c:when test="${isCompleted}">
                                                    <div class="completed-indicator">
                                                        <i class="fas fa-check-circle text-success"></i>
                                                        <span class="text-success font-weight-bold">✅ Lesson Completed</span>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="completion-prompt">
                                                        <h6 class="mb-3">
                                                            <i class="fas fa-book-reader mr-2"></i>
                                                            Have you finished reading this lesson?
                                                        </h6>
                                                        <button id="markCompletedBtn" class="btn btn-success btn-lg" onclick="markTextLessonCompleted()">
                                                            <i class="fas fa-check"></i> Mark as Completed
                                                        </button>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </c:if>

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
                                                                    // Ensure chevron is in correct position
                                                                    trigger.find('.fa-chevron-down').removeClass('fa-chevron-down').addClass('fa-chevron-up');
                                                                });

                                                                // Handle collapse events for proper icon rotation and state management
                                                                $('.collapse').on('show.bs.collapse', function (e) {
                                                                    // Prevent event bubbling to parent collapses
                                                                    e.stopPropagation();

                                                                    const targetId = $(this).attr('id');
                                                                    const trigger = $('[data-target="#' + targetId + '"]');

                                                                    // Update aria-expanded attribute
                                                                    trigger.attr('aria-expanded', 'true');

                                                                    // Rotate chevron icon
                                                                    trigger.find('.fa-chevron-down').removeClass('fa-chevron-down').addClass('fa-chevron-up');

                                                                    console.log('Expanding chapter:', targetId);
                                                                });

                                                                $('.collapse').on('hide.bs.collapse', function (e) {
                                                                    // Prevent event bubbling to parent collapses
                                                                    e.stopPropagation();

                                                                    const targetId = $(this).attr('id');
                                                                    const trigger = $('[data-target="#' + targetId + '"]');

                                                                    // Update aria-expanded attribute
                                                                    trigger.attr('aria-expanded', 'false');

                                                                    // Rotate chevron icon back
                                                                    trigger.find('.fa-chevron-up').removeClass('fa-chevron-up').addClass('fa-chevron-down');

                                                                    console.log('Collapsing chapter:', targetId);
                                                                });

                                                                // Handle manual clicks on chapter headers
                                                                $('.chapter-header').on('click', function (e) {
                                                                    e.preventDefault();
                                                                    e.stopPropagation();

                                                                    const target = $(this).attr('data-target');
                                                                    const $collapse = $(target);

                                                                    // Toggle the collapse manually
                                                                    if ($collapse.hasClass('show')) {
                                                                        $collapse.collapse('hide');
                                                                    } else {
                                                                        $collapse.collapse('show');
                                                                    }
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
                                                                        // Update corresponding buttons
                                                                        $('.course-sidebar .collapse').not(':has(.lesson-item.active)').each(function () {
                                                                            const targetId = $(this).attr('id');
                                                                            const trigger = $('[data-target="#' + targetId + '"]');
                                                                            trigger.attr('aria-expanded', 'false');
                                                                            trigger.find('.fa-chevron-up').removeClass('fa-chevron-up').addClass('fa-chevron-down');
                                                                        });
                                                                    }
                                                                }

                                                                adjustForMobile();
                                                                $(window).resize(adjustForMobile);
                                                            });

                                                            function showWarningMessage(message) {
                                                                showToastNotification(message, 'warning', 'fa-exclamation-triangle');
                                                            }

                                                            function showSuccessMessage(message) {
                                                                showToastNotification(message, 'success', 'fa-check-circle');
                                                            }

                                                            function showErrorMessage(message) {
                                                                showToastNotification(message, 'error', 'fa-times-circle');
                                                            }

                                                            function showToastNotification(message, type, iconClass) {
                                                                 // Remove any existing notifications
                                                                const existingToasts = document.querySelectorAll('.toast-notification');
                                                                existingToasts.forEach(toast => toast.remove());

                                                                // Create new notification using DOM methods
                                                                const toastId = 'toast-' + Date.now();

                                                                // Create main container
                                                                const toast = document.createElement('div');
                                                                toast.id = toastId;
                                                                toast.className = `toast-notification ${type}`;

                                                                // Create icon
                                                                const icon = document.createElement('i');
                                                                icon.className = `fas ${iconClass}`;

                                                                // Create message container
                                                                const messageDiv = document.createElement('div');
                                                                messageDiv.className = 'message';
                                                                messageDiv.textContent = message;

                                                                // Create close button
                                                                const closeBtn = document.createElement('button');
                                                                closeBtn.className = 'close-btn';
                                                                closeBtn.onclick = () => closeToast(toastId);

                                                                const closeIcon = document.createElement('i');
                                                                closeIcon.className = 'fas fa-times';
                                                                closeBtn.appendChild(closeIcon);

                                                                // Assemble toast
                                                                toast.appendChild(icon);
                                                                toast.appendChild(messageDiv);
                                                                toast.appendChild(closeBtn);

                                                                // Add to body
                                                                document.body.appendChild(toast);

                                                                // Force styles to ensure visibility
                                                                toast.style.position = 'fixed';
                                                                toast.style.zIndex = '10000';
                                                                toast.style.color = 'white';
                                                                toast.style.display = 'flex';

                                                                // Trigger show animation
                                                                setTimeout(() => {
                                                                    toast.classList.add('show');
                                                                }, 100);

                                                                // Auto-hide after 5 seconds
                                                                setTimeout(() => {
                                                                    hideToast(toastId);
                                                                }, 5000);
                                                            }

                                                            function closeToast(toastId) {
                                                                hideToast(toastId);
                                                            }

                                                            function hideToast(toastId) {
                                                                const toast = document.getElementById(toastId);
                                                                if (toast) {
                                                                    toast.classList.remove('show');
                                                                    setTimeout(() => {
                                                                        toast.remove();
                                                                    }, 400);
                                                                }
                                                            }

                                                            function markTextLessonCompleted() {
                                                                const lessonId = ${currentLesson.lesson_id};
                                                                const courseId = ${courseId};

                                                                // Disable button and show loading state
                                                                const btn = document.getElementById('markCompletedBtn');
                                                                btn.disabled = true;
                                                                btn.classList.add('loading');
                                                                btn.innerHTML = '<i class="fas fa-spinner"></i> Marking as Completed...';

                                                                $.ajax({
                                                                    url: '/video-viewer',
                                                                    method: 'POST',
                                                                    data: {
                                                                        action: 'markTextLessonCompleted',
                                                                        lessonId: lessonId,
                                                                        courseId: courseId
                                                                    },
                                                                    success: function (response) {
                                                                        if (response.success) {
                                                                            // Show success message with explicit message
                                                                            const successMessage = response.message || 'Lesson marked as completed! Great job!';
                                                                            showSuccessMessage('🎉 ' + successMessage);

                                                                            // Update UI with animation
                                                                            $('.text-lesson-actions').fadeOut(300, function () {
                                                                                $(this).html(`
                        <div class="completed-indicator">
                            <i class="fas fa-check-circle text-success"></i>
                            <span class="text-success font-weight-bold">✅ Lesson Completed</span>
                        </div>
                    `).fadeIn(300);
                                                                            });

                                                                            // Update sidebar lesson item with animation
                                                                            const lessonItem = $(`.lesson-item[href*="lessonId=${lessonId}"]`);
                                                                            lessonItem.addClass('newly-completed');
                                                                            setTimeout(() => {
                                                                                lessonItem.addClass('completed').removeClass('newly-completed');
                                                                            }, 600);

                                                                            // Update progress bar with animation if visible
                                                                            const progressBar = $('.progress-bar-fill');
                                                                            if (progressBar.length) {
                                                                                progressBar.parent().addClass('progress-update-animation');
                                                                                setTimeout(() => {
                                                                                    progressBar.parent().removeClass('progress-update-animation');
                                                                                }, 600);
                                                                            }

                                                                            // Reload page after 3 seconds to update progress
                                                                            setTimeout(function () {
                                                                                window.location.reload();
                                                                            }, 3000);

                                                                        } else {
                                                                            const errorMessage = response.message || 'Failed to mark lesson as completed. Please try again.';
                                                                            showWarningMessage(errorMessage);
                                                                            // Re-enable button
                                                                            resetMarkCompletedButton(btn);
                                                                        }
                                                                    },
                                                                    error: function (xhr, status, error) {
                                                                        const errorMessage = 'Error marking lesson as completed. Please check your connection and try again.';
                                                                        showErrorMessage(errorMessage);
                                                                        // Re-enable button
                                                                        resetMarkCompletedButton(btn);
                                                                    }
                                                                });
                                                            }

                                                            function resetMarkCompletedButton(btn) {
                                                                btn.disabled = false;
                                                                btn.classList.remove('loading');
                                                                btn.innerHTML = '<i class="fas fa-check"></i> Mark as Completed';
                                                            }
                                                            function goToNextLesson() {
                                                                const nextBtn = $('.nav-btn.next[href]');
                                                                if (nextBtn.length) {
                                                                    showSuccessMessage('Moving to next lesson...');
                                                                    setTimeout(() => {
                                                                        window.location.href = nextBtn.attr('href');
                                                                    }, 1000);
                                                                }
                                                            }
        </script>
    </body>
</html>