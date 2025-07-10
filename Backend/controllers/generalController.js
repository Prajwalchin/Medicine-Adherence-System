const connection = require("../db.js");

const quoteOfTheDay = (req, res) => {
    const { user_id } = req.body;

    if (!user_id) {
        return res.status(400).json({ message: "User ID is required" });
    }

    // Find user by ID and get their preferred language
    const userQuery = "SELECT language FROM Users WHERE user_id = ?";

    connection.query(userQuery, [user_id], (err, results) => {
        if (err) {
            return res.status(500).json({ message: "Database error", error: err });
        }

        if (results.length === 0) {
            return res.status(404).json({ message: "User not found" });
        }

        const userLanguage = results[0].language;

        // Get the quote of the day in the user's language
        const quoteQuery = `
            SELECT q.quote 
            FROM QuoteOfTheDay qd
            JOIN MediQuotes q ON qd.medi_quote_id = q.medi_quote_id
            WHERE qd.language = ?
            ORDER BY qd.last_updated DESC 
            LIMIT 1
        `;

        connection.query(quoteQuery, [userLanguage], (err, quoteResults) => {
            if (err) {
                return res.status(500).json({ message: "Database error", error: err });
            }

            if (quoteResults.length === 0) {
                return res.status(404).json({ message: "No quote found for the day" });
            }

            return res.status(200).json({ quote: quoteResults[0].quote });
        });
    });
};

module.exports = {
    quoteOfTheDay,
};
