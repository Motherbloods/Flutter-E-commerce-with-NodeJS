const mongoose = require("mongoose");

const userSchema = new mongoose.Schema({
  email: {
    type: String,
    required: true,
  },
  password: {
    type: String,
    required: true,
  },
  alamat: {
    type: String,
    required: false,
    default: "",
  },
  fullname: {
    type: String,
  },
  username: {
    type: String,
  },
  recomendations: {
    type: Array,
    required: false,
    default: [],
  },
  token: {
    type: String,
  },
  img: {
    type: String,
    default: "",
  },
});

const Users = mongoose.model("Users", userSchema);

module.exports = Users;
