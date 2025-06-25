/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dal.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.*;

/**
 *
 * @author ankha
 */
@WebServlet(name = "HomeController", urlPatterns = {"/"})
public class HomeController extends HttpServlet {
    
    private DAOSubject subjectDAO = new DAOSubject();
    private GradeDAO gradeDAO = new GradeDAO();
    private ChapterDAO chapterDAO = new ChapterDAO();
    private LessonDAO lessonDAO = new LessonDAO();
    private StudyPackageDAO packageDAO = new StudyPackageDAO();
    private TestDAO testDAO = new TestDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();
    private AccountDAO accountDAO = new AccountDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get featured subjects with detailed info
            List<Subject> allSubjects = subjectDAO.findAll();
            List<Map<String, Object>> featuredSubjects = getFeaturedSubjectsWithDetails(allSubjects);
            
            // Get grades for mapping
            List<Grade> grades = gradeDAO.findAllFromGrade();
            Map<Integer, Grade> gradeMap = new HashMap<>();
            for (Grade grade : grades) {
                gradeMap.put(grade.getId(), grade);
            }
            
            // Get popular study packages with enhanced info
            List<StudyPackage> allPackages = packageDAO.getStudyPackage("SELECT * FROM study_package");
            List<Map<String, Object>> enhancedPackages = getEnhancedPackages(allPackages);
            
            // Get recent lessons with chapter info
            List<Lesson> allLessons = lessonDAO.getAllLessons();
            List<Map<String, Object>> recentLessonsWithInfo = getRecentLessonsWithInfo(allLessons);
            
            // Get test categories with enhanced info
            List<Category> categories = categoryDAO.getAllCategories();
            
            // Get comprehensive statistics
            Map<String, Object> stats = getComprehensiveStats();
            
            // Get testimonials (mock data based on real structure)
            List<Map<String, String>> testimonials = getTestimonials();
            
            // Get learning paths
            List<Map<String, Object>> learningPaths = getLearningPaths();
            
            // Get why choose us features
            List<Map<String, String>> features = getWhyChooseUsFeatures();
            
