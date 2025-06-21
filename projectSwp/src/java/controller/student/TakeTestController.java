/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.student;

import dal.*;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.*;
import util.AuthUtil;
import util.RoleConstants;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 *
 * @author Na
 */

@WebServlet("/student/taketest")
public class TakeTestController extends HttpServlet {
    private TestDAO testDAO;
    private TestRecordDAO testRecordDAO;
    private QuestionDAO questionDAO;
    private QuestionOptionDAO questionOptionDAO;
    private QuestionRecordDAO questionRecordDAO;
    private CategoryDAO categoryDAO;

    @Override
    public void init() {
        testDAO = new TestDAO();
        testRecordDAO = new TestRecordDAO();
        questionDAO = new QuestionDAO();
        questionOptionDAO = new QuestionOptionDAO();
        questionRecordDAO = new QuestionRecordDAO();
        categoryDAO = new CategoryDAO();
        
        // Khởi tạo dữ liệu test nếu cần
        questionRecordDAO.initializeTestDataIfNeeded();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!AuthUtil.hasRole(request, RoleConstants.STUDENT)) {
            response.sendRedirect("/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            showTestList(request, response);
        } else {
            switch (action) {
                case "start":
                    startTest(request, response);
                    break;
                case "question":
                    showAllQuestions(request, response);
                    break;
                case "result":
                    showResult(request, response);
                    break;
                case "history":
                    showHistory(request, response);
                    break;
                case "finish":
                    finishTest(request, response);
                    break;
                default:
                    showTestList(request, response);
                    break;
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!AuthUtil.hasRole(request, RoleConstants.STUDENT)) {
            response.sendRedirect("/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("submit".equals(action)) {
            submitAllAnswers(request, response);
        } else if ("finish".equals(action)) {
            finishTest(request, response);
        }
    }

    private void showTestList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            Student student = (Student) session.getAttribute("student");
            
            if (student == null) {
                response.sendRedirect("/login.jsp");
                return;
            }

            List<Test> practiceTests = testDAO.getTestsByType(true);
            List<Test> officialTests = testDAO.getTestsByType(false);
            Map<Integer, String> categoryMap = getCategoryMap();

            // Check which official tests student has already taken
            Map<Integer, Boolean> takenTests = new HashMap<>();
            for (Test test : officialTests) {
                boolean hasTaken = testRecordDAO.hasStudentTakenTest(student.getId(), test.getId());
                takenTests.put(test.getId(), hasTaken);
            }

            request.setAttribute("practiceTests", practiceTests);
            request.setAttribute("officialTests", officialTests);
            request.setAttribute("categoryMap", categoryMap);
            request.setAttribute("takenTests", takenTests);

            RequestDispatcher dispatcher = request.getRequestDispatcher("/student/testList.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/student/testList.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void startTest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            System.out.println("\n===== START TEST =====");
            int testId = Integer.parseInt(request.getParameter("testId"));
            HttpSession session = request.getSession();
            Student student = (Student) session.getAttribute("student");

            if (student == null) {
                System.out.println("No student found in session! Redirecting to login");
                response.sendRedirect("/login.jsp");
                return;
            }

            Test test = testDAO.getTestById(testId);
            if (test == null) {
                System.out.println("Test ID " + testId + " not found!");
                request.setAttribute("error", "Test không tồn tại!");
                showTestList(request, response);
                return;
            }
            
            // Debug test info
            testDAO.debugTestInfo(testId);

            // Check if it's an official test and student has already taken it
            if (!test.isIs_practice() && testRecordDAO.hasStudentTakenTest(student.getId(), testId)) {
                System.out.println("Student " + student.getId() + " has already taken test " + testId);
                request.setAttribute("error", "Bạn đã làm bài test này rồi!");
                showTestList(request, response);
                return;
            }

            // Check for active test record
            TestRecord activeRecord = testRecordDAO.getActiveTestRecord(student.getId(), testId);
            int testRecordId;

            if (activeRecord != null) {
                testRecordId = activeRecord.getId();
                System.out.println("Found active test record ID=" + testRecordId);
            } else {
                // Create new test record
                testRecordId = testRecordDAO.createTestRecord(student.getId(), testId);
                if (testRecordId == -1) {
                    System.out.println("Failed to create test record!");
                    request.setAttribute("error", "Không thể bắt đầu test!");
                    showTestList(request, response);
                    return;
                }
                System.out.println("Created new test record ID=" + testRecordId);
            }

            // Store test info in session
            session.setAttribute("currentTestId", testId);
            session.setAttribute("currentTestRecordId", testRecordId);
            session.setAttribute("currentQuestionIndex", 0);
            
            System.out.println("Session updated with testId=" + testId + 
                              ", testRecordId=" + testRecordId + ", questionIndex=0");
            System.out.println("===== START TEST COMPLETED =====\n");

            // Redirect to first question
            response.sendRedirect("taketest?action=question");

        } catch (NumberFormatException e) {
            System.out.println("ERROR: Invalid test ID format");
            request.setAttribute("error", "Test ID không hợp lệ!");
            showTestList(request, response);
        } catch (Exception e) {
            System.out.println("ERROR in startTest: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            showTestList(request, response);
        }
    }

    private void showAllQuestions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            Integer testId = (Integer) session.getAttribute("currentTestId");
            Integer testRecordId = (Integer) session.getAttribute("currentTestRecordId");
            
            if (testId == null || testRecordId == null) {
                response.sendRedirect("taketest");
                return;
            }
            
            Test test = testDAO.getTestById(testId);
            if (test == null) {
                response.sendRedirect("taketest");
                return;
            }
            
            // Lấy danh sách câu hỏi
            List<Question> questions = questionDAO.getQuestionsByTest(testId);
            
            // Lấy các câu trả lời đã lưu (nếu có)
            Map<Integer, Integer> previousAnswers = new HashMap<>();
            List<QuestionRecord> records = questionRecordDAO.getQuestionRecordsByTestRecord(testRecordId);
            for (QuestionRecord record : records) {
                previousAnswers.put(record.getQuestion_id(), record.getOption_id());
            }
            
            // Lấy options cho mỗi câu hỏi
            Map<Integer, List<QuestionOption>> allOptions = new HashMap<>();
            for (Question question : questions) {
                List<QuestionOption> options = questionOptionDAO.getOptionsByQuestion(question.getId());
                allOptions.put(question.getId(), options);
            }
            
            // Lấy danh sách hình ảnh cho câu hỏi
            ImageDAO imageDAO = new ImageDAO(this.questionDAO.getDBConnection());
            List<Image> images = imageDAO.findAll();
            
            // Xử lý thời gian làm bài
            int duration = 0; // Mặc định không có thời gian
            
            // Nếu là bài test thực sự (không phải luyện tập), mới cần thời gian
            if (!test.isIs_practice()) {
                try {
                    // Debug: In ra SQL trực tiếp
                    System.out.println("DEBUG SQL: SELECT * FROM Category WHERE id = " + test.getCategory_id());
                    
                    // Lấy trực tiếp từ database thay vì qua DAO để debug
                    try (Connection conn = new DBContext().getConnection();
                         PreparedStatement ps = conn.prepareStatement("SELECT * FROM Category WHERE id = ?")) {
                        ps.setInt(1, test.getCategory_id());
                        try (ResultSet rs = ps.executeQuery()) {
                            if (rs.next()) {
                                duration = rs.getInt("duration");
                                System.out.println("Truy vấn SQL trực tiếp: Lấy được duration = " + duration + " phút (category_id=" + test.getCategory_id() + ")");
                            } else {
                                System.out.println("Truy vấn SQL trực tiếp: Không tìm thấy Category với id = " + test.getCategory_id());
                            }
                        }
                    } catch (Exception sqlEx) {
                        System.out.println("Lỗi SQL trực tiếp: " + sqlEx.getMessage());
                    }
                    
                    // Thử cách thông thường nếu trên không được
                    if (duration <= 0) {
                        Category category = categoryDAO.getCategoryById(test.getCategory_id());
                        if (category != null && category.getDuration() > 0) {
                            duration = category.getDuration();
                            System.out.println("Lấy được duration từ Category thông qua DAO: " + duration + " phút (category_id=" + test.getCategory_id() + ")");
                        } else {
                            System.out.println("Không tìm thấy Category hoặc duration = 0, sử dụng mặc định: 30 phút");
                            duration = 30; // Mặc định 30 phút cho bài test thực sự
                        }
                    }
                } catch (Exception e) {
                    System.out.println("Lỗi khi lấy duration từ Category: " + e.getMessage());
                    duration = 30; // Mặc định 30 phút cho bài test thực sự nếu có lỗi
                }
            } else {
                System.out.println("Bài test " + testId + " là bài luyện tập (is_practice=true), không áp dụng thời gian giới hạn");
            }
            
            // Lấy thời gian bắt đầu làm bài từ TestRecord hoặc thiết lập thời gian bắt đầu mới
            Long startTime = (Long) session.getAttribute("testStartTime");
            if (startTime == null) {
                // Lấy startTime từ TestRecord nếu có
                TestRecord testRecord = testRecordDAO.getTestRecordById(testRecordId);
                if (testRecord != null && testRecord.getStart_time() != null) {
                    // Chuyển từ java.sql.Timestamp sang milliseconds
                    startTime = testRecord.getStart_time().getTime();
                    System.out.println("Lấy được startTime từ TestRecord: " + new java.util.Date(startTime));
                } else {
                    // Nếu không có, tạo thời gian bắt đầu mới
                    startTime = System.currentTimeMillis();
                    System.out.println("Tạo mới startTime: " + new java.util.Date(startTime));
                    // Cập nhật startTime trong database nếu cần
                    testRecordDAO.updateStartTime(testRecordId, new java.sql.Timestamp(startTime));
                }
                session.setAttribute("testStartTime", startTime);
            } else {
                System.out.println("Lấy startTime từ session: " + new java.util.Date(startTime));
            }
            
            System.out.println("Test ID: " + testId + ", Is Practice: " + test.isIs_practice() + ", Duration: " + duration + " minutes, Start Time: " + new java.util.Date(startTime));
            
            // Đặt dữ liệu vào request
            request.setAttribute("test", test);
            request.setAttribute("questions", questions);
            request.setAttribute("allOptions", allOptions);
            request.setAttribute("previousAnswers", previousAnswers);
            request.setAttribute("totalQuestions", questions.size());
            request.setAttribute("duration", Integer.toString(duration)); // Truyền thời gian làm bài (phút) dưới dạng String
            request.setAttribute("startTime", Long.toString(startTime)); // Truyền thời gian bắt đầu dưới dạng String
            request.setAttribute("isPractice", test.isIs_practice()); // Thêm thông tin về loại bài test
            request.setAttribute("images", images); // Thêm danh sách hình ảnh
            
            // Hiển thị lỗi nếu có
            String error = (String) request.getAttribute("error");
            if (error != null) {
                request.setAttribute("error", error);
            }
            
            // Chuyển hướng đến trang hiển thị tất cả câu hỏi
            RequestDispatcher dispatcher = request.getRequestDispatcher("/student/takeTest.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("taketest");
        }
    }
    
    // Phương thức xử lý nộp bài với tất cả câu hỏi
    private void submitAllAnswers(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            HttpSession session = request.getSession();
            Integer testRecordId = (Integer) session.getAttribute("currentTestRecordId");
            Integer testId = (Integer) session.getAttribute("currentTestId");
            if (testRecordId == null || testId == null) {
                response.sendRedirect("taketest");
                return;
            }
            // Lấy danh sách câu hỏi để biết loại câu hỏi
            List<Question> questions = questionDAO.getQuestionsByTest(testId);
            int index = 0;
            String questionIdParam;
            while ((questionIdParam = request.getParameter("questionId" + index)) != null) {
                int questionId = Integer.parseInt(questionIdParam);
                Question question = null;
                for (Question q : questions) {
                    if (q.getId() == questionId) {
                        question = q;
                        break;
                    }
                }
                if (question != null) {
                    // Luôn xóa đáp án cũ trước khi lưu mới
                    questionRecordDAO.deleteQuestionRecordsByTestRecordAndQuestion(testRecordId, questionId);
                    if ("MULTIPLE".equals(question.getQuestion_type())) {
                        String[] optionIds = request.getParameterValues("optionId" + index);
                        if (optionIds != null) {
                            for (String optIdStr : optionIds) {
                                if (optIdStr != null && !optIdStr.isEmpty()) {
                                    int optionId = Integer.parseInt(optIdStr);
                                    questionRecordDAO.insertQuestionRecord(testRecordId, questionId, optionId);
                                }
                            }
                        }
                    } else {
                        String optionIdParam = request.getParameter("optionId" + index);
                        if (optionIdParam != null && !optionIdParam.isEmpty()) {
                            int optionId = Integer.parseInt(optionIdParam);
                            questionRecordDAO.insertQuestionRecord(testRecordId, questionId, optionId);
                        }
                    }
                }
                index++;
            }
            // Chuyển đến hoàn thành bài test
            finishTest(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("taketest");
        }
    }

    private void finishTest(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            System.out.println("\n***** FINISH TEST START *****");
            HttpSession session = request.getSession();
            Integer testRecordId = (Integer) session.getAttribute("currentTestRecordId");
            Integer testId = (Integer) session.getAttribute("currentTestId");
            System.out.println("Test record ID from session: " + testRecordId);

            if (testRecordId != null) {
                // Clear test timing information from session
                session.removeAttribute("testStartTime");
                
                // Check question records
                List<QuestionRecord> records = questionRecordDAO.getQuestionRecordsByTestRecord(testRecordId);
                System.out.println("Number of question records: " + records.size());
                
                // Lấy danh sách câu hỏi
                List<Question> questions = questionDAO.getQuestionsByTest(testId);
                
                // Kiểm tra xem đã trả lời đủ câu hỏi chưa
                Set<Integer> answeredQuestions = new HashSet<>();
                for (QuestionRecord record : records) {
                    answeredQuestions.add(record.getQuestion_id());
                }
                if (answeredQuestions.size() < questions.size()) {
                    // Chưa trả lời đủ câu hỏi
                    request.setAttribute("error", "Vui lòng trả lời tất cả câu hỏi trước khi nộp bài!");
                    // Chuyển hướng về trang làm bài
                    response.sendRedirect("taketest?action=question");
                    return;
                }
                
                // Tính điểm thực tế dựa trên câu trả lời
                double score = questionRecordDAO.calculateScore(testRecordId);
                System.out.println("ACTUAL SCORE CALCULATION: " + score);
                
                try {
                    // Attempt to save score
                    System.out.println("Calling finishTestRecord with testRecordId=" + testRecordId + ", score=" + score);
                    testRecordDAO.finishTestRecord(testRecordId, score);
                    System.out.println("finishTestRecord completed successfully");
                    
                    // Verify score was saved
                    TestRecord record = testRecordDAO.getTestRecordById(testRecordId);
                    if (record != null) {
                        System.out.println("VERIFICATION: Record retrieved, score=" + record.getScore());
                    } else {
                        System.out.println("ERROR: Could not retrieve test record after save");
                    }
                } catch (Exception e) {
                    System.out.println("ERROR in finishTestRecord: " + e.getMessage());
                    e.printStackTrace();
                }

                // Clear session
                session.removeAttribute("currentTestId");
                session.removeAttribute("currentTestRecordId");
                session.removeAttribute("currentQuestionIndex");
                
                System.out.println("Redirecting to result page: taketest?action=result&testRecordId=" + testRecordId);
                // Redirect to result page with valid testRecordId
                response.sendRedirect("taketest?action=result&testRecordId=" + testRecordId);
                System.out.println("***** FINISH TEST END *****\n");
            } else {
                System.out.println("ERROR: No testRecordId found in session");
                System.out.println("***** FINISH TEST FAILED *****\n");
                // No valid testRecordId, redirect to test list
                response.sendRedirect("taketest");
            }

        } catch (Exception e) {
            System.out.println("CRITICAL ERROR in finishTest: " + e.getMessage());
            e.printStackTrace();
            System.out.println("***** FINISH TEST FAILED WITH EXCEPTION *****\n");
            response.sendRedirect("taketest");
        }
    }

