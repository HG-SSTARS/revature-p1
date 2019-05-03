const express = require('express');
const path = require('path')
const fileUpload = require('express-fileupload')
const multer = require ("multer"); // storage of images
const port = 8000;
const app = express();

app.use(fileUpload());
app.get("/", function (req, res) { 
    res.sendFile(path.join(__dirname + "/index.html")); 
}); 

// Set storage engine
const storage = multer.diskStorage({
    destination: './public/uploads',
    filename: function (req, file, cb) {        
    // null as first argument means no error
        cb(null, Date.now() + '-' + file.originalname )
    }
})

// Init upload
const upload = multer({
    storage: storage, 
    limits: {
        fileSize: 100
    },
    fileFilter: function (req, file, cb) {
        sanitizeFile(file, cb);
    }
}).single('files')



// Handle the upload route
app.post("/upload", upload, function (req, res) { 
    console.log(req.files)
    let sampleFile = req.files.imgUploader;
    let uploadPath = __dirname + '/public/uploads' + sampleFile.name;
    res.send(uploadPath)
}); 
 
app.listen(8000, function () { 
    console.log("Listening to port 8000"); 
});