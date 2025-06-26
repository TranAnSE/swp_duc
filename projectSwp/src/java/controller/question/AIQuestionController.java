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
        if (action == null) action = "";
        
        try {
            switch (action) {
                case "form":
                    showAIGenerationForm(request, response);
                    break;
                case "preview":
                    showPreviewPage(request, response);
                    break;
                default:
                    response.sendRedirect("/Question");
                    break;
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in AI Question Controller", e);
            request.setAttribute("error", "System error: " + e.getMessage());
            request.getRequestDispatcher("/question/questionList.jsp").forward(request, response);
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
        if (action == null) action = "";
        
        try {
            switch (action) {
                case "generate":
                    generateQuestions(request, response);
                    break;
                case "chat":
                    handleChatWithAI(request, response);
                    break;
                case "approve":
                    approveAndSaveQuestions(request, response);
                    break;
                default:
                    response.sendRedirect("/Question");
                    break;
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in AI Question Controller POST", e);
            request.setAttribute("error", "System error: " + e.getMessage());
            request.getRequestDispatcher("/question/questionList.jsp").forward(request, response);
        }
    }
    
    private void showAIGenerationForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Lesson> lessons = lessonDAO.getAllLessons();
            request.setAttribute("lessons", lessons);
            request.getRequestDispatcher("/question/aiQuestionForm.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException("Error loading AI generation form", e);
        }
    }
    
    private void showPreviewPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        List<GeminiAIService.AIQuestion> generatedQuestions = 
            (List<GeminiAIService.AIQuestion>) session.getAttribute("generatedQuestions");
        
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
            int lessonId = Integer.parseInt(request.getParameter("lesson_id"));
            int numberOfQuestions = Integer.parseInt(request.getParameter("number_of_questions"));
            String difficulty = request.getParameter("difficulty");
            String questionType = request.getParameter("question_type");
            String additionalInstructions = request.getParameter("additional_instructions");
            
            // Get lesson and related information
            Lesson lesson = lessonDAO.getLessonById(lessonId);
            if (lesson == null) {
                throw new Exception("Lesson not found");
            }
            
            Chapter chapter = chapterDAO.findChapterById(lesson.getChapter_id());
            Subject subject = subjectDAO.findById(chapter.getSubject_id());
            Grade grade = gradeDAO.getGradeById(subject.getGrade_id());
            
            // Build AI request
            GeminiAIService.AIGenerationRequest aiRequest = new GeminiAIService.AIGenerationRequest();
            aiRequest.setGradeName(grade.getName());
            aiRequest.setSubjectName(subject.getName());
            aiRequest.setLessonName(lesson.getName());
            aiRequest.setLessonContent(lesson.getContent());
            aiRequest.setNumberOfQuestions(numberOfQuestions);
            aiRequest.setDifficulty(difficulty);
            aiRequest.setQuestionType(questionType);
            aiRequest.setAdditionalInstructions(additionalInstructions);
            
            // Generate questions using AI
            List<GeminiAIService.AIQuestion> generatedQuestions = aiService.generateQuestions(aiRequest);
            
            // Store in session for preview
            HttpSession session = request.getSession();
            session.setAttribute("generatedQuestions", generatedQuestions);
            session.setAttribute("selectedLessonId", lessonId);
            session.setAttribute("aiGenerationContext", buildContextString(grade, subject, lesson));
            
            response.sendRedirect("/ai-question?action=preview");
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error generating AI questions", e);
            request.setAttribute("error", "Failed to generate questions: " + e.getMessage());
            showAIGenerationForm(request, response);
        }
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
            
            // Return JSON response
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
            List<GeminiAIService.AIQuestion> generatedQuestions = 
                (List<GeminiAIService.AIQuestion>) session.getAttribute("generatedQuestions");
            Integer lessonId = (Integer) session.getAttribute("selectedLessonId");
            
            if (generatedQuestions == null || lessonId == null) {
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
                
                if (!isApproved) continue;
                
                GeminiAIService.AIQuestion aiQuestion = generatedQuestions.get(i);
                
                // Use modified text if provided
                String finalQuestionText = (questionTexts != null && i < questionTexts.length) 
                    ? questionTexts[i] : aiQuestion.getQuestion();
                String finalExplanation = (explanations != null && i < explanations.length) 
                    ? explanations[i] : aiQuestion.getExplanation();
                
                // Save question to database
                Question question = new Question();
                question.setQuestion(finalQuestionText);
                question.setLesson_id(lessonId);
                question.setQuestion_type("SINGLE"); // AI generates single choice questions
                question.setImage_id(0); // No image for AI generated questions
                
                questionDAO.insert(question);
                
                // Get the inserted question ID
                List<Question> allQuestions = questionDAO.findAllQuestion();
                int questionId = allQuestions.get(allQuestions.size() - 1).getId();
                
                // Save options
                for (int j = 0; j < aiQuestion.getOptions().size(); j++) {
                    QuestionOption option = new QuestionOption();
                    option.setQuestion_id(questionId);
                    option.setContent(aiQuestion.getOptions().get(j));
                    option.setIs_correct(j == aiQuestion.getCorrectAnswerIndex());
                    questionOptionDAO.insertOption(option);
                }
                
                savedCount++;
            }
            
            // Clear session data
            session.removeAttribute("generatedQuestions");
            session.removeAttribute("selectedLessonId");
            session.removeAttribute("aiGenerationContext");
            
            request.setAttribute("message", "Successfully saved " + savedCount + " AI-generated questions");
            response.sendRedirect("/Question");
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error saving AI questions", e);
            request.setAttribute("error", "Failed to save questions: " + e.getMessage());
            showPreviewPage(request, response);
        }
    }
    
    private String buildContextString(Grade grade, Subject subject, Lesson lesson) {
        return String.format("Grade: %s, Subject: %s, Lesson: %s - %s", 
            grade.getName(), subject.getName(), lesson.getName(), lesson.getContent());
    }
}