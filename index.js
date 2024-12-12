// Importar las librerías necesarias
import express from "express";
import fs from "fs";
import bodyParser from "body-parser";

// Crear la aplicación de Express
const app = express();

// Configurar el middleware de body-parser
app.use(bodyParser.json());

// Función para leer datos de un archivo JSON
const readData = () => {
    try {
        const data = fs.readFileSync("./data.json");
        return JSON.parse(data);
    } catch (error) {
        console.error(error);
    }
};

// Función para escribir datos en un archivo JSON
const writeData = (data) => {
    try {
        fs.writeFileSync("./data.json", JSON.stringify(data));
    } catch (error) {
        console.error(error);
    }
};

// Endpoint para registrar un usuario
app.post("/user", (req, res) => {
    const data = readData();
    const body = req.body;
    const newUser = {
        id: data.user.length + 1,
        ...body,
    };
    data.user.push(newUser);
    writeData(data);
    res.json(newUser);
});

// Endpoint para obtener un usuario por su ID
app.get("/user/:id", (req, res) => {
    const data = readData();
    const id = parseInt(req.params.id);
    const user = data.user.find((user) => user.id === id);
    res.json(user);
});

// Endpoint para listar a todos los usuarios
app.get("/user", (req, res) => {
    const data = readData();
    res.json(data.user);
});

export default app;
