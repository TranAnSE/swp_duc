<%-- 
    Document   : listStudyPackage
    Created on : Jun 2, 2025, 12:37:58 AM
    Author     : Na
    Modified   : Tách form thêm/sửa thành trang riêng (studyPackageForm.jsp), tích hợp header/footer
--%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Study Package Management</title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="manifest" href="site.webmanifest">
        <link rel="shortcut icon" type="image/x-icon" href="assets/img/favicon.ico">

        <!-- CSS here -->
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
            .text-danger {
                color: red;
                font-size: 0.875em;
            }
            .text-success {
                color: green;
                font-size: 0.875em;
            }
            .header-area {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                z-index: 1000;
                background-color: white;
                border-bottom: 1px solid #ddd;
            }
            body {
                padding-top: 130px;
            }
            main {
                background-color: #f8f9fa;
                padding: 30px 15px;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                margin: 20px auto;
                max-width: 1400px;
            }
            main h2 {
                text-align: center;
                font-weight: 700;
                color: #343a40;
                margin-bottom: 30px;
            }
            /* Search form */
            form[method="get"] {
                display: flex;
                align-items: flex-end;
                gap: 15px;
                flex-wrap: wrap;
                justify-content: center;
                margin-bottom: 30px;
                background: #ffffff;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            form[method="get"] .form-group {
                display: flex;
                flex-direction: column;
                margin-bottom: 0;
            }
            form[method="get"] label {
                font-weight: 600;
                color: #333;
                margin-bottom: 5px;
            }
            form[method="get"] input[type="text"],
            form[method="get"] input[type="number"] {
                width: 200px;
                padding: 8px 12px;
                font-size: 14px;
                border-radius: 6px;
                border: 1px solid #ced4da;
                box-sizing: border-box;
                background-color: #fdfdfd;
                transition: border-color 0.3s ease;
            }
            form[method="get"] input[type="text"]:focus,
            form[method="get"] input[type="number"]:focus {
                border-color: #007bff;
                outline: none;
            }
            form[method="get"] input[type="submit"],
            form[method="get"] button {
                padding: 8px 15px;
                font-size: 14px;
                border-radius: 6px;
                border: none;
                text-decoration: none;
                color: #fff;
                background-color: #28a745;
                transition: background-color 0.3s ease;
            }
            form[method="get"] button[type="button"] {
                background-color: #6c757d;
            }
            form[method="get"] input[type="submit"]:hover,
            form[method="get"] button:hover {
                background-color: #218838;
            }
            form[method="get"] button[type="button"]:hover {
                background-color: #5a6268;
            }
            /* Action buttons */
            .action-buttons {
                display: flex;
                gap: 15px;
                justify-content: center;
                margin-bottom: 30px;
            }
            .add-btn {
                display: inline-block;
                padding: 12px 20px;
                font-size: 14px;
                border-radius: 6px;
                text-decoration: none;
                color: #fff;
                background-color: #28a745;
                transition: background-color 0.3s ease;
            }
            .add-btn:hover {
                background-color: #218838;
                color: #fff;
            }
            .my-packages-btn {
                background-color: #007bff;
            }
            .my-packages-btn:hover {
                background-color: #0056b3;
            }
            /* Table */
            table.table {
                background-color: #fff;
                border-radius: 6px;
                overflow: hidden;
            }
            table.table thead {
                background-color: #343a40;
                color: #fff;
            }
            table.table td,
            table.table th {
                vertical-align: middle !important;
                text-align: center;
                padding: 12px 8px;
            }
            table.table .btn {
                margin: 2px;
                font-size: 12px;
                padding: 4px 8px;
            }
            .package-type-badge {
                padding: 4px 8px;
                border-radius: 12px;
                font-size: 11px;
                font-weight: bold;
            }
            .type-combo {
                background-color: #e3f2fd;
                color: #1976d2;
            }
            .type-grade {
                background-color: #e8f5e8;
                color: #388e3c;
            }
            .status-badge {
                padding: 4px 8px;
                border-radius: 12px;
                font-size: 11px;
                font-weight: bold;
            }
            .status-active {
                background-color: #d4edda;
                color: #155724;
            }
            .status-inactive {
                background-color: #f8d7da;
                color: #721c24;
            }
            /* Messages */
            .text-danger, .text-success {
                font-size: 0.9em;
                font-weight: bold;
                margin: 10px 0;
                text-align: center;
            }
            .package-description {
                max-width: 200px;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
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

        <%@include file="../header.jsp" %>

        <main>
            <h2>Study Package Management</h2>

            <!-- Error and success messages -->
            <c:if test="${not empty errorMessage}">
                <div class="text-danger"><c:out value="${errorMessage}"/></div>
            </c:if>
            <c:if test="${not empty message}">
                <div class="text-success"><c:out value="${message}"/></div>
            </c:if>

            <!-- Search form -->
            <script>
                function validateSearchForm() {
                    const id = document.getElementById("id").value.trim();
                    const name = document.getElementById("name").value.trim();
                    const price = document.getElementById("price").value.trim();

                    if (!id && !name && !price) {
                        alert("Please enter at least one search criterion (ID, Name, or Price).");
                        return false;
                    }
                    return true;
                }
            </script>

            <form method="get" action="study_package" onsubmit="return validateSearchForm()">
                <input type="hidden" name="service" value="search" />
                <div class="form-group">
                    <label for="id">Package ID</label>
                    <input type="text" name="id" id="id" placeholder="Enter ID" value="${param.id != null ? param.id : ''}" />
                </div>
                <div class="form-group">
                    <label for="name">Package Name</label>
                    <input type="text" name="name" id="name" placeholder="Enter name" value="${param.name != null ? param.name : ''}" />
                </div>
                <div class="form-group">
                    <label for="price">Price</label>
                    <input type="text" name="price" id="price" placeholder="Enter price" value="${param.price != null ? param.price : ''}" />
                </div>
                <div>
                    <input type="submit" value="Search" />
                    <button type="button" onclick="window.location.href = 'study_package'">Clear Search</button>
                </div>
            </form>

            <!-- Action buttons -->
            <div class="action-buttons">
                <c:if test="${sessionScope.account.role == 'admin' || sessionScope.account.role == 'teacher'}">
                    <a href="study_package?service=add" class="add-btn">
                        <i class="fas fa-plus"></i> Add New Package
                    </a>
                </c:if>
                <c:if test="${sessionScope.account.role == 'parent'}">
                    <a href="study_package?service=myPackages" class="add-btn my-packages-btn">
                        <i class="fas fa-box"></i> My Packages
                    </a>
                </c:if>
            </div>

            <!-- Package table -->
            <h3>Available Study Packages</h3>
            <div class="table-responsive">
                <table class="table table-bordered table-hover">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Type</th>
                            <th>Grade</th>
                            <th>Price (VND)</th>
                            <th>Max Students</th>
                            <th>Duration (Days)</th>
                            <th>Description</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty listStudyPackage}">
                                <c:forEach var="sp" items="${listStudyPackage}">
                                    <tr>
                                        <td><c:out value="${sp.id}"/></td>
                                        <td>
                                            <c:out value="${sp.name}"/>
                                            <c:if test="${sp.type == 'SUBJECT_COMBO'}">
                                                <br><small class="text-muted">
                                                    <i class="fas fa-info-circle"></i> 
                                                    <a href="#" onclick="showSubjects(${sp.id})" class="text-info">View Subjects</a>
                                                </small>
                                            </c:if>
                                        </td>
                                        <td>
                                            <span class="package-type-badge ${sp.type == 'GRADE_ALL' ? 'type-grade' : 'type-combo'}">
                                                <c:choose>
                                                    <c:when test="${sp.type == 'GRADE_ALL'}">All Subjects</c:when>
                                                    <c:otherwise>Subject Combo</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>
                                        <td>
                                            <c:if test="${sp.grade_id != null}">
                                                <c:forEach items="${grades}" var="grade">
                                                    <c:if test="${grade.id == sp.grade_id}">
                                                        ${grade.name}
                                                    </c:if>
                                                </c:forEach>
                                            </c:if>
                                            <c:if test="${sp.grade_id == null}">-</c:if>
                                            </td>
                                            <td><c:out value="${sp.price}"/></td>
                                        <td>${sp.max_students}</td>
                                        <td>${sp.duration_days}</td>
                                        <td>
                                            <div class="package-description" title="${sp.description}">
                                                <c:out value="${sp.description}"/>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="status-badge ${sp.is_active ? 'status-active' : 'status-inactive'}">
                                                ${sp.is_active ? 'Active' : 'Inactive'}
                                            </span>
                                        </td>
                                        <td>
                                            <c:if test="${sessionScope.account.role == 'admin' || sessionScope.account.role == 'teacher'}">
                                                <a href="study_package?service=edit&editId=${sp.id}" class="btn btn-primary btn-sm">
                                                    <i class="fas fa-edit"></i> Edit
                                                </a>
                                                <form method="post" action="study_package" style="display:inline-block;" 
                                                      onsubmit="return confirm('Are you sure you want to deactivate package ID ${sp.id}?');">
                                                    <input type="hidden" name="service" value="delete" />
                                                    <input type="hidden" name="id" value="${sp.id}" />
                                                    <button type="submit" class="btn btn-danger btn-sm">
                                                        <i class="fas fa-ban"></i> Deactivate
                                                    </button>
                                                </form>
                                            </c:if>

                                            <a href="study_package?service=detail&id=${sp.id}" class="btn btn-info btn-sm">
                                                <i class="fas fa-eye"></i> Details
                                            </a>

                                            <c:if test="${sessionScope.account.role == 'parent' && sp.is_active}">
                                                <a href="study_package?service=checkout&id=${sp.id}" class="btn btn-success btn-sm"
                                                   onclick="return confirm('Do you want to purchase this study package?');">
                                                    <i class="fas fa-shopping-cart"></i> Purchase
                                                </a>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr><td colspan="10" class="text-center">No study packages available</td></tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
            <!-- Subject Details Modal -->
            <div class="modal fade" id="subjectModal" tabindex="-1" role="dialog" aria-labelledby="subjectModalLabel" aria-hidden="true">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="subjectModalLabel">Package Subjects</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body" id="subjectModalBody">
                            <div class="text-center">
                                <i class="fas fa-spinner fa-spin"></i> Loading subjects...
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <%@include file="../footer.jsp" %>
        <div id="back-top">
            <a title="Go to Top" href="#"> <i class="fas fa-level-up-alt"></i></a>
        </div>

        <!-- JS here -->
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

        <script>
                                                       function showSubjects(packageId) {
                                                           $('#subjectModal').modal('show');
                                                           $('#subjectModalBody').html('<div class="text-center"><i class="fas fa-spinner fa-spin"></i> Loading subjects...</div>');

                                                           $.ajax({
                                                               url: 'study_package',
                                                               type: 'GET',
                                                               data: {
                                                                   service: 'getSubjectsByPackage',
                                                                   packageId: packageId
                                                               },
                                                               dataType: 'json',
                                                               success: function (subjects) {
                                                                   let html = '';
                                                                   if (subjects && subjects.length > 0) {
                                                                       html = '<ul class="list-group">';
                                                                       subjects.forEach(function (subject) {
                                                                           html += '<li class="list-group-item">' +
                                                                                   '<i class="fas fa-book"></i> ' + subject.name +
                                                                                   '</li>';
                                                                       });
                                                                       html += '</ul>';
                                                                   } else {
                                                                       html = '<div class="alert alert-info">No subjects found for this package.</div>';
                                                                   }
                                                                   $('#subjectModalBody').html(html);
                                                               },
                                                               error: function () {
                                                                   $('#subjectModalBody').html('<div class="alert alert-danger">Error loading subjects.</div>');
                                                               }
                                                           });
                                                       }
        </script>
    </body>
</html>
