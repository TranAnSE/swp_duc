/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.Test;

import dal.TestDAO;
import dal.QuestionDAO;
import dal.TestQuestionDAO;
import dal.GradeDAO;
import dal.DAOSubject;
import dal.ChapterDAO;
import dal.CourseDAO;
import dal.LessonDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Test;
import model.Question;
import model.Grade;
import model.Subject;
import model.Chapter;
import model.Lesson;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;
import java.sql.SQLException;
import model.Account;
import util.AuthUtil;
import util.RoleConstants;

/**
 *
 * @author Na
 */
@WebServlet("/test")
public class TestController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!AuthUtil.hasRole(request, RoleConstants.STUDENT)
                && !AuthUtil.hasRole(request, RoleConstants.TEACHER)
                && !AuthUtil.hasRole(request, RoleConstants.ADMIN)) {
            response.sendRedirect("/error.jsp");
            return;
        }
        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect("test");
            return;
        }
        try {
            switch (action) {
                case "add":
                    addTest(request, response);
                    break;
                case "update":
                    updateTest(request, response);
                    break;
                case "generateQuestions":
                    generateQuestionsForTest(request, response);
                    break;
                case "addToCourse":
                    addTestToCourse(request, response);
                    break;
                case "removeFromCourse":
                    removeTestFromCourse(request, response);
                    break;
                default:
                    response.sendRedirect("test");
                    break;
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
            response.sendRedirect("test");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!AuthUtil.hasRole(request, RoleConstants.STUDENT)
                && !AuthUtil.hasRole(request, RoleConstants.TEACHER)
                && !AuthUtil.hasRole(request, RoleConstants.ADMIN)) {
            response.sendRedirect("/error.jsp");
            return;
        }
        String action = request.getParameter("action");
        if (action == null) {
            listTests(request, response);
        } else {
            try {
                switch (action) {
                    case "create":
                        showCreateForm(request, response);
                        break;
                    case "edit":
                        showEditForm(request, response);
                        break;
                    case "delete":
                        deleteTest(request, response);
                        break;
                    case "search":
                        searchTestById(request, response);
                        break;
                    case "getSubjectsByGrade":
                        handleGetSubjectsByGrade(request, response);
                        return;
                    case "getChaptersBySubject":
                        handleGetChaptersBySubject(request, response);
                        return;
                    case "getLessonsByChapter":
                        handleGetLessonsByChapter(request, response);
                        return;
                    case "getQuestionsByLesson":
                        handleGetQuestionsByLesson(request, response);
                        return;
                    case "getRandomQuestions":
                        handleGetRandomQuestions(request, response);
                        return;
                    case "getSmartQuestions":
                        handleGetSmartQuestions(request, response);
                        return;
                    case "getLessonHierarchy":
                        handleGetLessonHierarchy(request, response);
                        return;
                    case "getAllGrades":
                        handleGetAllGrades(request, response);
                        return;
                    case "getQuestionsBySubject":
                        handleGetQuestionsBySubject(request, response);
                        return;
                    case "getQuestionsByChapter":
                        handleGetQuestionsByChapter(request, response);
                        return;
                    case "getAllQuestionsBySubject":
                        handleGetAllQuestionsBySubject(request, response);
                        return;
                    case "getAllQuestionsByChapter":
                        handleGetAllQuestionsByChapter(request, response);
                        return;
                    case "createForCourse":
                        showCreateFormForCourse(request, response);
                        break;
                    case "courseTests":
                        showCourseTests(request, response);
                        break;
                    case "getLessonsByCourse":
                        handleGetLessonsByCourse(request, response);
                        return;
                    default:
                        listTests(request, response);
                        break;
                }
            } catch (Exception e) {
                request.setAttribute("error", "Error: " + e.getMessage());
                listTests(request, response);
            }
        }
    }

    private void listTests(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        TestDAO testDAO = new TestDAO();
        // Get pagination parameters
        int page = 1;
        int pageSize = 10;
        String pageParam = request.getParameter("page");
        String pageSizeParam = request.getParameter("pageSize");

        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        if (pageSizeParam != null && !pageSizeParam.isEmpty()) {
            try {
                pageSize = Integer.parseInt(pageSizeParam);
                if (pageSize < 5) {
                    pageSize = 5;
                }
                if (pageSize > 50) {
                    pageSize = 50;
                }
            } catch (NumberFormatException e) {
                pageSize = 10;
            }
        }

        // Get filter parameters
        String searchKeyword = request.getParameter("search");
        String testType = request.getParameter("testType");
        String courseIdParam = request.getParameter("courseId");
        Integer courseId = null;

        if (courseIdParam != null && !courseIdParam.isEmpty()) {
            try {
                courseId = Integer.parseInt(courseIdParam);
            } catch (NumberFormatException e) {
                // Ignore invalid course ID
            }
        }

        // Get current user for filtering
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("account");

        List<Map<String, Object>> testList;
        int totalTests;

        if (AuthUtil.hasRole(request, RoleConstants.ADMIN)) {
            // Admin sees all tests using new method
            testList = testDAO.getAllTestsWithPaginationAndFilters(
                    searchKeyword, testType, courseId, page, pageSize);
            totalTests = testDAO.getTotalTestsCountForAdmin(searchKeyword, testType, courseId);
        } else if (AuthUtil.hasRole(request, RoleConstants.TEACHER)) {
            // Teacher sees only their tests
            testList = testDAO.getTestsByTeacherWithPagination(
                    account.getId(), searchKeyword, testType, courseId, page, pageSize);
            totalTests = testDAO.getTotalTestsByTeacherCountWithFilters(
                    account.getId(), searchKeyword, testType, courseId);
        } else {
            // Students see all tests (for taking tests)
            testList = testDAO.getTestsWithPaginationAndFilters(
                    searchKeyword, testType, courseId, null, page, pageSize);
            totalTests = testDAO.getTotalTestsCountWithFilters(searchKeyword, testType, courseId, null);
        }

        // Calculate pagination info
        int totalPages = (int) Math.ceil((double) totalTests / pageSize);
        int startPage = Math.max(1, page - 2);
        int endPage = Math.min(totalPages, page + 2);
        int displayStart = (page - 1) * pageSize + 1;
        int displayEnd = Math.min(page * pageSize, totalTests);

        // Get courses for filter dropdown
        List<Map<String, Object>> courses = new ArrayList<>();
        try {
            if (AuthUtil.hasRole(request, RoleConstants.ADMIN)) {
                courses = testDAO.getAllCoursesForAdmin();
            } else if (AuthUtil.hasRole(request, RoleConstants.TEACHER)) {
                CourseDAO courseDAO = new CourseDAO();
                courses = courseDAO.getCoursesByTeacher(account.getId());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("testList", testList);
        request.setAttribute("courses", courses);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalTests", totalTests);
        request.setAttribute("startPage", startPage);
        request.setAttribute("endPage", endPage);
        request.setAttribute("displayStart", displayStart);
        request.setAttribute("displayEnd", displayEnd);

        // Preserve filter parameters
        request.setAttribute("searchKeyword", searchKeyword);
        request.setAttribute("selectedTestType", testType);
        request.setAttribute("selectedCourseId", courseId);

        if (AuthUtil.hasRole(request, RoleConstants.TEACHER)) {
            RequestDispatcher dispatcher = request.getRequestDispatcher("/teacher/manageTests.jsp");
            dispatcher.forward(request, response);
        } else if (AuthUtil.hasRole(request, RoleConstants.ADMIN)) {
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/manageTests.jsp");
            dispatcher.forward(request, response);
        } else {
            RequestDispatcher dispatcher = request.getRequestDispatcher("/test/testList.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("test", new Test());

        // Load hierarchy data for test creation
        try {
            GradeDAO gradeDAO = new GradeDAO();
            List<Grade> gradeList = gradeDAO.findAllFromGrade();
            request.setAttribute("gradeList", gradeList);
        } catch (Exception e) {
            System.out.println("Error loading grades: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("gradeList", new ArrayList<Grade>());
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("/Test/addTest.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        TestDAO testDAO = new TestDAO();
        QuestionDAO questionDAO = new QuestionDAO();
        TestQuestionDAO testQuestionDAO = new TestQuestionDAO();
        LessonDAO lessonDAO = new LessonDAO();

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Test test = testDAO.getTestById(id);
            if (test == null) {
                request.setAttribute("error", "Test not found!");
                listTests(request, response);
                return;
            }

            // Get test configuration
            Map<String, Integer> testConfig = testDAO.getTestConfiguration(id);
            request.setAttribute("testConfig", testConfig);

            // Check if this is a course-integrated test
            boolean isCourseTest = testDAO.isCourseIntegratedTest(id);
            request.setAttribute("isCourseTest", isCourseTest);

            // Get required question count for validation
            int requiredQuestionCount = testDAO.getRequiredQuestionCount(id);
            request.setAttribute("requiredQuestionCount", requiredQuestionCount);

            request.setAttribute("test", test);

            // Get test context with enhanced information
            Map<String, Object> testContext = testDAO.getTestContext(id);
            if (testContext != null) {
                request.setAttribute("testContext", testContext);
                String contextLevel = (String) testContext.get("contextLevel");
                Object contextId = testContext.get("contextId");
                String contextName = (String) testContext.get("contextName");

                // Enhanced context info display
                String contextInfo = "";
                if (Boolean.TRUE.equals(testContext.get("courseLevel"))) {
                    // For course-level tests
                    String courseName = (String) testContext.get("courseContextName");
                    contextInfo = "Course: " + (courseName != null ? courseName : "Unknown Course")
                            + " (Subject: " + (contextName != null ? contextName : "Unknown Subject") + ")";
                } else {
                    contextInfo = "Test Context: " + (contextLevel != null ? contextLevel.toUpperCase() : "Unknown")
                            + " - " + (contextName != null ? contextName : "Unknown");
                }

                // Set context info for JSP
                if (contextId != null) {
                    request.setAttribute("contextInfo", contextInfo);
                    request.setAttribute("contextLevel", contextLevel);
                    request.setAttribute("contextId", contextId);

                    // Set lesson context specifically for JavaScript (for backward compatibility)
                    if ("lesson".equals(contextLevel)) {
                        request.setAttribute("contextLessonId", contextId);
                    }
                }
            }

            // Get selected question IDs for this test
            List<Integer> selectedQuestionIds = testQuestionDAO.getQuestionIdsByTest(id);
            request.setAttribute("selectedQuestionIds", selectedQuestionIds);

            // Get selected questions with full details
            List<Question> selectedQuestions = new ArrayList<>();
            for (Integer questionId : selectedQuestionIds) {
                Question question = questionDAO.getQuestionById(questionId);
                if (question != null) {
                    selectedQuestions.add(question);
                }
            }
            request.setAttribute("selectedQuestions", selectedQuestions);

            // Build lesson name map for displaying lesson names
            List<Integer> lessonIds = new ArrayList<>();
            for (Question q : selectedQuestions) {
                if (q.getLesson_id() > 0) {
                    lessonIds.add(q.getLesson_id());
                }
            }
            Map<Integer, String> lessonNameMap = lessonDAO.getLessonNameMap(lessonIds);
            request.setAttribute("lessonNameMap", lessonNameMap);

            // Load hierarchy data for question selection
            GradeDAO gradeDAO = new GradeDAO();
            List<Grade> gradeList = gradeDAO.findAllFromGrade();
            request.setAttribute("gradeList", gradeList);

            RequestDispatcher dispatcher = request.getRequestDispatcher("/Test/updateTest.jsp");
            dispatcher.forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid ID");
            listTests(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading test: " + e.getMessage());
            listTests(request, response);
        }
    }

    private void addTest(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        TestDAO testDAO = new TestDAO();
        TestQuestionDAO testQuestionDAO = new TestQuestionDAO();

        try {
            HttpSession session = request.getSession();
            Account account = (Account) session.getAttribute("account");

            String name = request.getParameter("name");
            String description = request.getParameter("description");
            boolean practice = "true".equals(request.getParameter("practice"));

            // Check if this is a course-integrated test
            String courseIdParam = request.getParameter("courseId");
            String chapterIdParam = request.getParameter("chapterId");
            String lessonIdParam = request.getParameter("lessonId");
            String durationParam = request.getParameter("duration");
            String numQuestionsParam = request.getParameter("numQuestions");
            String testOrderParam = request.getParameter("testOrder");

            Test test = new Test();
            test.setName(name);
            test.setDescription(description);
            test.setIs_practice(practice);

            if (account != null) {
                test.setCreated_by(account.getId());
            }

            if (courseIdParam != null && !courseIdParam.isEmpty()) {
                // Course-integrated test
                test.setCourse_id(Integer.parseInt(courseIdParam));

                if (chapterIdParam != null && !chapterIdParam.isEmpty()) {
                    test.setChapter_id(Integer.parseInt(chapterIdParam));
                }

                if (lessonIdParam != null && !lessonIdParam.isEmpty()) {
                    test.setLesson_id(Integer.parseInt(lessonIdParam));
                }

                if (durationParam != null && !durationParam.isEmpty()) {
                    test.setDuration_minutes(Integer.parseInt(durationParam));
                }

                if (numQuestionsParam != null && !numQuestionsParam.isEmpty()) {
                    test.setNum_questions(Integer.parseInt(numQuestionsParam));
                }

                if (testOrderParam != null && !testOrderParam.isEmpty()) {
                    test.setTest_order(Integer.parseInt(testOrderParam));
                }
            } else {
                // Standalone test - set default values
                test.setDuration_minutes(durationParam != null && !durationParam.isEmpty()
                        ? Integer.parseInt(durationParam) : 30);
                test.setNum_questions(numQuestionsParam != null && !numQuestionsParam.isEmpty()
                        ? Integer.parseInt(numQuestionsParam) : 10);
            }

            int testId = testDAO.addTest(test);

            if (testId > 0) {
                // Handle question selection
                String[] questionIds = request.getParameterValues("questionIds");
                if (questionIds != null && questionIds.length > 0) {
                    for (String questionIdStr : questionIds) {
                        try {
                            int questionId = Integer.parseInt(questionIdStr);
                            testQuestionDAO.addTestQuestion(testId, questionId);
                        } catch (NumberFormatException e) {
                            // Skip invalid question IDs
                        }
                    }
                }

                // Redirect based on test type
                if (test.getCourse_id() != null) {
                    response.sendRedirect("course?action=build&id=" + test.getCourse_id());
                } else {
                    response.sendRedirect("test");
                }
            } else {
                request.setAttribute("error", "Failed to create test");
                if (test.getCourse_id() != null) {
                    showCreateFormForCourse(request, response);
                } else {
                    showCreateForm(request, response);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error creating test: " + e.getMessage());
            response.sendRedirect("test");
        }
    }

    private void updateTest(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        TestDAO testDAO = new TestDAO();
        TestQuestionDAO testQuestionDAO = new TestQuestionDAO();

        // Check if user has admin or teacher role
        if (!AuthUtil.hasRole(request, RoleConstants.ADMIN) && !AuthUtil.hasRole(request, RoleConstants.TEACHER)) {
            response.sendRedirect("/error.jsp");
            return;
        }

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            boolean practice = "true".equals(request.getParameter("practice"));

            // Get duration and num_questions parameters
            String durationParam = request.getParameter("duration");
            String numQuestionsParam = request.getParameter("numQuestions");

            int duration = 30; // default
            int numQuestions = 10; // default

            if (durationParam != null && !durationParam.trim().isEmpty()) {
                try {
                    duration = Integer.parseInt(durationParam);
                    if (duration < 5 || duration > 180) {
                        request.setAttribute("error", "Duration must be between 5 and 180 minutes");
                        showEditForm(request, response);
                        return;
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "Invalid duration format");
                    showEditForm(request, response);
                    return;
                }
            }

            if (numQuestionsParam != null && !numQuestionsParam.trim().isEmpty()) {
                try {
                    numQuestions = Integer.parseInt(numQuestionsParam);
                    if (numQuestions < 1 || numQuestions > 100) {
                        request.setAttribute("error", "Number of questions must be between 1 and 100");
                        showEditForm(request, response);
                        return;
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "Invalid number of questions format");
                    showEditForm(request, response);
                    return;
                }
            }

            // Create test object with all fields
            Test test = new Test();
            test.setId(id);
            test.setName(name);
            test.setDescription(description);
            test.setIs_practice(practice);
            test.setDuration_minutes(duration);
            test.setNum_questions(numQuestions);

            // Check if this is a course-integrated test
            boolean isCourseTest = testDAO.isCourseIntegratedTest(id);

            // Validate question count for course-integrated tests
            String[] questionIds = request.getParameterValues("questionIds");
            int selectedQuestionCount = questionIds != null ? questionIds.length : 0;

            if (isCourseTest && selectedQuestionCount != numQuestions) {
                request.setAttribute("error",
                        String.format("For course-integrated tests, you must select exactly %d questions as specified in the test configuration. Currently selected: %d questions.",
                                numQuestions, selectedQuestionCount));
                showEditForm(request, response);
                return;
            }

            // Update test information with new method
            boolean updateSuccess = testDAO.updateTestWithConfiguration(test);

            if (!updateSuccess) {
                request.setAttribute("error", "Failed to update test configuration");
                showEditForm(request, response);
                return;
            }

            // Remove all old questions from test
            testQuestionDAO.removeAllQuestionsFromTest(id);

            // Add new selected questions
            if (questionIds != null && questionIds.length > 0) {
                for (String questionIdStr : questionIds) {
                    try {
                        int questionId = Integer.parseInt(questionIdStr);
                        testQuestionDAO.addTestQuestion(id, questionId);
                    } catch (NumberFormatException e) {
                        // Skip invalid question IDs
                    }
                }
            }

            request.setAttribute("message", "Test updated successfully");
            response.sendRedirect("test");

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid ID");
            response.sendRedirect("test");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error updating test: " + e.getMessage());
            response.sendRedirect("test");
        }
    }

    private void deleteTest(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        TestDAO testDAO = new TestDAO();

        // Check if user has admin or teacher role
        if (!AuthUtil.hasRole(request, RoleConstants.ADMIN) && !AuthUtil.hasRole(request, RoleConstants.TEACHER)) {
            response.sendRedirect("/error.jsp");
            return;
        }

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            testDAO.deleteTest(id);
            request.setAttribute("message", "Test deleted successfully");
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid ID");
        } catch (Exception e) {
            request.setAttribute("error", "Error deleting test: " + e.getMessage());
        }

        response.sendRedirect("test");
    }

    private void searchTestById(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        TestDAO testDAO = new TestDAO();

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Test test = testDAO.getTestById(id);
            request.setAttribute("testList", test != null ? List.of(test) : List.of());

            RequestDispatcher dispatcher = request.getRequestDispatcher("/Test/testList.jsp");
            dispatcher.forward(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid ID");
            listTests(request, response);
        }
    }

    // AJAX handlers for hierarchical data loading
    private void handleGetSubjectsByGrade(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            int gradeId = Integer.parseInt(request.getParameter("gradeId"));
            DAOSubject subjectDAO = new DAOSubject();
            List<Subject> subjects = subjectDAO.findAll();

            StringBuilder json = new StringBuilder("[");
            boolean first = true;
            for (Subject subject : subjects) {
                if (subject.getGrade_id() == gradeId) {
                    if (!first) {
                        json.append(",");
                    }
                    json.append("{\"id\":").append(subject.getId())
                            .append(",\"name\":\"").append(subject.getName().replace("\"", "\\\"")).append("\"}");
                    first = false;
                }
            }
            json.append("]");

            response.getWriter().write(json.toString());
        } catch (Exception e) {
            response.getWriter().write("[]");
        }
    }

    private void handleGetChaptersBySubject(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            int subjectId = Integer.parseInt(request.getParameter("subjectId"));
            ChapterDAO chapterDAO = new ChapterDAO();
            List<Chapter> chapters = chapterDAO.findChapterBySubjectId(subjectId);

            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < chapters.size(); i++) {
                if (i > 0) {
                    json.append(",");
                }
                Chapter chapter = chapters.get(i);
                json.append("{\"id\":").append(chapter.getId())
                        .append(",\"name\":\"").append(chapter.getName().replace("\"", "\\\"")).append("\"}");
            }
            json.append("]");

            response.getWriter().write(json.toString());
        } catch (Exception e) {
            response.getWriter().write("[]");
        }
    }

    private void handleGetLessonsByChapter(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            int chapterId = Integer.parseInt(request.getParameter("chapterId"));
            LessonDAO lessonDAO = new LessonDAO();
            List<Lesson> allLessons = lessonDAO.getAllLessons();

            StringBuilder json = new StringBuilder("[");
            boolean first = true;
            for (Lesson lesson : allLessons) {
                if (lesson.getChapter_id() == chapterId) {
                    if (!first) {
                        json.append(",");
                    }
                    json.append("{\"id\":").append(lesson.getId())
                            .append(",\"name\":\"").append(lesson.getName().replace("\"", "\\\"")).append("\"}");
                    first = false;
                }
            }
            json.append("]");

            response.getWriter().write(json.toString());
        } catch (Exception e) {
            response.getWriter().write("[]");
        }
    }

    private void handleGetSmartQuestions(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            int lessonId = Integer.parseInt(request.getParameter("lessonId"));
            int count = Integer.parseInt(request.getParameter("count"));
            String difficulty = request.getParameter("difficulty");
            String category = request.getParameter("category");
            String excludeIdsStr = request.getParameter("excludeIds");

            // Parse excluded IDs
            Set<Integer> excludeIds = new HashSet<>();
            if (excludeIdsStr != null && !excludeIdsStr.trim().isEmpty()) {
                String[] ids = excludeIdsStr.split(",");
                for (String id : ids) {
                    try {
                        excludeIds.add(Integer.parseInt(id.trim()));
                    } catch (NumberFormatException e) {
                        // Skip invalid IDs
                    }
                }
            }

            QuestionDAO questionDAO = new QuestionDAO();
            List<Question> questions = questionDAO.getSmartQuestionsForLesson(lessonId, count, difficulty, category, excludeIds);

            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < questions.size(); i++) {
                if (i > 0) {
                    json.append(",");
                }
                Question question = questions.get(i);
                String difficulty_val = question.getDifficulty() != null ? question.getDifficulty() : "medium";
                String category_val = question.getCategory() != null ? question.getCategory() : "conceptual";
                String questionType = question.getQuestion_type() != null ? question.getQuestion_type() : "SINGLE";

                json.append("{\"id\":").append(question.getId())
                        .append(",\"question\":\"").append(escapeJsonString(question.getQuestion()))
                        .append("\",\"question_type\":\"").append(questionType)
                        .append("\",\"difficulty\":\"").append(difficulty_val)
                        .append("\",\"category\":\"").append(category_val)
                        .append("\",\"isAI\":").append(question.isAIGenerated())
                        .append("}");
            }
            json.append("]");

            response.getWriter().write(json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("[]");
        }
    }

    private void handleGetQuestionsByLesson(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            int lessonId = Integer.parseInt(request.getParameter("lessonId"));
            QuestionDAO questionDAO = new QuestionDAO();

            // Use the method that includes all details
            List<Question> questions = questionDAO.getQuestionsByLessonWithDetails(lessonId);

            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < questions.size(); i++) {
                if (i > 0) {
                    json.append(",");
                }
                Question question = questions.get(i);

                // Ensure all fields have default values if null
                String difficulty = question.getDifficulty() != null ? question.getDifficulty() : "medium";
                String category = question.getCategory() != null ? question.getCategory() : "conceptual";
                String questionType = question.getQuestion_type() != null ? question.getQuestion_type() : "SINGLE";
                String questionText = question.getQuestion() != null ? question.getQuestion() : "";

                json.append("{\"id\":").append(question.getId())
                        .append(",\"question\":\"").append(escapeJsonString(questionText))
                        .append("\",\"type\":\"").append(questionType)
                        .append("\",\"difficulty\":\"").append(difficulty)
                        .append("\",\"category\":\"").append(category)
                        .append("\",\"isAI\":").append(question.isAIGenerated())
                        .append("}");
            }
            json.append("]");

            response.getWriter().write(json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("[]");
        }
    }

    private void handleGetRandomQuestions(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            int lessonId = Integer.parseInt(request.getParameter("lessonId"));
            int count = Integer.parseInt(request.getParameter("count"));
            String difficulty = request.getParameter("difficulty");
            String category = request.getParameter("category");

            QuestionDAO questionDAO = new QuestionDAO();
            List<Question> allQuestions = questionDAO.findAllQuestion();
            List<Question> filteredQuestions = new ArrayList<>();

            // Filter questions by lesson and criteria
            for (Question question : allQuestions) {
                if (question.getLesson_id() == lessonId) {
                    boolean matchesCriteria = true;

                    if (difficulty != null && !difficulty.isEmpty() && !difficulty.equals("all")) {
                        String qDifficulty = question.getDifficulty() != null ? question.getDifficulty() : "medium";
                        if (!qDifficulty.equals(difficulty)) {
                            matchesCriteria = false;
                        }
                    }

                    if (category != null && !category.isEmpty() && !category.equals("all")) {
                        String qCategory = question.getCategory() != null ? question.getCategory() : "conceptual";
                        if (!qCategory.equals(category)) {
                            matchesCriteria = false;
                        }
                    }

                    if (matchesCriteria) {
                        filteredQuestions.add(question);
                    }
                }
            }

            // Shuffle and select random questions
            Collections.shuffle(filteredQuestions);
            List<Question> selectedQuestions = filteredQuestions.subList(0, Math.min(count, filteredQuestions.size()));

            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < selectedQuestions.size(); i++) {
                if (i > 0) {
                    json.append(",");
                }
                Question question = selectedQuestions.get(i);
                String difficulty_val = question.getDifficulty() != null ? question.getDifficulty() : "medium";
                String category_val = question.getCategory() != null ? question.getCategory() : "conceptual";
                String questionType = question.getQuestion_type() != null ? question.getQuestion_type() : "SINGLE";

                json.append("{\"id\":").append(question.getId())
                        .append(",\"question\":\"").append(escapeJsonString(question.getQuestion()))
                        .append("\",\"type\":\"").append(questionType)
                        .append("\",\"difficulty\":\"").append(difficulty_val)
                        .append("\",\"category\":\"").append(category_val)
                        .append("\",\"isAI\":").append(question.isAIGenerated())
                        .append("}");
            }
            json.append("]");

            response.getWriter().write(json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("[]");
        }
    }

    // Helper method to escape JSON strings
    private String escapeJsonString(String input) {
        if (input == null) {
            return "";
        }
        return input.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\b", "\\b")
                .replace("\f", "\\f")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }

    private void generateQuestionsForTest(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            int lessonId = Integer.parseInt(request.getParameter("lessonId"));
            int count = Integer.parseInt(request.getParameter("count"));
            String difficulty = request.getParameter("difficulty");
            String category = request.getParameter("category");

            QuestionDAO questionDAO = new QuestionDAO();
            List<Question> allQuestions = questionDAO.findAllQuestion();
            List<Question> filteredQuestions = new ArrayList<>();

            // Filter questions by lesson and criteria
            for (Question question : allQuestions) {
                if (question.getLesson_id() == lessonId) {
                    boolean matchesCriteria = true;

                    if (difficulty != null && !difficulty.isEmpty() && !difficulty.equals("all")) {
                        String qDifficulty = question.getDifficulty() != null ? question.getDifficulty() : "medium";
                        if (!qDifficulty.equals(difficulty)) {
                            matchesCriteria = false;
                        }
                    }

                    if (category != null && !category.isEmpty() && !category.equals("all")) {
                        String qCategory = question.getCategory() != null ? question.getCategory() : "conceptual";
                        if (!qCategory.equals(category)) {
                            matchesCriteria = false;
                        }
                    }

                    if (matchesCriteria) {
                        filteredQuestions.add(question);
                    }
                }
            }

            // Shuffle and select random questions
            Collections.shuffle(filteredQuestions);
            List<Question> selectedQuestions = filteredQuestions.subList(0, Math.min(count, filteredQuestions.size()));

            StringBuilder json = new StringBuilder("{\"success\": true, \"questions\": [");
            for (int i = 0; i < selectedQuestions.size(); i++) {
                if (i > 0) {
                    json.append(",");
                }
                Question question = selectedQuestions.get(i);
                json.append("{\"id\":").append(question.getId())
                        .append(",\"question\":\"").append(question.getQuestion().replace("\"", "\\\"").replace("\n", "\\n"))
                        .append("\",\"type\":\"").append(question.getQuestion_type())
                        .append("\",\"difficulty\":\"").append(question.getDifficulty() != null ? question.getDifficulty() : "medium")
                        .append("\",\"category\":\"").append(question.getCategory() != null ? question.getCategory() : "conceptual")
                        .append("\",\"isAI\":").append(question.isAIGenerated())
                        .append("}");
            }
            json.append("], \"total\": ").append(selectedQuestions.size()).append("}");

            out.print(json.toString());
        } catch (Exception e) {
            out.print("{\"success\": false, \"error\": \"" + e.getMessage() + "\"}");
        }
    }

    private void handleGetLessonHierarchy(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            int lessonId = Integer.parseInt(request.getParameter("lessonId"));

            // Get lesson details with hierarchy
            LessonDAO lessonDAO = new LessonDAO();
            ChapterDAO chapterDAO = new ChapterDAO();
            DAOSubject subjectDAO = new DAOSubject();
            GradeDAO gradeDAO = new GradeDAO();

            Lesson lesson = lessonDAO.getLessonById(lessonId);
            if (lesson == null) {
                response.getWriter().write("{}");
                return;
            }

            Chapter chapter = chapterDAO.findChapterById(lesson.getChapter_id());
            if (chapter == null) {
                response.getWriter().write("{}");
                return;
            }

            Subject subject = subjectDAO.findById(chapter.getSubject_id());
            if (subject == null) {
                response.getWriter().write("{}");
                return;
            }

            Grade grade = gradeDAO.getGradeById(subject.getGrade_id());
            if (grade == null) {
                response.getWriter().write("{}");
                return;
            }

            // Build JSON response with proper escaping
            StringBuilder json = new StringBuilder("{");
            json.append("\"lessonId\":").append(lesson.getId())
                    .append(",\"lessonName\":\"").append(escapeJsonString(lesson.getName()))
                    .append("\",\"chapterId\":").append(chapter.getId())
                    .append(",\"chapterName\":\"").append(escapeJsonString(chapter.getName()))
                    .append("\",\"subjectId\":").append(subject.getId())
                    .append(",\"subjectName\":\"").append(escapeJsonString(subject.getName()))
                    .append("\",\"gradeId\":").append(grade.getId())
                    .append(",\"gradeName\":\"").append(escapeJsonString(grade.getName()))
                    .append("\"}");

            response.getWriter().write(json.toString());

            // Log để debug
            System.out.println("Lesson hierarchy response: " + json.toString());

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Failed to load lesson hierarchy\"}");
        }
    }

    private void handleGetAllGrades(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            GradeDAO gradeDAO = new GradeDAO();
            List<Grade> grades = gradeDAO.findAllFromGrade();

            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < grades.size(); i++) {
                Grade grade = grades.get(i);
                if (i > 0) {
                    json.append(",");
                }
                json.append("{")
                        .append("\"id\":").append(grade.getId())
                        .append(",\"name\":\"").append(escapeJsonString(grade.getName()))
                        .append("\"}");
            }
            json.append("]");

            response.getWriter().write(json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("[]");
        }
    }
    // Handle getting questions by subject

    private void handleGetQuestionsBySubject(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            int subjectId = Integer.parseInt(request.getParameter("subjectId"));
            int count = Integer.parseInt(request.getParameter("count"));
            String difficulty = request.getParameter("difficulty");
            String category = request.getParameter("category");
            String excludeIdsStr = request.getParameter("excludeIds");

            // Parse excluded IDs
            Set<Integer> excludeIds = new HashSet<>();
            if (excludeIdsStr != null && !excludeIdsStr.trim().isEmpty()) {
                String[] ids = excludeIdsStr.split(",");
                for (String id : ids) {
                    try {
                        excludeIds.add(Integer.parseInt(id.trim()));
                    } catch (NumberFormatException e) {
                        // Skip invalid IDs
                    }
                }
            }

            QuestionDAO questionDAO = new QuestionDAO();
            List<Question> questions = questionDAO.getQuestionsBySubjectWithDetails(subjectId, count, difficulty, category, excludeIds);

            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < questions.size(); i++) {
                if (i > 0) {
                    json.append(",");
                }
                Question question = questions.get(i);
                String difficulty_val = question.getDifficulty() != null ? question.getDifficulty() : "medium";
                String category_val = question.getCategory() != null ? question.getCategory() : "conceptual";
                String questionType = question.getQuestion_type() != null ? question.getQuestion_type() : "SINGLE";

                json.append("{\"id\":").append(question.getId())
                        .append(",\"question\":\"").append(escapeJsonString(question.getQuestion()))
                        .append("\",\"question_type\":\"").append(questionType)
                        .append("\",\"difficulty\":\"").append(difficulty_val)
                        .append("\",\"category\":\"").append(category_val)
                        .append("\",\"isAI\":").append(question.isAIGenerated())
                        .append("}");
            }
            json.append("]");

            response.getWriter().write(json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("[]");
        }
    }

