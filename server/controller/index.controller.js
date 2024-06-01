const Products = require("../models/product");
const Users = require("../models/user");
const Sellers = require("../models/seller");

require("dotenv").config();

const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");
const redis = require("redis");
const redisClient = redis.createClient();

const register = async (req, res) => {
  try {
    const { email, password, confirmPassword } = req.body;
    if (!email || !password || !confirmPassword) {
      return res.status(400).send("Please fill all required fields");
    }
    if (password !== confirmPassword) {
      return res.status(400).send("Password and confirm password must match");
    }

    const alreadyUser = await Users.findOne({ email });
    if (alreadyUser) {
      return res.status(409).send("User already exists, please login");
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const newUser = new Users({
      email,
      password: hashedPassword,
    });

    await newUser.save();
    return res
      .status(201)
      .send({ success: true, message: "User created successfully" });
  } catch (err) {
    console.error(err);
    return res.status(500).send("Internal Server Error");
  }
};

const login = async (req, res) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) {
      return res.status(400).send("Please fill all required fields");
    }

    const user = await Users.findOne({ email });
    if (!user) {
      // Use the same error message to avoid timing attacks
      return res.status(400).send("Email or password is incorrect");
    }

    const validateUser = await bcrypt.compare(password, user.password);
    if (!validateUser) {
      // Use the same error message to avoid timing attacks
      return res.status(400).send("Email or password is incorrect");
    }

    const secretToken = process.env.SECRET_TOKEN || "sfdkjdsakjsfdjkjadsfjk";
    const token = jwt.sign(
      {
        _id: user._id,
        email: user.email,
        recomendations: user.recomendations,
        username: user.username,
      },
      secretToken,
      {
        expiresIn: "1d",
      }
    );

    // Update user's token and save
    user.token = token;
    await user.save();

    return res.status(200).send({ success: true, token });
  } catch (err) {
    console.error("ini error", err);
    return res.status(500).send("Internal Server Error");
  }
};
const getRecomendations = async (req, res) => {
  try {
    const { id, email, recomendations } = req.user;
    console.log("Recomendations", req.user, recomendations);
    const totalProductsCount = await Products.countDocuments();

    if (!recomendations || recomendations.length === 0) {
      let additionalProducts = await Products.find()
        .sort({ salesLastWeek: -1 })
        .limit(totalProductsCount);
      const sellerIdsAdditionalIds = additionalProducts.map(
        (product) => product.sellerId
      );
      const sellersAdditional = await Sellers.find({
        _id: { $in: sellerIdsAdditionalIds },
      });
      const productAdditionalWithSellerName = additionalProducts.map(
        (product) => {
          const seller = sellersAdditional.find((seller) => {
            return seller._id.toString() === product.sellerId.toString();
          });
          return {
            ...product.toObject(),
            sellerName: seller ? seller.namaToko : "Unknown",
          };
        }
      );
      return res.status(200).json(productAdditionalWithSellerName);
    }
    console.log("haloo");
    let additionalProducts = await Products.find()
      .sort({ salesLastWeek: -1 })
      .limit(totalProductsCount);

    const products = await Products.find({
      category: { $in: recomendations },
    });
    const sellerIds = products.map((product) => product.sellerId);
    const sellers = await Sellers.find({ _id: { $in: sellerIds } });
    const sellerIdsAdditionalIds = additionalProducts.map(
      (product) => product.sellerId
    );
    const sellersAdditional = await Sellers.find({
      _id: { $in: sellerIdsAdditionalIds },
    });

    // Filter additional products that are already in the recommended products
    additionalProducts = additionalProducts.filter((additionalProduct) => {
      // Return true if additionalProduct is not in products
      return !products.some(
        (product) => product._id.toString() === additionalProduct._id.toString()
      );
    });

    const productAdditionalWithSellerName = additionalProducts.map(
      (product) => {
        const seller = sellersAdditional.find((seller) => {
          return seller._id.toString() === product.sellerId.toString();
        });
        return {
          ...product.toObject(),
          sellerName: seller ? seller.namaToko : "Unknown",
        };
      }
    );

    const productsWithSellerName = products.map((product) => {
      const seller = sellers.find(
        (seller) => seller._id.toString() === product.sellerId.toString()
      );

      return {
        ...product.toObject(),
        sellerName: seller ? seller.namaToko : "Unknown Seller",
      };
    });

    // Combine additional products with recommended products if the number of recomendations is less than 5

    // Combine additional products into the products list
    const allProducts = [
      ...productsWithSellerName,
      ...productAdditionalWithSellerName,
    ];
    console.log(";;shdfs");
    console.log(allProducts);
    if (products.length === 0) {
      return res
        .status(404)
        .json({ message: "No products found for the given recomendations." });
    }

    return res.status(200).json(allProducts);
  } catch (err) {
    console.error(err);
    return res.status(500).json({ message: "Internal server error." });
  }
};

