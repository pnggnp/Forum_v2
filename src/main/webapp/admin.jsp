<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ include file="includes/header.jsp" %>

        <section style="margin-bottom: 3rem;">
            <h1>Admin Dashboard</h1>
            <p class="meta">Manage users and content.</p>
        </section>

        <div class="card">
            <h3 style="margin-bottom: 1.5rem;">User Management</h3>
            <table style="width: 100%; border-collapse: collapse;">
                <thead>
                    <tr style="text-align: left; border-bottom: 1px solid rgba(255, 255, 255, 0.1);">
                        <th style="padding: 1rem;">Username</th>
                        <th style="padding: 1rem;">Email</th>
                        <th style="padding: 1rem;">Status</th>
                        <th style="padding: 1rem;">Role</th>
                        <th style="padding: 1rem;">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="u" items="${users}">
                        <tr style="border-bottom: 1px solid rgba(255, 255, 255, 0.05);">
                            <td style="padding: 1rem;">${u.username}</td>
                            <td style="padding: 1rem;">${u.email}</td>
                            <td style="padding: 1rem;">
                                <span class="${u.active ? 'status-active' : 'status-pending'}">
                                    ${u.active ? 'Active' : 'Pending'}
                                </span>
                            </td>
                            <td style="padding: 1rem;">${u.admin ? 'Admin' : 'User'}</td>
                            <td style="padding: 1rem;">
                                <c:if test="${!u.admin}">
                                    <a href="#" style="color: var(--danger); font-size: 0.875rem;">Ban</a>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <div class="card" style="margin-top: 3rem;">
            <h3 style="margin-bottom: 1.5rem;">Article Moderation</h3>
            <table style="width: 100%; border-collapse: collapse;">
                <thead>
                    <tr style="text-align: left; border-bottom: 1px solid rgba(255, 255, 255, 0.1);">
                        <th style="padding: 1rem;">Title</th>
                        <th style="padding: 1rem;">Author</th>
                        <th style="padding: 1rem;">Date</th>
                        <th style="padding: 1rem;">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="a" items="${articles}">
                        <tr style="border-bottom: 1px solid rgba(255, 255, 255, 0.05);">
                            <td style="padding: 1rem;">${a.title}</td>
                            <td style="padding: 1rem;">${a.authorName}</td>
                            <td style="padding: 1rem;">
                                <fmt:formatDate value="${a.createdAt}" pattern="MMM d, yyyy" />
                            </td>
                            <td style="padding: 1rem;">
                                <form action="admin" method="post" style="display: inline;">
                                    <input type="hidden" name="action" value="deleteArticle">
                                    <input type="hidden" name="id" value="${a.id}">
                                    <button type="submit"
                                        style="background: none; border: none; color: var(--danger); cursor: pointer;"
                                        onclick="return confirm('Delete this article?')">Delete</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <%@ include file="includes/footer.jsp" %>