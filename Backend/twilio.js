const twilio = require('twilio');
require('dotenv').config();

// Twilio configuration
const accountSid = process.env.TWILIO_ACCOUNT_SID;
const authToken = process.env.TWILIO_AUTH_TOKEN;
const client = new twilio(accountSid, authToken);

/**
 * Sends an OTP message via WhatsApp using Twilio
 * @param {string} otp - The OTP code to send
 * @param {string} phone - The phone number to send to (without country code)
 * @returns {Promise} - Promise representing the message sending operation
 */
const sendMessage = async (msg, phone) => {
    console.log('Sending message to', phone);
    try {
        const message = await client.messages.create({
            from: `whatsapp:${process.env.TWILIO_WHATSAPP_FROM}`,
            to: 'whatsapp:+91' + phone,
            body: `${msg}`
        });
        console.log('Message sent:', message.sid);
        return message;
    } catch (error) {
        console.error('Error sending message:', error);
        throw error;
    }
};

module.exports = {
    sendMessage
};