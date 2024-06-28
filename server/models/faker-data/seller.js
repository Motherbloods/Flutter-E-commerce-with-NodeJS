const Sellers = require("../seller");
const indonesianKecamatan = require("./dummy/alamat");

function getRandomArrayElement(arr) {
  return arr[Math.floor(Math.random() * arr.length)];
}

for (let i = 0; i < 10; i++) {
  const namaToko = faker.company.name();
  const email = faker.internet.email();
  const noHP = faker.phone.number("08##########");
  const kategoriPenjualanBrg = faker.helpers
    .shuffle([
      "Elektronik",
      "Pakaian",
      "Makanan",
      "Olahraga",
      "Kecantikan",
      "Hobi",
    ])
    .slice(0, faker.datatype.number({ min: 1, max: 4 }));
  const alamatToko = `${getRandomArrayElement(indonesianKecamatan).alamat}, ${
    getRandomArrayElement(indonesianKecamatan).desa
  }, ${getRandomArrayElement(indonesianKecamatan).kecamatan}, ${
    getRandomArrayElement(indonesianKecamatan).kabupaten
  }, ${getRandomArrayElement(indonesianKecamatan).provinsi}`;
  const totalProductSalesLastWeek = faker.datatype.number({
    min: 0,
    max: 1000,
  });

  const newSeller = {
    namaToko,
    email,
    noHP,
    kategoriPenjualanBrg,
    alamatToko,
    totalProductSalesLastWeek,
  };

  dummySellers.push(newSeller);
}

// Connect to MongoDB (replace 'mongodb://localhost:27017/yourdbname' with your actual connection string)
mongoose
  .connect(
    "mongodb+srv://motherbloodss:XKFofTN9qGntgqbo@cluster0.ejyrmvc.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0",
    {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    }
  )
  .then(async () => {
    console.log("Connected to MongoDB");
    await Sellers.insertMany(dummySellers);

    console.log("Dummy seller created:", dummySellers);

    mongoose.disconnect();
  })
  .catch((err) => {
    console.error("Error connecting to MongoDB", err);
  });
