const express = require("express");
const bodyParser = require("body-parser");
const http = require("http");
const dotenv = require("dotenv");
const axios = require("axios");

const getSnapToken = async (req, res) => {
  const { payment_type, transaction_details, credit_card } = req.body;

  const url = "https://api.sandbox.midtrans.com/v2/charge"; // endpoint sandbox
  const serverKey = process.env.MIDTRANS_SERVER_KEY;

  try {
    const response = await axios.post(
      url,
      {
        payment_type,
        transaction_details,
        credit_card,
      },
      {
        headers: {
          "Content-Type": "application/json",
          Accept: "application/json",
          Authorization: `Basic ${Buffer.from(serverKey + ":").toString(
            "base64"
          )}`,
        },
      }
    );

    res.status(response.status).json(response.data);
  } catch (error) {
    console.error("Error creating transaction:", error);
    res.status(error.response.status || 500).json({
      error: {
        message: error.message,
        details: error.response.data,
      },
    });
  }
};

module.exports = getSnapToken;
