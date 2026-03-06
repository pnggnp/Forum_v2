package tp.forum_v1.controller;

import tp.forum_v1.dao.UserDAO;
import tp.forum_v1.model.User;
import tp.forum_v1.util.EmailService;
import tp.forum_v1.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Calendar;

@WebServlet("/resend-code")
public class ResendCodeServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");

        if (email == null || email.isEmpty()) {
            request.setAttribute("error", "Email is required to resend the code.");
            request.getRequestDispatcher("/verifyCode.jsp").forward(request, response);
            return;
        }

        User user = userDAO.findByEmail(email);
        if (user == null) {
            request.setAttribute("error", "No account found with that email.");
            request.getRequestDispatcher("/verifyCode.jsp").forward(request, response);
            return;
        }

        if (user.isActive()) {
            request.setAttribute("message", "Your account is already verified. Please login.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Generate new 6-digit numeric code
        String token = String.valueOf((int) (Math.random() * 900000) + 100000);
        saveVerificationToken(user.getId(), token);

        // SEND EMAIL (ASYNCHRONOUSLY)
        final String finalEmail = email;
        final String finalToken = token;
        new Thread(() -> {
            System.out.println("ASYNC: Starting background resend dispatch to " + finalEmail);
            boolean sent = EmailService.sendVerificationEmail(finalEmail, finalToken);
            if (sent) {
                System.out.println("ASYNC: Resend email sent successfully in background.");
            } else {
                System.err.println("ASYNC ERROR: Failed to resend email in background.");
            }
        }).start();

        request.setAttribute("message", "A new verification code has been sent to " + email);
        request.setAttribute("email", email);
        request.getRequestDispatcher("/verifyCode.jsp").forward(request, response);
    }

    private void saveVerificationToken(int userId, String token) {
        // Delete old tokens first to keep it clean
        String deleteSql = "DELETE FROM verification_tokens WHERE user_id = ?";
        String insertSql = "INSERT INTO verification_tokens (user_id, token, expiry_date) VALUES (?, ?, ?)";

        try (Connection conn = DBConnection.getConnection()) {
            // Delete
            try (PreparedStatement deleteStmt = conn.prepareStatement(deleteSql)) {
                deleteStmt.setInt(1, userId);
                deleteStmt.executeUpdate();
            }

            // Insert
            try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                insertStmt.setInt(1, userId);
                insertStmt.setString(2, token);
                Calendar cal = Calendar.getInstance();
                cal.add(Calendar.HOUR, 24);
                insertStmt.setTimestamp(3, new java.sql.Timestamp(cal.getTimeInMillis()));
                insertStmt.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
