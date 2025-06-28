/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.question;

import com.google.gson.Gson;
import dal.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.*;
import service.GeminiAIService;
import util.AuthUtil;
import util.RoleConstants;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author ankha
 */
@WebServlet("/ai-question")
public class AIQuestionController extends HttpServlet {

    private static final Logger logger = Logger.getLogger(AIQuestionController.class.getName());

    private GeminiAIService aiService = new GeminiAIService();
    private LessonDAO lessonDAO = new LessonDAO();
    private ChapterDAO chapterDAO = new ChapterDAO();
    private DAOSubject subjectDAO = new DAOSubject();
    private GradeDAO gradeDAO = new GradeDAO();
    private QuestionDAO questionDAO = new QuestionDAO();
    private QuestionOptionDAO questionOptionDAO = new QuestionOptionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!AuthUtil.hasRole(request, RoleConstants.ADMIN) && !AuthUtil.hasRole(request, RoleConstants.TEACHER)) {
            response.sendRedirect("/error.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        try {
            switch (action) {
                case "form":
                    showAIGenerationForm(request, response);
                    return;
                case "preview":
                    showPreviewPage(request, response);
                    return;
                // AJAX endpoints for hierarchy loading
                case "getSubjectsByGrade":
                    handleGetSubjectsByGrade(request, response);
                    return;
                case "getChaptersBySubject":
                    handleGetChaptersBySubject(request, response);
                    return;
                case "getLessonsByChapter":
                    handleGetLessonsByChapter(request, response);
                    return;
                case "getChapterContent":
                    handleGetChapterContent(request, response);
                    return;
                case "getSubjectContent":
                    handleGetSubjectContent(request, response);
                    return;
                default:
                    response.sendRedirect("/Question");
                    return;
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in AI Question Controller", e);
            if (!response.isCommitted()) {
                request.setAttribute("error", "System error: " + e.getMessage());
                request.getRequestDispatcher("/question/questionList.jsp").forward(request, response);
            } else {
                logger.log(Level.WARNING, "Response already committed, cannot forward to error page");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!AuthUtil.hasRole(request, RoleConstants.ADMIN) && !AuthUtil.hasRole(request, RoleConstants.TEACHER)) {
            response.sendRedirect("/error.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        try {
            switch (action) {
                case "generate":
                    generateQuestions(request, response);
                    return;
                case "chat":
                    handleChatWithAI(request, response);
                    return;
                case "approve":
                    approveAndSaveQuestions(request, response);
                    return;
                default:
                    response.sendRedirect("/Question");
                    return;
            }
        } catch (Exception e) {
            if (!response.isCommitted()) {
                request.setAttribute("error", "System error: " + e.getMessage());
                request.getRequestDispatcher("/question/questionList.jsp").forward(request, response);
            } else {
                logger.log(Level.WARNING, "Response already committed, cannot forward to error page");
            }
        }
    }

    private void showAIGenerationForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Grade> grades = gradeDAO.findAllFromGrade();
            List<Lesson> lessons = lessonDAO.getAllLessons();

            request.setAttribute("grades", grades);
            request.setAttribute("lessons", lessons);
            request.getRequestDispatcher("/question/aiQuestionForm.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException("Error loading AI generation form", e);
        }
    }

    private void showPreviewPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        List<GeminiAIService.AIQuestion> generatedQuestions
                = (List<GeminiAIService.AIQuestion>) session.getAttribute("generatedQuestions");

        if (generatedQuestions == null) {
            response.sendRedirect("/ai-question?action=form");
            return;
        }

        request.setAttribute("generatedQuestions", generatedQuestions);
        request.getRequestDispatcher("/question/aiQuestionPreview.jsp").forward(request, response);
    }

    private void generateQuestions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get form parameters
            String generationMode = request.getParameter("generation_mode");
            int numberOfQuestions = Integer.parseInt(request.getParameter("number_of_questions"));
            String difficulty = request.getParameter("difficulty");
            String questionType = request.getParameter("question_type");
            String additionalInstructions = request.getParameter("additional_instructions");

            // Store context for later use
            storeGenerationContext(request, generationMode);

            // Build content and lesson mapping based on generation mode
            ContentAndLessonMapping contentMapping = buildContentAndLessonMapping(request, generationMode);

            if (contentMapping == null) {
                throw new Exception("Failed to build content mapping");
            }

            // Build AI request
            GeminiAIService.AIGenerationRequest aiRequest = new GeminiAIService.AIGenerationRequest();
            aiRequest.setGradeName(contentMapping.getGradeName());
            aiRequest.setSubjectName(contentMapping.getSubjectName());
            aiRequest.setLessonName(contentMapping.getContextName());
            aiRequest.setLessonContent(contentMapping.getContent());
            aiRequest.setNumberOfQuestions(numberOfQuestions);
            aiRequest.setDifficulty(difficulty);
            aiRequest.setQuestionType(questionType);
            aiRequest.setAdditionalInstructions(additionalInstructions);

            // Generate questions using AI
            List<GeminiAIService.AIQuestion> generatedQuestions = aiService.generateQuestions(aiRequest);

            // Enhanced: Add lesson mapping information to each question
            enhanceQuestionsWithLessonMapping(generatedQuestions, contentMapping);

            // Store in session for preview
            HttpSession session = request.getSession();
            session.setAttribute("generatedQuestions", generatedQuestions);
            session.setAttribute("generationMode", generationMode);
            session.setAttribute("contentMapping", contentMapping);
            session.setAttribute("aiGenerationContext", buildContextString(
                    contentMapping.getGrade(), contentMapping.getSubject(), contentMapping.getContextName()));

            response.sendRedirect("/ai-question?action=preview");

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error generating AI questions", e);
            request.setAttribute("error", "Failed to generate questions: " + e.getMessage());
            showAIGenerationForm(request, response);
        }
    }

    /**
     * Build content and lesson mapping based on generation mode
     */
    private ContentAndLessonMapping buildContentAndLessonMapping(HttpServletRequest request, String generationMode)
            throws Exception {

        ContentAndLessonMapping mapping = new ContentAndLessonMapping();
        StringBuilder contentBuilder = new StringBuilder();

        if ("lesson".equals(generationMode)) {
            int lessonId = Integer.parseInt(request.getParameter("lesson_id"));
            Lesson lesson = lessonDAO.getLessonById(lessonId);
            if (lesson == null) {
                throw new Exception("Lesson not found");
            }

            contentBuilder.append(lesson.getContent());
            mapping.setContextName(lesson.getName());

            // For single lesson, create simple mapping
            Map<String, Integer> lessonMapping = new HashMap<>();
            lessonMapping.put(lesson.getName(), lesson.getId());
            mapping.setLessonMapping(lessonMapping);

            // Get lesson context
            Chapter chapter = chapterDAO.findChapterById(lesson.getChapter_id());
            Subject subject = subjectDAO.findById(chapter.getSubject_id());
            Grade grade = gradeDAO.getGradeById(subject.getGrade_id());

            mapping.setGrade(grade);
            mapping.setSubject(subject);
            mapping.setChapter(chapter);
            mapping.setLesson(lesson);

        } else if ("chapter".equals(generationMode)) {
            int chapterId = Integer.parseInt(request.getParameter("chapter_id"));
            Chapter chapter = chapterDAO.findChapterById(chapterId);
            if (chapter == null) {
                throw new Exception("Chapter not found");
            }

            // Get all lessons in this chapter
            List<Lesson> lessons = lessonDAO.getAllLessons();
            Map<String, Integer> lessonMapping = new HashMap<>();
            Map<String, String> lessonContentMap = new HashMap<>();

            for (Lesson lesson : lessons) {
                if (lesson.getChapter_id() == chapterId) {
                    String lessonKey = "Lesson: " + lesson.getName();
                    contentBuilder.append(lessonKey).append("\n");
                    contentBuilder.append(lesson.getContent()).append("\n\n");

                    // Store lesson mapping for intelligent assignment
                    lessonMapping.put(lesson.getName().toLowerCase(), lesson.getId());
                    lessonContentMap.put(lesson.getName().toLowerCase(), lesson.getContent());
                }
            }

            mapping.setLessonMapping(lessonMapping);
            mapping.setLessonContentMap(lessonContentMap);
            mapping.setContextName(chapter.getName());

            // Get chapter context
            Subject subject = subjectDAO.findById(chapter.getSubject_id());
            Grade grade = gradeDAO.getGradeById(subject.getGrade_id());

            mapping.setGrade(grade);
            mapping.setSubject(subject);
            mapping.setChapter(chapter);

        } else if ("subject".equals(generationMode)) {
            int subjectId = Integer.parseInt(request.getParameter("subject_id"));
            Subject subject = subjectDAO.findById(subjectId);
            if (subject == null) {
                throw new Exception("Subject not found");
            }

            // Get all chapters and lessons in this subject
            List<Chapter> chapters = chapterDAO.findChapterBySubjectId(subjectId);
            Map<String, Integer> lessonMapping = new HashMap<>();
            Map<String, String> lessonContentMap = new HashMap<>();

            for (Chapter chapter : chapters) {
                contentBuilder.append("Chapter: ").append(chapter.getName()).append("\n");
                contentBuilder.append(chapter.getDescription()).append("\n");

                List<Lesson> lessons = lessonDAO.getAllLessons();
                for (Lesson lesson : lessons) {
                    if (lesson.getChapter_id() == chapter.getId()) {
                        String lessonKey = "Lesson: " + lesson.getName();
                        contentBuilder.append("  ").append(lessonKey).append("\n");
                        contentBuilder.append("  ").append(lesson.getContent()).append("\n");

                        // Store lesson mapping for intelligent assignment
                        lessonMapping.put(lesson.getName().toLowerCase(), lesson.getId());
                        lessonContentMap.put(lesson.getName().toLowerCase(), lesson.getContent());
                    }
                }
                contentBuilder.append("\n");
            }

            mapping.setLessonMapping(lessonMapping);
            mapping.setLessonContentMap(lessonContentMap);
            mapping.setContextName(subject.getName());

            // Get subject context
            Grade grade = gradeDAO.getGradeById(subject.getGrade_id());

            mapping.setGrade(grade);
            mapping.setSubject(subject);
        }

        mapping.setContent(contentBuilder.toString());
        mapping.setGradeName(mapping.getGrade() != null ? mapping.getGrade().getName() : "Unknown Grade");
        mapping.setSubjectName(mapping.getSubject() != null ? mapping.getSubject().getName() : "Unknown Subject");

        return mapping;
    }

    /**
     * Enhance generated questions with lesson mapping information
     */
    private void enhanceQuestionsWithLessonMapping(List<GeminiAIService.AIQuestion> questions,
            ContentAndLessonMapping mapping) {

        for (GeminiAIService.AIQuestion question : questions) {
            // Try to intelligently assign lesson based on question content
            int assignedLessonId = intelligentLessonAssignment(question, mapping);
            question.setAssignedLessonId(assignedLessonId);
        }
    }

    /**
     * Intelligently assign lesson ID based on question content and available
     * lessons
     */
    private int intelligentLessonAssignment(GeminiAIService.AIQuestion question, ContentAndLessonMapping mapping) {
        String questionText = question.getQuestion().toLowerCase();
        Map<String, Integer> lessonMapping = mapping.getLessonMapping();
        Map<String, String> lessonContentMap = mapping.getLessonContentMap();

        // If only one lesson available, assign to it
        if (lessonMapping.size() == 1) {
            return lessonMapping.values().iterator().next();
        }

        // Try to match question content with lesson content
        int bestMatchScore = 0;
        int bestLessonId = -1;

        for (Map.Entry<String, Integer> entry : lessonMapping.entrySet()) {
            String lessonName = entry.getKey();
            int lessonId = entry.getValue();

            // Calculate similarity score
            int score = calculateContentSimilarity(questionText, lessonName, lessonContentMap.get(lessonName));

            if (score > bestMatchScore) {
                bestMatchScore = score;
                bestLessonId = lessonId;
            }
        }

        // If no good match found, assign to first available lesson
        if (bestLessonId == -1) {
            bestLessonId = lessonMapping.values().iterator().next();
        }

        return bestLessonId;
    }

    /**
     * Calculate content similarity between question and lesson
     */
    private int calculateContentSimilarity(String questionText, String lessonName, String lessonContent) {
        int score = 0;

        // Check if question contains lesson name or keywords
        if (questionText.contains(lessonName.toLowerCase())) {
            score += 10;
        }

        // Check for common keywords
        if (lessonContent != null) {
            String[] questionWords = questionText.split("\\s+");
            String[] lessonWords = lessonContent.toLowerCase().split("\\s+");

            for (String qWord : questionWords) {
                if (qWord.length() > 3) { // Only consider meaningful words
                    for (String lWord : lessonWords) {
                        if (qWord.equals(lWord)) {
                            score += 1;
                        }
                    }
                }
            }
        }

        return score;
    }

    private void handleChatWithAI(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String message = request.getParameter("message");
            HttpSession session = request.getSession();
            String context = (String) session.getAttribute("aiGenerationContext");

            String aiResponse = aiService.chatWithAI(message, context);

            PrintWriter out = response.getWriter();
            out.print("{\"response\": \"" + aiResponse.replace("\"", "\\\"").replace("\n", "\\n") + "\"}");
            out.flush();

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in AI chat", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            PrintWriter out = response.getWriter();
            out.print("{\"error\": \"Failed to get AI response\"}");
            out.flush();
        }
    }

    private void approveAndSaveQuestions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            List<GeminiAIService.AIQuestion> generatedQuestions
                    = (List<GeminiAIService.AIQuestion>) session.getAttribute("generatedQuestions");
            ContentAndLessonMapping contentMapping = (ContentAndLessonMapping) session.getAttribute("contentMapping");

            if (generatedQuestions == null) {
                throw new Exception("No generated questions found in session");
            }

            // Get modified questions from form
            String[] questionTexts = request.getParameterValues("question_text");
            String[] explanations = request.getParameterValues("explanation");
            String[] approvedFlags = request.getParameterValues("approved");

            int savedCount = 0;

            for (int i = 0; i < generatedQuestions.size(); i++) {
                // Check if this question is approved
                boolean isApproved = false;
                if (approvedFlags != null) {
                    for (String flag : approvedFlags) {
                        if (flag.equals(String.valueOf(i))) {
                            isApproved = true;
                            break;
                        }
                    }
                }

                if (!isApproved) {
                    continue;
                }

                GeminiAIService.AIQuestion aiQuestion = generatedQuestions.get(i);

                // Use modified text if provided
                String finalQuestionText = (questionTexts != null && i < questionTexts.length)
                        ? questionTexts[i] : aiQuestion.getQuestion();
                String finalExplanation = (explanations != null && i < explanations.length)
                        ? explanations[i] : aiQuestion.getExplanation();

                // Determine question type for database
                String dbQuestionType = "SINGLE"; // Default
                switch (aiQuestion.getQuestionType().toLowerCase()) {
                    case "multiple_choice":
                        dbQuestionType = "MULTIPLE";
                        break;
                    case "true_false":
                    case "single_choice":
                    default:
                        dbQuestionType = "SINGLE";
                        break;
                }

                // Enhanced: Use intelligent lesson assignment
                int lessonId = aiQuestion.getAssignedLessonId();
                if (lessonId <= 0) {
                    // Fallback to default assignment if intelligent assignment failed
                    lessonId = getDefaultLessonId(contentMapping);
                }

                // Save question to database
                Question question = new Question();
                question.setQuestion(finalQuestionText);
                question.setLesson_id(lessonId);
                question.setQuestion_type(dbQuestionType);
                question.setImage_id(0); // No image for AI generated questions

                questionDAO.insert(question);

                // Get the inserted question ID
                List<Question> allQuestions = questionDAO.findAllQuestion();
                int questionId = allQuestions.get(allQuestions.size() - 1).getId();

                // Save options based on question type
                List<Integer> correctAnswers = aiQuestion.getCorrectAnswers();
                if (correctAnswers == null || correctAnswers.isEmpty()) {
                    correctAnswers = List.of(aiQuestion.getCorrectAnswerIndex());
                }

                for (int j = 0; j < aiQuestion.getOptions().size(); j++) {
                    QuestionOption option = new QuestionOption();
                    option.setQuestion_id(questionId);
                    option.setContent(aiQuestion.getOptions().get(j));

                    // Check if this option is correct
                    boolean isCorrectOption = correctAnswers.contains(j);
                    option.setIs_correct(isCorrectOption);

                    questionOptionDAO.insertOption(option);
                }

                savedCount++;

                // Log the lesson assignment for debugging
                logger.info("Question saved to lesson ID: " + lessonId + " - Question: "
                        + finalQuestionText.substring(0, Math.min(50, finalQuestionText.length())));
            }

            // Clear session data
            session.removeAttribute("generatedQuestions");
            session.removeAttribute("generationMode");
            session.removeAttribute("contentMapping");
            session.removeAttribute("aiGenerationContext");

            // Set success message and redirect
            session.setAttribute("message", "Successfully saved " + savedCount + " AI-generated questions with intelligent lesson assignment!");
            response.sendRedirect("/Question");

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error saving AI questions", e);
            request.setAttribute("error", "Failed to save questions: " + e.getMessage());
            showPreviewPage(request, response);
        }
    }

    /**
     * Get default lesson ID as fallback
     */
    private int getDefaultLessonId(ContentAndLessonMapping mapping) {
        if (mapping != null && mapping.getLessonMapping() != null && !mapping.getLessonMapping().isEmpty()) {
            return mapping.getLessonMapping().values().iterator().next();
        }

        // Last resort: get any available lesson
        List<Lesson> allLessons = lessonDAO.getAllLessons();
        if (!allLessons.isEmpty()) {
            return allLessons.get(0).getId();
        }

        return 1; // Ultimate fallback
    }

    // AJAX handlers for hierarchical data loading (same as in QuestionController)
    private void handleGetSubjectsByGrade(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            int gradeId = Integer.parseInt(request.getParameter("gradeId"));
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

    private void handleGetChapterContent(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            int chapterId = Integer.parseInt(request.getParameter("chapterId"));
            Chapter chapter = chapterDAO.findChapterById(chapterId);

            if (chapter == null) {
                response.getWriter().write("{\"error\": \"Chapter not found\"}");
                return;
            }

            StringBuilder contentBuilder = new StringBuilder();
            contentBuilder.append("Chapter: ").append(chapter.getName()).append("\\n");
            contentBuilder.append("Description: ").append(chapter.getDescription()).append("\\n\\n");

            // Get all lessons in this chapter
            List<Lesson> lessons = lessonDAO.getAllLessons();
            int lessonCount = 0;
            for (Lesson lesson : lessons) {
                if (lesson.getChapter_id() == chapterId) {
                    contentBuilder.append("Lesson ").append(++lessonCount).append(": ")
                            .append(lesson.getName()).append("\\n");
                    contentBuilder.append(lesson.getContent().replace("\"", "\\\"").replace("\n", "\\n"))
                            .append("\\n\\n");
                }
            }

            String json = "{\"content\": \"" + contentBuilder.toString() + "\", \"lessonCount\": " + lessonCount + "}";
            response.getWriter().write(json);
        } catch (Exception e) {
            response.getWriter().write("{\"error\": \"Failed to load chapter content\"}");
        }
    }

    private void handleGetSubjectContent(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            int subjectId = Integer.parseInt(request.getParameter("subjectId"));
            Subject subject = subjectDAO.findById(subjectId);

            if (subject == null) {
                response.getWriter().write("{\"error\": \"Subject not found\"}");
                return;
            }

            StringBuilder contentBuilder = new StringBuilder();
            contentBuilder.append("Subject: ").append(subject.getName()).append("\\n");
            contentBuilder.append("Description: ").append(subject.getDescription()).append("\\n\\n");

            // Get all chapters in this subject
            List<Chapter> chapters = chapterDAO.findChapterBySubjectId(subjectId);
            int totalLessons = 0;

            for (Chapter chapter : chapters) {
                contentBuilder.append("Chapter: ").append(chapter.getName()).append("\\n");
                contentBuilder.append(chapter.getDescription()).append("\\n");

                // Get lessons in this chapter
                List<Lesson> lessons = lessonDAO.getAllLessons();
                int chapterLessons = 0;
                for (Lesson lesson : lessons) {
                    if (lesson.getChapter_id() == chapter.getId()) {
                        chapterLessons++;
                        totalLessons++;
                        contentBuilder.append("  Lesson ").append(chapterLessons).append(": ")
                                .append(lesson.getName()).append("\\n");
                        // Truncate lesson content for subject overview
                        String lessonContent = lesson.getContent();
                        if (lessonContent.length() > 200) {
                            lessonContent = lessonContent.substring(0, 200) + "...";
                        }
                        contentBuilder.append("  ").append(lessonContent.replace("\"", "\\\"").replace("\n", "\\n"))
                                .append("\\n");
                    }
                }
                contentBuilder.append("\\n");
            }

            String json = "{\"content\": \"" + contentBuilder.toString() + "\", \"chapterCount\": " + chapters.size() + ", \"lessonCount\": " + totalLessons + "}";
            response.getWriter().write(json);
        } catch (Exception e) {
            response.getWriter().write("{\"error\": \"Failed to load subject content\"}");
        }
    }

    private String buildContextString(Grade grade, Subject subject, String contextName) {
        return String.format("Grade: %s, Subject: %s, Context: %s",
                grade != null ? grade.getName() : "Unknown",
                subject != null ? subject.getName() : "Unknown",
                contextName);
    }

    private void storeGenerationContext(HttpServletRequest request, String generationMode) {
        HttpSession session = request.getSession();

        try {
            switch (generationMode) {
                case "lesson":
                    String lessonIdParam = request.getParameter("lesson_id");
                    if (lessonIdParam != null) {
                        session.setAttribute("selectedLessonId", Integer.parseInt(lessonIdParam));
                    }
                    break;

                case "chapter":
                    String chapterIdParam = request.getParameter("chapter_id");
                    if (chapterIdParam != null) {
                        session.setAttribute("selectedChapterId", Integer.parseInt(chapterIdParam));
                    }
                    break;

                case "subject":
                    String subjectIdParam = request.getParameter("subject_id");
                    if (subjectIdParam != null) {
                        session.setAttribute("selectedSubjectId", Integer.parseInt(subjectIdParam));
                    }
                    break;
            }

            session.setAttribute("currentGenerationMode", generationMode);

        } catch (NumberFormatException e) {
            logger.warning("Invalid ID parameter in generation context: " + e.getMessage());
        }
    }

    /**
     * Inner class to hold content and lesson mapping information
     */
    public static class ContentAndLessonMapping {

        private String content;
        private String contextName;
        private String gradeName;
        private String subjectName;
        private Grade grade;
        private Subject subject;
        private Chapter chapter;
        private Lesson lesson;
        private Map<String, Integer> lessonMapping;
        private Map<String, String> lessonContentMap;

        // Getters and setters
        public String getContent() {
            return content;
        }

        public void setContent(String content) {
            this.content = content;
        }

        public String getContextName() {
            return contextName;
        }

        public void setContextName(String contextName) {
            this.contextName = contextName;
        }

        public String getGradeName() {
            return gradeName;
        }

        public void setGradeName(String gradeName) {
            this.gradeName = gradeName;
        }

        public String getSubjectName() {
            return subjectName;
        }

        public void setSubjectName(String subjectName) {
            this.subjectName = subjectName;
        }

        public Grade getGrade() {
            return grade;
        }

        public void setGrade(Grade grade) {
            this.grade = grade;
        }

        public Subject getSubject() {
            return subject;
        }

        public void setSubject(Subject subject) {
            this.subject = subject;
        }

        public Chapter getChapter() {
            return chapter;
        }

        public void setChapter(Chapter chapter) {
            this.chapter = chapter;
        }

        public Lesson getLesson() {
            return lesson;
        }

        public void setLesson(Lesson lesson) {
            this.lesson = lesson;
        }

        public Map<String, Integer> getLessonMapping() {
            return lessonMapping;
        }

        public void setLessonMapping(Map<String, Integer> lessonMapping) {
            this.lessonMapping = lessonMapping;
        }

        public Map<String, String> getLessonContentMap() {
            return lessonContentMap;
        }

        public void setLessonContentMap(Map<String, String> lessonContentMap) {
            this.lessonContentMap = lessonContentMap;
        }
    }
}
