package com.afak.servlet;

public class User {
    private String firstName;
    private String uniqueId;
    private String imageUrl;

    // Constructor with parameters
    public User(String firstName, String uniqueId, String imageUrl) {
        this.firstName = firstName;
        this.uniqueId = uniqueId;
        this.imageUrl = imageUrl;
    }

    // Getter methods
    public String getFirstName() {
        return firstName;
    }

    public String getUniqueId() {
        return uniqueId;
    }

    public String getImageUrl() {
        return imageUrl;
    }
}
