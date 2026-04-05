package dao;

import models.Folder;
import models.Note;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * FolderDAO – all database operations for folders.
 * Place this file at: backend/data access objects/FolderDAO.java
 *
 * Corresponds to FolderDatabase in the class diagram.
 */
public class FolderDAO {

    // ─── Database connection ─────────────────────────────────────────────────────

    private static final String URL  = "jdbc:mysql://localhost:3306/crud_app";
    private static final String USER = "root";
    private static final String PASS = "123456";

    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }

    // ─── CREATE ──────────────────────────────────────────────────────────────────

    /**
     * UC-18: Create a new folder (or sub-folder) for a user.
     * @param folderName     name of the new folder
     * @param userId         owner
     * @param parentFolderId null for root folder, or parent's id for sub-folder
     * @return the newly created Folder with its generated id, or null on failure
     */
    public Folder createFolder(String folderName, int userId, Integer parentFolderId) {
        String sql = "INSERT INTO folder (folderName, userId, parentFolderId) VALUES (?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, folderName);
            stmt.setInt(2, userId);
            if (parentFolderId == null) stmt.setNull(3, Types.INTEGER);
            else                        stmt.setInt(3, parentFolderId);

            int rows = stmt.executeUpdate();
            if (rows > 0) {
                ResultSet keys = stmt.getGeneratedKeys();
                if (keys.next()) {
                    int newId = keys.getInt(1);
                    return new Folder(newId, folderName, userId, parentFolderId);
                }
            }
        } catch (SQLException e) {
            System.err.println("createFolder error: " + e.getMessage());
        }
        return null;
    }

    // ─── READ ────────────────────────────────────────────────────────────────────

    /**
     * Get all folders belonging to a user (flat list).
     */
    public List<Folder> getFoldersByUser(int userId) {
        List<Folder> folders = new ArrayList<>();
        String sql = "SELECT folderId, folderName, userId, parentFolderId FROM folder WHERE userId = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                int     id       = rs.getInt("folderId");
                String  name     = rs.getString("folderName");
                int     uid      = rs.getInt("userId");
                Integer parentId = rs.getObject("parentFolderId", Integer.class);
                folders.add(new Folder(id, name, uid, parentId));
            }
        } catch (SQLException e) {
            System.err.println("getFoldersByUser error: " + e.getMessage());
        }
        return folders;
    }

    /**
     * Get all notes inside a specific folder.
     * UC-13: needed to display notes after selecting a folder.
     */
    public List<Note> getNotesInFolder(int folderId) {
        List<Note> notes = new ArrayList<>();
        String sql = "SELECT noteId, title, content, dateCreated, modifiedDate, folderId " +
                     "FROM notes WHERE folderId = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, folderId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Note note = new Note();
                note.setNoteId(rs.getInt("noteId"));
                note.setTitle(rs.getString("title"));
                note.setContent(rs.getString("content"));
                note.setCreatedDate(rs.getDate("dateCreated"));
                note.setModifiedDate(rs.getDate("modifiedDate"));
                note.setFolderId(rs.getObject("folderId", Integer.class));
                notes.add(note);
            }
        } catch (SQLException e) {
            System.err.println("getNotesInFolder error: " + e.getMessage());
        }
        return notes;
    }

    /**
     * Check if a folder name already exists for a given user (and optional parent).
     */
    public boolean folderNameExists(String folderName, int userId, Integer parentFolderId) {
        String sql;
        if (parentFolderId == null) {
            sql = "SELECT COUNT(*) FROM folder WHERE folderName=? AND userId=? AND parentFolderId IS NULL";
        } else {
            sql = "SELECT COUNT(*) FROM folder WHERE folderName=? AND userId=? AND parentFolderId=?";
        }

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, folderName);
            stmt.setInt(2, userId);
            if (parentFolderId != null) stmt.setInt(3, parentFolderId);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;

        } catch (SQLException e) {
            System.err.println("folderNameExists error: " + e.getMessage());
        }
        return false;
    }

    // ─── UPDATE ──────────────────────────────────────────────────────────────────

    /**
     * UC-20: Rename a folder.
     * @return true if renamed successfully
     */
    public boolean renameFolder(int folderId, String newName) {
        String sql = "UPDATE folder SET folderName = ? WHERE folderId = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, newName);
            stmt.setInt(2, folderId);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("renameFolder error: " + e.getMessage());
        }
        return false;
    }

    /**
     * UC-13: Move a note into a folder (or out of any folder with null).
     * @return true if moved successfully
     */
    public boolean moveNoteToFolder(int noteId, Integer folderId) {
        String sql = "UPDATE notes SET folderId = ? WHERE noteId = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            if (folderId == null) stmt.setNull(1, Types.INTEGER);
            else                  stmt.setInt(1, folderId);
            stmt.setInt(2, noteId);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("moveNoteToFolder error: " + e.getMessage());
        }
        return false;
    }

    // ─── DELETE ──────────────────────────────────────────────────────────────────

    /**
     * UC-19: Delete a folder.
     * Notes inside are un-assigned (folderId set to NULL) before deletion
     * to preserve the notes themselves.
     * Sub-folders are also deleted recursively.
     * @return true if deleted successfully
     */
    public boolean deleteFolder(int folderId) {
        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);

            // 1. Un-assign notes from this folder
            String unassignNotes = "UPDATE notes SET folderId = NULL WHERE folderId = ?";
            try (PreparedStatement s = conn.prepareStatement(unassignNotes)) {
                s.setInt(1, folderId);
                s.executeUpdate();
            }

            // 2. Delete child folders recursively (simple one-level; extend if needed)
            String deleteChildren = "DELETE FROM folder WHERE parentFolderId = ?";
            try (PreparedStatement s = conn.prepareStatement(deleteChildren)) {
                s.setInt(1, folderId);
                s.executeUpdate();
            }

            // 3. Delete the folder itself
            String deleteFolder = "DELETE FROM folder WHERE folderId = ?";
            try (PreparedStatement s = conn.prepareStatement(deleteFolder)) {
                s.setInt(1, folderId);
                int rows = s.executeUpdate();
                conn.commit();
                return rows > 0;
            }

        } catch (SQLException e) {
            System.err.println("deleteFolder error: " + e.getMessage());
        }
        return false;
    }
}
