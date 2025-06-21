/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author BuiNgocLinh
 */
public class PackageSubject {
    private int package_id;
    private int subject_id;

    public PackageSubject() {
    }

    public PackageSubject(int package_id, int subject_id) {
        this.package_id = package_id;
        this.subject_id = subject_id;
    }

    public int getPackage_id() {
        return package_id;
    }

    public void setPackage_id(int package_id) {
        this.package_id = package_id;
    }

    public int getSubject_id() {
        return subject_id;
    }

    public void setSubject_id(int subject_id) {
        this.subject_id = subject_id;
    }

    @Override
    public String toString() {
        return "PackageSubject{" + "package_id=" + package_id + ", subject_id=" + subject_id + '}';
    }
    
    
}
