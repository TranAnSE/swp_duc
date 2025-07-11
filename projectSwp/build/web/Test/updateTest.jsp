<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
    <head>
        <title>Test Update</title>
        <!-- CSS Libraries -->
        <link rel="stylesheet" href="/assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="/assets/css/owl.carousel.min.css">
        <link rel="stylesheet" href="/assets/css/slicknav.css">
        <link rel="stylesheet" href="/assets/css/flaticon.css">
        <link rel="stylesheet" href="/assets/css/progressbar_barfiller.css">
        <link rel="stylesheet" href="/assets/css/gijgo.css">
        <link rel="stylesheet" href="/assets/css/animate.min.css">
        <link rel="stylesheet" href="/assets/css/animated-headline.css">
        <link rel="stylesheet" href="/assets/css/magnific-popup.css">
        <link rel="stylesheet" href="/assets/css/fontawesome-all.min.css">
        <link rel="stylesheet" href="/assets/css/themify-icons.css">
        <link rel="stylesheet" href="/assets/css/slick.css">
        <link rel="stylesheet" href="/assets/css/nice-select.css">
        <link rel="stylesheet" href="/assets/css/style.css">

        <!-- Select2 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
        <link href="https://cdn.jsdelivr.net/npm/select2-bootstrap-5-theme@1.3.0/dist/select2-bootstrap-5-theme.min.css" rel="stylesheet" />

        <style>
            html, body {
                margin: 0;
                padding: 0;
                height: 100%;
                font-family: Arial, sans-serif;
                background-color: #f9f9f9;
            }

            .page-wrapper {
                display: flex;
                flex-direction: column;
                min-height: 100vh;
            }

            header, footer {
                flex-shrink: 0;
            }

            main {
                flex: 1;
                padding: 100px 20px 20px 20px;
                display: flex;
                justify-content: center;
            }

            .form-container {
                background-color: #fff;
                padding: 30px;
                border-radius: 12px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                max-width: 1200px;
                width: 100%;
            }

            h3 {
                color: #333;
                margin-bottom: 30px;
                border-bottom: 3px solid #007BFF;
                padding-bottom: 10px;
                font-weight: 600;
            }

            .form-section {
                margin-bottom: 30px;
                padding: 25px;
                border: 1px solid #e0e0e0;
                border-radius: 10px;
                background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
            }

            .form-section h4 {
                color: #007BFF;
                margin-bottom: 20px;
                font-weight: 600;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .context-info {
                background: linear-gradient(135deg, #e0f2fe 0%, #f0f9ff 100%);
                border: 2px solid #0ea5e9;
                border-radius: 8px;
                padding: 15px;
                margin-bottom: 20px;
                font-weight: 500;
                color: #0c4a6e;
            }

            .selected-questions-section {
                background: linear-gradient(135deg, #ecfdf5 0%, #f0fdf4 100%);
                border: 2px solid #10b981;
                border-radius: 12px;
                padding: 25px;
                margin-bottom: 25px;
            }

            .adding-section {
                background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
                border: 2px solid #f59e0b;
                border-radius: 12px;
                padding: 25px;
                margin-bottom: 25px;
            }

            .hierarchy-section {
                background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
                border: 2px solid #0ea5e9;
                border-radius: 12px;
                padding: 20px;
                margin-bottom: 20px;
                display: none;
            }

            .hierarchy-section.active {
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

            .hierarchy-steps {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 15px;
                margin-bottom: 20px;
            }

            .step-item {
                background: white;
                padding: 15px;
                border-radius: 8px;
                border: 1px solid #e2e8f0;
            }

            .step-item label {
                font-weight: 600;
                color: #374151;
                margin-bottom: 8px;
                display: block;
            }

            .generation-controls {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
                gap: 15px;
                margin-bottom: 20px;
            }

            .control-group {
                background: white;
                padding: 15px;
                border-radius: 8px;
                border: 1px solid #e2e8f0;
            }

            .control-group label {
                font-weight: 600;
                color: #374151;
                margin-bottom: 8px;
                display: block;
            }

            .btn-generate {
                background: linear-gradient(135deg, #10b981 0%, #059669 100%);
                border: none;
                color: white;
                padding: 12px 24px;
                border-radius: 8px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .btn-generate:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
            }

            .questions-preview {
                background: white;
                border: 1px solid #e2e8f0;
                border-radius: 8px;
                padding: 20px;
                margin-top: 20px;
                max-height: 400px;
                overflow-y: auto;
                display: none;
            }

            .questions-preview.active {
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

            .question-list {
                background: white;
                border: 1px solid #e2e8f0;
                border-radius: 10px;
                padding: 20px;
                max-height: 400px;
                overflow-y: auto;
            }

            .question-item {
                background: #f8fafc;
                border: 1px solid #e2e8f0;
                border-radius: 8px;
                padding: 15px;
                margin-bottom: 12px;
                display: flex;
                align-items: flex-start;
                gap: 12px;
                transition: all 0.2s ease;
            }

            .question-item:hover {
                background: #f1f5f9;
                border-color: #cbd5e1;
            }

            .question-item.selected {
                border-color: #10b981;
                background: #ecfdf5;
            }

            .question-item.to-remove {
                border-color: #ef4444;
                background: #fef2f2;
            }

            .question-checkbox {
                margin-top: 5px;
                transform: scale(1.2);
            }

            .question-content {
                flex: 1;
            }

            .question-text {
                font-weight: 500;
                margin-bottom: 8px;
                color: #1f2937;
                line-height: 1.4;
            }

            .question-meta {
                display: flex;
                gap: 12px;
                flex-wrap: wrap;
                align-items: center;
            }

            .lesson-name {
                font-size: 0.875rem;
                color: #6b7280;
                font-weight: 500;
            }

            .meta-badge {
                padding: 3px 8px;
                border-radius: 12px;
                font-size: 0.75rem;
                font-weight: 500;
            }

            .difficulty-easy {
                background: #d1fae5;
                color: #065f46;
            }
            .difficulty-medium {
                background: #fef3c7;
                color: #92400e;
            }
            .difficulty-hard {
                background: #fee2e2;
                color: #991b1b;
            }

            .category-badge {
                background: #e0e7ff;
                color: #3730a3;
            }
            .ai-badge {
                background: #f3e8ff;
                color: #6b21a8;
            }
            .manual-badge {
                background: #f3f4f6;
                color: #374151;
            }

            .selection-stats {
                background: #f0f9ff;
                border: 1px solid #0ea5e9;
                border-radius: 8px;
                padding: 12px 16px;
                margin-bottom: 15px;
                font-weight: 500;
                color: #0c4a6e;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .bulk-actions {
                margin-bottom: 20px;
                display: flex;
                gap: 10px;
                flex-wrap: wrap;
            }

            .btn-bulk {
                padding: 8px 16px;
                border: 1px solid #d1d5db;
                background: white;
                border-radius: 6px;
                cursor: pointer;
                font-size: 0.875rem;
                transition: all 0.2s ease;
                display: flex;
                align-items: center;
                gap: 5px;
                color: #374151;
            }

            .btn-bulk:hover {
                transform: translateY(-1px);
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }

            /* Improved color scheme for bulk action buttons */
            .btn-bulk.keep-all {
                background: linear-gradient(135deg, #10b981 0%, #059669 100%);
                color: white;
                border-color: #10b981;
            }
            .btn-bulk.keep-all:hover {
                background: linear-gradient(135deg, #059669 0%, #047857 100%);
                border-color: #059669;
            }

            .btn-bulk.remove-all {
                background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
                color: white;
                border-color: #ef4444;
            }
            .btn-bulk.remove-all:hover {
                background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%);
                border-color: #dc2626;
            }

            .btn-bulk.select-all {
                background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
                color: white;
                border-color: #3b82f6;
            }
            .btn-bulk.select-all:hover {
                background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
                border-color: #2563eb;
            }

            .btn-bulk.deselect-all {
                background: linear-gradient(135deg, #6b7280 0%, #4b5563 100%);
                color: white;
                border-color: #6b7280;
            }
            .btn-bulk.deselect-all:hover {
                background: linear-gradient(135deg, #4b5563 0%, #374151 100%);
                border-color: #4b5563;
            }

            .btn-bulk.generate {
                background: linear-gradient(135deg, #8b5cf6 0%, #7c3aed 100%);
                color: white;
                border-color: #8b5cf6;
            }
            .btn-bulk.generate:hover {
                background: linear-gradient(135deg, #7c3aed 0%, #6d28d9 100%);
                border-color: #7c3aed;
            }

            /* Select2 Custom Styling */
            .select2-container--bootstrap-5 .select2-selection {
                border: 2px solid #e2e8f0 !important;
                border-radius: 8px !important;
                min-height: 45px !important;
                padding: 5px 10px !important;
            }

            .select2-container--bootstrap-5.select2-container--focus .select2-selection {
                border-color: #0ea5e9 !important;
                box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.1) !important;
            }

            .select2-dropdown {
                border: 2px solid #0ea5e9 !important;
                border-radius: 8px !important;
                box-shadow: 0 4px 12px rgba(0,0,0,0.15) !important;
            }

            input[type="text"], select:not(.select2-hidden-accessible) {
                width: 100%;
                padding: 12px;
                margin: 6px 0 15px 0;
                border: 2px solid #e2e8f0;
                border-radius: 8px;
                transition: border-color 0.2s ease;
            }

            input[type="text"]:focus, select:focus {
                border-color: #0ea5e9;
                outline: none;
                box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.1);
            }

            input[type="checkbox"] {
                margin-right: 8px;
                transform: scale(1.1);
            }

            input[type="submit"] {
                background: linear-gradient(135deg, #007BFF 0%, #0056b3 100%);
                color: white;
                border: none;
                padding: 14px 28px;
                border-radius: 8px;
                cursor: pointer;
                font-weight: 600;
                font-size: 1rem;
                transition: all 0.3s ease;
            }

            input[type="submit"]:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(0, 123, 255, 0.3);
            }

            .alert {
                padding: 12px 16px;
                border-radius: 8px;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .alert-info {
                background: #e0f2fe;
                border: 1px solid #0ea5e9;
                color: #0c4a6e;
            }
            .alert-warning {
                background: #fef3c7;
                border: 1px solid #f59e0b;
                color: #92400e;
            }
            .alert-success {
                background: #ecfdf5;
                border: 1px solid #10b981;
                color: #065f46;
            }

            .back-link {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                margin-top: 20px;
                text-decoration: none;
                color: #007BFF;
                font-weight: 500;
                transition: color 0.2s ease;
            }

            .back-link:hover {
                color: #0056b3;
                text-decoration: none;
            }

            .adding-method-selector {
                margin-bottom: 20px;
                padding: 15px;
                background: white;
                border-radius: 8px;
                border: 1px solid #e2e8f0;
            }

            .adding-method-selector label {
                display: flex;
                align-items: center;
                gap: 10px;
                margin-bottom: 10px;
                font-weight: 500;
                cursor: pointer;
            }

            .adding-method-selector input[type="radio"] {
                transform: scale(1.2);
            }

            @media (max-width: 768px) {
                .generation-controls {
                    grid-template-columns: 1fr;
                }
                .bulk-actions {
                    flex-direction: column;
                }
                .selection-stats {
                    flex-direction: column;
                    gap: 10px;
                    text-align: center;
                }
                .hierarchy-steps {
                    grid-template-columns: 1fr;
                }
            }
            /* Question Item Styles */
            .question-item[style*="display: none"] {
                display: none !important;
            }

            .question-item:not([style*="display: none"]) {
                animation: fadeIn 0.3s ease-in-out;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(-10px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* Search Highlight */
            .question-text mark {
                background: linear-gradient(120deg, #fff3cd 0%, #ffeaa7 100%);
                padding: 2px 4px;
                border-radius: 3px;
                font-weight: bold;
            }

            /* Filter Active Indicator */
            .filter-group .form-control:not([value=""]):not([value="all"]) {
                border-color: #007bff;
                box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
            }

            #questionSearch:not([value=""]) {
                border-color: #28a745;
                box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, 0.25);
            }

            /* Stats Display */
            .selection-stats {
                background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
                border: 1px solid #2196f3;
                border-radius: 8px;
                padding: 12px 16px;
                margin-bottom: 15px;
                font-weight: 500;
                color: #1565c0;
            }

            .selection-stats strong {
                color: #0d47a1;
                font-weight: 700;
            }

            /* Improved Alert Styles */
            .alert-success {
                background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
                border-color: #28a745;
                color: #155724;
            }

            .alert-success i {
                color: #28a745;
            }

            /* Loading State Enhancement */
            .alert-info .fa-spinner {
                animation: spin 1s linear infinite;
            }

            @keyframes spin {
                from {
                    transform: rotate(0deg);
                }
                to {
                    transform: rotate(360deg);
                }
            }

            /* Question Type Badges Enhancement */
            .meta-badge {
                font-size: 0.75em;
                padding: 3px 8px;
                border-radius: 12px;
                font-weight: 500;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .meta-badge.difficulty-easy {
                background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
                color: #155724;
                border: 1px solid #28a745;
            }

            .meta-badge.difficulty-medium {
                background: linear-gradient(135deg, #fff3cd 0%, #ffeaa7 100%);
                color: #856404;
                border: 1px solid #ffc107;
            }

            .meta-badge.difficulty-hard {
                background: linear-gradient(135deg, #f8d7da 0%, #f1b0b7 100%);
                color: #721c24;
                border: 1px solid #dc3545;
            }

            .meta-badge.category-badge {
                background: linear-gradient(135deg, #e2e3e5 0%, #d1ecf1 100%);
                color: #495057;
                border: 1px solid #6c757d;
            }

            .meta-badge.ai-badge {
                background: linear-gradient(135deg, #e1f5fe 0%, #b3e5fc 100%);
                color: #01579b;
                border: 1px solid #03a9f4;
            }

            .meta-badge.manual-badge {
                background: linear-gradient(135deg, #f3e5f5 0%, #e1bee7 100%);
                color: #4a148c;
                border: 1px solid #9c27b0;
            }

            /* Filter Section Enhancement */
            .filter-section {
                background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
                border: 1px solid #dee2e6;
                border-radius: 12px;
                padding: 20px;
                margin-bottom: 20px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }

            .filter-section h6 {
                color: #495057;
                margin-bottom: 15px;
                font-weight: 600;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .filter-row {
                display: grid;
                grid-template-columns: 2fr 1fr 1fr 1fr auto;
                gap: 15px;
                align-items: end;
            }

            @media (max-width: 768px) {
                .filter-row {
                    grid-template-columns: 1fr;
                    gap: 10px;
                }
            }

            .filter-group {
                display: flex;
                flex-direction: column;
            }

            .filter-group label {
                font-size: 0.9em;
                font-weight: 500;
                color: #6c757d;
                margin-bottom: 5px;
            }

            .search-input-group {
                position: relative;
            }

            .search-input-group .form-control {
                padding-right: 40px;
            }

            .search-icon {
                position: absolute;
                right: 12px;
                top: 50%;
                transform: translateY(-50%);
                color: #6c757d;
                pointer-events: none;
            }

            .btn-clear-filters {
                background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
                color: white;
                border: none;
                padding: 8px 16px;
                border-radius: 6px;
                font-size: 0.9em;
                cursor: pointer;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                gap: 6px;
                white-space: nowrap;
            }

            .btn-clear-filters:hover {
                background: linear-gradient(135deg, #c82333 0%, #a71e2a 100%);
                transform: translateY(-1px);
                box-shadow: 0 4px 8px rgba(220, 53, 69, 0.3);
            }
            .context-display {
                background: #f8f9fa;
                border: 1px solid #dee2e6;
                border-radius: 8px;
                padding: 15px;
                margin: 10px 0;
            }

            .context-path {
                display: flex;
                align-items: center;
                flex-wrap: wrap;
                gap: 8px;
                margin: 10px 0;
            }

            .context-item {
                background: #e9ecef;
                padding: 4px 8px;
                border-radius: 4px;
                font-size: 0.9em;
            }

            .context-item.active {
                background: #007bff;
                color: white;
                font-weight: 500;
            }

            .context-path i {
                color: #6c757d;
                font-size: 0.8em;
            }

            /* Hide hierarchy steps by default when context is available */
            .hierarchy-steps.auto-hidden {
                display: none;
            }
            /* scope selection styles */
            #scopeSelection, #scopeSelectionUpdate {
                background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
                border: 2px solid #0ea5e9;
                border-radius: 12px;
                padding: 20px;
                margin-bottom: 20px;
            }

            #scopeSelection h5, #scopeSelectionUpdate h5 {
                color: #0c4a6e;
                margin-bottom: 15px;
                font-weight: 600;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            #scopeSelection label, #scopeSelectionUpdate label {
                display: flex;
                align-items: center;
                gap: 10px;
                margin-bottom: 10px;
                font-weight: 500;
                cursor: pointer;
                padding: 8px 12px;
                border-radius: 6px;
                transition: all 0.2s ease;
            }

            #scopeSelection label:hover, #scopeSelectionUpdate label:hover {
                background: rgba(14, 165, 233, 0.1);
            }

            #scopeSelection input[type="radio"], #scopeSelectionUpdate input[type="radio"] {
                transform: scale(1.2);
                accent-color: #0ea5e9;
            }

            /* hierarchy steps for different scopes */
            .hierarchy-steps .step-item.scope-disabled {
                opacity: 0.5;
                pointer-events: none;
            }

            .hierarchy-steps .step-item.scope-active {
                border-color: #10b981;
                background: linear-gradient(135deg, #ecfdf5 0%, #f0fdf4 100%);
            }

            /* Scope indicator badges */
            .scope-indicator {
                display: inline-flex;
                align-items: center;
                gap: 5px;
                background: linear-gradient(135deg, #8b5cf6 0%, #7c3aed 100%);
                color: white;
                padding: 4px 10px;
                border-radius: 12px;
                font-size: 0.75rem;
                font-weight: 500;
                margin-left: 10px;
            }

            .scope-indicator.lesson {
                background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            }

            .scope-indicator.chapter {
                background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
            }

            .scope-indicator.subject {
                background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
            }

            /* question item with scope information */
            .question-item .question-scope {
                font-size: 0.75rem;
                color: #6b7280;
                margin-top: 5px;
                display: flex;
                align-items: center;
                gap: 5px;
            }

            .question-item .question-scope i {
                color: #9ca3af;
            }

            /* Loading states for different scopes */
            .scope-loading {
                background: linear-gradient(135deg, #f3f4f6 0%, #e5e7eb 100%);
                border: 1px solid #d1d5db;
                border-radius: 8px;
                padding: 20px;
                text-align: center;
                margin: 20px 0;
            }

            .scope-loading i {
                font-size: 2rem;
                color: #6b7280;
                margin-bottom: 10px;
            }

            /* stats display for different scopes */
            .selection-stats.scope-enhanced {
                background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
                border: 1px solid #f59e0b;
                color: #92400e;
            }

            .selection-stats.scope-enhanced .scope-info {
                font-size: 0.875rem;
                margin-top: 5px;
                opacity: 0.8;
            }

            /* Responsive design for scope selection */
            @media (max-width: 768px) {
                #scopeSelection, #scopeSelectionUpdate {
                    padding: 15px;
                }

                #scopeSelection label, #scopeSelectionUpdate label {
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 5px;
                    padding: 10px;
                }

                .scope-indicator {
                    margin-left: 0;
                    margin-top: 5px;
                }
            }

            /* Animation for scope transitions */
            .scope-transition {
                transition: all 0.3s ease;
            }

            .scope-fade-in {
                animation: scopeFadeIn 0.3s ease;
            }

            @keyframes scopeFadeIn {
                from {
                    opacity: 0;
                    transform: translateY(-10px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .scope-slide-up {
                animation: scopeSlideUp 0.3s ease;
            }

            @keyframes scopeSlideUp {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
            .form-row {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px;
                margin-bottom: 20px;
            }

            .form-group {
                display: flex;
                flex-direction: column;
            }

            .form-group label {
                font-weight: 600;
                color: #333;
                margin-bottom: 8px;
            }

            .form-group input {
                padding: 10px;
                border: 2px solid #e2e8f0;
                border-radius: 8px;
                font-size: 14px;
                transition: border-color 0.2s ease;
            }

            .form-group input:focus {
                border-color: #0ea5e9;
                outline: none;
                box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.1);
            }

            .form-text {
                font-size: 0.875em;
                color: #6c757d;
                margin-top: 5px;
            }

            .alert-success {
                background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
                border-color: #28a745;
                color: #155724;
            }

            .alert-danger {
                background: linear-gradient(135deg, #f8d7da 0%, #f1b0b7 100%);
                border-color: #dc3545;
                color: #721c24;
            }

            @media (max-width: 768px) {
                .form-row {
                    grid-template-columns: 1fr;
                    gap: 15px;
                }
            }
        </style>
    </head>
    <body>
        <div class="page-wrapper">
            <jsp:include page="/header.jsp" />

            <main>
                <div class="form-container">
                    <h3><i class="fas fa-edit"></i> Test Update</h3>

                    <form action="${pageContext.request.contextPath}/test" method="post" id="updateTestForm">
                        <input type="hidden" name="action" value="update"/>
                        <input type="hidden" name="id" value="${test.id}"/>

                        <!-- Basic Test Information -->
                        <div class="form-section">
                            <h4><i class="fas fa-info-circle"></i> Test Information</h4>

                            <label for="name">Test Name:</label>
                            <input type="text" name="name" value="${test.name}" required/>

                            <label for="description">Description:</label>
                            <input type="text" name="description" value="${test.description}" required/>

                            <!-- Duration and Number of Questions for Course Tests -->
                            <c:if test="${isCourseTest}">
                                <div class="alert alert-info">
                                    <i class="fas fa-info-circle"></i>
                                    <strong>Course-Integrated Test Configuration</strong><br>
                                    This test is part of a course. Duration and question count are configurable.
                                </div>

                                <div class="form-row">
                                    <div class="form-group">
                                        <label for="duration">Duration (minutes) *</label>
                                        <input type="number" id="duration" name="duration" min="5" max="180" 
                                               value="${testConfig.duration_minutes}" required />
                                        <small class="form-text text-muted">Test duration between 5 and 180 minutes</small>
                                    </div>

                                    <div class="form-group">
                                        <label for="numQuestions">Number of Questions *</label>
                                        <input type="number" id="numQuestions" name="numQuestions" 
                                               min="1" max="100" value="${testConfig.num_questions}" required />
                                        <small class="form-text text-muted">You must select exactly this many questions</small>
                                    </div>
                                </div>

                                <div class="alert alert-warning" id="questionCountWarning">
                                    <i class="fas fa-exclamation-triangle"></i>
                                    <strong>Important:</strong> You must select exactly <span id="requiredQuestionCount">${testConfig.num_questions}</span> questions for this test.
                                </div>

                            </c:if>

                            <label>
                                <input type="checkbox" name="practice" value="true"
                                       <c:if test="${test.is_practice}">checked</c:if> />
                                       Practice Test (uncheck for official test)
                                </label>

                                <!-- Context Information -->
                            <c:if test="${not empty testContext}">
                                <div class="context-info">
                                    <i class="fas fa-map-marker-alt"></i>
                                    <strong>Test Context:</strong> 
                                    <c:choose>
                                        <c:when test="${testContext.contextLevel == 'lesson'}">
                                            Lesson level - ${testContext.contextName}
                                        </c:when>
                                        <c:when test="${testContext.contextLevel == 'chapter'}">
                                            Chapter level - ${testContext.contextName}
                                        </c:when>
                                        <c:when test="${testContext.contextLevel == 'subject'}">
                                            Subject level - ${testContext.contextName}
                                        </c:when>
                                        <c:otherwise>
                                            Course level - ${testContext.contextName}
                                        </c:otherwise>
                                    </c:choose>

                                    <!-- Hidden fields for JavaScript -->
                                    <input type="hidden" id="contextLevel" value="${testContext.contextLevel}" />
                                    <input type="hidden" id="contextId" value="${testContext.contextId}" />
                                    <c:if test="${testContext.contextLevel == 'subject'}">
                                        <input type="hidden" id="isCourseLevel" value="true" />
                                    </c:if>
                                    <c:if test="${testContext.contextLevel == 'lesson'}">
                                        <input type="hidden" id="contextLessonId" value="${testContext.contextId}" />
                                    </c:if>
                                </div>
                            </c:if>

                            <!-- Hidden fields for validation -->
                            <input type="hidden" id="isCourseTest" value="${isCourseTest}" />
                            <input type="hidden" id="originalRequiredCount" value="${testConfig.num_questions}" />
                        </div>

                        <!-- Currently Selected Questions -->
                        <div class="selected-questions-section">
                            <h4><i class="fas fa-check-circle"></i> Currently Selected Questions</h4>
                            <div class="alert alert-success">
                                <i class="fas fa-info-circle"></i>
                                These are the questions currently assigned to this test. Uncheck questions you want to remove.
                            </div>

                            <div class="selection-stats" id="currentSelectionStats">
                                <span>
                                    <i class="fas fa-chart-bar"></i> 
                                    Currently selected: <span id="currentSelectedCount">${selectedQuestions.size()}</span> questions
                                </span>
                            </div>

                            <div class="bulk-actions">
                                <button type="button" class="btn-bulk keep-all" id="selectAllCurrentBtn">
                                    <i class="fas fa-check-square"></i> Keep All Questions
                                </button>
                                <button type="button" class="btn-bulk remove-all" id="deselectAllCurrentBtn">
                                    <i class="fas fa-times-circle"></i> Remove All Questions
                                </button>
                            </div>

                            <div class="question-list" id="currentQuestionsList">
                                <c:if test="${empty selectedQuestions}">
                                    <div class="alert alert-warning">
                                        <i class="fas fa-exclamation-triangle"></i>
                                        No questions currently selected for this test.
                                    </div>
                                </c:if>
                                <c:if test="${not empty selectedQuestions}">
                                    <c:forEach var="q" items="${selectedQuestions}">
                                        <div class="question-item" data-question-id="${q.id}">
                                            <input type="checkbox" name="questionIds" value="${q.id}" 
                                                   class="question-checkbox current-question-checkbox" checked />
                                            <div class="question-content">
                                                <div class="question-text">${q.question}</div>
                                                <div class="question-meta">
                                                    <span class="lesson-name">
                                                        <i class="fas fa-book"></i>
                                                        <c:choose>
                                                            <c:when test="${lessonNameMap[q.lesson_id] != null}">
                                                                ${lessonNameMap[q.lesson_id]}
                                                            </c:when>
                                                            <c:otherwise>
                                                                Unknown Lesson (ID: ${q.lesson_id})
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </span>

                                                    <span class="meta-badge difficulty-${q.difficulty != null ? q.difficulty : 'medium'}">
                                                        ${q.difficulty != null ? q.difficulty : 'medium'}
                                                    </span>
                                                    <span class="meta-badge category-badge">
                                                        ${q.category != null ? q.category : 'conceptual'}
                                                    </span>
                                                    <span class="meta-badge">
                                                        ${q.question_type}
                                                    </span>
                                                    <c:choose>
                                                        <c:when test="${q.AIGenerated}">
                                                            <span class="meta-badge ai-badge">AI Generated</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="meta-badge manual-badge">Manual</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:if>
                            </div>
                        </div>

                        <!-- Question Adding Section -->
                        <div class="adding-section">
                            <h4><i class="fas fa-plus-circle"></i> Add More Questions</h4>
                            <div class="alert alert-info">
                                <i class="fas fa-lightbulb"></i>
                                Choose how you want to add more questions to this test.
                            </div>

                            <div class="adding-method-selector">
                                <label>
                                    <input type="radio" name="addingMethod" value="smart" checked onchange="toggleAddingMethod()">
                                    <i class="fas fa-magic"></i> Smart Question Adding - Auto-generate based on criteria
                                </label>
                                <label>
                                    <input type="radio" name="addingMethod" value="manual" onchange="toggleAddingMethod()">
                                    <i class="fas fa-hand-pointer"></i> Manual Question Adding - Browse and select manually
                                </label>
                            </div>

                            <!-- Smart Adding Controls -->
                            <div id="smartAddingControls">
                                <c:choose>
                                    <c:when test="${not empty testContext}">
                                        <div class="context-info">
                                            <i class="fas fa-info-circle"></i>
                                            <strong>Smart Generation Available:</strong> 
                                            <c:choose>
                                                <c:when test="${testContext.contextLevel == 'lesson'}">
                                                    Lesson level - ${testContext.contextName}
                                                </c:when>
                                                <c:when test="${testContext.contextLevel == 'chapter'}">
                                                    Chapter level - ${testContext.contextName}
                                                </c:when>
                                                <c:when test="${testContext.contextLevel == 'subject'}">
                                                    Subject level - ${testContext.contextName}
                                                </c:when>
                                                <c:otherwise>
                                                    Course level - ${testContext.contextName}
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <div class="generation-controls">
                                            <div class="control-group">
                                                <label for="questionCount">Number of Questions</label>
                                                <input type="number" id="questionCount" min="1" max="20" value="5" class="form-control">
                                            </div>

                                            <div class="control-group">
                                                <label for="difficultyFilter">Difficulty Level</label>
                                                <select id="difficultyFilter" class="form-control">
                                                    <option value="all">All Levels</option>
                                                    <option value="easy">Easy</option>
                                                    <option value="medium" selected>Medium</option>
                                                    <option value="hard">Hard</option>
                                                </select>
                                            </div>

                                            <div class="control-group">
                                                <label for="categoryFilter">Question Category</label>
                                                <select id="categoryFilter" class="form-control">
                                                    <option value="all">All Categories</option>
                                                    <option value="conceptual">Conceptual</option>
                                                    <option value="application">Application</option>
                                                    <option value="analysis">Analysis</option>
                                                    <option value="synthesis">Synthesis</option>
                                                    <option value="evaluation">Evaluation</option>
                                                </select>
                                            </div>
                                        </div>

                                        <div style="text-align: center; margin-bottom: 20px;">
                                            <button type="button" class="btn-generate" id="generateSmartBtn">
                                                <i class="fas fa-dice"></i> Generate Smart Questions
                                            </button>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="alert alert-warning">
                                            <i class="fas fa-exclamation-triangle"></i>
                                            Smart question generation is not available because this test doesn't have a specific context.
                                            Please use Manual Question Adding instead.
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- Manual Adding Controls -->
                            <div id="manualAddingControls" style="display: none;">
                                <!-- Learning Path Selection -->
                                <div class="hierarchy-section active" id="hierarchySection">
                                    <h5><i class="fas fa-sitemap"></i> Select Learning Path</h5>
                                    <div class="alert alert-info">
                                        <i class="fas fa-route"></i>
                                        Navigate through Grade → Subject → Chapter → Lesson to find questions
                                    </div>

                                    <div class="hierarchy-steps">
                                        <div class="step-item">
                                            <label for="gradeSelect">Grade</label>
                                            <select id="gradeSelect" class="form-select select2-dropdown">
                                                <option value="">-- Select Grade --</option>
                                                <c:forEach var="grade" items="${gradeList}">
                                                    <option value="${grade.id}">${grade.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <div class="step-item">
                                            <label for="subjectSelect">Subject</label>
                                            <select id="subjectSelect" class="form-select select2-dropdown" disabled>
                                                <option value="">-- Select Subject --</option>
                                            </select>
                                        </div>

                                        <div class="step-item">
                                            <label for="chapterSelect">Chapter</label>
                                            <select id="chapterSelect" class="form-select select2-dropdown" disabled>
                                                <option value="">-- Select Chapter --</option>
                                            </select>
                                        </div>

                                        <div class="step-item">
                                            <label for="lessonSelect">Lesson</label>
                                            <select id="lessonSelect" class="form-select select2-dropdown" disabled>
                                                <option value="">-- Select Lesson --</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>

                                <div id="manualQuestionsContainer" style="display: none;">
                                    <div class="alert alert-info">
                                        <i class="fas fa-info-circle"></i>
                                        Select questions to add to your test. Questions already in the test are excluded.
                                    </div>

                                    <div class="selection-stats" id="manualStats"></div>
                                    <div class="bulk-actions">
                                        <button type="button" class="btn-bulk select-all" id="selectAllManualBtn">
                                            <i class="fas fa-check-square"></i> Select All
                                        </button>
                                        <button type="button" class="btn-bulk deselect-all" id="deselectAllManualBtn">
                                            <i class="fas fa-square"></i> Deselect All
                                        </button>
                                    </div>
                                    <div class="question-list" id="manualQuestionsList"></div>
                                </div>
                            </div>

                            <!-- Questions Preview for both Smart and Manual -->
                            <div class="questions-preview" id="addingQuestionsPreview">
                                <h5 id="previewTitle">Questions Preview</h5>
                                <div class="selection-stats" id="addingStats"></div>
                                <div class="bulk-actions">
                                    <button type="button" class="btn-bulk select-all" id="selectAllAddingBtn">
                                        <i class="fas fa-check-square"></i> Select All
                                    </button>
                                    <button type="button" class="btn-bulk deselect-all" id="deselectAllAddingBtn">
                                        <i class="fas fa-square"></i> Deselect All
                                    </button>
                                    <button type="button" class="btn-bulk generate" id="regenerateBtn" style="display: none;">
                                        <i class="fas fa-sync"></i> Regenerate
                                    </button>
                                </div>
                                <div id="addingQuestionsList"></div>
                            </div>
                        </div>

                        <div style="text-align: center; margin-top: 30px;">
                            <input type="submit" value="Update Test" />
                            <a href="${pageContext.request.contextPath}/test" class="back-link">
                                <i class="fas fa-arrow-left"></i> Back to Test List
                            </a>
                        </div>
                    </form>
                </div>
            </main>

            <jsp:include page="/footer.jsp" />
        </div>

        <!-- JS Libraries -->
        <script src="${pageContext.request.contextPath}/assets/js/vendor/modernizr-3.5.0.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/vendor/jquery-1.12.4.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/popper.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>

        <!-- Select2 JS -->
        <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

        <script src="${pageContext.request.contextPath}/assets/js/jquery.slicknav.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/owl.carousel.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/slick.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/wow.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/animated.headline.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.magnific-popup.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/gijgo.min.js"></script>
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

        <script>
                                        // Global variables
                                        let contextLessonId;
                                        let currentlySelectedIds = new Set();
                                        let currentAddingMethod = 'smart';
                                        let allManualQuestions = []; // Store all questions for filtering
                                        let lessonHierarchy = null; // Store lesson hierarchy info
                                        let currentSubjectId = null;
                                        let currentChapterId = null;
                                        let isCourseTest = $('#isCourseTest').val() === 'true';
                                        let originalRequiredCount = parseInt($('#originalRequiredCount').val()) || 0;

                                        // Initialize Select2
                                        function initializeSelect2(selector) {
                                            $(selector).select2({
                                                theme: 'bootstrap-5',
                                                width: '100%',
                                                allowClear: false,
                                                dropdownParent: $('body')
                                            });
                                        }

                                        // Update current selection stats
                                        function updateCurrentSelectionStats() {
                                            const totalCurrent = $('.current-question-checkbox').length;
                                            const selectedCurrent = $('.current-question-checkbox:checked').length;
                                            $('#currentSelectedCount').text(selectedCurrent);

                                            // Update visual selection for current questions
                                            $('#currentQuestionsList .question-item').each(function () {
                                                const $item = $(this);
                                                if ($item.find('.current-question-checkbox').is(':checked')) {
                                                    $item.removeClass('to-remove');
                                                } else {
                                                    $item.addClass('to-remove');
                                                }
                                            });

                                            // Update currently selected IDs set
                                            currentlySelectedIds.clear();
                                            $('.current-question-checkbox:checked').each(function () {
                                                currentlySelectedIds.add(parseInt($(this).val()));
                                            });

                                            // Update course test validation if applicable
                                            if (isCourseTest) {
                                                const requiredCount = getCurrentRequiredCount();
                                                // Use total selected questions (current + adding)
                                                const totalSelected = getTotalSelectedQuestions();
                                                console.log('updateCurrentSelectionStats - calling updateQuestionCountWarning with:', requiredCount, 'totalSelected:', totalSelected);
                                                updateQuestionCountWarningWithTotal(requiredCount, totalSelected);
                                            }
                                        }

                                        // Update adding questions stats
                                        function updateAddingStats() {
                                            const total = $('#addingQuestionsList .question-checkbox').length;
                                            const selected = $('#addingQuestionsList .question-checkbox:checked').length;

                                            const method = currentAddingMethod === 'smart' ? 'Smart Generated' : 'Manual Selected';
                                            const statsHtml = '<span><i class="fas fa-chart-bar"></i> Selected: <strong>' + selected + '</strong> / <strong>' + total + '</strong> ' + method + ' questions</span>';
                                            $('#addingStats').html(statsHtml);

                                            // Update visual selection
                                            $('#addingQuestionsList .question-item').each(function () {
                                                const $item = $(this);
                                                if ($item.find('.question-checkbox').is(':checked')) {
                                                    $item.addClass('selected');
                                                } else {
                                                    $item.removeClass('selected');
                                                }
                                            });

                                            console.log('Adding stats updated:', {selected: selected, total: total, method: method});

                                            // Update course test validation if applicable
                                            if (isCourseTest) {
                                                const requiredCount = getCurrentRequiredCount();
                                                // Use total selected questions (current + adding)
                                                const totalSelected = getTotalSelectedQuestions();
                                                console.log('updateAddingStats - calling updateQuestionCountWarning with:', requiredCount, 'totalSelected:', totalSelected);
                                                updateQuestionCountWarningWithTotal(requiredCount, totalSelected);
                                            }
                                        }

                                        // Function to update question count warning with explicit total count
                                        function updateQuestionCountWarningWithTotal(requiredCount, totalSelectedCount) {
                                            const warningElement = $('#questionCountWarning');

                                            console.log('updateQuestionCountWarningWithTotal - requiredCount:', requiredCount, 'totalSelectedCount:', totalSelectedCount);

                                            if (!warningElement.length) {
                                                console.warn('Warning element #questionCountWarning not found');
                                                return;
                                            }

                                            // Force convert to numbers to ensure they're valid
                                            const reqCount = parseInt(requiredCount) || 0;
                                            const selCount = parseInt(totalSelectedCount) || 0;

                                            console.log('Converted values - reqCount:', reqCount, 'selCount:', selCount);

                                            if (selCount !== reqCount) {
                                                warningElement.removeClass('alert-warning alert-success').addClass('alert-danger');

                                                // Build HTML string step by step
                                                const iconHtml = '<i class="fas fa-exclamation-triangle"></i>';
                                                const strongStart = '<strong>Error:</strong>';
                                                const message1 = ' You must select exactly ';
                                                const reqSpanHtml = '<span id="requiredQuestionCount">' + reqCount + '</span>';
                                                const message2 = ' questions for this test. Currently selected: ';
                                                const selStrongHtml = '<strong>' + selCount + '</strong>';
                                                const message3 = ' questions.';

                                                const fullHtml = iconHtml + ' ' + strongStart + message1 + reqSpanHtml + message2 + selStrongHtml + message3;

                                                console.log('Setting error HTML with total:', fullHtml);
                                                warningElement.html(fullHtml);

                                            } else {
                                                warningElement.removeClass('alert-danger alert-warning').addClass('alert-success');

                                                // Build success HTML
                                                const iconHtml = '<i class="fas fa-check-circle"></i>';
                                                const strongStart = '<strong>Perfect:</strong>';
                                                const message = ' You have selected exactly ';
                                                const countHtml = '<strong>' + reqCount + '</strong>';
                                                const message2 = ' questions as required.';

                                                const fullHtml = iconHtml + ' ' + strongStart + message + countHtml + message2;

                                                console.log('Setting success HTML with total:', fullHtml);
                                                warningElement.html(fullHtml);
                                            }

                                            // Double check the HTML was set correctly
                                            console.log('Final warning HTML with total:', warningElement.html());
                                        }

                                        // Update manual questions stats
                                        function updateManualStats() {
                                            // Count only visible questions after filtering
                                            const visibleItems = $('#manualQuestionsList .question-item:visible');
                                            const total = visibleItems.length;
                                            const selected = visibleItems.find('.question-checkbox:checked').length;

                                            const statsHtml = '<span><i class="fas fa-chart-bar"></i> Showing: <strong>' + total + '</strong> questions, Selected: <strong>' + selected + '</strong></span>';
                                            $('#manualStats').html(statsHtml);
                                        }

// Toggle adding method
                                        function toggleAddingMethod() {
                                            const method = $('input[name="addingMethod"]:checked').val();
                                            currentAddingMethod = method;

                                            if (method === 'smart') {
                                                $('#smartAddingControls').show();
                                                $('#manualAddingControls').hide();
                                                $('#regenerateBtn').show();
                                                $('#previewTitle').text('Smart Generated Questions Preview');
                                            } else {
                                                $('#smartAddingControls').hide();
                                                $('#manualAddingControls').show();
                                                $('#regenerateBtn').hide();
                                                $('#previewTitle').text('Manual Selected Questions Preview');

                                                // Auto-load lesson hierarchy and questions if available
                                                if (contextLessonId && !lessonHierarchy) {
                                                    loadLessonHierarchy();
                                                } else if (contextLessonId && lessonHierarchy) {
                                                    // Questions might already be loaded, just show the container
                                                    if ($('#manualQuestionsList').children().length === 0) {
                                                        loadManualQuestions(contextLessonId);
                                                    } else {
                                                        $('#manualQuestionsContainer').show();
                                                    }
                                                }
                                            }

                                            // Clear preview
                                            $('#addingQuestionsPreview').removeClass('active');
                                            $('#addingQuestionsList').empty();
                                            updateAddingStats();
                                        }

                                        // Load lesson hierarchy
                                        function loadLessonHierarchy() {
                                            console.log('Loading lesson hierarchy for lesson:', contextLessonId);

                                            $.get('test', {
                                                action: 'getLessonHierarchy',
                                                lessonId: contextLessonId
                                            }, function (data) {
                                                console.log('Lesson hierarchy loaded:', data);
                                                lessonHierarchy = data;

                                                if (data.gradeId) {
                                                    // Show context info
                                                    $('#hierarchySection .alert').html('<i class="fas fa-route"></i><strong>Auto-navigated to test context:</strong> ' + data.gradeName + ' → ' + data.subjectName + ' → ' + data.chapterName + ' → ' + data.lessonName).removeClass('alert-info').addClass('alert-success');

                                                    // DIRECTLY load questions for the context lesson instead of populating dropdowns
                                                    loadManualQuestions(contextLessonId);

                                                    // Hide the hierarchy selection since we already know the context
                                                    $('.hierarchy-steps').hide();

                                                    // Show a simplified context display
                                                    const contextHtml = `
                <div class="context-display">
                    <h6><i class="fas fa-book-open"></i> Current Test Context</h6>
                    <div class="context-path">
                        <span class="context-item">${data.gradeName}</span>
                        <i class="fas fa-chevron-right"></i>
                        <span class="context-item">${data.subjectName}</span>
                        <i class="fas fa-chevron-right"></i>
                        <span class="context-item">${data.chapterName}</span>
                        <i class="fas fa-chevron-right"></i>
                        <span class="context-item active">${data.lessonName}</span>
                    </div>
                    <button type="button" class="btn btn-sm btn-outline-secondary mt-2" onclick="showHierarchySelection()">
                        <i class="fas fa-exchange-alt"></i> Change Lesson
                    </button>
                </div>
            `;
                                                    $('.hierarchy-steps').after(contextHtml);
                                                }
                                            }).fail(function (xhr, status, error) {
                                                console.error('Failed to load lesson hierarchy:', error);
                                                console.error('Response text:', xhr.responseText);

                                                // Fallback: show hierarchy selection
                                                $('.hierarchy-steps').show();

                                                // Load initial data for hierarchy
                                                loadInitialHierarchyData();
                                            });
                                        }
                                        // Show hierarchy selection
                                        function showHierarchySelection() {
                                            $('.hierarchy-steps').show();
                                            $('.context-display').hide();

                                            // Load initial data if not loaded
                                            if ($('#gradeSelect option').length <= 1) {
                                                loadInitialHierarchyData();
                                            }
                                        }

// Hide hierarchy selection
                                        function hideHierarchySelection() {
                                            $('.hierarchy-steps').hide();
                                            $('.context-display').show();
                                        }

// Load initial hierarchy data
                                        function loadInitialHierarchyData() {
                                            console.log('Loading initial hierarchy data...');

                                            // Load grades first
                                            $.get('test', {
                                                action: 'getAllGrades'
                                            }, function (data) {
                                                console.log('Grades loaded:', data);
                                                populateSelect('#gradeSelect', data, '-- Select Grade --');

                                                // If we have lesson hierarchy, auto-select
                                                if (lessonHierarchy && lessonHierarchy.gradeId) {
                                                    setTimeout(function () {
                                                        $('#gradeSelect').val(lessonHierarchy.gradeId).trigger('change');
                                                    }, 100);
                                                }
                                            }).fail(function (xhr, status, error) {
                                                console.error('Failed to load grades:', error);
                                            });
                                        }

                                        // Bulk selection functions for current questions
                                        function selectAllCurrent() {
                                            $('.current-question-checkbox').prop('checked', true);
                                            updateCurrentSelectionStats();
                                        }

                                        function deselectAllCurrent() {
                                            if (confirm('Are you sure you want to remove all currently selected questions from this test?')) {
                                                $('.current-question-checkbox').prop('checked', false);
                                                updateCurrentSelectionStats();
                                            }
                                        }

// Bulk selection functions for adding questions
                                        function selectAllAdding() {
                                            $('#addingQuestionsList .question-checkbox').prop('checked', true);
                                            updateAddingStats();
                                        }

                                        function deselectAllAdding() {
                                            $('#addingQuestionsList .question-checkbox').prop('checked', false);
                                            updateAddingStats();
                                        }

// Bulk selection functions for manual questions
                                        function selectAllManual() {
                                            $('#manualQuestionsList .question-item:visible .question-checkbox').prop('checked', true);
                                            updateManualStats();
                                            copyManualSelectionsToPreview();
                                        }

                                        function deselectAllManual() {
                                            $('#manualQuestionsList .question-item:visible .question-checkbox').prop('checked', false);
                                            updateManualStats();
                                            copyManualSelectionsToPreview();
                                        }

// Copy manual selections to preview
                                        function copyManualSelectionsToPreview() {
                                            const selectedQuestions = [];
                                            $('#manualQuestionsList .question-item').each(function () {
                                                const $item = $(this);
                                                if ($item.find('.question-checkbox').is(':checked')) {
                                                    selectedQuestions.push({
                                                        id: $item.data('question-id'),
                                                        question: $item.find('.question-text').text(),
                                                        difficulty: $item.data('difficulty') || 'medium',
                                                        category: $item.data('category') || 'conceptual',
                                                        question_type: $item.data('type') || 'SINGLE',
                                                        isAI: $item.data('source') === 'ai'
                                                    });
                                                }
                                            });

                                            if (selectedQuestions.length > 0) {
                                                displayAddingQuestions(selectedQuestions);
                                                $('#addingQuestionsPreview').addClass('active');
                                            } else {
                                                $('#addingQuestionsPreview').removeClass('active');
                                                $('#addingQuestionsList').empty();
                                            }
                                            updateAddingStats();
                                        }

                                        // Smart question generation
                                        function generateSmartQuestions() {
                                            const contextLevel = document.getElementById('contextLevel')?.value;
                                            const contextId = document.getElementById('contextId')?.value;
                                            const isCourseLevel = document.getElementById('isCourseLevel')?.value === 'true';

                                            console.log('Smart generation context:', {
                                                contextLevel: contextLevel,
                                                contextId: contextId,
                                                isCourseLevel: isCourseLevel
                                            });

                                            if (!contextLevel || !contextId) {
                                                alert('No context found for this test');
                                                return;
                                            }

                                            const count = $('#questionCount').val() || 5;
                                            const difficulty = $('#difficultyFilter').val();
                                            const category = $('#categoryFilter').val();

                                            // Determine the appropriate action based on context level
                                            let action = '';
                                            let paramName = '';

                                            switch (contextLevel) {
                                                case 'lesson':
                                                    action = 'getSmartQuestions';
                                                    paramName = 'lessonId';
                                                    break;
                                                case 'chapter':
                                                    action = 'getQuestionsByChapter';
                                                    paramName = 'chapterId';
                                                    break;
                                                case 'subject':
                                                    // For course-level tests or subject-level tests
                                                    action = 'getQuestionsBySubject';
                                                    paramName = 'subjectId';
                                                    break;
                                                default:
                                                    alert('Unsupported context level: ' + contextLevel);
                                                    return;
                                            }

                                            console.log('Generating smart questions with context:', {
                                                contextLevel: contextLevel,
                                                contextId: contextId,
                                                action: action,
                                                paramName: paramName,
                                                count: count,
                                                difficulty: difficulty,
                                                category: category,
                                                excludeIds: Array.from(currentlySelectedIds)
                                            });

                                            // Show loading state
                                            $('#addingQuestionsList').html('<div class="alert alert-info"><i class="fas fa-spinner fa-spin"></i> Generating smart questions...</div>');
                                            $('#addingQuestionsPreview').addClass('active');
                                            updateAddingStats();

                                            // Build parameters object properly
                                            const params = {
                                                action: action,
                                                count: count,
                                                difficulty: difficulty,
                                                category: category,
                                                excludeIds: Array.from(currentlySelectedIds).join(',')
                                            };

                                            // Add the specific ID parameter
                                            params[paramName] = contextId;

                                            console.log('Final params object:', params);

                                            $.ajax({
                                                url: 'test',
                                                method: 'GET',
                                                data: params,
                                                dataType: 'json',
                                                success: function (data) {
                                                    console.log('Smart questions received:', data);

                                                    if (!Array.isArray(data)) {
                                                        console.error('Expected array but got:', typeof data, data);
                                                        $('#addingQuestionsList').html('<div class="alert alert-danger"><i class="fas fa-exclamation-triangle"></i> Invalid response format from server.</div>');
                                                        updateAddingStats();
                                                        return;
                                                    }

                                                    if (data && data.length > 0) {
                                                        displayAddingQuestions(data);
                                                    } else {
                                                        $('#addingQuestionsList').html('<div class="alert alert-warning"><i class="fas fa-info-circle"></i> No additional questions found matching your criteria. Try adjusting the filters.</div>');
                                                    }
                                                    updateAddingStats();
                                                },
                                                error: function (xhr, status, error) {
                                                    console.error('Failed to generate smart questions:', error);
                                                    console.error('Response status:', xhr.status);
                                                    console.error('Response text:', xhr.responseText);

                                                    let errorMessage = 'Failed to generate smart questions. Please try again.';
                                                    if (xhr.responseText && xhr.responseText.includes('<!DOCTYPE html>')) {
                                                        errorMessage = 'Server returned an error page. Action: ' + action + ' may not be handled properly.';
                                                    }

                                                    $('#addingQuestionsList').html('<div class="alert alert-danger"><i class="fas fa-exclamation-triangle"></i> ' + errorMessage + '</div>');
                                                    updateAddingStats();
                                                }
                                            });
                                        }

                                        function regenerateQuestions() {
                                            if (currentAddingMethod === 'smart') {
                                                generateSmartQuestions();
                                            }
                                        }

                                        // Display adding questions (both smart and manual)
                                        function displayAddingQuestions(questions) {
                                            const container = $('#addingQuestionsList');
                                            container.empty();

                                            if (!questions || questions.length === 0) {
                                                container.html('<div class="alert alert-warning"><i class="fas fa-info-circle"></i> No questions available to add.</div>');
                                                updateAddingStats();
                                                return;
                                            }

                                            questions.forEach(function (question) {
                                                // Double-check to avoid duplicates
                                                if (currentlySelectedIds.has(question.id)) {
                                                    return;
                                                }

                                                const difficulty = question.difficulty || 'medium';
                                                const category = question.category || 'conceptual';
                                                const type = question.question_type || 'SINGLE';
                                                const isAI = question.isAI || false;
                                                const questionText = question.question || 'No question text';

                                                const questionDiv = $('<div></div>')
                                                        .addClass('question-item')
                                                        .attr('data-question-id', question.id)
                                                        .attr('data-difficulty', difficulty)
                                                        .attr('data-category', category)
                                                        .attr('data-type', type)
                                                        .attr('data-source', isAI ? 'ai' : 'manual');

                                                const checkbox = $('<input>')
                                                        .attr('type', 'checkbox')
                                                        .attr('name', 'questionIds')
                                                        .attr('value', question.id)
                                                        .addClass('question-checkbox')
                                                        .prop('checked', true) // Auto-select new questions
                                                        .on('change', function () {
                                                            updateAddingStats();
                                                        });

                                                const contentDiv = $('<div></div>').addClass('question-content');
                                                const textDiv = $('<div></div>').addClass('question-text').text(questionText);

                                                const metaDiv = $('<div></div>').addClass('question-meta');

                                                // Add source indicator
                                                const sourceText = currentAddingMethod === 'smart' ? 'Smart Generated' : 'Manual Selection';
                                                metaDiv.append($('<span></span>').addClass('lesson-name').html('<i class="fas fa-plus"></i> ' + sourceText));

                                                metaDiv.append($('<span></span>').addClass('meta-badge difficulty-' + difficulty).text(difficulty));
                                                metaDiv.append($('<span></span>').addClass('meta-badge category-badge').text(category));
                                                metaDiv.append($('<span></span>').addClass('meta-badge').text(type));

                                                const aiGeneratedBadge = isAI ?
                                                        $('<span></span>').addClass('meta-badge ai-badge').text('AI Generated') :
                                                        $('<span></span>').addClass('meta-badge manual-badge').text('Manual');
                                                metaDiv.append(aiGeneratedBadge);

                                                contentDiv.append(textDiv).append(metaDiv);
                                                questionDiv.append(checkbox).append(contentDiv);

                                                container.append(questionDiv);
                                            });

                                            updateAddingStats();

                                            // Safe scroll to show generated questions - FIX for addEventListener error
                                            try {
                                                const previewElement = document.getElementById('addingQuestionsPreview');
                                                if (previewElement) {
                                                    previewElement.scrollIntoView({
                                                        behavior: 'smooth',
                                                        block: 'start'
                                                    });
                                                }
                                            } catch (error) {
                                                console.warn('Scroll to preview failed:', error);
                                                // Fallback scroll method
                                                $('html, body').animate({
                                                    scrollTop: $('#addingQuestionsPreview').offset().top - 100
                                                }, 500);
                                            }
                                        }


                                        // Load manual questions for selected lesson
                                        function loadManualQuestions(lessonId) {
                                            console.log('Loading manual questions for lesson:', lessonId);

                                            // Show loading state
                                            $('#manualQuestionsList').html('<div class="alert alert-info"><i class="fas fa-spinner fa-spin"></i> Loading questions...</div>');
                                            $('#manualQuestionsContainer').show();

                                            $.get('test', {
                                                action: 'getQuestionsByLesson',
                                                lessonId: lessonId
                                            }, function (data) {
                                                console.log('Manual questions loaded:', data);
                                                allManualQuestions = data; // Store for filtering
                                                displayManualQuestions(data);

                                                // Show filter controls after loading
                                                $('#manualFilterControls').show();
                                            }).fail(function (xhr, status, error) {
                                                console.error('Failed to load manual questions:', error);
                                                $('#manualQuestionsList').html('<div class="alert alert-danger"><i class="fas fa-exclamation-triangle"></i> Failed to load questions: ' + error + '</div>');
                                            });
                                        }

                                        // Display manual questions for selection
                                        function displayManualQuestions(questions) {
                                            const container = $('#manualQuestionsList');
                                            container.empty();

                                            if (!questions || questions.length === 0) {
                                                container.html('<div class="alert alert-warning"><i class="fas fa-info-circle"></i> No questions found for this lesson</div>');
                                                return;
                                            }

                                            // Filter out already selected questions
                                            const availableQuestions = questions.filter(function (q) {
                                                return !currentlySelectedIds.has(q.id);
                                            });

                                            if (availableQuestions.length === 0) {
                                                container.html('<div class="alert alert-info"><i class="fas fa-info-circle"></i> All questions from this lesson are already selected in the test</div>');
                                                return;
                                            }

                                            availableQuestions.forEach(function (question) {
                                                const difficulty = question.difficulty || 'medium';
                                                const category = question.category || 'conceptual';
                                                const type = question.type || 'SINGLE';
                                                const isAI = question.isAI || false;
                                                const questionText = question.question || 'No question text';

                                                const questionDiv = $('<div></div>')
                                                        .addClass('question-item')
                                                        .attr('data-question-id', question.id)
                                                        .attr('data-difficulty', difficulty)
                                                        .attr('data-category', category)
                                                        .attr('data-type', type)
                                                        .attr('data-source', isAI ? 'ai' : 'manual')
                                                        .attr('data-question-text', questionText.toLowerCase()); // For search

                                                const checkbox = $('<input>')
                                                        .attr('type', 'checkbox')
                                                        .attr('value', question.id)
                                                        .addClass('question-checkbox')
                                                        .on('change', function () {
                                                            updateManualStats();
                                                            copyManualSelectionsToPreview();
                                                        });

                                                const contentDiv = $('<div></div>').addClass('question-content');
                                                const textDiv = $('<div></div>').addClass('question-text').text(questionText);

                                                const metaDiv = $('<div></div>').addClass('question-meta');
                                                metaDiv.append($('<span></span>').addClass('lesson-name').html('<i class="fas fa-book"></i> Available for Selection'));
                                                metaDiv.append($('<span></span>').addClass('meta-badge difficulty-' + difficulty).text(difficulty));
                                                metaDiv.append($('<span></span>').addClass('meta-badge category-badge').text(category));
                                                metaDiv.append($('<span></span>').addClass('meta-badge').text(type));

                                                const aiGeneratedBadge = isAI ?
                                                        $('<span></span>').addClass('meta-badge ai-badge').text('AI Generated') :
                                                        $('<span></span>').addClass('meta-badge manual-badge').text('Manual');
                                                metaDiv.append(aiGeneratedBadge);

                                                contentDiv.append(textDiv).append(metaDiv);
                                                questionDiv.append(checkbox).append(contentDiv);

                                                container.append(questionDiv);
                                            });

                                            updateManualStats();
                                        }

                                        // Filter manual questions
                                        function filterManualQuestions() {
                                            const searchTerm = $('#questionSearch').val().toLowerCase();
                                            const difficultyFilter = $('#manualDifficultyFilter').val();
                                            const categoryFilter = $('#manualCategoryFilter').val();
                                            const typeFilter = $('#manualTypeFilter').val();

                                            $('#manualQuestionsList .question-item').each(function () {
                                                const $item = $(this);
                                                let visible = true;

                                                // Search filter
                                                if (searchTerm && !$item.attr('data-question-text').includes(searchTerm)) {
                                                    visible = false;
                                                }

                                                // Difficulty filter
                                                if (difficultyFilter && difficultyFilter !== 'all' && $item.attr('data-difficulty') !== difficultyFilter) {
                                                    visible = false;
                                                }

                                                // Category filter
                                                if (categoryFilter && categoryFilter !== 'all' && $item.attr('data-category') !== categoryFilter) {
                                                    visible = false;
                                                }

                                                // Type filter
                                                if (typeFilter && typeFilter !== 'all' && $item.attr('data-type') !== typeFilter) {
                                                    visible = false;
                                                }

                                                if (visible) {
                                                    $item.show();
                                                    // Highlight search term
                                                    if (searchTerm) {
                                                        const $questionText = $item.find('.question-text');
                                                        const text = $questionText.text();
                                                        const highlightedText = text.replace(new RegExp(searchTerm, 'gi'), '<mark>$&</mark>');
                                                        $questionText.html(highlightedText);
                                                    }
                                                } else {
                                                    $item.hide();
                                                }
                                            });

                                            updateManualStats();
                                        }

                                        // Clear manual filters
                                        function clearManualFilters() {
                                            $('#questionSearch').val('');
                                            $('#manualDifficultyFilter').val('all');
                                            $('#manualCategoryFilter').val('all');
                                            $('#manualTypeFilter').val('all');

                                            // Remove highlights and show all items
                                            $('#manualQuestionsList .question-item').show();
                                            $('#manualQuestionsList .question-text').each(function () {
                                                const $this = $(this);
                                                $this.html($this.text()); // Remove HTML tags
                                            });

                                            updateManualStats();
                                        }

                                        // Hierarchy loading functions
                                        function loadSubjects(gradeId) {
                                            $.get('test', {
                                                action: 'getSubjectsByGrade',
                                                gradeId: gradeId
                                            }, function (data) {
                                                populateSelect('#subjectSelect', data, '-- Select Subject --');
                                            }).fail(function (xhr, status, error) {
                                                console.error('Failed to load subjects:', error);
                                            });
                                        }

                                        function loadChapters(subjectId) {
                                            $.get('test', {
                                                action: 'getChaptersBySubject',
                                                subjectId: subjectId
                                            }, function (data) {
                                                populateSelect('#chapterSelect', data, '-- Select Chapter --');
                                            }).fail(function (xhr, status, error) {
                                                console.error('Failed to load chapters:', error);
                                            });
                                        }

                                        function loadLessons(chapterId) {
                                            $.get('test', {
                                                action: 'getLessonsByChapter',
                                                chapterId: chapterId
                                            }, function (data) {
                                                populateSelect('#lessonSelect', data, '-- Select Lesson --');
                                            }).fail(function (xhr, status, error) {
                                                console.error('Failed to load lessons:', error);
                                            });
                                        }

                                        function populateSelect(selector, data, placeholder) {
                                            const $select = $(selector);
                                            $select.empty().append('<option value="">' + placeholder + '</option>');
                                            $.each(data, function (i, item) {
                                                $select.append('<option value="' + item.id + '">' + item.name + '</option>');
                                            });
                                            $select.prop('disabled', false);
                                            $select.select2('destroy');
                                            initializeSelect2(selector);
                                        }

                                        function resetSubsequentSelects(selectors) {
                                            selectors.forEach(function (selector) {
                                                $(selector).empty().append('<option value="">-- Select --</option>').prop('disabled', true);
                                                $(selector).select2('destroy');
                                                initializeSelect2(selector);
                                            });
                                        }
                                        // Show selection scope options (Lesson, Chapter, Subject) for update page
                                        function showSelectionScopeOptionsForUpdate() {
                                            // Add scope selection if not exists
                                            if ($('#scopeSelectionUpdate').length === 0) {
                                                const contextLevel = document.getElementById('contextLevel')?.value;
                                                const contextId = document.getElementById('contextId')?.value;

                                                let contextHint = '';
                                                if (contextLevel && contextId) {
                                                    contextHint = '<div class="alert alert-success">' +
                                                            '<i class="fas fa-info-circle"></i>' +
                                                            '<strong>Test Context Available:</strong> This test has ' + contextLevel + ' level context. ' +
                                                            'You can use "' + contextLevel + '" scope for direct generation, or choose other scopes for broader question selection.' +
                                                            '</div>';
                                                }

                                                // Build scope options HTML
                                                let lessonChecked = '';
                                                let chapterChecked = '';
                                                let subjectChecked = '';
                                                let lessonIndicator = '';
                                                let chapterIndicator = '';
                                                let subjectIndicator = '';

                                                if (contextLevel === 'lesson') {
                                                    lessonChecked = 'checked';
                                                    lessonIndicator = '<span class="scope-indicator lesson">Current Context</span>';
                                                } else if (contextLevel === 'chapter') {
                                                    chapterChecked = 'checked';
                                                    chapterIndicator = '<span class="scope-indicator chapter">Current Context</span>';
                                                } else if (contextLevel === 'subject') {
                                                    subjectChecked = 'checked';
                                                    subjectIndicator = '<span class="scope-indicator subject">Current Context</span>';
                                                } else {
                                                    // Default to chapter if no context
                                                    chapterChecked = 'checked';
                                                }

                                                const scopeHtml = '<div id="scopeSelectionUpdate" class="form-section" style="margin-bottom: 20px;">' +
                                                        '<h5><i class="fas fa-layer-group"></i> Question Selection Scope</h5>' +
                                                        '<div class="alert alert-info">' +
                                                        '<i class="fas fa-info-circle"></i>' +
                                                        'Choose the scope for adding more questions: specific lesson, entire chapter, or whole subject.' +
                                                        '</div>' +
                                                        contextHint +
                                                        '<div style="margin-bottom: 15px;">' +
                                                        '<label>' +
                                                        '<input type="radio" name="selectionScopeUpdate" value="lesson" ' + lessonChecked + ' onchange="toggleSelectionScopeForUpdate()"> ' +
                                                        '<i class="fas fa-book"></i> Lesson Level - Select from a specific lesson ' +
                                                        lessonIndicator +
                                                        '</label><br>' +
                                                        '<label>' +
                                                        '<input type="radio" name="selectionScopeUpdate" value="chapter" ' + chapterChecked + ' onchange="toggleSelectionScopeForUpdate()"> ' +
                                                        '<i class="fas fa-bookmark"></i> Chapter Level - Select from all lessons in a chapter ' +
                                                        chapterIndicator +
                                                        '</label><br>' +
                                                        '<label>' +
                                                        '<input type="radio" name="selectionScopeUpdate" value="subject" ' + subjectChecked + ' onchange="toggleSelectionScopeForUpdate()"> ' +
                                                        '<i class="fas fa-graduation-cap"></i> Subject Level - Select from all lessons in a subject ' +
                                                        subjectIndicator +
                                                        '</label>' +
                                                        '</div>' +
                                                        '</div>';

                                                $('#hierarchySection').before(scopeHtml);
                                            }

                                            toggleSelectionScopeForUpdate();
                                        }

                                        // Toggle selection scope for update page
                                        window.toggleSelectionScopeForUpdate = function () {
                                            const scope = $('input[name="selectionScopeUpdate"]:checked').val();
                                            const method = currentAddingMethod;

                                            // Update hierarchy section based on scope
                                            updateHierarchyForScopeUpdate(scope);

                                            // Update smart generation section
                                            if (method === 'smart') {
                                                updateSmartGenerationForScopeUpdate(scope);
                                            }

                                            // Clear previous selections
                                            $('#addingQuestionsPreview').removeClass('active');
                                            $('#addingQuestionsList').empty();
                                            $('#manualQuestionsContainer').hide();
                                        };

                                        // Update hierarchy section based on scope for update page
                                        function updateHierarchyForScopeUpdate(scope) {
                                            const $hierarchySteps = $('.hierarchy-steps');
                                            const $lessonStep = $hierarchySteps.find('.step-item').eq(3);
                                            const $chapterStep = $hierarchySteps.find('.step-item').eq(2);
                                            const $subjectStep = $hierarchySteps.find('.step-item').eq(1);

                                            // Reset all steps
                                            $hierarchySteps.find('.step-item').show();

                                            // Update instruction based on scope
                                            let instruction = '';
                                            switch (scope) {
                                                case 'lesson':
                                                    instruction = 'Navigate through Grade → Subject → Chapter → Lesson to find questions';
                                                    break;
                                                case 'chapter':
                                                    instruction = 'Navigate through Grade → Subject → Chapter to find all questions in that chapter';
                                                    $lessonStep.hide();
                                                    break;
                                                case 'subject':
                                                    instruction = 'Navigate through Grade → Subject to find all questions in that subject';
                                                    $chapterStep.hide();
                                                    $lessonStep.hide();
                                                    break;
                                            }

                                            $('#hierarchySection .alert').html('<i class="fas fa-route"></i> ' + instruction);
                                        }

// Update smart generation section based on scope for update page
                                        function updateSmartGenerationForScopeUpdate(scope) {
                                            const $generateBtn = $('#generateSmartBtn');
                                            let buttonText = '';

                                            switch (scope) {
                                                case 'lesson':
                                                    buttonText = '<i class="fas fa-dice"></i> Generate from Lesson';
                                                    break;
                                                case 'chapter':
                                                    buttonText = '<i class="fas fa-dice"></i> Generate from Chapter';
                                                    break;
                                                case 'subject':
                                                    buttonText = '<i class="fas fa-dice"></i> Generate from Subject';
                                                    break;
                                            }

                                            $generateBtn.html(buttonText);
                                        }

                                        function setupEnhancedHierarchyHandlers() {
                                            // Override existing subject select handler
                                            $('#subjectSelect').off('change').on('change', function () {
                                                const subjectId = $(this).val();
                                                const scope = $('input[name="selectionScopeUpdate"]:checked').val();

                                                if (subjectId) {
                                                    if (scope === 'subject') {
                                                        // Load questions directly from subject
                                                        currentSubjectId = subjectId;
                                                        if (currentAddingMethod === 'manual') {
                                                            loadManualQuestionsFromSubjectUpdate(subjectId);
                                                        }
                                                    } else {
                                                        // Continue with chapter selection
                                                        loadChapters(subjectId);
                                                        resetSubsequentSelects(['#chapterSelect', '#lessonSelect']);
                                                        $('#manualQuestionsContainer').hide();
                                                    }
                                                }
                                            });

                                            // Override existing chapter select handler
                                            $('#chapterSelect').off('change').on('change', function () {
                                                const chapterId = $(this).val();
                                                const scope = $('input[name="selectionScopeUpdate"]:checked').val();

                                                if (chapterId) {
                                                    if (scope === 'chapter') {
                                                        // Load questions directly from chapter
                                                        currentChapterId = chapterId;
                                                        if (currentAddingMethod === 'manual') {
                                                            loadManualQuestionsFromChapterUpdate(chapterId);
                                                        }
                                                    } else {
                                                        // Continue with lesson selection
                                                        loadLessons(chapterId);
                                                        resetSubsequentSelects(['#lessonSelect']);
                                                        $('#manualQuestionsContainer').hide();
                                                    }
                                                }
                                            });
                                        }

// Load manual questions from subject for update page
                                        function loadManualQuestionsFromSubjectUpdate(subjectId) {
                                            console.log('Loading manual questions from subject for update:', subjectId);

                                            $('#manualQuestionsList').html('<div class="alert alert-info"><i class="fas fa-spinner fa-spin"></i> Loading questions from subject...</div>');
                                            $('#manualQuestionsContainer').show();

                                            $.get('test', {
                                                action: 'getAllQuestionsBySubject',
                                                subjectId: subjectId
                                            }, function (data) {
                                                console.log('Subject questions loaded for update:', data);
                                                allManualQuestions = data;
                                                displayManualQuestions(data);
                                                $('#manualFilterControls').show();
                                            }).fail(function (xhr, status, error) {
                                                console.error('Failed to load subject questions:', error);
                                                $('#manualQuestionsList').html('<div class="alert alert-danger"><i class="fas fa-exclamation-triangle"></i> Failed to load questions: ' + error + '</div>');
                                            });
                                        }

// Load manual questions from chapter for update page
                                        function loadManualQuestionsFromChapterUpdate(chapterId) {
                                            console.log('Loading manual questions from chapter for update:', chapterId);

                                            $('#manualQuestionsList').html('<div class="alert alert-info"><i class="fas fa-spinner fa-spin"></i> Loading questions from chapter...</div>');
                                            $('#manualQuestionsContainer').show();

                                            $.get('test', {
                                                action: 'getAllQuestionsByChapter',
                                                chapterId: chapterId
                                            }, function (data) {
                                                console.log('Chapter questions loaded for update:', data);
                                                allManualQuestions = data;
                                                displayManualQuestions(data);
                                                $('#manualFilterControls').show();
                                            }).fail(function (xhr, status, error) {
                                                console.error('Failed to load chapter questions:', error);
                                                $('#manualQuestionsList').html('<div class="alert alert-danger"><i class="fas fa-exclamation-triangle"></i> Failed to load questions: ' + error + '</div>');
                                            });
                                        }
                                        function generateSmartQuestionsUpdate() {
                                            console.log('=== GENERATE SMART QUESTIONS UPDATE DEBUG ===');

                                            // Debug available elements
                                            console.log('Available elements:');
                                            console.log('- contextLevel element:', document.getElementById('contextLevel'));
                                            console.log('- contextId element:', document.getElementById('contextId'));
                                            console.log('- isCourseLevel element:', document.getElementById('isCourseLevel'));

                                            const scope = $('input[name="selectionScopeUpdate"]:checked').val();
                                            const count = $('#questionCount').val() || 5;
                                            const difficulty = $('#difficultyFilter').val();
                                            const category = $('#categoryFilter').val();

                                            console.log('=== DEBUG SMART GENERATION UPDATE ===');
                                            console.log('Selected scope:', scope);

                                            // Get test context information
                                            const testContextLevel = document.getElementById('contextLevel')?.value;
                                            const testContextId = document.getElementById('contextId')?.value;
                                            const isCourseLevel = document.getElementById('isCourseLevel')?.value === 'true';

                                            console.log('Test contextLevel:', testContextLevel);
                                            console.log('Test contextId:', testContextId);
                                            console.log('isCourseLevel:', isCourseLevel);

                                            let sourceId = null;
                                            let action = '';
                                            let paramName = '';

                                            // Enhanced logic for determining source based on scope and test context
                                            switch (scope) {
                                                case 'lesson':
                                                    if (!contextLessonId) {
                                                        // Try to get from manual selection
                                                        const selectedLessonId = $('#lessonSelect').val();
                                                        if (!selectedLessonId) {
                                                            alert('Please select a lesson first from the hierarchy');
                                                            return;
                                                        }
                                                        sourceId = selectedLessonId;
                                                    } else {
                                                        sourceId = contextLessonId;
                                                    }
                                                    action = 'getSmartQuestions';
                                                    paramName = 'lessonId';
                                                    break;

                                                case 'chapter':
                                                    if (!currentChapterId) {
                                                        // For course-level tests, we need to select a chapter manually
                                                        const selectedChapterId = $('#chapterSelect').val();
                                                        if (!selectedChapterId) {
                                                            alert('Please select a chapter first from the hierarchy');
                                                            return;
                                                        }
                                                        sourceId = selectedChapterId;
                                                    } else {
                                                        sourceId = currentChapterId;
                                                    }
                                                    action = 'getQuestionsByChapter';
                                                    paramName = 'chapterId';
                                                    break;

                                                case 'subject':
                                                    // Enhanced subject handling
                                                    if (testContextLevel === 'subject' && testContextId) {
                                                        // Use context from test
                                                        sourceId = testContextId;
                                                    } else if (currentSubjectId) {
                                                        // Use manually selected subject
                                                        sourceId = currentSubjectId;
                                                    } else {
                                                        // Try to get from hierarchy selection
                                                        const selectedSubjectId = $('#subjectSelect').val();
                                                        if (!selectedSubjectId) {
                                                            alert('Please select a subject first from the hierarchy');
                                                            return;
                                                        }
                                                        sourceId = selectedSubjectId;
                                                    }
                                                    action = 'getQuestionsBySubject';
                                                    paramName = 'subjectId';
                                                    break;

                                                default:
                                                    alert('Please select a scope first');
                                                    return;
                                            }

                                            console.log('Final generation params:', {
                                                scope: scope,
                                                sourceId: sourceId,
                                                action: action,
                                                paramName: paramName,
                                                count: count,
                                                difficulty: difficulty,
                                                category: category
                                            });

                                            // Show loading state
                                            $('#addingQuestionsList').html('<div class="alert alert-info"><i class="fas fa-spinner fa-spin"></i> Generating smart questions...</div>');
                                            $('#addingQuestionsPreview').addClass('active');
                                            updateAddingStats();

                                            // Build parameters object properly
                                            const params = {
                                                action: action,
                                                count: count,
                                                difficulty: difficulty,
                                                category: category,
                                                excludeIds: Array.from(currentlySelectedIds).join(',')
                                            };

                                            // Add the specific ID parameter
                                            params[paramName] = sourceId;

                                            console.log('Final params object:', params);

                                            $.ajax({
                                                url: 'test',
                                                method: 'GET',
                                                data: params,
                                                dataType: 'json',
                                                success: function (data) {
                                                    console.log('Smart questions received for update:', data);

                                                    if (!Array.isArray(data)) {
                                                        console.error('Expected array but got:', typeof data, data);
                                                        $('#addingQuestionsList').html('<div class="alert alert-danger"><i class="fas fa-exclamation-triangle"></i> Invalid response format from server.</div>');
                                                        updateAddingStats();
                                                        return;
                                                    }

                                                    if (data && data.length > 0) {
                                                        displayAddingQuestions(data);
                                                    } else {
                                                        $('#addingQuestionsList').html('<div class="alert alert-warning"><i class="fas fa-info-circle"></i> No additional questions found matching your criteria. Try adjusting the filters.</div>');
                                                    }
                                                    updateAddingStats();
                                                },
                                                error: function (xhr, status, error) {
                                                    console.error('Failed to generate smart questions:', error);
                                                    console.error('Response status:', xhr.status);
                                                    console.error('Response text:', xhr.responseText);

                                                    let errorMessage = 'Failed to generate smart questions. Please try again.';
                                                    if (xhr.responseText && xhr.responseText.includes('<!DOCTYPE html>')) {
                                                        errorMessage = 'Server returned an error page. Action: ' + action + ' may not be handled properly.';
                                                    }

                                                    $('#addingQuestionsList').html('<div class="alert alert-danger"><i class="fas fa-exclamation-triangle"></i> ' + errorMessage + '</div>');
                                                    updateAddingStats();
                                                }
                                            });
                                        }

                                        // Function to auto-select appropriate scope based on test context
                                        function autoSelectAppropriateScope() {
                                            const contextLevel = document.getElementById('contextLevel')?.value;

                                            console.log('Auto-selecting scope for contextLevel:', contextLevel);

                                            if (contextLevel) {
                                                // Auto-select the scope that matches test context
                                                const scopeRadio = $('input[name="selectionScopeUpdate"][value="' + contextLevel + '"]');
                                                if (scopeRadio.length > 0) {
                                                    scopeRadio.prop('checked', true);
                                                    toggleSelectionScopeForUpdate();
                                                    console.log('Auto-selected scope:', contextLevel);
                                                }
                                            }
                                        }

                                        const originalToggleAddingMethod = window.toggleAddingMethod;

                                        // Document ready function
                                        $(document).ready(function () {
                                            // Initialize global variables
                                            contextLessonId = $('#contextLessonId').val();
                                            currentlySelectedIds = new Set();

                                            // Initialize scope selection if not already done
                                            if ($('input[name="selectionScopeUpdate"]').length === 0) {
                                                setTimeout(function () {
                                                    showSelectionScopeOptionsForUpdate();
                                                }, 100);
                                            }

                                            setTimeout(function () {
                                                // Initialize scope selection if not already done
                                                if ($('#scopeSelectionUpdate').length === 0) {
                                                    showSelectionScopeOptionsForUpdate();
                                                }

                                                // Auto-select appropriate scope based on test context
                                                autoSelectAppropriateScope();

                                                // Setup handlers
                                                setupEnhancedHierarchyHandlers();
                                            }, 500);

                                            // Initialize validation on page load
                                            if (isCourseTest && originalRequiredCount > 0) {
                                                updateQuestionCountWarning(originalRequiredCount);

                                                // Also trigger validation when any question checkbox changes
                                                $(document).on('change', 'input[name="questionIds"]', function () {
                                                    const requiredCount = getCurrentRequiredCount();
                                                    updateQuestionCountWarning(requiredCount);
                                                });
                                            }

                                            // Initialize currently selected question IDs
                                            $('.current-question-checkbox:checked').each(function () {
                                                currentlySelectedIds.add(parseInt($(this).val()));
                                            });

                                            console.log('Context Lesson ID:', contextLessonId);
                                            console.log('Currently selected question IDs:', Array.from(currentlySelectedIds));

                                            // Initialize Select2 dropdowns
                                            $('.select2-dropdown').each(function () {
                                                initializeSelect2('#' + $(this).attr('id'));
                                            });

                                            // Initialize selection stats
                                            updateCurrentSelectionStats();

                                            // Initialize adding method
                                            toggleAddingMethod();

                                            // Event handlers for current questions
                                            $(document).on('change', '.current-question-checkbox', function () {
                                                updateCurrentSelectionStats();
                                            });

                                            $(document).on('change', '#addingQuestionsList .question-checkbox', function () {
                                                updateAddingStats();
                                            });

                                            $(document).on('change', '#manualQuestionsList .question-checkbox', function () {
                                                updateManualStats();
                                                copyManualSelectionsToPreview();
                                            });

                                            // Event handlers for bulk actions
                                            $('#selectAllCurrentBtn').on('click', selectAllCurrent);
                                            $('#deselectAllCurrentBtn').on('click', deselectAllCurrent);
                                            $('#selectAllAddingBtn').on('click', selectAllAdding);
                                            $('#deselectAllAddingBtn').on('click', deselectAllAdding);
                                            $('#selectAllManualBtn').on('click', selectAllManual);
                                            $('#deselectAllManualBtn').on('click', deselectAllManual);
                                            $('#generateSmartBtn').on('click', generateSmartQuestions);
                                            $('#regenerateBtn').on('click', regenerateQuestions);

                                            // Event handlers for manual question filters
                                            $('#questionSearch').on('input', filterManualQuestions);
                                            $('#manualDifficultyFilter, #manualCategoryFilter, #manualTypeFilter').on('change', filterManualQuestions);
                                            $('#clearFiltersBtn').on('click', clearManualFilters);

                                            // Hierarchy selection handlers
                                            $('#gradeSelect').on('change', function () {
                                                const gradeId = $(this).val();
                                                if (gradeId) {
                                                    loadSubjects(gradeId);
                                                    resetSubsequentSelects(['#subjectSelect', '#chapterSelect', '#lessonSelect']);
                                                    $('#manualQuestionsContainer').hide();
                                                }
                                            });

                                            $('#subjectSelect').on('change', function () {
                                                const subjectId = $(this).val();
                                                if (subjectId) {
                                                    loadChapters(subjectId);
                                                    resetSubsequentSelects(['#chapterSelect', '#lessonSelect']);
                                                    $('#manualQuestionsContainer').hide();
                                                }
                                            });

                                            $('#chapterSelect').on('change', function () {
                                                const chapterId = $(this).val();
                                                if (chapterId) {
                                                    loadLessons(chapterId);
                                                    resetSubsequentSelects(['#lessonSelect']);
                                                    $('#manualQuestionsContainer').hide();
                                                }
                                            });

                                            $('#lessonSelect').on('change', function () {
                                                const lessonId = $(this).val();
                                                if (lessonId) {
                                                    loadManualQuestions(lessonId);
                                                }
                                            });

                                            // Form submission validation
                                            $('#updateTestForm').off('submit').on('submit', function (e) {
                                                const totalSelected = getTotalSelectedQuestions();

                                                console.log('Form submission - totalSelected:', totalSelected);

                                                if (totalSelected === 0) {
                                                    e.preventDefault();
                                                    alert('Please select at least one question for the test');
                                                    return false;
                                                }

                                                // Course test specific validation
                                                if (isCourseTest) {
                                                    const requiredCount = getCurrentRequiredCount();
                                                    const duration = parseInt($('#duration').val());

                                                    console.log('Form submission - requiredCount:', requiredCount, 'totalSelected:', totalSelected);

                                                    // Validate duration
                                                    if (duration < 5 || duration > 180) {
                                                        e.preventDefault();
                                                        alert('Duration must be between 5 and 180 minutes');
                                                        $('#duration').focus();
                                                        return false;
                                                    }

                                                    // Validate question count
                                                    if (requiredCount < 1 || requiredCount > 100) {
                                                        e.preventDefault();
                                                        alert('Number of questions must be between 1 and 100');
                                                        $('#numQuestions').focus();
                                                        return false;
                                                    }

                                                    // Validate exact question count match
                                                    if (totalSelected !== requiredCount) {
                                                        e.preventDefault();
                                                        alert('For course-integrated tests, you must select exactly ' + requiredCount + ' questions. Currently selected: ' + totalSelected + ' questions.');
                                                        return false;
                                                    }
                                                }

                                                // Show loading state
                                                $('input[type="submit"]').prop('disabled', true).val('Updating Test...');
                                                return true;
                                            });

                                            // visual feedback
                                            $('.question-item').on('mouseenter', function () {
                                                $(this).css('transform', 'translateY(-2px)');
                                            }).on('mouseleave', function () {
                                                $(this).css('transform', 'translateY(0)');
                                            });

                                            // Question text expansion for long questions
                                            $(document).on('click', '.question-text', function () {
                                                const fullText = $(this).text();
                                                if (fullText.length > 100) {
                                                    const isExpanded = $(this).hasClass('expanded');
                                                    if (isExpanded) {
                                                        $(this).removeClass('expanded').css({
                                                            'max-height': '3em',
                                                            'overflow': 'hidden'
                                                        });
                                                    } else {
                                                        $(this).addClass('expanded').css({
                                                            'max-height': 'none',
                                                            'overflow': 'visible'
                                                        });
                                                    }
                                                }
                                            });

                                            // Initialize long question text truncation
                                            $(document).on('mouseenter', '.question-text', function () {
                                                const text = $(this).text();
                                                if (text.length > 150) {
                                                    $(this).css({
                                                        'max-height': '3em',
                                                        'overflow': 'hidden',
                                                        'cursor': 'pointer',
                                                        'position': 'relative'
                                                    }).attr('title', 'Click to expand/collapse');
                                                }
                                            });

                                            // Keyboard shortcuts
                                            $(document).on('keydown', function (e) {
                                                // Ctrl+S: Submit form
                                                if (e.ctrlKey && e.key === 's') {
                                                    e.preventDefault();
                                                    $('#updateTestForm').submit();
                                                }
                                                // Ctrl+G: Generate smart questions
                                                if (e.ctrlKey && e.key === 'g') {
                                                    e.preventDefault();
                                                    if (contextLessonId && currentAddingMethod === 'smart') {
                                                        generateSmartQuestions();
                                                    }
                                                }
                                                // Ctrl+F: Focus search
                                                if (e.ctrlKey && e.key === 'f' && currentAddingMethod === 'manual') {
                                                    e.preventDefault();
                                                    $('#questionSearch').focus();
                                                }
                                            });

                                            setTimeout(function () {
                                                // Initialize scope selection for smart method if context exists
                                                if (contextLessonId && currentAddingMethod === 'smart') {
                                                    if ($('#scopeSelectionUpdate').length === 0) {
                                                        showSelectionScopeOptionsForUpdate();
                                                    }
                                                }

                                                // Setup handlers
                                                setupEnhancedHierarchyHandlers();
                                            }, 500);

                                            // Auto-select appropriate scope based on test context
                                            if (testContextLevel && $('#scopeSelectionUpdate').length > 0) {
                                                console.log('Auto-selecting scope for contextLevel:', testContextLevel);
                                                let autoScope = 'subject'; // default

                                                if (testContextLevel === 'lesson') {
                                                    autoScope = 'lesson';
                                                } else if (testContextLevel === 'chapter') {
                                                    autoScope = 'chapter';
                                                } else if (testContextLevel === 'subject') {
                                                    autoScope = 'subject';
                                                }

                                                $('input[name="selectionScopeUpdate"][value="' + autoScope + '"]').prop('checked', true);
                                                console.log('Auto-selected scope:', autoScope);

                                                // Trigger the change event to update UI
                                                setTimeout(function () {
                                                    toggleSelectionScopeForUpdate();
                                                }, 200);
                                            }

//                                            console.log('Test Update page initialized successfully');
                                        });

                                        // Make functions globally accessible
                                        window.toggleAddingMethod = function () {
                                            // Call original function
                                            if (originalToggleAddingMethod) {
                                                originalToggleAddingMethod();
                                            }

                                            // Add scope selection for manual method
                                            if (currentAddingMethod === 'manual') {
                                                if ($('#scopeSelectionUpdate').length === 0) {
                                                    showSelectionScopeOptionsForUpdate();
                                                }
                                                // Auto-select appropriate scope
                                                autoSelectAppropriateScope();
                                                setupEnhancedHierarchyHandlers();
                                            }
                                        };

                                        window.generateSmartQuestions = generateSmartQuestionsUpdate;
                                        window.regenerateQuestions = regenerateQuestions;
                                        window.filterManualQuestions = filterManualQuestions;
                                        window.clearManualFilters = clearManualFilters;
                                        window.showHierarchySelection = showHierarchySelection;
                                        window.hideHierarchySelection = hideHierarchySelection;

                                        // Function to get current required count
                                        function getCurrentRequiredCount() {
                                            if (isCourseTest) {
                                                const numQuestionsInput = $('#numQuestions');
                                                if (numQuestionsInput.length > 0) {
                                                    const value = parseInt(numQuestionsInput.val());
                                                    return value > 0 ? value : originalRequiredCount;
                                                }
                                            }
                                            return originalRequiredCount;
                                        }

                                        // Update required question count when numQuestions changes
                                        $(document).on('change', '#numQuestions', function () {
                                            const newCount = parseInt($(this).val()) || 0;
                                            const requiredSpan = $('#requiredQuestionCount');

                                            // Update all instances of required count display
                                            if (requiredSpan.length) {
                                                requiredSpan.text(newCount);
                                            }

                                            // Update warning for course tests
                                            if (isCourseTest) {
                                                updateQuestionCountWarning(newCount);
                                            }
                                        });

                                        // Function to update question count warning
                                        function updateQuestionCountWarning(requiredCount) {
                                            const selectedCount = $('input[name="questionIds"]:checked').length;
                                            const warningElement = $('#questionCountWarning');

                                            console.log('updateQuestionCountWarning - requiredCount:', requiredCount, 'selectedCount:', selectedCount);

                                            if (!warningElement.length) {
                                                console.warn('Warning element #questionCountWarning not found');
                                                return;
                                            }

                                            // Force convert to numbers to ensure they're valid
                                            const reqCount = parseInt(requiredCount) || 0;
                                            const selCount = parseInt(selectedCount) || 0;

                                            console.log('Converted values - reqCount:', reqCount, 'selCount:', selCount);

                                            if (selCount !== reqCount) {
                                                warningElement.removeClass('alert-warning alert-success').addClass('alert-danger');

                                                // Build HTML string step by step to avoid template literal issues
                                                const iconHtml = '<i class="fas fa-exclamation-triangle"></i>';
                                                const strongStart = '<strong>Error:</strong>';
                                                const message1 = ' You must select exactly ';
                                                const reqSpanHtml = '<span id="requiredQuestionCount">' + reqCount + '</span>';
                                                const message2 = ' questions for this test. Currently selected: ';
                                                const selStrongHtml = '<strong>' + selCount + '</strong>';
                                                const message3 = ' questions.';

                                                const fullHtml = iconHtml + ' ' + strongStart + message1 + reqSpanHtml + message2 + selStrongHtml + message3;

                                                console.log('Setting error HTML:', fullHtml);
                                                warningElement.html(fullHtml);

                                            } else {
                                                warningElement.removeClass('alert-danger alert-warning').addClass('alert-success');

                                                // Build success HTML
                                                const iconHtml = '<i class="fas fa-check-circle"></i>';
                                                const strongStart = '<strong>Perfect:</strong>';
                                                const message = ' You have selected exactly ';
                                                const countHtml = '<strong>' + reqCount + '</strong>';
                                                const message2 = ' questions as required.';

                                                const fullHtml = iconHtml + ' ' + strongStart + message + countHtml + message2;

                                                console.log('Setting success HTML:', fullHtml);
                                                warningElement.html(fullHtml);
                                            }

                                            // Double check the HTML was set correctly
                                            console.log('Final warning HTML:', warningElement.html());
                                        }

                                        // Helper function to get total selected questions (both current and adding)
                                        function getTotalSelectedQuestions() {
                                            const currentSelected = $('.current-question-checkbox:checked').length;
                                            const addingSelected = $('#addingQuestionsList .question-checkbox:checked').length;
                                            const total = currentSelected + addingSelected;

                                            console.log('getTotalSelectedQuestions - current:', currentSelected, 'adding:', addingSelected, 'total:', total);
                                            return total;
                                        }


                                        // Override the existing updateCurrentSelectionStats function
                                        const originalUpdateCurrentSelectionStats = window.updateCurrentSelectionStats;
                                        window.updateCurrentSelectionStats = function () {
                                            // Call original function
                                            if (originalUpdateCurrentSelectionStats) {
                                                originalUpdateCurrentSelectionStats();
                                            }

                                            // Add course test validation
                                            if (isCourseTest) {
                                                const requiredCount = getCurrentRequiredCount();
                                                console.log('updateCurrentSelectionStats - requiredCount:', requiredCount);
                                                updateQuestionCountWarning(requiredCount);
                                            }
                                        };

                                        // Override the existing updateAddingStats function
                                        const originalUpdateAddingStats = window.updateAddingStats;
                                        window.updateAddingStats = function () {
                                            // Call original function
                                            if (originalUpdateAddingStats) {
                                                originalUpdateAddingStats();
                                            }

                                            // Add course test validation
                                            if (isCourseTest) {
                                                const requiredCount = getCurrentRequiredCount();
                                                console.log('updateAddingStats - requiredCount:', requiredCount);
                                                updateQuestionCountWarning(requiredCount);
                                            }
                                        };
        </script>
    </body>
</html>