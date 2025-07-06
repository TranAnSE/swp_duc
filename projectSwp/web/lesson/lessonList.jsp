<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Lesson List</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- CSS -->
        <link rel="stylesheet" href="/assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="/assets/css/style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
        <!-- Select2 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
        <style>
            body {
                padding-top: 130px;
                background-color: #f8f9fa;
            }

            main {
                max-width: 1400px;
                margin: 40px auto;
                padding: 20px;
                background: white;
                border-radius: 12px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }

            .content-preview {
                max-width: 250px;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
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
        <jsp:include page="/header.jsp" />

        <main>
            <h2 class="mb-4 text-primary">Lesson List</h2>

            <!-- Filter Section -->
            <div class="filter-section">
                <form method="get" action="LessonURL" id="filterForm">
                    <div class="filter-row">
                        <div class="filter-group">
                            <label for="nameFilter">Lesson Name:</label>
                            <input type="text" id="nameFilter" name="name" 
                                   placeholder="Search by name..." 
                                   value="${selectedName}">
                        </div>

                        <div class="filter-group">
                            <label for="chapterFilter">Chapter:</label>
                            <select id="chapterFilter" name="chapterId">
                                <option value="">All Chapters</option>
                                <c:forEach var="chap" items="${chapter}">
                                    <option value="${chap.id}" 
                                            ${selectedChapterId != null && selectedChapterId == chap.id ? 'selected' : ''}>
                                        ${chap.name}
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

            <!-- Alerts -->
            <c:if test="${not empty message}">
                <div class="alert alert-success">${message}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <!-- Results Info -->
            <div class="results-info">
                <div class="results-count">
                    <c:choose>
                        <c:when test="${totalLessons > 0}">
                            <div class="results-count">
                                <c:choose>
                                    <c:when test="${totalLessons > 0}">
                                        Showing ${displayStart} - ${displayEnd} of ${totalLessons} lessons
                                    </c:when>
                                    <c:otherwise>
                                        No lessons found
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:when>
                        <c:otherwise>
                            No lessons found
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

                    <a href="LessonURL?action=addForm" class="btn btn-success">Add New Lesson</a>
                </div>
            </div>

            <!-- Table -->
            <table class="table table-bordered table-hover bg-white">
                <thead class="table-primary">
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Content</th>
                        <th>Chapter</th>
                        <th>Video</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty lessonList}">
                            <c:forEach var="lesson" items="${lessonList}">
                                <tr>
                                    <td>${lesson.id}</td>
                                    <td><strong>${lesson.name}</strong></td>
                                    <td>
                                        <div class="content-preview">${lesson.content}</div>
                                    </td>
                                    <td>
                                        <c:forEach var="chap" items="${chapter}">
                                            <c:if test="${lesson.chapter_id == chap.id}">
                                                <span class="badge bg-info">${chap.name}</span>
                                            </c:if>
                                        </c:forEach>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty lesson.video_link}">
                                                <a href="LessonURL?action=videoViewer&id=${lesson.id}" 
                                                   class="btn btn-sm btn-outline-primary" target="_blank">
                                                    <i class="fas fa-play"></i> Watch
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">No video</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="btn-group" role="group">
                                            <a href="LessonURL?action=updateForm&id=${lesson.id}" 
                                               class="btn btn-sm btn-warning">
                                                <i class="fas fa-edit"></i> Edit
                                            </a>
                                            <a href="LessonURL?action=delete&id=${lesson.id}" 
                                               class="btn btn-sm btn-danger" 
                                               onclick="return confirm('Are you sure you want to delete this lesson?')">
                                                <i class="fas fa-trash"></i> Delete
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="6" class="text-center text-muted py-4">
                                    <i class="fas fa-book-open fa-3x mb-3"></i>
                                    <br>No lessons found.
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
        </main>

        <jsp:include page="/footer.jsp" />

        <!-- JS -->
        <script src="/assets/js/vendor/jquery-1.12.4.min.js"></script>
        <script src="/assets/js/bootstrap.min.js"></script>
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
                                   $('select').each(function () {
                                       if ($(this).hasClass('select2-hidden-accessible')) {
                                           $(this).select2('destroy');
                                       }
                                       // Remove nice-select if exists
                                       if ($(this).next('.nice-select').length) {
                                           $(this).next('.nice-select').remove();
                                           $(this).show();
                                       }
                                   });

                                   // Initialize Select2 for all select elements
                                   $('select').select2({
                                       placeholder: function () {
                                           return $(this).find('option:first').text() || 'All Chapters';
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
                                   $('#chapterFilter').val('').trigger('change');
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

                               // Auto-dismiss alerts after 5 seconds
                               setTimeout(function () {
                                   $('.alert').fadeOut('slow');
                               }, 5000);
        </script>
    </body>
</html>