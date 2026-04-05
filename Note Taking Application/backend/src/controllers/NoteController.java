package controllers;
import dao.NoteDAO;
import models.Note;
import java.util.List;
import models.User;
public class NoteController {
    NoteDAO noteDAO;

    public NoteController(){
        this.noteDAO = new NoteDAO();
    }
    public boolean createNote(Note note){
        return noteDAO.createNote(note);
    }
    public List<Note> getAllNotes(int userID){
        return noteDAO.getallNotes(userID);
    }
    public List<Note> processLandingPageRequest (User user){
        return noteDAO.getallNotes(user.getUserID());
    }
    public boolean updateExistingNote(Note note){
        return noteDAO.updateNote(note);
    }
    public boolean deleteExistingNote(int noteID){
        return noteDAO.deleteNote(noteID);
    }
    public Note getNoteByID(int noteID, int userID){
        return noteDAO.getNotebyid(noteID, userID);
    }
}