const mongoose = require("mongoose");
const { faker } = require("@faker-js/faker");
const searchSchema = new mongoose.Schema({
  searchValue: {
    type: String,
  },
  userId: {
    type: String,
    ref: "User",
  },
  date: {
    type: Date,
    default: Date.now,
  },
});
const SearchHistory = mongoose.model("Search", searchSchema);

module.exports = SearchHistory;
