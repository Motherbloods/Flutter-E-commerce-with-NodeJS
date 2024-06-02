const express = require("express");
const router = express.Router();
const verifyToken = require("../middleware/checkToken");

const {
  register,
  login,
  searchWithPicture,
  getRecomendations,
  getSellerHome,
  getSuggest,
} = require("../controller/index.controller");
const upload = require("../utills/multer");

router.post("/api/register", register);
router.post("/api/login", login);
router.get("/api/home", verifyToken, getRecomendations);
router.get("/api/seller/:id", getSellerHome);
router.get("/api/suggest", getSuggest);
router.post("/api/searchWithImage", upload.single("img"), searchWithPicture);
module.exports = router;
