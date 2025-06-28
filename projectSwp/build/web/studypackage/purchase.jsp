<%-- 
    Document   : purchase
    Created on : Jun 29, 2025, 3:21:36 AM
    Author     : ankha
--%>

<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
            }
            .student-card:hover {
                border-color: #007bff;
                background-color: #f8f9fa;
            }
            .student-card.selected {
                border-color: #28a745;
                background-color: #d4edda;
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
                <p><strong>Maximum Students:</strong> ${studyPackage.max_students}</p>
                <p><strong>Price:</strong> <span class="price">${studyPackage.price} VND</span></p>
            </div>

            <c:if test="${not empty children}">
                <div class="student-selection">
                    <h5>Select Students for This Package:</h5>
                    <div class="warning-text">
                        <i class="fas fa-info-circle"></i>
                        <strong>Important:</strong> You can assign up to ${studyPackage.max_students} student(s) to this package. 
                        Each assignment will last for ${studyPackage.duration_days} days from the purchase date.
                    </div>

                    <form id="purchaseForm" action="${pageContext.request.contextPath}/payment" method="post">
                        <input type="hidden" name="packageId" value="${packageId}">
                        <input type="hidden" name="amount" value="${amount}">

                        <c:forEach items="${children}" var="child">
                            <div class="student-card" onclick="toggleStudent(${child.id})">
                                <input type="checkbox" name="studentIds" value="${child.id}" id="student_${child.id}">
                                <label for="student_${child.id}" style="cursor: pointer; margin: 0;">
                                    <strong>${child.full_name}</strong>
                                    <br>
                                    <small class="text-muted">
                                        Username: ${child.username} | 
                                        Grade: <c:forEach items="${gradeList}" var="grade">
                                            <c:if test="${grade.id == child.grade_id}">${grade.name}</c:if>
                                        </c:forEach>
                                    </small>
                                </label>
                            </div>
                        </c:forEach>

                        <div class="btn-container">
                            <button type="submit" class="btn btn-success" id="purchaseBtn" disabled>
                                <i class="fas fa-credit-card"></i> Proceed to Payment
                            </button>
                            <a href="${pageContext.request.contextPath}/study_package" class="btn btn-secondary">
                                <i class="fas fa-arrow-left"></i> Back to Packages
                            </a>
                        </div>
                    </form>
                </div>
            </c:if>

            <c:if test="${empty children}">
                <div class="warning-text text-center">
                    <h5>No Students Found</h5>
                    <p>You need to add students to your account before purchasing study packages.</p>
                    <a href="${pageContext.request.contextPath}/student?action=create" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Add Student
                    </a>
                </div>
            </c:if>
        </div>

        <%@include file="../footer.jsp" %>

        <script src="${pageContext.request.contextPath}/assets/js/vendor/jquery-1.12.4.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>
        <script>
                        let maxStudents = ${studyPackage.max_students};
                        let selectedCount = 0;

                        function toggleStudent(studentId) {
                            const checkbox = document.getElementById('student_' + studentId);
                            const card = checkbox.closest('.student-card');

                            if (checkbox.checked) {
                                if (selectedCount >= maxStudents) {
                                    alert('You can only select up to ' + maxStudents + ' student(s) for this package.');
                                    return;
                                }
                                checkbox.checked = false;
                                card.classList.remove('selected');
                                selectedCount--;
                            } else {
                                if (selectedCount >= maxStudents) {
                                    alert('You can only select up to ' + maxStudents + ' student(s) for this package.');
                                    return;
                                }
                                checkbox.checked = true;
                                card.classList.add('selected');
                                selectedCount++;
                            }

                            updatePurchaseButton();
                        }

                        function updatePurchaseButton() {
                            const purchaseBtn = document.getElementById('purchaseBtn');
                            if (selectedCount > 0) {
                                purchaseBtn.disabled = false;
                                purchaseBtn.innerHTML = '<i class="fas fa-credit-card"></i> Purchase for ' + selectedCount + ' Student(s)';
                            } else {
                                purchaseBtn.disabled = true;
                                purchaseBtn.innerHTML = '<i class="fas fa-credit-card"></i> Select Students First';
                            }
                        }

                        // Form validation
                        document.getElementById('purchaseForm').addEventListener('submit', function (e) {
                            if (selectedCount === 0) {
                                e.preventDefault();
                                alert('Please select at least one student for this package.');
                                return false;
                            }

                            if (!confirm('Are you sure you want to purchase this package for ' + selectedCount + ' student(s)?')) {
                                e.preventDefault();
                                return false;
                            }
                        });

                        // Initialize checkboxes
                        document.addEventListener('DOMContentLoaded', function () {
                            const checkboxes = document.querySelectorAll('input[name="studentIds"]');
                            checkboxes.forEach(function (checkbox) {
                                checkbox.addEventListener('change', function () {
                                    // This ensures the checkbox state is properly managed
                                    updatePurchaseButton();
                                });
                            });
                        });
        </script>

    </body>
</html>
