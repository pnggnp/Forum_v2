package tp.forum_v1.controller;

import tp.forum_v1.dao.ArticleDAO;
import tp.forum_v1.dao.TopicDAO;
import tp.forum_v1.model.Article;
import tp.forum_v1.model.Topic;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {
    private ArticleDAO articleDAO = new ArticleDAO();
    private TopicDAO topicDAO = new TopicDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");

        if (keyword == null || keyword.trim().isEmpty()) {
            response.sendRedirect("articles");
            return;
        }

        List<Article> articles = articleDAO.searchArticles(keyword);
        List<Topic> topics = topicDAO.searchTopics(keyword);

        request.setAttribute("articles", articles);
        request.setAttribute("topics", topics);
        request.setAttribute("keyword", keyword);

        request.getRequestDispatcher("/searchResults.jsp").forward(request, response);
    }
}
