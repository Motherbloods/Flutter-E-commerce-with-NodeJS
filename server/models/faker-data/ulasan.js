const userIds = require("./dummy/userIds");
const productIds = require("./dummy/productIds");
const Review = require("../ulasan");
const { faker } = require("@faker-js/faker");
const mongoose = require("mongoose");

const generateUlasanProduct = () => {
  return new Review({
    userId: userIds[Math.floor(Math.random() * userIds.length)],
    productId: productIds[Math.floor(Math.random() * productIds.length)],
    review: faker.lorem.paragraph(),
    picture: [
      faker.image.abstract(),
      faker.image.abstract(),
      faker.image.abstract(),
    ],
  });
};

const createFakeUlasan = async (num) => {
  await mongoose.connect(
    "mongodb+srv://motherbloodss:XKFofTN9qGntgqbo@cluster0.ejyrmvc.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0",
    {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    }
  );

  const ulasan = [];
  for (let i = 0; i < num; i++) {
    ulasan.push(await generateUlasanProduct());
  }

  await Review.insertMany(ulasan);
  console.log(`${num} fake ulasan inserted successfully`);
  await mongoose.disconnect();
};

createFakeUlasan(100);
