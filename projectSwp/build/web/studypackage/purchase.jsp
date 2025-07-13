<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Purchase Study Package</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
        <style>
            body {
                padding-top: 130px;
                background-color: #f8f9fa;
            }
            .purchase-container {
                max-width: 900px;
                margin: 40px auto;
                background: #ffffff;
                padding: 30px;
                border-radius: 12px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            .package-info {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 25px;
                border-radius: 12px;
                margin-bottom: 30px;
            }
            .package-info h4 {
                margin-bottom: 15px;
                font-weight: bold;
            }
            .price {
                font-size: 1.8em;
                font-weight: bold;
                color: #fff;
                text-shadow: 0 2px 4px rgba(0,0,0,0.3);
            }
            .stats-card {
                background-color: #f8f9fa;
                padding: 20px;
                border-radius: 8px;
                margin: 20px 0;
                border-left: 4px solid #007bff;
            }
            .stats-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
                gap: 15px;
                margin-top: 15px;
            }
            .stat-item {
                text-align: center;
                padding: 15px;
                background: white;
                border-radius: 8px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }
            .stat-number {
                font-size: 1.8em;
                font-weight: bold;
                color: #007bff;
            }
            .stat-label {
                font-size: 0.9em;
                color: #666;
                margin-top: 5px;
            }
            .children-section {
                margin: 30px 0;
            }
            .section-title {
                font-size: 1.2em;
                font-weight: bold;
                color: #333;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 10px;
            }
            .child-card {
                border: 2px solid #e9ecef;
                border-radius: 8px;
                padding: 20px;
                margin-bottom: 15px;
                transition: all 0.3s ease;
                cursor: pointer;
                position: relative;
            }
            .child-card:hover {
                border-color: #007bff;
                background-color: #f8f9fa;
                transform: translateY(-2px);
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            }
            .child-card.selected {
                border-color: #28a745;
                background-color: #d4edda;
            }
            .child-card.has-package {
                border-color: #dc3545;
                background-color: #f8d7da;
                opacity: 0.8;
                cursor: not-allowed;
            }
            .child-info {
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .child-details h6 {
                margin-bottom: 8px;
                color: #333;
                font-weight: bold;
            }
            .child-meta {
                font-size: 0.9em;
                color: #666;
            }
            .child-status {
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 0.8em;
                font-weight: bold;
                text-transform: uppercase;
            }
            .status-available {
                background-color: #d4edda;
                color: #155724;
            }
            .status-active {
                background-color: #cce5ff;
                color: #004085;
            }
            .status-expired {
                background-color: #f8d7da;
                color: #721c24;
            }
            .purchase-form {
                background-color: #f8f9fa;
                padding: 25px;
                border-radius: 8px;
                margin-top: 30px;
            }
            .btn-container {
                display: flex;
                gap: 15px;
                justify-content: center;
                margin-top: 30px;
            }
            .btn {
                padding: 12px 25px;
                border-radius: 6px;
                border: none;
                text-decoration: none;
                font-size: 16px;
                font-weight: 600;
                transition: all 0.3s ease;
                cursor: pointer;
            }
            .btn-success {
                background-color: #28a745;
                color: white;
            }
            .btn-success:hover:not(:disabled) {
                background-color: #218838;
                transform: translateY(-2px);
            }
            .btn:disabled {
                opacity: 0.6;
                cursor: not-allowed;
            }
            .btn-secondary {
                background-color: #6c757d;
                color: white;
            }
            .btn-secondary:hover {
                background-color: #5a6268;
            }
            .alert-custom {
                padding: 15px 20px;
                border-radius: 8px;
                margin: 20px 0;
                border: none;
            }
            .alert-info {
                background: linear-gradient(135deg, #d1ecf1 0%, #bee5eb 100%);
                color: #0c5460;
                border-left: 4px solid #17a2b8;
            }
            .alert-warning {
                background: linear-gradient(135deg, #fff3cd 0%, #ffeaa7 100%);
                color: #856404;
                border-left: 4px solid #ffc107;
            }
            .no-children {
                text-align: center;
                padding: 40px 20px;
                color: #666;
                background: #f8f9fa;
                border-radius: 8px;
                border: 2px dashed #dee2e6;
            }
            .selection-info {
                background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
                color: white;
                padding: 15px 20px;
                border-radius: 8px;
                margin: 20px 0;
                text-align: center;
                font-weight: bold;
            }
            .package-explanation {
                background-color: #e3f2fd;
                padding: 20px;
                border-radius: 8px;
                margin: 20px 0;
                border-left: 4px solid #2196f3;
            }
            .package-explanation h6 {
                color: #1976d2;
                margin-bottom: 10px;
            }
            .child-card {
                border: 2px solid #e9ecef;
                border-radius: 8px;
                padding: 20px;
                margin-bottom: 15px;
                transition: all 0.3s ease;
                cursor: pointer;
                position: relative;
                user-select: none; /* Prevent text selection when clicking */
            }

            .child-card:hover:not(.has-package) {
                border-color: #007bff;
                background-color: #f8f9fa;
                transform: translateY(-2px);
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            }

            .child-card.selected {
                border-color: #28a745;
                background-color: #d4edda;
                box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
            }

            .child-card.has-package {
                border-color: #dc3545;
                background-color: #f8d7da;
                opacity: 0.8;
                cursor: not-allowed;
            }

            .child-card input[type="radio"] {
                pointer-events: none; /* Prevent direct radio button clicks */
            }

            .child-info {
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .child-details h6 {
                margin-bottom: 8px;
                color: #333;
                font-weight: bold;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .child-meta {
                font-size: 0.9em;
                color: #666;
            }

            .child-status {
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 0.8em;
                font-weight: bold;
                text-transform: uppercase;
                white-space: nowrap;
            }

            .status-available {
                background-color: #d4edda;
                color: #155724;
            }

            .status-active {
                background-color: #cce5ff;
                color: #004085;
            }

            .status-expired {
                background-color: #f8d7da;
                color: #721c24;
            }

            /* Add visual feedback for selection */
            .child-card.selected::before {
                content: "✓";
                position: absolute;
                top: 10px;
                right: 10px;
                background-color: #28a745;
                color: white;
                border-radius: 50%;
                width: 25px;
                height: 25px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: bold;
                font-size: 14px;
            }
        </style>
    </head>
    <body>

        <%@include file="../header.jsp" %>

        <div class="purchase-container">
            <h2 class="text-center mb-4">
                <i class="fas fa-shopping-cart"></i> Purchase Study Package
            </h2>

            <!-- Package Information -->
            <div class="package-info">
                <h4><i class="fas fa-box"></i> ${studyPackage.name}</h4>
                <c:if test="${not empty studyPackage.description}">
                    <p style="margin-bottom: 15px; opacity: 0.9;">${studyPackage.description}</p>
                </c:if>
                <div style="display: flex; justify-content: space-between; align-items: center;">
                    <div>
                        <div><strong>Duration:</strong> ${studyPackage.duration_days} days per student</div>
                        <div><strong>Type:</strong> Individual Course Package</div>
                    </div>
                    <div class="price">
                        <i class="fas fa-money-bill-wave"></i> <fmt:formatNumber value="${studyPackage.price}" type="number" groupingUsed="true"/> VND
                    </div>
                </div>
            </div>

            <!-- Package Explanation -->
            <div class="package-explanation">
                <h6><i class="fas fa-info-circle"></i> How Our Package System Works</h6>
                <p><strong>One Package = One Student:</strong> Each package purchase provides access for exactly one student. 
                    If you have multiple children, you'll need to purchase separate packages for each child you want to enroll.</p>
                <p><strong>Individual Access:</strong> Each student gets their own dedicated access with full course content, 
                    progress tracking, and ${studyPackage.duration_days} days of learning time.</p>
            </div>

            <!-- Statistics -->
            <div class="stats-card">
                <h6><i class="fas fa-chart-bar"></i> Your Children & This Package</h6>
                <div class="stats-grid">
                    <div class="stat-item">
                        <div class="stat-number">${totalChildren}</div>
                        <div class="stat-label">Total Children</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">${activeAssignments}</div>
                        <div class="stat-label">Currently Enrolled</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">${availableForPurchase}</div>
                        <div class="stat-label">Available to Enroll</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">${studyPackage.duration_days}</div>
                        <div class="stat-label">Days Access</div>
                    </div>
                </div>
            </div>

            <!-- Info Messages -->
            <c:if test="${not empty infoMessage}">
                <div class="alert-custom alert-info">
                    <i class="fas fa-info-circle"></i> <strong>Current Status:</strong> ${infoMessage}
                </div>
            </c:if>

            <!-- Children with Package -->
            <c:if test="${not empty childrenWithPackage}">
                <div class="children-section">
                    <div class="section-title">
                        <i class="fas fa-users-check"></i> 
                        Children Already Enrolled (${fn:length(childrenWithPackage)} students)
                    </div>
                    <c:forEach items="${childrenWithPackage}" var="child">
                        <div class="child-card has-package">
                            <div class="child-info">
                                <div class="child-details">
                                    <h6><i class="fas fa-user"></i> ${child.full_name}</h6>
                                    <div class="child-meta">
                                        <strong>Username:</strong> ${child.username} | 
                                        <strong>Grade:</strong> ${child.grade_name}
                                        <br>
                                        <strong>Enrolled:</strong> <fmt:formatDate value="${child.purchased_at}" pattern="dd/MM/yyyy"/>
                                        | <strong>Expires:</strong> <fmt:formatDate value="${child.expires_at}" pattern="dd/MM/yyyy"/>
                                    </div>
                                </div>
                                <div class="child-status status-${fn:toLowerCase(child.status)}">
                                    ${child.status}
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>

            <!-- Available Children -->
            <c:choose>
                <c:when test="${not empty availableChildren}">
                    <div class="children-section">
                        <div class="section-title">
                            <i class="fas fa-user-plus"></i> 
                            Select Child to Enroll (${fn:length(availableChildren)} available)
                        </div>

                        <div class="alert-custom alert-warning">
                            <i class="fas fa-exclamation-triangle"></i>
                            <strong>Important:</strong> You are purchasing individual access for ONE student. 
                            The package price of <strong>${studyPackage.price} VND</strong> provides 
                            <strong>${studyPackage.duration_days} days</strong> of access for the selected student only.
                        </div>

                        <form id="purchaseForm" action="${pageContext.request.contextPath}/study_package" method="post">
                            <input type="hidden" name="service" value="assignPackage">
                            <input type="hidden" name="packageId" value="${packageId}">

                            <c:forEach items="${availableChildren}" var="child">
                                <div class="child-card" data-child-id="${child.id}" onclick="selectChild(${child.id})">
                                    <div class="child-info">
                                        <div class="child-details">
                                            <input type="radio" name="studentIds" value="${child.id}" id="child_${child.id}" 
                                                   style="margin-right: 10px; transform: scale(1.3); pointer-events: none;">
                                            <h6><i class="fas fa-user"></i> ${child.full_name}</h6>
                                            <div class="child-meta">
                                                <strong>Username:</strong> ${child.username} | 
                                                <strong>Grade:</strong> ${child.grade_name}
                                            </div>
                                        </div>
                                        <div class="child-status status-available">
                                            Available
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>

                            <div class="selection-info" id="selectionInfo" style="display: none;">
                                <i class="fas fa-check-circle"></i> 
                                <span id="selectedChildName"></span> selected for enrollment
                            </div>

                            <div class="btn-container">
                                <button type="submit" class="btn btn-success" id="purchaseBtn" disabled>
                                    <i class="fas fa-credit-card"></i> Select a Student First
                                </button>
                                <a href="${pageContext.request.contextPath}/study_package" class="btn btn-secondary">
                                    <i class="fas fa-arrow-left"></i> Back to Packages
                                </a>
                            </div>
                        </form>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="no-children">
                        <i class="fas fa-info-circle fa-3x mb-3" style="color: #dee2e6;"></i>
                        <h5>No Children Available for Enrollment</h5>
                        <c:choose>
                            <c:when test="${totalChildren == 0}">
                                <p>You haven't added any children to your account yet.</p>
                                <a href="${pageContext.request.contextPath}/student?action=create" class="btn btn-primary">
                                    <i class="fas fa-plus"></i> Add Student
                                </a>
                            </c:when>
                            <c:otherwise>
                                <p>All your children already have access to this package.</p>
                                <a href="${pageContext.request.contextPath}/study_package?service=myPackagesDetailed" class="btn btn-primary">
                                    <i class="fas fa-cog"></i> Manage My Packages
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <%@include file="../footer.jsp" %>

        <script src="${pageContext.request.contextPath}/assets/js/vendor/jquery-1.12.4.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>

        <script>
                                    let selectedChildId = null;
                                    let selectedChildName = null;

                                    function selectChild(childId) {
                                        // Remove previous selection
                                        document.querySelectorAll('.child-card').forEach(card => {
                                            card.classList.remove('selected');
                                        });
                                        document.querySelectorAll('input[name="studentIds"]').forEach(radio => {
                                            radio.checked = false;
                                        });

                                        // Select current child
                                        const card = document.querySelector('[data-child-id="' + childId + '"]');
                                        const radio = document.getElementById('child_' + childId);

                                        if (card && radio) {
                                            card.classList.add('selected');
                                            radio.checked = true;

                                            selectedChildId = childId;
                                            // Get child name from the h6 element inside the card
                                            const nameElement = card.querySelector('.child-details h6');
                                            if (nameElement) {
                                                selectedChildName = nameElement.textContent.replace(/^\s*[^\s]+\s*/, '').trim(); // Remove icon
                                            }

                                            updateUI();
                                        }
                                    }

                                    function updateUI() {
                                        const purchaseBtn = document.getElementById('purchaseBtn');
                                        const selectionInfo = document.getElementById('selectionInfo');
                                        const selectedChildNameSpan = document.getElementById('selectedChildName');

                                        if (selectedChildId && selectedChildName) {
                                            // Format price using JavaScript
                                            const price = '${studyPackage.price}';
                                            const formattedPrice = parseInt(price).toLocaleString();

                                            // Update button
                                            purchaseBtn.disabled = false;
                                            purchaseBtn.innerHTML = '<i class="fas fa-credit-card"></i> Purchase Package for ' + selectedChildName + ' - ' + formattedPrice + ' VND';

                                            // Show selection info
                                            selectedChildNameSpan.textContent = selectedChildName;
                                            selectionInfo.style.display = 'block';
                                        } else {
                                            // Reset button
                                            purchaseBtn.disabled = true;
                                            purchaseBtn.innerHTML = '<i class="fas fa-credit-card"></i> Select a Student First';

                                            // Hide selection info
                                            selectionInfo.style.display = 'none';
                                        }
                                    }

                                    // Form submission confirmation
                                    document.addEventListener('DOMContentLoaded', function () {
                                        const form = document.getElementById('purchaseForm');
                                        if (form) {
                                            form.addEventListener('submit', function (e) {
                                                if (!selectedChildId) {
                                                    e.preventDefault();
                                                    alert('Please select a student to enroll in this package.');
                                                    return false;
                                                }

                                                const price = '${studyPackage.price}';
                                                const formattedPrice = parseInt(price).toLocaleString();

                                                const confirmMessage = 'Purchase Confirmation:\n\n' +
                                                        'Package: ${studyPackage.name}\n' +
                                                        'Student: ' + selectedChildName + '\n' +
                                                        'Duration: ${studyPackage.duration_days} days\n' +
                                                        'Price: ' + formattedPrice + ' VND\n\n' +
                                                        'This will provide individual access for ' + selectedChildName + ' only.\n\n' +
                                                        'Do you want to proceed with the purchase?';

                                                if (!confirm(confirmMessage)) {
                                                    e.preventDefault();
                                                    return false;
                                                }
                                            });
                                        }

                                        // Add click event listeners to all child cards
                                        document.querySelectorAll('.child-card:not(.has-package)').forEach(card => {
                                            const childId = card.getAttribute('data-child-id');
                                            if (childId) {
                                                card.addEventListener('click', function () {
                                                    selectChild(parseInt(childId));
                                                });

                                                // Add visual feedback on hover
                                                card.style.cursor = 'pointer';
                                            }
                                        });

                                        // Debug logging
                                        console.log('Purchase page loaded');
                                        console.log('Available children: ${fn:length(availableChildren)}');
                                        console.log('Children with package: ${fn:length(childrenWithPackage)}');

                                        // Log available child cards
                                        const childCards = document.querySelectorAll('.child-card:not(.has-package)');
                                        console.log('Found child cards:', childCards.length);
                                        childCards.forEach((card, index) => {
                                            console.log('Card ' + index + ':', card.getAttribute('data-child-id'));
                                        });
                                    });
        </script>
    </body>
</html>
