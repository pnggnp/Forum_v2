<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ include file="includes/header.jsp" %>

        <div class="container py-section">
            <div style="margin-bottom: 3rem;">
                <h1>
                    <fmt:message key="dashboard.welcome" />, ${sessionScope.user.username}
                </h1>
                <p class="text-lead">Monitor your platform activity and performance.</p>
            </div>

            <div class="stat-grid">
                <div class="card text-center">
                    <p class="meta" style="margin-bottom: 0.5rem;">CONTRIBUTIONS</p>
                    <p class="stat-value">${userArticles.size()}</p>
                </div>
                <div class="card text-center">
                    <p class="meta" style="margin-bottom: 0.5rem;">ACCOUNT LEVEL</p>
                    <p class="stat-value" style="font-size: 2rem; margin-top: 1rem;">
                        <span style="color: var(--success);">${sessionScope.user.active ? "VERIFIED" : "PENDING"}</span>
                    </p>
                </div>
                <div class="card text-center">
                    <p class="meta" style="margin-bottom: 0.5rem;">JOINED STATUS</p>
                    <p class="stat-value" style="font-size: 1.5rem; margin-top: 1.25rem;">
                        <fmt:formatDate value="${sessionScope.user.joinDate}" pattern="MMMM yyyy" />
                    </p>
                </div>
            </div>

            <div style="margin-top: 4rem;">
                <h2 style="margin-bottom: 2rem;">
                    <fmt:message key="dashboard.recent_activity" />
                </h2>

                <div style="display: grid; gap: 1rem;">
                    <c:forEach var="article" items="${userArticles}">
                        <div class="card"
                            style="padding: 1.5rem; display: flex; justify-content: space-between; align-items: center; background: rgba(0,0,0,0.1);">
                            <div>
                                <h4 style="margin: 0;"><a href="articles?action=details&id=${article.id}"
                                        style="color: inherit; text-decoration: none;">
                                        <c:choose>
                                            <c:when test="${sessionScope.lang == 'fr' && not empty article.titleFr}">
                                                ${article.titleFr}
                                            </c:when>
                                            <c:otherwise>
                                                ${article.title}
                                            </c:otherwise>
                                        </c:choose>
                                    </a></h4>
                                <p class="meta" style="margin: 0.25rem 0 0;">Published on
                                    <fmt:formatDate value="${article.createdAt}" pattern="MMM d, yyyy" />
                                </p>
                            </div>
                            <div style="display: flex; gap: 1rem;">
                                <a href="articles?action=edit&id=${article.id}" class="btn btn-outline"
                                    style="padding: 0.5rem 1rem; font-size: 0.85rem;">Edit</a>
                                <a href="articles?action=delete&id=${article.id}" class="btn btn-outline"
                                    style="padding: 0.5rem 1rem; font-size: 0.85rem; border-color: var(--danger); color: var(--danger);"
                                    onclick="return confirm('Are you sure?')">Remove</a>
                            </div>
                        </div>
                    </c:forEach>

                    <c:if test="${empty userArticles}">
                        <div class="card text-center" style="padding: 3rem;">
                            <p class="text-muted">You haven't shared any insights yet.</p>
                            <a href="articles?action=create" class="btn btn-primary" style="margin-top: 1.5rem;">Create
                                Your
                                First Article</a>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <%@ include file="includes/footer.jsp" %>