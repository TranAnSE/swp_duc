/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Image;

/**
 *
 * @author BuiNgocLinh
 */
public class ImageDAO extends DBContext {

    public ImageDAO(Connection connection) {
        this.connection = connection;
    }

    public Image findImageById(int id) {
        String sql = "SELECT * FROM image WHERE id = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, id);
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    Image image = new Image();
                    image.setId(rs.getInt("id"));
                    image.setImage_data(rs.getString("image_data"));
                    return image;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Image> findAll() throws SQLException {
        String sql = "SELECT * FROM image";
        List<Image> images = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Image image = new Image();
                image.setId(rs.getInt("id"));
                image.setImage_data(rs.getString("image_data"));
                images.add(image);
            }
        }
        return images;
    }

    public int insertImage(Image image) throws SQLException {
        String sql = "INSERT INTO image (image_data) VALUES (?)";
        PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
        ps.setString(1, image.getImage_data());
        int affectedRows = ps.executeUpdate();

        if (affectedRows == 0) {
            throw new SQLException("Creating image failed, no rows affected.");
        }

        try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
            if (generatedKeys.next()) {
                return generatedKeys.getInt(1);
            } else {
                throw new SQLException("Creating image failed, no ID obtained.");
            }
        }
    }

}
