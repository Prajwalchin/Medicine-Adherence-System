
drop database HealthMobi;
create schema HealthMobi;
use HealthMobi;

-- CREATE TABLE STATEMENTS
CREATE TABLE Users (
  user_id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(255),
  phone BIGINT NOT NULL UNIQUE,
  email VARCHAR(255),
  address VARCHAR(255),
  otp VARCHAR(10),
  language VARCHAR(50) NOT NULL DEFAULT 'English',
  role ENUM('doctor', 'patient') NOT NULL DEFAULT 'patient',
  PRIMARY KEY (user_id),
  isprofilecomplete bool not null default false
);

CREATE TABLE AuthTokens (
  token_id INT NOT NULL AUTO_INCREMENT,
  user_id INT NOT NULL,
  auth_token VARCHAR(255) NOT NULL,
  PRIMARY KEY (token_id),
  FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

CREATE TABLE Courses (
  course_id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  doctor_id INT NOT NULL,
  status ENUM('Ongoing', 'Completed', 'Terminated') NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
  FOREIGN KEY (doctor_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

CREATE TABLE MedicineCourses (
  medicine_course_id INT PRIMARY KEY AUTO_INCREMENT,
  course_id INT NOT NULL,
  medicine_name VARCHAR(255) NOT NULL,
  status ENUM('Ongoing', 'Completed', 'Terminated') NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE,
  frequency CHAR(4),
  medtype CHAR(1),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE
);

CREATE TABLE MedicineIntakes (
  intake_id INT PRIMARY KEY AUTO_INCREMENT,
  medicine_course_id INT NOT NULL,
  scheduled_at TIMESTAMP NOT NULL,
  beforeafter BOOL NOT NULL,
  taken_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (medicine_course_id) REFERENCES MedicineCourses(medicine_course_id) ON DELETE CASCADE
);

CREATE TABLE MediQuotes (
    medi_quote_id INT PRIMARY KEY AUTO_INCREMENT,
    quote VARCHAR(255),
    language ENUM('English', 'Hindi', 'Marathi') NOT NULL
);

CREATE TABLE QuoteOfTheDay (
    qotd_id INT PRIMARY KEY AUTO_INCREMENT,
    medi_quote_id INT,
    language ENUM('English', 'Hindi', 'Marathi') NOT NULL,
    last_updated DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (medi_quote_id) REFERENCES MediQuotes(medi_quote_id)
);

CREATE TABLE PrescriptionImages (
  image_id INT PRIMARY KEY AUTO_INCREMENT,
  course_id INT NOT NULL,
  image_url VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE
);

CREATE TABLE PrescriptionVoiceNotes (
  voice_id INT PRIMARY KEY AUTO_INCREMENT,
  course_id INT NOT NULL,
  voice_url VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE
);

CREATE TABLE UserNotes (
  note_id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL unique,
  note VARCHAR(1000) NOT NULL default '',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);



-- TRUNCATE STATEMENTS
-- TRUNCATE TABLE Users;
-- TRUNCATE TABLE AuthTokens;
-- TRUNCATE TABLE Courses;
-- TRUNCATE TABLE MedicineCourses;
-- TRUNCATE TABLE MedicineIntakes;
-- TRUNCATE TABLE MediQuotes;
-- TRUNCATE TABLE QuoteOfTheDay;
-- TRUNCATE TABLE PrescriptionImages;
-- TRUNCATE TABLE PrescriptionVoiceNotes;
-- TRUNCATE TABLE UserNotes;


-- SELECT STATEMENTS
SELECT * FROM Users;
SELECT * FROM AuthTokens;
SELECT * FROM Courses;
SELECT * FROM MedicineCourses;
SELECT * FROM MedicineIntakes;
SELECT * FROM MediQuotes;
SELECT * FROM QuoteOfTheDay;
SELECT * FROM PrescriptionImages;
SELECT * FROM PrescriptionVoiceNotes;
SELECT * FROM UserNotes;





