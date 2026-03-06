package tp.forum_v1.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String DEFAULT_URL_BASE = "jdbc:mysql://localhost:3306/?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true&useUnicode=yes&characterEncoding=UTF-8";
    private static final String DEFAULT_DB_NAME = "forum_db";
    private static final String DEFAULT_USER = "root";
    private static final String DEFAULT_PASSWORD = "";

    private static final String URL_BASE = getEnvOrDefault("DB_URL_BASE", DEFAULT_URL_BASE);
    private static final String DB_NAME = getEnvOrDefault("DB_NAME", DEFAULT_DB_NAME);
    private static final String USER = getEnvOrDefault("DB_USER", DEFAULT_USER);
    private static final String PASSWORD = getEnvOrDefault("DB_PASSWORD", DEFAULT_PASSWORD);

    private static final String FULL_URL = System.getenv("DB_URL");
    private static final String URL = (FULL_URL != null) ? FULL_URL : URL_BASE.replace("3306/", "3306/" + DB_NAME);

    private static String getEnvOrDefault(String key, String defaultValue) {
        String value = System.getenv(key);
        return (value != null) ? value : defaultValue;
    }

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static Connection getBaseConnection() throws SQLException {
        // For InfinityFree/Render, we always connect to the specific database
        return getConnection();
    }

    public static Connection getConnection() throws SQLException {
        System.out.println("Connecting to Database: " + (URL.contains("?") ? URL.substring(0, URL.indexOf("?")) : URL));
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
