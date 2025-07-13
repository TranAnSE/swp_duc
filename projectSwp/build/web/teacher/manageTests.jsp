<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Quản lý bài Test</title>
        <link rel="stylesheet" href="/assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="/assets/css/style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
        <!-- Select2 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
        <link href="https://cdn.jsdelivr.net/npm/select2-bootstrap4-theme@1.0.0/dist/select2-bootstrap4.min.css" rel="stylesheet" />

        <style>
            body {
                background: #f9f9f9;
                padding-top: 80px;
            }
            .container {
                padding: 30px;
                margin-top: 30px;
            }
            h2 {
                color: #333;
                border-bottom: 2px solid #007BFF;
                padding-bottom: 8px;
                margin-bottom: 20px;
            }
            .add-link {
                margin-bottom: 15px;
                display: inline-block;
                background: #007BFF;
                color: #fff;
                padding: 8px 16px;
                border-radius: 4px;
                text-decoration: none;
            }
            .add-link:hover {
                background: #0056b3;
                color: #fff;
                text-decoration: none;
            }
            table {
                width: 100%;
                margin-top: 20px;
            }
            th, td {
                text-align: left;
                padding: 10px;
            }
            th {
                background: #007BFF;
                color: #fff;
            }
            tr:nth-child(even) {
                background: #f2f2f2;
            }
            .action-link {
                margin-right: 8px;
            }
            .alert {
                margin-bottom: 20px;
            }
            .filters {
                background: #fff;
                padding: 20px;
                border-radius: 5px;
                margin-bottom: 20px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }
            .pagination-info {
                margin: 15px 0;
                color: #666;
            }
            .badge {
                font-size: 0.8em;
            }
            .badge-success {
                background-color: #28a745;
            }
            .badge-warning {
                background-color: #ffc107;
                color: #212529;
            }

            /* Select2 custom styles */
            .select2-container--bootstrap4 .select2-selection--single {
                height: calc(1.5em + 0.75rem + 2px) !important;
                padding: 0.375rem 0.75rem !important;
                font-size: 1rem !important;
                line-height: 1.5 !important;
                border: 1px solid #ced4da !important;
                border-radius: 0.25rem !important;
            }

            .select2-container--bootstrap4 .select2-selection--single .select2-selection__rendered {
                padding-left: 0 !important;
                padding-right: 0 !important;
            }

            .select2-container--bootstrap4 .select2-selection--single .select2-selection__arrow {
                height: calc(1.5em + 0.75rem) !important;
            }

            /* Disable nice-select */
            .nice-select {
                display: none !important;
            }
        </style>
    </head>
    <body>
        <jsp:include page="../header.jsp" />
        <div class="container">
            <h2><i class="fas fa-clipboard-list"></i> Quản lý bài Test</h2>

            <!-- Success message -->
            <c:if test="${not empty message}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle"></i> ${message}
                    <button type="button" class="close" data-dismiss="alert">
                        <span>&times;</span>
                    </button>
                </div>
            </c:if>

            <!-- Error message -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-triangle"></i> ${error}
                    <button type="button" class="close" data-dismiss="alert">
                        <span>&times;</span>
                    </button>
                </div>
            </c:if>

            <!-- Filters -->
            <div class="filters">
                <form method="get" action="${pageContext.request.contextPath}/test" id="filterForm">
                    <div class="row">
                        <div class="col-md-3">
                            <label for="search">Tìm kiếm:</label>
                            <input type="text" class="form-control" id="search" name="search" 
                                   value="${searchKeyword}" placeholder="Tên hoặc mô tả test...">
                        </div>
                        <div class="col-md-3">
                            <label for="testType">Loại test:</label>
                            <select class="form-control select2-dropdown" id="testType" name="testType" data-theme="bootstrap4">
                                <option value="all" ${selectedTestType == 'all' ? 'selected' : ''}>Tất cả</option>
                                <option value="practice" ${selectedTestType == 'practice' ? 'selected' : ''}>Practice</option>
                                <option value="official" ${selectedTestType == 'official' ? 'selected' : ''}>Official</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label for="courseId">Khóa học:</label>
                            <select class="form-control select2-dropdown" id="courseId" name="courseId" data-theme="bootstrap4">
                                <option value="">Tất cả khóa học</option>
                                <c:forEach var="course" items="${courses}">
                                    <option value="${course.course_id}" ${selectedCourseId == course.course_id ? 'selected' : ''}>
                                        ${course.course_title}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label>&nbsp;</label>
                            <div>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-search"></i> Tìm kiếm
                                </button>
                                <a href="${pageContext.request.contextPath}/test" class="btn btn-secondary">
                                    <i class="fas fa-redo"></i> Reset
                                </a>
                            </div>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Action buttons -->
            <div class="mb-3">
                <a class="add-link" href="${pageContext.request.contextPath}/test?action=create">
                    <i class="fas fa-plus"></i> Thêm mới Test
                </a>
            </div>

            <!-- Pagination info -->
            <c:if test="${totalTests > 0}">
                <div class="pagination-info">
                    Hiển thị ${displayStart} - ${displayEnd} trong tổng số ${totalTests} bài test
                </div>
            </c:if>

            <!-- Tests table -->
            <div class="table-responsive">
                <table class="table table-bordered table-hover">
                    <thead>
                        <tr>
                            <th width="8%">ID</th>
                            <th width="25%">Tên Test</th>
                            <th width="30%">Mô tả</th>
                            <th width="10%">Loại</th>
                            <th width="12%">Khóa học</th>
                            <th width="8%">Câu hỏi</th>
                            <th width="15%">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty testList}">
                                <c:forEach var="test" items="${testList}">
                                    <tr>
                                        <td>${test.test_id}</td>
                                        <td>
                                            <strong>${test.test_name}</strong>
                                            <c:if test="${not empty test.course_name}">
                                                <br><small class="text-muted">${test.course_name}</small>
                                            </c:if>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${fn:length(test.test_description) > 100}">
                                                    ${fn:substring(test.test_description, 0, 100)}...
                                                </c:when>
                                                <c:otherwise>
                                                    ${test.test_description}
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${test.is_practice}">
                                                    <span class="badge badge-success">Practice</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-warning">Official</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty test.course_name}">
                                                    ${test.course_name}
                                                    <c:if test="${not empty test.chapter_name}">
                                                        <br><small class="text-muted">${test.chapter_name}</small>
                                                    </c:if>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">Standalone</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <span class="badge badge-info">${test.total_questions_assigned}</span>
                                        </td>
                                        <td>
                                            <a class="btn btn-sm btn-warning" 
                                               href="${pageContext.request.contextPath}/test?action=edit&id=${test.test_id}"
                                               title="Chỉnh sửa">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <a class="btn btn-sm btn-danger" 
                                               href="${pageContext.request.contextPath}/test?action=delete&id=${test.test_id}" 
                                               onclick="return confirm('Bạn chắc chắn muốn xoá test này?');"
                                               title="Xóa">
                                                <i class="fas fa-trash"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="7" class="text-center text-muted">
                                        <i class="fas fa-inbox fa-2x mb-2"></i><br>
                                        Không có bài test nào được tìm thấy
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
                <nav aria-label="Test pagination">
                    <ul class="pagination justify-content-center">
                        <!-- Previous page -->
                        <c:if test="${currentPage > 1}">
                            <li class="page-item">
                                <a class="page-link" href="?page=${currentPage - 1}&pageSize=${pageSize}&search=${searchKeyword}&testType=${selectedTestType}&courseId=${selectedCourseId}">
                                    <i class="fas fa-chevron-left"></i>
                                </a>
                            </li>
                        </c:if>

                        <!-- Page numbers -->
                        <c:forEach begin="${startPage}" end="${endPage}" var="pageNum">
                            <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                <a class="page-link" href="?page=${pageNum}&pageSize=${pageSize}&search=${searchKeyword}&testType=${selectedTestType}&courseId=${selectedCourseId}">
                                    ${pageNum}
                                </a>
                            </li>
                        </c:forEach>

                        <!-- Next page -->
                        <c:if test="${currentPage < totalPages}">
                            <li class="page-item">
                                <a class="page-link" href="?page=${currentPage + 1}&pageSize=${pageSize}&search=${searchKeyword}&testType=${selectedTestType}&courseId=${selectedCourseId}">
                                    <i class="fas fa-chevron-right"></i>
                                </a>
                            </li>
                        </c:if>
                    </ul>
                </nav>
            </c:if>
        </div>

        <jsp:include page="../footer.jsp" />

        <!-- Scripts -->
        <script src="/assets/js/disable-nice-select.js"></script>
        <script src="/assets/js/vendor/jquery-1.12.4.min.js"></script>
        <script src="/assets/js/bootstrap.min.js"></script>
        <!-- Select2 JS -->
        <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

        <script>
                                                   $(document).ready(function () {
                                                       // Force remove any nice-select elements that might have been created
                                                       $('.nice-select').remove();
                                                       $('select').removeClass('nice-select-processed');

                                                       // Prevent nice-select from being applied
                                                       if (typeof $.fn.niceSelect !== 'undefined') {
                                                           $.fn.niceSelect = function () {
                                                               return this;
                                                           };
                                                       }

                                                       // Initialize Select2 with delay to ensure nice-select is completely disabled
                                                       setTimeout(function () {
                                                           $('.select2-dropdown').each(function () {
                                                               var $this = $(this);
                                                               var theme = $this.data('theme') || 'bootstrap4';

                                                               // Remove any nice-select wrapper
                                                               if ($this.next('.nice-select').length) {
                                                                   $this.next('.nice-select').remove();
                                                               }

                                                               // Show the original select
                                                               $this.show();

                                                               // Initialize Select2
                                                               $this.select2({
                                                                   theme: theme,
                                                                   width: '100%',
                                                                   allowClear: false,
                                                                   placeholder: function () {
                                                                       return $(this).data('placeholder') || 'Chọn...';
                                                                   }
                                                               });
                                                           });
                                                       }, 100);

                                                       // Continuous monitoring to remove nice-select
                                                       setInterval(function () {
                                                           $('.nice-select').each(function () {
                                                               $(this).remove();
                                                           });
                                                       }, 500);

                                                       // Handle form submission
                                                       $('#filterForm').on('submit', function () {
                                                           $('.select2-dropdown').each(function () {
                                                               var $select = $(this);
                                                               var value = $select.val();
                                                               if (value) {
                                                                   $select.attr('value', value);
                                                               }
                                                           });
                                                       });
                                                   });
        </script>
    </body>
</html>
