package controller.lesson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.Lesson;
import dal.LessonDAO;
import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Chapter;
import dal.ChapterDAO;
import service.VideoService;
import util.AuthUtil;
import util.RoleConstants;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/LessonURL")
@MultipartConfig(
        fileSizeThreshold = 10 * 1024 * 1024, // 10MB
        maxFileSize = 100 * 1024 * 1024, // 100MB
        maxRequestSize = 200 * 1024 * 1024 // 200MB
)
public class LessonController extends HttpServlet {

    private static final Logger logger = Logger.getLogger(LessonController.class.getName());
    private LessonDAO lessonDAO = new LessonDAO();
    private VideoService videoService;

    @Override
    public void init() throws ServletException {
        try {
            videoService = new VideoService(getServletContext());
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Không thể khởi tạo VideoService", e);
            throw new ServletException("Không thể khởi tạo VideoService", e);
        }
    }

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
                    List<Chapter> chapterName = new ChapterDAO().getChapter("select * from chapter");
                    request.setAttribute("chapterName", chapterName);
                    request.getRequestDispatcher("lesson/addLesson.jsp").forward(request, response);
                    return;

                case "updateForm":
                    String idStr = request.getParameter("id");
                    if (idStr != null) {
                        int id = Integer.parseInt(idStr);
                        Lesson lesson = lessonDAO.getLessonById(id);
                        if (lesson != null) {
                            List<Chapter> chapter = new ChapterDAO().getChapter("select * from chapter");
                            request.setAttribute("chapter", chapter);
                            request.setAttribute("lesson", lesson);
                            request.getRequestDispatcher("lesson/updateLesson.jsp").forward(request, response);
                            return;
                        } else {
                            request.setAttribute("error", "Không tìm thấy lesson với ID " + id);
                        }
                    } else {
                        request.setAttribute("error", "ID không hợp lệ");
                    }
                    break;

                case "delete":
                    String delIdStr = request.getParameter("id");
                    if (delIdStr != null) {
                        int delId = Integer.parseInt(delIdStr);
                        // Lấy thông tin lesson trước khi xóa để xóa video
                        Lesson lessonToDelete = lessonDAO.getLessonById(delId);
                        if (lessonToDelete != null && lessonToDelete.getVideo_link() != null && !lessonToDelete.getVideo_link().isEmpty()) {
                            try {
                                // Xóa video trên cloud storage
                                videoService.deleteOldVideo(lessonToDelete.getVideo_link());
                            } catch (Exception e) {
                                logger.log(Level.WARNING, "Không thể xóa video khi xóa bài học", e);
                            }
                        }
                        lessonDAO.deleteLesson(delId);
                        response.sendRedirect("LessonURL");
                        return;
                    } else {
                        request.setAttribute("error", "ID không hợp lệ để xóa");
                    }
                    break;

                case "videoViewer":
                    String lessonIdParam = request.getParameter("id");
                    if (lessonIdParam != null) {
                        response.sendRedirect("/video-viewer?lessonId=" + lessonIdParam);
                    } else {
                        response.sendRedirect("/LessonURL");
                    }
                    return;
                default:
                    String name = request.getParameter("name");
                    List<Lesson> lessonList;
                    if (name != null && !name.trim().isEmpty()) {
                        lessonList = lessonDAO.searchByName(name.trim());
                        if (lessonList == null || lessonList.isEmpty()) {
                            request.setAttribute("error", "Không tìm thấy bài học nào với tên: " + name);
                        }
                    } else {
                        lessonList = lessonDAO.getAllLessons();
                    }
                    request.setAttribute("lessonList", lessonList);
                    List<Chapter> chapter = new ChapterDAO().getChapter("select * from chapter");
                    request.setAttribute("chapter", chapter);
                    break;
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Lỗi xử lý GET request", e);
            request.setAttribute("error", "Lỗi xử lý yêu cầu: " + e.getMessage());
        }

        request.getRequestDispatcher("lesson/lessonList.jsp").forward(request, response);
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
            if ("insert".equals(action)) {
                String name = request.getParameter("name");
                String content = request.getParameter("content");
                int chapterId = Integer.parseInt(request.getParameter("chapter_id"));

                Lesson lesson = new Lesson(0, name, content, chapterId, "");

                // Handle video file if present
                Part videoPart = request.getPart("video_file");
                if (videoPart != null && videoPart.getSize() > 0) {
                    String videoUrl = videoService.uploadAndUpdateLesson(videoPart, lesson);
                    lesson.setVideo_link(videoUrl);
                }

                lessonDAO.addLesson(lesson);

                // Check if should return to course builder
                String returnTo = request.getParameter("returnTo");
                String courseId = request.getParameter("courseId");

                if ("course".equals(returnTo) && courseId != null) {
                    response.sendRedirect("/course?action=build&id=" + courseId + "&message=Lesson created successfully");
                    return;
                }

                request.setAttribute("message", "Lesson added successfully");
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String name = request.getParameter("name");
                String content = request.getParameter("content");
                int chapterId = Integer.parseInt(request.getParameter("chapter_id"));

                // Lấy thông tin bài học hiện tại
                Lesson currentLesson = lessonDAO.getLessonById(id);
                String currentVideoLink = currentLesson != null ? currentLesson.getVideo_link() : "";

                // Tạo đối tượng Lesson mới với thông tin cập nhật
                Lesson lesson = new Lesson(id, name, content, chapterId, currentVideoLink);

                // Xử lý nếu có file video mới
                Part videoPart = request.getPart("video_file");
                if (videoPart != null && videoPart.getSize() > 0) {
                    String videoUrl = videoService.uploadAndUpdateLesson(videoPart, lesson);
                    lesson.setVideo_link(videoUrl);
                }

                // Cập nhật bài học vào database
                lessonDAO.updateLesson(lesson);
                request.setAttribute("message", "Cập nhật bài học thành công");

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                // Lấy thông tin lesson trước khi xóa để xóa video
                Lesson lessonToDelete = lessonDAO.getLessonById(id);
                if (lessonToDelete != null && lessonToDelete.getVideo_link() != null && !lessonToDelete.getVideo_link().isEmpty()) {
                    try {
                        // Xóa video trên cloud storage
                        videoService.deleteOldVideo(lessonToDelete.getVideo_link());
                    } catch (Exception e) {
                        logger.log(Level.WARNING, "Không thể xóa video khi xóa bài học", e);
                    }
                }
                lessonDAO.deleteLesson(id);
                request.setAttribute("message", "Xóa bài học thành công");
            }

            List<Lesson> lessonList = lessonDAO.getAllLessons();
            request.setAttribute("lessonList", lessonList);
            List<Chapter> chapter = new ChapterDAO().getChapter("select * from chapter");
            request.setAttribute("chapter", chapter);

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Lỗi xử lý POST request", e);
            request.setAttribute("error", "Lỗi xử lý POST: " + e.getMessage());
        }

        request.getRequestDispatcher("lesson/lessonList.jsp").forward(request, response);
    }
}