// Handle getting questions by chapter
    private void handleGetQuestionsByChapter(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            int chapterId = Integer.parseInt(request.getParameter("chapterId"));
            int count = Integer.parseInt(request.getParameter("count"));
            String difficulty = request.getParameter("difficulty");
            String category = request.getParameter("category");
            String excludeIdsStr = request.getParameter("excludeIds");

            // Parse excluded IDs
            Set<Integer> excludeIds = new HashSet<>();
            if (excludeIdsStr != null && !excludeIdsStr.trim().isEmpty()) {
                String[] ids = excludeIdsStr.split(",");
                for (String id : ids) {
                    try {
                        excludeIds.add(Integer.parseInt(id.trim()));
                    } catch (NumberFormatException e) {
                        // Skip invalid IDs
                    }
                }
            }

            QuestionDAO questionDAO = new QuestionDAO();
            List<Question> questions = questionDAO.getQuestionsByChapterWithDetails(chapterId, count, difficulty, category, excludeIds);

            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < questions.size(); i++) {
                if (i > 0) {
                    json.append(",");
                }
                Question question = questions.get(i);
                String difficulty_val = question.getDifficulty() != null ? question.getDifficulty() : "medium";
                String category_val = question.getCategory() != null ? question.getCategory() : "conceptual";
                String questionType = question.getQuestion_type() != null ? question.getQuestion_type() : "SINGLE";

                json.append("{\"id\":").append(question.getId())
                        .append(",\"question\":\"").append(escapeJsonString(question.getQuestion()))
                        .append("\",\"question_type\":\"").append(questionType)
                        .append("\",\"difficulty\":\"").append(difficulty_val)
                        .append("\",\"category\":\"").append(category_val)
                        .append("\",\"isAI\":").append(question.isAIGenerated())
                        .append("}");
            }
            json.append("]");

            response.getWriter().write(json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("[]");
        }
    }

