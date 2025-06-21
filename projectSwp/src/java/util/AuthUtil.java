package util;

import jakarta.servlet.http.HttpServletRequest;
import model.Account;
import model.Student;

public class AuthUtil {

    /**
     * Kiểm tra người dùng hiện tại có vai trò tương ứng không.
     * Admin, Teacher, Parent nằm trong bảng Account; Student là bảng riêng.
     *
     * @param request HttpServletRequest
     * @param role Role cần kiểm tra (RoleConstants.ADMIN, STUDENT, ...)
     * @return true nếu người dùng có vai trò tương ứng
     */
    public static boolean hasRole(HttpServletRequest request, String role) {
        // Nếu là student, kiểm tra session student
        if (RoleConstants.STUDENT.equalsIgnoreCase(role)) {
            return request.getSession().getAttribute("student") instanceof Student;
        }

        // Nếu là admin, teacher, parent: kiểm tra account
        Object accountObj = request.getSession().getAttribute("account");
        if (accountObj instanceof Account) {
            Account acc = (Account) accountObj;
            return acc.getRole() != null && acc.getRole().equalsIgnoreCase(role);
        }

        return false;
    }

    /**
     * Kiểm tra xem người dùng đã đăng nhập chưa (account hoặc student).
     */
    public static boolean isLoggedIn(HttpServletRequest request) {
        return request.getSession().getAttribute("account") != null
                || request.getSession().getAttribute("student") != null;
    }
}
