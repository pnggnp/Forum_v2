package tp.forum_v1.util;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;

public class EmailService {
    // These should be configured correctly for a real SMTP server
    // GOOGLE SMTP CONFIGURATION
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";

    // IMPORTANT: Replace these with your actual Gmail and 16-character App Password
    private static final String SMTP_USER = "younesszarouali7@gmail.com";
    private static final String SMTP_PASS = "mkvmuwifwvpdklad";

    public static boolean sendVerificationEmail(String to, String token) {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.starttls.required", "true");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.debug", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SMTP_USER, SMTP_PASS.replaceAll("\\s+", ""));
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SMTP_USER));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject("Forum Account Verification - Your Code");

            String content = "Welcome to the Forum!\n\n"
                    + "Your verification code is: " + token + "\n\n"
                    + "Please enter this code in the application to activate your account.\n"
                    + "This code will expire in 24 hours.";
            message.setText(content);

            System.out.println("Attempting to send verification code to " + to + "...");
            Transport.send(message);
            System.out.println("SUCCESS: Verification code [" + token + "] sent to " + to);
            return true;
        } catch (MessagingException e) {
            System.err.println("CRITICAL ERROR: Failed to send email to " + to);
            System.err.println("Error Message: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
