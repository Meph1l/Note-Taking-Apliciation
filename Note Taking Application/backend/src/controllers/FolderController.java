package controllers;

import dao.FolderDAO;
import models.Folder;
import models.Note;

import java.util.*;

/**
 * FolderController – business logic layer for folder operations.
 * Place this file at: backend/controllers/FolderController.java
 *
 * This is the "FolderDatabase" controller from your class diagram.
 * It sits between the API routes (index.js) and FolderDAO.
 */
public class FolderController {

    private final FolderDAO folderDAO;

    public FolderController() {
        this.folderDAO = new FolderDAO();
    }

    // ─── UC-18: Create Folder ────────────────────────────────────────────────────

    /**
     * Create a root-level folder for a user.
     */
    public Map<String, Object> createFolder(String folderName, int userId) {
        return createFolderInternal(folderName, userId, null);
    }

    /**
     * Create a sub-folder inside an existing folder.
     */
    public Map<String, Object> createSubFolder(String folderName, int userId, int parentFolderId) {
        return createFolderInternal(folderName, userId, parentFolderId);
    }

    private Map<String, Object> createFolderInternal(String folderName, int userId, Integer parentFolderId) {
        Map<String, Object> response = new HashMap<>();

        // Validate input
        if (folderName == null || folderName.trim().isEmpty()) {
            response.put("success", false);
            response.put("message", "Folder name cannot be empty.");
            return response;
        }

        // Check for duplicate name
        if (folderDAO.folderNameExists(folderName.trim(), userId, parentFolderId)) {
            response.put("success", false);
            response.put("message", "A folder with that name already exists.");
            return response;
        }

        Folder created = folderDAO.createFolder(folderName.trim(), userId, parentFolderId);
        if (created != null) {
            response.put("success", true);
            response.put("message", "Folder created successfully.");
            response.put("folder", folderToMap(created));
        } else {
            response.put("success", false);
            response.put("message", "Failed to create folder.");
        }
        return response;
    }

    // ─── UC-19: Delete Folder ────────────────────────────────────────────────────

    public Map<String, Object> deleteFolder(int folderId) {
        Map<String, Object> response = new HashMap<>();
        boolean deleted = folderDAO.deleteFolder(folderId);
        response.put("success", deleted);
        response.put("message", deleted ? "Folder deleted." : "Failed to delete folder.");
        return response;
    }

    // ─── UC-20: Rename Folder ────────────────────────────────────────────────────

    public Map<String, Object> renameFolder(int folderId, String newName) {
        Map<String, Object> response = new HashMap<>();

        if (newName == null || newName.trim().isEmpty()) {
            response.put("success", false);
            response.put("message", "New name cannot be empty.");
            return response;
        }

        boolean renamed = folderDAO.renameFolder(folderId, newName.trim());
        response.put("success", renamed);
        response.put("message", renamed ? "Folder renamed." : "Failed to rename folder.");
        return response;
    }

    // ─── Get Folders ─────────────────────────────────────────────────────────────

    /**
     * Get all folders for a user as a flat list.
     */
    public List<Map<String, Object>> getAllFolders(int userId) {
        List<Folder> folders = folderDAO.getFoldersByUser(userId);
        List<Map<String, Object>> result = new ArrayList<>();
        for (Folder f : folders) {
            result.add(folderToMap(f));
        }
        return result;
    }

    /**
     * Build a hierarchical folder tree for a user.
     * Root folders contain their sub-folders nested inside.
     */
    public List<Map<String, Object>> getFolderTree(int userId) {
        List<Folder> allFolders = folderDAO.getFoldersByUser(userId);

        // Map folderId -> folder data
        Map<Integer, Map<String, Object>> folderMap = new LinkedHashMap<>();
        for (Folder f : allFolders) {
            Map<String, Object> fm = folderToMap(f);
            fm.put("subFolders", new ArrayList<>());
            folderMap.put(f.getFolderId(), fm);
        }

        // Build tree
        List<Map<String, Object>> roots = new ArrayList<>();
        for (Folder f : allFolders) {
            Map<String, Object> fm = folderMap.get(f.getFolderId());
            if (f.getParentFolderId() == null) {
                roots.add(fm);
            } else {
                Map<String, Object> parent = folderMap.get(f.getParentFolderId());
                if (parent != null) {
                    @SuppressWarnings("unchecked")
                    List<Map<String, Object>> subs = (List<Map<String, Object>>) parent.get("subFolders");
                    subs.add(fm);
                }
            }
        }
        return roots;
    }

    // ─── UC-13: Notes in Folder ──────────────────────────────────────────────────

    /**
     * Get all notes inside a folder.
     */
    public List<Map<String, Object>> getNotesInFolder(int folderId) {
        List<Note> notes = folderDAO.getNotesInFolder(folderId);
        List<Map<String, Object>> result = new ArrayList<>();
        for (Note n : notes) {
            result.add(noteToMap(n));
        }
        return result;
    }

    /**
     * Move a note into a folder (or remove from folder with folderId = null).
     */
    public Map<String, Object> moveNoteToFolder(int noteId, Integer folderId) {
        Map<String, Object> response = new HashMap<>();
        boolean moved = folderDAO.moveNoteToFolder(noteId, folderId);
        response.put("success", moved);
        response.put("message", moved ? "Note moved successfully." : "Failed to move note.");
        return response;
    }

    // ─── Helpers ─────────────────────────────────────────────────────────────────

    private Map<String, Object> folderToMap(Folder f) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("folderId",       f.getFolderId());
        m.put("folderName",     f.getFolderName());
        m.put("userId",         f.getUserId());
        m.put("parentFolderId", f.getParentFolderId());
        return m;
    }

    private Map<String, Object> noteToMap(Note n) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("noteId",       n.getNoteId());
        m.put("title",        n.getTitle());
        m.put("content",      n.getContent());
        m.put("createdDate",  n.getCreatedDate());
        m.put("modifiedDate", n.getModifiedDate());
        m.put("folderId",     n.getFolderId());
        return m;
    }
}