            // Set attributes
            request.setAttribute("featuredSubjects", featuredSubjects);
            request.setAttribute("gradeMap", gradeMap);
            request.setAttribute("enhancedPackages", enhancedPackages);
            request.setAttribute("recentLessonsWithInfo", recentLessonsWithInfo);
            request.setAttribute("categories", categories);
            request.setAttribute("stats", stats);
            request.setAttribute("testimonials", testimonials);
            request.setAttribute("learningPaths", learningPaths);
            request.setAttribute("features", features);
            
        } catch (SQLException e) {
            e.printStackTrace();
            setDefaultAttributes(request);
        }
        
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
    
    private List<Map<String, Object>> getFeaturedSubjectsWithDetails(List<Subject> subjects) throws SQLException {
        List<Map<String, Object>> featured = new ArrayList<>();
        int count = 0;
        
        for (Subject subject : subjects) {
            if (count >= 6) break;
            
            Map<String, Object> subjectInfo = new HashMap<>();
            subjectInfo.put("subject", subject);
            
            // Get grade info
            Grade grade = gradeDAO.getGradeById(subject.getGrade_id());
            subjectInfo.put("grade", grade);
            
            // Count chapters
            List<Chapter> chapters = chapterDAO.getChapter("SELECT * FROM chapter WHERE subject_id = " + subject.getId());
            subjectInfo.put("chapterCount", chapters.size());
            
            // Count lessons
            int lessonCount = 0;
            for (Chapter chapter : chapters) {
                List<Lesson> lessons = lessonDAO.getAllLessons();
                for (Lesson lesson : lessons) {
                    if (lesson.getChapter_id() == chapter.getId()) {
                        lessonCount++;
                    }
                }
            }
            subjectInfo.put("lessonCount", lessonCount);
            
            featured.add(subjectInfo);
            count++;
        }
        
        return featured;
    }
    
    private List<Map<String, Object>> getEnhancedPackages(List<StudyPackage> packages) {
        List<Map<String, Object>> enhanced = new ArrayList<>();
        String[] packageFeatures = {
            "Full Access to All Lessons",
            "Interactive Quizzes & Tests", 
            "Progress Tracking",
            "Certificate of Completion",
            "24/7 Support",
            "Mobile App Access"
        };
        
        String[] packageTypes = {"Basic", "Premium", "Pro", "Enterprise"};
        String[] packageDescriptions = {
            "Perfect for individual learners starting their journey",
            "Ideal for serious students with advanced features",
            "Complete solution for professional development",
            "Comprehensive package for organizations"
        };
        
        for (int i = 0; i < packages.size() && i < 4; i++) {
            StudyPackage pkg = packages.get(i);
            Map<String, Object> packageInfo = new HashMap<>();
            
            packageInfo.put("pkg", pkg);
            packageInfo.put("type", packageTypes[i % packageTypes.length]);
            packageInfo.put("description", packageDescriptions[i % packageDescriptions.length]);
            packageInfo.put("features", Arrays.asList(packageFeatures).subList(0, 3 + i));
            packageInfo.put("popular", i == 1); // Mark second package as popular
            
            enhanced.add(packageInfo);
        }
        
        return enhanced;
    }
    
    private List<Map<String, Object>> getRecentLessonsWithInfo(List<Lesson> lessons) throws SQLException {
        List<Map<String, Object>> recentWithInfo = new ArrayList<>();
        int count = 0;
        
        for (Lesson lesson : lessons) {
            if (count >= 8) break;
            
            Map<String, Object> lessonInfo = new HashMap<>();
            lessonInfo.put("lesson", lesson);
            
            // Get chapter info
            Chapter chapter = chapterDAO.findChapterById(lesson.getChapter_id());
            lessonInfo.put("chapter", chapter);
            
            if (chapter != null) {
                // Get subject info
                Subject subject = subjectDAO.findById(chapter.getSubject_id());
                lessonInfo.put("subject", subject);
                
                if (subject != null) {
                    // Get grade info
                    Grade grade = gradeDAO.getGradeById(subject.getGrade_id());
                    lessonInfo.put("grade", grade);
                }
            }
            
            // Add difficulty level
            String[] difficulties = {"Beginner", "Intermediate", "Advanced"};
            lessonInfo.put("difficulty", difficulties[count % 3]);
            
            // Add estimated duration
            int duration = 15 + (count % 4) * 10; // 15, 25, 35, 45 minutes
            lessonInfo.put("duration", duration);
            
            recentWithInfo.add(lessonInfo);
            count++;
        }
        
        return recentWithInfo;
    }
    
    private Map<String, Object> getComprehensiveStats() throws SQLException {
        Map<String, Object> stats = new HashMap<>();
        
        stats.put("totalSubjects", subjectDAO.findAll().size());
        stats.put("totalLessons", lessonDAO.getAllLessons().size());
        stats.put("totalPackages", packageDAO.getStudyPackage("SELECT * FROM study_package").size());
        stats.put("totalCategories", categoryDAO.getAllCategories().size());
        
        // Add more engaging stats
        stats.put("totalStudents", "10,000+"); // Based on typical platform
        stats.put("totalTeachers", "500+");
        stats.put("completionRate", "95%");
        stats.put("satisfaction", "4.8/5");
        
        return stats;
    }
    
    private List<Map<String, String>> getTestimonials() {
        List<Map<String, String>> testimonials = new ArrayList<>();
        
        String[][] testimonialData = {
            {"Sarah Johnson", "High School Student", "This platform helped me improve my grades significantly. The interactive lessons make learning fun!", "assets/img/testimonials/student1.jpg"},
            {"Michael Chen", "Parent", "As a parent, I'm impressed with the progress tracking and quality of education my child receives here.", "assets/img/testimonials/parent1.jpg"},
            {"Dr. Emily Rodriguez", "Teacher", "The teaching tools and resources available here are exceptional. My students love the interactive content.", "assets/img/testimonials/teacher1.jpg"},
            {"David Kim", "College Student", "The flexibility to learn at my own pace while maintaining high-quality education is exactly what I needed.", "assets/img/testimonials/student2.jpg"}
        };
        
        for (String[] data : testimonialData) {
            Map<String, String> testimonial = new HashMap<>();
            testimonial.put("name", data[0]);
            testimonial.put("role", data[1]);
            testimonial.put("content", data[2]);
            testimonial.put("image", data[3]);
            testimonials.add(testimonial);
        }
        
        return testimonials;
    }
    
    private List<Map<String, Object>> getLearningPaths() {
        List<Map<String, Object>> paths = new ArrayList<>();
        
        Object[][] pathData = {
            {"Mathematics Mastery", "Complete mathematical foundation from basics to advanced", "fas fa-calculator", "12 Courses", "beginner"},
            {"Science Explorer", "Discover the wonders of physics, chemistry, and biology", "fas fa-search", "15 Courses", "intermediate"},
            {"Language Arts", "Master reading, writing, and communication skills", "fas fa-book", "10 Courses", "beginner"},
            {"Technology & Innovation", "Learn about modern technology and digital literacy", "fas fa-code", "8 Courses", "advanced"}
        };
        
        for (Object[] data : pathData) {
            Map<String, Object> path = new HashMap<>();
            path.put("title", data[0]);
            path.put("description", data[1]);
            path.put("icon", data[2]);
            path.put("courseCount", data[3]);
            path.put("level", data[4]);
            paths.add(path);
        }
        
        return paths;
    }
    
    private List<Map<String, String>> getWhyChooseUsFeatures() {
        List<Map<String, String>> features = new ArrayList<>();
        
        String[][] featureData = {
            {"Expert Instructors", "Learn from qualified teachers with years of experience", "fas fa-users"},
            {"Interactive Learning", "Engage with multimedia content and interactive exercises", "fas fa-play-circle"},
            {"Flexible Schedule", "Study at your own pace, anytime and anywhere", "fas fa-clock"},
            {"Progress Tracking", "Monitor your learning progress with detailed analytics", "fas fa-chart-line"},
            {"Certificate Programs", "Earn certificates upon successful course completion", "fas fa-certificate"},
            {"24/7 Support", "Get help whenever you need it with our support team", "fas fa-headphones"}
        };
        
        for (String[] data : featureData) {
            Map<String, String> feature = new HashMap<>();
            feature.put("title", data[0]);
            feature.put("description", data[1]);
            feature.put("icon", data[2]);
            features.add(feature);
        }
        
        return features;
    }
    
    private void setDefaultAttributes(HttpServletRequest request) {
        request.setAttribute("featuredSubjects", new ArrayList<>());
        request.setAttribute("enhancedPackages", new ArrayList<>());
        request.setAttribute("recentLessonsWithInfo", new ArrayList<>());
        request.setAttribute("categories", new ArrayList<>());
        request.setAttribute("stats", getDefaultStats());
        request.setAttribute("testimonials", new ArrayList<>());
        request.setAttribute("learningPaths", new ArrayList<>());
        request.setAttribute("features", new ArrayList<>());
    }
    
    private Map<String, Object> getDefaultStats() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalSubjects", 0);
        stats.put("totalLessons", 0);
        stats.put("totalPackages", 0);
        stats.put("totalCategories", 0);
        stats.put("totalStudents", "0");
        stats.put("totalTeachers", "0");
        stats.put("completionRate", "0%");
        stats.put("satisfaction", "0/5");
        return stats;
    }
}