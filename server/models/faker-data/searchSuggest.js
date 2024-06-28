const searchSuggest = require("../searchSugges");
const searchSuggest = require("./dummy/searchSuggest");

searchSuggest
  .insertMany(dummyData)
  .then(() => {
    console.log("Dummy data inserted successfully!");
    mongoose.connection.close();
  })
  .catch((error) => {
    console.error("Error inserting dummy data: ", error);
    mongoose.connection.close();
  });
