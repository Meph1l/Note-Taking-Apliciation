// frontend/src/pages/Folders.js
// Place this file at: frontend/src/pages/Folders.js

import React, { useState, useEffect, useCallback } from "react";
import "./Folders.css";

const API = "http://localhost:8080/api";

// ─── Small helper components ──────────────────────────────────────────────────

function FolderNode({ folder, selectedId, onSelect, onRename, onDelete, onCreateSub, level = 0 }) {
  const isSelected = folder.folderId === selectedId;

  return (
    <div className="folder-node" style={{ marginLeft: level * 20 }}>
      <div
        className={`folder-row ${isSelected ? "selected" : ""}`}
        onClick={() => onSelect(folder.folderId)}
      >
        <span className="folder-icon">📁</span>
        <span className="folder-name">{folder.folderName}</span>
        <div className="folder-actions" onClick={(e) => e.stopPropagation()}>
          <button className="btn-icon" title="Create sub-folder" onClick={() => onCreateSub(folder.folderId)}>＋</button>
          <button className="btn-icon" title="Rename" onClick={() => onRename(folder.folderId, folder.folderName)}>✏️</button>
          <button className="btn-icon danger" title="Delete" onClick={() => onDelete(folder.folderId, folder.folderName)}>🗑</button>
        </div>
      </div>

      {/* Render sub-folders recursively */}
      {folder.subFolders && folder.subFolders.map((sub) => (
        <FolderNode
          key={sub.folderId}
          folder={sub}
          selectedId={selectedId}
          onSelect={onSelect}
          onRename={onRename}
          onDelete={onDelete}
          onCreateSub={onCreateSub}
          level={level + 1}
        />
      ))}
    </div>
  );
}

// ─── Main Folders Page ────────────────────────────────────────────────────────

