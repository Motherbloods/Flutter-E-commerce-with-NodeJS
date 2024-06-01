const mongoose = require("mongoose");
require("dotenv").config();
const url = process.env.URL;

(async () => {
  try {
    const db = await mongoose.connect(url);
    console.log("Connected to MongoDB");
  } catch (e) {
    console.error("Couldn't connect to MongoDB", e);
  }
})();
