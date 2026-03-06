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

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPassword(password);

        if (userDAO.registerUser(user)) {
            User registeredUser = userDAO.findByEmail(email);

            if (registeredUser == null) {
                System.err.println("CRITICAL: User was registered but could not be found by email: " + email);
                request.setAttribute("error", "Internal registration error. Please contact support.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }

            // Generate 6-digit numeric code
            String token = String.valueOf((int) (Math.random() * 900000) + 100000);

            // SAVE TOKEN FIRST
            if (saveVerificationToken(registeredUser.getId(), token)) {
                System.out
                        .println("INFO: Verification token successfully saved for user ID: " + registeredUser.getId());

                // SEND EMAIL SECOND (ASYNCHRONOUSLY)
                final String finalEmail = email;
                final String finalToken = token;
                new Thread(() -> {
                    System.out.println("ASYNC: Starting background email dispatch to " + finalEmail);
                    boolean sent = EmailService.sendVerificationEmail(finalEmail, finalToken);
                    if (sent) {
                        System.out.println("ASYNC: Email sent successfully in background.");
                    } else {
                        System.err.println("ASYNC ERROR: Failed to send email in background.");
                    }
                }).start();

                request.setAttribute("message",
                        "Registration successful! A verification code has been sent to " + email);
                request.setAttribute("email", email);
                request.getRequestDispatcher("/verifyCode.jsp").forward(request, response);
            } else {
                System.err.println("CRITICAL: Failed to save verification token for registered user ID: "
                        + registeredUser.getId());
                request.setAttribute("error",
                        "Internal error: Failed to generate verification code. Please try again or contact support.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
            }
        } else {
            System.err.println(
                    "REGISTRATION FAILED: Possible duplicate username or email for: " + username + " / " + email);
            request.setAttribute("error", "Registration failed. Username or Email might already exist.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }

    private boolean saveVerificationToken(int userId, String token) {
        String sql = "INSERT INTO verification_tokens (user_id, token, expiry_date) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setString(2, token);

            Calendar cal = Calendar.getInstance();
            cal.add(Calendar.HOUR, 24); // Token expires in 24h
            stmt.setTimestamp(3, new java.sql.Timestamp(cal.getTimeInMillis()));

            int rows = stmt.executeUpdate();
            System.out.println("DATABASE: Verification token saved for user " + userId);
            return rows > 0;
        } catch (SQLException e) {
            System.err.println(
                    "DATABASE ERROR: Failed to save verification token for user " + userId + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
