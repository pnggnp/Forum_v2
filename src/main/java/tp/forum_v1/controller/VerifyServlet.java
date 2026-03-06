package tp.forum_v1.controller;

import tp.forum_v1.dao.UserDAO;
import tp.forum_v1.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/verify")
public class VerifyServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/verifyCode.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String code = request.getParameter("code");
        if (code == null || code.isEmpty()) {
            request.setAttribute("error", "Please enter the verification code.");
            request.getRequestDispatcher("/verifyCode.jsp").forward(request, response);
            return;
        }

        int userId = getUserIdByToken(code);
        if (userId != -1) {
            if (userDAO.activateUser(userId)) {
                deleteToken(code);
                request.setAttribute("message", "Your account has been verified! You can now login.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Verification failed. Please try again.");
                request.getRequestDispatcher("/verifyCode.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "Invalid or expired verification code.");
            request.getRequestDispatcher("/verifyCode.jsp").forward(request, response);
        }
    }

    private int getUserIdByToken(String token) {
        String sql = "SELECT user_id FROM verification_tokens WHERE token = ? AND expiry_date > NOW()";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, token);
            ResultSet rs = stmt.executeQuery();
            if (rs.next())
                return rs.getInt("user_id");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    private void deleteToken(String token) {
        String sql = "DELETE FROM verification_tokens WHERE token = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, token);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
