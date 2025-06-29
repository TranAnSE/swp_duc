<%-- 
    Document   : assignToParent
    Created on : Jun 29, 2025, 5:21:08 AM
    Author     : ankha
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Assign Study Package to Parent</title>

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <!-- Select2 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
        <link href="https://cdn.jsdelivr.net/npm/select2-bootstrap-5-theme@1.3.0/dist/select2-bootstrap-5-theme.min.css" rel="stylesheet" />

        <style>
            body {
                background-color: #f8f9fa;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            .assign-container {
                max-width: 1000px;
                margin: 40px auto;
                background: white;
                padding: 40px;
                border-radius: 15px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            }

            .form-group {
                margin-bottom: 25px;
            }

            .form-label {
                font-weight: 600;
                color: #495057;
                margin-bottom: 10px;
            }

            .package-info {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 20px;
                border-radius: 10px;
                margin: 20px 0;
            }

            .package-info h6 {
                color: #fff;
                font-weight: 600;
                margin-bottom: 15px;
            }

            .package-info p {
                margin-bottom: 8px;
                color: #f8f9fa;
            }

            .student-card {
                border: 2px solid #e9ecef;
                border-radius: 10px;
                padding: 20px;
                margin-bottom: 15px;
                transition: all 0.3s ease;
                cursor: pointer;
                background: white;
            }

            .student-card:hover {
                border-color: #007bff;
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(0,123,255,0.2);
            }

            .student-card.selected {
                border-color: #28a745;
                background-color: #d4edda;
                box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, 0.25);
            }

            .student-card.selected::before {
                content: '✓';
                position: absolute;
                top: 15px;
                right: 20px;
                background-color: #28a745;
                color: white;
                border-radius: 50%;
                width: 30px;
                height: 30px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: bold;
                font-size: 16px;
            }

            .student-info h6 {
                color: #495057;
                font-weight: 600;
                margin-bottom: 5px;
            }

            .student-info p {
                color: #6c757d;
                margin-bottom: 5px;
                font-size: 14px;
            }

            .btn-container {
                text-align: center;
                margin-top: 30px;
                padding-top: 20px;
                border-top: 1px solid #e9ecef;
            }

            .btn {
                padding: 12px 30px;
                border-radius: 8px;
                font-weight: 600;
                margin: 0 10px;
                transition: all 0.3s ease;
            }

            .btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            }

            .alert {
                border-radius: 10px;
                padding: 15px 20px;
            }

            /* Select2 custom styling */
            .select2-container--bootstrap-5 .select2-selection {
                min-height: 48px;
                border-radius: 8px;
                border: 2px solid #e9ecef;
            }

            .select2-container--bootstrap-5 .select2-selection--single .select2-selection__rendered {
                line-height: 44px;
                padding-left: 15px;
            }

            .select2-container--bootstrap-5 .select2-selection--single .select2-selection__arrow {
                height: 44px;
                right: 15px;
            }

            .select2-dropdown {
                border-radius: 8px;
                border: 2px solid #e9ecef;
            }

            .students-container {
                display: none;
                margin-top: 25px;
            }

            .students-container.show {
                display: block;
            }

            .loading {
                text-align: center;
                padding: 20px;
                color: #6c757d;
            }

            .no-students {
                text-align: center;
                padding: 30px;
                color: #6c757d;
                background: #f8f9fa;
                border-radius: 10px;
            }
            /* Completely disable nice-select */
            .nice-select {
                display: none !important;
                visibility: hidden !important;
            }

            /* Ensure select elements are always visible */
            select {
                display: block !important;
                visibility: visible !important;
            }

            /* Override any nice-select styling */
            select[style*="display: none"] {
                display: block !important;
            }
            .students-container {
                display: none;
                margin-top: 25px;
                padding: 20px;
                background-color: #f8f9fa;
                border-radius: 10px;
                border: 1px solid #dee2e6;
            }

            .students-container.show {
                display: block;
                animation: fadeIn 0.3s ease-in;
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

            .student-card {
                border: 2px solid #e9ecef;
                border-radius: 10px;
                padding: 20px;
                margin-bottom: 15px;
                transition: all 0.3s ease;
                cursor: pointer;
                background: white;
                position: relative;
            }

            .student-card:hover {
                border-color: #007bff;
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(0,123,255,0.2);
            }

            .student-card.selected {
                border-color: #28a745;
                background-color: #d4edda;
                box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, 0.25);
            }

            .student-card.selected::before {
                content: '✓';
                position: absolute;
                top: 15px;
                right: 20px;
                background-color: #28a745;
                color: white;
                border-radius: 50%;
                width: 30px;
                height: 30px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: bold;
                font-size: 16px;
            }

            .student-info h6 {
                color: #495057;
                font-weight: 600;
                margin-bottom: 5px;
            }

            .student-info p {
                color: #6c757d;
                margin-bottom: 5px;
                font-size: 14px;
            }

            .no-students {
                text-align: center;
                padding: 30px;
                color: #6c757d;
                background: #f8f9fa;
                border-radius: 10px;
            }

            .loading {
                text-align: center;
                padding: 20px;
                color: #6c757d;
            }

            /* Button styling improvements */
            .btn:disabled {
                opacity: 0.6;
                cursor: not-allowed;
            }

            .btn-container {
                text-align: center;
                margin-top: 30px;
                padding-top: 20px;
                border-top: 1px solid #e9ecef;
            }
            .student-card.unavailable {
                border-color: #dc3545;
                background-color: #f8d7da;
                opacity: 0.7;
                cursor: not-allowed;
            }

            .student-card.unavailable .student-info h6 {
                color: #721c24;
            }

            .student-card.unavailable .student-info p {
                color: #856404;
            }

            .badge {
                padding: 4px 8px;
                border-radius: 12px;
                font-size: 0.8em;
                font-weight: bold;
            }

            .badge-success {
                background-color: #d4edda;
                color: #155724;
            }

            .badge-danger {
                background-color: #f8d7da;
                color: #721c24;
            }

            .alert {
                margin: 15px 0;
                padding: 12px 15px;
                border-radius: 8px;
                border: 1px solid transparent;
            }

            .alert-info {
                color: #0c5460;
                background-color: #d1ecf1;
                border-color: #bee5eb;
            }

            .alert-warning {
                color: #856404;
                background-color: #fff3cd;
                border-color: #ffeaa7;
            }

            .text-success {
                color: #28a745 !important;
            }

            .text-danger {
                color: #dc3545 !important;
            }
        </style>
    </head>
    <body>
        <div class="assign-container">
            <h2 class="text-center mb-4">
                <i class="fas fa-user-plus text-primary"></i>
                Assign Study Package to Parent
            </h2>

            <c:if test="${not empty message}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle"></i> ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle"></i> ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <form id="assignForm" action="study_package" method="post">
                <input type="hidden" name="service" value="assignToParent">

                <!-- Package Selection -->
                <div class="form-group">
                    <label for="packageId" class="form-label">
                        <i class="fas fa-box text-primary"></i> Select Study Package *
                    </label>
                    <select id="packageId" name="packageId" class="form-select" required>
                        <option value="">-- Select Package --</option>
                        <c:forEach var="pkg" items="${packages}">
                            <option value="${pkg.id}" 
                                    data-name="${pkg.name}" 
                                    data-type="${pkg.type}" 
                                    data-price="${pkg.price}" 
                                    data-max="${pkg.max_students}" 
                                    data-duration="${pkg.duration_days}">
                                ${pkg.name} - <fmt:formatNumber value="${pkg.price}" type="currency" currencySymbol="" pattern="#,###"/> VND
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Package Info -->
                <div id="packageInfo" class="package-info" style="display: none;">
                    <h6><i class="fas fa-info-circle"></i> Package Information:</h6>
                    <div id="packageDetails">
                        <p><strong>Name:</strong> <span id="pkgName">-</span></p>
                        <p><strong>Type:</strong> <span id="pkgType">-</span></p>
                        <p><strong>Price:</strong> <span id="pkgPrice">-</span> VND</p>
                        <p><strong>Max Students Per Parent:</strong> <span id="pkgMax">-</span></p>
                        <p><strong>Duration:</strong> <span id="pkgDuration">-</span> days</p>
                    </div>
                    <div id="parentSpecificInfo" style="display: none;">
                        <hr>
                        <h6><i class="fas fa-user-check"></i> Parent Assignment Status:</h6>
                        <div id="parentStats">
                            <!-- Will be populated by JavaScript -->
                        </div>
                    </div>
                </div>

                <!-- Parent Selection -->
                <div class="form-group">
                    <label for="parentId" class="form-label">
                        <i class="fas fa-user text-success"></i> Select Parent *
                    </label>
                    <select id="parentId" name="parentId" class="form-select" required>
                        <option value="">-- Select Parent --</option>
                        <c:forEach var="parent" items="${parents}">
                            <option value="${parent.id}">${parent.full_name} (${parent.email})</option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Students Container -->
                <div id="studentsContainer" class="students-container">
                    <h5><i class="fas fa-users text-info"></i> Select Students:</h5>
                    <div id="studentsList">
                        <div class="loading">
                            <i class="fas fa-spinner fa-spin"></i> Loading students...
                        </div>
                    </div>
                </div>

                <div id="assignmentHistory" style="display: none;" class="section-card">
                    <h5><i class="fas fa-history text-info"></i> Recent Assignments for Selected Parent</h5>
                    <div id="historyContent">
                        <!-- Will be populated by JavaScript -->
                    </div>
                </div>

                <!-- Submit Buttons -->
                <div class="btn-container">
                    <button type="submit" class="btn btn-success" id="assignBtn" disabled>
                        <i class="fas fa-user-plus"></i> Assign Package
                    </button>
                    <a href="study_package?service=manageAssignments" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to Assignments
                    </a>
                </div>
            </form>
        </div>

        <!-- jQuery -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        <!-- Select2 JS -->
        <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

        <script>
            let selectedStudents = [];
            let maxStudents = 0;
            let currentPackageId = null;
            let currentParentId = null;
            let parentPackageStats = null;

            $(document).ready(function () {
                // Initialize Select2 for all select elements
                $('#packageId').select2({
                    theme: 'bootstrap-5',
                    placeholder: '-- Select Package --',
                    allowClear: true
                });

                $('#parentId').select2({
                    theme: 'bootstrap-5',
                    placeholder: '-- Select Parent --',
                    allowClear: true
                });

                // Package selection handler
                $('#packageId').on('change', function () {
                    currentPackageId = $(this).val();
                    showPackageInfo();
                    resetStudentSelection();
                    hideStudentsContainer();

                    // If both package and parent are selected, reload students
                    if (currentPackageId && currentParentId) {
                        loadStudents();
                    }
                });

                // Parent selection handler
                $('#parentId').on('change', function () {
                    currentParentId = $(this).val();
                    resetStudentSelection();

                    if (currentParentId) {
                        loadAssignmentHistory(currentParentId);
                    } else {
                        document.getElementById('assignmentHistory').style.display = 'none';
                    }

                    // If both package and parent are selected, load students
                    if (currentPackageId && currentParentId) {
                        loadStudents();
                    } else {
                        hideStudentsContainer();
                    }
                });

                // Form validation
                $('#assignForm').on('submit', function (e) {
                    if (!validateForm()) {
                        e.preventDefault();
                        return false;
                    }

                    var confirmMessage = 'Are you sure you want to assign "' + $('#pkgName').text() +
                            '" to ' + selectedStudents.length + ' student(s) of parent "' +
                            $('#parentId option:selected').text() + '"?\n\n' +
                            'This will create an invoice and immediately activate the package for the selected students.';
                    if (!confirm(confirmMessage)) {
                        e.preventDefault();
                        return false;
                    }
                });
            });

            function showPackageInfo() {
                const select = document.getElementById('packageId');
                const selectedOption = select.options[select.selectedIndex];

                if (selectedOption && selectedOption.value) {
                    const name = selectedOption.getAttribute('data-name');
                    const type = selectedOption.getAttribute('data-type');
                    const price = selectedOption.getAttribute('data-price');
                    const max = selectedOption.getAttribute('data-max');
                    const duration = selectedOption.getAttribute('data-duration');

                    document.getElementById('pkgName').textContent = name || '-';
                    document.getElementById('pkgType').textContent = type || '-';
                    document.getElementById('pkgPrice').textContent = price ? new Intl.NumberFormat().format(price) : '-';
                    document.getElementById('pkgMax').textContent = max || '-';
                    document.getElementById('pkgDuration').textContent = duration || '-';

                    maxStudents = parseInt(max) || 0;
                    document.getElementById('packageInfo').style.display = 'block';
                } else {
                    document.getElementById('packageInfo').style.display = 'none';
                    maxStudents = 0;
                }

                updateAssignButton();
            }

            function hideStudentsContainer() {
                const studentsContainer = document.getElementById('studentsContainer');
                studentsContainer.classList.remove('show');
                updateAssignButton();
            }

            function loadStudents() {
                if (!currentParentId || !currentPackageId) {
                    hideStudentsContainer();
                    return;
                }

                const studentsContainer = document.getElementById('studentsContainer');
                const studentsList = document.getElementById('studentsList');

                // Show loading
                studentsList.innerHTML = '<div class="loading"><i class="fas fa-spinner fa-spin"></i> Loading students and checking package assignments...</div>';
                studentsContainer.classList.add('show');

                // AJAX call to get students with package status
                $.ajax({
                    url: 'study_package',
                    method: 'GET',
                    data: {
                        service: 'getStudentsByParent',
                        parentId: currentParentId,
                        packageId: currentPackageId
                    },
                    success: function (students) {
                        console.log('DEBUG: Received students data:', students);
                        try {
                            // Parse JSON if it's a string
                            if (typeof students === 'string') {
                                students = JSON.parse(students);
                            }
                            displayStudents(students);

                            // Also load parent's package statistics
                            loadParentPackageStats();
                        } catch (parseError) {
                            console.error('JSON Parse Error:', parseError);
                            console.error('Raw response:', students);
                            studentsList.innerHTML = '<div class="alert alert-danger">Error parsing student data. Please check the server response.</div>';
                            updateAssignButton();
                        }
                    },
                    error: function (xhr, status, error) {
                        console.error('AJAX Error:', error);
                        console.error('Status:', status);
                        console.error('Response:', xhr.responseText);
                        studentsList.innerHTML = '<div class="alert alert-danger">Error loading students: ' + error + '</div>';
                        updateAssignButton();
                    }
                });
            }

            function loadParentPackageStats() {
                if (!currentParentId || !currentPackageId)
                    return;

                $.ajax({
                    url: 'study_package',
                    method: 'GET',
                    data: {
                        service: 'getParentPackageStats',
                        parentId: currentParentId,
                        packageId: currentPackageId
                    },
                    success: function (stats) {
                        try {
                            if (typeof stats === 'string') {
                                stats = JSON.parse(stats);
                            }
                            parentPackageStats = stats;
                            updatePackageStatsDisplay();
                        } catch (parseError) {
                            console.error('Error parsing parent package stats:', parseError);
                        }
                    },
                    error: function (xhr, status, error) {
                        console.error('Error loading parent package stats:', error);
                    }
                });
            }

            function updatePackageStatsDisplay() {
                if (!parentPackageStats)
                    return;

                // Update package info with parent-specific stats
                const packageInfo = document.getElementById('packageInfo');
                let statsHtml = '<h6><i class="fas fa-info-circle"></i> Package Information:</h6>';
                statsHtml += '<div id="packageDetails">';
                statsHtml += '<p><strong>Name:</strong> <span id="pkgName">' + (parentPackageStats.packageName || '-') + '</span></p>';
                statsHtml += '<p><strong>Price:</strong> <span id="pkgPrice">' + (parentPackageStats.price ? new Intl.NumberFormat().format(parentPackageStats.price) : '-') + '</span> VND</p>';
                statsHtml += '<p><strong>Max Students Per Parent:</strong> <span id="pkgMax">' + (parentPackageStats.maxPerParent || '-') + '</span></p>';
                statsHtml += '<p><strong>Parent\'s Current Assignments:</strong> <span class="text-info">' + (parentPackageStats.activeAssignments || 0) + '</span></p>';
                statsHtml += '<p><strong>Parent\'s Available Slots:</strong> <span class="text-success">' + (parentPackageStats.availableSlots || 0) + '</span></p>';
                statsHtml += '</div>';

                if (parentPackageStats.availableSlots <= 0) {
                    statsHtml += '<div class="alert alert-warning mt-2">';
                    statsHtml += '<i class="fas fa-exclamation-triangle"></i> ';
                    statsHtml += 'This parent has reached the maximum limit for this package (' + (parentPackageStats.maxPerParent || 0) + ' students).';
                    statsHtml += '</div>';
                }

                packageInfo.innerHTML = statsHtml;

                // Update max students for validation
                maxStudents = parentPackageStats.availableSlots || 0;
            }

            function displayStudents(students) {
                const studentsList = document.getElementById('studentsList');

                if (!students || students.length === 0) {
                    studentsList.innerHTML = '<div class="no-students"><i class="fas fa-user-slash"></i><br>No students found for this parent.</div>';
                    updateAssignButton();
                    return;
                }

                // Separate available and unavailable students
                const availableStudents = students.filter(s => s.status === 'available');
                const unavailableStudents = students.filter(s => s.status === 'unavailable');

                var html = '';

                // Show parent's available slots info
                if (parentPackageStats && parentPackageStats.availableSlots <= 0) {
                    html += '<div class="alert alert-warning">';
                    html += '<i class="fas fa-exclamation-triangle"></i> ';
                    html += 'This parent has no available slots for this package. ';
                    html += 'Current assignments: ' + (parentPackageStats.activeAssignments || 0) + '/' + (parentPackageStats.maxPerParent || 0);
                    html += '</div>';
                } else if (parentPackageStats) {
                    html += '<div class="alert alert-info">';
                    html += '<i class="fas fa-info-circle"></i> ';
                    html += 'Available slots for this parent: ' + (parentPackageStats.availableSlots || 0) + ' out of ' + (parentPackageStats.maxPerParent || 0);
                    html += '</div>';
                }

                // Available students section
                if (availableStudents.length > 0) {
                    html += '<h6 class="mt-3 mb-3 text-success">Available Students (' + availableStudents.length + '):</h6>';
                    for (var i = 0; i < availableStudents.length; i++) {
                        var student = availableStudents[i];
                        html += '<div class="student-card" data-student-id="' + student.id + '" onclick="toggleStudentSelection(' + student.id + ')">';
                        html += '<div class="student-info">';
                        html += '<h6><i class="fas fa-user text-success"></i> ' + student.full_name + '</h6>';
                        html += '<p><i class="fas fa-id-card"></i> Username: ' + student.username + '</p>';
                        html += '<p><i class="fas fa-graduation-cap"></i> Grade: ' + student.grade_name + '</p>';
                        html += '<p><span class="badge badge-success">Available for Assignment</span></p>';
                        html += '</div>';
                        html += '<input type="checkbox" name="studentIds" value="' + student.id + '" style="display: none;">';
                        html += '</div>';
                    }
                }

                // Unavailable students section
                if (unavailableStudents.length > 0) {
                    html += '<h6 class="mt-4 mb-3 text-danger">Students Already Have This Package (' + unavailableStudents.length + '):</h6>';
                    for (var i = 0; i < unavailableStudents.length; i++) {
                        var student = unavailableStudents[i];
                        html += '<div class="student-card unavailable">';
                        html += '<div class="student-info">';
                        html += '<h6><i class="fas fa-user text-danger"></i> ' + student.full_name + '</h6>';
                        html += '<p><i class="fas fa-id-card"></i> Username: ' + student.username + '</p>';
                        html += '<p><i class="fas fa-graduation-cap"></i> Grade: ' + student.grade_name + '</p>';
                        html += '<p><span class="badge badge-danger">Already Assigned</span></p>';
                        html += '</div>';
                        html += '</div>';
                    }
                }

                if (availableStudents.length === 0 && unavailableStudents.length === 0) {
                    html += '<div class="no-students"><i class="fas fa-user-slash"></i><br>No students found for this parent.</div>';
                }

                studentsList.innerHTML = html;
                updateAssignButton();
            }

            function loadAssignmentHistory(parentId) {
                if (!parentId)
                    return;

                $.ajax({
                    url: 'study_package',
                    method: 'GET',
                    data: {
                        service: 'getParentAssignmentHistory',
                        parentId: parentId,
                        limit: 5
                    },
                    success: function (history) {
                        try {
                            if (typeof history === 'string') {
                                history = JSON.parse(history);
                            }
                            displayAssignmentHistory(history);
                        } catch (parseError) {
                            console.error('Error parsing assignment history:', parseError);
                        }
                    },
                    error: function () {
                        console.log('Could not load assignment history');
                    }
                });
            }

            function displayAssignmentHistory(history) {
                const historyDiv = document.getElementById('assignmentHistory');
                const historyContent = document.getElementById('historyContent');

                if (!history || history.length === 0) {
                    historyDiv.style.display = 'none';
                    return;
                }

                let html = '<div class="table-responsive"><table class="table table-sm">';
                html += '<thead><tr><th>Package</th><th>Student</th><th>Date</th><th>Status</th></tr></thead><tbody>';

                history.forEach(function (item) {
                    html += '<tr>';
                    html += '<td>' + (item.packageName || '-') + '</td>';
                    html += '<td>' + (item.studentName || '-') + '</td>';
                    html += '<td>' + (item.assignmentDate ? new Date(item.assignmentDate).toLocaleDateString() : '-') + '</td>';
                    html += '<td><span class="badge badge-' + (item.status === 'ACTIVE' ? 'success' : 'secondary') + '">' + (item.status || '-') + '</span></td>';
                    html += '</tr>';
                });

                html += '</tbody></table></div>';
                historyContent.innerHTML = html;
                historyDiv.style.display = 'block';
            }

            // Rest of the JavaScript functions remain the same...
            // (toggleStudentSelection, resetStudentSelection, updateAssignButton, validateForm, showAlert)

            function toggleStudentSelection(studentId) {
                const card = document.querySelector('[data-student-id="' + studentId + '"]');
                const checkbox = card.querySelector('input[type="checkbox"]');

                // Check if card is unavailable
                if (card.classList.contains('unavailable')) {
                    return;
                }

                // Check parent's available slots
                if (parentPackageStats && parentPackageStats.availableSlots <= 0) {
                    showAlert('This parent has no available slots for this package.', 'warning');
                    return;
                }

                if (selectedStudents.includes(studentId)) {
                    // Deselect
                    selectedStudents = selectedStudents.filter(function (id) {
                        return id !== studentId;
                    });
                    card.classList.remove('selected');
                    checkbox.checked = false;
                } else {
                    // Check max limit (use parent's available slots)
                    const maxAllowed = parentPackageStats ? parentPackageStats.availableSlots : maxStudents;
                    if (maxAllowed > 0 && selectedStudents.length >= maxAllowed) {
                        showAlert('This parent can only assign up to ' + maxAllowed + ' more student(s) for this package.', 'warning');
                        return;
                    }

                    // Select
                    selectedStudents.push(studentId);
                    card.classList.add('selected');
                    checkbox.checked = true;
                }

                updateAssignButton();
            }

            function resetStudentSelection() {
                selectedStudents = [];
                document.querySelectorAll('.student-card').forEach(function (card) {
                    card.classList.remove('selected');
                    const checkbox = card.querySelector('input[type="checkbox"]');
                    if (checkbox)
                        checkbox.checked = false;
                });
                updateAssignButton();
            }

            function updateAssignButton() {
                const packageSelected = $('#packageId').val();
                const parentSelected = $('#parentId').val();
                const studentsSelected = selectedStudents.length > 0;
                const assignBtn = document.getElementById('assignBtn');

                console.log('DEBUG: Package:', packageSelected, 'Parent:', parentSelected, 'Students:', selectedStudents.length);

                if (packageSelected && parentSelected && studentsSelected) {
                    // Check if parent has available slots
                    if (parentPackageStats && parentPackageStats.availableSlots <= 0) {
                        assignBtn.disabled = true;
                        assignBtn.innerHTML = '<i class="fas fa-ban"></i> Parent Has No Available Slots';
                        assignBtn.className = 'btn btn-warning';
                    } else {
                        assignBtn.disabled = false;
                        assignBtn.innerHTML = '<i class="fas fa-user-plus"></i> Assign to ' + selectedStudents.length + ' Student(s)';
                        assignBtn.className = 'btn btn-success';
                    }
                } else {
                    assignBtn.disabled = true;
                    if (!packageSelected) {
                        assignBtn.innerHTML = '<i class="fas fa-user-plus"></i> Select Package First';
                    } else if (!parentSelected) {
                        assignBtn.innerHTML = '<i class="fas fa-user-plus"></i> Select Parent First';
                    } else if (!studentsSelected) {
                        assignBtn.innerHTML = '<i class="fas fa-user-plus"></i> Select Students First';
                    } else {
                        assignBtn.innerHTML = '<i class="fas fa-user-plus"></i> Complete Selection';
                    }
                    assignBtn.className = 'btn btn-secondary';
                }
            }

            function validateForm() {
                const packageSelected = $('#packageId').val();
                const parentSelected = $('#parentId').val();
                const studentsSelected = selectedStudents.length > 0;

                if (!packageSelected) {
                    showAlert('Please select a study package.', 'warning');
                    return false;
                }

                if (!parentSelected) {
                    showAlert('Please select a parent.', 'warning');
                    return false;
                }

                if (!studentsSelected) {
                    showAlert('Please select at least one student for assignment.', 'warning');
                    return false;
                }

                // Check parent's available slots
                if (parentPackageStats) {
                    if (parentPackageStats.availableSlots <= 0) {
                        showAlert('This parent has no available slots for this package.', 'warning');
                        return false;
                    }

                    if (selectedStudents.length > parentPackageStats.availableSlots) {
                        showAlert('You can only assign up to ' + parentPackageStats.availableSlots + ' student(s) for this parent.', 'warning');
                        return false;
                    }
                }

                return true;
            }

            function showAlert(message, type) {
                if (!type)
                    type = 'info';

                const alertDiv = document.createElement('div');
                alertDiv.className = 'alert alert-' + type + ' alert-dismissible fade show';

                var iconClass = 'info-circle';
                if (type === 'warning')
                    iconClass = 'exclamation-triangle';
                if (type === 'danger')
                    iconClass = 'exclamation-circle';
                if (type === 'success')
                    iconClass = 'check-circle';

                alertDiv.innerHTML = '<i class="fas fa-' + iconClass + '"></i> ' + message +
                        '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>';

                const container = document.querySelector('.assign-container');
                const firstChild = container.children[1]; // After h2 title
                container.insertBefore(alertDiv, firstChild);

                // Auto dismiss after 5 seconds
                setTimeout(function () {
                    if (alertDiv.parentNode) {
                        alertDiv.remove();
                    }
                }, 5000);
            }

            // Prevent nice-select conflicts
            $(document).ready(function () {
                // Remove any nice-select elements that might interfere
                $('.nice-select').remove();
                $('select').show();
            });
        </script>
    </body>
</html>