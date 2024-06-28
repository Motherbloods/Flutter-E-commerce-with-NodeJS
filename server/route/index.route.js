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
  updateUser,
  getProductSearch,
  get_user,
  registerSeller,
  loginSeller,
} = require("../controller/index.controller");
const upload = require("../utills/multer");

const {
  conversations,
  getConversations,
  getMessages,
  messages,
} = require("../controller/realtimechat.controller");
const getSnapToken = require("../controller/midtrans.controller");

router.post("/api/register", register);
router.post("/api/login", login);
router.get("/api/home", verifyToken, getRecomendations);
router.get("/api/search-products", getProductSearch);
router.get("/api/seller/:id", getSellerHome);
router.get("/api/suggest", getSuggest);
router.get("/api/user", get_user);
router.post("/api/searchWithImage", upload.single("img"), searchWithPicture);
router.post("/api/createTransaction", getSnapToken);
router.put("/api/update-profile", updateUser);

//chat
router.post("/api/conversation", conversations);
router.get("/api/conversation/:userId", getConversations);
router.post("/api/messages", messages);
router.get("/api/messages/:conversationId", getMessages);

//seller
router.post("/api/register/seller", registerSeller);
router.post("/api/login/seller", loginSeller);
module.exports = router;
