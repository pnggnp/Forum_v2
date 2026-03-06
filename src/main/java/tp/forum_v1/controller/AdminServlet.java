package tp.forum_v1.controller;

import tp.forum_v1.dao.UserDAO;
import tp.forum_v1.dao.ArticleDAO;
import tp.forum_v1.dao.CommentDAO;
import tp.forum_v1.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
    private ArticleDAO articleDAO = new ArticleDAO();
    private CommentDAO commentDAO = new CommentDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = checkAdmin(request, response);
        if (user == null)
            return;

        request.setAttribute("users", userDAO.findAll());
        request.setAttribute("articles", articleDAO.getAllArticles());
        request.getRequestDispatcher("/admin.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = checkAdmin(request, response);
        if (user == null)
            return;

        String action = request.getParameter("action");
        if ("deleteArticle".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            articleDAO.deleteArticle(id);
        } else if ("deleteComment".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            commentDAO.deleteComment(id);
        }
        response.sendRedirect("admin");
    }

    private User checkAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return null;
        }
        User user = (User) session.getAttribute("user");
        if (!user.isAdmin()) {
            response.sendRedirect("articles");
            return null;
        }
        return user;
    }
}
