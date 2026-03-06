USE forum_db;

-- Topics table
CREATE TABLE IF NOT EXISTS topics (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Add topic_id to articles if it doesn't exist
SET @dbname = 'forum_db';
SET @tablename = 'articles';
SET @columnname = 'topic_id';
SET @preparedStatement = (SELECT IF(
  (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
   WHERE TABLE_SCHEMA = @dbname
     AND TABLE_NAME = @tablename
     AND COLUMN_NAME = @columnname) > 0,
  'SELECT 1',
  'ALTER TABLE articles ADD COLUMN topic_id INT, ADD FOREIGN KEY (topic_id) REFERENCES topics(id) ON DELETE SET NULL'
));
PREPARE stmt FROM @preparedStatement;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

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

-- Insert some default topics
INSERT IGNORE INTO topics (name, description) VALUES ('General', 'General discussion topic');
INSERT IGNORE INTO topics (name, description) VALUES ('Music', 'Discuss your favorite music');
INSERT IGNORE INTO topics (name, description) VALUES ('Tech', 'Technology and gadgets');
