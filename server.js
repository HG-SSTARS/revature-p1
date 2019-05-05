const express = require('express');
const path = require('path')
const fs = require('fs')
const multer = require ("multer"); // storage of images
const port = 8080;
const app = express();
const directoryPath = path.join(__dirname, '/public/uploads')
app.use(express.static('.'));

// Init upload
const upload = multer({
    dest: directoryPath
}).single('imgUploader')

// Handle the upload route
app.post("/upload", upload, function (req, res) { 
    res.redirect('/')
}); 

app.get('/images', function (req, res) {
   
fs.readdir(directoryPath, (err, files) => {
    if (err) {
        return res.json([])
    }
    return res.json(files);
 })
})
 
app.listen(8080, function () { 
    console.log("Listening to port 8080"); 
});
