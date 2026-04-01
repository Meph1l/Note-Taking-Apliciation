import express from "express"
import mysql from "mysql"


const app = express()

const db = mysql.createConnection({
    host:"localhost",
    user:"root",
    password:"123456",
    database:"crud_app"
})

app.use(express.json())

db.connect((err) => {
    if (err) throw (err);
    console.log('Connected to MySQl Database');
});


app.get("/", (req, res)=>{
    res.json("hello this is the backend")
})

app.get("/logins", (req,res)=>{
    const q = "SELECT * FROM logins"
    db.query(q,(err,data)=>{
        if(err) return res.json(err)
        return res.json(data)
    })
})

//Insert (?) provides backend security
app.post("/logins", (req,res)=>{
    const q = "INSERT INTO logins (`user`,`password`, `email`) VALUES (?)"
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

app.listen(8800, ()=>{
    console.log("Connected to backend!")
})