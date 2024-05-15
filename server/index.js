const express = require("express");
const { MongoClient } = require("mongodb");

var http = require("http");
const cors = require("cors");
const app = express();
const port = process.env.PORT || 5000;
var server = http.createServer(app);
var io = require("socket.io")(server, {
    cors: {
        origin: "*"
    }
});

app.use(express.json());
app.use(cors());
app.post('/api/data', (req, res) => {
    const jsonData = req.body;
})

io.on("connection", (socket) => {
    console.log("connected");
    console.log(socket.id, "has joined");
    socket.on("/test", (msg) => {
        console.log(msg);
    })
    socket.on("makale", (msg) => {
        console.log(msg);
    })
    socket.on("ekle", (msg) => {
        ekle(msg);
    })

    socket.on("kategoricek", () => {
        kategoricek();
    })
    socket.on("dokumancek", (msg) => {
        dokumancek(msg);
    })
    socket.on("dokumancekk", (msg) => {
        dokumancekk(msg);
    })
    socket.on("kategoricekkontrol", () => {
        kategoricekkontrol();
    })
 

    async function kategoricek() {
        let client;
        const collectionsList = [];
        try {
            const uri = "mongodb://localhost:27017/";
            client = new MongoClient(uri);
            await client.connect();
            const database = client.db('web_scraping');
            const collections = await database.listCollections().toArray();
            collections.forEach(collection => {
                const collectionMap = {
                    "name": collection.name,  
                   
                };
                collectionsList.push(collectionMap);
            });

            socket.emit("koleksiyonlar", collectionsList);
            /*  console.log('Koleksiyonlar:');
              collections.forEach(collection => {
                  console.log(collection.name);
              });*/
        } catch (error) {
            console.error("Error:", error);
        } finally {
            if (client) {
                await client.close();
            }
        }
    }
    async function kategoricekkontrol() {
        let client;
        const collectionsList = [];
        try {
            const uri = "mongodb://localhost:27017/";
            client = new MongoClient(uri);
            await client.connect();
            const database = client.db('web_scraping');
            const collections = await database.listCollections().toArray();
            collections.forEach(collection => {
                const collectionMap = {
                    "name": collection.name,  
                   
                };
                collectionsList.push(collectionMap);
            });

            socket.emit("koleksiyonlarkontrol", collectionsList);
            /*  console.log('Koleksiyonlar:');
              collections.forEach(collection => {
                  console.log(collection.name);
              });*/
        } catch (error) {
            console.error("Error:", error);
        } finally {
            if (client) {
                await client.close();
            }
        }
    }

    async function dokumancek(collectionName) {
        let client;
        try {
            const uri = "mongodb://localhost:27017/";
            client = new MongoClient(uri);
            await client.connect();
            const database = client.db('web_scraping');
            const collection = database.collection(collectionName);
          
            const documents = await collection.find({}).toArray();
            
            socket.emit("dokumanlar", documents);


        } catch (error) {
            console.error("Error:", error);
         
        } finally {
            if (client) {
                await client.close();
            }
        }
    }

    
     
    async function dokumancekk(collectionName) {
        let client;
        try {
            const uri = "mongodb://localhost:27017/";
            client = new MongoClient(uri);
            await client.connect();
            const database = client.db('web_scraping');
            const collection = database.collection(collectionName);
             
            const documents = await collection.find({}).toArray();
           
            socket.emit("dokumanlarr", documents);


        } catch (error) {
            console.error("Error:", error);
           
        } finally {
            if (client) {
                await client.close();
            }
        }
    }




    async function ekle(msg) {
        let client;



        try {
            const uri = "mongodb://localhost:27017/";
            client = new MongoClient(uri);
            await client.connect();
            const aranankelime = msg.aranankelime;
            const database = client.db('web_scraping');
            const myColl = database.collection(aranankelime);
            const result = await myColl.insertOne(msg);
            
        } catch (error) {
            console.error("Error:", error);
        } finally {
            await client.close();
        }
    }
});

server.listen(port, "0.0.0.0", () => {
    console.log("server started");
});
