const mongoose = require("mongoose");

const searchSchema = new mongoose.Schema({
  searchValue: {
    type: String,
  },
  userId: {
    type: String,
    ref: "User",
  },
});
const SearchHistory = mongoose.model("Search", searchSchema);

module.exports = SearchHistory;
