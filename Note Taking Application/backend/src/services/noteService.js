import noteDAO from "../dao/notedao.js";
import folderDAO from "../dao/folderdao.js";

// Get all notes for a specific user
const getNotesByUser = async (userId) => {
  return await noteDAO.getNotesByUserId(userId);
};

// Get notes that are not inside any folder
const getUnfolderedNotesByUser = async (userId) => {
  return await noteDAO.getUnfolderedNotesByUserId(userId);
};

// Get notes inside one folder
const getNotesByFolder = async (folderId, userId) => {
  return await noteDAO.getNotesByFolderId(folderId, userId);
};

// Get one note by noteId
const getNoteById = async (noteId, userId) => {
  return await noteDAO.getNoteById(noteId, userId);
};

// Create a note
const createNote = async (title, content, userId, folderId = null) => {
  if (folderId !== null) {
    const folder = await folderDAO.getFolderById(folderId, userId);

    if (!folder) {
      throw new Error("Folder not found.");
    }
  }

  return await noteDAO.createNote(title, content, userId, folderId);
};

// Update note
const updateNote = async (noteId, title, content, userId) => {
  const existingNote = await noteDAO.getNoteById(noteId, userId);

  if (!existingNote) {
    throw new Error("Note not found.");
  }

  await noteDAO.updateNote(noteId, title, content, userId);
  return true;
};

// Delete note
const deleteNote = async (noteId, userId) => {
  const existingNote = await noteDAO.getNoteById(noteId, userId);

  if (!existingNote) {
    throw new Error("Note not found.");
  }

  await noteDAO.deleteNote(noteId, userId);
  return true;
};

// Move note into a folder or remove it from folder
const moveNoteToFolder = async (noteId, folderId = null, userId) => {
  const existingNote = await noteDAO.getNoteById(noteId, userId);

  if (!existingNote) {
    throw new Error("Note not found.");
  }

  if (folderId !== null) {
    const folder = await folderDAO.getFolderById(folderId, userId);

    if (!folder) {
      throw new Error("Folder not found.");
    }
  }

  await noteDAO.moveNoteToFolder(noteId, folderId, userId);
  return true;
};

export {
  getNotesByUser,
  getUnfolderedNotesByUser,
  getNotesByFolder,
  getNoteById,
  createNote,
  updateNote,
  deleteNote,
  moveNoteToFolder
};