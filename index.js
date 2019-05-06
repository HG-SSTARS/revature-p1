let learn = document.querySelector("#section")

if(learn){

   fetch('/images')
   .then(res => res.json())
   .then(res => {
        console.log(res)
       res.forEach(image =>{
         const img = document.createElement('img')
         img.src = img.src = `https://${process.env.AZURE_STORAGE_ACCOUNT_NAME}.blob.core.windows.net/images/${image}`

         learn.appendChild(img)  //Node.appendChild() method adds a node to the end of the list of children of a specified parent node.
       })
   });



}
