<%-- 
    Document   : paymentResult
    Created on : Jun 14, 2025, 10:37:31 AM
    Author     : ledai
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết quả thanh toán</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
            text-align: center;
        }
        .container {
            max-width: 800px;
            margin: 50px auto;
            padding: 30px;
            background-color: #fff;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .icon {
            font-size: 60px;
            margin-bottom: 20px;
        }
        .success {
            color: #27ae60;
        }
        .error {
            color: #e74c3c;
        }
        .pending {
            color: #f39c12;
        }
        h2 {
            margin-bottom: 20px;
        }
        p {
            color: #666;
            line-height: 1.6;
            margin-bottom: 15px;
        }
        .contact {
            font-size: 20px;
            color: #e74c3c;
            margin: 15px 0;
            font-weight: bold;
        }
        .btn {
            display: inline-block;
            padding: 10px 20px;
            background-color: #3498db;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            margin-top: 20px;
            transition: background-color 0.3s;
        }
        .btn:hover {
            background-color: #2980b9;
        }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" 
          integrity="sha512-z3gLpd7yknf1YoNbCzqRKc4qyor8gaKU1qmn+CShxbuBusANI9QpRohGBreCFkKxLhei6S9CQXFEbbKuqLg0DA==" 
          crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>
<body>
    <div class="container">
        <!-- Giao dịch thành công -->
        <c:if test="${transResult == true}">
            <div class="icon success">
                <i class="fas fa-check-circle"></i>
            </div>
            <h2>Thanh toán thành công!</h2>
            <p>Cảm ơn bạn đã mua gói học. Bạn có thể bắt đầu học ngay bây giờ.</p>
            <p>Nếu có bất kỳ vấn đề gì, vui lòng liên hệ với chúng tôi qua:</p>
            <div class="contact">
                <i class="fas fa-phone"></i> 0383459560
            </div>
        </c:if>

        <!-- Giao dịch thất bại -->
        <c:if test="${transResult == false}">
            <div class="icon error">
                <i class="fas fa-times-circle"></i>
            </div>
            <h2>Thanh toán thất bại!</h2>
            <p>Đã xảy ra lỗi trong quá trình thanh toán. Vui lòng thử lại sau.</p>
            <p>Nếu tiền đã bị trừ từ tài khoản của bạn, vui lòng liên hệ với chúng tôi qua:</p>
            <div class="contact">
                <i class="fas fa-phone"></i> 0383459560
            </div>
        </c:if>

        <!-- Đang xử lý giao dịch -->
        <c:if test="${transResult == null}">
            <div class="icon pending">
                <i class="fas fa-spinner fa-spin"></i>
            </div>
            <h2>Đang xử lý thanh toán...</h2>
            <p>Giao dịch của bạn đang được xử lý. Vui lòng không đóng trang này.</p>
            <p>Quá trình này có thể mất vài phút. Cảm ơn bạn đã kiên nhẫn chờ đợi.</p>
        </c:if>
        
        <a href="${pageContext.request.contextPath}/study_package" class="btn">
            <i class="fas fa-arrow-left"></i> Quay lại danh sách gói học
        </a>
    </div>
</body>
</html> 