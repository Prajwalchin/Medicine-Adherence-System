const connection = require('../db.js');

const authUser = (req, res, next) => {
    // Check if authorization header exists
    if (!req.headers['authorization']) {
        return res.status(401).json({ message: 'Missing authorization header' });
    }
    
    const authToken = req.headers['authorization'].split(' ')[1];
    if (!authToken) {
        return res.status(401).json({ message: 'Missing auth token' });
    }

    connection.query('SELECT * FROM AuthTokens WHERE auth_token = ?', [authToken], (err, results) => {
        if (err) {
            console.error(err);
            return res.status(500).json({ message: 'Error checking auth token' });
        }

        if (results.length === 0) {
            return res.status(401).json({ message: 'Invalid auth token' });
        }

        req.body.user_id = results[0].user_id;
        next();
    });
};

module.exports = {
    authUser
};