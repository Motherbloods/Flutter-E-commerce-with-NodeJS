const jwt = require("jsonwebtoken");
require("dotenv").config();

const verifyToken = (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    if (authHeader) {
      const token = authHeader.split(" ")[1];
      jwt.verify(token, process.env.SECRET_TOKEN, (err, decoded) => {
        if (err) {
          return res.status(403).json({ error: "Invalid token" });
        }
        req.user = decoded;
        next();
      });
    }
  } catch (e) {
    res.status(401).json({ error: "Authorization header missing" });
  }
};

module.exports = verifyToken;
