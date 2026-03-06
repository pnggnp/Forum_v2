package tp.forum_v1.dao;

import tp.forum_v1.model.Article;
import tp.forum_v1.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ArticleDAO {

    public boolean createArticle(Article article) {
        String sql = "INSERT INTO articles (title, title_fr, content, content_fr, author_id, topic_id) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, article.getTitle());
            stmt.setString(2, article.getTitleFr());
            stmt.setString(3, article.getContent());
            stmt.setString(4, article.getContentFr());
            stmt.setInt(5, article.getAuthorId());
            if (article.getTopicId() > 0) {
                stmt.setInt(6, article.getTopicId());
            } else {
                stmt.setNull(6, Types.INTEGER);
            }
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next())
                        article.setId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Database Error in createArticle: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public List<Article> getAllArticles() {
        List<Article> articles = new ArrayList<>();
        String sql = "SELECT a.*, u.username as author_name, t.name as topic_name, t.name_fr as topic_name_fr " +
                "FROM articles a " +
                "JOIN users u ON a.author_id = u.id " +
                "LEFT JOIN topics t ON a.topic_id = t.id " +
                "ORDER BY a.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                articles.add(mapResultSetToArticle(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return articles;
    }

    public Article getArticleById(int id) {
        String sql = "SELECT a.*, u.username as author_name, t.name as topic_name, t.name_fr as topic_name_fr " +
                "FROM articles a " +
                "JOIN users u ON a.author_id = u.id " +
                "LEFT JOIN topics t ON a.topic_id = t.id " +
                "WHERE a.id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToArticle(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Article> getArticlesByTopicId(int topicId) {
        List<Article> articles = new ArrayList<>();
        String sql = "SELECT a.*, u.username as author_name, t.name as topic_name, t.name_fr as topic_name_fr " +
                "FROM articles a " +
                "JOIN users u ON a.author_id = u.id " +
                "LEFT JOIN topics t ON a.topic_id = t.id " +
                "WHERE a.topic_id = ? " +
                "ORDER BY a.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, topicId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                articles.add(mapResultSetToArticle(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return articles;
    }

    public List<Article> searchArticles(String keyword) {
        List<Article> articles = new ArrayList<>();
        String sql = "SELECT a.*, u.username as author_name, t.name as topic_name, t.name_fr as topic_name_fr " +
                "FROM articles a " +
                "JOIN users u ON a.author_id = u.id " +
                "LEFT JOIN topics t ON a.topic_id = t.id " +
                "WHERE a.title LIKE ? OR a.title_fr LIKE ? OR a.content LIKE ? OR a.content_fr LIKE ? ORDER BY a.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            String pattern = "%" + keyword + "%";
            stmt.setString(1, pattern);
            stmt.setString(2, pattern);
            stmt.setString(3, pattern);
            stmt.setString(4, pattern);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                articles.add(mapResultSetToArticle(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return articles;
    }

    public boolean updateArticle(Article article) {
        String sql = "UPDATE articles SET title = ?, title_fr = ?, content = ?, content_fr = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, article.getTitle());
            stmt.setString(2, article.getTitleFr());
            stmt.setString(3, article.getContent());
            stmt.setString(4, article.getContentFr());
            stmt.setInt(5, article.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteArticle(int id) {
        String sql = "DELETE FROM articles WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Article mapResultSetToArticle(ResultSet rs) throws SQLException {
        Article article = new Article();
        article.setId(rs.getInt("id"));
        article.setTitle(rs.getString("title"));
        article.setTitleFr(rs.getString("title_fr"));
        article.setContent(rs.getString("content"));
        article.setContentFr(rs.getString("content_fr"));
        article.setAuthorId(rs.getInt("author_id"));
        article.setAuthorName(rs.getString("author_name"));
        article.setTopicId(rs.getInt("topic_id"));
        article.setTopicName(rs.getString("topic_name"));
        article.setTopicNameFr(rs.getString("topic_name_fr"));
        article.setCreatedAt(rs.getTimestamp("created_at"));
        article.setUpdatedAt(rs.getTimestamp("updated_at"));
        return article;
    }
}
