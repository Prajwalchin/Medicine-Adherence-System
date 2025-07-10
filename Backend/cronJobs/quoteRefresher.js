const cron = require('node-cron');
const connection = require('../db.js');
const util = require('util');

// Convert callback-based MySQL queries to promises
const query = util.promisify(connection.query).bind(connection);

// Function to update quotes of the day
async function updateQuotesOfTheDay() {
  try {
    // Delete all existing records from QuoteOfTheDay
    await query('DELETE FROM QuoteOfTheDay');
    // console.log('Successfully cleared QuoteOfTheDay table');
    
    // Get random quotes for each language in parallel
    const [englishQuote, hindiQuote, marathiQuote] = await Promise.all([
      query("SELECT * FROM MediQuotes WHERE language = 'English' ORDER BY RAND() LIMIT 1"),
      query("SELECT * FROM MediQuotes WHERE language = 'Hindi' ORDER BY RAND() LIMIT 1"),
      query("SELECT * FROM MediQuotes WHERE language = 'Marathi' ORDER BY RAND() LIMIT 1")
    ]);
    
    // Make sure we have quotes for each language
    if (!englishQuote.length || !hindiQuote.length || !marathiQuote.length) {
      throw new Error('Could not find quotes for all required languages');
    }
    
    // Insert new quotes in parallel
    await Promise.all([
      query('INSERT INTO QuoteOfTheDay (medi_quote_id, language) VALUES (?, ?)', 
            [englishQuote[0].medi_quote_id, 'English']),
      query('INSERT INTO QuoteOfTheDay (medi_quote_id, language) VALUES (?, ?)', 
            [hindiQuote[0].medi_quote_id, 'Hindi']),
      query('INSERT INTO QuoteOfTheDay (medi_quote_id, language) VALUES (?, ?)', 
            [marathiQuote[0].medi_quote_id, 'Marathi'])
    ]);
    
    // console.log('Successfully updated QuoteOfTheDay table with new quotes');
  } catch (error) {
    console.error('Error updating Quote of the Day:', error);
  }
}

// Schedule daily update at midnight
cron.schedule('0 0 * * *', updateQuotesOfTheDay);

// Run immediately when module is required
// console.log('Quote of the Day service initializing...');
updateQuotesOfTheDay();

// Export the update function in case it needs to be called manually
module.exports = { updateQuotesOfTheDay };