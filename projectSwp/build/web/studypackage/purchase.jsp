<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
                max-width: 800px;
                margin: 40px auto;
                background: #ffffff;
                padding: 30px;
                border-radius: 12px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            .package-info {
                background-color: #f8f9fa;
                padding: 20px;
                border-radius: 8px;
                margin-bottom: 25px;
                border-left: 4px solid #007bff;
            }
            .package-info h4 {
                color: #007bff;
                margin-bottom: 15px;
            }
            .price {
                font-size: 1.5em;
                font-weight: bold;
                color: #28a745;
            }
            .package-stats {
                background-color: #e3f2fd;
                padding: 15px;
                border-radius: 8px;
                margin: 20px 0;
                border-left: 4px solid #2196f3;
            }
            .stats-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
                gap: 15px;
                margin-top: 10px;
            }
            .stat-item {
                text-align: center;
                padding: 10px;
                background: white;
                border-radius: 6px;
            }
            .stat-number {
                font-size: 1.5em;
                font-weight: bold;
                color: #1976d2;
            }
            .stat-label {
                font-size: 0.9em;
                color: #666;
            }
            .student-selection {
                margin: 25px 0;
            }
            .student-card {
                border: 2px solid #e9ecef;
                border-radius: 8px;
                padding: 15px;
                margin-bottom: 15px;
                transition: all 0.3s ease;
                cursor: pointer;
                position: relative;
            }
            .student-card:hover {
                border-color: #007bff;
                background-color: #f8f9fa;
            }
            .student-card.selected {
                border-color: #28a745;
                background-color: #d4edda;
            }
            .student-card.unavailable {
                border-color: #dc3545;
                background-color: #f8d7da;
                opacity: 0.7;
                cursor: not-allowed;
            }
            .student-card input[type="checkbox"] {
                margin-right: 10px;
                transform: scale(1.2);
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
                transition: all 0.3s ease;
                cursor: pointer;
            }
            .btn-success {
                background-color: #28a745;
                color: white;
            }
            .btn-success:hover {
                background-color: #218838;
            }
            .btn-secondary {
                background-color: #6c757d;
                color: white;
            }
            .btn-secondary:hover {
                background-color: #5a6268;
            }
            .warning-text {
                color: #856404;
                background-color: #fff3cd;
                border: 1px solid #ffeaa7;
                padding: 15px;
                border-radius: 6px;
                margin: 20px 0;
            }
            .unavailable-notice {
                color: #721c24;
                background-color: #f8d7da;
                border: 1px solid #f5c6cb;
                padding: 15px;
                border-radius: 6px;
                margin: 20px 0;
            }
            .student-status {
                position: absolute;
                top: 10px;
                right: 15px;
                padding: 4px 8px;
                border-radius: 12px;
                font-size: 0.8em;
                font-weight: bold;
            }
            .status-available {
                background-color: #d4edda;
                color: #155724;
            }
            .status-unavailable {
                background-color: #f8d7da;
                color: #721c24;
            }
            .selection-counter {
                background-color: #17a2b8;
                color: white;
                padding: 10px 15px;
                border-radius: 6px;
                margin: 15px 0;
                text-align: center;
                font-weight: bold;
            }
        </style>
    </head>
    <body>

        <%@include file="../header.jsp" %>

        <div class="purchase-container">
            <h2 class="text-center mb-4">Purchase Study Package</h2>

            <div class="package-info">
                <h4>${studyPackage.name}</h4>
                <p><strong>Type:</strong> 
                    <c:choose>
                        <c:when test="${studyPackage.type == 'GRADE_ALL'}">All Subjects in Grade</c:when>
                        <c:otherwise>Subject Combo</c:otherwise>
                    </c:choose>
                </p>
                <c:if test="${not empty studyPackage.description}">
                    <p><strong>Description:</strong> ${studyPackage.description}</p>
                </c:if>
                <p><strong>Duration:</strong> ${studyPackage.duration_days} days</p>
                <p><strong>Price:</strong> <span class="price">${studyPackage.price} VND</span></p>
            </div>

            <!-- Package Statistics -->
            <div class="package-stats">
                <h6><i class="fas fa-chart-bar"></i> Package Availability</h6>
                <div class="stats-grid">
                    <div class="stat-item">
                        <div class="stat-number">${studyPackage.max_students}</div>
                        <div class="stat-label">Total Capacity</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">${currentAssignedCount}</div>
                        <div class="stat-label">Currently Assigned</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number" style="color: #28a745;">${availableSlots}</div>
                        <div class="stat-label">Available Slots</div>
                    </div>
                </div>
            </div>

            <c:choose>
                <c:when test="${not empty children || not empty unavailableChildren}">
                    <div class="student-selection">
                        <h5>Select Students for This Package:</h5>

                        <div class="warning-text">
                            <i class="fas fa-info-circle"></i>
                            <strong>Important:</strong> This package has <strong>${availableSlots}</strong> available slot(s) remaining. 
                            You can select up to <strong>${availableSlots}</strong> of your students for this purchase.
                            Each assignment will last for ${studyPackage.duration_days} days from the purchase date.
                        </div>

                        <c:if test="${not empty unavailableChildren}">
                            <div class="unavailable-notice">
                                <i class="fas fa-exclamation-triangle"></i>
                                <strong>Note:</strong> Some students already have this package and cannot be selected again.
                            </div>
                        </c:if>

                        <form id="purchaseForm" action="${pageContext.request.contextPath}/payment" method="post">
                            <input type="hidden" name="packageId" value="${packageId}">
                            <input type="hidden" name="amount" value="${amount}">

                            <!-- Selection Counter -->
                            <div class="selection-counter" id="selectionCounter">
                                <i class="fas fa-users"></i> Selected: <span id="selectedCount">0</span> / ${availableSlots} students
                            </div>

                            <!-- Available Students -->
                            <c:if test="${not empty children}">
                                <h6 class="mt-4 mb-3">Available Students (${fn:length(children)} students):</h6>
                                <c:forEach items="${children}" var="child">
                                    <div class="student-card" data-student-id="${child.id}" onclick="toggleStudent(${child.id})" style="cursor: pointer;">
                                        <span class="student-status status-available">Available</span>
                                        <div style="width: calc(100% - 100px);">
                                            <input type="checkbox" name="studentIds" value="${child.id}" id="student_${child.id}" style="margin-right: 10px; transform: scale(1.2); pointer-events: none;">
                                            <strong>${child.full_name}</strong>
                                            <br>
                                            <small class="text-muted">
                                                Username: ${child.username} | 
                                                Grade: <c:forEach items="${gradeList}" var="grade">
                                                    <c:if test="${grade.id == child.grade_id}">${grade.name}</c:if>
                                                </c:forEach>
                                            </small>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:if>

                            <!-- Unavailable Students -->
                            <c:if test="${not empty unavailableChildren}">
                                <h6 class="mt-4 mb-3">Students Already Have This Package (${fn:length(unavailableChildren)} students):</h6>
                                <c:forEach items="${unavailableChildren}" var="child">
                                    <div class="student-card unavailable">
                                        <span class="student-status status-unavailable">Already Assigned</span>
                                        <div style="margin-left: 30px;">
                                            <strong>${child.full_name}</strong>
                                            <br>
                                            <small class="text-muted">
                                                Username: ${child.username} | 
                                                Grade: <c:forEach items="${gradeList}" var="grade">
                                                    <c:if test="${grade.id == child.grade_id}">${grade.name}</c:if>
                                                </c:forEach>
                                                <br><em>This student already has an active subscription to this package.</em>
                                            </small>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:if>

                            <c:if test="${not empty children}">
                                <div class="btn-container">
                                    <button type="submit" class="btn btn-success" id="purchaseBtn" disabled>
                                        <i class="fas fa-credit-card"></i> Select Students First
                                    </button>
                                    <a href="${pageContext.request.contextPath}/study_package" class="btn btn-secondary">
                                        <i class="fas fa-arrow-left"></i> Back to Packages
                                    </a>
                                </div>
                            </c:if>
                        </form>

                        <c:if test="${empty children}">
                            <div class="warning-text text-center">
                                <h6>No Available Students</h6>
                                <p>All your students already have this package or you have no students to assign.</p>
                                <a href="${pageContext.request.contextPath}/study_package" class="btn btn-primary">
                                    <i class="fas fa-arrow-left"></i> Back to Packages
                                </a>
                            </div>
                        </c:if>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="warning-text text-center">
                        <h5>No Students Found</h5>
                        <p>You need to add students to your account before purchasing study packages.</p>
                        <a href="${pageContext.request.contextPath}/student?action=create" class="btn btn-primary">
                            <i class="fas fa-plus"></i> Add Student
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <%@include file="../footer.jsp" %>

        <script src="${pageContext.request.contextPath}/assets/js/vendor/jquery-1.12.4.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>
        <script>
            // Package capacity limits
            const maxAvailableSlots = ${availableSlots};
            const packagePrice = ${amount};

            // Current selection state - dùng Set để tránh duplicate
            let selectedStudents = new Set();

            console.log('Package Info:', {
                maxAvailableSlots: maxAvailableSlots,
                packagePrice: packagePrice
            });

            function toggleStudent(studentId) {
                console.log('toggleStudent called with ID:', studentId);

                const card = document.querySelector('[data-student-id="' + studentId + '"]');
                const checkbox = document.getElementById('student_' + studentId);

                if (!card || !checkbox) {
                    console.error('Card or checkbox not found for student:', studentId);
                    return;
                }

                // Check if card is unavailable
                if (card.classList.contains('unavailable')) {
                    console.log('Student unavailable, skipping');
                    return;
                }

                // Simple toggle logic based on current visual state
                if (card.classList.contains('selected')) {
                    // Currently selected -> deselect
                    console.log('Deselecting student:', studentId);
                    selectedStudents.delete(studentId);
                    card.classList.remove('selected');
                    checkbox.checked = false;
                } else {
                    // Currently not selected -> try to select
                    if (selectedStudents.size >= maxAvailableSlots) {
                        alert('This package only has ' + maxAvailableSlots + ' available slot(s) remaining.\n' +
                                'You cannot select more than ' + maxAvailableSlots + ' student(s).');
                        return;
                    }

                    console.log('Selecting student:', studentId);
                    selectedStudents.add(studentId);
                    card.classList.add('selected');
                    checkbox.checked = true;
                }

                console.log('Current selection:', {
                    selectedCount: selectedStudents.size,
                    selectedStudents: Array.from(selectedStudents)
                });

                updateUI();
            }

            function updateUI() {
                const selectedCount = selectedStudents.size;
                console.log('Updating UI with selectedCount:', selectedCount);

                // Update selection counter
                const counterElement = document.getElementById('selectedCount');
                if (counterElement) {
                    counterElement.textContent = selectedCount;
                }

                // Update counter color based on selection
                const selectionCounter = document.getElementById('selectionCounter');
                if (selectionCounter) {
                    if (selectedCount === 0) {
                        selectionCounter.style.backgroundColor = '#6c757d';
                    } else if (selectedCount === maxAvailableSlots) {
                        selectionCounter.style.backgroundColor = '#dc3545';
                    } else {
                        selectionCounter.style.backgroundColor = '#17a2b8';
                    }
                }

                // Update purchase button
                updatePurchaseButton();
            }

            function updatePurchaseButton() {
                const selectedCount = selectedStudents.size;
                const purchaseBtn = document.getElementById('purchaseBtn');
                if (!purchaseBtn)
                    return;

                if (selectedCount > 0) {
                    purchaseBtn.disabled = false;
                    const totalCost = packagePrice * selectedCount;
                    purchaseBtn.innerHTML = '<i class="fas fa-credit-card"></i> Purchase for ' + selectedCount + ' Student(s) - ' + totalCost.toLocaleString() + ' VND';
                    purchaseBtn.className = 'btn btn-success';
                } else {
                    purchaseBtn.disabled = true;
                    purchaseBtn.innerHTML = '<i class="fas fa-credit-card"></i> Select Students First';
                    purchaseBtn.className = 'btn btn-secondary';
                }
            }

            // Initialize when page loads
            document.addEventListener('DOMContentLoaded', function () {
                console.log('DOM Content Loaded - Initializing...');

                // RESET selection state
                selectedStudents.clear();

                // Clear any pre-selected checkboxes and visual states
                const checkboxes = document.querySelectorAll('input[name="studentIds"]');
                checkboxes.forEach(function (checkbox) {
                    checkbox.checked = false;
                    const card = document.querySelector('[data-student-id="' + checkbox.value + '"]');
                    if (card) {
                        card.classList.remove('selected');
                    }
                });

                // Initialize UI
                updateUI();

                // Form validation
                const form = document.getElementById('purchaseForm');
                if (form) {
                    form.addEventListener('submit', function (e) {
                        const selectedCount = selectedStudents.size;
                        console.log('Form submit - selectedCount:', selectedCount);

                        if (selectedCount === 0) {
                            e.preventDefault();
                            alert('Please select at least one student for this package.');
                            return false;
                        }

                        const totalCost = packagePrice * selectedCount;
                        const confirmMessage = 'Purchase Confirmation:\n\n' +
                                'Package: ${studyPackage.name}\n' +
                                'Students: ' + selectedCount + ' student(s)\n' +
                                'Duration: ${studyPackage.duration_days} days each\n' +
                                'Total Cost: ' + totalCost.toLocaleString() + ' VND\n\n' +
                                'Do you want to proceed with the payment?';

                        if (!confirm(confirmMessage)) {
                            e.preventDefault();
                            return false;
                        }
                    });
                }
            });

            // Debug: Show package capacity info
            console.log('=== Package Capacity Info ===');
            console.log('Total Capacity: ${studyPackage.max_students} students');
            console.log('Currently Assigned: ${currentAssignedCount} students');
            console.log('Available Slots:', maxAvailableSlots, 'students');
            console.log('Your Available Children: ${fn:length(children)} students');
            console.log('============================');
        </script>
    </body>
</html>