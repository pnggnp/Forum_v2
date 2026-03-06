package tp.forum_v1.util;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.Statement;
import java.util.stream.Collectors;

public class DatabaseInitializer {

    public static void initialize() {
        System.out.println("Starting Database Initialization...");
        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement()) {

            // Read schema normalized to handle different line endings and comments
            InputStream is = DatabaseInitializer.class.getResourceAsStream("/schema.sql");
            if (is == null) {
                System.err.println("Could not find schema.sql in resources");
                return;
            }

            BufferedReader reader = new BufferedReader(new InputStreamReader(is, "UTF-8"));
            String sql = reader.lines()
                    .filter(line -> !line.trim().startsWith("--")) // Remove comments
                    .collect(Collectors.joining("\n"));

            // Split by semicolon but ignore semicolons inside quotes if needed (simple
            // split for now)
            String[] statements = sql.split(";");

            for (String statement : statements) {
                if (!statement.trim().isEmpty()) {
                    try {
                        stmt.execute(statement.trim());
                    } catch (Exception e) {
                        System.err.println("Error executing statement: " + statement.trim());
                        System.err.println(e.getMessage());
                    }
                }
            }
            System.out.println("Database Initialization completed successfully.");

        } catch (Exception e) {
            System.err.println("Major failure during database initialization:");
            e.printStackTrace();
        }
    }
}
