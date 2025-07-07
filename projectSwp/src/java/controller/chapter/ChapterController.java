/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.chapter;

import dal.ChapterDAO;
import dal.DAOSubject;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Chapter;
import model.Subject;
import util.AuthUtil;
import util.RoleConstants;

/**
 *
 * @author Na
 */
@WebServlet(name = "ChapterController", urlPatterns = {"/chapter"})
public class ChapterController extends HttpServlet {

    private ChapterDAO chapterDAO;
    private DAOSubject subjectDAO;

    @Override
    public void init() throws ServletException {
        chapterDAO = new ChapterDAO();
        subjectDAO = new DAOSubject();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Authorization check
        if (!AuthUtil.hasRole(request, RoleConstants.ADMIN) && !AuthUtil.hasRole(request, RoleConstants.TEACHER) && !AuthUtil.hasRole(request, RoleConstants.PARENT)) {
            response.sendRedirect("/error.jsp");
            return;
        }

        response.setContentType("text/html;charset=UTF-8");

        String service = request.getParameter("service");
        if (service == null) {
            service = "";
        }

        try {
            switch (service) {
                case "add":
                    if (request.getMethod().equalsIgnoreCase("GET")) {
                        showAddForm(request, response);
                    } else {
                        addChapter(request, response);
                    }
                    break;
                case "edit":
                    if (request.getMethod().equalsIgnoreCase("GET")) {
                        showEditForm(request, response);
                    } else {
                        editChapter(request, response);
                    }
                    break;
                case "delete":
                    deleteChapter(request, response);
                    break;
                case "search":
                    // Both search and list use the same method now
                    listChapter(request, response);
                    break;
                default:
                    listChapter(request, response);
                    break;
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "System error: " + e.getMessage());
            request.setAttribute("listChapter", List.of());
            request.setAttribute("listSubject", List.of());
            request.setAttribute("subjectMap", new HashMap<Integer, String>());
            request.getRequestDispatcher("/chapter/listChapter.jsp").forward(request, response);
        }
    }

    private void listChapter(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {

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
        String subjectIdParam = request.getParameter("subject_id");
        Integer subjectId = null;

        // Clean up empty parameters
        if (name != null && name.trim().isEmpty()) {
            name = null;
        }
        if (subjectIdParam != null && subjectIdParam.trim().isEmpty()) {
            subjectIdParam = null;
        }

        if (subjectIdParam != null) {
            try {
                subjectId = Integer.parseInt(subjectIdParam);
            } catch (NumberFormatException e) {
                // Ignore invalid subject ID
                subjectId = null;
            }
        }

        // Get chapters with pagination and filters
        List<Chapter> listChapter = chapterDAO.findChaptersWithPagination(name, subjectId, page, pageSize);
        int totalChapters = chapterDAO.getTotalChaptersCount(name, subjectId);

        // Calculate pagination info
        int totalPages = (int) Math.ceil((double) totalChapters / pageSize);
        int startPage = Math.max(1, page - 2);
        int endPage = Math.min(totalPages, page + 2);

        // Calculate display range
        int displayStart = totalChapters > 0 ? (page - 1) * pageSize + 1 : 0;
        int displayEnd = Math.min(page * pageSize, totalChapters);

        List<Subject> listSubject = subjectDAO.findAll();
        Map<Integer, String> subjectMap = loadSubjectMap();

        request.setAttribute("listChapter", listChapter != null ? listChapter : List.of());
        request.setAttribute("listSubject", listSubject != null ? listSubject : List.of());
        request.setAttribute("subjectMap", subjectMap != null ? subjectMap : new HashMap<>());

        // Pagination attributes
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalChapters", totalChapters);
        request.setAttribute("startPage", startPage);
        request.setAttribute("endPage", endPage);
        request.setAttribute("displayStart", displayStart);
        request.setAttribute("displayEnd", displayEnd);

        // Preserve filter parameters for form
        request.setAttribute("selectedName", name != null ? name : "");
        request.setAttribute("selectedSubjectId", subjectId);

        request.getRequestDispatcher("/chapter/listChapter.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {
        List<Subject> listSubject = subjectDAO.findAll();
        request.setAttribute("listSubject", listSubject != null ? listSubject : List.of());

        // Check if coming from course builder
        String returnTo = request.getParameter("returnTo");
        String courseId = request.getParameter("courseId");
        if ("course".equals(returnTo) && courseId != null) {
            request.setAttribute("returnToCourse", true);
            request.setAttribute("courseId", courseId);
        }

        request.getRequestDispatcher("/chapter/chapterForm.jsp").forward(request, response);
    }

    private void addChapter(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {
        try {
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            int subjectId = Integer.parseInt(request.getParameter("subject_id"));

            // Create chapter without ID (will be auto-generated)
            Chapter chapter = new Chapter(0, name, description, subjectId);
            int generatedId = chapterDAO.addChapter(chapter);

            if (generatedId > 0) {
                // Check if should return to course builder
                String returnTo = request.getParameter("returnTo");
                String courseId = request.getParameter("courseId");

                if ("course".equals(returnTo) && courseId != null) {
                    response.sendRedirect("course?action=build&id=" + courseId + "&message=Chapter created successfully");
                } else {
                    response.sendRedirect("chapter");
                }
            } else {
                request.setAttribute("errorMessage", "Cannot add chapter!");
                showAddForm(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid Subject ID format!");
            showAddForm(request, response);
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {
        int editId = Integer.parseInt(request.getParameter("editId"));
        Chapter chapter = chapterDAO.findChapterById(editId);
        List<Subject> listSubject = subjectDAO.findAll();

        request.setAttribute("chapterToEdit", chapter);
        request.setAttribute("listSubject", listSubject != null ? listSubject : List.of());
        request.getRequestDispatcher("/chapter/chapterForm.jsp").forward(request, response);
    }

    private void editChapter(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            int subjectId = Integer.parseInt(request.getParameter("subject_id"));

            Chapter chapter = new Chapter(id, name, description, subjectId);
            int result = chapterDAO.editChapter(chapter);
            if (result > 0) {
                response.sendRedirect("chapter");
            } else {
                request.setAttribute("errorMessage", "Cannot update chapter!");
                showEditForm(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid ID or Subject ID format!");
            showEditForm(request, response);
        }
    }

    private void deleteChapter(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            int result = chapterDAO.deleteChapter(id);
            if (result > 0) {
                request.setAttribute("message", "Chapter deleted successfully!");
            } else {
                request.setAttribute("errorMessage", "Cannot delete chapter!");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid ID format!");
        }
        listChapter(request, response);
    }

    private Map<Integer, String> loadSubjectMap() {
        Map<Integer, String> subjectMap = new HashMap<>();
        try {
            List<Subject> listSubject = subjectDAO.findAll();
            for (Subject s : listSubject) {
                subjectMap.put(s.getId(), s.getName());
            }
        } catch (Exception e) {
            // Ignore
        }
        return subjectMap;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "ChapterController - for Admin and Teacher roles";
    }
}
