package service;

import com.google.auth.oauth2.GoogleCredentials;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Arrays;
import java.util.Base64;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Service để tương tác với Google Cloud Storage sử dụng REST API trực tiếp
 * @author ACER
 */
public class GoogleCloudStorageService {
    private static final Logger logger = Logger.getLogger(GoogleCloudStorageService.class.getName());
    
    private final String bucketName;
    private final GoogleCredentials credentials;
    private static final String UPLOAD_URL = "https://storage.googleapis.com/upload/storage/v1/b/%s/o?uploadType=media&name=%s";
    private static final String DELETE_URL = "https://storage.googleapis.com/storage/v1/b/%s/o/%s";
    
    // Scopes cần thiết cho Google Cloud Storage
    private static final String STORAGE_SCOPE = "https://www.googleapis.com/auth/devstorage.read_write";
    
    /**
     * Khởi tạo service Google Cloud Storage với thông tin xác thực
     * @param credentialStream InputStream của file credential.json
     * @param bucketName Tên bucket trên Google Cloud Storage
     * @throws IOException Nếu không thể đọc file credential
     */
    public GoogleCloudStorageService(InputStream credentialStream, String bucketName) throws IOException {
        try {
            // Tạo credentials từ file JSON với scope cụ thể
            this.credentials = GoogleCredentials.fromStream(credentialStream)
                    .createScoped(Arrays.asList(STORAGE_SCOPE));
            this.bucketName = bucketName;
            
            logger.info("Google Cloud Storage service initialized successfully with REST API");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Failed to initialize Google Cloud Storage", e);
            throw new IOException("Could not initialize Google Cloud Storage: " + e.getMessage(), e);
        }
    }
    
    /**
     * Upload video lên Google Cloud Storage sử dụng REST API
     * @param fileContent Nội dung file video
     * @param fileName Tên file gốc
     * @param contentType Loại nội dung (MIME type)
     * @return URL của video đã upload
     */
    public String uploadVideo(InputStream fileContent, String fileName, String contentType) {
        try {
            // Tạo tên file duy nhất để tránh trùng lặp
            String uniqueFileName = generateUniqueFileName(fileName);
            String objectPath = "videos/" + uniqueFileName;
            
            // Đọc file vào memory
            ByteArrayOutputStream buffer = new ByteArrayOutputStream();
            int nRead;
            byte[] data = new byte[16384]; // 16KB buffer
            while ((nRead = fileContent.read(data, 0, data.length)) != -1) {
                buffer.write(data, 0, nRead);
            }
            buffer.flush();
            byte[] fileBytes = buffer.toByteArray();
            
            // Chuẩn bị URL upload
            String encodedObjectPath = java.net.URLEncoder.encode(objectPath, "UTF-8").replace("+", "%20");
            String uploadUrlStr = String.format(UPLOAD_URL, bucketName, encodedObjectPath);
            URL uploadUrl = new URL(uploadUrlStr);
            
            // Chuẩn bị connection
            HttpURLConnection connection = (HttpURLConnection) uploadUrl.openConnection();
            connection.setDoOutput(true);
            connection.setRequestMethod("POST");
            connection.setRequestProperty("Content-Type", contentType);
            connection.setRequestProperty("Content-Length", String.valueOf(fileBytes.length));
            
            // Thêm thông tin xác thực
            String accessToken = getAccessToken();
            if (accessToken != null) {
                connection.setRequestProperty("Authorization", "Bearer " + accessToken);
            }
            
            // Upload file
            try (OutputStream out = connection.getOutputStream()) {
                out.write(fileBytes);
            }
            
            // Kiểm tra response
            int responseCode = connection.getResponseCode();
            if (responseCode >= 200 && responseCode < 300) {
                // Upload thành công
                logger.info("Successfully uploaded video: " + uniqueFileName);
                return "https://storage.googleapis.com/" + bucketName + "/" + objectPath;
            } else {
                // Upload thất bại
                try (InputStream errorStream = connection.getErrorStream()) {
                    ByteArrayOutputStream errorBuffer = new ByteArrayOutputStream();
                    byte[] errorData = new byte[1024];
                    int errorBytesRead;
                    while ((errorBytesRead = errorStream.read(errorData)) != -1) {
                        errorBuffer.write(errorData, 0, errorBytesRead);
                    }
                    String errorResponse = new String(errorBuffer.toByteArray());
                    logger.severe("Failed to upload video. Response code: " + responseCode + ", Error: " + errorResponse);
                }
                throw new IOException("Failed to upload video. Response code: " + responseCode);
            }
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Lỗi khi upload video: " + fileName, e);
            throw new RuntimeException("Không thể upload video", e);
        }
    }
    
    /**
     * Lấy access token từ credentials
     */
    private String getAccessToken() throws IOException {
        credentials.refreshIfExpired();
        return credentials.getAccessToken().getTokenValue();
    }
    
    /**
     * Tạo tên file duy nhất để tránh trùng lặp
     * @param originalFileName Tên file gốc
     * @return Tên file đã được tạo duy nhất
     */
    private String generateUniqueFileName(String originalFileName) {
        // Lấy phần mở rộng của file
        String extension = "";
        int lastDot = originalFileName.lastIndexOf('.');
        if (lastDot > 0) {
            extension = originalFileName.substring(lastDot);
        }
        
        // Tạo tên file duy nhất với UUID
        return UUID.randomUUID().toString() + extension;
    }
    
    /**
     * Xóa video trên Google Cloud Storage
     * @param videoUrl URL của video cần xóa
     * @return true nếu xóa thành công
     */
    public boolean deleteVideo(String videoUrl) {
        try {
            if (videoUrl == null || videoUrl.isEmpty()) {
                return false;
            }
            
            // Lấy tên blob từ URL
            String prefix = "https://storage.googleapis.com/" + bucketName + "/";
            if (!videoUrl.startsWith(prefix)) {
                logger.warning("Invalid video URL format: " + videoUrl);
                return false;
            }
            
            String objectPath = videoUrl.substring(prefix.length());
            String encodedObjectPath = java.net.URLEncoder.encode(objectPath, "UTF-8").replace("+", "%20");
            
            // Chuẩn bị URL xóa
            String deleteUrlStr = String.format(DELETE_URL, bucketName, encodedObjectPath);
            URL deleteUrl = new URL(deleteUrlStr);
            
            // Chuẩn bị connection
            HttpURLConnection connection = (HttpURLConnection) deleteUrl.openConnection();
            connection.setRequestMethod("DELETE");
            
            // Thêm thông tin xác thực
            String accessToken = getAccessToken();
            if (accessToken != null) {
                connection.setRequestProperty("Authorization", "Bearer " + accessToken);
            }
            
            // Thực hiện xóa
            int responseCode = connection.getResponseCode();
            if (responseCode >= 200 && responseCode < 300) {
                // Xóa thành công
                logger.info("Successfully deleted video: " + objectPath);
                return true;
            } else {
                // Xóa thất bại
                try (InputStream errorStream = connection.getErrorStream()) {
                    ByteArrayOutputStream errorBuffer = new ByteArrayOutputStream();
                    byte[] errorData = new byte[1024];
                    int errorBytesRead;
                    while ((errorBytesRead = errorStream.read(errorData)) != -1) {
                        errorBuffer.write(errorData, 0, errorBytesRead);
                    }
                    String errorResponse = new String(errorBuffer.toByteArray());
                    logger.severe("Failed to delete video. Response code: " + responseCode + ", Error: " + errorResponse);
                }
                return false;
            }
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Lỗi khi xóa video: " + videoUrl, e);
            return false;
        }
    }
} 