export default function Folders() {
  // Hard-coded userId=1 (Galen) for demo – swap with real auth later
  const userId = 1;

  const [folderTree,      setFolderTree]      = useState([]);
  const [selectedFolder,  setSelectedFolder]  = useState(null);
  const [notesInFolder,   setNotesInFolder]   = useState([]);
  const [statusMsg,       setStatusMsg]       = useState("");
  const [loading,         setLoading]         = useState(false);

  // Modal state
  const [modal, setModal] = useState(null);
  // modal = { type: "create"|"createSub"|"rename"|"delete"|"move",
  //           folderId?, oldName?, noteId? }
  const [inputValue, setInputValue] = useState("");

  // ─── Data fetching ───────────────────────────────────────────────────────────

  const fetchTree = useCallback(async () => {
    setLoading(true);
    const res = await fetch(`${API}/folders/tree?userId=${userId}`);
    const data = await res.json();
    setFolderTree(data);
    setLoading(false);
  }, [userId]);

  const fetchNotes = useCallback(async (folderId) => {
    const res = await fetch(`${API}/folders/${folderId}/notes`);
    const data = await res.json();
    setNotesInFolder(data);
  }, []);

  useEffect(() => { fetchTree(); }, [fetchTree]);
  useEffect(() => {
    if (selectedFolder) fetchNotes(selectedFolder);
    else setNotesInFolder([]);
  }, [selectedFolder, fetchNotes]);

  // ─── Status message helper ────────────────────────────────────────────────────

  const showStatus = (msg, isError = false) => {
    setStatusMsg({ text: msg, error: isError });
    setTimeout(() => setStatusMsg(""), 3000);
  };

  // ─── Modal handlers ──────────────────────────────────────────────────────────

  const openCreate    = ()           => { setModal({ type: "create" });               setInputValue(""); };
  const openCreateSub = (folderId)   => { setModal({ type: "createSub", folderId }); setInputValue(""); };
  const openRename    = (id, name)   => { setModal({ type: "rename", folderId: id }); setInputValue(name); };
  const openDelete    = (id, name)   => { setModal({ type: "delete", folderId: id, folderName: name }); };
  const closeModal    = ()           => { setModal(null); setInputValue(""); };

  // UC-18: Create Folder
  const handleCreate = async () => {
    if (!inputValue.trim()) return;
    const body = { folderName: inputValue.trim(), userId };
    const res = await fetch(`${API}/folders`, {
      method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify(body),
    });
    const data = await res.json();
    if (res.ok) { showStatus("Folder created!"); fetchTree(); closeModal(); }
    else        { showStatus(data.error || "Error creating folder.", true); }
  };

  // UC-18: Create Sub-Folder
  const handleCreateSub = async () => {
    if (!inputValue.trim()) return;
    const body = { folderName: inputValue.trim(), userId, parentFolderId: modal.folderId };
    const res = await fetch(`${API}/folders`, {
      method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify(body),
    });
    const data = await res.json();
    if (res.ok) { showStatus("Sub-folder created!"); fetchTree(); closeModal(); }
    else        { showStatus(data.error || "Error.", true); }
  };

  // UC-20: Rename Folder
  const handleRename = async () => {
    if (!inputValue.trim()) return;
    const res = await fetch(`${API}/folders/${modal.folderId}`, {
      method: "PUT", headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ folderName: inputValue.trim() }),
    });
    if (res.ok) { showStatus("Folder renamed!"); fetchTree(); closeModal(); }
    else        { showStatus("Error renaming folder.", true); }
  };

  // UC-19: Delete Folder
  const handleDelete = async () => {
    const res = await fetch(`${API}/folders/${modal.folderId}`, { method: "DELETE" });
    if (res.ok) {
      showStatus("Folder deleted.");
      if (selectedFolder === modal.folderId) setSelectedFolder(null);
      fetchTree();
      closeModal();
    } else {
      showStatus("Error deleting folder.", true);
    }
  };

  // UC-13: Move Note to Another Folder
  const handleMoveNote = async (noteId, targetFolderId) => {
    const res = await fetch(`${API}/notes/${noteId}/move`, {
      method: "PUT", headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ folderId: targetFolderId || null }),
    });
    if (res.ok) {
      showStatus("Note moved!");
      if (selectedFolder) fetchNotes(selectedFolder);
    } else {
      showStatus("Error moving note.", true);
    }
  };

  // ─── Render ──────────────────────────────────────────────────────────────────

  return (
    <div className="folders-page">

      {/* ── Left Panel: Folder Tree ─────────────────────────── */}
      <div className="panel panel-left">
        <div className="panel-header">
          <h2>📂 Folders</h2>
          <button className="btn-primary" onClick={openCreate}>＋ New Folder</button>
        </div>

        {loading && <p className="hint">Loading…</p>}

        {!loading && folderTree.length === 0 && (
          <p className="hint">No folders yet. Create one!</p>
        )}

        <div className="folder-tree">
          {folderTree.map((folder) => (
            <FolderNode
              key={folder.folderId}
              folder={folder}
              selectedId={selectedFolder}
              onSelect={setSelectedFolder}
              onRename={openRename}
              onDelete={openDelete}
              onCreateSub={openCreateSub}
            />
          ))}
        </div>
      </div>

      {/* ── Right Panel: Notes in Selected Folder ──────────── */}
      <div className="panel panel-right">
        {selectedFolder ? (
          <>
            <div className="panel-header">
              <h2>📝 Notes in Folder</h2>
            </div>

            {notesInFolder.length === 0 ? (
              <p className="hint">No notes in this folder yet.</p>
            ) : (
              <div className="notes-list">
                {notesInFolder.map((note) => (
                  <div key={note.noteId} className="note-card">
                    <div className="note-card-header">
                      <h3>{note.title}</h3>
                      <span className="note-date">
                        {note.modifiedDate
                          ? new Date(note.modifiedDate).toLocaleDateString()
                          : ""}
                      </span>
                    </div>
                    <p className="note-preview">
                      {note.content ? note.content.slice(0, 120) + (note.content.length > 120 ? "…" : "") : ""}
                    </p>
                    <div className="note-move">
                      <label>Move to folder: </label>
                      <select
                        defaultValue=""
                        onChange={(e) => {
                          const val = e.target.value;
                          if (val !== "") handleMoveNote(note.noteId, val === "none" ? null : parseInt(val));
                          e.target.value = "";
                        }}
                      >
                        <option value="" disabled>Select…</option>
                        <option value="none">🚫 Remove from folder</option>
                        {/* Flatten tree for dropdown */}
                        {flattenTree(folderTree).map((f) => (
                          <option key={f.folderId} value={f.folderId}>{f.folderName}</option>
                        ))}
                      </select>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </>
        ) : (
          <div className="empty-state">
            <span>👈</span>
            <p>Select a folder to see its notes.</p>
          </div>
        )}
      </div>

      {/* ── Status Message ─────────────────────────────────── */}
      {statusMsg && (
        <div className={`status-toast ${statusMsg.error ? "error" : "success"}`}>
          {statusMsg.text}
        </div>
      )}

      {/* ── Modal ──────────────────────────────────────────── */}
      {modal && (
        <div className="modal-overlay" onClick={closeModal}>
          <div className="modal" onClick={(e) => e.stopPropagation()}>

            {/* Create Folder */}
            {(modal.type === "create" || modal.type === "createSub") && (
              <>
                <h3>{modal.type === "create" ? "Create Folder" : "Create Sub-Folder"}</h3>
                <input
                  autoFocus
                  type="text"
                  placeholder="Folder name"
                  value={inputValue}
                  onChange={(e) => setInputValue(e.target.value)}
                  onKeyDown={(e) => e.key === "Enter" && (modal.type === "create" ? handleCreate() : handleCreateSub())}
                />
                <div className="modal-buttons">
                  <button className="btn-primary" onClick={modal.type === "create" ? handleCreate : handleCreateSub}>
                    Create
                  </button>
                  <button className="btn-secondary" onClick={closeModal}>Cancel</button>
                </div>
              </>
            )}

            {/* Rename Folder */}
            {modal.type === "rename" && (
              <>
                <h3>Rename Folder</h3>
                <input
                  autoFocus
                  type="text"
                  value={inputValue}
                  onChange={(e) => setInputValue(e.target.value)}
                  onKeyDown={(e) => e.key === "Enter" && handleRename()}
                />
                <div className="modal-buttons">
                  <button className="btn-primary" onClick={handleRename}>Rename</button>
                  <button className="btn-secondary" onClick={closeModal}>Cancel</button>
                </div>
              </>
            )}

            {/* Delete Folder */}
            {modal.type === "delete" && (
              <>
                <h3>Delete Folder</h3>
                <p>Delete <strong>"{modal.folderName}"</strong>?<br />
                  Notes inside will be unassigned (not deleted). Sub-folders will be removed.</p>
                <div className="modal-buttons">
                  <button className="btn-danger" onClick={handleDelete}>Delete</button>
                  <button className="btn-secondary" onClick={closeModal}>Cancel</button>
                </div>
              </>
            )}

          </div>
        </div>
      )}
    </div>
  );
}

// Flatten nested tree into flat array (for move-to-folder dropdown)
function flattenTree(tree) {
  const result = [];
  function walk(nodes) {
    nodes.forEach((n) => {
      result.push(n);
      if (n.subFolders) walk(n.subFolders);
    });
  }
  walk(tree);
  return result;
}
