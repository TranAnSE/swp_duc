package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.PackageSubject;

public class PackageSubjectDAO extends DBContext {

    public List<PackageSubject> getAll() {
        List<PackageSubject> list = new ArrayList<>();
        String sql = "SELECT * FROM package_subject";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new PackageSubject(
                    rs.getInt("package_id"),
                    rs.getInt("subject_id")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public PackageSubject getById(int packageId, int subjectId) {
        String sql = "SELECT * FROM package_subject WHERE package_id = ? AND subject_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, packageId);
            ps.setInt(2, subjectId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new PackageSubject(
                        rs.getInt("package_id"),
                        rs.getInt("subject_id")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void insert(PackageSubject ps) {
        String sql = "INSERT INTO package_subject (package_id, subject_id) VALUES (?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, ps.getPackage_id());
            stmt.setInt(2, ps.getSubject_id());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void update(PackageSubject ps, int oldPackageId, int oldSubjectId) {
        String sql = "UPDATE package_subject SET package_id = ?, subject_id = ? WHERE package_id = ? AND subject_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, ps.getPackage_id());
            stmt.setInt(2, ps.getSubject_id());
            stmt.setInt(3, oldPackageId);
            stmt.setInt(4, oldSubjectId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void delete(int packageId, int subjectId) {
        String sql = "DELETE FROM package_subject WHERE package_id = ? AND subject_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, packageId);
            stmt.setInt(2, subjectId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
