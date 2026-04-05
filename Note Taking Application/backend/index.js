import express from "express"
import mysql, { createConnection } from "mysql"
import cors from "cors";

const app = express()

const db = mysql.createConnection({
    host:"localhost",
    user:"root",
    password:"123456",
    database:"crud_app"
})

app.use(express.json())
app.use(cors())

db.connect((err) => {
    if (err) throw (err);
    console.log('Connected to MySQl Database');
});


app.get("/", (req, res)=>{
    res.json("hello this is the backend")
})

app.get("/logins", (req,res)=>{
    const q = "SELECT * FROM users"
    db.query(q,(err,data)=>{
        if(err) return res.json(err)
        return res.json(data)
    })
})

//Insert (?) provides backend security
app.post("/logins", (req,res)=>{
    const q = "INSERT INTO users (`user`,`password`, `email`) VALUES (?)"
    const values = [
        req.body.user,
        req.body.password,
        req.body.email,
        ];          

    db.query(q,[values], (err,data) => {
        if (err) return res.json(err);
        return res.json(data);
    });
});
// =====================================================
// POST /tags
// Function:
// Create a new tag
// Example request body:
// {
//   "tagName": "study"
// }
// =====================================================
app.post("/tags", (req, res) => {
    const { tagName } = req.body;

    // Check whether tagName is provided
    if (!tagName || tagName.trim() === "") {
        return res.json("tagName is required");
    }

    // Insert a new tag into the tag table
    const q = "INSERT INTO tag (`tagName`) VALUES (?)";

    db.query(q, [tagName.trim()], (err, data) => {
        if (err) {
    return res.json("Error creating tag");
}

        return res.json({
            message: "Tag created successfully",
            data
        });
    });
});


// =====================================================
// POST /notes/:noteId/tags
// Function:
// Attach a tag to a note
// Example:
// POST /notes/1/tags
// {
//   "tagName": "study"
// }
// =====================================================
app.post("/notes/:noteId/tags", (req, res) => {
    const { noteId } = req.params;
    const { tagName } = req.body;

    // Make sure tagName is not empty
    if (!tagName || tagName.trim() === "") {
        return res.json( "tagName is required");
    }

    // Step 1: Check whether the note exists
    const checkNoteQuery = "SELECT * FROM notes WHERE noteId = ?";

    db.query(checkNoteQuery, [noteId], (err, noteResult) => {
         if (err) {
            return res.json("Failed to check note");
        }

        if (noteResult.length === 0) {
            return res.json("Note not found");
        }


        // Step 2: Find the tag by tagName
        const findTagQuery = "SELECT tagId FROM tag WHERE tagName = ?";

        db.query(findTagQuery, [tagName.trim()], (err, tagResult) => {
            if (err) {
                return res.json("Failed to find tag");
            }

            if (tagResult.length === 0) {
                return res.json("Tag not found. Please create the tag first.");
            }

            const tagId = tagResult[0].tagId;

            // Step 3: Create the relationship between note and tag
            const insertRelationQuery =
                "INSERT INTO note_tag (`noteId`, `tagId`) VALUES (?, ?)";

            db.query(insertRelationQuery, [noteId, tagId], (err, data) => {
                if (err) {
                    return res.json("Failed to add tag to note");
                }

                return res.json({
                    message: "Tag added to note successfully",
                    data
                });
            });
        });
    });
});


// =====================================================
// GET /notes/search
// Function:
// Search notes by keyword in title or content
// Example:
// /notes/search?keyword=java
// =====================================================
app.get("/notes/search", (req, res) => {
    const { keyword } = req.query;

    // Check whether keyword is provided
    if (!keyword || keyword.trim() === "") {
        return res.json("keyword is required");
    }

    // Add % for LIKE query
    const searchValue = `%${keyword.trim()}%`;

    // Search note title and content
    const q = `
        SELECT *
        FROM notes
        WHERE title LIKE ? OR content LIKE ?
        ORDER BY modifiedDate DESC
    `;

    db.query(q, [searchValue, searchValue], (err, data) => {
        if (err) {
            return res.json("Keyword search failed");
        }

        return res.json(data);
    });
});


// =====================================================
// GET /notes/search/tag
// Function:
// Search notes by tag
// Example:
// /notes/search/tag?tag=study
// =====================================================
app.get("/notes/search/tag", (req, res) => {
    const { tag } = req.query;

    // Check whether tag is provided
    if (!tag || tag.trim() === "") {
        return res.json("tag is required");
    }

    const searchValue = `%${tag.trim()}%`;

    // Join notes, note_tag, and tag to find matching notes
    const q = `
        SELECT DISTINCT n.*
        FROM notes n
        JOIN note_tag nt ON n.noteId = nt.noteId
        JOIN tag t ON nt.tagId = t.tagId
        WHERE t.tagName LIKE ?
        ORDER BY n.modifiedDate DESC
    `;

    db.query(q, [searchValue], (err, data) => {
        if (err) {
            return res.json("Tag search failed");
        }

        return res.json(data);
    });
});
app.get("/registers", (req,res)=>{
    const q = "SELECT * FROM users"
    db.query(q,(err,data)=>{
        if(err) return res.json(err)
        return res.json(data)
    })
})
app.listen(8800, ()=>{
    console.log("Connected to backend!")
})
