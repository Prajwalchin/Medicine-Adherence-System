const WebSocket = require('ws');

let wss;
let connectedClients = []; // Store connected clients
let messageHandlers = []; // Store custom message handlers

/**
 * Initialize the WebSocket server
 * @param {http.Server} server - HTTP server instance
 */
function initializeWebSocketServer(server) {
    wss = new WebSocket.Server({ server });
    
    wss.on('connection', (socket, request) => {
        console.log("Client Connected");
        
        // Generate a unique ID for this client
        socket.id = Date.now().toString() + Math.random().toString(36).substr(2, 5);
        
        // Add this client to our connected clients array
        connectedClients.push(socket);
        console.log(`Client ${socket.id} connected. Total clients: ${connectedClients.length}`);
        
        // Set up message handling
        socket.on('message', (message) => {
            handleIncomingMessage(message, socket);
        });

        socket.on('close', () => {
            console.log(`Client ${socket.id} disconnected`);
            // Remove this client from our array
            connectedClients = connectedClients.filter(client => client !== socket);
            console.log(`Remaining clients: ${connectedClients.length}`);
        });

        // Handle errors to prevent crashes
        socket.on('error', (error) => {
            console.error(`Socket error for client ${socket.id}:`, error);
            // Attempt to remove problematic client
            connectedClients = connectedClients.filter(client => client !== socket);
        });
    });
    
    return wss;
}

/**
 * Process an incoming message from a client
 * @param {Buffer|ArrayBuffer|string} message - The message received
 * @param {WebSocket} sender - The client that sent the message
 */
function handleIncomingMessage(message, sender) {
    const messageStr = message.toString();
    console.log(`Received message from client ${sender.id}:`, messageStr);
    
    // Try to parse as JSON
    try {
        const parsedMessage = JSON.parse(messageStr);
        
        // First try registered message handlers
        const handlerFound = messageHandlers.some(handler => {
            try {
                return handler(parsedMessage, sender);
            } catch (error) {
                console.error('Error in message handler:', error);
                return false;
            }
        });
        
        // Default handler if no custom handler processed it
        if (!handlerFound && parsedMessage.type) {
            handleSocketMessage(parsedMessage, sender);
        }
    } catch (e) {
        // Handle as raw text if not valid JSON
        handleRawSocketMessage(messageStr, sender);
    }
}

/**
 * Handle structured JSON messages
 * @param {Object} message - Parsed JSON message with type and data
 * @param {WebSocket} sender - The client that sent the message
 */
function handleSocketMessage(message, sender) {
    switch (message.type) {
        case 'broadcast':
            // Broadcast the message data directly
            broadcastMessage(message.data);
            break;
        default:
            console.log('Received message of type:', message.type);
            // You can add more message types here
    }
}

/**
 * Handle raw text messages
 * @param {string} message - The raw message string
 * @param {WebSocket} sender - The client that sent the message
 */
function handleRawSocketMessage(message, sender) {
    console.log('Received raw message:', message);
    // You can add specific raw message handling here
}

/**
 * Register a custom message handler
 * @param {Function} handler - Function that takes (message, sender) and returns true if handled
 */
function registerMessageHandler(handler) {
    if (typeof handler === 'function') {
        messageHandlers.push(handler);
    }
}

/**
 * Send a message to all connected clients
 * @param {any} message - The message to broadcast (can be object, string, etc.)
 */
function broadcastMessage(message) {
    const messageToSend = typeof message === 'string' ? message : JSON.stringify(message);
    
    // Check if we have clients before attempting to broadcast
    if (connectedClients.length === 0) {
        console.log('No clients connected. Cannot broadcast message.');
        return;
    }
    
    let successCount = 0;
    
    connectedClients.forEach(client => {
        try {
            if (client && client.readyState === WebSocket.OPEN) {
                client.send(messageToSend);
                successCount++;
            }
        } catch (error) {
            console.error(`Error sending to client ${client.id}:`, error);
        }
    });
    
    console.log(`Broadcast message: ${messageToSend} to ${successCount} of ${connectedClients.length} clients`);
}

/**
 * Send a message to a specific client by ID
 * @param {string} clientId - The ID of the client to send to
 * @param {any} message - The message to send
 * @returns {boolean} - Whether the message was sent successfully
 */
function sendMessageToClient(clientId, message) {
    const messageToSend = typeof message === 'string' ? message : JSON.stringify(message);
    
    const client = connectedClients.find(c => c.id === clientId);
    if (client && client.readyState === WebSocket.OPEN) {
        try {
            client.send(messageToSend);
            console.log(`Sent message to client ${clientId}: ${messageToSend}`);
            return true;
        } catch (error) {
            console.error(`Error sending to client ${clientId}:`, error);
            return false;
        }
    }
    
    console.log(`Client ${clientId} not found or not ready`);
    return false;
}

/**
 * Get the number of connected clients
 * @returns {number} - The number of connected clients
 */
function getConnectedClientsCount() {
    // Clean up any potential dead connections
    const activeClients = connectedClients.filter(client => 
        client && client.readyState === WebSocket.OPEN
    );
    
    // If we found and removed dead connections, update our array
    if (activeClients.length !== connectedClients.length) {
        console.log(`Cleaned up ${connectedClients.length - activeClients.length} dead connections`);
        connectedClients = activeClients;
    }
    
    return connectedClients.length;
}

module.exports = {
    initializeWebSocketServer,
    broadcastMessage,
    sendMessageToClient,
    getConnectedClientsCount,
    registerMessageHandler
};