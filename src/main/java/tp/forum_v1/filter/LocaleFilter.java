package tp.forum_v1.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.jsp.jstl.core.Config;
import java.io.IOException;
import java.util.Locale;

@WebFilter("/*")
public class LocaleFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        if (request instanceof HttpServletRequest) {
            HttpServletRequest httpRequest = (HttpServletRequest) request;
            HttpSession session = httpRequest.getSession(false);
            if (session != null) {
                String lang = (String) session.getAttribute("lang");
                if (lang != null) {
                    Locale locale = Locale.forLanguageTag(lang);
                    Config.set(session, Config.FMT_LOCALE, locale);
                }
            }
        }
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
