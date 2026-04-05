package dao;

import models.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {

    public User findUserByCredentials(String email, String password) {
        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            if (conn == null) {
                System.out.println("Database connection failed.");
                return null;
            }

            stmt.setString(1, email);
            stmt.setString(2, password);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                int userID = rs.getInt("userid");
                String username = rs.getString("user");
                String dbEmail = rs.getString("email");
                String dbPassword = rs.getString("password");
                int loggedIn = rs.getInt("loggedin");

                return new User(userID, username, dbEmail, dbPassword, loggedIn);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean incrementLoginCount(int userID) {
        String sql = "UPDATE users SET loggedin = loggedin + 1 WHERE userid = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            if (conn == null) {
                System.out.println("Database connection failed.");
                return false;
            }

            stmt.setInt(1, userID);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public User getUserById(int userID) {
        String sql = "SELECT * FROM users WHERE userid = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            if (conn == null) {
                System.out.println("Database connection failed.");
                return null;
            }

            stmt.setInt(1, userID);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String username = rs.getString("user");
                String email = rs.getString("email");
                String password = rs.getString("password");
                int loggedIn = rs.getInt("loggedin");

                return new User(userID, username, email, password, loggedIn);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }
}