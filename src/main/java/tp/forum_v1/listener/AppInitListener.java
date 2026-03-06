package tp.forum_v1.listener;

import tp.forum_v1.util.DatabaseInitializer;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class AppInitListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("Application Context Initialized. Running Database Setup...");
        DatabaseInitializer.initialize();
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("Application Context Destroyed.");
    }
}
