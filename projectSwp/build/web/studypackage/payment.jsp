<%-- 
    Document   : payment
    Created on : Jun 14, 2025, 10:35:50 AM
    Author     : ledai
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Xác nhận thanh toán</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
        }
        .container {
            max-width: 800px;
            margin: 30px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        h2 {
            color: #333;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }
        .package-info {
            background-color: #f9f9f9;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .price {
            font-size: 1.2em;
            font-weight: bold;
            color: #e74c3c;
        }
        .btn {
            display: inline-block;
            padding: 10px 15px;
            background-color: #3498db;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            font-size: 16px;
            margin-top: 10px;
        }
        .btn:hover {
            background-color: #2980b9;
        }
        .btn-payment {
            background-color: #27ae60;
        }
        .btn-payment:hover {
            background-color: #219955;
        }
        .btn-cancel {
            background-color: #e74c3c;
            margin-left: 10px;
        }
        .btn-cancel:hover {
            background-color: #c0392b;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Xác nhận thanh toán</h2>
        
        <div class="package-info">
            <h3>Thông tin gói học</h3>
            <p><strong>Tên gói:</strong> ${packageName}</p>
            <p><strong>Giá:</strong> <span class="price">${amount} VND</span></p>
        </div>
        
        <div>
            <h3>Chọn phương thức thanh toán</h3>
            
            <form action="${pageContext.request.contextPath}/payment" method="post">
                <input type="hidden" name="packageId" value="${packageId}">
                <input type="hidden" name="amount" value="${amount}">
                
                <button type="submit" class="btn btn-payment">Thanh toán qua VNPay</button>
                <a href="${pageContext.request.contextPath}/study_package" class="btn btn-cancel">Hủy</a>
            </form>
        </div>
    </div>
</body>
</html> 