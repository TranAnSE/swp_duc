package config;

import jakarta.servlet.ServletContext;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

/**
 * Cấu hình cho Google Cloud Storage
 * @author ACER
 */
public class CloudStorageConfig {
    
    private static final String CREDENTIAL_PATH = "/WEB-INF/credentials.json";
    private static final String BUCKET_NAME = "myproject-video-bucket-2025"; // Thay đổi tên bucket theo cấu hình của bạn
    
    private String credentialFilePath;
    private String bucketName;
    
    public CloudStorageConfig(ServletContext context) {
        // Lấy đường dẫn thực tế đến file credential.json
        this.credentialFilePath = context.getRealPath(CREDENTIAL_PATH);
        this.bucketName = BUCKET_NAME;
    }
    
    public String getCredentialFilePath() {
        return credentialFilePath;
    }
    
    public String getBucketName() {
        return bucketName;
    }
    
    public InputStream getCredentialStream() throws IOException {
        return new FileInputStream(new File(credentialFilePath));
    }
} 