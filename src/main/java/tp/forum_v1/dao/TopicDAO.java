package tp.forum_v1.dao;

import tp.forum_v1.model.Topic;
import tp.forum_v1.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TopicDAO {

    public List<Topic> getAllTopics() {
        List<Topic> topics = new ArrayList<>();
        String sql = "SELECT * FROM topics ORDER BY name ASC";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                topics.add(mapResultSetToTopic(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return topics;
    }

    public Topic getTopicById(int id) {
        String sql = "SELECT * FROM topics WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToTopic(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void createTopic(Topic topic) throws SQLException {
        String sql = "INSERT INTO topics (name, name_fr, description, description_fr) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, topic.getName());
            stmt.setString(2, topic.getNameFr());
            stmt.setString(3, topic.getDescription());
            stmt.setString(4, topic.getDescriptionFr());
            stmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("SQL Error in createTopic: " + e.getMessage());
            throw e;
        }
    }

    public List<Topic> searchTopics(String keyword) {
        List<Topic> topics = new ArrayList<>();
        String sql = "SELECT * FROM topics WHERE name LIKE ? OR name_fr LIKE ? OR description LIKE ? OR description_fr LIKE ? ORDER BY name ASC";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            String pattern = "%" + keyword + "%";
            stmt.setString(1, pattern);
            stmt.setString(2, pattern);
            stmt.setString(3, pattern);
            stmt.setString(4, pattern);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                topics.add(mapResultSetToTopic(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return topics;
    }

    public boolean existsTopicByName(String name) {
        String sql = "SELECT COUNT(*) FROM topics WHERE name = ? OR name_fr = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, name);
            stmt.setString(2, name);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Topic mapResultSetToTopic(ResultSet rs) throws SQLException {
        Topic topic = new Topic();
        topic.setId(rs.getInt("id"));
        topic.setName(rs.getString("name"));
        topic.setNameFr(rs.getString("name_fr"));
        topic.setDescription(rs.getString("description"));
        topic.setDescriptionFr(rs.getString("description_fr"));
        topic.setCreatedAt(rs.getTimestamp("created_at"));
        return topic;
    }
}
