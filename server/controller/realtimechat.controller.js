const Conversations = require("../models/conversations");
const Messages = require("../models/messages");
const Sellers = require("../models/seller");
const Users = require("../models/user");

const conversations = async (req, res) => {
  try {
    const { senderId, receiverId } = req.body;
    let receiver;
    let receiverData;
    receiver = await Users.findById(receiverId);
    if (receiver) {
      // If found in User collection, select only the needed fields
      receiverData = {
        email: receiver.email,
        noHP: receiver.noHP,
        username: receiver.username,
        fullname: receiver.fullname,
        img: receiver.img,
      };
    } else {
      // If not found in User collection, try to find in Seller collection
      receiver = await Sellers.findById(receiverId);
      if (receiver) {
        // If found in Seller collection, select only the needed fields
        receiverData = {
          namaToko: receiver.namaToko,
          email: receiver.email,
          noHP: receiver.noHP,
          alamatToko: receiver.alamatToko,
        };
      }
    }
    const existingConversation = await Conversations.findOne({
      members: { $all: [senderId, receiverId] },
    });

    if (existingConversation) {
      return res.status(200).json({
        message: "Conversation already exists",
        conversationId: existingConversation._id,
        receiver: receiverData,
      });
    }

    // Buat percakapan baru jika tidak ada percakapan yang cocok
    const newConversation = new Conversations({
      members: [senderId, receiverId],
    });

    const savedConversation = await newConversation.save();
    res.status(200).json({
      message: "Conversation saved successfully",
      conversationId: savedConversation._id,
      receiver: receiverData,
    });
  } catch (err) {
    console.error(err);
    res
      .status(500)
      .json({ message: "Failed to save conversation", error: err.message });
  }
};

const getConversations = async (req, res) => {
  const userId = req.params.userId;
  console.log("ini user: " + userId);
  if (!userId) {
    return res.status(400).json({ message: "UserId is required" });
  }

  try {
    const conversations = await Conversations.find({
      members: { $in: [userId] },
    });

    const conversationsData = await Promise.all(
      conversations.map(async (conversation) => {
        let isSeller;
        // Ambil ID penerima jika percakapan individu
        let receiver;
        let receiverType = "user"; // Default assumption is user
        const receiverId = conversation.members.find(
          (member) => member.toString() !== userId
        );

        // Coba temukan penerima di tabel Users
        receiver = await Users.findById(receiverId);

        // Jika tidak ditemukan di tabel Users, coba di tabel Sellers
        if (!receiver) {
          receiver = await Sellers.findById(receiverId);
          receiverType = "seller"; // If found in Sellers, change type
        }

        // Ambil pesan untuk percakapan ini
        const messages = await Messages.find({
          conversationId: conversation._id,
        });

        const messagesArray = messages.map((message) => ({
          messageId: message._id,
          message: message.message,
          receiverId: receiver ? receiver._id : "",
          id: message.senderId,
          read: message.read,
          createdAt: message.createdAt,
          conversationId: conversation._id,
          isReply: message.isReply,
          isForward: message.isForward,
        }));

        // Siapkan data penerima berdasarkan jenis penerima
        let receiverData;
        if (receiverType === "user") {
          receiverData = {
            _id: receiver ? receiver._id : "",
            email: receiver ? receiver.email : "",
            fullName: receiver ? receiver.fullName : "",
            img: receiver ? receiver.img : "",
            isSeller: false,
          };
        } else {
          receiverData = {
            _id: receiver ? receiver._id : "",
            namaToko: receiver ? receiver.namaToko : "",
            email: receiver ? receiver.email : "",
            noHP: receiver ? receiver.noHP : "",
            isSeller: true,
          };
        }

        // Kembalikan data percakapan individu dengan pesan
        return {
          user: receiverData,
          type: conversation.type,
          conversationId: conversation._id,
          messages: messagesArray,
        };
      })
    );
    // Send the conversations data to the frontend
    return res.status(200).json(conversationsData);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: "Internal server error" });
  }
};

const messages = async (req, res) => {
  try {
    const { conversationId, senderId, message, productInfo } = req.body;

    // Validation
    if (!senderId || !conversationId || !message) {
      return res.status(400).json({
        message: "senderId, conversationId, and message are required",
      });
    }

    // Create new message object
    const newMessage = new Messages({
      conversationId,
      senderId,
      message,
      productInfo: productInfo || null,
    });

    // Save message to database
    const savedMessage = await newMessage.save();
    // req.app.get("io").to(conversationId).emit("new_message", savedMessage);
    // Send successful response
    res.status(201).json({
      message: "Message sent successfully",
      data: savedMessage,
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({
      message: "An error occurred while sending the message",
      error: err.message,
    });
  }
};

const getMessages = async (req, res) => {
  const conversationId = req.params.conversationId;

  if (!conversationId) {
    return res.status(400).send({ message: "Invalid conversationId" });
  }

  try {
    const messages = await Messages.find({ conversationId: conversationId });

    if (!messages || messages.length === 0) {
      return res
        .status(404)
        .send({ message: "No messages found for this conversation" });
    }

    res.status(200).json({ data: messages });
  } catch (error) {
    console.error(error);
    res.status(500).send({
      message: "An error occurred while fetching messages",
      error: error.message,
    });
  }
};

module.exports = { conversations, getConversations, getMessages, messages };
