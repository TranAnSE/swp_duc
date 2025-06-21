package controller.PackageSubject;

import dal.PackageSubjectDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.PackageSubject;
import java.io.IOException;
import java.util.List;
import model.Subject;
import dal.DAOSubject;

@WebServlet(name = "PackageSubjectController", urlPatterns = {"/packageSubjectURL"})
public class PackageSubjectController extends HttpServlet {

    private final PackageSubjectDAO dao = new PackageSubjectDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "";

        try {
            switch (action) {
                case "addForm":
                    List<Subject> subjectName = new DAOSubject().findAll();
                    request.setAttribute("subjectName", subjectName);
                    request.getRequestDispatcher("PackageSubject/addPackageSubject.jsp").forward(request, response);
                    return;

                case "updateForm":
                    int oldPackageId = Integer.parseInt(request.getParameter("package_id"));
                    int oldSubjectId = Integer.parseInt(request.getParameter("subject_id"));
                    PackageSubject ps = dao.getById(oldPackageId, oldSubjectId);
                    if (ps != null) {
                        List<Subject> subject = new DAOSubject().findAll();
                         request.setAttribute("subject", subject);
                        request.setAttribute("ps", ps);
                        request.getRequestDispatcher("PackageSubject/updatePackageSubject.jsp").forward(request, response);
                        return;
                    } else {
                        request.setAttribute("error", "Không tìm thấy bản ghi phù hợp");
                    }
                    break;

                case "delete":
                    int delPackageId = Integer.parseInt(request.getParameter("package_id"));
                    int delSubjectId = Integer.parseInt(request.getParameter("subject_id"));
                    dao.delete(delPackageId, delSubjectId);
                    response.sendRedirect("packageSubjectURL");
                    return;

                default:
                    // load danh sách mặc định
                    List<PackageSubject> list = dao.getAll();
                    request.setAttribute("list", list);
                    DAOSubject subject = new DAOSubject();
                    List<Subject> sub = subject.findAll();
                    request.setAttribute("subject", sub);
                    break;
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi xử lý: " + e.getMessage());
        }

        request.getRequestDispatcher("PackageSubject/listPackageSubject.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            if ("insert".equals(action)) {
                int packageId = Integer.parseInt(request.getParameter("package_id"));
                int subjectId = Integer.parseInt(request.getParameter("subject_id"));
                PackageSubject ps = new PackageSubject(packageId, subjectId);
                dao.insert(ps);
                request.setAttribute("message", "Thêm mới thành công");

            } else if ("update".equals(action)) {
                int oldPackageId = Integer.parseInt(request.getParameter("old_package_id"));
                int oldSubjectId = Integer.parseInt(request.getParameter("old_subject_id"));
                int newPackageId = Integer.parseInt(request.getParameter("package_id"));
                int newSubjectId = Integer.parseInt(request.getParameter("subject_id"));
                PackageSubject updated = new PackageSubject(newPackageId, newSubjectId);
                dao.update(updated, oldPackageId, oldSubjectId);
                request.setAttribute("message", "Cập nhật thành công");

            } else if ("delete".equals(action)) {
                int packageId = Integer.parseInt(request.getParameter("package_id"));
                int subjectId = Integer.parseInt(request.getParameter("subject_id"));
                dao.delete(packageId, subjectId);
                request.setAttribute("message", "Xóa thành công");
            }

            // Load lại danh sách sau thao tác
            List<PackageSubject> list = dao.getAll();
            request.setAttribute("list", list);
            List<Subject> subject = new DAOSubject().findAll();
            request.setAttribute("subject", subject);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi xử lý: " + e.getMessage());
        }

        request.getRequestDispatcher("PackageSubject/listPackageSubject.jsp").forward(request, response);
    }
}
