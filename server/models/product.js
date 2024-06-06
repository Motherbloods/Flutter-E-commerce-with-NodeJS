const mongoose = require("mongoose");

const productsSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  sellerId: {
    type: String,
    ref: "Sellers",
  },
  price: {
    type: Number,
    required: true,
  },
  category: {
    type: Array,
    required: false,
  },
  stockQuantity: {
    type: Number,
    required: true,
  },
  salesLastWeek: {
    type: Number,
  },
  totalUnitsSold: {
    type: Number,
    required: true,
    default: 0,
  },
  imageUrl: {
    type: String,
  },
  diskon: {
    type: Number,
    required: false,
  },
  ulasan: {
    type: String,
    ref: "Review",
  },
});

const Products = mongoose.model("Products", productsSchema);

module.exports = Products;

const dummyProducts = [
  {
    name: "Smartphone XYZ",
    sellerId: "664f234c16815f5648a5a125",
    price: 3500000,
    category: ["Elektronik", "Gadget"],
    stockQuantity: 100,
    salesLastWeek: 20,
    totalUnitsSold: 30,
    imageUrl: "/images/1.jpg",
  },
  {
    name: "T-Shirt Basic",
    sellerId: "664f234c16815f5648a5a125",
    price: 75000,
    category: ["Pakaian"],
    stockQuantity: 200,
    salesLastWeek: 40,
    totalUnitsSold: 50,
    imageUrl: "/images/cropped-2.jpg",
  },
  {
    name: "Novel Best Seller",
    sellerId: "664f234c16815f5648a5a125",
    price: 95000,
    category: ["Buku"],
    stockQuantity: 150,
    salesLastWeek: 25,
    totalUnitsSold: 20,
    imageUrl: "/images/cropped-3.jpg",
  },
  {
    name: "Snack Box",
    sellerId: "664f234c16815f5648a5a125",
    price: 50000,
    category: ["Makanan"],
    stockQuantity: 300,
    salesLastWeek: 29,
    totalUnitsSold: 100,
    imageUrl: "/images/cropped-4.jpg",
  },
  {
    name: "Sofa Minimalis",
    sellerId: "664f234c16815f5648a5a125",
    price: 4500000,
    category: ["Perabotan Rumah"],
    stockQuantity: 20,
    salesLastWeek: 89,
    totalUnitsSold: 5,
    imageUrl: "/images/cropped-5.jpg",
  },
  {
    name: "Lipstick Matte",
    sellerId: "664f234c16815f5648a5a125",
    price: 120000,
    category: ["Kosmetik"],
    stockQuantity: 100,
    salesLastWeek: 78,
    totalUnitsSold: 40,
    imageUrl: "/images/cropped-6.jpg",
  },
  {
    name: "Basketball",
    sellerId: "664f24a2c7435b6e5b734315",
    price: 250000,
    category: ["Alat Olahraga"],
    stockQuantity: 80,
    salesLastWeek: 67,
    totalUnitsSold: 30,
    imageUrl: "/images/cropped-7.jpg",
  },
  {
    name: "Electric Guitar",
    sellerId: "664f24a2c7435b6e5b734316",
    price: 3500000,
    category: ["Alat Musik"],
    stockQuantity: 50,
    salesLastWeek: 56,
    totalUnitsSold: 10,
    imageUrl: "/images/cropped-8.jpg",
  },
  {
    name: "Vitamin C",
    sellerId: "664f24a2c7435b6e5b734317",
    price: 150000,
    category: ["Obat-obatan"],
    stockQuantity: 200,
    salesLastWeek: 45,
    totalUnitsSold: 70,
    imageUrl: "/images/cropped-9.jpg",
  },
  {
    name: "Gaming Mouse",
    sellerId: "664f234c16815f5648a5a12a",
    price: 450000,
    category: ["Komputer"],
    stockQuantity: 100,
    salesLastWeek: 35,
    totalUnitsSold: 60,
    imageUrl: "/images/cropped-10.jpg",
  },
  {
    name: "Smartphone XYZ",
    sellerId: "664f234c16815f5648a5a12b",
    price: 3500000,
    category: ["Elektronik", "Gadget", "Teknologi"],
    stockQuantity: 100,
    salesLastWeek: 9,
    totalUnitsSold: 30,
    imageUrl: "/images/cropped-11.jpg",
  },
  {
    name: "T-Shirt Basic",
    sellerId: "664f24a2c7435b6e5b734318",
    price: 75000,
    category: ["Pakaian", "Fashion", "Kasual"],
    stockQuantity: 200,
    salesLastWeek: 8,
    totalUnitsSold: 50,
    imageUrl: "/images/12.jpg",
  },
  {
    name: "Novel Best Seller",
    sellerId: "664f24a2c7435b6e5b734316",
    price: 95000,
    category: ["Buku", "Sastra", "Fiksi"],
    stockQuantity: 150,
    salesLastWeek: 66,
    totalUnitsSold: 20,
    imageUrl: "/images/cropped-4.jpg",
  },
  {
    name: "Snack Box",
    sellerId: "664f24a2c7435b6e5b734315",
    price: 50000,
    category: ["Makanan", "Camilan", "Kue"],
    stockQuantity: 300,
    salesLastWeek: 120,
    totalUnitsSold: 100,
    imageUrl: "/images/cropped-.jpg",
  },
  {
    name: "Sofa Minimalis",
    sellerId: "664f24a2c7435b6e5b734312",
    price: 4500000,
    category: ["Perabotan Rumah", "Dekorasi", "Furnitur"],
    stockQuantity: 20,
    salesLastWeek: 80,
    totalUnitsSold: 5,
    imageUrl: "/images/cropped-.jpg",
  },
  {
    name: "Lipstick Matte",
    sellerId: "664f24a2c7435b6e5b734314",
    price: 120000,
    category: ["Kosmetik", "Makeup", "Perawatan Kulit"],
    stockQuantity: 100,
    salesLastWeek: 28,
    totalUnitsSold: 40,
    imageUrl: "/images/cropped-.jpg",
  },
  {
    name: "Basketball",
    sellerId: "664f24a2c7435b6e5b734315",
    price: 250000,
    category: ["Alat Olahraga", "Olahraga", "Mainan"],
    stockQuantity: 80,
    salesLastWeek: 78,
    totalUnitsSold: 30,
    imageUrl: "/images/cropped-.jpg",
  },
  {
    name: "Electric Guitar",
    sellerId: "664f24a2c7435b6e5b734316",
    price: 3500000,
    category: ["Alat Musik", "Instrumen", "Musik"],
    stockQuantity: 50,
    salesLastWeek: 100,
    totalUnitsSold: 10,
    imageUrl: "/images/cropped-4.jpg",
  },
  {
    name: "Vitamin C",
    sellerId: "664f24a2c7435b6e5b734317",
    price: 150000,
    category: ["Obat-obatan", "Suplemen", "Kesehatan"],
    stockQuantity: 200,
    salesLastWeek: 78,
    totalUnitsSold: 70,
    imageUrl: "/images/cropped-2.jpg",
  },
  {
    name: "Gaming Mouse",
    sellerId: "664f234c16815f5648a5a12a",
    price: 450000,
    category: ["Komputer", "Aksesoris", "Gaming"],
    stockQuantity: 100,
    salesLastWeek: 89,
    totalUnitsSold: 60,
    imageUrl: "/images/cropped-3.jpg",
  },
  {
    name: "Bluetooth Headphones",
    sellerId: "664f234c16815f5648a5a12b",
    price: 750000,
    category: ["Elektronik", "Gadget", "Audio"],
    stockQuantity: 120,
    salesLastWeek: 89,
    totalUnitsSold: 50,
    imageUrl: "/images/cropped-5.jpg",
  },
  {
    name: "Running Shoes",
    sellerId: "664f24a2c7435b6e5b734318",
    price: 500000,
    category: ["Pakaian", "Olahraga", "Sepatu"],
    stockQuantity: 150,
    salesLastWeek: 89,
    totalUnitsSold: 60,
    imageUrl: "/images/cropped-6.jpg",
  },
  {
    name: "Organic Green Tea",
    sellerId: "664f24a2c7435b6e5b734316",
    price: 80000,
    category: ["Makanan", "Minuman", "Sehat"],
    stockQuantity: 200,
    salesLastWeek: 89,
    totalUnitsSold: 70,
    imageUrl: "/images/cropped-4.jpg",
  },
  {
    name: "LED Desk Lamp",
    sellerId: "664f24a2c7435b6e5b734315",
    price: 150000,
    category: ["Perabotan Rumah", "Dekorasi", "Lampu"],
    stockQuantity: 80,
    salesLastWeek: 89,
    totalUnitsSold: 30,
    imageUrl: "/images/cropped-7.jpg",
  },
  {
    name: "Face Serum",
    sellerId: "664f24a2c7435b6e5b734314",
    price: 200000,
    category: ["Kosmetik", "Perawatan Kulit", "Kecantikan"],
    stockQuantity: 100,
    salesLastWeek: 67,
    totalUnitsSold: 45,
    imageUrl: "/images/cropped-8.jpg",
  },
  {
    name: "Yoga Mat",
    sellerId: "664f24a2c7435b6e5b734315",
    price: 250000,
    category: ["Alat Olahraga", "Olahraga", "Kesehatan"],
    stockQuantity: 90,
    salesLastWeek: 67,
    totalUnitsSold: 40,
    imageUrl: "/images/cropped-9.jpg",
  },
  {
    name: "Digital Piano",
    sellerId: "664f24a2c7435b6e5b734316",
    price: 5000000,
    category: ["Alat Musik", "Elektronik", "Piano"],
    stockQuantity: 25,
    salesLastWeek: 67,
    totalUnitsSold: 5,
    imageUrl: "/images/cropped-10.jpg",
  },
  {
    name: "Fish Oil Supplement",
    sellerId: "664f24a2c7435b6e5b734317",
    price: 180000,
    category: ["Obat-obatan", "Suplemen", "Kesehatan"],
    stockQuantity: 200,
    salesLastWeek: 67,
    totalUnitsSold: 75,
    imageUrl: "/images/cropped-11.jpg",
  },
  {
    name: "Wireless Keyboard",
    sellerId: "664f234c16815f5648a5a12a",
    price: 300000,
    category: ["Komputer", "Aksesoris", "Teknologi"],
    stockQuantity: 100,
    salesLastWeek: 67,
    totalUnitsSold: 55,
    imageUrl: "/images/cropped-1.jpg",
  },
  {
    name: "Graphic Tablet",
    sellerId: "664f234c16815f5648a5a12b",
    price: 1200000,
    category: ["Elektronik", "Gadget", "Desain"],
    stockQuantity: 60,
    salesLastWeek: 67,
    totalUnitsSold: 20,
    imageUrl: "/images/1.jpg",
  },
  {
    name: "Portable Blender",
    sellerId: "664f24a2c7435b6e5b734318",
    price: 200000,
    category: ["Elektronik", "Dapur", "Alat Makan"],
    stockQuantity: 80,
    salesLastWeek: 67,
    totalUnitsSold: 25,
    imageUrl: "/images/12.jpg",
  },
  {
    name: "Cotton Tote Bag",
    sellerId: "664f24a2c7435b6e5b734316",
    price: 50000,
    category: ["Pakaian", "Aksesoris", "Eco-Friendly"],
    stockQuantity: 150,
    salesLastWeek: 67,
    totalUnitsSold: 70,
    imageUrl: "/images/cropped-3.jpg",
  },
  {
    name: "Instant Noodle",
    sellerId: "664f24a2c7435b6e5b734315",
    price: 10000,
    category: ["Makanan", "Camilan", "Instan"],
    stockQuantity: 300,
    salesLastWeek: 56,
    totalUnitsSold: 120,
    imageUrl: "/images/cropped-2.jpg",
  },
  {
    name: "Wooden Desk Organizer",
    sellerId: "664f24a2c7435b6e5b734314",
    price: 80000,
    category: ["Perabotan Rumah", "Dekorasi", "Kantor"],
    stockQuantity: 100,
    salesLastWeek: 56,
    totalUnitsSold: 40,
    imageUrl: "/images/cropped-6.jpg",
  },
  {
    name: "Eyeshadow Palette",
    sellerId: "664f24a2c7435b6e5b734315",
    price: 150000,
    category: ["Kosmetik", "Makeup", "Wajah"],
    stockQuantity: 120,
    salesLastWeek: 56,
    totalUnitsSold: 60,
    imageUrl: "/images/cropped-9.jpg",
  },
  {
    name: "Yoga Block",
    sellerId: "664f24a2c7435b6e5b734316",
    price: 75000,
    category: ["Alat Olahraga", "Olahraga", "Yoga"],
    stockQuantity: 70,
    salesLastWeek: 56,
    totalUnitsSold: 20,
    imageUrl: "/images/cropped-10.jpg",
  },
  {
    name: "Acoustic Guitar",
    sellerId: "664f24a2c7435b6e5b734317",
    price: 2000000,
    category: ["Alat Musik", "Instrumen", "Musik"],
    stockQuantity: 40,
    salesLastWeek: 56,
    totalUnitsSold: 10,
    imageUrl: "/images/cropped-3.jpg",
  },
  {
    name: "Allergy Medicine",
    sellerId: "664f234c16815f5648a5a12a",
    price: 50000,
    category: ["Obat-obatan", "Resep", "Kesehatan"],
    stockQuantity: 200,
    salesLastWeek: 67,
    totalUnitsSold: 80,
    imageUrl: "/images/cropped-8.jpg",
  },
  {
    name: "External Hard Drive",
    sellerId: "664f234c16815f5648a5a12b",
    price: 800000,
    category: ["Komputer", "Aksesoris", "Penyimpanan"],
    stockQuantity: 60,
    salesLastWeek: 67,
    totalUnitsSold: 30,
    imageUrl: "/images/cropped-9.jpg",
  },
  {
    name: "Watercolor Paint Set",
    sellerId: "609bda581c4ae30f1c8e4d3c",
    price: 150000,
    category: ["Seni", "Lukisan", "Cat Air"],
    stockQuantity: 80,
    salesLastWeek: 67,
    totalUnitsSold: 25,
    imageUrl: "/images/cropped-5.jpg",
  },
];

// Fungsi utama untuk menjalankan skrip
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
//     await Products.insertMany(dummyProducts);

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
