package tp.forum_v1.controller;

import tp.forum_v1.dao.ArticleDAO;
import tp.forum_v1.dao.ArticlePhotoDAO;
import tp.forum_v1.dao.CommentDAO;
import tp.forum_v1.dao.TopicDAO;
import tp.forum_v1.model.Article;
import tp.forum_v1.model.ArticlePhoto;
import tp.forum_v1.model.Comment;
import tp.forum_v1.model.Topic;
import tp.forum_v1.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.util.UUID;
import java.util.List;

@WebServlet("/articles")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 5, maxRequestSize = 1024 * 1024 * 5 * 5)
public class ArticleServlet extends HttpServlet {
    private static final String UPLOAD_DIR = "uploads" + File.separator + "articles";
    private ArticleDAO articleDAO = new ArticleDAO();
    private TopicDAO topicDAO = new TopicDAO();
    private ArticlePhotoDAO photoDAO = new ArticlePhotoDAO();
    private CommentDAO commentDAO = new CommentDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null)
            action = "list";

        switch (action) {
            case "details":
                showDetails(request, response);
                break;
            case "create":
                showCreateForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteArticle(request, response);
                break;
            case "search":
                searchArticles(request, response);
                break;
            default:
                listArticles(request, response);
                break;
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("save".equals(action)) {
            saveArticle(request, response);
        } else if ("update".equals(action)) {
            updateArticle(request, response);
        }
    }

    private void listArticles(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Article> articles = articleDAO.getAllArticles();
        request.setAttribute("articles", articles);
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    private void showDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (checkAuth(request, response) == null)
            return;
        int id = Integer.parseInt(request.getParameter("id"));
        Article article = articleDAO.getArticleById(id);
        List<ArticlePhoto> photos = photoDAO.getPhotosByArticleId(id);
        List<Comment> comments = commentDAO.getCommentsByArticleId(id);
        request.setAttribute("article", article);
        request.setAttribute("photos", photos);
        request.setAttribute("comments", comments);
        request.getRequestDispatcher("/articleDetails.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        checkAuth(request, response);
        List<Topic> topics = topicDAO.getAllTopics();
        request.setAttribute("topics", topics);
        request.getRequestDispatcher("/createArticle.jsp").forward(request, response);
    }

    private void saveArticle(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = checkAuth(request, response);
        if (user == null)
            return;

        String title = request.getParameter("title");
        String titleFr = request.getParameter("title_fr");
        String content = request.getParameter("content");
        String contentFr = request.getParameter("content_fr");

        // Bidirectional Fallbacks
        if ((titleFr == null || titleFr.trim().isEmpty()) && title != null && !title.trim().isEmpty()) {
            titleFr = title;
        }
        if ((title == null || title.trim().isEmpty()) && titleFr != null && !titleFr.trim().isEmpty()) {
            title = titleFr;
        }
        if ((contentFr == null || contentFr.trim().isEmpty()) && content != null && !content.trim().isEmpty()) {
            contentFr = content;
        }
        if ((content == null || content.trim().isEmpty()) && contentFr != null && !contentFr.trim().isEmpty()) {
            content = contentFr;
        }

        Article article = new Article();
        article.setTitle(title);
        article.setTitleFr(titleFr);
        article.setContent(content);
        article.setContentFr(contentFr);
        article.setAuthorId(user.getId());

        String topicIdStr = request.getParameter("topicId");
        if (topicIdStr != null && !topicIdStr.isEmpty()) {
            article.setTopicId(Integer.parseInt(topicIdStr));
        }

        if (articleDAO.createArticle(article)) {
            // Handle optional photo upload
            try {
                Part part = request.getPart("photo");
                if (part != null && part.getSize() > 0) {
                    processPhotoUpload(request, article.getId(), user.getId(), part);
                }
            } catch (Exception e) {
                System.err.println("Optional photo upload failed: " + e.getMessage());
            }
            response.sendRedirect("articles?action=details&id=" + article.getId());
        } else {
            List<Topic> topics = topicDAO.getAllTopics();
            request.setAttribute("topics", topics);
            request.setAttribute("error", "Failed to create article.");
            request.getRequestDispatcher("/createArticle.jsp").forward(request, response);
        }
    }

    private void processPhotoUpload(HttpServletRequest request, int articleId, int userId, Part part)
            throws IOException {
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists())
            uploadDir.mkdirs();

        String fileName = getFileName(part);
        if (fileName != null && !fileName.isEmpty()) {
            String extension = fileName.substring(fileName.lastIndexOf("."));
            String newFileName = UUID.randomUUID().toString() + extension;
            part.write(uploadPath + File.separator + newFileName);

            ArticlePhoto photo = new ArticlePhoto();
            photo.setArticleId(articleId);
            photo.setPhotoUrl(UPLOAD_DIR + "/" + newFileName);
            photo.setUploaderId(userId);
            photoDAO.addPhoto(photo);
        }
    }

    private String getFileName(Part part) {
        for (String content : part.getHeader("content-disposition").split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf("=") + 2, content.length() - 1);
            }
        }
        return null;
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = checkAuth(request, response);
        if (user == null)
            return;

        int id = Integer.parseInt(request.getParameter("id"));
        Article article = articleDAO.getArticleById(id);

        if (article != null && (article.getAuthorId() == user.getId() || user.isAdmin())) {
            request.setAttribute("article", article);
            request.getRequestDispatcher("/editArticle.jsp").forward(request, response);
        } else {
            response.sendRedirect("articles");
        }
    }

    private void updateArticle(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = checkAuth(request, response);
        if (user == null)
            return;

        Article article = new Article();
        article.setId(Integer.parseInt(request.getParameter("id")));
        String title = request.getParameter("title");
        String titleFr = request.getParameter("title_fr");
        String content = request.getParameter("content");
        String contentFr = request.getParameter("content_fr");

        // Bidirectional Fallbacks
        if ((titleFr == null || titleFr.trim().isEmpty()) && title != null && !title.trim().isEmpty()) {
            titleFr = title;
        }
        if ((title == null || title.trim().isEmpty()) && titleFr != null && !titleFr.trim().isEmpty()) {
            title = titleFr;
        }
        if ((contentFr == null || contentFr.trim().isEmpty()) && content != null && !content.trim().isEmpty()) {
            contentFr = content;
        }
        if ((content == null || content.trim().isEmpty()) && contentFr != null && !contentFr.trim().isEmpty()) {
            content = contentFr;
        }

        article.setTitle(title);
        article.setTitleFr(titleFr);
        article.setContent(content);
        article.setContentFr(contentFr);

        if (articleDAO.updateArticle(article)) {
            response.sendRedirect("articles?action=details&id=" + article.getId());
        } else {
            response.sendRedirect("articles");
        }
    }

    private void deleteArticle(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = checkAuth(request, response);
        if (user == null)
            return;

        int id = Integer.parseInt(request.getParameter("id"));
        Article article = articleDAO.getArticleById(id);

        if (article != null && (article.getAuthorId() == user.getId() || user.isAdmin())) {
            articleDAO.deleteArticle(id);
        }
        response.sendRedirect("articles");
    }

    private void searchArticles(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        List<Article> articles = articleDAO.searchArticles(keyword);
        request.setAttribute("articles", articles);
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    private User checkAuth(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return null;
        }
        return (User) session.getAttribute("user");
    }
}
