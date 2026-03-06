-- PostgreSQL Database Schema for Forum_v1 (Render deployment)

-- Users table
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
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
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    token VARCHAR(255) NOT NULL UNIQUE,
    expiry_date TIMESTAMP NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Topics table
CREATE TABLE IF NOT EXISTS topics (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    name_fr VARCHAR(100),
    description TEXT,
    description_fr TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Articles table
CREATE TABLE IF NOT EXISTS articles (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    title_fr VARCHAR(255),
    content TEXT NOT NULL,
    content_fr TEXT,
    author_id INT NOT NULL,
    topic_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (author_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (topic_id) REFERENCES topics(id) ON DELETE SET NULL
);

-- Article Photos table
CREATE TABLE IF NOT EXISTS article_photos (
    id SERIAL PRIMARY KEY,
    article_id INT NOT NULL,
    photo_url VARCHAR(255) NOT NULL,
    uploader_id INT NOT NULL,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE,
    FOREIGN KEY (uploader_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Comments table
CREATE TABLE IF NOT EXISTS comments (
    id SERIAL PRIMARY KEY,
    article_id INT NOT NULL,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Default Topics
INSERT INTO topics (name, name_fr, description, description_fr) VALUES
-- 1ère Année - Semestre 1
('Mathématique 1', 'Mathématique 1', 'Mathématique 1', 'Mathématique 1'),
('Algorithmique et Bases de Développement', 'Algorithmique et Bases de Développement', 'Algorithmique et Bases de Développement', 'Algorithmique et Bases de Développement'),
('Architecture Matérielle', 'Architecture Matérielle', 'Architecture Matérielle', 'Architecture Matérielle'),
('Système d''Exploitation', 'Système d''Exploitation', 'Système d''Exploitation', 'Système d''Exploitation'),
('Programmation Python', 'Programmation Python', 'Programmation Python', 'Programmation Python'),
('Méthodologie de Travail Universitaire', 'Méthodologie de Travail Universitaire', 'Méthodologie de Travail Universitaire', 'Méthodologie de Travail Universitaire'),
('Langues (Français, Anglais) S1', 'Langues (Français, Anglais) S1', 'Langues (Français, Anglais) S1', 'Langues (Français, Anglais) S1'),
-- 1ère Année - Semestre 2
('Réseaux Informatiques', 'Réseaux Informatiques', 'Réseaux Informatiques', 'Réseaux Informatiques'),
('Bases de Données', 'Bases de Données', 'Bases de Données', 'Bases de Données'),
('Technologies Web', 'Technologies Web', 'Technologies Web', 'Technologies Web'),
('Structure de données en C', 'Structure de données en C', 'Structure de données en C', 'Structure de données en C'),
('Développement Web', 'Développement Web', 'Développement Web', 'Développement Web'),
('Culture Digitale', 'Culture Digitale', 'Culture Digitale', 'Culture Digitale'),
('Langues (Français, Anglais) S2', 'Langues (Français, Anglais) S2', 'Langues (Français, Anglais) S2', 'Langues (Français, Anglais) S2'),
-- 2ème Année - Semestre 3
('Mathématiques 2', 'Mathématiques 2', 'Mathématiques 2', 'Mathématiques 2'),
('Programmation Orientée Objet Java', 'Programmation Orientée Objet Java', 'Programmation Orientée Objet Java', 'Programmation Orientée Objet Java'),
('Ingénierie Logicielle', 'Ingénierie Logicielle', 'Ingénierie Logicielle', 'Ingénierie Logicielle'),
('Analyse et COO - UML', 'Analyse et COO - UML', 'Analyse et COO - UML', 'Analyse et COO - UML'),
('Programmation Java Avancée', 'Programmation Java Avancée', 'Programmation Java Avancée', 'Programmation Java Avancée'),
('Bases de Données Avancées', 'Bases de Données Avancées', 'Bases de Données Avancées', 'Bases de Données Avancées'),
('Conduite de projet informatique et planification agile', 'Conduite de projet', 'Conduite de projet', 'Conduite de projet'),
-- 2ème Année - Semestre 4
('Développement Mobile', 'Développement Mobile', 'Développement Mobile', 'Développement Mobile'),
('Technologie JEE', 'Technologie JEE', 'Technologie JEE', 'Technologie JEE'),
('Introduction à l''IA', 'Introduction à l''IA', 'Introduction à l''IA', 'Introduction à l''IA'),
('Complexité Computationnelle', 'Complexité Computationnelle', 'Complexité Computationnelle', 'Complexité Computationnelle')
ON CONFLICT (name) DO NOTHING;

-- Default Admin User (password is 'admin123' hashed with BCrypt)
INSERT INTO users (username, email, password, is_active, is_admin)
VALUES ('admin', 'admin@forum.com', '$2a$10$8.UnVuG9HHgffUDAlk8q2OuVGkqBKCbVqG9Le9VJ2Z1iU9qOC132i', TRUE, TRUE)
ON CONFLICT (username) DO NOTHING;
