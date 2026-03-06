package tp.forum_v1.controller;

import tp.forum_v1.dao.ArticleDAO;
import tp.forum_v1.model.Article;
import tp.forum_v1.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    private ArticleDAO articleDAO = new ArticleDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("user");
        List<Article> allArticles = articleDAO.getAllArticles();

        // Filter articles written by the current user
        List<Article> userArticles = allArticles.stream()
                .filter(a -> a.getAuthorId() == user.getId())
                .collect(Collectors.toList());

        request.setAttribute("userArticles", userArticles);
        request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
    }
}
