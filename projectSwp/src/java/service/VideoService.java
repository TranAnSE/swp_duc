package service;

import config.CloudStorageConfig;
import dal.LessonDAO;
import jakarta.servlet.ServletContext;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Lesson;

/**
 * Service xử lý các thao tác với video
 * @author ACER
 */
public class VideoService {
    private static final Logger logger = Logger.getLogger(VideoService.class.getName());
    private final GoogleCloudStorageService storageService;
    private final LessonDAO lessonDAO;
    
    /**
     * Khởi tạo VideoService với context của ứng dụng
     * @param context Servlet context
     * @throws IOException Nếu không thể tạo kết nối với Google Cloud Storage
     */
    public VideoService(ServletContext context) throws IOException {
        CloudStorageConfig config = new CloudStorageConfig(context);
        try {
            this.storageService = new GoogleCloudStorageService(
                    config.getCredentialStream(), 
                    config.getBucketName()
            );
            logger.info("VideoService initialized successfully with default transport");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error initializing GoogleCloudStorageService", e);
            throw new IOException("Could not initialize Google Cloud Storage", e);
        }
        this.lessonDAO = new LessonDAO();
    }
    
    /**
     * Upload video và cập nhật thông tin bài học
     * @param videoPart Part chứa nội dung video từ form
     * @param lesson Bài học cần cập nhật video
     * @return URL của video sau khi upload
     * @throws IOException Nếu có lỗi khi xử lý file upload
     */
    public String uploadAndUpdateLesson(Part videoPart, Lesson lesson) throws IOException {
        if (videoPart == null || videoPart.getSize() <= 0) {
            return lesson.getVideo_link(); // Giữ nguyên link cũ nếu không có video mới
        }
        
        try {
            // Xóa video cũ nếu có
            if (lesson.getId() > 0 && lesson.getVideo_link() != null && !lesson.getVideo_link().isEmpty()) {
                deleteOldVideo(lesson.getVideo_link());
            }
            
            // Upload video mới
            String fileName = getFileName(videoPart);
            String contentType = videoPart.getContentType();
            String videoUrl = storageService.uploadVideo(
                    videoPart.getInputStream(), 
                    fileName, 
                    contentType
            );
            
            // Cập nhật link video cho bài học
            lesson.setVideo_link(videoUrl);
            
            return videoUrl;
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Lỗi khi upload video cho bài học: " + lesson.getName(), e);
            throw new IOException("Không thể upload video", e);
        }
    }
    
    /**
     * Xóa video cũ nếu có
     * @param videoLink Link video cần xóa
     */
    public void deleteOldVideo(String videoLink) {
        try {
            if (videoLink != null && !videoLink.isEmpty()) {
                storageService.deleteVideo(videoLink);
            }
        } catch (Exception e) {
            logger.log(Level.WARNING, "Không thể xóa video cũ: " + videoLink, e);
        }
    }
    
    /**
     * Lấy tên file từ Part
     * @param part Part chứa file upload
     * @return Tên file không chứa đường dẫn
     */
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        String[] items = contentDisposition.split(";");
        
        for (String item : items) {
            if (item.trim().startsWith("filename")) {
                String fileName = item.substring(item.indexOf("=") + 2, item.length() - 1);
                return fileName.substring(fileName.lastIndexOf('/') + 1)
                        .substring(fileName.lastIndexOf('\\') + 1);
            }
        }
        
        return "unknown_file";
    }
} 