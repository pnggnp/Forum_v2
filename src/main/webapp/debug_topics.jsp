<%@ page import="tp.forum_v1.dao.TopicDAO" %>
    <%@ page import="tp.forum_v1.model.Topic" %>
        <%@ page import="java.util.List" %>
            <%@ page contentType="text/html;charset=UTF-8" language="java" %>
                <html>

                <body>
                    <h2>Current Topics in Database:</h2>
                    <ul>
                        <% TopicDAO dao=new TopicDAO(); List<Topic> topics = dao.getAllTopics();
                            for (Topic t : topics) {
                            %>
                            <li>ID: <%= t.getId() %>, Name: <%= t.getName() %>, Name FR: <%= t.getNameFr() %>
                            </li>
                            <% } %>
                    </ul>
                </body>

                </html>