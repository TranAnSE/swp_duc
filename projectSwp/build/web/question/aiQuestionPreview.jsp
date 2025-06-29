<%-- 
    Document   : aiQuestionPreview
    Created on : Jun 26, 2025, 10:22:14 PM
    Author     : ankha
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
    <head>
        <title>AI Generated Questions - Preview</title>
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

            .preview-container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 20px;
            }

            .preview-header {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                padding: 30px;
                border-radius: 20px;
                box-shadow: var(--shadow-lg);
                border: 1px solid rgba(255, 255, 255, 0.2);
                margin-bottom: 30px;
                text-align: center;
            }

            .preview-header h2 {
                color: var(--text-primary);
                font-weight: 700;
                font-size: 2.5rem;
                margin-bottom: 10px;
                background: var(--gradient-primary);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
            }

            .preview-stats {
                display: flex;
                justify-content: center;
                gap: 30px;
                margin-top: 20px;
                flex-wrap: wrap;
            }

            .stat-card {
                background: linear-gradient(135deg, rgba(79, 70, 229, 0.1) 0%, rgba(6, 182, 212, 0.1) 100%);
                border: 1px solid rgba(79, 70, 229, 0.2);
                border-radius: 12px;
                padding: 15px 20px;
                text-align: center;
                min-width: 120px;
            }

            .stat-number {
                font-size: 1.5rem;
                font-weight: 700;
                color: var(--primary-color);
                display: block;
            }

            .stat-label {
                font-size: 0.9rem;
                color: var(--text-secondary);
                margin-top: 5px;
            }

            .question-card {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                border-radius: 16px;
                padding: 25px;
                margin-bottom: 25px;
                box-shadow: var(--shadow-md);
                border: 1px solid rgba(255, 255, 255, 0.2);
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;
            }

            .question-card::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                height: 4px;
                background: var(--gradient-primary);
                opacity: 0;
                transition: opacity 0.3s ease;
            }

            .question-card:hover::before {
                opacity: 1;
            }

            .question-card:hover {
                transform: translateY(-2px);
                box-shadow: var(--shadow-lg);
            }

            .question-header {
                display: flex;
                justify-content: space-between;
                align-items: flex-start;
                margin-bottom: 20px;
                flex-wrap: wrap;
                gap: 15px;
            }

            .question-number {
                background: var(--gradient-primary);
                color: white;
                padding: 8px 16px;
                border-radius: 20px;
                font-weight: 600;
                font-size: 0.9rem;
                min-width: 80px;
                text-align: center;
            }

            .question-type-badge {
                padding: 6px 12px;
                border-radius: 15px;
                font-size: 0.8rem;
                font-weight: 600;
                text-transform: uppercase;
            }

            .type-single {
                background: linear-gradient(135deg, #ecfdf5 0%, #d1fae5 100%);
                color: #065f46;
                border: 1px solid #10b981;
            }

            .type-multiple {
                background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
                color: #92400e;
                border: 1px solid #f59e0b;
            }

            .type-true-false {
                background: linear-gradient(135deg, #e0e7ff 0%, #c7d2fe 100%);
                color: #3730a3;
                border: 1px solid #6366f1;
            }

            .question-content {
                background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
                border: 1px solid #e2e8f0;
                border-radius: 12px;
                padding: 20px;
                margin-bottom: 20px;
            }

            .question-text {
                font-size: 1.1rem;
                font-weight: 500;
                color: var(--text-primary);
                line-height: 1.6;
                margin-bottom: 15px;
            }

            .options-list {
                list-style: none;
                padding: 0;
                margin: 0;
            }

            .option-item {
                background: white;
                border: 2px solid #e5e7eb;
                border-radius: 8px;
                padding: 12px 16px;
                margin-bottom: 8px;
                display: flex;
                align-items: center;
                gap: 12px;
                transition: all 0.2s ease;
            }

            .option-item:hover {
                border-color: var(--primary-color);
                background: rgba(79, 70, 229, 0.02);
            }

            .option-item.correct {
                border-color: var(--success-color);
                background: linear-gradient(135deg, #ecfdf5 0%, #d1fae5 100%);
            }

            .option-letter {
                background: var(--primary-color);
                color: white;
                width: 24px;
                height: 24px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: 600;
                font-size: 0.8rem;
                flex-shrink: 0;
            }

            .option-item.correct .option-letter {
                background: var(--success-color);
            }

            .correct-indicator {
                margin-left: auto;
                color: var(--success-color);
                font-weight: 600;
                font-size: 0.9rem;
            }

            .question-actions {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding-top: 20px;
                border-top: 1px solid #e5e7eb;
                flex-wrap: wrap;
                gap: 15px;
            }

            .approve-checkbox {
                display: flex;
                align-items: center;
                gap: 10px;
                background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
                border: 1px solid #0ea5e9;
                border-radius: 8px;
                padding: 10px 15px;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .approve-checkbox:hover {
                background: linear-gradient(135deg, #e0f2fe 0%, #bae6fd 100%);
            }

            .approve-checkbox input[type="checkbox"] {
                width: 18px;
                height: 18px;
                accent-color: var(--primary-color);
            }

            .approve-checkbox label {
                font-weight: 600;
                color: #0c4a6e;
                cursor: pointer;
                margin: 0;
            }

            .edit-section {
                background: linear-gradient(135deg, #fefce8 0%, #fef3c7 100%);
                border: 1px solid #f59e0b;
                border-radius: 12px;
                padding: 20px;
                margin-top: 15px;
                display: none;
            }

            .edit-section.active {
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

            .edit-section h6 {
                color: #92400e;
                font-weight: 600;
                margin-bottom: 15px;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .form-control, .form-select {
                border: 2px solid #e5e7eb;
                border-radius: 8px;
                padding: 10px 12px;
                transition: all 0.3s ease;
            }

            .form-control:focus, .form-select:focus {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
                outline: none;
            }

            .action-buttons {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                padding: 25px;
                border-radius: 16px;
                box-shadow: var(--shadow-md);
                border: 1px solid rgba(255, 255, 255, 0.2);
                margin-top: 30px;
                text-align: center;
            }

            .btn-approve {
                background: var(--gradient-primary);
                border: none;
                padding: 14px 30px;
                font-size: 1.1rem;
                font-weight: 600;
                border-radius: 25px;
                color: white;
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;
                box-shadow: var(--shadow-md);
            }

            .btn-approve::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
                transition: left 0.5s ease;
            }

            .btn-approve:hover::before {
                left: 100%;
            }

            .btn-approve:hover {
                transform: translateY(-2px);
                box-shadow: var(--shadow-lg);
            }

            .btn-secondary {
                background: white;
                border: 2px solid #e5e7eb;
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

            .btn-edit {
                background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
                border: 1px solid #f59e0b;
                color: #92400e;
                padding: 8px 16px;
                border-radius: 8px;
                font-size: 0.9rem;
                font-weight: 500;
                transition: all 0.3s ease;
            }

            .btn-edit:hover {
                background: linear-gradient(135deg, #fde68a 0%, #fcd34d 100%);
                color: #78350f;
            }

            .ai-chat-section {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                border-radius: 16px;
                padding: 25px;
                margin-bottom: 30px;
                box-shadow: var(--shadow-md);
                border: 1px solid rgba(255, 255, 255, 0.2);
            }

            .chat-header {
                display: flex;
                align-items: center;
                gap: 12px;
                margin-bottom: 20px;
                padding-bottom: 15px;
                border-bottom: 1px solid #e5e7eb;
            }

            .chat-header h4 {
                color: var(--text-primary);
                font-weight: 600;
                margin: 0;
            }

            .chat-input-group {
                display: flex;
                gap: 10px;
                align-items: flex-end;
            }

            .chat-input {
                flex: 1;
                border: 2px solid #e5e7eb;
                border-radius: 12px;
                padding: 12px 16px;
                resize: vertical;
                min-height: 50px;
                transition: all 0.3s ease;
            }

            .chat-input:focus {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
                outline: none;
            }

            .btn-chat {
                background: var(--primary-color);
                border: none;
                color: white;
                padding: 12px 20px;
                border-radius: 12px;
                font-weight: 500;
                transition: all 0.3s ease;
                height: 50px;
            }

            .btn-chat:hover {
                background: #3730a3;
                transform: translateY(-1px);
            }

            .chat-response {
                background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
                border: 1px solid #0ea5e9;
                border-radius: 12px;
                padding: 15px;
                margin-top: 15px;
                display: none;
            }

            .chat-response.active {
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

            .bulk-actions-section {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                border-radius: 16px;
                padding: 20px;
                margin-bottom: 30px;
                box-shadow: var(--shadow-md);
                border: 1px solid rgba(255, 255, 255, 0.2);
            }

            .bulk-actions-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                flex-wrap: wrap;
                gap: 15px;
            }

            .bulk-actions-header h4 {
                color: var(--text-primary);
                font-weight: 600;
                margin: 0;
            }

            .bulk-buttons {
                display: flex;
                gap: 10px;
                flex-wrap: wrap;
            }

            .bulk-buttons .btn {
                padding: 8px 16px;
                font-size: 0.9rem;
                border-radius: 8px;
                transition: all 0.3s ease;
            }

            .bulk-buttons .btn:hover {
                transform: translateY(-1px);
            }

            .question-badges {
                display: flex;
                flex-wrap: wrap;
                gap: 10px;
                align-items: center;
            }

            .difficulty-badge {
                padding: 6px 12px;
                border-radius: 15px;
                font-size: 0.8rem;
                font-weight: 600;
                text-transform: uppercase;
            }

            .difficulty-easy {
                background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%);
                color: #065f46;
                border: 1px solid #10b981;
            }

            .difficulty-medium {
                background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
                color: #92400e;
                border: 1px solid #f59e0b;
            }

            .difficulty-hard {
                background: linear-gradient(135deg, #fee2e2 0%, #fecaca 100%);
                color: #991b1b;
                border: 1px solid #ef4444;
            }

            .difficulty-mixed {
                background: linear-gradient(135deg, #e0e7ff 0%, #c7d2fe 100%);
                color: #3730a3;
                border: 1px solid #6366f1;
            }

            .category-badge {
                padding: 6px 12px;
                border-radius: 15px;
                font-size: 0.8rem;
                font-weight: 600;
                text-transform: capitalize;
                background: linear-gradient(135deg, #f3e8ff 0%, #e9d5ff 100%);
                color: #6b21a8;
                border: 1px solid #a855f7;
            }

            /* Option Editing Styles */
            .options-edit-container {
                background: #f8fafc;
                border: 1px solid #e2e8f0;
                border-radius: 8px;
                padding: 15px;
            }

            .option-edit-row {
                background: white;
                border: 1px solid #e5e7eb;
                border-radius: 6px;
                padding: 10px;
                transition: all 0.2s ease;
            }

            .option-edit-row:hover {
                border-color: var(--primary-color);
                box-shadow: 0 2px 4px rgba(79, 70, 229, 0.1);
            }

            .option-letter-edit {
                background: var(--primary-color);
                color: white;
                width: 28px;
                height: 28px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: 600;
                font-size: 0.9rem;
                flex-shrink: 0;
                margin-right: 10px;
            }

            .option-text-edit {
                flex: 1;
                border: 1px solid #d1d5db;
                border-radius: 4px;
                padding: 6px 10px;
                font-size: 0.9rem;
            }

            .option-text-edit:focus {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 2px rgba(79, 70, 229, 0.1);
                outline: none;
            }

            .option-correct-edit {
                width: 18px;
                height: 18px;
                accent-color: var(--success-color);
            }

            /* Select2 Custom Styling for Edit Sections */
            .edit-section .select2-container--bootstrap-5 .select2-selection {
                border: 2px solid #e5e7eb !important;
                border-radius: 8px !important;
                min-height: 40px !important;
                padding: 4px 8px !important;
                font-size: 14px !important;
                transition: all 0.3s ease !important;
                background: white !important;
            }

            .edit-section .select2-container--bootstrap-5 .select2-selection--single {
                height: 40px !important;
                display: flex !important;
                align-items: center !important;
            }

            .edit-section .select2-container--bootstrap-5 .select2-selection--single .select2-selection__rendered {
                line-height: 30px !important;
                padding-left: 0 !important;
                padding-right: 20px !important;
                font-size: 14px !important;
                color: var(--text-primary) !important;
            }

            .edit-section .select2-container--bootstrap-5 .select2-selection__arrow {
                height: 38px !important;
                position: absolute !important;
                top: 1px !important;
                right: 8px !important;
                width: 20px !important;
            }

            .edit-section .select2-container--bootstrap-5.select2-container--focus .select2-selection,
            .edit-section .select2-container--bootstrap-5.select2-container--open .select2-selection {
                border-color: var(--primary-color) !important;
                box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1) !important;
                outline: none !important;
            }

            /* Dropdown styling for edit sections */
            .edit-section .select2-dropdown {
                background: white !important;
                border: 2px solid var(--primary-color) !important;
                border-radius: 8px !important;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15) !important;
                margin-top: 2px !important;
                z-index: 99999 !important; /* Increased z-index */
                font-size: 14px !important;
                position: fixed !important; /* Changed to fixed positioning */
            }

            .edit-section .select2-container--bootstrap-5 .select2-dropdown .select2-results__options {
                max-height: 200px !important;
            }

            .edit-section .select2-container--bootstrap-5 .select2-results__option {
                padding: 8px 12px !important;
                font-size: 14px !important;
                color: var(--text-primary) !important;
                cursor: pointer !important;
                transition: background-color 0.2s ease !important;
            }

            .edit-section .select2-container--bootstrap-5 .select2-results__option:hover,
            .edit-section .select2-container--bootstrap-5 .select2-results__option--highlighted {
                background-color: var(--primary-color) !important;
                color: white !important;
            }

            .edit-section .select2-container--bootstrap-5 .select2-results__option[aria-selected="true"] {
                background-color: rgba(79, 70, 229, 0.1) !important;
                color: var(--primary-color) !important;
                font-weight: 600 !important;
            }

            /* Ensure proper width and z-index for edit sections */
            .edit-section .select2-container {
                width: 100% !important;
                z-index: 1000 !important;
            }

            .edit-section .select2-container--open {
                z-index: 9999 !important;
            }

            /* Fix for disabled state in edit sections */
            .edit-section .select2-container--bootstrap-5.select2-container--disabled .select2-selection {
                background-color: #f3f4f6 !important;
                color: #9ca3af !important;
                cursor: not-allowed !important;
            }

            .edit-section .select2-container--bootstrap-5.select2-container--disabled .select2-selection--single .select2-selection__rendered {
                color: #9ca3af !important;
            }

            /* Fix overflow issues in edit sections */
            .edit-section {
                position: relative !important;
                z-index: 10 !important;
                overflow: visible !important;
            }

            .question-card {
                position: relative !important;
                overflow: visible !important;
            }

            /* Fix for Select2 dropdown positioning in modal-like containers */
            .select2-dropdown--above {
                top: auto !important;
                bottom: 100% !important;
            }

            .select2-dropdown--below {
                top: 100% !important;
                bottom: auto !important;
            }

            /* Ensure dropdowns appear above other content */
            .select2-container--open .select2-dropdown {
                z-index: 99999 !important;
            }

            @media (max-width: 768px) {
                .preview-container {
                    padding: 15px;
                }

                .preview-header {
                    padding: 20px;
                    margin-bottom: 20px;
                }

                .preview-header h2 {
                    font-size: 2rem;
                }

                .preview-stats {
                    gap: 15px;
                }

                .question-card {
                    padding: 20px;
                    margin-bottom: 20px;
                }

                .question-header {
                    flex-direction: column;
                    align-items: stretch;
                    gap: 10px;
                }

                .question-actions {
                    flex-direction: column;
                    align-items: stretch;
                    gap: 10px;
                }

                .action-buttons {
                    padding: 20px;
                }

                .btn-approve {
                    width: 100%;
                    padding: 12px 20px;
                    font-size: 1rem;
                }

                .chat-input-group {
                    flex-direction: column;
                    gap: 10px;
                }

                .btn-chat {
                    width: 100%;
                }

                .bulk-actions-header {
                    flex-direction: column;
                    align-items: stretch;
                }

                .bulk-buttons {
                    justify-content: center;
                }

                .bulk-buttons .btn {
                    flex: 1;
                    min-width: 120px;
                }

                .question-badges {
                    flex-direction: column;
                    align-items: stretch;
                    gap: 8px;
                }

                .difficulty-badge,
                .category-badge {
                    text-align: center;
                }

                .option-edit-row {
                    flex-direction: column;
                    gap: 10px;
                }

                .option-letter-edit {
                    align-self: flex-start;
                }
            }

            @media (max-width: 480px) {
                body {
                    padding-top: 100px;
                }

                .preview-container {
                    padding: 10px;
                }

                .preview-header {
                    padding: 15px;
                }

                .question-card {
                    padding: 15px;
                }

                .ai-chat-section {
                    padding: 20px;
                }
            }
            /* Visual feedback for edited sections */
            .edit-section.has-changes {
                border-color: #10b981 !important;
                background: linear-gradient(135deg, #ecfdf5 0%, #d1fae5 100%) !important;
            }

            .edit-section.has-changes .edit-path-title {
                color: #065f46 !important;
            }

            /* Custom dropdown class for edit sections */
            .select2-dropdown-edit {
                border: 2px solid var(--primary-color) !important;
                border-radius: 8px !important;
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2) !important;
                z-index: 99999 !important;
            }

            /* Ensure proper stacking order */
            .question-card:hover {
                z-index: 20 !important;
            }

            .question-card .edit-section.active {
                z-index: 30 !important;
            }
            .edit-section .select2-container:not(:first-of-type) {
                display: none !important;
            }
            /* Ensure only one dropdown per select element */
            .select2-dropdown-edit + .select2-dropdown-edit {
                display: none !important;
            }
        </style>
    </head>
    <body>
        <jsp:include page="/header.jsp" />

        <div class="preview-container">
            <div class="preview-header">
                <h2><i class="fas fa-robot me-3"></i>AI Generated Questions</h2>
                <p class="text-muted">Review and approve the questions generated by AI</p>

                <div class="preview-stats">
                    <div class="stat-card">
                        <span class="stat-number">${fn:length(generatedQuestions)}</span>
                        <div class="stat-label">Generated</div>
                    </div>
                    <div class="stat-card">
                        <span class="stat-number" id="approvedCount">0</span>
                        <div class="stat-label">Approved</div>
                    </div>
                    <div class="stat-card">
                        <span class="stat-number" id="editedCount">0</span>
                        <div class="stat-label">Edited</div>
                    </div>
                </div>
            </div>

            <div class="bulk-actions-section">
                <div class="bulk-actions-header">
                    <h4><i class="fas fa-tasks me-2"></i>Bulk Actions</h4>
                    <div class="bulk-buttons">
                        <button type="button" class="btn btn-outline-primary" id="selectAllBtn">
                            <i class="fas fa-check-square me-2"></i>Select All
                        </button>
                        <button type="button" class="btn btn-outline-secondary" id="deselectAllBtn">
                            <i class="fas fa-square me-2"></i>Deselect All
                        </button>
                    </div>
                </div>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    ${error}
                </div>
            </c:if>

            <!-- AI Chat Assistant -->
            <div class="ai-chat-section">
                <div class="chat-header">
                    <i class="fas fa-comments text-primary fa-lg"></i>
                    <h4>Chat with AI Assistant</h4>
                    <span class="badge bg-primary">Beta</span>
                </div>
                <div class="chat-input-group">
                    <textarea id="chatInput" class="chat-input" 
                              placeholder="Ask AI to modify questions, explain concepts, or generate additional questions...&#10;&#10;Examples:&#10;• Make question 3 easier&#10;• Add more options to question 1&#10;• Explain the concept behind question 2"></textarea>
                    <button type="button" class="btn-chat" onclick="chatWithAI()">
                        <i class="fas fa-paper-plane me-2"></i>Send
                    </button>
                </div>
                <div id="chatResponse" class="chat-response"></div>
            </div>

            <!-- Questions Preview -->
            <form action="/ai-question" method="post" id="approveForm">
                <input type="hidden" name="action" value="approve">

                <c:forEach var="question" items="${generatedQuestions}" varStatus="status">
                    <div class="question-card" data-question-index="${status.index}">
                        <div class="question-header">
                            <div class="question-number">
                                Question ${status.index + 1}
                            </div>
                            <div class="question-badges">
                                <div class="question-type-badge type-${fn:toLowerCase(fn:replace(question.questionType, '_', '-'))}">
                                    <c:choose>
                                        <c:when test="${question.questionType == 'single_choice'}">Single Choice</c:when>
                                        <c:when test="${question.questionType == 'multiple_choice'}">Multiple Choice</c:when>
                                        <c:when test="${question.questionType == 'true_false'}">True/False</c:when>
                                        <c:otherwise>${question.questionType}</c:otherwise>
                                    </c:choose>
                                </div>

                                <%-- Add Difficulty Badge --%>
                                <div class="difficulty-badge difficulty-${fn:toLowerCase(question.difficulty)}">
                                    <i class="fas fa-chart-line me-1"></i>
                                    <c:choose>
                                        <c:when test="${question.difficulty == 'easy'}">Easy</c:when>
                                        <c:when test="${question.difficulty == 'medium'}">Medium</c:when>
                                        <c:when test="${question.difficulty == 'hard'}">Hard</c:when>
                                        <c:when test="${question.difficulty == 'mixed'}">Mixed</c:when>
                                        <c:otherwise>${question.difficulty}</c:otherwise>
                                    </c:choose>
                                </div>

                                <%-- Add Category Badge --%>
                                <div class="category-badge category-${fn:toLowerCase(question.category)}">
                                    <i class="fas fa-tag me-1"></i>
                                    <c:choose>
                                        <c:when test="${question.category == 'conceptual'}">Conceptual</c:when>
                                        <c:when test="${question.category == 'application'}">Application</c:when>
                                        <c:when test="${question.category == 'analysis'}">Analysis</c:when>
                                        <c:when test="${question.category == 'synthesis'}">Synthesis</c:when>
                                        <c:when test="${question.category == 'evaluation'}">Evaluation</c:when>
                                        <c:when test="${question.category == 'mixed'}">Mixed</c:when>
                                        <c:otherwise>${question.category}</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <div class="question-content">
                            <div class="question-text" id="questionText${status.index}">
                                ${question.question}
                            </div>

                            <ul class="options-list">
                                <c:forEach var="option" items="${question.options}" varStatus="optStatus">
                                    <li class="option-item ${question.correctAnswers.contains(optStatus.index) || question.correctAnswerIndex == optStatus.index ? 'correct' : ''}">
                                        <div class="option-letter">
                                            <c:out value="${fn:substring('ABCDEFGHIJKLMNOPQRSTUVWXYZ', optStatus.index, optStatus.index + 1)}" />
                                        </div>
                                        <span class="option-text">${option}</span>
                                        <c:if test="${question.correctAnswers.contains(optStatus.index) || question.correctAnswerIndex == optStatus.index}">
                                            <span class="correct-indicator">
                                                <i class="fas fa-check-circle me-1"></i>Correct
                                            </span>
                                        </c:if>
                                    </li>
                                </c:forEach>
                            </ul>

                            <c:if test="${not empty question.explanation}">
                                <div class="mt-3 p-3 bg-light rounded">
                                    <strong><i class="fas fa-lightbulb me-2 text-warning"></i>Explanation:</strong>
                                    <div class="mt-2" id="questionExplanation${status.index}">${question.explanation}</div>
                                </div>
                            </c:if>
                        </div>

                        <!-- Lesson Assignment Info -->
                        <div class="lesson-assignment-info mt-3 p-3" style="background: linear-gradient(135deg, #e0f2fe 0%, #b3e5fc 100%); border-radius: 8px; border-left: 4px solid #0ea5e9;">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-map-marker-alt text-primary me-2"></i>
                                <strong class="text-primary">Assigned to:</strong>
                                <span class="ms-2 text-dark fw-bold">
                                    <c:choose>
                                        <c:when test="${not empty question.lessonDisplayInfo}">
                                            ${question.lessonDisplayInfo}
                                        </c:when>
                                        <c:otherwise>
                                            <c:choose>
                                                <c:when test="${generationMode == 'lesson'}">
                                                    Selected Lesson
                                                </c:when>
                                                <c:when test="${generationMode == 'chapter'}">
                                                    Best matching lesson in selected chapter
                                                </c:when>
                                                <c:when test="${generationMode == 'subject'}">
                                                    Best matching lesson in selected subject
                                                </c:when>
                                                <c:otherwise>
                                                    Automatically assigned lesson
                                                </c:otherwise>
                                            </c:choose>
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <div class="mt-2">
                                <small class="text-muted">
                                    <i class="fas fa-info-circle me-1"></i>
                                    This question will be saved to the lesson shown above based on content analysis
                                </small>
                            </div>
                        </div>

                        <div class="question-actions">
                            <div class="approve-checkbox">
                                <input type="checkbox" name="approved" value="${status.index}" 
                                       id="approve${status.index}" onchange="updateApprovedCount()">
                                <label for="approve${status.index}">
                                    <i class="fas fa-check-circle me-1"></i>
                                    Approve this question
                                </label>
                            </div>

                            <button type="button" class="btn-edit" onclick="toggleEdit(${status.index})">
                                <i class="fas fa-edit me-1"></i>Edit Question
                            </button>
                        </div>

                        <!-- Edit Section -->
                        <div class="edit-section" id="editSection${status.index}">
                            <h6>
                                <i class="fas fa-edit"></i>
                                Edit Question ${status.index + 1}
                            </h6>

                            <div class="mb-3">
                                <label class="form-label">Question Text</label>
                                <textarea name="question_text" class="form-control" rows="3" 
                                          onchange="updateEditedCount()">${question.question}</textarea>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Explanation</label>
                                <textarea name="explanation" class="form-control" rows="2" 
                                          onchange="updateEditedCount()">${question.explanation}</textarea>
                            </div>

                            <%-- Options Editing Section --%>
                            <div class="mb-3">
                                <label class="form-label">Answer Options</label>
                                <div id="optionsContainer${status.index}" class="options-edit-container">
                                    <c:forEach var="option" items="${question.options}" varStatus="optStatus">
                                        <div class="option-edit-row d-flex align-items-center mb-2">
                                            <div class="option-letter-edit">
                                                <c:out value="${fn:substring('ABCDEFGHIJKLMNOPQRSTUVWXYZ', optStatus.index, optStatus.index + 1)}" />
                                            </div>
                                            <input type="text" class="form-control option-text-edit me-2" 
                                                   value="${option}" onchange="updateEditedCount()" 
                                                   data-question-index="${status.index}" data-option-index="${optStatus.index}">
                                            <div class="form-check">
                                                <input type="checkbox" class="form-check-input option-correct-edit" 
                                                       ${question.correctAnswers.contains(optStatus.index) || question.correctAnswerIndex == optStatus.index ? 'checked' : ''}
                                                       onchange="updateEditedCount()" 
                                                       data-question-index="${status.index}" data-option-index="${optStatus.index}">
                                                <label class="form-check-label">Correct</label>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                                <button type="button" class="btn btn-sm btn-success mt-2" 
                                        onclick="addNewOption(${status.index})">
                                    <i class="fas fa-plus me-1"></i>Add Option
                                </button>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <label class="form-label">Difficulty</label>
                                    <select class="form-select difficulty-select select2-edit" name="difficulty" 
                                            onchange="updateEditedCount()" data-question-index="${status.index}">
                                        <option value="easy" ${question.difficulty == 'easy' ? 'selected' : ''}>Easy</option>
                                        <option value="medium" ${question.difficulty == 'medium' ? 'selected' : ''}>Medium</option>
                                        <option value="hard" ${question.difficulty == 'hard' ? 'selected' : ''}>Hard</option>
                                        <option value="mixed" ${question.difficulty == 'mixed' ? 'selected' : ''}>Mixed</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Category</label>
                                    <select class="form-select category-select select2-edit" name="category" 
                                            onchange="updateEditedCount()" data-question-index="${status.index}">
                                        <option value="conceptual" ${question.category == 'conceptual' ? 'selected' : ''}>Conceptual Understanding</option>
                                        <option value="application" ${question.category == 'application' ? 'selected' : ''}>Practical Application</option>
                                        <option value="analysis" ${question.category == 'analysis' ? 'selected' : ''}>Critical Analysis</option>
                                        <option value="synthesis" ${question.category == 'synthesis' ? 'selected' : ''}>Knowledge Synthesis</option>
                                        <option value="evaluation" ${question.category == 'evaluation' ? 'selected' : ''}>Evaluation & Assessment</option>
                                        <option value="mixed" ${question.category == 'mixed' ? 'selected' : ''}>Mixed</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>

                <div class="action-buttons">
                    <div class="d-flex justify-content-center gap-3 flex-wrap">
                        <button type="submit" class="btn-approve" id="approveBtn" disabled>
                            <i class="fas fa-check-double me-2"></i>
                            Save Approved Questions
                        </button>
                        <a href="/ai-question?action=form" class="btn btn-secondary">
                            <i class="fas fa-arrow-left me-2"></i>
                            Generate More Questions
                        </a>
                        <a href="/Question" class="btn btn-secondary">
                            <i class="fas fa-list me-2"></i>
                            Back to Question List
                        </a>
                    </div>

                    <div class="mt-3 text-muted">
                        <i class="fas fa-info-circle me-1"></i>
                        Select the questions you want to add to your question bank, then click "Save Approved Questions"
                    </div>
                </div>
            </form>
        </div>

        <jsp:include page="/footer.jsp" />

        <script src="/assets/js/vendor/jquery-1.12.4.min.js"></script>
        <script src="/assets/js/bootstrap.min.js"></script>

        <!-- Select2 JS -->
        <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

        <script>
                                                $(document).ready(function () {
                                                    let editedQuestions = new Set();
                                                    let select2InitializedElements = new Set();

                                                    // Select2 initialization function for edit sections
                                                    function initializeSelect2ForEdit() {
                                                        $('.select2-edit').each(function () {
                                                            const $element = $(this);

                                                            // Skip if already initialized - improved check
                                                            if ($element.hasClass('select2-hidden-accessible')) {
                                                                return;
                                                            }

                                                            const elementId = $element.attr('id') || $element.attr('name') + '_' + Date.now() + '_' + Math.random().toString(36).substr(2, 5);
                                                            $element.attr('id', elementId);

                                                            // Skip if already in our tracking set
                                                            if (select2InitializedElements.has(elementId)) {
                                                                return;
                                                            }

                                                            try {
                                                                // Initialize Select2 with custom configuration for edit sections
                                                                $element.select2({
                                                                    theme: 'bootstrap-5',
                                                                    width: '100%',
                                                                    minimumResultsForSearch: Infinity,
                                                                    dropdownParent: $element.closest('.edit-section'), // Changed back to closest edit-section
                                                                    placeholder: function () {
                                                                        return $(this).find('option:first').text();
                                                                    },
                                                                    allowClear: false,
                                                                    escapeMarkup: function (markup) {
                                                                        return markup;
                                                                    },
                                                                    dropdownCssClass: 'select2-dropdown-edit'
                                                                });

                                                                // Mark as initialized
                                                                select2InitializedElements.add(elementId);
                                                                console.log('Select2 initialized for edit section element:', elementId);
                                                            } catch (error) {
                                                                console.error('Failed to initialize Select2 for edit section:', elementId, error);
                                                            }
                                                        });
                                                    }

                                                    // Safely destroy Select2 instance
                                                    function destroySelect2ForEdit(selector) {
                                                        const $element = $(selector);
                                                        if ($element.length && $element.hasClass('select2-hidden-accessible')) {
                                                            try {
                                                                $element.select2('destroy');
                                                                const elementId = $element.attr('id');
                                                                if (elementId) {
                                                                    select2InitializedElements.delete(elementId);
                                                                }
                                                                console.log('Select2 destroyed for edit section:', elementId);
                                                            } catch (error) {
                                                                console.error('Failed to destroy Select2 for edit section:', selector, error);
                                                            }
                                                        }
                                                    }

                                                    // Function to add new option to a question
                                                    window.addNewOption = function (questionIndex) {
                                                        const container = $('#optionsContainer' + questionIndex);
                                                        const currentOptions = container.find('.option-edit-row').length;
                                                        const nextLetter = String.fromCharCode(65 + currentOptions); // A, B, C, D, etc.

                                                        const newOptionHtml = `
                        <div class="option-edit-row d-flex align-items-center mb-2">
                            <div class="option-letter-edit">${nextLetter}</div>
                            <input type="text" class="form-control option-text-edit me-2" 
                                   placeholder="Enter option text" onchange="updateEditedCount()" 
                                   data-question-index="${questionIndex}" data-option-index="${currentOptions}">
                            <div class="form-check">
                                <input type="checkbox" class="form-check-input option-correct-edit" 
                                       onchange="updateEditedCount()" 
                                       data-question-index="${questionIndex}" data-option-index="${currentOptions}">
                                <label class="form-check-label">Correct</label>
                            </div>
                            <button type="button" class="btn btn-sm btn-danger ms-2" 
                                    onclick="removeOption(this, ${questionIndex})">
                                <i class="fas fa-times"></i>
                            </button>
                        </div>
                    `;

                                                        container.append(newOptionHtml);
                                                        updateEditedCount();
                                                    };

                                                    // Function to remove option
                                                    window.removeOption = function (button, questionIndex) {
                                                        const container = $('#optionsContainer' + questionIndex);
                                                        const optionRows = container.find('.option-edit-row');

                                                        // Don't allow removing if less than 2 options
                                                        if (optionRows.length <= 2) {
                                                            alert('A question must have at least 2 options.');
                                                            return;
                                                        }

                                                        $(button).closest('.option-edit-row').remove();

                                                        // Re-index the remaining options
                                                        container.find('.option-edit-row').each(function (index) {
                                                            const letter = String.fromCharCode(65 + index);
                                                            $(this).find('.option-letter-edit').text(letter);
                                                            $(this).find('.option-text-edit').attr('data-option-index', index);
                                                            $(this).find('.option-correct-edit').attr('data-option-index', index);
                                                        });

                                                        updateEditedCount();
                                                    };

                                                    // Auto-approve all questions on page load
                                                    function autoApproveAll() {
                                                        const checkboxes = document.querySelectorAll('input[name="approved"]');
                                                        checkboxes.forEach(cb => {
                                                            cb.checked = true;
                                                        });
                                                        updateApprovedCount();
                                                    }

                                                    // Select All functionality
                                                    function selectAll() {
                                                        const checkboxes = document.querySelectorAll('input[name="approved"]');
                                                        checkboxes.forEach(cb => {
                                                            cb.checked = true;
                                                        });
                                                        updateApprovedCount();

                                                        // Add visual feedback
                                                        $('#selectAllBtn').addClass('btn-success').removeClass('btn-outline-primary');
                                                        $('#deselectAllBtn').removeClass('btn-danger').addClass('btn-outline-secondary');

                                                        setTimeout(() => {
                                                            $('#selectAllBtn').removeClass('btn-success').addClass('btn-outline-primary');
                                                        }, 1000);
                                                    }

                                                    // Deselect All functionality  
                                                    function deselectAll() {
                                                        const checkboxes = document.querySelectorAll('input[name="approved"]');
                                                        checkboxes.forEach(cb => {
                                                            cb.checked = false;
                                                        });
                                                        updateApprovedCount();

                                                        // Add visual feedback
                                                        $('#deselectAllBtn').addClass('btn-danger').removeClass('btn-outline-secondary');
                                                        $('#selectAllBtn').removeClass('btn-success').addClass('btn-outline-primary');

                                                        setTimeout(() => {
                                                            $('#deselectAllBtn').removeClass('btn-danger').addClass('btn-outline-secondary');
                                                        }, 1000);
                                                    }

                                                    // Event listeners
                                                    $('#selectAllBtn').click(selectAll);
                                                    $('#deselectAllBtn').click(deselectAll);

                                                    function updateApprovedCount() {
                                                        const approvedCheckboxes = document.querySelectorAll('input[name="approved"]:checked');
                                                        const count = approvedCheckboxes.length;
                                                        document.getElementById('approvedCount').textContent = count;
                                                        document.getElementById('approveBtn').disabled = count === 0;

                                                        // Update bulk action button states
                                                        const totalCheckboxes = document.querySelectorAll('input[name="approved"]').length;
                                                        if (count === totalCheckboxes) {
                                                            $('#selectAllBtn').text('All Selected').addClass('btn-success').removeClass('btn-outline-primary');
                                                            $('#deselectAllBtn').removeClass('btn-danger').addClass('btn-outline-secondary');
                                                        } else if (count === 0) {
                                                            $('#selectAllBtn').text('Select All').removeClass('btn-success').addClass('btn-outline-primary');
                                                            $('#deselectAllBtn').text('All Deselected').addClass('btn-secondary').removeClass('btn-outline-secondary');
                                                            setTimeout(() => {
                                                                $('#deselectAllBtn').text('Deselect All').removeClass('btn-secondary').addClass('btn-outline-secondary');
                                                            }, 2000);
                                                        } else {
                                                            $('#selectAllBtn').text('Select All').removeClass('btn-success').addClass('btn-outline-primary');
                                                            $('#deselectAllBtn').text('Deselect All').removeClass('btn-danger btn-secondary').addClass('btn-outline-secondary');
                                                        }
                                                    }

                                                    function updateEditedCount() {
                                                        document.getElementById('editedCount').textContent = editedQuestions.size;
                                                    }

                                                    function toggleEdit(index) {
                                                        const editSection = document.getElementById('editSection' + index);
                                                        const isActive = editSection.classList.contains('active');

                                                        if (isActive) {
                                                            // Destroy Select2 instances BEFORE hiding
                                                            $(editSection).find('.select2-edit').each(function () {
                                                                if ($(this).hasClass('select2-hidden-accessible')) {
                                                                    destroySelect2ForEdit(this);
                                                                }
                                                            });
                                                            editSection.classList.remove('active');
                                                        } else {
                                                            editSection.classList.add('active');
                                                            editedQuestions.add(index);
                                                            updateEditedCount();

                                                            // Initialize Select2 with proper delay
                                                            setTimeout(() => {
                                                                initializeSelect2ForEdit();
                                                            }, 200);
                                                        }
                                                    }

                                                    function chatWithAI() {
                                                        const chatInput = document.getElementById('chatInput');
                                                        const chatResponse = document.getElementById('chatResponse');
                                                        const message = chatInput.value.trim();

                                                        if (!message) {
                                                            alert('Please enter a message to chat with AI');
                                                            return;
                                                        }

                                                        // Show loading state
                                                        chatResponse.innerHTML = '<div class="d-flex align-items-center">' +
                                                                '<div class="spinner-border spinner-border-sm text-primary me-3" role="status">' +
                                                                '<span class="visually-hidden">Loading...</span>' +
                                                                '</div>' +
                                                                '<span>AI is thinking...</span>' +
                                                                '</div>';
                                                        chatResponse.classList.add('active');

                                                        // Send request to AI
                                                        fetch('/ai-question', {
                                                            method: 'POST',
                                                            headers: {
                                                                'Content-Type': 'application/x-www-form-urlencoded',
                                                            },
                                                            body: new URLSearchParams({
                                                                'action': 'chat',
                                                                'message': message
                                                            })
                                                        })
                                                                .then(response => response.json())
                                                                .then(data => {
                                                                    if (data.error) {
                                                                        chatResponse.innerHTML = '<div class="text-danger">' +
                                                                                '<i class="fas fa-exclamation-triangle me-2"></i>' +
                                                                                'Error: ' + data.error +
                                                                                '</div>';
                                                                    } else {
                                                                        var formattedResponse = data.response.replace(/\n/g, '<br>');
                                                                        chatResponse.innerHTML = '<div class="d-flex align-items-start">' +
                                                                                '<i class="fas fa-robot text-primary me-3 mt-1"></i>' +
                                                                                '<div>' +
                                                                                '<strong class="text-primary">AI Assistant:</strong>' +
                                                                                '<div class="mt-2">' + formattedResponse + '</div>' +
                                                                                '</div>' +
                                                                                '</div>';
                                                                    }
                                                                })
                                                                .catch(error => {
                                                                    chatResponse.innerHTML = '<div class="text-danger">' +
                                                                            '<i class="fas fa-exclamation-triangle me-2"></i>' +
                                                                            'Failed to get AI response. Please try again.' +
                                                                            '</div>';
                                                                })
                                                                .finally(() => {
                                                                    chatInput.value = '';
                                                                });
                                                    }

                                                    // Allow Enter key to send chat message
                                                    document.getElementById('chatInput').addEventListener('keydown', function (e) {
                                                        if (e.key === 'Enter' && !e.shiftKey) {
                                                            e.preventDefault();
                                                            chatWithAI();
                                                        }
                                                    });

                                                    // form submission with option data collection
                                                    document.getElementById('approveForm').addEventListener('submit', function (e) {
                                                        const approvedCount = document.querySelectorAll('input[name="approved"]:checked').length;

                                                        if (approvedCount === 0) {
                                                            e.preventDefault();
                                                            alert('Please select at least one question to approve');
                                                            return;
                                                        }

                                                        // Collect edited option data before submission
                                                        collectEditedOptionsData();

                                                        // Show loading overlay
                                                        const submitBtn = document.getElementById('approveBtn');
                                                        const originalText = submitBtn.innerHTML;
                                                        submitBtn.disabled = true;
                                                        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Saving Questions...';

                                                        // Add loading overlay
                                                        document.body.insertAdjacentHTML('beforeend',
                                                                '<div id="savingOverlay" style="' +
                                                                'position: fixed;' +
                                                                'top: 0;' +
                                                                'left: 0;' +
                                                                'width: 100%;' +
                                                                'height: 100%;' +
                                                                'background: rgba(0, 0, 0, 0.5);' +
                                                                'display: flex;' +
                                                                'justify-content: center;' +
                                                                'align-items: center;' +
                                                                'z-index: 9999;' +
                                                                '">' +
                                                                '<div style="' +
                                                                'background: white;' +
                                                                'padding: 30px;' +
                                                                'border-radius: 15px;' +
                                                                'text-align: center;' +
                                                                'box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);' +
                                                                '">' +
                                                                '<i class="fas fa-save fa-3x text-success mb-3"></i>' +
                                                                '<h4>Saving Questions to Database...</h4>' +
                                                                '<p class="text-muted">Processing ' + approvedCount + ' approved questions with all modifications</p>' +
                                                                '<div class="spinner-border text-success" role="status">' +
                                                                '<span class="visually-hidden">Loading...</span>' +
                                                                '</div>' +
                                                                '</div>' +
                                                                '</div>'
                                                                );

                                                        // If saving fails, restore button (timeout fallback)
                                                        setTimeout(() => {
                                                            const overlay = document.getElementById('savingOverlay');
                                                            if (overlay) {
                                                                overlay.remove();
                                                                submitBtn.disabled = false;
                                                                submitBtn.innerHTML = originalText;
                                                            }
                                                        }, 30000); // 30 second timeout
                                                    });

                                                    // Function to collect edited options data and add to form
                                                    function collectEditedOptionsData() {
                                                        const form = document.getElementById('approveForm');

                                                        // Remove any existing option data inputs
                                                        $(form).find('input[name^="option_"], input[name^="correct_"]').remove();

                                                        // Collect data from each question's edit section
                                                        $('.edit-section.active').each(function () {
                                                            const questionIndex = $(this).attr('id').replace('editSection', '');
                                                            const container = $(this).find('.options-edit-container');

                                                            // Collect option texts
                                                            container.find('.option-text-edit').each(function (optionIndex) {
                                                                const optionText = $(this).val();
                                                                const hiddenInput = $('<input type="hidden">');
                                                                hiddenInput.attr('name', 'option_text_' + questionIndex + '_' + optionIndex);
                                                                hiddenInput.val(optionText);
                                                                $(form).append(hiddenInput);
                                                            });

                                                            // Collect correct answers
                                                            container.find('.option-correct-edit').each(function (optionIndex) {
                                                                const isCorrect = $(this).is(':checked');
                                                                const hiddenInput = $('<input type="hidden">');
                                                                hiddenInput.attr('name', 'correct_answer_' + questionIndex + '_' + optionIndex);
                                                                hiddenInput.val(isCorrect);
                                                                $(form).append(hiddenInput);
                                                            });
                                                        });
                                                    }

                                                    // Keyboard shortcuts
                                                    document.addEventListener('keydown', function (e) {
                                                        // Ctrl/Cmd + A: Select all questions
                                                        if ((e.ctrlKey || e.metaKey) && e.key === 'a' && e.target.tagName !== 'INPUT' && e.target.tagName !== 'TEXTAREA') {
                                                            e.preventDefault();
                                                            selectAll();
                                                        }

                                                        // Ctrl/Cmd + D: Deselect all questions  
                                                        if ((e.ctrlKey || e.metaKey) && e.key === 'd' && e.target.tagName !== 'INPUT' && e.target.tagName !== 'TEXTAREA') {
                                                            e.preventDefault();
                                                            deselectAll();
                                                        }

                                                        // Ctrl/Cmd + S: Save approved questions
                                                        if ((e.ctrlKey || e.metaKey) && e.key === 's') {
                                                            e.preventDefault();
                                                            const approveBtn = document.getElementById('approveBtn');
                                                            if (!approveBtn.disabled) {
                                                                document.getElementById('approveForm').submit();
                                                            }
                                                        }

                                                        // Escape: Close all edit sections
                                                        if (e.key === 'Escape') {
                                                            document.querySelectorAll('.edit-section.active').forEach(section => {
                                                                const questionIndex = section.id.replace('editSection', '');
                                                                toggleEdit(questionIndex);
                                                            });
                                                        }
                                                    });

                                                    // Initialize page
                                                    autoApproveAll(); // Auto-approve all questions on load

                                                    // Smooth scroll animations
                                                    const observer = new IntersectionObserver((entries) => {
                                                        entries.forEach(entry => {
                                                            if (entry.isIntersecting) {
                                                                entry.target.style.opacity = '1';
                                                                entry.target.style.transform = 'translateY(0)';
                                                            }
                                                        });
                                                    });

                                                    document.querySelectorAll('.question-card').forEach(card => {
                                                        card.style.opacity = '0';
                                                        card.style.transform = 'translateY(20px)';
                                                        card.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
                                                        observer.observe(card);
                                                    });

                                                    // Auto-scroll to first question on load
                                                    setTimeout(() => {
                                                        const firstQuestion = document.querySelector('.question-card');
                                                        if (firstQuestion) {
                                                            firstQuestion.scrollIntoView({
                                                                behavior: 'smooth',
                                                                block: 'start',
                                                                inline: 'nearest'
                                                            });
                                                        }
                                                    }, 500);

                                                    // Initialize tooltips for better UX
                                                    const tooltips = [
                                                        {selector: '.question-type-badge', title: 'Question type generated by AI'},
                                                        {selector: '.difficulty-badge', title: 'Difficulty level of this question'},
                                                        {selector: '.category-badge', title: 'Educational category of this question'},
                                                        {selector: '.correct-indicator', title: 'This is the correct answer'},
                                                        {selector: '.approve-checkbox', title: 'Check to include this question in your question bank'},
                                                        {selector: '.btn-edit', title: 'Click to modify this question before saving'}
                                                    ];

                                                    tooltips.forEach(tooltip => {
                                                        document.querySelectorAll(tooltip.selector).forEach(element => {
                                                            element.setAttribute('title', tooltip.title);
                                                            element.setAttribute('data-bs-toggle', 'tooltip');
                                                        });
                                                    });

                                                    // Initialize Bootstrap tooltips if available
                                                    if (typeof bootstrap !== 'undefined' && bootstrap.Tooltip) {
                                                        const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
                                                        tooltipTriggerList.map(function (tooltipTriggerEl) {
                                                            return new bootstrap.Tooltip(tooltipTriggerEl);
                                                        });
                                                    }

                                                    // Make functions globally available
                                                    window.toggleEdit = toggleEdit;
                                                    window.chatWithAI = chatWithAI;
                                                    window.updateApprovedCount = updateApprovedCount;
                                                    window.updateEditedCount = updateEditedCount;

                                                    // Cleanup on page unload
                                                    $(window).on('beforeunload', function () {
                                                        $('.select2-edit').each(function () {
                                                            const elementId = $(this).attr('id') || $(this).attr('name');
                                                            destroySelect2ForEdit('#' + elementId);
                                                        });
                                                    });

                                                    // Handle Select2 dropdown positioning in edit sections
                                                    $(document).on('select2:open', function (e) {
                                                        const selectId = e.target.id || e.target.name;
                                                        const $select = $(e.target);
                                                        const $dropdown = $('.select2-dropdown');

                                                        if ($dropdown.length && $select.closest('.edit-section').length) {
                                                            // For edit section dropdowns, ensure they appear above other content
                                                            $dropdown.css({
                                                                'z-index': '99999',
                                                                'position': 'fixed'
                                                            });

                                                            // Calculate position to avoid going off-screen
                                                            const selectOffset = $select.offset();
                                                            const selectHeight = $select.outerHeight();
                                                            const dropdownHeight = $dropdown.outerHeight();
                                                            const windowHeight = $(window).height();
                                                            const scrollTop = $(window).scrollTop();

                                                            // Check if dropdown would go below viewport
                                                            if (selectOffset.top + selectHeight + dropdownHeight > scrollTop + windowHeight) {
                                                                // Position above the select
                                                                $dropdown.css({
                                                                    'top': selectOffset.top - dropdownHeight - 5,
                                                                    'left': selectOffset.left
                                                                }).addClass('select2-dropdown--above').removeClass('select2-dropdown--below');
                                                            } else {
                                                                // Position below the select (default)
                                                                $dropdown.css({
                                                                    'top': selectOffset.top + selectHeight + 2,
                                                                    'left': selectOffset.left
                                                                }).addClass('select2-dropdown--below').removeClass('select2-dropdown--above');
                                                            }
                                                        }
                                                    });

                                                    // Ensure Select2 dropdowns close properly when clicking outside edit sections
                                                    $(document).on('click', function (e) {
                                                        // Close edit sections when clicking outside
                                                        if (!$(e.target).closest('.edit-section, .btn-edit').length) {
                                                            $('.edit-section.active').each(function () {
                                                                const questionIndex = $(this).attr('id').replace('editSection', '');
                                                                // Destroy Select2 before closing
                                                                $(this).find('.select2-edit').each(function () {
                                                                    if ($(this).hasClass('select2-hidden-accessible')) {
                                                                        destroySelect2ForEdit(this);
                                                                    }
                                                                });
                                                                $(this).removeClass('active');
                                                            });
                                                        }
                                                    });

                                                    // Handle window resize to reposition dropdowns
                                                    $(window).on('resize', function () {
                                                        $('.select2-edit').each(function () {
                                                            if ($(this).hasClass('select2-hidden-accessible')) {
                                                                try {
                                                                    $(this).select2('close');
                                                                } catch (error) {
                                                                    // Ignore errors
                                                                }
                                                            }
                                                        });
                                                    });

                                                    $(document).on('submit', '#approveForm', function () {
                                                        // Ensure all Select2 values are properly synced and close dropdowns
                                                        $('.select2-edit').each(function () {
                                                            if ($(this).hasClass('select2-hidden-accessible')) {
                                                                try {
                                                                    $(this).select2('close');
                                                                    // Trigger change to ensure value is synced
                                                                    $(this).trigger('change.select2');
                                                                } catch (error) {
                                                                    // Ignore errors
                                                                }
                                                            }
                                                        });
                                                    });

                                                    // Handle Select2 change events for edit sections with proper tracking
                                                    $(document).on('change', '.select2-edit', function () {
                                                        const questionIndex = $(this).data('question-index');
                                                        if (questionIndex !== undefined) {
                                                            editedQuestions.add(questionIndex);
                                                            updateEditedCount();
                                                        }

                                                        // Update visual feedback
                                                        const $container = $(this).closest('.edit-section');
                                                        if ($container.length) {
                                                            $container.addClass('has-changes');
                                                        }
                                                    });

                                                    $(document).on('select2:opening', '.select2-edit', function (e) {
                                                        // Ensure no other Select2 dropdowns are open in edit sections
                                                        $('.edit-section .select2-edit').not(this).each(function () {
                                                            if ($(this).hasClass('select2-hidden-accessible')) {
                                                                try {
                                                                    $(this).select2('close');
                                                                } catch (error) {
                                                                    // Ignore errors
                                                                }
                                                            }
                                                        });
                                                    });
                                                });
        </script>
    </body>
</html>