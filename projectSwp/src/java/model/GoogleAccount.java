/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author BuiNgocLinh
 */
public class GoogleAccount {

    private String google_id, email, name, first_name, given_name, family_name, picture;
    private int account_id;
    private boolean verified_email;

    public GoogleAccount() {
    }

    public GoogleAccount(String google_id, String email, String name, String first_name, String given_name, String family_name, String picture, int account_id, boolean verified_email) {
        this.google_id = google_id;
        this.email = email;
        this.name = name;
        this.first_name = first_name;
        this.given_name = given_name;
        this.family_name = family_name;
        this.picture = picture;
        this.account_id = account_id;
        this.verified_email = verified_email;
    }

    public void setGoogle_id(String google_id) {
        this.google_id = google_id;
    }
    
    public void setAccount_id(int account_id) {
        this.account_id = account_id;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setFirst_name(String first_name) {
        this.first_name = first_name;
    }

    public void setGiven_name(String given_name) {
        this.given_name = given_name;
    }

    public void setFamily_name(String family_name) {
        this.family_name = family_name;
    }

    public void setPicture(String picture) {
        this.picture = picture;
    }

    public void setVerified_email(boolean verified_email) {
        this.verified_email = verified_email;
    }

    public String getGoogle_id() {
        return google_id;
    }
    
    public int getAccount_id() {
        return account_id;
    }

    public String getEmail() {
        return email;
    }

    public String getName() {
        return name;
    }

    public String getFirst_name() {
        return first_name;
    }

    public String getGiven_name() {
        return given_name;
    }

    public String getFamily_name() {
        return family_name;
    }

    public String getPicture() {
        return picture;
    }

    public boolean isVerified_email() {
        return verified_email;
    }

    @Override
    public String toString() {
        return "GoogleAccount{" + "google_id=" + google_id + ", email=" + email + ", name=" + name 
                + ", first_name=" + first_name + ", given_name=" + given_name 
                + ", family_name=" + family_name + ", picture=" + picture 
                + ", account_id=" + account_id + ", verified_email=" + verified_email + '}';
    }
}