    private void showResult(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String testRecordIdParam = request.getParameter("testRecordId");
            if (testRecordIdParam == null || testRecordIdParam.equals("null")) {
                response.sendRedirect("taketest");
                return;
            }
            
            int testRecordId = Integer.parseInt(testRecordIdParam);
            TestRecord testRecord = testRecordDAO.getTestRecordById(testRecordId);
            
            if (testRecord == null) {
                request.setAttribute("error", "Không tìm thấy kết quả test!");
                showTestList(request, response);
                return;
            }

            Test test = testDAO.getTestById(testRecord.getTest_id());
            
            // Lấy tất cả câu trả lời từ bảng question_record
            List<QuestionRecord> questionRecords = questionRecordDAO.getQuestionRecordsByTestRecord(testRecordId);
            
            // Tạo map questionId -> List<QuestionRecord> để hiển thị mỗi câu hỏi 1 lần
            Map<Integer, List<QuestionRecord>> questionRecordMap = new HashMap<>();
            for (QuestionRecord record : questionRecords) {
                questionRecordMap.computeIfAbsent(record.getQuestion_id(), k -> new java.util.ArrayList<>()).add(record);
            }
            request.setAttribute("questionRecordMap", questionRecordMap);
            
            // Lấy thông tin chi tiết của các câu hỏi
            Map<Integer, Question> questionMap = new HashMap<>();
            Map<Integer, List<QuestionOption>> optionsMap = new HashMap<>();
            
            for (QuestionRecord record : questionRecords) {
                int questionId = record.getQuestion_id();
                
                // Chỉ lấy thông tin câu hỏi nếu chưa có trong map
                if (!questionMap.containsKey(questionId)) {
                    Question question = questionDAO.getQuestionById(questionId);
                    if (question != null) {
                        questionMap.put(questionId, question);
                        
                        // Lấy tất cả các lựa chọn của câu hỏi
                        List<QuestionOption> options = questionOptionDAO.getOptionsByQuestion(questionId);
                        optionsMap.put(questionId, options);
                    }
                }
            }
            
            // Lấy danh sách hình ảnh cho câu hỏi (giống takeTest.jsp)
            ImageDAO imageDAO = new ImageDAO(this.questionDAO.getDBConnection());
            List<Image> images = imageDAO.findAll();
            request.setAttribute("images", images);

            request.setAttribute("testRecord", testRecord);
            request.setAttribute("test", test);
            request.setAttribute("questionRecords", questionRecords);
            request.setAttribute("questionMap", questionMap);
            request.setAttribute("optionsMap", optionsMap);

            RequestDispatcher dispatcher = request.getRequestDispatcher("/student/testResult.jsp");
            dispatcher.forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Test record ID không hợp lệ!");
            showTestList(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải kết quả!");
            showTestList(request, response);
        }
    }

