-- Database Schema for Forum_v1
-- The database should be created pre-emptively on shared hosting.

-- Users table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    join_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT FALSE,
    is_admin BOOLEAN DEFAULT FALSE,
    profile_picture VARCHAR(255) DEFAULT 'default_profile.png'
);

-- Verification tokens for email confirmation
CREATE TABLE IF NOT EXISTS verification_tokens (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    token VARCHAR(255) NOT NULL UNIQUE,
    expiry_date DATETIME NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Topics table
CREATE TABLE IF NOT EXISTS topics (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    name_fr VARCHAR(100),
    description TEXT,
    description_fr TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Articles table (modified)
CREATE TABLE IF NOT EXISTS articles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    title_fr VARCHAR(255),
    content TEXT NOT NULL,
    content_fr TEXT,
    author_id INT NOT NULL,
    topic_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (author_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (topic_id) REFERENCES topics(id) ON DELETE SET NULL
);

-- Article Photos table
CREATE TABLE IF NOT EXISTS article_photos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    article_id INT NOT NULL,
    photo_url VARCHAR(255) NOT NULL,
    uploader_id INT NOT NULL,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE,
    FOREIGN KEY (uploader_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Comments table
CREATE TABLE IF NOT EXISTS comments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    article_id INT NOT NULL,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Default Topics
INSERT IGNORE INTO topics (name, name_fr, description, description_fr) VALUES 
('General', 'Général', 'General discussion topic', 'Sujet de discussion général'),
('Music', 'Musique', 'Discuss your favorite music', 'Discutez de votre musique préférée'),
('Tech', 'Technologie', 'Technology and gadgets', 'Technologie et gadgets');

-- Default Admin User (password is 'admin123' hashed with BCrypt)
INSERT IGNORE INTO users (username, email, password, is_active, is_admin) 
VALUES ('admin', 'admin@forum.com', '$2a$10$8.UnVuG9HHgffUDAlk8q2OuVGkqBKCbVqG9Le9VJ2Z1iU9qOC132i', TRUE, TRUE);