// Handle getting all questions by subject (for manual selection)
    private void handleGetAllQuestionsBySubject(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            int subjectId = Integer.parseInt(request.getParameter("subjectId"));
            QuestionDAO questionDAO = new QuestionDAO();
            List<Question> questions = questionDAO.getAllQuestionsBySubject(subjectId);

            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < questions.size(); i++) {
                if (i > 0) {
                    json.append(",");
                }
                Question question = questions.get(i);
                String difficulty = question.getDifficulty() != null ? question.getDifficulty() : "medium";
                String category = question.getCategory() != null ? question.getCategory() : "conceptual";
                String questionType = question.getQuestion_type() != null ? question.getQuestion_type() : "SINGLE";

                json.append("{\"id\":").append(question.getId())
                        .append(",\"question\":\"").append(escapeJsonString(question.getQuestion()))
                        .append("\",\"type\":\"").append(questionType)
                        .append("\",\"difficulty\":\"").append(difficulty)
                        .append("\",\"category\":\"").append(category)
                        .append("\",\"isAI\":").append(question.isAIGenerated())
                        .append("}");
            }
            json.append("]");

            response.getWriter().write(json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("[]");
        }
    }

// Handle getting all questions by chapter (for manual selection)
    private void handleGetAllQuestionsByChapter(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            int chapterId = Integer.parseInt(request.getParameter("chapterId"));
            QuestionDAO questionDAO = new QuestionDAO();
            List<Question> questions = questionDAO.getAllQuestionsByChapter(chapterId);

            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < questions.size(); i++) {
                if (i > 0) {
                    json.append(",");
                }
                Question question = questions.get(i);
                String difficulty = question.getDifficulty() != null ? question.getDifficulty() : "medium";
                String category = question.getCategory() != null ? question.getCategory() : "conceptual";
                String questionType = question.getQuestion_type() != null ? question.getQuestion_type() : "SINGLE";

                json.append("{\"id\":").append(question.getId())
                        .append(",\"question\":\"").append(escapeJsonString(question.getQuestion()))
                        .append("\",\"type\":\"").append(questionType)
                        .append("\",\"difficulty\":\"").append(difficulty)
                        .append("\",\"category\":\"").append(category)
                        .append("\",\"isAI\":").append(question.isAIGenerated())
                        .append("}");
            }
            json.append("]");

            response.getWriter().write(json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("[]");
        }
    }

    private void showCreateFormForCourse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            String chapterIdParam = request.getParameter("chapterId");
            Integer chapterId = null;

            if (chapterIdParam != null && !chapterIdParam.isEmpty()) {
                chapterId = Integer.parseInt(chapterIdParam);
            }

            // Get course details
            CourseDAO courseDAO = new CourseDAO();
            Map<String, Object> courseDetails = courseDAO.getCourseDetails(courseId);

            if (courseDetails == null) {
                request.setAttribute("error", "Course not found!");
                response.sendRedirect("course");
                return;
            }

            // Get course chapters for chapter selection
            List<Map<String, Object>> courseChapters = courseDAO.getCourseChapters(courseId);

            // Create new test object with course context
            Test test = new Test();
            test.setCourse_id(courseId);
            test.setChapter_id(chapterId);

            // Get next test order
            TestDAO testDAO = new TestDAO();
            int nextOrder = testDAO.getNextTestOrder(courseId, chapterId);
            test.setTest_order(nextOrder);

            request.setAttribute("test", test);
            request.setAttribute("courseDetails", courseDetails);
            request.setAttribute("courseChapters", courseChapters);
            request.setAttribute("isForCourse", true);
            request.setAttribute("selectedChapterId", chapterId);

            RequestDispatcher dispatcher = request.getRequestDispatcher("/Test/addTestForCourse.jsp");
            dispatcher.forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid course or chapter ID");
            response.sendRedirect("course");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading course test form: " + e.getMessage());
            response.sendRedirect("course");
        }
    }

    private void showCourseTests(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int courseId = Integer.parseInt(request.getParameter("courseId"));

            // Get pagination parameters
            int page = 1;
            int pageSize = 10;
            String pageParam = request.getParameter("page");
            String pageSizeParam = request.getParameter("pageSize");

            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    page = Integer.parseInt(pageParam);
                    if (page < 1) {
                        page = 1;
                    }
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }

            if (pageSizeParam != null && !pageSizeParam.isEmpty()) {
                try {
                    pageSize = Integer.parseInt(pageSizeParam);
                    if (pageSize < 5) {
                        pageSize = 5;
                    }
                    if (pageSize > 50) {
                        pageSize = 50;
                    }
                } catch (NumberFormatException e) {
                    pageSize = 10;
                }
            }

            // Get course details
            CourseDAO courseDAO = new CourseDAO();
            Map<String, Object> courseDetails = courseDAO.getCourseDetails(courseId);

            if (courseDetails == null) {
                request.setAttribute("error", "Course not found!");
                response.sendRedirect("course");
                return;
            }

            // Get tests with pagination
            TestDAO testDAO = new TestDAO();
            List<Map<String, Object>> tests = testDAO.getTestsByCourseWithPagination(courseId, page, pageSize);
            int totalTests = testDAO.getTotalTestsByCourseCount(courseId);

            // Calculate pagination info
            int totalPages = (int) Math.ceil((double) totalTests / pageSize);
            int startPage = Math.max(1, page - 2);
            int endPage = Math.min(totalPages, page + 2);
            int displayStart = (page - 1) * pageSize + 1;
            int displayEnd = Math.min(page * pageSize, totalTests);

            // Get course chapters for context
            List<Map<String, Object>> courseChapters = courseDAO.getCourseChapters(courseId);

            request.setAttribute("courseDetails", courseDetails);
            request.setAttribute("tests", tests);
            request.setAttribute("courseChapters", courseChapters);
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalTests", totalTests);
            request.setAttribute("startPage", startPage);
            request.setAttribute("endPage", endPage);
            request.setAttribute("displayStart", displayStart);
            request.setAttribute("displayEnd", displayEnd);

            RequestDispatcher dispatcher = request.getRequestDispatcher("/Test/courseTestList.jsp");
            dispatcher.forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid course ID");
            response.sendRedirect("course");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading course tests: " + e.getMessage());
            response.sendRedirect("course");
        }
    }

    private void addTestToCourse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            int testId = Integer.parseInt(request.getParameter("testId"));
            String chapterIdParam = request.getParameter("chapterId");
            Integer chapterId = null;

            if (chapterIdParam != null && !chapterIdParam.isEmpty()) {
                chapterId = Integer.parseInt(chapterIdParam);
            }

            // Get test details to determine type
            TestDAO testDAO = new TestDAO();
            Test test = testDAO.getTestById(testId);

            if (test == null) {
                response.getWriter().write("{\"success\": false, \"message\": \"Test not found\"}");
                return;
            }

            // Get next display order
            CourseDAO courseDAO = new CourseDAO();
            int displayOrder = courseDAO.getNextTestOrder(courseId, chapterId);
            String testType = test.isIs_practice() ? "PRACTICE" : "OFFICIAL";

            boolean success = courseDAO.addTestToCourse(courseId, testId, chapterId, displayOrder, testType);

            if (success) {
                response.getWriter().write("{\"success\": true, \"message\": \"Test added to course successfully\"}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Failed to add test to course\"}");
            }

        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\": false, \"message\": \"Invalid number format\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\": false, \"message\": \"Error: " + e.getMessage() + "\"}");
        }
    }

    private void removeTestFromCourse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            int testId = Integer.parseInt(request.getParameter("testId"));

            CourseDAO courseDAO = new CourseDAO();
            boolean success = courseDAO.removeTestFromCourse(courseId, testId);

            if (success) {
                response.getWriter().write("{\"success\": true, \"message\": \"Test removed from course successfully\"}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Failed to remove test from course\"}");
            }

        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\": false, \"message\": \"Invalid number format\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\": false, \"message\": \"Error: " + e.getMessage() + "\"}");
        }
    }

    private void handleGetLessonsByCourse(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            TestDAO testDAO = new TestDAO();
            List<Map<String, Object>> lessons = testDAO.getLessonsByCourse(courseId);

            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < lessons.size(); i++) {
                if (i > 0) {
                    json.append(",");
                }
                Map<String, Object> lesson = lessons.get(i);
                json.append("{\"id\":").append(lesson.get("id"))
                        .append(",\"name\":\"").append(escapeJsonString((String) lesson.get("name")))
                        .append("\",\"chapter_id\":").append(lesson.get("chapter_id"))
                        .append(",\"chapter_name\":\"").append(escapeJsonString((String) lesson.get("chapter_name")))
                        .append("\"}");
            }
            json.append("]");

            response.getWriter().write(json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("[]");
        }
    }

    private Map<String, String> buildLessonNameMap(List<Question> questions) throws SQLException {
        Map<String, String> lessonNameMap = new HashMap<>();
        LessonDAO lessonDAO = new LessonDAO();

        Set<Integer> lessonIds = questions.stream()
                .map(Question::getLesson_id)
                .filter(id -> id > 0)
                .collect(Collectors.toSet());

        for (Integer lessonId : lessonIds) {
            try {
                Lesson lesson = lessonDAO.getLessonById(lessonId);
                if (lesson != null) {
                    lessonNameMap.put(lessonId.toString(), lesson.getName());
                }
            } catch (Exception e) {
                System.err.println("Error loading lesson " + lessonId + ": " + e.getMessage());
                lessonNameMap.put(lessonId.toString(), "Unknown Lesson");
            }
        }

        return lessonNameMap;
    }
}
