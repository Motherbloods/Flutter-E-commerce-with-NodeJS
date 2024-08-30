// socketConfig.js
const socketIo = require("socket.io");
const Messages = require("../models/messages");
const Conversations = require("../models/conversations");
const Users = require("../models/user");
const Sellers = require("../models/seller");

let users = [];
let usersActiveConversation = [];

function configureSocket(server) {
  const io = socketIo(server);

  io.on("connection", (socket) => {
    try {
      socket.on("addUser", (userId) => {
        const isUserExist = users.find(
          (user) => user.userId?.toString() === userId
        );
        console.log("inimasuk");
        if (!isUserExist) {
          const user = { userId, socketId: socket.id };
          users.push(user);
          io.emit("getUsers", users);
        }
      });
      socket.on("join_conversation", (conversationId) => {
        socket.join(conversationId);
      });

      socket.on(
        "sendMessage",
        async ({ senderId, message, conversationId }) => {
          console.log("sendMessage", senderId, conversationId);
          const lastMessage = await Messages.findOne(
            { conversationId: conversationId },
            {},
            { sort: { createdAt: -1 } }
          );
          const conversation = await Conversations.findById(conversationId);
          const receiverId = conversation.members.find(
            (memberId) => memberId.toString() !== senderId?.toString()
          );
          const receiverSocket = users.find(
            (user) => user.userId?.toString() === receiverId?.toString()
          );
          const senderSocket = users.find(
            (user) => user.userId?.toString() === senderId?.toString()
          );
          let messageToSend = {
            conversationId: conversationId,
            senderId: senderId,
            message: message,
            read: lastMessage.read,
            isReply: lastMessage.isReply,
            isReplyMessageId: lastMessage.isReplyMessageId,
            isForward: lastMessage.isForward,
            _id: lastMessage._id,
            productInfo: lastMessage.productInfo,
          };

          if (receiverSocket) {
            console.log("ini trueeee");
            messageToSend.receiver = true;
            io.to(senderSocket?.socketId)
              .to(receiverSocket.socketId)
              .emit("getMessage", messageToSend);
          } else {
            console.log("ini false");
            messageToSend.receiver = false;
            io.to(senderSocket?.socketId).emit("getMessage", messageToSend);
          }
        }
      );

      socket.on(
        "sendConversation",
        async ({ conversationId, senderId, message }) => {
          console.log("inni kepangill brok");
          try {
            let receiverId;
            let receiverSocket;
            let userOrSeller;
            let isSeller = false;
            const user = await Users.findById(senderId);
            if (user) {
              userOrSeller = user;
              isSeller = false;
            } else {
              const seller = await Sellers.findById(senderId);
              userOrSeller = seller;
              isSeller = true;
            }
            const senderSocket = users.find(
              (user) => user.userId?.toString() === senderId?.toString()
            );
            const conversation = await Conversations.findById(conversationId);
            const messages = await Messages.find({
              conversationId: conversationId,
            });

            if (conversation) {
              receiverId = conversation.members.find(
                (memberId) => memberId?.toString() != senderId?.toString()
              );
              receiverSocket = users.find(
                (user) => user.userId?.toString() == receiverId?.toString()
              );
            } else {
              receiverId = "";
              receiverSocket = "";
            }
            const payload = {
              conversationId,
              user: {
                _id: userOrSeller._id,
                img: userOrSeller.img,
                ...(isSeller
                  ? { namaToko: userOrSeller.namaToko }
                  : {
                      fullName: userOrSeller.fullName
                        ? userOrSeller.fullName
                        : "Unknown",
                    }),
                isSeller,
              },
              messages,
            };
            if (receiverSocket && receiverSocket != "") {
              console.log("ini treu convers");
              io.to(senderSocket?.socketId)
                .to(receiverSocket?.socketId)
                .emit("getConversation", payload);
            } else {
              console.log("ini false conver");
              io.to(senderSocket?.socketId).emit("getConversation", payload);
            }
          } catch (e) {
            console.error("Error in sendConversations:", e);
          }
        }
      );

      socket.on("disconnect", () => {
        console.log("Client disconnected");
      });
    } catch (e) {}
  });

  return io;
}

module.exports = configureSocket;
