package tp.forum_v1.controller;

import tp.forum_v1.model.User;
import tp.forum_v1.util.DBConnection;
import tp.forum_v1.dao.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.regex.Pattern;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("user");
        request.setAttribute("postCount", getUserPostCount(user.getId()));
        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }

    private int getUserPostCount(int userId) {
        String sql = "SELECT COUNT(*) FROM articles WHERE author_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next())
                return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        String username = request.getParameter("username");
        String email = request.getParameter("email");

        // Basic validation
        if (username == null || username.trim().isEmpty() || email == null || email.trim().isEmpty()) {
            response.sendRedirect("profile?error=Fields cannot be empty");
            return;
        }

        // Email validation
        String emailRegex = "^[A-Za-z0-9+_.-]+@(.+)$";
        if (!Pattern.compile(emailRegex).matcher(email).matches()) {
            response.sendRedirect("profile?error=Invalid email format");
            return;
        }

        User user = (User) session.getAttribute("user");
        user.setUsername(username.trim());
        user.setEmail(email.trim());

        UserDAO userDAO = new UserDAO();
        if (userDAO.updateUser(user)) {
            // Update session user object
            session.setAttribute("user", user);
            response.sendRedirect("profile?success=Profile updated successfully");
        } else {
            response.sendRedirect("profile?error=Failed to update profile. Email or username might be taken.");
        }
    }
}
