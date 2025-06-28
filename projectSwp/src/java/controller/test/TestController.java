/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.Test;

import dal.TestDAO;
import dal.CategoryDAO;
import dal.QuestionDAO;
import dal.TestQuestionDAO;
import dal.GradeDAO;
import dal.DAOSubject;
import dal.ChapterDAO;
import dal.LessonDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Test;
import model.Category;
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
        List<Test> testList = testDAO.getAllTests();
        Map<Integer, String> categoryMap = getCategoryMap();
        request.setAttribute("testList", testList);
        request.setAttribute("categoryMap", categoryMap);
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
        Map<Integer, String> categoryMap = getCategoryMap();
        request.setAttribute("categoryMap", categoryMap);

        // Load hierarchy data for enhanced test creation
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

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Test test = testDAO.getTestById(id);
            if (test == null) {
                request.setAttribute("error", "Test not found!");
                listTests(request, response);
                return;
            }
            request.setAttribute("test", test);

            Map<Integer, String> categoryMap = getCategoryMap();
            request.setAttribute("categoryMap", categoryMap);

            // Get selected question IDs for this test
            List<Integer> selectedQuestionIds = testQuestionDAO.getQuestionIdsByTest(id);
            request.setAttribute("selectedQuestionIds", selectedQuestionIds);

            // Get selected questions with full details
            List<Question> selectedQuestions = new ArrayList<>();
            LessonDAO lessonDAO = new LessonDAO();
            ChapterDAO chapterDAO = new ChapterDAO();
            DAOSubject subjectDAO = new DAOSubject();
            GradeDAO gradeDAO = new GradeDAO();

            Map<Integer, String> lessonNameMap = new HashMap<>();

            // Load all lessons for lesson name mapping
            List<Lesson> allLessons = lessonDAO.getAllLessons();
            for (Lesson lesson : allLessons) {
                lessonNameMap.put(lesson.getId(), lesson.getName());
            }
            request.setAttribute("lessonNameMap", lessonNameMap);

            // Get detailed information for selected questions and determine the lesson context
            Integer contextLessonId = null;
            String contextInfo = "";

            for (Integer questionId : selectedQuestionIds) {
                Question question = questionDAO.getQuestionById(questionId);
                if (question != null) {
                    selectedQuestions.add(question);

                    // Determine context lesson (use the first question's lesson as context)
                    if (contextLessonId == null && question.getLesson_id() > 0) {
                        contextLessonId = question.getLesson_id();

                        // Build context information
                        try {
                            Lesson lesson = lessonDAO.getLessonById(contextLessonId);
                            if (lesson != null) {
                                Chapter chapter = chapterDAO.findChapterById(lesson.getChapter_id());
                                if (chapter != null) {
                                    Subject subject = subjectDAO.findById(chapter.getSubject_id());
                                    if (subject != null) {
                                        Grade grade = gradeDAO.getGradeById(subject.getGrade_id());
                                        if (grade != null) {
                                            contextInfo = String.format("%s → %s → %s → %s",
                                                    grade.getName(), subject.getName(),
                                                    chapter.getName(), lesson.getName());
                                        }
                                    }
                                }
                            }
                        } catch (Exception e) {
                            System.out.println("Error building context info: " + e.getMessage());
                        }
                    }
                }
            }

            request.setAttribute("selectedQuestions", selectedQuestions);
            request.setAttribute("contextLessonId", contextLessonId);
            request.setAttribute("contextInfo", contextInfo);

            RequestDispatcher dispatcher = request.getRequestDispatcher("/Test/updateTest.jsp");
            dispatcher.forward(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid ID");
            listTests(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error loading test: " + e.getMessage());
            listTests(request, response);
        }
    }

    private void addTest(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        TestDAO testDAO = new TestDAO();
        TestQuestionDAO testQuestionDAO = new TestQuestionDAO();
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        boolean practice = "true".equals(request.getParameter("practice"));
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));

        // Create and save new test
        Test test = new Test(0, name, description, practice, categoryId);
        int testId = testDAO.addTest(test);

        // Handle question selection
        String[] questionIds = request.getParameterValues("questionIds");
        if (questionIds != null && questionIds.length > 0) {
            // Save selected questions to test_question table
            for (String questionIdStr : questionIds) {
                try {
                    int questionId = Integer.parseInt(questionIdStr);
                    testQuestionDAO.addTestQuestion(testId, questionId);
                } catch (NumberFormatException e) {
                    // Skip invalid question IDs
                }
            }
        }

        response.sendRedirect("test");
    }

    private void updateTest(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        TestDAO testDAO = new TestDAO();
        CategoryDAO categoryDAO = new CategoryDAO();
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
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));

            // Validate category exists
            Category category = categoryDAO.getCategoryById(categoryId);
            if (category == null) {
                request.setAttribute("error", "Category does not exist");
                showEditForm(request, response);
                return;
            }

            // Update test information
            Test test = new Test(id, name, description, practice, categoryId);
            testDAO.updateTest(test);

            // Remove all old questions from test
            testQuestionDAO.removeAllQuestionsFromTest(id);

            // Add new selected questions
            String[] questionIds = request.getParameterValues("questionIds");
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
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid ID or category");
        } catch (Exception e) {
            request.setAttribute("error", "Error updating test: " + e.getMessage());
        }

        response.sendRedirect("test");
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

            Map<Integer, String> categoryMap = getCategoryMap();
            request.setAttribute("categoryMap", categoryMap);

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

    // Helper method to get category map
    private Map<Integer, String> getCategoryMap() {
        CategoryDAO categoryDAO = new CategoryDAO();
        Map<Integer, String> categoryMap = new HashMap<>();
        List<Category> categoryList = categoryDAO.getAllCategories();
        for (Category c : categoryList) {
            categoryMap.put(c.getId(), c.getName());
        }
        return categoryMap;
    }

    private void getSmartQuestions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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
            List<Question> smartQuestions = questionDAO.getSmartQuestionsForLesson(
                    lessonId, count, difficulty, category, excludeIds);

            // Convert to JSON
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < smartQuestions.size(); i++) {
                Question q = smartQuestions.get(i);
                if (i > 0) {
                    json.append(",");
                }
                json.append("{")
                        .append("\"id\":").append(q.getId()).append(",")
                        .append("\"question\":\"").append(escapeJson(q.getQuestion())).append("\",")
                        .append("\"difficulty\":\"").append(q.getDifficulty() != null ? q.getDifficulty() : "medium").append("\",")
                        .append("\"category\":\"").append(q.getCategory() != null ? q.getCategory() : "conceptual").append("\",")
                        .append("\"question_type\":\"").append(q.getQuestion_type()).append("\",")
                        .append("\"AIGenerated\":").append(q.isAIGenerated())
                        .append("}");
            }
            json.append("]");

            response.getWriter().write(json.toString());

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"" + escapeJson(e.getMessage()) + "\"}");
        }
    }

    private String escapeJson(String str) {
        if (str == null) {
            return "";
        }
        return str.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", "\\r")
                .replace("\n", "\\n")
                .replace("\t", "\\t");
    }
}
