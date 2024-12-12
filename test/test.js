import request from "supertest";
import app from "../index";
import fs from "fs";

jest.mock("fs");

describe("Test API Endpoints", () => {
    it("Debería retornar una lista completa de usuarios", async () => {
        const mockData = {
            user: [
                { id: 1, name: "Eduardo", email: "correo1@gmail.com", telefono: "+56911111111", fecha_registro: "2024-12-06" },
                { id: 2, name: "Andres", email: "correo2@gmail.com", telefono: "+56911111112", fecha_registro: "2024-12-06" },
                { id: 3, name: "Pedro", email: "correo3@gmail.com", telefono: "+56911111113", fecha_registro: "2024-12-06" },
            ],
        };

        fs.readFileSync.mockImplementation(() => JSON.stringify(mockData));

        const response = await request(app).get("/user");

        expect(response.status).toBe(200);
        expect(response.body).toEqual(mockData.user);
        expect(response.body).toHaveLength(3);
    });
});

describe("POST /user", () => {
    it("Debería agregar un nuevo usuario y devolverlo con su ID asignado", async () => {
        const mockData = {
            user: [
                { id: 1, name: "Eduardo", email: "correo1@gmail.com", telefono: "+56911111111", fecha_registro: "2024-12-06" },
                { id: 2, name: "Andres", email: "correo2@gmail.com", telefono: "+56911111112", fecha_registro: "2024-12-06" },
                { id: 3, name: "Pedro", email: "correo3@gmail.com", telefono: "+56911111113", fecha_registro: "2024-12-06" },
            ],
        };

        const newUser = {
            name: "Juan",
            email: "correo4@gmail.com",
            telefono: "+56911111114",
            fecha_registro: "2024-12-06",
        };

        fs.readFileSync.mockImplementation(() => JSON.stringify(mockData));
        fs.writeFileSync.mockImplementation((filePath, data) => {
            const updatedData = JSON.parse(data);
            const newId = Math.max(...updatedData.user.map((u) => u.id)) + 1;
            expect(updatedData.user).toHaveLength(4);
            expect(updatedData.user[4]).toMatchObject({
                id: newId,
                ...newUser,
            });
        });

        const response = await request(app).post("/user").send(newUser);

        expect(response.status).toBe(200);
        expect(response.body).toMatchObject({
            id: 4,
            ...newUser,
        });
    });
});

describe("GET /user/:id", () => {
    it("Debería retornar un usuario por su ID si existe", async () => {
        const mockData = {
            user: [
                { id: 1, name: "Eduardo", email: "correo1@gmail.com", telefono: "+56911111111", fecha_registro: "2024-12-06" },
                { id: 2, name: "Andres", email: "correo2@gmail.com", telefono: "+56911111112", fecha_registro: "2024-12-06" },
                { id: 3, name: "Pedro", email: "correo3@gmail.com", telefono: "+56911111113", fecha_registro: "2024-12-06" },
            ],
        };

        fs.readFileSync.mockImplementation(() => JSON.stringify(mockData));

        const response = await request(app).get("/user/2");

        expect(response.status).toBe(200);
        expect(response.body).toMatchObject({
            id: 2,
            name: "Andres",
            email: "correo2@gmail.com",
            telefono: "+56911111112",
            fecha_registro: "2024-12-06",
        });
    });
});