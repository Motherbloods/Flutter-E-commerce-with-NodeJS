const mongoose = require("mongoose");
const { faker } = require("@faker-js/faker"); // Menggunakan @faker-js/faker

const variantSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  price: {
    type: Number,
    required: true,
  },
  imageUrl: {
    type: String,
  },
});

const productsSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  sellerId: {
    type: String,
    ref: "Sellers",
  },
  price: {
    type: Number,
    required: true,
  },
  category: {
    type: [String], // Array of strings
    required: false,
  },
  stockQuantity: {
    type: Number,
    required: true,
  },
  salesLastWeek: {
    type: Number,
  },
  totalUnitsSold: {
    type: Number,
    required: true,
    default: 0,
  },
  imageUrl: {
    type: String,
  },
  diskon: {
    type: Number,
    required: false,
  },
  ulasan: {
    type: String,
    ref: "Review",
  },
  variants: [variantSchema], // Array of variant subdocuments
});

const Products = mongoose.model("Product", productsSchema);
module.exports = Products;
