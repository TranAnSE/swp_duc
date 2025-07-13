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

                    // Check if coming from course builder
                    String returnTo = request.getParameter("returnTo");
                    String courseId = request.getParameter("courseId");
                    String chapterId = request.getParameter("chapterId");

                    if ("buildCourse".equals(returnTo) && courseId != null) {
                        request.setAttribute("returnToCourse", true);
                        request.setAttribute("courseId", courseId);
                        if (chapterId != null) {
                            request.setAttribute("preSelectedChapterId", chapterId);
                        }
                    }

                    // Set return navigation attributes
                    setReturnAttributes(request);

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

                            // Set return navigation attributes
                            setReturnAttributes(request);

                            request.getRequestDispatcher("lesson/updateLesson.jsp").forward(request, response);
                            return;
                        } else {
                            request.setAttribute("error", "Lesson not found with ID " + id);
                        }
                    } else {
                        request.setAttribute("error", "Invalid ID");
                    }
                    break;

                case "delete":
                    String delIdStr = request.getParameter("id");
                    if (delIdStr != null) {
                        int delId = Integer.parseInt(delIdStr);
                        // Get lesson info before deleting to delete video
                        Lesson lessonToDelete = lessonDAO.getLessonById(delId);
                        if (lessonToDelete != null && lessonToDelete.getVideo_link() != null && !lessonToDelete.getVideo_link().isEmpty()) {
                            try {
                                // Delete video on cloud storage
                                videoService.deleteOldVideo(lessonToDelete.getVideo_link());
                            } catch (Exception e) {
                                logger.log(Level.WARNING, "Cannot delete video when deleting lesson", e);
                            }
                        }
                        lessonDAO.deleteLesson(delId);
                        response.sendRedirect("LessonURL");
                        return;
                    } else {
                        request.setAttribute("error", "Invalid ID for deletion");
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
                    listLessonsWithPagination(request, response);
                    return;
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error processing GET request", e);
            request.setAttribute("error", "Error processing request: " + e.getMessage());
        }

        request.getRequestDispatcher("lesson/lessonList.jsp").forward(request, response);
    }

    private void listLessonsWithPagination(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

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
        String name = request.getParameter("name");
        String chapterIdParam = request.getParameter("chapterId");
        Integer chapterId = null;

        if (chapterIdParam != null && !chapterIdParam.isEmpty()) {
            try {
                chapterId = Integer.parseInt(chapterIdParam);
            } catch (NumberFormatException e) {
                // Ignore invalid chapter ID
            }
        }

        // Get lessons with pagination
        List<Lesson> lessonList = lessonDAO.findLessonsWithPagination(name, chapterId, page, pageSize);
        int totalLessons = lessonDAO.getTotalLessonsCount(name, chapterId);

        // Calculate pagination info
        int totalPages = (int) Math.ceil((double) totalLessons / pageSize);
        int startPage = Math.max(1, page - 2);
        int endPage = Math.min(totalPages, page + 2);

        // Calculate display range
        int displayStart = (page - 1) * pageSize + 1;
        int displayEnd = Math.min(page * pageSize, totalLessons);

        // Load chapters for filter and display
        List<Chapter> chapter = new ChapterDAO().getChapter("select * from chapter");

        // Set attributes
        request.setAttribute("lessonList", lessonList);
        request.setAttribute("chapter", chapter);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalLessons", totalLessons);
        request.setAttribute("startPage", startPage);
        request.setAttribute("endPage", endPage);

        request.setAttribute("displayStart", displayStart);
        request.setAttribute("displayEnd", displayEnd);

        // Preserve filter parameters
        request.setAttribute("selectedName", name);
        request.setAttribute("selectedChapterId", chapterId);

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

                if ("buildCourse".equals(returnTo) && courseId != null) {
                    response.sendRedirect("course?action=build&id=" + courseId + "&message=Lesson created successfully");
                    return;
                }

                request.setAttribute("message", "Lesson added successfully");
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String name = request.getParameter("name");
                String content = request.getParameter("content");
                int chapterId = Integer.parseInt(request.getParameter("chapter_id"));

                // Get current lesson info
                Lesson currentLesson = lessonDAO.getLessonById(id);
                String currentVideoLink = currentLesson != null ? currentLesson.getVideo_link() : "";

                // Create updated lesson object
                Lesson lesson = new Lesson(id, name, content, chapterId, currentVideoLink);

                // Handle new video file if present
                Part videoPart = request.getPart("video_file");
                if (videoPart != null && videoPart.getSize() > 0) {
                    String videoUrl = videoService.uploadAndUpdateLesson(videoPart, lesson);
                    lesson.setVideo_link(videoUrl);
                }

                // Update lesson in database
                lessonDAO.updateLesson(lesson);

                // Check if should return to course builder
                String returnTo = request.getParameter("returnTo");
                String courseId = request.getParameter("courseId");

                if ("buildCourse".equals(returnTo) && courseId != null) {
                    response.sendRedirect("course?action=build&id=" + courseId + "&message=Lesson updated successfully");
                    return;
                }

                request.setAttribute("message", "Lesson updated successfully");
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

    private String getReturnUrl(HttpServletRequest request) {
        String returnTo = request.getParameter("returnTo");
        String courseId = request.getParameter("courseId");

        if ("buildCourse".equals(returnTo) && courseId != null && !courseId.isEmpty()) {
            return "course?action=build&id=" + courseId;
        }
        return "LessonURL"; // Default return
    }

    private void setReturnAttributes(HttpServletRequest request) {
        String returnTo = request.getParameter("returnTo");
        String courseId = request.getParameter("courseId");

        if ("buildCourse".equals(returnTo) && courseId != null && !courseId.isEmpty()) {
            request.setAttribute("returnTo", returnTo);
            request.setAttribute("courseId", courseId);
            request.setAttribute("returnUrl", "course?action=build&id=" + courseId);
            request.setAttribute("returnLabel", "Back to Course Builder");
        } else {
            request.setAttribute("returnUrl", "LessonURL");
            request.setAttribute("returnLabel", "Back to Lesson List");
        }
    }
}
