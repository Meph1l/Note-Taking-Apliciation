package controllers;
import  dao.NoteDAO;
import models.Note;
import java.util.List;
public class TestController {
    public static void main(String[] args) {
       NoteController controller = new NoteController();
        Note note = controller.getNoteByID(1,1);
        note.setContent("This is a Controller test");
        controller.updateExistingNote(note);
        List<Note> notes = controller.getAllNotes(1);   
        for (Note n : notes) {
            System.out.println(n.getNoteID() + " | " + n.getTitle() + " | " + n.getContent());
        }
}}
