const mongoose = require("mongoose");

const reviewSchema = new mongoose.Schema({
  userId: {
    type: String,
    required: true,
    ref: "User",
  },
  productId: {
    type: String,
    required: true,
    ref: "Product",
  },
  review: {
    type: String,
    required: true,
  },
  picture: {
    type: Array,
    default: [],
  },
  date: {
    type: Date,
    default: Date.now,
  },
});

const Review = mongoose.model("Review", reviewSchema);

module.exports = Review;

const dummyProducts = [
  {
    userId: "665ab559c8742d74b5cb6664",
    productId: "665aaa727e89a1119dece148",
    review: "biasa aja ternaytaa",
    picture: [
      "/images/cropped-3.jpg",
      "/images/cropped-5",
      "/images/cropped-7",
    ],
  },
  {
    userId: "665ab559c8742d74b5cb6664",
    productId: "665aaa727e89a1119dece148",
    review: "biasa aja ternaytaa",
    picture: "/images/cropped-3.jpg",
  },
  {
    userId: "665ab559c8742d74b5cb6664",
    productId: "665aaa727e89a1119dece148",
    review: "biasa aja ternaytaa",
    picture: "/images/cropped-3.jpg",
  },
  {
    userId: "665ab559c8742d74b5cb6664",
    productId: "665aaa727e89a1119dece148",
    review: "biasa aja ternaytaa",
    picture: [
      "/images/cropped-3.jpg",
      "/images/cropped-9",
      "/images/cropped-6",
    ],
  },
  {
    userId: "665ab559c8742d74b5cb6664",
    productId: "665aaa727e89a1119dece148",
    review: "biasa aja ternaytaa",
    picture: "/images/cropped-3.jpg",
  },
  {
    userId: "665ab559c8742d74b5cb6664",
    productId: "665aaa727e89a1119dece148",
    review: "biasa aja ternaytaa",
    picture: "/images/cropped-3.jpg",
  },
];

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

//     // Masukkan data dummy ke tabel Sellers
//     await Review.insertMany(dummyProducts);

//     console.log("Data dummy berhasil dimasukkan!");

//     // Tutup koneksi ke database
//     mongoose.connection.close();
//   } catch (error) {
//     console.error("Gagal memasukkan data dummy:", error);
//     mongoose.connection.close();
//   }
// };

// insertDummyData();
