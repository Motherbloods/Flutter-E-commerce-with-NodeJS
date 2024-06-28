const mongoose = require("mongoose");

const conversationSchema = new mongoose.Schema({
  members: {
    type: [mongoose.Schema.Types.ObjectId],
    required: true,
    ref: "User",
  },
  type: {
    type: String,
    enum: ["individual", "group"],
    default: "individual",
    required: true,
  },
  img: {
    type: String,
    default: "uploads\\defaultgrub.jpeg", // Nilai default (kosong) jika tidak ada gambar
  },
  name: {
    type: String,
    required: function () {
      return this.type === "group";
    },
  },
  description: { type: String, default: "" },
  createdAt: {
    type: Date,
    default: Date.now,
  },
  admin: {
    type: mongoose.Schema.Types.ObjectId,
    required: function () {
      return this.type === "group";
    },
    ref: "User",
  },
});

const Conversations = mongoose.model("Conversations", conversationSchema);

module.exports = Conversations;
