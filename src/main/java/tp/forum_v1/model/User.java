package tp.forum_v1.model;

import java.sql.Timestamp;

public class User {
    private int id;
    private String username;
    private String email;
    private String password;
    private Timestamp joinDate;
    private boolean isActive;
    private boolean isAdmin;
    private String profilePicture;

    public User() {
    }

    public User(int id, String username, String email, String password, Timestamp joinDate, boolean isActive,
            boolean isAdmin, String profilePicture) {
        this.id = id;
        this.username = username;
        this.email = email;
        this.password = password;
        this.joinDate = joinDate;
        this.isActive = isActive;
        this.isAdmin = isAdmin;
        this.profilePicture = profilePicture;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public Timestamp getJoinDate() {
        return joinDate;
    }

    public void setJoinDate(Timestamp joinDate) {
        this.joinDate = joinDate;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public boolean isAdmin() {
        return isAdmin;
    }

    public void setAdmin(boolean admin) {
        isAdmin = admin;
    }

    public String getProfilePicture() {
        return profilePicture;
    }

    public void setProfilePicture(String profilePicture) {
        this.profilePicture = profilePicture;
    }
}
