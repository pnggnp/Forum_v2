package tp.forum_v1.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String URL_BASE = "jdbc:mysql://localhost:3306/?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true&useUnicode=yes&characterEncoding=UTF-8";
    private static final String DB_NAME = "forum_db";
    private static final String URL = URL_BASE.replace("3306/", "3306/" + DB_NAME);
    private static final String USER = "root";
    private static final String PASSWORD = "";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static Connection getBaseConnection() throws SQLException {
        return DriverManager.getConnection(URL_BASE, USER, PASSWORD);
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
