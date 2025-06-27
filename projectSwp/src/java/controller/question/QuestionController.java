package controller.question;

import dal.*;
import model.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.util.Base64;
import java.util.List;
import util.AuthUtil;
import util.RoleConstants;

@MultipartConfig
@WebServlet(name = "QuestionController", urlPatterns = {"/Question"})
public class QuestionController extends HttpServlet {

    private QuestionDAO questionDAO = new QuestionDAO();
    private ImageDAO imageDAO = new ImageDAO(questionDAO.getDBConnection());
    private QuestionOptionDAO questionOptionDAO = new QuestionOptionDAO();
    private TestQuestionDAO testQuestionDAO = new TestQuestionDAO();
    private QuestionRecordDAO questionRecordDAO = new QuestionRecordDAO();

    private GradeDAO gradeDAO = new GradeDAO();
    private DAOSubject subjectDAO = new DAOSubject();
    private ChapterDAO chapterDAO = new ChapterDAO();
    private LessonDAO lessonDAO = new LessonDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!AuthUtil.hasRole(request, RoleConstants.ADMIN) && !AuthUtil.hasRole(request, RoleConstants.TEACHER) && !AuthUtil.hasRole(request, RoleConstants.STUDENT)) {
            response.sendRedirect("/error.jsp");
            return;
        }
        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        try {
            switch (action) {
                case "addForm":
                    // Load hierarchy data for selection
                    List<Grade> gradeList = gradeDAO.findAllFromGrade();
                    request.setAttribute("gradeList", gradeList);
                    request.getRequestDispatcher("question/addQuestion.jsp").forward(request, response);
                    return;

                case "updateForm":
                    String idStr = request.getParameter("id");
                    if (idStr != null) {
                        int id = Integer.parseInt(idStr);
                        Question question = questionDAO.getQuestionById(id);

                        // Load hierarchy data
                        List<Grade> gradeList2 = gradeDAO.findAllFromGrade();
                        List<QuestionOption> options = questionOptionDAO.getOptionsByQuestion(id);

                        request.setAttribute("question", question);
                        request.setAttribute("gradeList", gradeList2);
                        request.setAttribute("options", options);

                        // If question has lesson, load the full hierarchy
                        if (question.getLesson_id() > 0) {
                            Lesson lesson = lessonDAO.getLessonById(question.getLesson_id());
                            if (lesson != null) {
                                Chapter chapter = chapterDAO.findChapterById(lesson.getChapter_id());
                                if (chapter != null) {
                                    Subject subject = subjectDAO.findById(chapter.getSubject_id());
                                    if (subject != null) {
                                        Grade grade = gradeDAO.getGradeById(subject.getGrade_id());

                                        request.setAttribute("selectedGrade", grade);
                                        request.setAttribute("selectedSubject", subject);
                                        request.setAttribute("selectedChapter", chapter);
                                        request.setAttribute("selectedLesson", lesson);

                                        // Load related data for dropdowns
                                        List<Subject> subjectList = subjectDAO.findAll();
                                        List<Chapter> chapterList = chapterDAO.getChapter("SELECT * FROM chapter WHERE subject_id = " + subject.getId());
                                        List<Lesson> lessonList = lessonDAO.getAllLessons();

                                        request.setAttribute("subjectList", subjectList);
                                        request.setAttribute("chapterList", chapterList);
                                        request.setAttribute("lessonList", lessonList);
                                    }
                                }
                            }
                        }

                        request.getRequestDispatcher("question/updateQuestion.jsp").forward(request, response);
                        return;
                    }
                    break;

                case "delete":
                    int delId = Integer.parseInt(request.getParameter("id"));
                    questionRecordDAO.deleteByQuestionId(delId);
                    testQuestionDAO.removeQuestionFromAllTests(delId);
                    questionOptionDAO.deleteOptionsByQuestion(delId);
                    questionDAO.delete(delId);
                    response.sendRedirect("Question");
                    return;

                case "ai":
                    response.sendRedirect("/ai-question?action=form");
                    return;

                case "getSubjectsByGrade":
                    handleGetSubjectsByGrade(request, response);
                    return;

                case "getChaptersBySubject":
                    handleGetChaptersBySubject(request, response);
                    return;

                case "getLessonsByChapter":
                    handleGetLessonsByChapter(request, response);
                    return;

                default:
                    String keyword = request.getParameter("question");
                    List<Question> list;
                    if (keyword != null && !keyword.trim().isEmpty()) {
                        list = questionDAO.findByQuestion(keyword.trim());
                    } else {
                        list = questionDAO.findAllQuestion();
                    }

                    LessonDAO dao = new LessonDAO();
                    List<Lesson> les = dao.getAllLessons();
                    request.setAttribute("les", les);
                    request.setAttribute("questionList", list);

                    try {
                        List<Image> images = imageDAO.findAll();
                        request.setAttribute("images", images);
                    } catch (Exception e) {
                        e.printStackTrace();
                        request.setAttribute("imageError", "Lỗi khi tải dữ liệu ảnh: " + e.getMessage());
                    }
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
        }

        request.getRequestDispatcher("question/questionList.jsp").forward(request, response);
    }

    // AJAX handlers for hierarchical data loading
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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!AuthUtil.hasRole(request, RoleConstants.ADMIN) && !AuthUtil.hasRole(request, RoleConstants.TEACHER) && !AuthUtil.hasRole(request, RoleConstants.STUDENT)) {
            response.sendRedirect("/error.jsp");
            return;
        }
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
            String questionText = request.getParameter("question");
            int lesson_id = 0;
            String lessonIdStr = request.getParameter("lesson_id");
            if (lessonIdStr != null && !lessonIdStr.isEmpty()) {
                lesson_id = Integer.parseInt(lessonIdStr);
            }

            int image_id = 0;
            Part imagePart = request.getPart("image_file");
            if (imagePart != null && imagePart.getSize() > 0) {
                InputStream inputStream = imagePart.getInputStream();
                byte[] imageBytes = inputStream.readAllBytes();
                String base64Image = Base64.getEncoder().encodeToString(imageBytes);
                Image img = new Image();
                img.setImage_data(base64Image);
                image_id = imageDAO.insertImage(img);
            }

            String questionType = request.getParameter("question_type");
            if (questionType == null || (!questionType.equals("SINGLE") && !questionType.equals("MULTIPLE"))) {
                questionType = "SINGLE";
            }

            if ("insert".equals(action)) {
                Question q = new Question(questionText, image_id, lesson_id, questionType);
                questionDAO.insert(q);
                int questionId = questionDAO.findAllQuestion().get(questionDAO.findAllQuestion().size() - 1).getId();
                String[] optionContents = request.getParameterValues("optionContent");
                boolean[] correctArr;
                if ("SINGLE".equals(questionType)) {
                    int correctIndex = -1;
                    String correctOption = request.getParameter("correctOption");
                    if (correctOption != null) {
                        correctIndex = Integer.parseInt(correctOption);
                    }
                    correctArr = new boolean[optionContents.length];
                    for (int i = 0; i < correctArr.length; i++) {
                        correctArr[i] = (i == correctIndex);
                    }
                } else {
                    correctArr = new boolean[optionContents.length];
                    for (int i = 0; i < correctArr.length; i++) {
                        String val = request.getParameter("correctOption" + i);
                        correctArr[i] = (val != null && val.equals("true"));
                    }
                }
                for (int i = 0; i < optionContents.length; i++) {
                    QuestionOption opt = new QuestionOption();
                    opt.setQuestion_id(questionId);
                    opt.setContent(optionContents[i]);
                    opt.setIs_correct(correctArr[i]);
                    questionOptionDAO.insertOption(opt);
                }
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Question q = new Question(id, questionText, image_id, lesson_id, questionType);
                questionDAO.update(q);
                questionOptionDAO.deleteOptionsByQuestion(id);
                String[] optionContents = request.getParameterValues("optionContent");
                boolean[] correctArr;
                if ("SINGLE".equals(questionType)) {
                    int correctIndex = -1;
                    String correctOption = request.getParameter("correctOption");
                    if (correctOption != null) {
                        correctIndex = Integer.parseInt(correctOption);
                    }
                    correctArr = new boolean[optionContents.length];
                    for (int i = 0; i < correctArr.length; i++) {
                        correctArr[i] = (i == correctIndex);
                    }
                } else {
                    correctArr = new boolean[optionContents.length];
                    for (int i = 0; i < correctArr.length; i++) {
                        String val = request.getParameter("correctOption" + i);
                        correctArr[i] = (val != null && val.equals("true"));
                    }
                }
                for (int i = 0; i < optionContents.length; i++) {
                    QuestionOption opt = new QuestionOption();
                    opt.setQuestion_id(id);
                    opt.setContent(optionContents[i]);
                    opt.setIs_correct(correctArr[i]);
                    questionOptionDAO.insertOption(opt);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error while processing request: " + e.getMessage());
        }

        response.sendRedirect("Question");
    }
}
