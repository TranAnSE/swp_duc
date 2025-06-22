<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!--Header Start--> 
<div class="header-area header-transparent">
    <div class="main-header">
        <div class="header-bottom header-sticky">
            <div class="container-fluid">
                <div class="row align-items-center">
                    <!-- Logo -->
                    <div class="col-xl-2 col-lg-2">
                        <div class="logo">
                            <a href="/"><img src="/assets/img/logo/logo.png" alt="Logo"></a>
                        </div>
                    </div>

                    <!-- Navbar -->
                    <div class="col-xl-10 col-lg-10">
                        <div class="menu-wrapper d-flex align-items-center justify-content-end">
                            <div class="main-menu d-none d-lg-block">
                                <nav>
                                    <ul id="navigation">
                                        <li><a href="/">Home</a></li>
                                        <li><a href="#">Courses</a>
                                            <ul class="submenu">
                                                <li><a href="/subjects">Subjects</a></li>
                                                <li><a href="/LessonURL">Lessons</a></li>
                                                <li><a href="/chapter">Chapters</a></li>
                                                <li><a href="/study_package">Study Packages</a></li>

                                            </ul>
                                        </li>

                                        <c:if test="${sessionScope.account.role == 'admin'}">
                                            <li><a href="#">Admin</a>
                                                <ul class="submenu">
                                                    <li><a href="/admin?action=dashboard">Dashboard</a></li>
                                                    <li><a href="/admin?action=listAccount">Manage Accounts</a></li>
                                                    <li><a href="/Question">Manage Questions</a></li>
                                                    <li><a href="/test">Manage Tests</a></li>
                                                    <li><a href="/student">Manage Student</a></li>
                                                    <li><a href="/invoice">Invoices</a></li>
                                                    <li><a href="/category">Test Categories</a></li>
                                                </ul>
                                            </li>
                                        </c:if>

                                        <c:if test="${sessionScope.account.role == 'teacher'}">
                                            <li><a href="#">Teacher</a>
                                                <ul class="submenu">
                                                    <li><a href="/admin?action=teacherDashboard">Dashboard</a></li>
                                                    <li><a href="/student">Manage Student</a></li>
                                                    <li><a href="/LessonURL">My Lessons</a></li>
                                                    <li><a href="/Question">Question Bank</a></li>
                                                    <li><a href="/test">Manage Tests</a></li>
                                                    <li><a href="/chapter">Chapters</a></li>
                                                    <li><a href="/category">Test Categories</a></li>
                                                </ul>
                                            </li>
                                        </c:if>

                                        <c:if test="${sessionScope.role == 'student'}">
                                            <li><a href="#">Learning</a>
                                                <ul class="submenu">
                                                    <li><a href="/subjects">My Subjects</a></li>
                                                    <li><a href="/LessonURL">My Lessons</a></li>
                                                    <li><a href="/chapter">Chapters</a></li>
                                                </ul>
                                            </li>
                                            <li><a href="#">Tests & Practice</a>
                                                <ul class="submenu">
                                                    <li><a href="/student/taketest">All Tests & Practice</a></li>
                                                    <li><a href="/student/taketest?action=history">My Test History</a></li>
                                                    <li><a href="/Grade">My Grades</a></li>
                                                </ul>
                                            </li>
                                        </c:if>

                                        <c:if test="${sessionScope.account.role == 'parent'}">
                                            <li><a href="#">Parent</a>
                                                <ul class="submenu">
                                                    <li><a href="/invoice">Invoices</a></li>
                                                    <li><a href="/Grade">Grades</a></li>
                                                    <li><a href="/parent?action=myChildren">My Children</a></li>

                                                </ul>
                                            </li>
                                        </c:if>

                                        <li><a href="#">Blog</a>
                                            <ul class="submenu">
                                                <li><a href="blog.html">All Blogs</a></li>
                                                <li><a href="blog_details.html">Blog Details</a></li>
                                            </ul>
                                        </li>

                                        <li><a href="/contact">Contact</a></li>

                                        <!-- Right-side Buttons -->
                                        
                                        <c:choose>
                                            <c:when test="${sessionScope.role == 'student'}">
                                                <li class="button-header">
                                                    <a href="/student?action=viewProfile&id=${sessionScope.student.id}" class="btn btn3">My Profile</a>
                                                </li>
                                            </c:when>
                                            <c:otherwise>
                                                <li class="button-header">
                                                    <a href="/admin?action=viewProfile&id=${sessionScope.account.id}" class="btn btn3">My Profile</a>
                                                </li>
                                            </c:otherwise>
                                        </c:choose>
   
                                        <c:if test="${not empty sessionScope.student or not empty sessionScope.account}">
                                            <li class="button-header">
                                                <a href="/logout" class="btn btn3">Logout</a>
                                            </li>
                                        </c:if>
                                    </ul>
                                </nav>
                            </div>
                        </div>
                    </div>

                    <!-- Mobile Menu -->
                    <div class="col-12">
                        <div class="mobile_menu d-block d-lg-none"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<!--Header End-->