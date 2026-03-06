package tp.forum_v1.util;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DBVerify {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection()) {
            System.out.println("Checking 'topics' table columns...");
            checkTable(conn, "topics");
            System.out.println("\nChecking 'articles' table columns...");
            checkTable(conn, "articles");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private static void checkTable(Connection conn, String tableName) throws SQLException {
        DatabaseMetaData meta = conn.getMetaData();
        try (ResultSet rs = meta.getColumns(null, null, tableName, null)) {
            while (rs.next()) {
                System.out.println("Column: " + rs.getString("COLUMN_NAME"));
            }
        }
    }
}
