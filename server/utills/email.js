const nodemailer = require("nodemailer");

const sendEmail = async (option) => {
  const transporter = nodemailer.createTransport({
    service: process.env.MAIL_HOST,
    port: process.env.MAIL_PORT,
    auth: {
      user: process.env.MAIL_USERNAME,
      password: process.env.MAIL_PASSWORD,
    },
  });

  const emailOptions = {
    from: process.env.MAIL_FROM_ADDRESS,
    to: option.email,
    subject: option.subject,
    text: option.message,
  };

  await transporter.send(emailOptions);
};

module.exports = sendEmail;
