/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.StudyPackage;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Na
 */
public class StudyPackageDAO extends DBContext {
    
    //Hien ra list cac goi hoc
    public List<StudyPackage> getStudyPackage(String sql) {
        List<StudyPackage> list = new ArrayList<>();
        
        try {
            Statement state = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
            ResultSet rs = state.executeQuery(sql);
            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                String price = rs.getString("price");
                StudyPackage stuPackage = new StudyPackage(id, name, price);
                list.add(stuPackage);
            }
        } catch (SQLException ex) {
            Logger.getLogger(StudyPackageDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }
    
    //add them goi hoc moi
    public int addStudyPackage (StudyPackage stuPackage) {
        int n = 0;
        String sql = "INSERT INTO STUDY_PACKAGE (id, name, price)\n"
                + "     VALUES\n"
                + "(?, ?, ?)";
        
        try {
            PreparedStatement pre = connection.prepareStatement(sql);
            pre.setInt(1, stuPackage.getId());
            pre.setString(2, stuPackage.getName());
            pre.setString(3, stuPackage.getPrice());
            n = pre.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(StudyPackageDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return n;
    }
    
    //update cac goi hoc
    public int updateStudyPackage (StudyPackage stuPackage) {
        int n = 0;
        String sql = """
                     UPDATE study_package
                        SET name = ?
                           ,price = ?
                     WHERE id = ?
                     """;
        
        try {
            PreparedStatement pre = connection.prepareStatement(sql);
            pre.setString(1, stuPackage.getName());
            pre.setString(2, stuPackage.getPrice());
            pre.setInt(3, stuPackage.getId());
            n = pre.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(StudyPackageDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return n;
    }
    
    //delete cac goi hoc
    public int deleteStudyPackage (int id) {
        int n = 0;
        String sql = "DELETE FROM study_package WHERE id = ?";
        
        try {
            PreparedStatement pre = connection.prepareStatement(sql);
            pre.setInt(1, id);
            n = pre.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(StudyPackageDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return n;
    }
    
    //tim kiem goi hoc theo id
    public StudyPackage findStudyPackageById (int id) {
        String sql = "SELECT * FROM study_package WHERE id = ?";
        
        try {
            PreparedStatement pre = connection.prepareStatement(sql);
            pre.setInt(1, id);
            ResultSet rs = pre.executeQuery();
            while (rs.next()) {
                return new StudyPackage(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("price")
                );
            }
        } catch (SQLException ex) {
            Logger.getLogger(StudyPackageDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }
    
    //tim kiem goi hoc theo ten
    public List<StudyPackage> findStudyPackageByName (String name) {
        List<StudyPackage> list = new ArrayList<>();
        String sql = "SELECT * FROM STUDY_PACKAGE WHERE name LIKE ?";
        
        try {
            PreparedStatement pre = connection.prepareStatement(sql);
            pre.setString(1, "%" + name + "%");
            ResultSet rs = pre.executeQuery();
            while (rs.next()) {
                StudyPackage stuPackage = new StudyPackage(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("price")
                    );
                list.add(stuPackage);
            }
        } catch (SQLException ex) {
            Logger.getLogger(StudyPackageDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }
    
    //tim kiem goi hoc theo price
    public List<StudyPackage> findStudyPackageByPrice (String price) {
        List<StudyPackage> list = new ArrayList<>();
        String sql = "SELECT * FROM study_package WHERE price = ?";
        
        try {
            PreparedStatement pre = connection.prepareStatement(sql);
            pre.setString(1, price);
            ResultSet rs = pre.executeQuery();
            while (rs.next()) {
                StudyPackage stuPackage = new StudyPackage(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("price")
                    );
                list.add(stuPackage);
            }
        } catch (SQLException ex) {
            Logger.getLogger(StudyPackageDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }
}
