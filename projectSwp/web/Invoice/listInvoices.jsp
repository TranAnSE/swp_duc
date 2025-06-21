<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Invoice" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="manifest" href="site.webmanifest">
        <link rel="shortcut icon" type="image/x-icon" href="assets/img/favicon.ico">
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
        <title>Danh sách Hóa đơn</title>
        <style>
            html, body {
                margin: 0;
                padding-top:  40px;
                height: 100%;
                font-family: Arial, sans-serif;
                background-color: #f9f9f9;
            }

            .page-wrapper {
                display: flex;
                flex-direction: column;
                min-height: 100vh;
            }

            header, footer {
                background-color: #f1f1f1;
            }

            main {
                flex: 1;
                padding: 100px 20px 20px 20px;
                max-width: 1000px;
                margin: 0 auto;
            }

            h2 {
                margin-bottom: 20px;
            }

            table {
                border-collapse: collapse;
                width: 100%;
                background-color: white;
                border-radius: 6px;
                overflow: hidden;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }

            th, td {
                border: 1px solid #ddd;
                padding: 10px;
                text-align: left;
            }

            th {
                background-color: #f2f2f2;
            }

            a {
                margin-right: 8px;
                color: #007bff;
                text-decoration: none;
            }

            a:hover {
                text-decoration: underline;
            }

            .add-link {
                display: inline-block;
                margin-top: 20px;
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
            <main>
                <h2>Danh sách Hóa đơn</h2>
                <table>
                    <tr>
                        <th>ID</th>
                        <th>Tổng tiền</th>
                        <th>Parent ID</th>
                        <th>Ngày tạo</th>
                        <th>Trạng thái</th>
                        <th>Ngày thanh toán</th>
                        <th>Hành động</th>
                    </tr>
                    <%
                        List<Invoice> invoices = (List<Invoice>) request.getAttribute("invoices");
                        if (invoices != null) {
                            for (Invoice invoice : invoices) {
                    %>
                    <tr>
                        <td><%= invoice.getId() %></td>
                        <td><%= invoice.getTotal_amount() %></td>
                        <td><%= invoice.getParent_id() %></td>
                        <td><%= invoice.getCreated_at() %></td>
                        <td><%= invoice.getStatus() %></td>
                        <td><%= invoice.getPay_at() != null ? invoice.getPay_at() : "" %></td>
                        <td>
                            <a href="invoice?action=edit&id=<%= invoice.getId() %>">Sửa</a>
                            <a href="invoice?action=delete&id=<%= invoice.getId() %>" onclick="return confirm('Xác nhận xoá?');">Xoá</a>
                        </td>
                    </tr>
                    <%
                            }
                        }
                    %>
                </table>

                <a class="add-link" href="invoice?action=create">➕ Thêm mới Hóa đơn</a>
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
