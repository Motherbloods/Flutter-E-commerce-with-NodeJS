const mongoose = require("mongoose");

const cartSchema = new mongoose.Schema({
  idBarang: {
    type: String,
    ref: "Products",
  },
  totalHarga: {
    type: Number,
  },
  jmlBrg: {
    type: Number,
  },
  addDate: {
    type: Date,
    default: Date.now,
  },
  status: {
    type: String,
  },
});

const Cart = mongoose.model("Cart", cartSchema);

module.exports = Cart;
