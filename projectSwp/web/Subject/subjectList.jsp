<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Subject Management</title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- CSS here -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
        <style>
            body {
                padding-top: 130px;
                background-color: #f8f9fa;
            }
            main {
                max-width: 1200px;
                margin: 40px auto;
                padding: 20px;
                background: white;
                border-radius: 12px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            .success-notification {
                background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
                border: 1px solid #28a745;
                border-radius: 8px;
                padding: 20px;
                margin-bottom: 20px;
                position: relative;
            }
            .success-notification h5 {
                color: #155724;
                margin-bottom: 15px;
            }
            .success-notification p {
                color: #155724;
                margin-bottom: 15px;
            }
            .btn-create-course {
                background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 6px;
                text-decoration: none;
                font-weight: 600;
                margin-right: 10px;
            }
            .btn-create-course:hover {
                color: white;
                transform: translateY(-2px);
                box-shadow: 0 4px 15px rgba(0,123,255,0.3);
            }
            .btn-dismiss {
                background: #6c757d;
                color: white;
                border: none;
                padding: 8px 15px;
                border-radius: 4px;
                cursor: pointer;
            }

            /* Fixed button group styling */
            .btn-group {
                display: flex;
                flex-direction: row;
                gap: 8px;
                align-items: center;
                justify-content: center;
                flex-wrap: wrap;
            }

            .btn-group .btn {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                padding: 8px 12px;
                font-size: 0.875rem;
                line-height: 1.5;
                border-radius: 4px;
                text-decoration: none;
                border: 1px solid transparent;
                transition: all 0.15s ease-in-out;
                white-space: nowrap;
                min-width: auto;
                margin: 0;
            }

            .btn-group .btn i {
                margin-right: 4px;
                font-size: 0.875rem;
            }

            .btn-group .btn:hover {
                text-decoration: none;
                transform: translateY(-1px);
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }

            /* Button variants */
            .btn-outline-primary {
                color: #0d6efd;
                border-color: #0d6efd;
                background-color: transparent;
            }

            .btn-outline-primary:hover {
                color: #fff !important;
                background-color: #0d6efd;
                border-color: #0d6efd;
            }

            .btn-outline-success {
                color: #198754;
                border-color: #198754;
                background-color: transparent;
            }

            .btn-outline-success:hover {
                color: #fff !important;
                background-color: #198754;
                border-color: #198754;
            }

            .btn-outline-danger {
                color: #dc3545;
                border-color: #dc3545;
                background-color: transparent;
            }

            .btn-outline-danger:hover {
                color: #fff !important;
                background-color: #dc3545;
                border-color: #dc3545;
            }

            /* Table responsive improvements */
            .table-responsive {
                border-radius: 8px;
                overflow: hidden;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }

            .table th {
                background-color: #343a40;
                color: white;
                font-weight: 600;
                border: none;
                padding: 12px;
            }

            .table td {
                padding: 12px;
                vertical-align: middle;
                border-color: #dee2e6;
            }

            .table tbody tr:hover {
                background-color: #f8f9fa;
            }

            .badge {
                padding: 6px 12px;
                font-size: 0.75rem;
                font-weight: 600;
                border-radius: 20px;
            }

            .bg-primary {
                background-color: #0d6efd !important;
            }

            /* Action column width */
            .action-column {
                width: 220px;
                min-width: 220px;
            }

            /* Responsive adjustments */
            @media (max-width: 768px) {
                .btn-group {
                    flex-direction: column;
                    gap: 4px;
                    width: 100%;
                }

                .btn-group .btn {
                    width: 100%;
                    justify-content: center;
                }

                .action-column {
                    width: auto;
                    min-width: auto;
                }
            }
        </style>
    </head>
    <body>
        <%@include file="../header.jsp" %>

        <main>
            <h2 class="text-center mb-4">Subject Management</h2>

            <!-- Success notification for new subject creation -->
            <c:if test="${sessionScope.subjectCreated != null && sessionScope.subjectCreated}">
                <div class="success-notification" id="courseCreationNotification">
                    <h5><i class="fas fa-check-circle"></i> Subject Created Successfully!</h5>
                    <p>Subject "<strong>${sessionScope.newSubjectName}</strong>" has been created successfully.</p>
                    <p>Would you like to create a course for this subject now?</p>
                    <div>
                        <a href="${pageContext.request.contextPath}/course?action=create&subjectId=${sessionScope.newSubjectId}" 
                           class="btn-create-course">
                            <i class="fas fa-plus"></i> Create Course Now
                        </a>
                        <button type="button" class="btn-dismiss" onclick="dismissNotification()">
                            <i class="fas fa-times"></i> Maybe Later
                        </button>
                    </div>
                </div>
            </c:if>

            <!-- Error and success messages -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <!-- Search form -->
            <div class="row mb-4">
                <div class="col-md-8">
                    <form method="get" action="subjects" class="d-flex">
                        <input type="text" name="name" class="form-control me-2" 
                               placeholder="Search by subject name..." 
                               value="${param.name}">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-search"></i> Search
                        </button>
                    </form>
                </div>
                <div class="col-md-4 text-end">
                    <a href="subjects?action=create" class="btn btn-success">
                        <i class="fas fa-plus"></i> Add New Subject
                    </a>
                </div>
            </div>

            <!-- Subject table -->
            <div class="table-responsive">
                <table class="table table-striped table-hover">
                    <thead class="table-dark">
                        <tr>
                            <th>ID</th>
                            <th>Subject Name</th>
                            <th>Grade</th>
                            <th>Description</th>
                            <th class="action-column">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty subjectList}">
                                <c:forEach var="subject" items="${subjectList}">
                                    <tr>
                                        <td>${subject.id}</td>
                                        <td><strong>${subject.name}</strong></td>
                                        <td>
                                            <span class="badge bg-primary">
                                                ${gradeMap[subject.grade_id]}
                                            </span>
                                        </td>
                                        <td>${subject.description}</td>
                                        <td class="action-column">
                                            <div class="btn-group" role="group">
                                                <a href="subjects?action=edit&id=${subject.id}" 
                                                   class="btn btn-outline-primary" title="Edit Subject">
                                                    <i class="fas fa-edit"></i> Edit
                                                </a>
                                                <a href="${pageContext.request.contextPath}/course?action=create&subjectId=${subject.id}" 
                                                   class="btn btn-outline-success" title="Create Course">
                                                    <i class="fas fa-plus"></i> Course
                                                </a>
                                                <a href="subjects?action=delete&id=${subject.id}" 
                                                   class="btn btn-outline-danger" title="Delete Subject"
                                                   onclick="return confirm('Are you sure you want to delete this subject?')">
                                                    <i class="fas fa-trash"></i> Delete
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="5" class="text-center text-muted">
                                        <i class="fas fa-inbox fa-2x mb-2"></i>
                                        <br>No subjects found.
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </main>

        <%@include file="../footer.jsp" %>

        <!-- JS -->
        <script src="${pageContext.request.contextPath}/assets/js/vendor/jquery-1.12.4.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4" crossorigin="anonymous"></script>

        <script>
                                                       function dismissNotification() {
                                                           document.getElementById('courseCreationNotification').style.display = 'none';
                                                           // Clear session attributes via AJAX
                                                           fetch('${pageContext.request.contextPath}/subjects?action=clearNotification', {
                                                               method: 'POST'
                                                           });
                                                       }

                                                       // Auto-dismiss notification after 10 seconds
                                                       setTimeout(function () {
                                                           const notification = document.getElementById('courseCreationNotification');
                                                           if (notification) {
                                                               notification.style.display = 'none';
                                                           }
                                                       }, 10000);

                                                       // Prevent nice-select initialization on page load
                                                       $(document).ready(function () {
                                                           // Disable nice-select globally for this page
                                                           if (typeof $.fn.niceSelect !== 'undefined') {
                                                               $.fn.niceSelect = function () {
                                                                   return this;
                                                               };
                                                           }
                                                       });
        </script>
    </body>
</html>
