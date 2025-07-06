<%-- 
    Document   : listChapter
    Created on : May 21, 2025, 02:06:43 AM
    Author     : Na
--%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page errorPage="error.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Quản lý Chapter</title>
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
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pagination.css">

        <!-- Select2 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />

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
            main h2 {
                text-align: center;
                font-weight: 700;
                color: #343a40;
                margin-bottom: 30px;
            }
            .add-btn {
                display: inline-block;
                margin-bottom: 20px;
                padding: 8px 15px;
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
                text-decoration: none;
            }
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
            }
            table.table .btn {
                margin: 2px;
                font-size: 14px;
                padding: 5px 10px;
            }
            .text-danger, .text-success {
                font-size: 0.9em;
                font-weight: bold;
                margin: 10px 0;
                text-align: center;
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
            <h2>Manage Chapter</h2>

            <!-- Error and success messages -->
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i> ${errorMessage}
                </div>
            </c:if>
            <c:if test="${not empty message}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> ${message}
                </div>
            </c:if>

            <!-- Filter Section -->
            <div class="filter-section">
                <form method="get" action="chapter" id="filterForm">
                    <input type="hidden" name="service" value="search" />
                    <div class="filter-row">
                        <div class="filter-group">
                            <label for="idFilter">ID:</label>
                            <input type="text" id="idFilter" name="id" 
                                   placeholder="Enter ID" 
                                   value="${param.id}">
                        </div>

                        <div class="filter-group">
                            <label for="nameFilter">Name:</label>
                            <input type="text" id="nameFilter" name="name" 
                                   placeholder="Enter Name" 
                                   value="${selectedName}">
                        </div>

                        <div class="filter-group">
                            <label for="subjectFilter">Subject:</label>
                            <select id="subjectFilter" name="subject_id" class="form-select select2-enabled">
                                <option value="">Choose Subject</option>
                                <c:forEach var="subject" items="${listSubject}">
                                    <option value="${subject.id}" 
                                            ${selectedSubjectId != null && selectedSubjectId == subject.id ? 'selected' : ''}>
                                        ${subject.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="filter-actions">
                            <button type="submit" class="btn-filter btn-primary">
                                <i class="fas fa-search"></i> Filter
                            </button>
                            <button type="button" class="btn-filter btn-secondary" onclick="clearFilters()">
                                <i class="fas fa-times"></i> Clear
                            </button>
                        </div>
                    </div>

                    <!-- Hidden fields to preserve pagination -->
                    <input type="hidden" name="page" value="1">
                    <input type="hidden" name="pageSize" value="${pageSize}">
                </form>
            </div>

            <!-- Add new chapter button -->
            <div style="text-align: center;">
                <a href="chapter?service=add" class="add-btn">
                    <i class="fas fa-plus"></i> Add new Chapter
                </a>
            </div>

            <!-- Results Info and Pagination -->
            <c:set var="totalItems" value="${totalChapters}" scope="request"/>
            <c:set var="itemType" value="chapters" scope="request"/>
            <jsp:include page="../components/pagination.jsp"/>

            <!-- Chapter table -->
            <div class="table-responsive">
                <table class="table table-bordered table-hover">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Description</th>
                            <th>Subject</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty listChapter}">
                                <c:forEach var="ch" items="${listChapter}">
                                    <tr>
                                        <td>${ch.id}</td>
                                        <td><strong>${ch.name}</strong></td>
                                        <td>${ch.description}</td>
                                        <td>
                                            <span class="badge bg-primary">
                                                ${subjectMap[ch.subject_id] != null ? subjectMap[ch.subject_id] : 'Unknown'}
                                            </span>
                                        </td>
                                        <td>
                                            <div class="btn-group" role="group">
                                                <a href="chapter?service=edit&editId=${ch.id}" 
                                                   class="btn btn-primary btn-sm">
                                                    <i class="fas fa-edit"></i> Edit
                                                </a>
                                                <a href="chapter?service=delete&id=${ch.id}" 
                                                   class="btn btn-danger btn-sm" 
                                                   onclick="return confirm('Are you sure you want to delete chapter ID ${ch.id}?');">
                                                    <i class="fas fa-trash"></i> Delete
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="5" class="text-center text-muted py-4">
                                        <i class="fas fa-book fa-3x mb-3"></i>
                                        <br>No chapters found.
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>

            <!-- Pagination at bottom -->
            <c:if test="${totalPages > 1}">
                <div class="pagination-container">
                    <div class="pagination">
                        <!-- First page -->
                        <c:if test="${currentPage > 1}">
                            <a href="javascript:void(0)" onclick="goToPage(1)" title="First page">
                                <i class="fas fa-angle-double-left"></i>
                            </a>
                        </c:if>

                        <!-- Previous page -->
                        <c:if test="${currentPage > 1}">
                            <a href="javascript:void(0)" onclick="goToPage(${currentPage - 1})" title="Previous page">
                                <i class="fas fa-angle-left"></i>
                            </a>
                        </c:if>

                        <!-- Page numbers -->
                        <c:forEach begin="${startPage}" end="${endPage}" var="pageNum">
                            <c:choose>
                                <c:when test="${pageNum == currentPage}">
                                    <span class="current">${pageNum}</span>
                                </c:when>
                                <c:otherwise>
                                    <a href="javascript:void(0)" onclick="goToPage(${pageNum})">${pageNum}</a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>

                        <!-- Next page -->
                        <c:if test="${currentPage < totalPages}">
                            <a href="javascript:void(0)" onclick="goToPage(${currentPage + 1})" title="Next page">
                                <i class="fas fa-angle-right"></i>
                            </a>
                        </c:if>

                        <!-- Last page -->
                        <c:if test="${currentPage < totalPages}">
                            <a href="javascript:void(0)" onclick="goToPage(${totalPages})" title="Last page">
                                <i class="fas fa-angle-double-right"></i>
                            </a>
                        </c:if>
                    </div>
                </div>
            </c:if>
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

        <!-- Select2 JS -->
        <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

        <script>
                                $(document).ready(function () {
                                    // Disable nice-select initialization completely
                                    if (typeof $.fn.niceSelect !== 'undefined') {
                                        $.fn.niceSelect = function () {
                                            return this;
                                        };
                                    }

                                    // Destroy any existing Select2 instances and nice-select
                                    $('.select2-enabled').each(function () {
                                        if ($(this).hasClass('select2-hidden-accessible')) {
                                            $(this).select2('destroy');
                                        }
                                        // Remove nice-select if exists
                                        if ($(this).next('.nice-select').length) {
                                            $(this).next('.nice-select').remove();
                                            $(this).show();
                                        }
                                    });

                                    // Initialize Select2 for dropdowns
                                    $('.select2-enabled').select2({
                                        placeholder: function () {
                                            return $(this).data('placeholder') || 'Choose Subject';
                                        },
                                        allowClear: true,
                                        width: '100%',
                                        dropdownParent: $('body')
                                    });

                                    // Auto-submit form when Enter is pressed in search fields
                                    $('#idFilter, #nameFilter').on('keypress', function (e) {
                                        if (e.which === 13) {
                                            $('#filterForm').submit();
                                        }
                                    });
                                });

                                function clearFilters() {
                                    $('#idFilter').val('');
                                    $('#nameFilter').val('');
                                    $('#subjectFilter').val('').trigger('change');
                                    $('#filterForm').submit();
                                }

                                // Auto-dismiss alerts after 5 seconds
                                setTimeout(function () {
                                    $('.alert').fadeOut('slow');
                                }, 5000);
        </script>
    </body>
</html>
