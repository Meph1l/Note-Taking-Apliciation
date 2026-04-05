package models;
public class User {
    private int userID;
    private String username;
    private String email;
    private String password;
    private int loggedIn;

    public User(int userID, String username, String email, String password, int loggedIn) {
        this.userID = userID;
        this.username = username;
        this.email = email;
        this.password = password;
        this.loggedIn = loggedIn;
    }

    public int getUserID() {
        return userID;
    }

    public String getUsername() {
        return username;
    }

    public String getEmail() {
        return email;
    }

    public String getPassword() {
        return password;
    }

    public int getLoggedIn() {
        return loggedIn;
    }

    public void setLoggedIn(int loggedIn) {
        this.loggedIn = loggedIn;
    }
}

