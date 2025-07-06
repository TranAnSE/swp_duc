<%-- 
    Document   : pagination
    Created on : Jul 5, 2025, 7:28:28 PM
    Author     : ankha
--%>

<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Results Info -->
<div class="results-info">
    <div class="results-count">
        <c:choose>
            <c:when test="${totalItems > 0}">
                Showing ${displayStart} - ${displayEnd} of ${totalItems} ${itemType}
            </c:when>
            <c:otherwise>
                No ${itemType} found
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

        <c:if test="${not empty addNewUrl}">
            <a href="${addNewUrl}" class="btn btn-success">
                <i class="fas fa-plus"></i> Add New ${itemType}
            </a>
        </c:if>
    </div>
</div>

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

<!-- Pagination JavaScript -->
<script>
    function goToPage(pageNumber) {
        const form = document.getElementById('filterForm') || document.querySelector('form');
        if (form) {
            let pageInput = form.querySelector('input[name="page"]');
            if (!pageInput) {
                pageInput = document.createElement('input');
                pageInput.type = 'hidden';
                pageInput.name = 'page';
                form.appendChild(pageInput);
            }
            pageInput.value = pageNumber;
            form.submit();
        }
    }

    function changePageSize(newPageSize) {
        const form = document.getElementById('filterForm') || document.querySelector('form');
        if (form) {
            let pageSizeInput = form.querySelector('input[name="pageSize"]');
            if (!pageSizeInput) {
                pageSizeInput = document.createElement('input');
                pageSizeInput.type = 'hidden';
                pageSizeInput.name = 'pageSize';
                form.appendChild(pageSizeInput);
            }
            pageSizeInput.value = newPageSize;

            let pageInput = form.querySelector('input[name="page"]');
            if (!pageInput) {
                pageInput = document.createElement('input');
                pageInput.type = 'hidden';
                pageInput.name = 'page';
                form.appendChild(pageInput);
            }
            pageInput.value = 1; // Reset to first page

            form.submit();
        }
    }
</script>