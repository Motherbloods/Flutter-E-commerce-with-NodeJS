const Products = require("../models/product");
const Users = require("../models/user");
const Sellers = require("../models/seller");
const SearchHistory = require("../models/searchhistory");
const Review = require("../models/ulasan");

require("dotenv").config();

const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");
const redis = require("redis");
const searchSuggest = require("../models/searchSugges");
const client = redis.createClient();
// Tambahkan event listener untuk menangani error koneksi Redis
// client.on("error", (err) => {
//   console.error("Redis error:", err);
// });

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

    return res.status(200).send({ success: true, token, id: user._id });
  } catch (err) {
    console.error("ini error", err);
    return res.status(500).send("Internal Server Error");
  }
};

const getRecomendations = async (req, res) => {
  try {
    const { _id, email, recomendations } = req.user;
    const cacheKey = `recommendations:${_id}`;
    const totalProductsCount = await Products.countDocuments();

    if (!recomendations || recomendations.length === 0) {
      let additionalProducts = await Products.find()
        .sort({ salesLastWeek: -1 })
        .limit(totalProductsCount);

      const additionalProductIds = additionalProducts.map(
        (product) => product._id
      );

      const reviewsProductAdditional = await Review.find({
        productId: { $in: additionalProductIds },
      });

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

          const productReviews = reviewsProductAdditional
            .filter((review) => {
              return review.productId.toString() === product._id.toString();
            })
            .map((review) => review.toObject());

          return {
            ...product.toObject(),
            sellerName: seller ? seller.namaToko : "Unknown",
            reviews: productReviews,
          };
        }
      );
      return res.status(200).json(productAdditionalWithSellerName);
    }

    let additionalProducts = await Products.find()
      .sort({ salesLastWeek: -1 })
      .limit(totalProductsCount);

    const products = await Products.find({
      category: { $in: recomendations },
    });

    const reviewsProduct = await Review.find({
      productId: { $in: products._id },
    });
    const reviewsProductAdditional = await Review.find({
      productId: { $in: additionalProducts._id },
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
          reviews: reviewsProductAdditional.map((review) => review.toObject()),
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
        reviews: reviewsProduct.map((review) => review.toObject()),
      };
    });

    // Combine additional products with recommended products if the number of recomendations is less than 5

    // Combine additional products into the products list
    const allProducts = [
      ...productsWithSellerName,
      ...productAdditionalWithSellerName,
    ];
    if (products.length === 0) {
      return res
        .status(404)
        .json({ message: "No products found for the given recomendations." });
    }
    client.setex(cacheKey, 3600, JSON.stringify(allProducts));
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

    client.get(cacheKey, async (err, cachedData) => {
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
      client.set(cacheKey, JSON.stringify(data));
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

    const product = await Products.find({ sellerId: seller._id });
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

const getSuggest = async (req, res) => {
  try {
    const selectId = req.query.selectId;
    let query = req.query.q;
    const user = req.query.userId;
    let response = [];

    query = query?.trim();

    if (user) {
      const historySuggest = await SearchHistory.find({
        userId: { $regex: user, $options: "i" },
      })
        .sort({ date: -1 }) // Mengurutkan berdasarkan jmlDicari tertinggi
        .limit(5);
      response = historySuggest;
    } else if (query && !user) {
      const suggest = await searchSuggest
        .find({
          suggest: { $regex: query, $options: "i" },
        })
        .sort({ jmlDicari: -1 }) // Mengurutkan berdasarkan jmlDicari tertinggi
        .limit(5); // Membatasi hasil ke 5 dokumen
      response = suggest;
    }

    res.status(200).json(response);
  } catch (error) {
    console.error(error);
    res
      .status(500)
      .json({ error: "An error occurred while fetching suggestions" });
  }
};

const getProductSearch = async (req, res) => {
  try {
    let query = req.query.q;
    query = query?.trim();
    if (query && query.length > 0) {
      const userId = req.query.userId;

      const history = await SearchHistory.findOne({
        userId: userId,
        searchValue: query,
      });
      if (history) {
        history.date = new Date(); // Mengatur tanggal dan waktu saat ini
        await history.save(); // Menyimpan perubahan
      } else {
        const addHistorySearch = new SearchHistory({
          searchValue: query,
          userId: userId,
          date: new Date(),
        });
        await addHistorySearch.save();
      }
      const products = await Products.find({
        name: { $regex: query, $options: "i" },
      });

      const sellerIds = products.map((product) => product.sellerId);
      const sellers = await Sellers.find({ _id: { $in: sellerIds } });

      const productsWithSellerName = products.map((product) => {
        const seller = sellers.find(
          (seller) => seller._id.toString() === product.sellerId.toString()
        );
        return {
          ...product.toObject(),
          sellerName: seller ? seller.namaToko : "Unknown Seller",
        };
      });

      res.status(200).json(productsWithSellerName);
    } else {
      res.status(200).json([]);
    }
  } catch (error) {
    console.error(error);
    res
      .status(500)
      .json({ error: "An error occurred while fetching products" });
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
  getSuggest,
  getProductSearch,
};
