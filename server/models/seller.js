const mongoose = require("mongoose");
const { faker } = require("@faker-js/faker"); // Menggunakan @faker-js/faker

const sellerSchema = new mongoose.Schema({
  namaToko: {
    type: String,
    required: true,
  },
  img: {
    type: String,
    required: false,
  },
  email: {
    type: String,
    required: true,
  },
  password: {
    type: String,
    required: true,
  },
  noHP: {
    type: Number,
    required: false,
  },
  kategoriPenjualanBrg: {
    type: Array,
    required: false,
    default: [],
  },
  alamatToko: {
    type: String,
    required: false,
  },
  totalProductSalesLastWeek: {
    type: Number,
  },
});

const Sellers = mongoose.model("Sellers", sellerSchema);

module.exports = Sellers;

const dummySellers = [];
