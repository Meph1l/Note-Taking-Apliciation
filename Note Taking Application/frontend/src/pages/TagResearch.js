import React, { useState } from "react";
import "./style.css";
import "bootstrap/dist/css/bootstrap.css";

const TagResearch = () => {
  const [tagName, setTagName] = useState("");
  const [noteId, setNoteId] = useState("");
  const [attachTagName, setAttachTagName] = useState("");
  const [keyword, setKeyword] = useState("");
  const [tagKeyword, setTagKeyword] = useState("");

  const [msg, setMsg] = useState("");
  const [results, setResults] = useState([]);

  const sectionStyle = {
    marginTop: "24px",
    padding: "18px",
    border: "1px solid var(--border)",
    borderRadius: "var(--radius)",
    background: "var(--white)"
  };

  const titleStyle = {
    fontSize: "1.1rem",
    marginBottom: "16px",
    color: "var(--dark)"
  };

  const msgStyle = {
    marginTop: "12px",
    fontSize: "0.95rem",
    color: "var(--red)"
  };

  const resultCardStyle = {
    padding: "14px",
    marginTop: "12px",
    border: "1px solid var(--border)",
    borderRadius: "var(--radius)",
    background: "var(--gray-100)"
  };

  const handleCreateTag = async () => {
    setMsg("");
    setResults([]);

    try {
      const res = await fetch("http://localhost:8800/tags", {
        method: "POST",
        headers: {
          "Content-Type": "application/json"
        },
        body: JSON.stringify({ tagName })
      });

      const data = await res.json();
      setMsg(typeof data === "string" ? data : data.message);
    } catch (err) {
      setMsg("Failed to connect to backend");
    }
  };

  const handleAttachTag = async () => {
    setMsg("");
    setResults([]);

    try {
      const res = await fetch(`http://localhost:8800/notes/${noteId}/tags`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json"
        },
        body: JSON.stringify({ tagName: attachTagName })
      });

      const data = await res.json();
      setMsg(typeof data === "string" ? data : data.message);
    } catch (err) {
      setMsg("Failed to connect to backend");
    }
  };

  const handleKeywordResearch = async () => {
    setMsg("");
    setResults([]);

    try {
      const res = await fetch(
        `http://localhost:8800/notes/search?keyword=${encodeURIComponent(keyword)}`
      );

      const data = await res.json();

      if (typeof data === "string") {
        setMsg(data);
      } else {
        setResults(data);

        if (data.length === 0) {
          setMsg("No notes found");
        }
      }
    } catch (err) {
      setMsg("Failed to connect to backend");
    }
  };

  const handleTagResearch = async () => {
    setMsg("");
    setResults([]);

    try {
      const res = await fetch(
        `http://localhost:8800/notes/search/tag?tag=${encodeURIComponent(tagKeyword)}`
      );

      const data = await res.json();

      if (typeof data === "string") {
        setMsg(data);
      } else {
        setResults(data);

        if (data.length === 0) {
          setMsg("No notes found");
        }
      }
    } catch (err) {
      setMsg("Failed to connect to backend");
    }
  };

  return (
    <div className="login-page">
      <div className="login-card" style={{ maxWidth: "900px" }}>
        <h1 className="login-title">Tag and Research</h1>
        <p className="login-sub">Create tags and research notes</p>

        <div style={sectionStyle}>
          <h3 style={titleStyle}>Create Tag</h3>

          <div className="form-group" id="form1">
            <label className="form-label">Tag Name</label>
            <input
              className="form-input"
              type="text"
              placeholder="study"
              value={tagName}
              onChange={(e) => setTagName(e.target.value)}
            />
          </div>

          <button
            className="btn btn-primary btn-full"
            id="login-btn"
            onClick={handleCreateTag}
          >
            Create Tag
          </button>
        </div>

        <div style={sectionStyle}>
          <h3 style={titleStyle}>Add Tag to Note</h3>

          <div className="form-group" id="form1">
            <label className="form-label">Note ID</label>
            <input
              className="form-input"
              type="text"
              placeholder="1"
              value={noteId}
              onChange={(e) => setNoteId(e.target.value)}
            />
          </div>

          <div className="form-group" id="form2">
            <label className="form-label">Tag Name</label>
            <input
              className="form-input"
              type="text"
              placeholder="study"
              value={attachTagName}
              onChange={(e) => setAttachTagName(e.target.value)}
            />
          </div>

          <button
            className="btn btn-primary btn-full"
            id="login-btn"
            onClick={handleAttachTag}
          >
            Add Tag to Note
          </button>
        </div>

        <div style={sectionStyle}>
          <h3 style={titleStyle}>Research Notes by Keyword</h3>

          <div className="form-group" id="form1">
            <label className="form-label">Keyword</label>
            <input
              className="form-input"
              type="text"
              placeholder="java"
              value={keyword}
              onChange={(e) => setKeyword(e.target.value)}
            />
          </div>

          <button
            className="btn btn-primary btn-full"
            id="login-btn"
            onClick={handleKeywordResearch}
          >
            Research by Keyword
          </button>
        </div>

        <div style={sectionStyle}>
          <h3 style={titleStyle}>Research Notes by Tag</h3>

          <div className="form-group" id="form1">
            <label className="form-label">Tag</label>
            <input
              className="form-input"
              type="text"
              placeholder="study"
              value={tagKeyword}
              onChange={(e) => setTagKeyword(e.target.value)}
            />
          </div>

          <button
            className="btn btn-primary btn-full"
            id="login-btn"
            onClick={handleTagResearch}
          >
            Research by Tag
          </button>
        </div>

        {msg && <p style={msgStyle}>{msg}</p>}

        {results.length > 0 &&
          results.map((note) => (
            <div style={resultCardStyle} key={note.noteId}>
              <p><strong>Note ID:</strong> {note.noteId}</p>
              <p><strong>Title:</strong> {note.title}</p>
              <p><strong>Content:</strong> {note.content}</p>
            </div>
          ))}
      </div>
    </div>
  );
};

export default TagResearch;