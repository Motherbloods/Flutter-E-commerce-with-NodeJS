const mongoose = require("mongoose");

const sellerSchema = new mongoose.Schema({
  namaToko: {
    type: String,
    required: true,
  },
  email: {
    type: String,
    required: true,
  },
  noHP: {
    type: Number,
    required: true,
  },
  kategoriPenjualanBrg: {
    type: Array,
    required: true,
    default: [],
  },
  alamatToko: {
    type: String,
    required: true,
  },
  totalProductSalesLastWeek: {
    type: Number,
  },
});

const Sellers = mongoose.model("Sellers", sellerSchema);

module.exports = Sellers;

// const dummySellers = [
//   {
//     namaToko: "Toko Sinar Jaya",
//     email: "sinarjaya@example.com",
//     noHP: 81234567890,
//     kategoriPenjualanBrg: ["Elektronik", "Gadget"],
//     alamatToko: "Jl. Mawar No. 10, Jakarta",
//   },
//   {
//     namaToko: "Toko Sejahtera",
//     email: "sejahtera@example.com",
//     noHP: 81345678901,
//     kategoriPenjualanBrg: ["Pakaian", "Aksesoris"],
//     alamatToko: "Jl. Melati No. 20, Bandung",
//   },
//   {
//     namaToko: "Toko Makmur",
//     email: "makmur@example.com",
//     noHP: 81456789012,
//     kategoriPenjualanBrg: ["Buku", "Alat Tulis"],
//     alamatToko: "Jl. Anggrek No. 30, Surabaya",
//   },
//   {
//     namaToko: "Toko Harmoni",
//     email: "harmoni@example.com",
//     noHP: 81567890123,
//     kategoriPenjualanBrg: ["Makanan", "Minuman"],
//     alamatToko: "Jl. Kenanga No. 40, Medan",
//   },
//   {
//     namaToko: "Toko Nusantara",
//     email: "nusantara@example.com",
//     noHP: 81678901234,
//     kategoriPenjualanBrg: ["Perabotan Rumah", "Dekorasi"],
//     alamatToko: "Jl. Kamboja No. 50, Semarang",
//   },
//   {
//     namaToko: "Toko Sentosa",
//     email: "sentosa@example.com",
//     noHP: 81789012345,
//     kategoriPenjualanBrg: ["Kosmetik", "Perawatan Kulit"],
//     alamatToko: "Jl. Dahlia No. 60, Yogyakarta",
//   },
//   {
//     namaToko: "Toko Bahagia",
//     email: "bahagia@example.com",
//     noHP: 81890123456,
//     kategoriPenjualanBrg: ["Mainan", "Alat Olahraga"],
//     alamatToko: "Jl. Teratai No. 70, Malang",
//   },
//   {
//     namaToko: "Toko Maju",
//     email: "maju@example.com",
//     noHP: 81901234567,
//     kategoriPenjualanBrg: ["Alat Musik", "CD Musik"],
//     alamatToko: "Jl. Lily No. 80, Bali",
//   },
//   {
//     namaToko: "Toko Sukses",
//     email: "sukses@example.com",
//     noHP: 81112345678,
//     kategoriPenjualanBrg: ["Obat-obatan", "Suplemen"],
//     alamatToko: "Jl. Tulip No. 90, Makassar",
//   },
//   {
//     namaToko: "Toko Lancar",
//     email: "lancar@example.com",
//     noHP: 81123456789,
//     kategoriPenjualanBrg: ["Komputer", "Aksesoris Komputer"],
//     alamatToko: "Jl. Flamboyan No. 100, Balikpapan",
//   },
// ];

// // Fungsi utama untuk menjalankan skrip
// const insertDummyData = async () => {
//   try {
//     // Hubungkan ke MongoDB
//     await mongoose.connect("mongodb://localhost:27017/e-commerce-IRi", {
//       useNewUrlParser: true,
//       useUnifiedTopology: true,
//     });

//     // Masukkan data dummy ke tabel Sellers
//     await Sellers.insertMany(dummySellers);

//     console.log("Data dummy berhasil dimasukkan!");

//     // Tutup koneksi ke database
//     mongoose.connection.close();
//   } catch (error) {
//     console.error("Gagal memasukkan data dummy:", error);
//     mongoose.connection.close();
//   }
// };

// // Jalankan fungsi untuk memasukkan data
// insertDummyData();
