const app = require("./utills/config");
const port = process.env.PORT || 8000;
const http = require("http");
const configureSocket = require("./utills/socketConfig");

require("./utills/db");
const routes = require("./route/index.route");
app.use(routes);

const server = http.createServer(app);
const io = configureSocket(server);

// Make io accessible to our router
app.set("io", io);

server.listen(8080, () => {
  console.log("Server and Socket.IO listening on port " + 8080);
});

app.listen(port, () => {
  console.log("Listening on port " + port);
});
