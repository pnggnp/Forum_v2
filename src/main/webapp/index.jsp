<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ include file="includes/header.jsp" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

            <div class="container py-section">
                <div class="text-center mb-huge">
                    <h1>
                        <fmt:message key="app.title" />
                    </h1>
                    <p class="text-lead">
                        <fmt:message key="app.tagline" />
                    </p>

                </div>

                <div class="section-actions"
                    style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
                    <h2 style="margin: 0;">Featured Discussions</h2>
                    <c:if test="${not empty sessionScope.user}">
                        <a href="articles?action=create" class="btn btn-primary">
                            <i class="fa-solid fa-plus"></i> New Article
                        </a>
                    </c:if>
                </div>

                <div class="article-grid"
                    style="display: grid; grid-template-columns: repeat(auto-fill, minmax(350px, 1fr)); gap: 2.5rem;">
                    <c:forEach var="article" items="${articles}">
                        <div class="card article-card-list">
                            <c:if test="${not empty article.topicName}">
                                <div class="topic-badge"
                                    style="margin-bottom: 1rem; transform: scale(0.9); transform-origin: left;">
                                    <c:choose>
                                        <c:when test="${sessionScope.lang == 'fr' && not empty article.topicNameFr}">
                                            ${article.topicNameFr}
                                        </c:when>
                                        <c:otherwise>
                                            ${article.topicName}
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </c:if>
                            <h3 style="margin-bottom: 0.5rem; line-height: 1.3;">
                                <a href="articles?action=details&id=${article.id}">
                                    <c:choose>
                                        <c:when test="${sessionScope.lang == 'fr' && not empty article.titleFr}">
                                            ${article.titleFr}
                                        </c:when>
                                        <c:otherwise>
                                            ${article.title}
                                        </c:otherwise>
                                    </c:choose>
                                </a>
                            </h3>
                            <p class="meta" style="margin-bottom: 2rem; font-size: 0.85rem; opacity: 0.7;">
                                <fmt:message key="article.author" /> <strong>${article.authorName}</strong> |
                                <fmt:formatDate value="${article.createdAt}" pattern="MMM d, yyyy" />
                            </p>
                            <div class="article-excerpt"
                                style="color: var(--text-muted); font-size: 1rem; line-height: 1.6; margin-bottom: 2.5rem; flex: 1;">
                                <c:set var="displayContent"
                                    value="${(sessionScope.lang == 'fr' && not empty article.contentFr) ? article.contentFr : article.content}" />
                                <c:set var="trimmedContent" value="${fn:trim(displayContent)}" />
                                ${fn:substring(trimmedContent, 0, fn:length(trimmedContent) > 140 ? 140 :
                                fn:length(trimmedContent))}
                                <c:if test="${fn:length(trimmedContent) > 140}">...</c:if>
                            </div>
                            <a href="articles?action=details&id=${article.id}"
                                style="color: var(--primary); font-weight: 800; text-decoration: none; display: inline-flex; align-items: center; gap: 0.75rem; font-size: 0.85rem; letter-spacing: 0.05em; text-transform: uppercase;">
                                Dive Deeper <i class="fa-solid fa-arrow-right"></i>
                            </a>
                        </div>
                    </c:forEach>
                </div>

                <c:if test="${empty articles}">
                    <div class="card text-center" style="padding: 5rem;">
                        <p class="text-lead">No discussions have started yet.</p>
                    </div>
                </c:if>
            </div>

            <%@ include file="includes/footer.jsp" %>