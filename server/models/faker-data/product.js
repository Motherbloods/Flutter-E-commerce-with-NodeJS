const Products = require("../product");
const sellerIds = require("./dummy/sellerIds");

const generateRandomProduct = () => {
  return new Products({
    name: faker.commerce.productName(),
    sellerId: sellerIds[Math.floor(Math.random() * sellerIds.length)],
    price: faker.commerce.price(),
    category: [faker.commerce.department(), faker.commerce.department()],
    stockQuantity: faker.datatype.number(100),
    salesLastWeek: faker.datatype.number(100),
    totalUnitsSold: faker.datatype.number(100),
    imageUrl: faker.image.abstract(),
    diskon: faker.datatype.number({ min: 0, max: 50 }), // Menghasilkan diskon antara 0 dan 50 persen
    ulasan: faker.lorem.paragraph(), // Menghasilkan ulasan produk yang lebih realistis
    variants: [
      {
        name: faker.commerce.productName(),
        price: faker.commerce.price(),
        imageUrl: faker.image.abstract(),
      },
      {
        name: faker.commerce.productName(),
        price: faker.commerce.price(),
        imageUrl: faker.image.abstract(),
      },
    ],
  });
};

const createFakeProducts = async (num) => {
  await mongoose.connect(
    "mongodb+srv://motherbloodss:XKFofTN9qGntgqbo@cluster0.ejyrmvc.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0",
    {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    }
  );

  const products = [];
  for (let i = 0; i < num; i++) {
    products.push(await generateRandomProduct());
  }

  await Products.insertMany(products);
  console.log(`${num} fake products inserted successfully`);
  await mongoose.disconnect();
};

createFakeProducts(100);
