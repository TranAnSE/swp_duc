<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
    <head>
        <title>Grade List</title>

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
        <link rel="shortcut icon" type="image/x-icon" href="assets/img/favicon.ico">

        <!-- External CSS -->
        <link rel="stylesheet" href="assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="assets/css/owl.carousel.min.css">
        <link rel="stylesheet" href="assets/css/slicknav.css">
        <link rel="stylesheet" href="assets/css/flaticon.css">
        <link rel="stylesheet" href="assets/css/progressbar_barfiller.css">
        <link rel="stylesheet" href="assets/css/gijgo.css">
        <link rel="stylesheet" href="assets/css/animate.min.css">
        <link rel="stylesheet" href="assets/css/animated-headline.css">
        <link rel="stylesheet" href="assets/css/magnific-popup.css">
        <link rel="stylesheet" href="assets/css/fontawesome-all.min.css">
        <link rel="stylesheet" href="assets/css/themify-icons.css">
        <link rel="stylesheet" href="assets/css/slick.css">
        <link rel="stylesheet" href="assets/css/style.css">
        <link rel="stylesheet" href="assets/css/pagination.css">

        <!-- Select2 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />

        <!-- Custom style -->
        <style>
            body {
                padding-top: 100px; /* avoid header overlap */
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

            .search-box {
                height: 45px;
                width: 300px;
                font-size: 16px;
                padding: 6px 12px;
            }

            .search-button {
                height: 45px;
                font-size: 16px;
                padding: 6px 20px;
            }
        </style>
    </head>
    <body>

        <jsp:include page="../header.jsp" />

        <main>
            <h2 class="mb-4">Grade List</h2>

            <!-- Filter Section -->
            <div class="filter-section">
                <form method="get" action="../Grade" id="filterForm">
                    <div class="filter-row">
                        <div class="filter-group">
                            <label for="nameFilter">Grade Name:</label>
                            <input type="text" id="nameFilter" name="name" 
                                   placeholder="Search by name..." 
                                   value="${selectedName}">
                        </div>

                        <div class="filter-group">
                            <label for="teacherFilter">Teacher:</label>
                            <select id="teacherFilter" name="teacherId" class="form-select select2-enabled">
                                <option value="">All Teachers</option>
                                <c:forEach var="acc" items="${accounts}">
                                    <option value="${acc.id}" 
                                            ${selectedTeacherId != null && selectedTeacherId == acc.id ? 'selected' : ''}>
                                        ${acc.full_name}
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

            <!-- Display errors -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <!-- Results Info and Pagination -->
            <c:set var="totalItems" value="${totalGrades}" scope="request"/>
            <c:set var="itemType" value="grades" scope="request"/>
            <c:set var="addNewUrl" value="../Grade?action=addForm" scope="request"/>
            <jsp:include page="../components/pagination.jsp"/>

            <!-- Grade table -->
            <table class="table table-bordered table-striped align-middle">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Description</th>
                        <th>Teacher Name</th>  
                        <th>Actions</th>              
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty gradeList}">
                            <c:forEach var="gra" items="${gradeList}">
                                <tr>
                                    <td>${gra.id}</td>
                                    <td><strong>${gra.name}</strong></td>
                                    <td>${gra.description}</td>
                                    <td>
                                        <c:forEach var="acc" items="${accounts}">
                                            <c:if test="${acc.id eq gra.teacher_id}">
                                                ${acc.full_name}
                                            </c:if>
                                        </c:forEach>
                                    </td>
                                    <td>
                                        <div class="btn-group" role="group">
                                            <a href="../Grade?action=updateForm&id=${gra.id}" 
                                               class="btn btn-sm btn-warning">
                                                <i class="fas fa-edit"></i> Update
                                            </a> 
                                            <a href="../Grade?action=delete&id=${gra.id}" 
                                               onclick="return confirm('Are you sure to delete grade ID ${gra.id}?');" 
                                               class="btn btn-sm btn-danger">
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
                                    <br>No grades found.
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>

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

            <!-- Display success message -->
            <c:if test="${not empty message}">
                <div class="alert alert-success mt-3">${message}</div>
            </c:if>
        </main>

        <!-- Include footer -->
        <jsp:include page="../footer.jsp" />

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <!-- JS Libraries -->
        <script src="./assets/js/vendor/modernizr-3.5.0.min.js"></script>
        <script src="./assets/js/vendor/jquery-1.12.4.min.js"></script>
        <script src="./assets/js/popper.min.js"></script>
        <script src="./assets/js/bootstrap.min.js"></script>
        <script src="./assets/js/jquery.slicknav.min.js"></script>
        <script src="./assets/js/owl.carousel.min.js"></script>
        <script src="./assets/js/slick.min.js"></script>
        <script src="./assets/js/wow.min.js"></script>
        <script src="./assets/js/animated.headline.js"></script>
        <script src="./assets/js/jquery.magnific-popup.js"></script>
        <script src="./assets/js/gijgo.min.js"></script>
        <script src="./assets/js/jquery.sticky.js"></script>
        <script src="./assets/js/jquery.barfiller.js"></script>
        <script src="./assets/js/jquery.counterup.min.js"></script>
        <script src="./assets/js/waypoints.min.js"></script>
        <script src="./assets/js/jquery.countdown.min.js"></script>
        <script src="./assets/js/hover-direction-snake.min.js"></script>
        <script src="./assets/js/contact.js"></script>
        <script src="./assets/js/jquery.form.js"></script>
        <script src="./assets/js/jquery.validate.min.js"></script>
        <script src="./assets/js/mail-script.js"></script>
        <script src="./assets/js/jquery.ajaxchimp.min.js"></script>
        <script src="./assets/js/plugins.js"></script>
        <script src="./assets/js/main.js"></script>

        <!-- Select2 JS -->
        <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

        <script>
                                // Initialize page
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
                                            return $(this).data('placeholder') || 'All Teachers';
                                        },
                                        allowClear: true,
                                        width: '100%',
                                        dropdownParent: $('body')
                                    });

                                    // Auto-submit form when Enter is pressed in search field
                                    $('#nameFilter').on('keypress', function (e) {
                                        if (e.which === 13) {
                                            $('#filterForm').submit();
                                        }
                                    });
                                });

                                function clearFilters() {
                                    $('#nameFilter').val('');
                                    $('#teacherFilter').val('').trigger('change');
                                    $('#filterForm').submit();
                                }

                                // Auto-dismiss alerts after 5 seconds
                                setTimeout(function () {
                                    $('.alert').fadeOut('slow');
                                }, 5000);
        </script>

    </body>
</html>