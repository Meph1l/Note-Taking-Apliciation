import db from "../config/db.js";
import Note from "../models/note.js";
// Get all notes for a specific user
const getNotesByUserId = (userId) => {
  return new Promise((resolve, reject) => {
    const sql = `
      SELECT noteId, title, content, dateCreated, modifiedDate, folderId, userId
      FROM notes
      WHERE userId = ?
      ORDER BY dateCreated DESC
    `;

    db.query(sql, [userId], (err, results) => {
      if (err) return reject(err);

      const notes = results.map(
        (row) =>
          new Note(
            row.noteId,
            row.title,
            row.content,
            row.dateCreated,
            row.modifiedDate,
            row.folderId,
            row.userId
          )
      );

      resolve(notes);
    });
  });
};

// Get notes that are not inside any folder
const getUnfolderedNotesByUserId = (userId) => {
  return new Promise((resolve, reject) => {
    const sql = `
      SELECT noteId, title, content, dateCreated, modifiedDate, folderId, userId
      FROM notes
      WHERE userId = ? AND folderId IS NULL
      ORDER BY dateCreated DESC
    `;

    db.query(sql, [userId], (err, results) => {
      if (err) return reject(err);

      const notes = results.map(
        (row) =>
          new Note(
            row.noteId,
            row.title,
            row.content,
            row.dateCreated,
            row.modifiedDate,
            row.folderId,
            row.userId
          )
      );

      resolve(notes);
    });
  });
};

// Get notes inside one folder
const getNotesByFolderId = (folderId, userId) => {
  return new Promise((resolve, reject) => {
    const sql = `
      SELECT noteId, title, content, dateCreated, modifiedDate, folderId, userId
      FROM notes
      WHERE folderId = ? AND userId = ?
      ORDER BY dateCreated DESC
    `;

    db.query(sql, [folderId, userId], (err, results) => {
      if (err) return reject(err);

      const notes = results.map(
        (row) =>
          new Note(
            row.noteId,
            row.title,
            row.content,
            row.dateCreated,
            row.modifiedDate,
            row.folderId,
            row.userId
          )
      );

      resolve(notes);
    });
  });
};

// Get one note by noteId
const getNoteById = (noteId, userId) => {
  return new Promise((resolve, reject) => {
    const sql = `
      SELECT noteId, title, content, dateCreated, modifiedDate, folderId, userId
      FROM notes
      WHERE noteId = ? AND userId = ?
    `;

    db.query(sql, [noteId, userId], (err, results) => {
      if (err) return reject(err);

      if (results.length === 0) {
        return resolve(null);
      }

      const row = results[0];
      const note = new Note(
        row.noteId,
        row.title,
        row.content,
        row.dateCreated,
        row.modifiedDate,
        row.folderId,
        row.userId
      );

      resolve(note);
    });
  });
};

// Create a new note
const createNote = (title, content, userId, folderId = null) => {
  return new Promise((resolve, reject) => {
    const sql = `
      INSERT INTO notes (title, content, dateCreated, modifiedDate, folderId, userId)
      VALUES (?, ?, NOW(), NULL, ?, ?)
    `;

    db.query(sql, [title, content, folderId, userId], (err, result) => {
      if (err) return reject(err);

      const newNote = new Note(
        result.insertId,
        title,
        content,
        new Date(),
        null,
        folderId,
        userId
      );

      resolve(newNote);
    });
  });
};

// Update an existing note
const updateNote = (noteId, title, content, userId) => {
  return new Promise((resolve, reject) => {
    const sql = `
      UPDATE notes
      SET title = ?, content = ?, modifiedDate = NOW()
      WHERE noteId = ? AND userId = ?
    `;

    db.query(sql, [title, content, noteId, userId], (err, result) => {
      if (err) return reject(err);
      resolve(result);
    });
  });
};

// Delete note by noteId
const deleteNote = (noteId, userId) => {
  return new Promise((resolve, reject) => {
    const sql = `
      DELETE FROM notes
      WHERE noteId = ? AND userId = ?
    `;

    db.query(sql, [noteId, userId], (err, result) => {
      if (err) return reject(err);
      resolve(result);
    });
  });
};

// Move note into a folder or remove it from folder
const moveNoteToFolder = (noteId, folderId = null, userId) => {
  return new Promise((resolve, reject) => {
    const sql = `
      UPDATE notes
      SET folderId = ?
      WHERE noteId = ? AND userId = ?
    `;

    db.query(sql, [folderId, noteId, userId], (err, result) => {
      if (err) return reject(err);
      resolve(result);
    });
  });
};

export default {
  getNotesByUserId,
  getUnfolderedNotesByUserId,
  getNotesByFolderId,
  getNoteById,
  createNote,
  updateNote,
  deleteNote,
  moveNoteToFolder
};