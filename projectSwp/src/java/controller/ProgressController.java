/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.StudentProgressDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Student;
import util.AuthUtil;
import util.RoleConstants;

import java.io.IOException;
import java.io.PrintWriter;

/**
 *
 * @author ankha
 */
@WebServlet("/progress")
public class ProgressController extends HttpServlet {

    private StudentProgressDAO progressDAO = new StudentProgressDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Only students can update progress
        if (!AuthUtil.hasRole(request, RoleConstants.STUDENT)) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String action = request.getParameter("action");

        if ("updateProgress".equals(action)) {
            updateLessonProgress(request, response);
        }
    }

    private void updateLessonProgress(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            HttpSession session = request.getSession();
            Student student = (Student) session.getAttribute("student");

            if (student == null) {
                out.write("{\"success\": false, \"message\": \"Student not found in session\"}");
                return;
            }

            int lessonId = Integer.parseInt(request.getParameter("lessonId"));
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            int watchDuration = Integer.parseInt(request.getParameter("watchDuration"));
            int totalDuration = Integer.parseInt(request.getParameter("totalDuration"));
            int lastPosition = Integer.parseInt(request.getParameter("lastPosition"));

            boolean success = progressDAO.updateLessonProgress(
                    student.getId(), lessonId, courseId, watchDuration, totalDuration, lastPosition);

            if (success) {
                out.write("{\"success\": true, \"message\": \"Progress updated successfully\"}");
            } else {
                out.write("{\"success\": false, \"message\": \"Failed to update progress\"}");
            }

        } catch (NumberFormatException e) {
            out.write("{\"success\": false, \"message\": \"Invalid parameters\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.write("{\"success\": false, \"message\": \"Server error: " + e.getMessage() + "\"}");
        }
    }
}