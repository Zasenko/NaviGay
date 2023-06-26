
    var blockedEvents: [Photo]
    var blockedPlaces: [Place]
    var blockedEvents: [Event]
    var blockedUsers: [User]

CREATE TABLE User (
    id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,

    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    
    bio VARCHAR(255) DEFAULT NULL,
    photo VARCHAR(255) DEFAULT NULL,
    instagram VARCHAR(255) DEFAULT NULL,
    
    status ENUM('user', 'admin', 'moderator', 'partner') NOT NULL DEFAULT 'user',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    last_time_online TIMESTAMP DEFAULT NULL,
    latitude decimal(10,8) DEFAULT NULL,
    longitude decimal(11,8) DEFAULT NULL
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci