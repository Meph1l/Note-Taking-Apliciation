package models;
import java.time.LocalDate;
import java.time.LocalDateTime;
public class Note {
 private int noteID; 
 private String title;
 private String content;
 private LocalDateTime dateCreated;
 private LocalDateTime modifiedDate;
 private int historyID;
 private int userID;

public Note(int u1){ 
    this.userID = u1;
    this.dateCreated = LocalDateTime.now();
    this.content = "";
    this.title = "Untitled";
    this.modifiedDate= null;
}
public Note(int noteID, String title, String content, LocalDateTime d1,
                LocalDateTime m1, int historyID, int userID) {
        this.noteID = noteID;
        this.title = title;
        this.content = content;
        this.dateCreated = d1;
        this.modifiedDate = m1;
        this.historyID = historyID;
        this.userID = userID;
    }
public int getNoteID(){
    return noteID;
}
public void setNoteID(int n1){
    this.noteID = n1;
}
public String getTitle(){
    return title;
}
public void setTitle(String t1){
    this.title= t1;
    this.modifiedDate = LocalDateTime.now();
}
public String getContent(){
    return this.content;
}
public void setContent (String c1){
    this.content = c1; 
    this.modifiedDate = LocalDateTime.now();
}

public LocalDateTime getDateCreated (){
    return this.dateCreated;
}
public LocalDateTime getModifiedDate(){
    return this.modifiedDate;
}
public int getHistoryID(){
    return this.historyID;
}
public int getUserID(){
    return this.userID;
}
public void setHistoryID(int h1){
    this.historyID = h1;

}
}

