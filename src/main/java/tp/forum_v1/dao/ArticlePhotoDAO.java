package tp.forum_v1.dao;

import tp.forum_v1.model.ArticlePhoto;
import tp.forum_v1.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ArticlePhotoDAO {

    public List<ArticlePhoto> getPhotosByArticleId(int articleId) {
        List<ArticlePhoto> photos = new ArrayList<>();
        String sql = "SELECT p.*, u.username as uploader_name " +
                "FROM article_photos p " +
                "JOIN users u ON p.uploader_id = u.id " +
                "WHERE p.article_id = ? ORDER BY p.uploaded_at DESC";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, articleId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                photos.add(mapResultSetToPhoto(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return photos;
    }

    public boolean addPhoto(ArticlePhoto photo) {
        String sql = "INSERT INTO article_photos (article_id, photo_url, uploader_id) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, photo.getArticleId());
            stmt.setString(2, photo.getPhotoUrl());
            stmt.setInt(3, photo.getUploaderId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deletePhoto(int id) {
        String sql = "DELETE FROM article_photos WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private ArticlePhoto mapResultSetToPhoto(ResultSet rs) throws SQLException {
        ArticlePhoto photo = new ArticlePhoto();
        photo.setId(rs.getInt("id"));
        photo.setArticleId(rs.getInt("article_id"));
        photo.setPhotoUrl(rs.getString("photo_url"));
        photo.setUploaderId(rs.getInt("uploader_id"));
        photo.setUploaderName(rs.getString("uploader_name"));
        photo.setUploadedAt(rs.getTimestamp("uploaded_at"));
        return photo;
    }
}
