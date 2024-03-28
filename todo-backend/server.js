const express = require("express");
const bodyParser = require("body-parser");
const { MongoClient } = require("mongodb");
const cors = require("cors");

const app = express();
const port = 3000;

app.use(cors());
app.use(bodyParser.json());

const uri = "mongodb+srv://Tarun:Tarun123@cluster0.gnvwszu.mongodb.net/";
const client = new MongoClient(uri, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
});

async function connectDB() {
    try {
        await client.connect();
        console.log("Connected to MongoDB Atlas");
    } catch (err) {
        console.error("Error connecting to MongoDB Atlas", err);
    }
}

connectDB();

app.post("/signup", async (req, res) => {
    try {
        const { username, password } = req.body;
        console.log(req.body);
        const db = client.db("Todo");
        const collection = db.collection("users");
        console.log(username);
        console.log(password);

        // Check if username or password is missing
        if (!username || !password) {
            throw new Error("Username or password is missing");
        }

        // Check if username is already taken
        const existingUser = await collection.findOne({ username });
        if (existingUser) {
            throw new Error("Username is already taken");
        }

        // Create user object with username and password
        const user = { username, password };

        // Insert user object into the collection
        const result = await collection.insertOne(user);

        // Log result and send response
        //console.log("User signed up successfully:", result.ops[0]);
        res.status(200).send("Signup successful");
    } catch (err) {
        console.error("Error signing up:", err);
        res.status(500).send(err.message); // Send error message as response
    }
});

app.get("/signup", (req, res) => {
    // Respond with a message indicating that GET requests to /signup are not allowed
    res.status(405).send("GET requests to /signup are not allowed");
});

app.post("/login", async (req, res) => {
    try {
        const { username, password } = req.body;
        console.log(req.body);
        const db = client.db("Todo");
        const collection = db.collection("users");
        console.log(username);
        console.log(password);

        // Check if username or password is missing
        if (!username || !password) {
            throw new Error("Username or password is missing");
        }

        // Find user in the database
        const user = await collection.findOne({ username, password });

        // If user not found or password is incorrect, return error
        if (!user) {
            throw new Error("Invalid username or password");
        }

        // If login successful, you may want to return a JWT token for authentication
        // For simplicity, let's just return a success message
        res.status(200).send("Login successful");
    } catch (err) {
        console.error("Error logging in:", err);
        res.status(401).send(err.message); // Send error message as response
    }
});

app.post("/todos", async (req, res) => {
    try {
        const { username, todoText, todoPriority } = req.body;
        console.log(req.body);
        const db = client.db("Todo");
        const collection = db.collection("Todos");
        console.log(username);
        console.log(todoText);
        console.log(todoPriority);

        // Check if username, todoText, or todoPriority is missing
        if (!username || !todoText || !todoPriority) {
            throw new Error("Username, todo text, or priority is missing");
        }

        // Create todo object with username, todoText, and todoPriority
        const todo = { username, todoText, todoPriority };

        // Insert todo object into the collection
        const result = await collection.insertOne(todo);

        // Log result and send response
        //console.log("Todo added successfully:", result.ops[0]);
        res.status(200).send("Todo added successfully");
    } catch (err) {
        console.error("Error adding todo:", err);
        res.status(500).send(err.message); // Send error message as response
    }
});

app.get("/todos/:username", async (req, res) => {
    try {
        const username = req.params.username;
        const db = client.db("Todo");
        const collection = db.collection("Todos");

        // Find all todos associated with the given username
        const todos = await collection.find({ username }).toArray();

        res.status(200).json(todos);
    } catch (err) {
        console.error("Error fetching todos:", err);
        res.status(500).send("Internal Server Error");
    }
});

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});
