package dao;
import dao.NoteDAO;
import models.Note;
import java.util.List;
public class TestDAO {
    public static void main(String[] args) {
        NoteDAO dao = new NoteDAO();
        Note note = dao.getNotebyid(1,1);
        // note.setContent("This is a DAO test");
        // note.setHistoryID(0);

        // boolean created = dao.createNote(note);
        // System.out.println("Created: " + created);

        note.setContent("This is an updated Content");
        note.setHistoryID(1);
        dao.updateNote(note);
        List<Note> notes = dao.getallNotes(1);
        for (Note n : notes) {
            System.out.println(n.getNoteID() + " | " + n.getTitle() + " | " + n.getContent());
        }
    }
}

