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

// const insertDummyData = async () => {
//   try {
//     // Hubungkan ke MongoDB
//     await mongoose.connect(
//       "mongodb+srv://motherbloodss:XKFofTN9qGntgqbo@cluster0.ejyrmvc.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0",
//       {
//         useNewUrlParser: true,
//         useUnifiedTopology: true,
//       }
//     );

//     const searchHistory = [];
//     const userId = [
//       "665ecd548f7e25ab2a017557",
//       "665ab559c8742d74b5cb6664",
//       "665ecd668f7e25ab2a01755a",
//     ];

//     for (let i = 0; i < 25; i++) {
//       searchHistory.push({
//         searchValue: faker.lorem.sentence(),
//         userId: userId[Math.floor(Math.random() * userId.length)],
//       });
//     }
//     await SearchHistory.insertMany(searchHistory);

//     console.log("Data dummy berhasil dimasukkan!");

//     // Tutup koneksi ke database
//     mongoose.connection.close();
//   } catch (error) {
//     console.error("Gagal memasukkan data dummy:", error);
//     mongoose.connection.close();
//   }
// };

// insertDummyData();
