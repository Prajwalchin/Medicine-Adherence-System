const connection = require("../db.js");

const getDashboard = (req, res) => {
  const user_id = req.body.user_id;
  
  if (!user_id) {
    return res.status(400).json({ message: "User ID is required" });
  }
  
  // Date handling
  const today = new Date();
  const dateStr = req.query.date || today.toISOString().split('T')[0];
  
  // For adherence matrix
  today.setHours(23, 59, 59, 999); // End of today
  const sevenDaysAgo = new Date(today);
  sevenDaysAgo.setDate(today.getDate() - 6); // Start of 7 days ago (including today)
  sevenDaysAgo.setHours(0, 0, 0, 0);
  
  const formattedToday = today.toISOString().slice(0, 19).replace('T', ' ');
  const formattedSevenDaysAgo = sevenDaysAgo.toISOString().slice(0, 19).replace('T', ' ');
  
  // Prepare promise for adherence matrix data
  const getAdherenceMatrix = new Promise((resolve, reject) => {
    const query = `
      SELECT 
        mi.scheduled_at,
        mi.taken_at
      FROM MedicineIntakes mi
      JOIN MedicineCourses mc ON mi.medicine_course_id = mc.medicine_course_id
      JOIN Courses c ON mc.course_id = c.course_id
      WHERE c.user_id = ? 
      AND mi.scheduled_at BETWEEN ? AND ?
      ORDER BY mi.scheduled_at ASC
    `;
    
    connection.query(query, [user_id, formattedSevenDaysAgo, formattedToday], (err, results) => {
      if (err) {
        console.error('Error fetching adherence matrix:', err);
        reject(err);
        return;
      }
      
      // Initialize the result object with all 7 days
      const dayMatrix = {};
      
      // Create entries for each of the last 7 days
      for (let i = 0; i < 7; i++) {
        const date = new Date(today);
        date.setDate(today.getDate() - i);
        const dateString = date.toISOString().split('T')[0]; // YYYY-MM-DD format
        dayMatrix[`day${7-i}`] = {
          date: dateString,
          total: 0,
          taken: 0,
          percentage: 0
        };
      }
      
      // Process each medication intake
      results.forEach(intake => {
        const intakeDate = new Date(intake.scheduled_at);
        
        // Calculate which day this belongs to (1-7)
        const dayDiff = Math.floor((today - intakeDate) / (1000 * 60 * 60 * 24));
        const dayKey = `day${7-dayDiff}`;
        
        // Only count if it's within our 7-day window
        if (dayDiff >= 0 && dayDiff < 7) {
          dayMatrix[dayKey].total++;
          if (intake.taken_at !== null) {
            dayMatrix[dayKey].taken++;
          }
        }
      });
      
      // Calculate percentages
      for (let i = 1; i <= 7; i++) {
        const dayKey = `day${i}`;
        if (dayMatrix[dayKey].total > 0) {
          dayMatrix[dayKey].percentage = Math.round((dayMatrix[dayKey].taken / dayMatrix[dayKey].total) * 100);
        } else {
          dayMatrix[dayKey].percentage = 0; // No medications scheduled for this day
        }
      }
      
      // Convert to the simplified format
      const simplifiedMatrix = {};
      for (let i = 1; i <= 7; i++) {
        const dayKey = `day${i}`;
        simplifiedMatrix[dayKey] = dayMatrix[dayKey].percentage;
      }
      
      resolve({
        adherenceMatrix: simplifiedMatrix,
        detailedMatrix: dayMatrix
      });
    });
  });
  
  // Prepare promise for today's schedule
  const getTodaySchedule = new Promise((resolve, reject) => {
    const now = new Date();
    
    const query = `
      SELECT 
        mi.intake_id,
        mc.medicine_course_id,
        mc.medicine_name,
        mi.scheduled_at,
        mi.taken_at,
        mi.beforeafter,
        mc.medtype
      FROM MedicineIntakes mi
      JOIN MedicineCourses mc ON mi.medicine_course_id = mc.medicine_course_id
      JOIN Courses c ON mc.course_id = c.course_id
      WHERE c.user_id = ? 
      AND DATE(mi.scheduled_at) = ?
      ORDER BY mi.scheduled_at ASC
    `;
    
    connection.query(query, [user_id, dateStr], (err, results) => {
      if (err) {
        console.error('Error fetching today\'s schedule:', err);
        reject(err);
        return;
      }
      
      // Process the results with 10 minute grace period for missed medications
      const schedule = results.map(item => {
        const scheduledTime = new Date(item.scheduled_at);
        
        // Add 10 minutes to scheduled time for grace period
        const graceTime = new Date(scheduledTime);
        graceTime.setMinutes(graceTime.getMinutes() + 10);
        
        let status = 'Upcoming';
        
        if (item.taken_at) {
          status = 'Taken';
        } else if (graceTime < now) {
          status = 'Missed';
        }
        
        return {
          intake_id: item.intake_id,
          medicine_name: item.medicine_name,
          scheduled_at: item.scheduled_at,
          taken_at: item.taken_at,
          status: status,
          timing: item.beforeafter === 0 ? 'Before meal' : 'After meal',
          medtype: item.medtype === '0' ? 'Pill' : 'Liquid',
          pillcount: 1
        };
      });
      
      // Count medications by status
      const takenIntakes = schedule.filter(item => item.status === 'Taken').length;
      const missedIntakes = schedule.filter(item => item.status === 'Missed').length;
      const upcomingIntakes = schedule.filter(item => item.status === 'Upcoming').length;
      
      resolve({
        date: dateStr,
        total_intakes: schedule.length,
        taken_intakes: takenIntakes,
        missed_intakes: missedIntakes,
        upcoming_intakes: upcomingIntakes,
        schedule: schedule
      });
    });
  });
  
  // Prepare promise for quote of the day
  const getQuote = new Promise((resolve, reject) => {
    // Check if today's quote exists
    const checkQuery = `
      SELECT m.quote FROM QuoteOfTheDay q
      JOIN MediQuotes m ON q.medi_quote_id = m.medi_quote_id
      WHERE DATE(q.last_updated) = CURDATE()
    `;
    
    connection.query(checkQuery, (err, result) => {
      if (err) {
        console.error('Error fetching quote:', err);
        reject(err);
        return;
      }
      
      if (result.length > 0) {
        resolve({ quote: result[0].quote }); // Return today's quote
        return;
      }
      
      // Otherwise, pick a new random quote
      const selectQuery = `SELECT * FROM MediQuotes ORDER BY RAND() LIMIT 1`;
      
      connection.query(selectQuery, (err, quoteResult) => {
        if (err) {
          console.error('Error selecting random quote:', err);
          reject(err);
          return;
        }
        
        if (quoteResult.length === 0) {
          resolve({ quote: "No quotes available" });
          return;
        }
        
        const medi_quote_id = quoteResult[0].medi_quote_id;
        
        // Insert or update the quote of the day
        const insertQuery = `
          INSERT INTO QuoteOfTheDay (medi_quote_id, last_updated)
          VALUES (${medi_quote_id}, NOW())
          ON DUPLICATE KEY UPDATE medi_quote_id = VALUES(medi_quote_id), last_updated = NOW()
        `;
        
        connection.query(insertQuery, (err) => {
          if (err) {
            console.error('Error updating quote of the day:', err);
            reject(err);
            return;
          }
          
          resolve({ quote: quoteResult[0].quote });
        });
      });
    });
  });
  
  // Execute all promises in parallel and combine results
  Promise.all([getAdherenceMatrix, getTodaySchedule, getQuote])
    .then(([adherenceData, scheduleData, quoteData]) => {
      res.status(200).json({
        adherence: adherenceData,
        todaySchedule: scheduleData,
        quoteOfTheDay: quoteData.quote
      });
    })
    .catch(error => {
      console.error('Dashboard error:', error);
      res.status(500).json({ message: "Error fetching dashboard data" });
    });
};

module.exports = {
    getDashboard,
};