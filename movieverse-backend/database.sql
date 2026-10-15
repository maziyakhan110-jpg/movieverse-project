-- ============================================
-- MovieVerse Database Schema
-- Run this in MySQL Workbench to recreate the DB
-- ============================================

CREATE DATABASE IF NOT EXISTS movieverse
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE movieverse;

-- USERS
CREATE TABLE IF NOT EXISTS users (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- GENRES
CREATE TABLE IF NOT EXISTS genres (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- SHOWS
CREATE TABLE IF NOT EXISTS shows (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    tvmaze_id INT NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    summary TEXT,
    rating DECIMAL(3,1),
    image_url VARCHAR(2048),
    language VARCHAR(50),
    premiered DATE,
    ended DATE,
    status VARCHAR(50),
    runtime INT,
    genre_id BIGINT UNSIGNED,
    CONSTRAINT chk_shows_rating CHECK (rating IS NULL OR (rating >= 0 AND rating <= 10)),
    CONSTRAINT fk_shows_genre FOREIGN KEY (genre_id) REFERENCES genres(id)
) ENGINE=InnoDB;

-- FAVORITES
CREATE TABLE IF NOT EXISTS favorites (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    show_id BIGINT UNSIGNED NOT NULL,
    added_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_fav_user_show UNIQUE (user_id, show_id),
    CONSTRAINT fk_fav_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_fav_show FOREIGN KEY (show_id) REFERENCES shows(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- REVIEWS
CREATE TABLE IF NOT EXISTS reviews (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    show_id BIGINT UNSIGNED NOT NULL,
    rating TINYINT NOT NULL,
    comment TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_review_rating CHECK (rating BETWEEN 1 AND 10),
    CONSTRAINT uq_review_user_show UNIQUE (user_id, show_id),
    CONSTRAINT fk_review_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_review_show FOREIGN KEY (show_id) REFERENCES shows(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- EPISODES
CREATE TABLE IF NOT EXISTS episodes (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    show_id BIGINT UNSIGNED NOT NULL,
    season INT NOT NULL,
    episode_no INT NOT NULL,
    name VARCHAR(255),
    airdate DATE,
    runtime INT,
    CONSTRAINT fk_episode_show FOREIGN KEY (show_id) REFERENCES shows(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- SAMPLE DATA
INSERT IGNORE INTO genres (id, name) VALUES
(1, 'Drama'), (2, 'Action'), (3, 'Comedy'),
(4, 'Science-Fiction'), (5, 'Thriller');

INSERT IGNORE INTO shows (tvmaze_id, name, summary, rating, image_url, language, premiered, ended, status, runtime, genre_id) VALUES
(1, 'Under the Dome', 'A small town is sealed off from the rest of the world by an enormous transparent dome.', 6.5, 'https://static.tvmaze.com/uploads/images/medium_portrait/81/202627.jpg', 'English', '2013-06-24', '2015-09-10', 'Ended', 60, 1),
(2, 'Person of Interest', 'A former CIA operative teams up with a mysterious billionaire to prevent violent crimes.', 8.8, 'https://static.tvmaze.com/uploads/images/medium_portrait/163/407679.jpg', 'English', '2011-09-22', '2016-06-21', 'Ended', 60, 2),
(3, 'Bitten', 'A werewolf discovers she is the only female werewolf in the world.', 7.5, 'https://static.tvmaze.com/uploads/images/medium_portrait/0/15.jpg', 'English', '2014-01-11', '2016-04-15', 'Ended', 60, 1),
(4, 'Arrow', 'A billionaire playboy becomes a vigilante after being stranded on an island.', 7.4, 'https://static.tvmaze.com/uploads/images/medium_portrait/143/358967.jpg', 'English', '2012-10-10', '2020-01-28', 'Ended', 60, 2),
(5, 'True Detective', 'Two detectives investigate a series of murders over 17 years.', 9.0, 'https://static.tvmaze.com/uploads/images/medium_portrait/490/1225090.jpg', 'English', '2014-01-12', NULL, 'Running', 60, 5),
(6, 'The Big Bang Theory', 'Four scientists and a waitress navigate life and love.', 8.3, 'https://static.tvmaze.com/uploads/images/medium_portrait/21/53909.jpg', 'English', '2007-09-24', '2019-05-16', 'Ended', 30, 3),
(7, 'Game of Thrones', 'Noble families fight for control of the Iron Throne.', 9.3, 'https://static.tvmaze.com/uploads/images/medium_portrait/498/1246401.jpg', 'English', '2011-04-17', '2019-05-19', 'Ended', 60, 1),
(8, 'Stranger Things', 'Kids uncover a mystery involving secret experiments and supernatural forces.', 8.7, 'https://static.tvmaze.com/uploads/images/medium_portrait/200/500891.jpg', 'English', '2016-07-15', NULL, 'Running', 60, 4),
(9, 'Breaking Bad', 'A chemistry teacher turns to manufacturing drugs after a cancer diagnosis.', 9.5, 'https://static.tvmaze.com/uploads/images/medium_portrait/0/1389.jpg', 'English', '2008-01-20', '2013-09-29', 'Ended', 60, 5),
(10, 'Friends', 'Six friends navigate life and love in Manhattan.', 8.6, 'https://static.tvmaze.com/uploads/images/medium_portrait/41/104550.jpg', 'English', '1994-09-22', '2004-05-06', 'Ended', 30, 3);