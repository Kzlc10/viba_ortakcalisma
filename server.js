require("dotenv").config();
const fs = require("fs");
const https = require("https");
const express = require("express");
const jwt = require("jsonwebtoken");
const bcrypt = require("bcryptjs");
const cors = require("cors");
const helmet = require("helmet");

const app = express();
const PORT = process.env.PORT || 3000;
const SECRET_KEY = process.env.SECRET_KEY || "supersecret";

// Middleware'ler
app.use(express.json());
app.use(cors());
app.use(helmet());

// Kullanıcı veritabanı (Geçici olarak bellekte saklıyoruz)
const users = [];

// 🟢 Kullanıcı kaydı (Register)
app.post("/register", async (req, res) => {
    const { username, password } = req.body;

    // Kullanıcı zaten var mı?
    const existingUser = users.find((user) => user.username === username);
    if (existingUser) {
        return res.status(400).json({ message: "Kullanıcı zaten var!" });
    }

    // Şifreyi hashle
    const hashedPassword = await bcrypt.hash(password, 10);
    users.push({ username, password: hashedPassword });

    res.json({ message: "Kayıt başarılı!" });
});

// 🔵 Kullanıcı girişi (Login)
app.post("/login", async (req, res) => {
    const { username, password } = req.body;
    const user = users.find((u) => u.username === username);

    if (!user || !(await bcrypt.compare(password, user.password))) {
        return res.status(401).json({ message: "Geçersiz kimlik bilgileri!" });
    }

    // JWT oluştur
    const token = jwt.sign({ username }, SECRET_KEY, { expiresIn: "1h" });

    res.json({ token });
});

// 🟠 Korumalı rota (Protected Route)
app.get("/protected", verifyToken, (req, res) => {
    res.json({ message: "Gizli verilere erişim sağlandı!", user: req.user });
});

// 🔐 Token doğrulama middleware
function verifyToken(req, res, next) {
    const token = req.headers["authorization"];
    if (!token) {
        return res.status(403).json({ message: "Token gerekli!" });
    }

    jwt.verify(token.split(" ")[1], SECRET_KEY, (err, user) => {
        if (err) {
            return res.status(403).json({ message: "Geçersiz token!" });
        }
        req.user = user;
        next();
    });
}

// 🟢 SSL Sertifikalarını Yükleme
const sslOptions = {
    key: fs.readFileSync("private.key"),
    cert: fs.readFileSync("certificate.crt"),
};

// 🟢 HTTPS Sunucu Başlatma
https.createServer(sslOptions, app).listen(PORT, () => {
    console.log(`🚀 Secure server running at https://localhost:${PORT}`);
});
