package controller;

import com.google.auth.oauth2.GoogleCredentials;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Arrays;
import java.util.UUID;
import jakarta.servlet.annotation.WebServlet;
@WebServlet("/upload-video")
@MultipartConfig
public class UploadVideoServlet extends HttpServlet {

    private static final String BUCKET_NAME = "myproject-video-bucket-2025";
    private static final String CREDENTIALS_PATH = "/WEB-INF/credentials.json";
    private static final String UPLOAD_URL = "https://storage.googleapis.com/upload/storage/v1/b/%s/o?uploadType=media&name=%s";
    private static GoogleCredentials credentials = null;
    
    // Scopes cần thiết cho Google Cloud Storage
    private static final String STORAGE_SCOPE = "https://www.googleapis.com/auth/devstorage.read_write";

    @Override
    public void init() throws ServletException {
        try {
            String realPath = getServletContext().getRealPath(CREDENTIALS_PATH);
            if (realPath == null) {
                throw new FileNotFoundException("Credentials file not found at " + CREDENTIALS_PATH);
            }
            
            InputStream credentialsStream = new FileInputStream(realPath);
            credentials = GoogleCredentials.fromStream(credentialsStream)
                    .createScoped(Arrays.asList(STORAGE_SCOPE));
            
            System.out.println("Google Cloud Storage credentials initialized successfully.");

        } catch (IOException e) {
            System.err.println("Failed to initialize Google Cloud Storage credentials.");
            e.printStackTrace();
            throw new ServletException("Could not initialize Google Cloud Storage credentials", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            Part filePart = request.getPart("video");
            if (filePart == null || filePart.getSize() == 0) {
                out.println("<h3>❌ Please select a video file to upload.</h3>");
                out.println("<a href='upload.jsp'>Go Back</a>");
                return;
            }
            
            String originalFileName = filePart.getSubmittedFileName();
            String uniqueFileName = generateUniqueFileName(originalFileName);
            String objectPath = "videos/" + uniqueFileName;
            String contentType = filePart.getContentType();
            
            // Đọc file từ Part
            ByteArrayOutputStream buffer = new ByteArrayOutputStream();
            try (InputStream fileContent = filePart.getInputStream()) {
                int nRead;
                byte[] data = new byte[16384]; // 16KB buffer
                while ((nRead = fileContent.read(data, 0, data.length)) != -1) {
                    buffer.write(data, 0, nRead);
                }
            }
            buffer.flush();
            byte[] fileBytes = buffer.toByteArray();
            
            // Chuẩn bị URL upload
            String encodedObjectPath = java.net.URLEncoder.encode(objectPath, "UTF-8").replace("+", "%20");
            String uploadUrlStr = String.format(UPLOAD_URL, BUCKET_NAME, encodedObjectPath);
            URL uploadUrl = new URL(uploadUrlStr);
            
            // Chuẩn bị connection
            HttpURLConnection connection = (HttpURLConnection) uploadUrl.openConnection();
            connection.setDoOutput(true);
            connection.setRequestMethod("POST");
            connection.setRequestProperty("Content-Type", contentType);
            connection.setRequestProperty("Content-Length", String.valueOf(fileBytes.length));
            
            // Thêm thông tin xác thực
            credentials.refreshIfExpired();
            String accessToken = credentials.getAccessToken().getTokenValue();
            connection.setRequestProperty("Authorization", "Bearer " + accessToken);
            
            // Upload file
            try (OutputStream outputStream = connection.getOutputStream()) {
                outputStream.write(fileBytes);
            }
            
            // Kiểm tra response
            int responseCode = connection.getResponseCode();
            if (responseCode >= 200 && responseCode < 300) {
                // Upload thành công
                String publicUrl = String.format("https://storage.googleapis.com/%s/%s", BUCKET_NAME, objectPath);
                
                out.println("<html><body>");
                out.println("<h3>✅ Upload successful!</h3>");
                out.println("<p>Video URL: <a href='" + publicUrl + "' target='_blank'>" + publicUrl + "</a></p>");
                out.println("<video width='640' controls><source src='" + publicUrl + "' type='" + contentType + "'></video>");
                out.println("<br/><br/><a href='upload.jsp'>Upload another video</a>");
                out.println("</body></html>");
            } else {
                // Upload thất bại
                StringBuilder errorMessage = new StringBuilder();
                try (InputStream errorStream = connection.getErrorStream()) {
                    if (errorStream != null) {
                        ByteArrayOutputStream errorBuffer = new ByteArrayOutputStream();
                        byte[] errorData = new byte[1024];
                        int errorBytesRead;
                        while ((errorBytesRead = errorStream.read(errorData)) != -1) {
                            errorBuffer.write(errorData, 0, errorBytesRead);
                        }
                        errorMessage.append(new String(errorBuffer.toByteArray()));
                    }
                }
                
                out.println("<h3>❌ An error occurred during upload.</h3>");
                out.println("<p>Response code: " + responseCode + "</p>");
                out.println("<p>Error details: " + errorMessage.toString() + "</p>");
                out.println("<a href='upload.jsp'>Go Back</a>");
            }

        } catch (Exception e) {
            e.printStackTrace(out);
            out.println("<h3>❌ An error occurred during upload.</h3>");
            out.println("<p>Details: " + e.getMessage() + "</p>");
            out.println("<a href='upload.jsp'>Go Back</a>");
        }
    }
    
    /**
     * Tạo tên file duy nhất để tránh trùng lặp
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
} 