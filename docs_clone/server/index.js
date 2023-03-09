const authRouter = require("./routes/auth");
const express = require("express");
const mongoose = require("mongoose");
const cors = require('cors');
const PORT = process.env.PORT | 3001;
const http = require("http");
const documentRouter = require("./routes/document");
const Document = require("./models/document");

const app = express();
var server = http.createServer(app);
var io = require("socket.io")(server);

app.use(cors());
app.use(express.json());
app.use(authRouter);
app.use(documentRouter);

mongoose.set("strictQuery", true);
const DB = "mongodb+srv://yuhang:wewewe123@cluster0.hwidg9p.mongodb.net/?retryWrites=true&w=majority";

mongoose.connect(DB).then(()=>{
    console.log("Connection successful!");
}).catch((err)=>{
    console.log(err);
});

io.on("connection",(socket)=>{
    socket.on("join", (documentId) => {
        socket.join(documentId);
      });
    
      socket.on("typing", (data) => {
        socket.broadcast.to(data.room).emit("changes", data);
      });

      socket.on('save',(data)=>{
        saveData(data);
      });
});

const saveData = async (data) => {
    let document = await Document.findById(data.room);
    document.content = data.delta;
    document = await document.save();
  };


server.listen(PORT,"0.0.0.0",()=>{
    console.log(`connected at port ${PORT}`);
});

