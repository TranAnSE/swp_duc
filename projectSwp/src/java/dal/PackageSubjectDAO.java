package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.PackageSubject;

public class PackageSubjectDAO extends DBContext {

    public List<PackageSubject> getAll() {
        List<PackageSubject> list = new ArrayList<>();
        String sql = "SELECT * FROM package_subject";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
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

    // Check if package includes a specific subject
    public boolean packageIncludesSubject(int packageId, int subjectId) {
        String sql = "SELECT COUNT(*) FROM package_subject WHERE package_id = ? AND subject_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, packageId);
            ps.setInt(2, subjectId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Get subjects included in a package
    public List<Integer> getPackageSubjects(int packageId) {
        List<Integer> subjectIds = new ArrayList<>();
        String sql = "SELECT subject_id FROM package_subject WHERE package_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, packageId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                subjectIds.add(rs.getInt("subject_id"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return subjectIds;
    }

    // Add subject to package
    public boolean addSubjectToPackage(int packageId, int subjectId) {
        String sql = "INSERT INTO package_subject (package_id, subject_id) VALUES (?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, packageId);
            ps.setInt(2, subjectId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Remove subject from package
    public boolean removeSubjectFromPackage(int packageId, int subjectId) {
        String sql = "DELETE FROM package_subject WHERE package_id = ? AND subject_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, packageId);
            ps.setInt(2, subjectId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
