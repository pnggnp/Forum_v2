package tp.forum_v1.controller;

import tp.forum_v1.dao.ArticlePhotoDAO;
import tp.forum_v1.model.ArticlePhoto;
import tp.forum_v1.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.util.UUID;

@WebServlet("/uploadPhoto")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 5, maxRequestSize = 1024 * 1024 * 5 * 5)
public class PhotoUploadServlet extends HttpServlet {
    private ArticlePhotoDAO photoDAO = new ArticlePhotoDAO();
    private static final String UPLOAD_DIR = "uploads" + File.separator + "articles";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }
        User user = (User) session.getAttribute("user");
        int articleId = Integer.parseInt(request.getParameter("articleId"));

        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists())
            uploadDir.mkdirs();

        for (Part part : request.getParts()) {
            String fileName = getFileName(part);
            if (fileName != null && !fileName.isEmpty()) {
                String extension = fileName.substring(fileName.lastIndexOf("."));
                String newFileName = UUID.randomUUID().toString() + extension;
                part.write(uploadPath + File.separator + newFileName);

                ArticlePhoto photo = new ArticlePhoto();
                photo.setArticleId(articleId);
                photo.setPhotoUrl(UPLOAD_DIR + "/" + newFileName);
                photo.setUploaderId(user.getId());
                photoDAO.addPhoto(photo);
            }
        }
        response.sendRedirect("articles?action=details&id=" + articleId);
    }

    private String getFileName(Part part) {
        for (String content : part.getHeader("content-disposition").split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf("=") + 2, content.length() - 1);
            }
        }
        return null;
    }
}
