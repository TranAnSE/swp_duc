/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package config;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

/**
 *
 * @author BuiNgocLinh
 */
public class FileUploadUlti {

    public static String uploadAvatarImage(HttpServletRequest request, String avatarName) {
        String uploadDir = request.getServletContext().getRealPath("assets/img/avatar/");
        System.out.println("Before cleaning: " + uploadDir);

        String cleanUploadDir = uploadDir.replaceAll("[/\\\\]build", "");
        System.out.println("After cleaning: " + cleanUploadDir);

        Part filePart;
        String imgURL = null;

        try {
            // Nhận phần tệp được tải lên  
            filePart = request.getPart("imgURL");
            if (filePart != null && filePart.getSize() > 0) {
                File uploadFolder = new File(cleanUploadDir);
                if (!uploadFolder.exists()) {
                    boolean created = uploadFolder.mkdirs();
                    if (!created) {
                        System.out.println("Failed to create upload directory: " + cleanUploadDir);
                        return null;
                    }
                }
                File[] existingFiles = uploadFolder.listFiles((dir, name) -> name.startsWith(avatarName));
                if (existingFiles != null) {
                    for (File existingFile : existingFiles) {
                        boolean deleted = existingFile.delete();
                        if (deleted) {
                            System.out.println("Deleted existing file: " + existingFile.getAbsolutePath());
                        } else {
                            System.out.println("Failed to delete existing file: " + existingFile.getAbsolutePath());
                        }
                    }
                }
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String fileExtension = fileName.substring(fileName.lastIndexOf("."));
                String newFileName = avatarName + fileExtension;
                File file = new File(uploadFolder, newFileName);

                try (InputStream fileContent = filePart.getInputStream()) {
                    Files.copy(fileContent, file.toPath(), StandardCopyOption.REPLACE_EXISTING);
                    System.out.println("File successfully uploaded to: " + file.getAbsolutePath());
                } catch (IOException e) {
                    System.out.println("Error saving file: " + e.getMessage());
                    e.printStackTrace();
                    return null;
                }
                imgURL = "assets/img/avatar/" + newFileName;
            } else {
                System.out.println("No file uploaded or file is empty.");
            }
        } catch (Exception e) {
            System.out.println("Error during file upload: " + e.getMessage());
            e.printStackTrace();
        }

        return imgURL;
    }

    public static String insertNewsImage(HttpServletRequest request) {
        String uploadDir = request.getServletContext().getRealPath("/assets/img/news/");
        System.out.println("Before cleaning: " + uploadDir);

        String cleanUploadDir = uploadDir.replaceAll("[/\\\\]build", "");
        System.out.println("After cleaning: " + cleanUploadDir);

        Part filePart;
        String imgURL = null;

        try {
            filePart = request.getPart("imageURL");
            if (filePart != null && filePart.getSize() > 0) {
                File uploadFolder = new File(cleanUploadDir);
                if (!uploadFolder.exists()) {
                    boolean created = uploadFolder.mkdirs();
                    if (!created) {
                        System.out.println("Failed to create upload directory: " + cleanUploadDir);
                        return null;
                    }
                }
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String fileExtension = fileName.substring(fileName.lastIndexOf("."));

                // Sử dụng UUID để tạo tên file ngẫu nhiên
                String newFileName = UUID.randomUUID().toString() + fileExtension;
                File file = new File(uploadFolder, newFileName);
                if (file.exists()) {
                    boolean deleted = file.delete();
                    if (!deleted) {
                        System.out.println("Failed to delete existing file: " + file.getAbsolutePath());
                        return null;
                    }
                }
                try (InputStream fileContent = filePart.getInputStream()) {
                    Files.copy(fileContent, file.toPath(), StandardCopyOption.REPLACE_EXISTING);
                    System.out.println("File successfully uploaded to: " + file.getAbsolutePath());
                } catch (IOException e) {
                    System.out.println("Error saving file: " + e.getMessage());
                    e.printStackTrace();
                    return null;
                }
                imgURL = "/assets/img/news/" + newFileName;
            } else {
                System.out.println("No file uploaded or file is empty.");
            }
        } catch (Exception e) {
            System.out.println("Error during file upload: " + e.getMessage());
            e.printStackTrace();
        }

        return imgURL;
    }
}
