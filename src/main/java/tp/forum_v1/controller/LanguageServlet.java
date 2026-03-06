package tp.forum_v1.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.jsp.jstl.core.Config;
import java.io.IOException;
import java.util.Locale;

@WebServlet("/language")
public class LanguageServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String lang = request.getParameter("lang");
        if (lang != null && (lang.equals("en") || lang.equals("fr"))) {
            HttpSession session = request.getSession();
            Locale locale = Locale.forLanguageTag(lang);

            // Set for JSTL
            Config.set(session, Config.FMT_LOCALE, locale);
            session.setAttribute("lang", lang);
        }

        // Redirect back to the referring page
        String referer = request.getHeader("referer");
        if (referer == null || referer.isEmpty()) {
            referer = request.getContextPath() + "/articles";
        }
        response.sendRedirect(referer);
    }
}
