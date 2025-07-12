/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import config.CloudStorageConfig;
import dal.ImageDAO;
import jakarta.servlet.ServletContext;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Image;

/**
 *
 * @author ankha
 */
/**
 * Service for handling image operations
 */
public class ImageService {

    private static final Logger logger = Logger.getLogger(ImageService.class.getName());
    private final GoogleCloudStorageService storageService;
    private final ImageDAO imageDAO;

    /**
     * Initialize ImageService with servlet context
     *
     * @param context Servlet context
     * @throws IOException If cannot create connection to Google Cloud Storage
     */
    public ImageService(ServletContext context) throws IOException {
        CloudStorageConfig config = new CloudStorageConfig(context);
        try {
            this.storageService = new GoogleCloudStorageService(
                    config.getCredentialStream(),
                    config.getBucketName()
            );
            logger.info("ImageService initialized successfully");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error initializing GoogleCloudStorageService", e);
            throw new IOException("Could not initialize Google Cloud Storage", e);
        }
        this.imageDAO = new ImageDAO(new dal.DBContext().getConnection());
    }

    /**
     * Upload image and save to database
     *
     * @param imagePart Part containing image content from form
     * @return Image ID if successful, null if failed
     * @throws IOException If error processing file upload
     */
    public Integer uploadAndSaveImage(Part imagePart) throws IOException {
        if (imagePart == null || imagePart.getSize() <= 0) {
            return null;
        }

        try {
            // Validate image type
            String contentType = imagePart.getContentType();
            if (!isValidImageType(contentType)) {
                throw new IOException("Invalid image type. Only JPG, PNG, GIF are allowed.");
            }

            // Upload to cloud storage
            String fileName = getFileName(imagePart);
            String imageUrl = storageService.uploadImage(
                    imagePart.getInputStream(),
                    fileName,
                    contentType
            );

            // Save to database
            Image image = new Image();
            image.setImage_data(imageUrl);
            int imageId = imageDAO.insertImage(image);

            logger.info("Image uploaded and saved successfully with ID: " + imageId);
            return imageId;

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error uploading image", e);
            throw new IOException("Could not upload image", e);
        }
    }

    /**
     * Update existing image
     *
     * @param imagePart New image part
     * @param oldImageId Old image ID to replace
     * @return New image ID if successful, old image ID if no new image provided
     * @throws IOException If error processing file upload
     */
    public Integer updateImage(Part imagePart, Integer oldImageId) throws IOException {
        if (imagePart == null || imagePart.getSize() <= 0) {
            return oldImageId; // Keep old image if no new image provided
        }

        try {
            // Delete old image if exists
            if (oldImageId != null) {
                deleteImageById(oldImageId);
            }

            // Upload new image
            return uploadAndSaveImage(imagePart);

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error updating image", e);
            throw new IOException("Could not update image", e);
        }
    }

    /**
     * Delete image by ID
     *
     * @param imageId Image ID to delete
     */
    public void deleteImageById(Integer imageId) {
        try {
            if (imageId == null) {
                return;
            }

            // Get image info from database
            Image image = imageDAO.findImageById(imageId);
            if (image != null && image.getImage_data() != null) {
                // Delete from cloud storage
                storageService.deleteImage(image.getImage_data());
            }

        } catch (Exception e) {
            logger.log(Level.WARNING, "Could not delete image with ID: " + imageId, e);
        }
    }

    /**
     * Validate if content type is valid image type
     *
     * @param contentType Content type to validate
     * @return true if valid image type
     */
    private boolean isValidImageType(String contentType) {
        if (contentType == null) {
            return false;
        }
        return contentType.equals("image/jpeg")
                || contentType.equals("image/jpg")
                || contentType.equals("image/png")
                || contentType.equals("image/gif");
    }

    /**
     * Get filename from Part
     *
     * @param part Part containing file upload
     * @return Filename without path
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

        return "unknown_image";
    }
}
