package controller.subject;

import dal.DAOSubject;
import dal.GradeDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Subject;
import model.Grade;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import util.AuthUtil;
import util.RoleConstants;

@WebServlet("/subjects")
public class SubjectController extends HttpServlet {

    private DAOSubject daoSubject = new DAOSubject();

    private void loadGradeMap(HttpServletRequest req) throws SQLException {
        GradeDAO daoGrade = new GradeDAO();
        List<Grade> gradeList = daoGrade.findAllFromGrade();
        Map<Integer, String> gradeMap = new HashMap<>();
        for (Grade g : gradeList) {
            gradeMap.put(g.getId(), g.getName());
        }
        req.setAttribute("gradeMap", gradeMap);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (!AuthUtil.hasRole(req, RoleConstants.ADMIN) && !AuthUtil.hasRole(req, RoleConstants.TEACHER) && !AuthUtil.hasRole(req, RoleConstants.STUDENT)) {
            resp.sendRedirect("/error.jsp");
            return;
        }

        try {
            // Load grade map for all requests
            loadGradeMap(req);

            if ("edit".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                Subject subject = daoSubject.findById(id);
                if (subject == null) {
                    req.setAttribute("error", "Subject not found!");
                    resp.sendRedirect("subjects");
                    return;
                }
                req.setAttribute("subject", subject);
                req.getRequestDispatcher("Subject/updateSubject.jsp").forward(req, resp);

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                daoSubject.delete(id);
                resp.sendRedirect("subjects");

            } else if ("create".equals(action)) {
                Subject newSubject = new Subject();
                req.setAttribute("subject", newSubject);
                req.getRequestDispatcher("Subject/addSubject.jsp").forward(req, resp);

            } else {
                // List subjects with pagination
                listSubjectsWithPagination(req, resp);
            }

        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            req.setAttribute("error", "Error processing data: " + e.getMessage());
            req.getRequestDispatcher("Subject/subjectList.jsp").forward(req, resp);
        }
    }

    private void listSubjectsWithPagination(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException, SQLException {

        // Get pagination parameters
        int page = 1;
        int pageSize = 10;
        String pageParam = req.getParameter("page");
        String pageSizeParam = req.getParameter("pageSize");

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
        String name = req.getParameter("name");
        String gradeIdParam = req.getParameter("gradeId");
        Integer gradeId = null;

        if (gradeIdParam != null && !gradeIdParam.isEmpty()) {
            try {
                gradeId = Integer.parseInt(gradeIdParam);
            } catch (NumberFormatException e) {
                // Ignore invalid grade ID
            }
        }

        // Get subjects with pagination
        List<Subject> subjectList = daoSubject.findSubjectsWithPagination(name, gradeId, page, pageSize);
        int totalSubjects = daoSubject.getTotalSubjectsCount(name, gradeId);

        // Calculate pagination info
        int totalPages = (int) Math.ceil((double) totalSubjects / pageSize);
        int startPage = Math.max(1, page - 2);
        int endPage = Math.min(totalPages, page + 2);

        // Calculate display range
        int displayStart = (page - 1) * pageSize + 1;
        int displayEnd = Math.min(page * pageSize, totalSubjects);

        // Load grades for filter
        GradeDAO gradeDAO = new GradeDAO();
        List<Grade> grades = gradeDAO.findAllFromGrade();

        // Set attributes
        req.setAttribute("subjectList", subjectList);
        req.setAttribute("currentPage", page);
        req.setAttribute("pageSize", pageSize);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalSubjects", totalSubjects);
        req.setAttribute("startPage", startPage);
        req.setAttribute("endPage", endPage);
        req.setAttribute("grades", grades);

        req.setAttribute("displayStart", displayStart);
        req.setAttribute("displayEnd", displayEnd);

        // Preserve filter parameters
        req.setAttribute("selectedName", name);
        req.setAttribute("selectedGradeId", gradeId);

        req.getRequestDispatcher("Subject/subjectList.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        // Handle AJAX request to clear notification
        if ("clearNotification".equals(action)) {
            HttpSession session = req.getSession();
            session.removeAttribute("subjectCreated");
            session.removeAttribute("newSubjectId");
            session.removeAttribute("newSubjectName");
            session.removeAttribute("newSubjectGradeId");
            resp.setStatus(HttpServletResponse.SC_OK);
            return;
        }

        if (!AuthUtil.hasRole(req, RoleConstants.ADMIN)) {
            resp.sendRedirect("/error.jsp");
            return;
        }

        try {
            // Load grade map for error handling
            loadGradeMap(req);

            String idStr = req.getParameter("id");
            String name = req.getParameter("name");
            String description = req.getParameter("description");
            int gradeId = Integer.parseInt(req.getParameter("grade_id"));

            Subject subject = new Subject();
            subject.setName(name);
            subject.setDescription(description);
            subject.setGrade_id(gradeId);

            if (idStr == null || idStr.trim().isEmpty()) {
                // Insert new subject
                daoSubject.insert(subject);

                // Get the inserted subject ID for course creation redirect
                List<Subject> subjects = daoSubject.findByNameOfSubject(name);
                if (!subjects.isEmpty()) {
                    Subject insertedSubject = subjects.get(0);

                    // Set success message with course creation option
                    req.getSession().setAttribute("subjectCreated", true);
                    req.getSession().setAttribute("newSubjectId", insertedSubject.getId());
                    req.getSession().setAttribute("newSubjectName", insertedSubject.getName());
                    req.getSession().setAttribute("newSubjectGradeId", insertedSubject.getGrade_id());
                }
            } else {
                subject.setId(Integer.parseInt(idStr));
                daoSubject.update(subject);
            }

            resp.sendRedirect("subjects");

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Error saving subject: " + e.getMessage());

            String idStr = req.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                req.getRequestDispatcher("Subject/addSubject.jsp").forward(req, resp);
            } else {
                Subject subject = new Subject();
                subject.setId(Integer.parseInt(idStr));
                subject.setName(req.getParameter("name"));
                subject.setDescription(req.getParameter("description"));
                subject.setGrade_id(Integer.parseInt(req.getParameter("grade_id")));
                req.setAttribute("subject", subject);

                req.getRequestDispatcher("Subject/updateSubject.jsp").forward(req, resp);
            }
        }
    }
}
