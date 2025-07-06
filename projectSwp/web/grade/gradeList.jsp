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
        <link rel="stylesheet" href="assets/css/nice-select.css">
        <link rel="stylesheet" href="assets/css/style.css">

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

            /* Filter Section */
            .filter-section {
                background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
                border-radius: 8px;
                padding: 20px;
                margin-bottom: 25px;
                border: 1px solid #dee2e6;
            }

            .filter-row {
                display: flex;
                flex-wrap: wrap;
                gap: 15px;
                align-items: end;
            }

            .filter-group {
                min-width: 200px;
                flex: 1;
            }

            .filter-group label {
                font-weight: 600;
                color: #495057;
                margin-bottom: 5px;
                display: block;
            }

            .filter-group select,
            .filter-group input {
                width: 100%;
                padding: 8px 12px;
                border: 1px solid #ced4da;
                border-radius: 4px;
                font-size: 14px;
            }

            .filter-actions {
                display: flex;
                gap: 10px;
                align-items: end;
            }

            .btn-filter {
                padding: 8px 20px;
                border-radius: 4px;
                border: none;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .btn-primary {
                background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
                color: white;
            }

            .btn-secondary {
                background: #6c757d;
                color: white;
            }

            .btn-filter:hover {
                transform: translateY(-1px);
                box-shadow: 0 2px 8px rgba(0,0,0,0.15);
            }

            /* Results info */
            .results-info {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
                padding: 15px 0;
                border-bottom: 1px solid #dee2e6;
            }

            .results-count {
                font-weight: 600;
                color: #495057;
            }

            .page-size-selector {
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .page-size-selector select {
                padding: 5px 10px;
                border: 1px solid #ced4da;
                border-radius: 4px;
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

            /* Pagination */
            .pagination-container {
                display: flex;
                justify-content: center;
                align-items: center;
                margin-top: 30px;
                padding-top: 20px;
                border-top: 1px solid #dee2e6;
            }

            .pagination {
                display: flex;
                align-items: center;
                gap: 5px;
            }

            .pagination a,
            .pagination span {
                padding: 8px 12px;
                text-decoration: none;
                border: 1px solid #dee2e6;
                border-radius: 4px;
                color: #495057;
                transition: all 0.3s ease;
            }

            .pagination a:hover {
                background-color: #e9ecef;
                color: #495057;
                text-decoration: none;
            }

            .pagination .current {
                background-color: #007bff;
                color: white;
                border-color: #007bff;
            }

            .pagination .disabled {
                color: #6c757d;
                background-color: #f8f9fa;
                cursor: not-allowed;
            }

            /* Responsive */
            @media (max-width: 768px) {
                .filter-row {
                    flex-direction: column;
                }

                .filter-group {
                    min-width: 100%;
                }

                .results-info {
                    flex-direction: column;
                    gap: 10px;
                    align-items: flex-start;
                }
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
                            <select id="teacherFilter" name="teacherId">
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

            <!-- Results Info -->
            <div class="results-info">
                <div class="results-count">
                    <c:choose>
                        <c:when test="${totalGrades > 0}">
                            <div class="results-count">
                                <c:choose>
                                    <c:when test="${totalGrades > 0}">
                                        Showing ${displayStart} - ${displayEnd} of ${totalGrades} grades
                                    </c:when>
                                    <c:otherwise>
                                        No grades found
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:when>
                        <c:otherwise>
                            No grades found
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="d-flex gap-3 align-items-center">
                    <div class="page-size-selector">
                        <label for="pageSizeSelect">Show:</label>
                        <select id="pageSizeSelect" onchange="changePageSize(this.value)">
                            <option value="5" ${pageSize == 5 ? 'selected' : ''}>5</option>
                            <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                            <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                            <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                        </select>
                        <span>per page</span>
                    </div>

                    <a href="../Grade?action=addForm" class="btn btn-success">Add New Grade</a>
                </div>
            </div>

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
                                        <a href="../Grade?action=updateForm&id=${gra.id}" class="btn btn-sm btn-warning">Update</a> 
                                        <a href="../Grade?action=delete&id=${gra.id}" 
                                           onclick="return confirm('Are you sure to delete grade ID ${gra.id}?');" 
                                           class="btn btn-sm btn-danger ms-1">Delete</a>
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

            <!-- Pagination -->
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
        <script src="./assets/js/jquery.nice-select.min.js"></script>
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

        <script>
                                // Initialize page
                                $(document).ready(function () {
                                    // Auto-submit form when Enter is pressed in search field
                                    $('#nameFilter').on('keypress', function (e) {
                                        if (e.which === 13) {
                                            $('#filterForm').submit();
                                        }
                                    });
                                });

                                function clearFilters() {
                                    $('#nameFilter').val('');
                                    $('#teacherFilter').val('');
                                    $('#filterForm').submit();
                                }

                                function changePageSize(newPageSize) {
                                    const form = $('#filterForm');
                                    form.find('input[name="pageSize"]').val(newPageSize);
                                    form.find('input[name="page"]').val(1); // Reset to first page
                                    form.submit();
                                }

                                function goToPage(pageNumber) {
                                    const form = $('#filterForm');
                                    form.find('input[name="page"]').val(pageNumber);
                                    form.submit();
                                }

                                $(document).ready(function () {
                                    // Destroy existing nice-select instances
                                    $('select').niceSelect('destroy');

                                    // Reinitialize nice-select
                                    $('select').niceSelect();

                                    $('.nice-select').on('click', function () {
                                        $(this).toggleClass('open');
                                    });
                                });
        </script>

    </body>
</html>