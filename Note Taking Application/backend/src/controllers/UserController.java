package controllers;

import dao.UserDAO;
import models.User;

public class UserController {

    private UserDAO userDAO;

    public UserController() {
        this.userDAO = new UserDAO();
    }

    public User login(String email, String password) {
        User user = userDAO.findUserByCredentials(email, password);

        if (user != null) {
            boolean updated = userDAO.incrementLoginCount(user.getUserID());

            if (updated) {
                user.setLoggedIn(user.getLoggedIn() + 1);
            }

            return user;
        }

        return null;
    }

    public User getUserById(int userID) {
        return userDAO.getUserById(userID);
    }
}