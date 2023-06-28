CREATE TABLE User_LikedPlace (

user_id INT UNSIGNED NOT NULL,
place_id INT UNSIGNED NOT NULL,

CONSTRAINT User_LikedPlace_user_id
FOREIGN KEY (user_id)
REFERENCES User (id)
ON DELETE RESTRICT,

CONSTRAINT User_LikedPlace_place_id
FOREIGN KEY (place_id)
REFERENCES Place (id)
ON DELETE RESTRICT,

INDEX (user_id),

CONSTRAINT User_LikedPlace
UNIQUE (user_id, place_id)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci