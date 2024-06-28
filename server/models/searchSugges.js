const mongoose = require("mongoose");

const searchSuggestSchema = new mongoose.Schema({
  suggest: {
    type: String,
  },
  jmlDicari: {
    type: Number,
  },
});

const searchSuggest = mongoose.model("searchSuggest", searchSuggestSchema);

module.exports = searchSuggest;
