package models;

import java.util.ArrayList;
import java.util.List;

/**
 * Folder entity class
 * Place this file at: backend/models/Folder.java
 */
public class Folder {

    private int folderId;
    private String folderName;
    private int userId;
    private Integer parentFolderId; // null = root folder
    private List<Folder> subFolders;
    private List<Note> notes;

    // ─── Constructors ───────────────────────────────────────────────────────────

    public Folder() {
        this.subFolders = new ArrayList<>();
        this.notes      = new ArrayList<>();
    }

    public Folder(int folderId, String folderName, int userId, Integer parentFolderId) {
        this.folderId       = folderId;
        this.folderName     = folderName;
        this.userId         = userId;
        this.parentFolderId = parentFolderId;
        this.subFolders     = new ArrayList<>();
        this.notes          = new ArrayList<>();
    }

    // ─── Business Method ────────────────────────────────────────────────────────

    /**
     * Rename this folder.
     * UC-20: Rename Folder
     */
    public void rename(String newName) {
        if (newName == null || newName.trim().isEmpty()) {
            throw new IllegalArgumentException("Folder name cannot be empty.");
        }
        this.folderName = newName.trim();
    }

    // ─── Getters & Setters ──────────────────────────────────────────────────────

    public int getFolderId()                 { return folderId; }
    public void setFolderId(int folderId)    { this.folderId = folderId; }

    public String getFolderName()                { return folderName; }
    public void setFolderName(String folderName) { this.folderName = folderName; }

    public int getUserId()              { return userId; }
    public void setUserId(int userId)   { this.userId = userId; }

    public Integer getParentFolderId()                  { return parentFolderId; }
    public void setParentFolderId(Integer parentFolderId){ this.parentFolderId = parentFolderId; }

    public List<Folder> getSubFolders()                  { return subFolders; }
    public void setSubFolders(List<Folder> subFolders)   { this.subFolders = subFolders; }
    public void addSubFolder(Folder folder)              { this.subFolders.add(folder); }

    public List<Note> getNotes()                 { return notes; }
    public void setNotes(List<Note> notes)       { this.notes = notes; }
    public void addNote(Note note)               { this.notes.add(note); }

    @Override
    public String toString() {
        return "Folder{id=" + folderId + ", name='" + folderName +
               "', userId=" + userId + ", parentId=" + parentFolderId + "}";
    }
}
