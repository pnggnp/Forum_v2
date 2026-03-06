package tp.forum_v1.model;

import java.sql.Timestamp;

public class Article {
    private int id;
    private String title;
    private String titleFr;
    private String content;
    private String content_fr;
    private int authorId;
    private String authorName; // Extra field for JSP display
    private int topicId;
    private String topicName; // Extra field for JSP display
    private String topicNameFr; // Extra field for JSP display
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public Article() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getTitleFr() {
        return titleFr;
    }

    public void setTitleFr(String titleFr) {
        this.titleFr = titleFr;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getContentFr() {
        return content_fr;
    }

    public void setContentFr(String content_fr) {
        this.content_fr = content_fr;
    }

    public int getAuthorId() {
        return authorId;
    }

    public void setAuthorId(int authorId) {
        this.authorId = authorId;
    }

    public String getAuthorName() {
        return authorName;
    }

    public void setAuthorName(String authorName) {
        this.authorName = authorName;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public int getTopicId() {
        return topicId;
    }

    public void setTopicId(int topicId) {
        this.topicId = topicId;
    }

    public String getTopicName() {
        return topicName;
    }

    public void setTopicName(String topicName) {
        this.topicName = topicName;
    }

    public String getTopicNameFr() {
        return topicNameFr;
    }

    public void setTopicNameFr(String topicNameFr) {
        this.topicNameFr = topicNameFr;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
}