const getDetailProduk = async (req, res) => {
  try {
    const id = req.params.id;
    const cacheKey = `product:${id}`;

    redisClient.get(cacheKey, async (err, cachedData) => {
      if (err) throw err;

      if (cachedData) {
        const { product, nameOfSeller } = JSON.parse(cachedData);
        return res.status(200).send({ data: { product, nameOfSeller } });
      }

      const product = await Products.findById(id);
      if (!product) {
        return res.status(404).send("Product not found");
      }

      const nameOfSeller = await Sellers.findById(product.sellerId);

      if (!nameOfSeller) {
        throw err;
      }
      const data = { product, nameOfSeller: nameOfSeller.namaToko };
      redisClient.set(cacheKey, JSON.stringify(data));
      res.status(200).send({ data });
    });
  } catch (err) {
    console.error("Error in getDetailProduk:", err);
    res.status(500).send("Internal Server Error");
  }
};

const getSellerHome = async (req, res) => {
  try {
    const id = req.params.id;

    const seller = await Sellers.findById(id);
    if (!seller) {
      return res.status(404).send("seller not found");
    }

    const product = await Products.findMany({ sellerId: seller._id });
    if (!product) {
      return res.status(404).send("Product not found");
    }

    res.status(200).send({ data: { seller, product } });
  } catch (err) {
    console.error("Error in getSellerHome:", err);
    res.status(500).send("Internal Server Error");
  }
};

const updateProfile = async (req, res) => {
  try {
    const { fullName, alamat, username, recomendations } = req.body;
    const { _id } = req.user;

    const user = await Users.findById(_id);
    if (!user) {
      return res.status(404).send("user not found");
    }

    user.fullname = fullName;
    user.alamat = alamat;
    user.username = username;
    user.recomendations = recomendations;
    await user.save();

    res.status(200).send("Profile updated successfully");
  } catch (err) {
    console.error("Error in updateProfile:", err);
    res.status(500).send("Internal Server Error");
  }
};

const searchWithPicture = async (req, res) => {
  const img = req.file;
};

const checkOut = async (req, res) => {
  try {
    const { idBarang } = req.body;

    // Membuat array promise untuk mengambil detail produk dan harga
    const promises = idBarang.map(async (brg) => {
      const product = await Products.findById(brg.id);
      if (!product) {
        throw new Error(`Product with ID ${brg.id} not found`);
      }
      const harga = product.price * brg.jmlbrg;
      return { product, harga };
    });

    // Menunggu semua promise selesai dieksekusi
    const results = await Promise.all(promises);

    // Mengembalikan hasil ke klien
    res.status(200).json(results);
  } catch (error) {
    console.error("Error in checkOut:", error);
    res.status(500).json({ message: "Internal Server Error" });
  }
};

const pembayaran = async (req, res) => {};

module.exports = {
  register,
  login,
  getRecomendations,
  updateProfile,
  getDetailProduk,
  getSellerHome,
  searchWithPicture,
};
