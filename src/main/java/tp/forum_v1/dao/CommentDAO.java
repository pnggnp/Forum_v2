package tp.forum_v1.dao;

import tp.forum_v1.model.Comment;
import tp.forum_v1.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CommentDAO {

    public boolean addComment(Comment comment) {
        String sql = "INSERT INTO comments (article_id, user_id, content) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, comment.getArticleId());
            stmt.setInt(2, comment.getUserId());
            stmt.setString(3, comment.getContent());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Comment> getCommentsByArticleId(int articleId) {
        List<Comment> comments = new ArrayList<>();
        String sql = "SELECT c.*, u.username FROM comments c JOIN users u ON c.user_id = u.id WHERE c.article_id = ? ORDER BY c.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, articleId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                comments.add(mapResultSetToComment(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return comments;
    }

    public boolean deleteComment(int id) {
        String sql = "DELETE FROM comments WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Comment mapResultSetToComment(ResultSet rs) throws SQLException {
        Comment comment = new Comment();
        comment.setId(rs.getInt("id"));
        comment.setArticleId(rs.getInt("article_id"));
        comment.setUserId(rs.getInt("user_id"));
        comment.setUsername(rs.getString("username"));
        comment.setContent(rs.getString("content"));
        comment.setCreatedAt(rs.getTimestamp("created_at"));
        return comment;
    }
}
