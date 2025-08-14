-- MySQL initialization script for DIY Journey

CREATE DATABASE IF NOT EXISTS diy_journey CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE diy_journey;

CREATE TABLE IF NOT EXISTS label_codes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  code VARCHAR(100) NOT NULL UNIQUE,
  active TINYINT(1) DEFAULT 1,
  server_expiry DATETIME DEFAULT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS personal_details (
  id INT AUTO_INCREMENT PRIMARY KEY,
  employee_code VARCHAR(100) NOT NULL UNIQUE,
  first_name VARCHAR(150) NOT NULL,
  last_name VARCHAR(150),
  dob DATE NOT NULL,
  gender ENUM('Male','Female','Other') DEFAULT 'Other',
  email VARCHAR(255),
  phone VARCHAR(20),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS address_details (
  id INT AUTO_INCREMENT PRIMARY KEY,
  employee_code VARCHAR(100) NOT NULL,
  address1 VARCHAR(255) NOT NULL,
  address2 VARCHAR(255),
  city VARCHAR(150),
  state VARCHAR(150),
  district VARCHAR(150),
  pincode VARCHAR(10),
  landmark VARCHAR(255),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX(employee_code),
  CONSTRAINT fk_address_personal FOREIGN KEY (employee_code) REFERENCES personal_details(employee_code) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS family_members (
  id INT AUTO_INCREMENT PRIMARY KEY,
  employee_code VARCHAR(100) NOT NULL,
  name VARCHAR(255) NOT NULL,
  relation VARCHAR(50),
  age INT,
  occupation VARCHAR(150),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  INDEX(employee_code),
  CONSTRAINT fk_family_personal FOREIGN KEY (employee_code) REFERENCES personal_details(employee_code) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS nominees (
  id INT AUTO_INCREMENT PRIMARY KEY,
  employee_code VARCHAR(100) NOT NULL,
  name VARCHAR(255) NOT NULL,
  relation VARCHAR(50),
  age INT,
  share_percentage DECIMAL(5,2) NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  INDEX(employee_code),
  CONSTRAINT fk_nominee_personal FOREIGN KEY (employee_code) REFERENCES personal_details(employee_code) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS onboarding_status (
  id INT AUTO_INCREMENT PRIMARY KEY,
  employee_code VARCHAR(100) NOT NULL UNIQUE,
  onboarding_completed TINYINT(1) DEFAULT 0,
  membership_id VARCHAR(100),
  completed_at DATETIME DEFAULT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  INDEX(employee_code),
  CONSTRAINT fk_onboarding_personal FOREIGN KEY (employee_code) REFERENCES personal_details(employee_code) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO label_codes (code, active, server_expiry) VALUES ('EMP001', 1, '2025-12-31 23:59:59');

INSERT INTO personal_details (employee_code, first_name, last_name, dob, gender, email, phone) VALUES ('EMP001','Test','User','1990-01-01','Male','test@example.com','9900000000');

-- To import:
-- mysql -u youruser -p < db_init.sql
