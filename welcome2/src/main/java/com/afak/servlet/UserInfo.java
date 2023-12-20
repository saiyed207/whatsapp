package com.afak.servlet;

public class UserInfo {
    private String firstName;
    private String uniqueId;
    private String imageUrl; // New field for image URL

    public UserInfo() {
        // Default constructor
    }

    public UserInfo(String firstName, String uniqueId, String imageUrl) {
        this.firstName = firstName;
        this.uniqueId = uniqueId;
        this.imageUrl = imageUrl;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getUniqueId() {
        return uniqueId;
    }

    public void setUniqueId(String uniqueId) {
        this.uniqueId = uniqueId;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
}
