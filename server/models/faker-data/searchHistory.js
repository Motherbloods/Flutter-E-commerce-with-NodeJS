const SearchHistory = require("../searchhistory");
const userId = require("./dummy/userIds");

const insertDummyData = async () => {
  try {
    // Hubungkan ke MongoDB
    await mongoose.connect(
      "mongodb+srv://motherbloodss:XKFofTN9qGntgqbo@cluster0.ejyrmvc.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0",
      {
        useNewUrlParser: true,
        useUnifiedTopology: true,
      }
    );

    const searchHistory = [];

    for (let i = 0; i < 25; i++) {
      searchHistory.push({
        searchValue: faker.lorem.sentence(),
        userId: userId[Math.floor(Math.random() * userId.length)],
      });
    }
    await SearchHistory.insertMany(searchHistory);

    console.log("Data dummy berhasil dimasukkan!");

    // Tutup koneksi ke database
    mongoose.connection.close();
  } catch (error) {
    console.error("Gagal memasukkan data dummy:", error);
    mongoose.connection.close();
  }
};

insertDummyData();