    private void showHistory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            Student student = (Student) session.getAttribute("student");

            if (student == null) {
                response.sendRedirect("/login.jsp");
                return;
            }

            System.out.println("DEBUG: Getting test records for student ID: " + student.getId());
            List<TestRecord> testRecords = testRecordDAO.getTestRecordsByStudent(student.getId());
            System.out.println("DEBUG: Found " + testRecords.size() + " test records");
            
            Map<Integer, String> testMap = new HashMap<>();

            for (TestRecord record : testRecords) {
                Test test = testDAO.getTestById(record.getTest_id());
                if (test != null) {
                    testMap.put(test.getId(), test.getName());
                }
                System.out.println("DEBUG: Record ID: " + record.getId() + ", Test ID: " + record.getTest_id() + ", Score: " + record.getScore());
            }

            request.setAttribute("testRecords", testRecords);
            request.setAttribute("testMap", testMap);

            RequestDispatcher dispatcher = request.getRequestDispatcher("/student/testHistory.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            System.out.println("DEBUG: Error in showHistory: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/student/testHistory.jsp");
            dispatcher.forward(request, response);
        }
    }

    private Map<Integer, String> getCategoryMap() {
        Map<Integer, String> categoryMap = new HashMap<>();
        try {
            List<Category> categories = categoryDAO.getAllCategories();
            for (Category category : categories) {
                categoryMap.put(category.getId(), category.getName());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return categoryMap;
    }
} 