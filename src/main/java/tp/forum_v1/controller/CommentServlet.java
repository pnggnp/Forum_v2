package tp.forum_v1.controller;

import tp.forum_v1.dao.CommentDAO;
import tp.forum_v1.model.Comment;
import tp.forum_v1.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/comments")
public class CommentServlet extends HttpServlet {
    private CommentDAO commentDAO = new CommentDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            Comment comment = new Comment();
            comment.setArticleId(Integer.parseInt(request.getParameter("articleId")));
            comment.setUserId(user.getId());
            comment.setContent(request.getParameter("content"));
            commentDAO.addComment(comment);
            response.sendRedirect("articles?action=details&id=" + comment.getArticleId());
        } else if ("delete".equals(action)) {
            int commentId = Integer.parseInt(request.getParameter("id"));
            int articleId = Integer.parseInt(request.getParameter("articleId"));
            // In a real app, check if user is author or admin
            commentDAO.deleteComment(commentId);
            response.sendRedirect("articles?action=details&id=" + articleId);
        }
    }
}
