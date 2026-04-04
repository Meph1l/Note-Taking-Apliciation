package dao;
import models.Note;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
public class NoteDAO{
    Note note;
    List<Note> notes; 
    public boolean createNote(Note note){
          String sql = "INSERT INTO notes (title, content, dateCreated, modifiedDate, historyID, userID) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, note.getTitle());
            stmt.setString(2, note.getContent());
            stmt.setTimestamp(3, Timestamp.valueOf(note.getDateCreated()));

            if (note.getModifiedDate() != null) {
                stmt.setTimestamp(4, Timestamp.valueOf(note.getModifiedDate()));
            } else {
                stmt.setNull(4, java.sql.Types.TIMESTAMP);
            }

            stmt.setInt(5, note.getHistoryID());
            stmt.setInt(6, note.getUserID());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    public List<Note> getallNotes(int userID){
        notes = new ArrayList<>();
        String sql = "SELECT * FROM notes WHERE userID = ?";
        try (Connection con = DBConnection.getConnection();
            PreparedStatement stmt = con.prepareStatement(sql)){
                stmt.setInt(1,userID);
                ResultSet rs = stmt.executeQuery();
                while (rs.next()){
                int noteId = rs.getInt("noteId");
                String title = rs.getString("title");
                String content = rs.getString("content");

                Timestamp createdTs = rs.getTimestamp("dateCreated");
                Timestamp modifiedTs = rs.getTimestamp("modifiedDate");

                LocalDateTime dateCreated = createdTs.toLocalDateTime();
                LocalDateTime modifiedDate = (modifiedTs != null) ? modifiedTs.toLocalDateTime() : null;

                int historyID = rs.getInt("historyID");
                int dbUserID = rs.getInt("userID");

                Note note = new Note(noteId, title, content, dateCreated, modifiedDate, historyID, dbUserID);
                notes.add(note);
                }
            }
            catch(SQLException e){
                e.printStackTrace();
            }
            return notes;
            }
    
    public Note getNotebyid (int noteID, int userID){
        String sql = "SELECT * FROM notes WHERE noteId = ?";
        Note note1 = new Note(userID);
        try (Connection con = DBConnection.getConnection();
            PreparedStatement stmt = con.prepareStatement(sql)){
                stmt.setInt(1,noteID);
                ResultSet rs = stmt.executeQuery();
                while(rs.next()){
                    int noteId = rs.getInt("noteId");
                String title = rs.getString("title");
                String content = rs.getString("content");

                Timestamp createdTs = rs.getTimestamp("dateCreated");
                Timestamp modifiedTs = rs.getTimestamp("modifiedDate");

                LocalDateTime dateCreated = createdTs.toLocalDateTime();
                LocalDateTime modifiedDate = (modifiedTs != null) ? modifiedTs.toLocalDateTime() : null;

                int historyID = rs.getInt("historyID");
                int dbUserID = rs.getInt("userID");

                note1 = new Note(noteId, title, content, dateCreated, modifiedDate, historyID, dbUserID);
                }
            }
            catch(SQLException e){
                e.printStackTrace();
            }
            return note1;
    }
    public boolean updateNote(Note note){
        String sql = "UPDATE Note SET title = ?, content = ?, modifiedDate = ?, historyID = ?, userID = ? WHERE noteID = ?";

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        stmt.setString(1, note.getTitle());
        stmt.setString(2, note.getContent());

        if (note.getModifiedDate() != null) {
            stmt.setTimestamp(3, Timestamp.valueOf(note.getModifiedDate()));
        } else {
            stmt.setNull(3, java.sql.Types.TIMESTAMP);
        }

        stmt.setInt(4, note.getHistoryID());
        stmt.setInt(5, note.getUserID());
        stmt.setInt(6, note.getNoteID());

        int rowsAffected = stmt.executeUpdate();
        return rowsAffected > 0;

    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
    }
    public boolean deleteNote(int noteID){
       String sql = "DELETE FROM Note WHERE noteID = ?";

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        stmt.setInt(1, noteID);

        int rowsAffected = stmt.executeUpdate();
        return rowsAffected > 0;

    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
    }
}
