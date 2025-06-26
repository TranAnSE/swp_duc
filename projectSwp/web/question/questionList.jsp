<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
    <head>
        <title>Question List</title>

        <!-- Bootstrap CSS -->
        <!-- External CSS -->
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

        <!-- Internal CSS -->

        <style>
            body {
                display: flex;
                flex-direction: column;
                min-height: 100vh;
                font-family: Arial, sans-serif;
                background-color: #f9f9f9;
                padding-top: 120px;
            }
            th, td {
                vertical-align: middle;
                text-align: center;
            }
            img.img-thumbnail {
                object-fit: cover;
            }

            /* Bootstrap Dropdown Fixes */
            .dropdown {
                position: relative;
                z-index: 1050;
            }

            .dropdown-menu {
                position: absolute;
                top: 100%;
                left: 0;
                z-index: 1000;
                display: none;
                min-width: 10rem;
                padding: 0.5rem 0;
                margin: 0.125rem 0 0;
                font-size: 1rem;
                color: var(--text-primary);
                text-align: left;
                list-style: none;
                background-color: #fff;
                background-clip: padding-box;
                border: 1px solid rgba(0, 0, 0, 0.15);
                border-radius: 0.375rem;
                box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.175);
                opacity: 0;
                transform: translateY(-10px);
                transition: all 0.2s ease-in-out;
                pointer-events: none;
                cursor: default;
            }

            .dropdown-menu.show {
                display: block;
                opacity: 1;
                transform: translateY(0);
                pointer-events: auto;
            }

            .dropdown-item {
                display: block;
                width: 100%;
                padding: 0.375rem 1rem;
                clear: both;
                font-weight: 400;
                color: var(--text-primary);
                text-align: inherit;
                text-decoration: none;
                white-space: nowrap;
                background-color: transparent;
                border: 0;
                transition: background-color 0.15s ease-in-out, color 0.15s ease-in-out;
                cursor: pointer;
            }

            .dropdown-item:hover,
            .dropdown-item:focus {
                color: var(--primary-color);
                background-color: rgba(79, 70, 229, 0.1);
            }

            .dropdown-item:active {
                color: #fff;
                background-color: var(--primary-color);
            }

            .dropdown-toggle::after {
                display: inline-block;
                margin-left: 0.255em;
                vertical-align: 0.255em;
                content: "";
                border-top: 0.3em solid;
                border-right: 0.3em solid transparent;
                border-bottom: 0;
                border-left: 0.3em solid transparent;
            }

            .dropdown-toggle:empty::after {
                margin-left: 0;
            }

            /* Enhanced Quick Actions Button */
            .btn-outline-secondary {
                color: var(--text-secondary);
                border-color: var(--border-color);
                background-color: white;
                transition: all 0.3s ease;
            }

            .btn-outline-secondary:hover {
                color: var(--primary-color);
                background-color: rgba(79, 70, 229, 0.1);
                border-color: var(--primary-color);
            }

            .btn-outline-secondary:focus {
                box-shadow: 0 0 0 0.2rem rgba(79, 70, 229, 0.25);
            }

            /* Ensure dropdown works with our custom styling */
            .dropdown-menu {
                border: 2px solid var(--primary-color) !important;
                border-radius: 12px !important;
                box-shadow: var(--shadow-lg) !important;
                padding: 8px 0 !important;
            }

            .dropdown-item {
                padding: 12px 20px !important;
                font-size: 1.5rem !important;
                border-radius: 0 !important;
                transition: all 0.2s ease !important;
            }

            .dropdown-item i {
                color: var(--primary-color);
                width: 20px;
            }

            .dropdown-item:hover i {
                color: var(--primary-color);
            }
        </style>
    </head>

    <body class="bg-light">
        <!-- Include header -->
        <jsp:include page="/header.jsp" />

        <div class="container mt-5 mb-5">
            <h2 class="mb-4">Question List</h2>

            <form method="get" action="Question" class="mb-4 d-flex gap-2">
                <input type="text" name="question" class="form-control w-25" placeholder="Search by question..." />
                <button type="submit" class="btn btn-primary">Search</button>
            </form>

            <table class="table table-bordered table-striped table-hover">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Question</th>
                        <th>Image</th>
                        <th>Lesson Name</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="q" items="${questionList}">
                        <tr>
                            <td>${q.id}</td>
                            <td>${q.question}</td>
                            <td>
                                <c:forEach var="img" items="${images}">
                                    <c:if test="${img.id == q.image_id}">
                                        <img src="data:image/jpg;base64, ${img.image_data}" alt="Ảnh câu hỏi" width="100" height="100" class="img-thumbnail">
                                    </c:if>
                                </c:forEach>
                            </td>
                            <td>
                                <c:forEach var="l" items="${les}">
                                    <c:if test="${q.lesson_id eq l.id}">
                                        ${l.name}
                                    </c:if>
                                </c:forEach>
                            </td>
                            <td>
                                <a href="Question?action=updateForm&id=${q.id}" class="btn btn-sm btn-warning">Edit</a>
                                <a href="Question?action=delete&id=${q.id}" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure?');">Delete</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <div class="mb-4">
                <div class="row">
                    <div class="col-md-8">
                        <div class="btn-group" role="group" aria-label="Question creation options">
                            <a href="Question?action=addForm" class="btn btn-success btn-lg">
                                <i class="fas fa-plus me-2"></i>
                                Manual Entry
                            </a>
                            <a href="/ai-question?action=form" class="btn btn-primary btn-lg">
                                <i class="fas fa-cogs me-2"></i>
                                AI Generator
                            </a>
                        </div>
                    </div>
                    <div class="col-md-4 text-end">
                        <div class="dropdown">
                            <button class="btn btn-outline-secondary dropdown-toggle" type="button" 
                                    data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="fas fa-cog me-2"></i>Quick Actions
                            </button>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item" href="/ai-question?action=form&type=single_choice">
                                        <i class="fas fa-dot-circle me-2"></i>Generate Single Choice
                                    </a></li>
                                <li><a class="dropdown-item" href="/ai-question?action=form&type=multiple_choice">
                                        <i class="fas fa-check-square me-2"></i>Generate Multiple Choice
                                    </a></li>
                                <li><a class="dropdown-item" href="/ai-question?action=form&type=true_false">
                                        <i class="fas fa-balance-scale me-2"></i>Generate True/False
                                    </a></li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Include footer -->
        <jsp:include page="/footer.jsp" />

        <!-- JS Libraries -->
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

        <script>
                                    $(document).ready(function () {
                                        // Enhanced Bootstrap dropdown handling
                                        if (typeof bootstrap !== 'undefined') {
                                            // Bootstrap 5 is loaded - initialize dropdowns
                                            var dropdownElementList = [].slice.call(document.querySelectorAll('.dropdown-toggle'));
                                            var dropdownList = dropdownElementList.map(function (dropdownToggleEl) {
                                                return new bootstrap.Dropdown(dropdownToggleEl);
                                            });
                                        } else {
                                            // Fallback: Manual dropdown implementation with proper closing
                                            $('.dropdown-toggle').click(function (e) {
                                                e.preventDefault();
                                                e.stopPropagation();

                                                var $dropdown = $(this).closest('.dropdown');
                                                var $menu = $dropdown.find('.dropdown-menu');
                                                var isOpen = $menu.hasClass('show');

                                                // Close all other dropdowns first
                                                $('.dropdown-menu').removeClass('show');
                                                $('.dropdown-toggle').attr('aria-expanded', 'false');

                                                // Toggle current dropdown
                                                if (!isOpen) {
                                                    $menu.addClass('show');
                                                    $(this).attr('aria-expanded', 'true');
                                                }
                                            });
                                        }

                                        // Universal dropdown closing handlers
                                        $(document).on('click', function (e) {
                                            // Close Bootstrap dropdowns when clicking outside
                                            if (!$(e.target).closest('.dropdown').length) {
                                                $('.dropdown-menu').removeClass('show');
                                                $('.dropdown-toggle').attr('aria-expanded', 'false');

                                                // Also trigger Bootstrap's hide if available
                                                if (typeof bootstrap !== 'undefined') {
                                                    $('.dropdown-toggle').each(function () {
                                                        var dropdown = bootstrap.Dropdown.getInstance(this);
                                                        if (dropdown) {
                                                            dropdown.hide();
                                                        }
                                                    });
                                                }
                                            }
                                        });

                                        // Close dropdown when clicking on dropdown items
                                        $(document).on('click', '.dropdown-item', function (e) {
                                            // Allow the link to work, but close the dropdown
                                            setTimeout(function () {
                                                $('.dropdown-menu').removeClass('show');
                                                $('.dropdown-toggle').attr('aria-expanded', 'false');
                                            }, 100);
                                        });

                                        // Close dropdown when pressing Escape key
                                        $(document).on('keydown', function (e) {
                                            if (e.key === 'Escape' || e.keyCode === 27) {
                                                $('.dropdown-menu').removeClass('show');
                                                $('.dropdown-toggle').attr('aria-expanded', 'false');

                                                if (typeof bootstrap !== 'undefined') {
                                                    $('.dropdown-toggle').each(function () {
                                                        var dropdown = bootstrap.Dropdown.getInstance(this);
                                                        if (dropdown) {
                                                            dropdown.hide();
                                                        }
                                                    });
                                                }
                                            }
                                        });

                                        // Initialize nice-select with proper configuration
                                        $('select.wide').niceSelect();

                                        // Handle lesson selection with nice-select compatibility
                                        $('#lessonSelect').on('change', function () {
                                            const selectedValue = $(this).val();
                                            const selectedOption = $(this).find('option[value="' + selectedValue + '"]');
                                            const content = selectedOption.data('content');

                                            if (content && selectedValue) {
                                                $('#lessonContent').text(content);
                                                $('#lessonPreview').slideDown(300);
                                            } else {
                                                $('#lessonPreview').slideUp(300);
                                            }
                                        });

                                        // Handle question type selection
                                        $('.question-type-card').click(function () {
                                            $('.question-type-card').removeClass('selected');
                                            $(this).addClass('selected');
                                            $(this).find('input[type="radio"]').prop('checked', true);

                                            // Add animation effect
                                            $(this).addClass('animate__animated animate__pulse');
                                            setTimeout(() => {
                                                $(this).removeClass('animate__animated animate__pulse');
                                            }, 600);
                                        });

                                        // Handle difficulty selection
                                        $('.difficulty-option').click(function () {
                                            $('.difficulty-option').removeClass('selected');
                                            $(this).addClass('selected');
                                            $(this).find('input[type="radio"]').prop('checked', true);
                                        });

                                        // Initialize selected states
                                        $('input[name="question_type"]:checked').closest('.question-type-card').addClass('selected');
                                        $('input[name="difficulty"]:checked').closest('.difficulty-option').addClass('selected');

                                        // Enhanced dropdown click handling for nice-select (separate from Bootstrap dropdown)
                                        $(document).on('click', '.nice-select', function (e) {
                                            e.stopPropagation();
                                            $('.nice-select').not(this).removeClass('open');
                                            $(this).toggleClass('open');
                                        });

                                        // Close nice-select dropdown when clicking outside (separate handler)
                                        $(document).on('click', function (e) {
                                            if (!$(e.target).closest('.nice-select').length) {
                                                $('.nice-select').removeClass('open');
                                            }
                                        });

                                        // Form validation and submission
                                        $('#aiQuestionForm').submit(function (e) {
                                            const lessonId = $('#lessonSelect').val();
                                            const numberOfQuestions = $('#numberOfQuestions').val();

                                            if (!lessonId) {
                                                e.preventDefault();
                                                showAlert('Please select a lesson', 'danger');
                                                $('#lessonSelect').focus();
                                                return false;
                                            }

                                            if (numberOfQuestions < 1 || numberOfQuestions > 20) {
                                                e.preventDefault();
                                                showAlert('Number of questions must be between 1 and 20', 'danger');
                                                $('#numberOfQuestions').focus();
                                                return false;
                                            }

                                            // Show loading state
                                            const submitBtn = $(this).find('button[type="submit"]');
                                            const originalText = submitBtn.html();
                                            submitBtn.prop('disabled', true)
                                                    .html('<i class="fas fa-spinner fa-spin me-2"></i>Generating Questions...');

                                            // Add loading overlay
                                            $('body').append(`
                <div id="loadingOverlay" style="
                    position: fixed;
                    top: 0;
                    left: 0;
                    width: 100%;
                    height: 100%;
                    background: rgba(0, 0, 0, 0.5);
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    z-index: 9999;
                ">
                    <div style="
                        background: white;
                        padding: 30px;
                        border-radius: 15px;
                        text-align: center;
                        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
                    ">
                        <i class="fas fa-robot fa-3x text-primary mb-3"></i>
                        <h4>AI is generating your questions...</h4>
                        <p class="text-muted">This may take a few moments</p>
                        <div class="spinner-border text-primary" role="status">
                            <span class="visually-hidden">Loading...</span>
                        </div>
                    </div>
                </div>
            `);

                                            // If form submission fails, restore button
                                            setTimeout(() => {
                                                if ($('#loadingOverlay').length) {
                                                    $('#loadingOverlay').remove();
                                                    submitBtn.prop('disabled', false).html(originalText);
                                                }
                                            }, 30000); // 30 second timeout
                                        });

                                        // Smooth animations on scroll
                                        const observer = new IntersectionObserver((entries) => {
                                            entries.forEach(entry => {
                                                if (entry.isIntersecting) {
                                                    entry.target.style.opacity = '1';
                                                    entry.target.style.transform = 'translateY(0)';
                                                }
                                            });
                                        });

                                        $('.form-section').each(function () {
                                            this.style.opacity = '0';
                                            this.style.transform = 'translateY(20px)';
                                            this.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
                                            observer.observe(this);
                                        });

                                        // Helper function to show alerts
                                        function showAlert(message, type) {
                                            const alertHtml = `
                <div class="alert alert-${type} alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i>
            ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            `;
                                            $('.ai-form-container').prepend(alertHtml);

                                            // Auto dismiss after 5 seconds
                                            setTimeout(() => {
                                                $('.alert').fadeOut();
                                            }, 5000);
                                        }

                                        // Add hover effects for better UX
                                        $('.form-control, .form-select').on('focus', function () {
                                            $(this).closest('.form-section').addClass('focused');
                                        }).on('blur', function () {
                                            $(this).closest('.form-section').removeClass('focused');
                                        });

                                        // Fix for nice-select dropdown positioning
                                        $('.nice-select').each(function () {
                                            const $this = $(this);
                                            const $list = $this.find('.list');

                                            $this.on('click', function () {
                                                setTimeout(() => {
                                                    if ($this.hasClass('open')) {
                                                        // Calculate if dropdown goes below viewport
                                                        const dropdownBottom = $this.offset().top + $this.outerHeight() + $list.outerHeight();
                                                        const viewportBottom = $(window).scrollTop() + $(window).height();

                                                        if (dropdownBottom > viewportBottom) {
                                                            // Position dropdown above the select
                                                            $list.css({
                                                                'top': 'auto',
                                                                'bottom': '100%',
                                                                'margin-top': '0',
                                                                'margin-bottom': '5px'
                                                            });
                                                        } else {
                                                            // Position dropdown below the select (default)
                                                            $list.css({
                                                                'top': '100%',
                                                                'bottom': 'auto',
                                                                'margin-top': '5px',
                                                                'margin-bottom': '0'
                                                            });
                                                        }
                                                    }
                                                }, 10);
                                            });
                                        });

                                        // Ensure proper z-index stacking
                                        $('.form-section.has-dropdown').each(function (index) {
                                            $(this).css('z-index', 100 - index);
                                        });
                                    });
        </script>
    </body>
</html>
