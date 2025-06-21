<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="model.Invoice" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
    <head>
        <title>Sửa Hóa đơn</title>

        <style>
            html, body {
                margin: 0;
                padding: 0;
                height: 100%;
                font-family: Arial, sans-serif;
                background-color: #f9f9f9;
            }

            .page-wrapper {
                display: flex;
                flex-direction: column;
                min-height: 100vh;
            }

            main {
                flex: 1;
                padding: 100px 20px 20px 20px;
                max-width: 600px;
                margin: 0 auto;
            }

            h2 {
                margin-bottom: 20px;
            }

            form {
                background: white;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
            }

            .form-group {
                margin-bottom: 15px;
            }

            label {
                font-weight: bold;
                margin-bottom: 5px;
                display: block;
            }

            input, select {
                width: 100%;
                padding: 8px;
                border: 1px solid #ccc;
                border-radius: 4px;
            }

            input[type="submit"] {
                background-color: #007BFF;
                color: white;
                border: none;
                cursor: pointer;
            }

            input[type="submit"]:hover {
                background-color: #0056b3;
            }

            a {
                display: inline-block;
                margin-top: 15px;
                color: #007bff;
            }

            footer {
                text-align: center;
                padding: 10px;
            }
        </style>
    </head>
    <body>
        <div class="page-wrapper">
            <%@include file="../header.jsp" %>
            <link rel="stylesheet" href="/assets/css/bootstrap.min.css">
            <link rel="stylesheet" href="/assets/css/owl.carousel.min.css">
            <link rel="stylesheet" href="/assets/css/slicknav.css">
            <link rel="stylesheet" href="/assets/css/flaticon.css">
            <link rel="stylesheet" href="/assets/css/progressbar_barfiller.css">
            <link rel="stylesheet" href="/assets/css/gijgo.css">
            <link rel="stylesheet" href="/assets/css/animate.min.css">
            <link rel="stylesheet" href="/assets/css/animated-headline.css">
            <link rel="stylesheet" href="/assets/css/magnific-popup.css">
            <link rel="stylesheet" href="/assets/css/fontawesome-all.min.css">
            <link rel="stylesheet" href="/assets/css/themify-icons.css">
            <link rel="stylesheet" href="/assets/css/slick.css">
            <link rel="stylesheet" href="/assets/css/nice-select.css">
            <link rel="stylesheet" href="/assets/css/style.css">

            <main>
                <%
                    Invoice invoice = (Invoice) request.getAttribute("invoice");
                    if (invoice == null) {
                %>
                <p style="color:red;">Hóa đơn không tồn tại hoặc lỗi tải dữ liệu.</p>
                <a href="invoice">Quay lại danh sách</a>
                <%
                    } else {
                %>
                <h2>Sửa Hóa đơn</h2>
                <form action="invoice" method="post">
                    <input type="hidden" name="action" value="update" />
                    <input type="hidden" name="id" value="<%= invoice.getId() %>" />

                    <div class="form-group">
                        <label>Tổng tiền:</label>
                        <input type="text" name="total_amount" value="<%= invoice.getTotal_amount() %>" required />
                    </div>

                    <div class="form-group">
                        <label>Parent ID:</label>
                        <input type="number" name="parent_id" value="<%= invoice.getParent_id() %>" required />
                    </div>

                    <div class="form-group">
                        <label>Ngày tạo:</label>
                        <input type="date" name="created_at" value="<%= invoice.getCreated_at() %>" required />
                    </div>

                    <div class="form-group">
                        <label>Trạng thái:</label>
                        <select name="status" required>
                            <option value="Chưa thanh toán" <%= "Chưa thanh toán".equals(invoice.getStatus()) ? "selected" : "" %>>Chưa thanh toán</option>
                            <option value="Đã thanh toán" <%= "Đã thanh toán".equals(invoice.getStatus()) ? "selected" : "" %>>Đã thanh toán</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Ngày thanh toán (nếu có):</label>
                        <input type="date" name="pay_at" value="<%= invoice.getPay_at() != null ? invoice.getPay_at() : "" %>" />
                    </div>

                    <input type="submit" value="Cập nhật hóa đơn" />
                </form>

                <a href="invoice">Quay lại danh sách</a>
                <%
                    }
                %>
            </main>

            <%@include file="../footer.jsp" %>
        </div>

        <!-- JS -->
        <script src="${pageContext.request.contextPath}/assets/js/vendor/modernizr-3.5.0.min.js"></script>
        <!-- Jquery, Popper, Bootstrap -->
        <script src="${pageContext.request.contextPath}/assets/js/vendor/jquery-1.12.4.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/popper.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>
        <!-- Jquery Mobile Menu -->
        <script src="${pageContext.request.contextPath}/assets/js/jquery.slicknav.min.js"></script>

        <!-- Jquery Slick , Owl-Carousel Plugins -->
        <script src="${pageContext.request.contextPath}/assets/js/owl.carousel.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/slick.min.js"></script>
        <!-- One Page, Animated-HeadLin -->
        <script src="${pageContext.request.contextPath}/assets/js/wow.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/animated.headline.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.magnific-popup.js"></script>

        <!-- Date Picker -->
        <script src="${pageContext.request.contextPath}/assets/js/gijgo.min.js"></script>
        <!-- Nice-select, sticky -->
        <script src="${pageContext.request.contextPath}/assets/js/jquery.nice-select.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.sticky.js"></script>
        <!-- Progress -->
        <script src="${pageContext.request.contextPath}/assets/js/jquery.barfiller.js"></script>

        <!-- counter , waypoint,Hover Direction -->
        <script src="${pageContext.request.contextPath}/assets/js/jquery.counterup.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/waypoints.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.countdown.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/hover-direction-snake.min.js"></script>

        <!-- contact js -->
        <script src="${pageContext.request.contextPath}/assets/js/contact.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.form.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.validate.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/mail-script.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.ajaxchimp.min.js"></script>

        <!-- Jquery Plugins, main Jquery -->	
        <script src="${pageContext.request.contextPath}/assets/js/plugins.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
        <script>
            $(document).ready(function () {
                $('select').niceSelect();
            });
        </script>
    </body>
</html>
