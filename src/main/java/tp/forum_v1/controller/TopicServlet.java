package tp.forum_v1.controller;

import tp.forum_v1.dao.ArticleDAO;
import tp.forum_v1.dao.TopicDAO;
import tp.forum_v1.model.Article;
import tp.forum_v1.model.Topic;
import tp.forum_v1.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/topics")
public class TopicServlet extends HttpServlet {
    private TopicDAO topicDAO = new TopicDAO();
    private ArticleDAO articleDAO = new ArticleDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null)
            action = "list";

        switch (action) {
            case "view":
                viewTopic(request, response);
                break;
            case "create":
                showCreateForm(request, response);
                break;
            default:
                listTopics(request, response);
                break;
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("save".equals(action)) {
            saveTopic(request, response);
        }
    }

    private void listTopics(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Topic> topics = topicDAO.getAllTopics();
        request.setAttribute("topics", topics);
        request.getRequestDispatcher("/topics.jsp").forward(request, response);
    }

    private void viewTopic(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (checkAuth(request, response) == null)
            return;
        int id = Integer.parseInt(request.getParameter("id"));
        Topic topic = topicDAO.getTopicById(id);
        List<Article> articles = articleDAO.getArticlesByTopicId(id);

        request.setAttribute("topic", topic);
        request.setAttribute("articles", articles);
        request.getRequestDispatcher("/topicArticles.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = checkAuth(request, response);
        if (user == null)
            return;
        request.getRequestDispatcher("/createTopic.jsp").forward(request, response);
    }

    private void saveTopic(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = checkAuth(request, response);
        if (user == null)
            return;

        String name = request.getParameter("name");
        String nameFr = request.getParameter("name_fr");
        String description = request.getParameter("description");
        String descriptionFr = request.getParameter("description_fr");

        if (name != null)
            name = name.trim();
        if (nameFr != null)
            nameFr = nameFr.trim();
        if (description != null)
            description = description.trim();
        if (descriptionFr != null)
            descriptionFr = descriptionFr.trim();

        // Robust bidirectional fallbacks if JS auto-translation didn't catch it
        if ((nameFr == null || nameFr.trim().isEmpty()) && name != null && !name.trim().isEmpty()) {
            nameFr = name;
        }
        if ((name == null || name.trim().isEmpty()) && nameFr != null && !nameFr.trim().isEmpty()) {
            name = nameFr;
        }
        if ((descriptionFr == null || descriptionFr.trim().isEmpty()) && description != null
                && !description.trim().isEmpty()) {
            descriptionFr = description;
        }
        if ((description == null || description.trim().isEmpty()) && descriptionFr != null
                && !descriptionFr.trim().isEmpty()) {
            description = descriptionFr;
        }

        Topic topic = new Topic();
        topic.setName(name);
        topic.setNameFr(nameFr);
        topic.setDescription(description);
        topic.setDescriptionFr(descriptionFr);

        if (topicDAO.existsTopicByName(name)) {
            request.setAttribute("error", "A topic with the name '" + name + "' already exists.");
            request.getRequestDispatcher("/createTopic.jsp").forward(request, response);
            return;
        }
        if (nameFr != null && !nameFr.equals(name) && topicDAO.existsTopicByName(nameFr)) {
            request.setAttribute("error", "A topic with the French name '" + nameFr + "' already exists.");
            request.getRequestDispatcher("/createTopic.jsp").forward(request, response);
            return;
        }

        try {
            topicDAO.createTopic(topic);
            response.sendRedirect("topics");
        } catch (SQLException e) {
            String errorMsg = "Failed to create topic.";
            if (e.getMessage().toLowerCase().contains("duplicate")) {
                errorMsg = "This topic (or its translation) already exists in the database.";
            } else {
                errorMsg += " Technical details: " + e.getMessage();
            }
            request.setAttribute("error", errorMsg);
            request.getRequestDispatcher("/createTopic.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An unexpected error occurred: " + e.getMessage());
            request.getRequestDispatcher("/createTopic.jsp").forward(request, response);
        }
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
