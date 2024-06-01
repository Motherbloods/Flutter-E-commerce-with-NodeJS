const express = require("express");
const app = express();
const cors = require("cors");
const path = require("path");
require("dotenv").config();

const port = process.env.PORT;

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use("/images", express.static(path.join(__dirname, "images")));

require("./utills/db");
const routes = require("./route/index.route");
app.use(routes);

app.listen(port, () => {
  console.log("Listening on port " + port);
});
