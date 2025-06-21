<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Children</title>
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    
    <style>
        .child-card {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        
        .child-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            object-fit: cover;
        }
        
        .no-children {
            text-align: center;
            padding: 60px 20px;
        }
    </style>
</head>
<body>
<div class="page-wrapper">
    <jsp:include page="/header.jsp" />
    
    <main class="container mt-4">
        <h2><i class="fa fa-users"></i> My Children</h2>
        <p>Danh sách con em của: <strong>${parent.full_name}</strong></p>
        
        <div class="mb-3">
            <a href="${pageContext.request.contextPath}/student?action=create&fromParent=true" 
               class="btn btn-success">
                <i class="fa fa-plus"></i> Thêm con
            </a>
        </div>
        
        <c:choose>
            <c:when test="${empty children}">
                <div class="no-children">
                    <h4>Chưa có con em nào</h4>
                    <p>Vui lòng liên hệ nhà trường để được hỗ trợ.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row">
                    <c:forEach var="child" items="${children}">
                        <div class="col-lg-6">
                            <div class="child-card">
                                <div class="row">
                                    <div class="col-auto">
                                        <c:forEach items="${imageList}" var="img">
                                            <c:if test="${img.id == child.image_id}">
                                                <img src="${pageContext.request.contextPath}/${img.image_data}" 
                                                     alt="${child.full_name}" class="child-avatar">
                                            </c:if>
                                        </c:forEach>
                                    </div>
                                    <div class="col">
                                        <h5>${child.full_name}</h5>
                                        <p>ID: ${child.id}</p>
                                        <p>Username: ${child.username}</p>
                                        <p>Giới tính: ${child.sex ? 'Nam' : 'Nữ'}</p>
                                        <c:forEach items="${gradeList}" var="grade">
                                            <c:if test="${grade.id == child.grade_id}">
                                                <p>Lớp: ${grade.name}</p>
                                            </c:if>
                                        </c:forEach>
                                        <p>
                                            <a href="${pageContext.request.contextPath}/student?action=viewProfile&id=${child.id}" 
                                               class="btn btn-primary btn-sm">
                                                <i class="fa fa-eye"></i> Xem chi tiết
                                            </a>
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </main>
    
    <jsp:include page="/footer.jsp" />
</div>

<script src="${pageContext.request.contextPath}/assets/js/vendor/jquery-1.12.4.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>
</body>
</html> 