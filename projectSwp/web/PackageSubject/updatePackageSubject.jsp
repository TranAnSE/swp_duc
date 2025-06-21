<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Cập nhật PackageSubject</title>

        <!-- CSS Libraries -->
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

        <style>
            html, body {
                height: 100%;
                margin: 0;
                padding: 0;
            }

            body {
                display: flex;
                flex-direction: column;
                min-height: 100vh;
                background-color: #f8f9fa;
            }

            main {
                flex: 1;
                padding-top: 80px;
            }

            .card {
                margin-bottom: 40px;
            }

            .text-danger {
                font-size: 0.875rem;
            }
        </style>
    </head>
    <body>

        <%@include file="../header.jsp" %>

        <main>
            <div class="container py-5">
                <div class="row justify-content-center">
                    <div class="col-md-6">
                        <div class="card shadow-sm">
                            <div class="card-header bg-warning text-white text-center">
                                <h5 class="mb-0">Cập nhật PackageSubject</h5>
                            </div>
                            <div class="card-body">
                                <form method="post" action="packageSubjectURL" onsubmit="return validateUpdateForm()">
                                    <input type="hidden" name="action" value="update" />
                                    <input type="hidden" name="old_package_id" value="${ps.package_id}" />
                                    <input type="hidden" name="old_subject_id" value="${ps.subject_id}" />

                                    <div class="mb-3">
                                        <label for="package_id" class="form-label">Package ID</label>
                                        <input type="number" class="form-control" id="package_id" name="package_id" value="${ps.package_id}" required />
                                        <div id="packageError" class="text-danger"></div>
                                    </div>

                                    <div class="mb-3">
                                        <label for="subject_id" class="form-label">Subject</label>
                                        <select id="subject_id" name="subject_id" class="form-select nice-select wide">
                                            <option value="">-- Chọn Subject --</option>
                                            <c:forEach var="s" items="${subject}">
                                                <option value="${s.id}" <c:if test="${s.id == ps.subject_id}">selected</c:if>>${s.name}</option>
                                            </c:forEach>
                                        </select>
                                        <div id="subjectError" class="text-danger"></div>
                                    </div>

                                    <div class="d-grid gap-2">
                                        <button type="submit" class="btn btn-warning text-white">Cập nhật</button>
                                        <a href="packageSubjectURL" class="btn btn-outline-secondary">Quay lại danh sách</a>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <%@include file="../footer.jsp" %>

        <!-- JS -->
        <script src="/assets/js/jquery-1.12.4.min.js"></script>
        <script src="/assets/js/bootstrap.min.js"></script>
        <script src="/assets/js/jquery.nice-select.min.js"></script>
        <!-- JS Libraries -->
        <script src="${pageContext.request.contextPath}/assets/js/vendor/modernizr-3.5.0.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/vendor/jquery-1.12.4.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/popper.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.slicknav.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/owl.carousel.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/slick.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/wow.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/animated.headline.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.magnific-popup.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/gijgo.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.nice-select.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.sticky.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.barfiller.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.counterup.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/waypoints.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.countdown.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/hover-direction-snake.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/contact.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.form.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.validate.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/mail-script.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.ajaxchimp.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/plugins.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>

        <script>
                                    $(document).ready(function () {
                                        $('select').niceSelect();
                                    });

                                    function validateUpdateForm() {
                                        let isValid = true;

                                        document.getElementById("packageError").innerText = "";
                                        document.getElementById("subjectError").innerText = "";

                                        const packageId = document.getElementById("package_id").value.trim();
                                        const subjectId = document.getElementById("subject_id").value;

                                        if (packageId === "") {
                                            document.getElementById("packageError").innerText = "Vui lòng nhập Package ID.";
                                            isValid = false;
                                        }

                                        if (subjectId === "") {
                                            document.getElementById("subjectError").innerText = "Vui lòng chọn một Subject.";
                                            isValid = false;
                                        }

                                        return isValid;
                                    }
        </script>

    </body>
</html>
