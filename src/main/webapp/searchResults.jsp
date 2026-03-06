<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ include file="includes/header.jsp" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

            <div class="container py-section">
                <div class="mb-huge">
                    <nav aria-label="breadcrumb">
                        <ul class="breadcrumb">
                            <li><a href="articles">Home</a></li>
                            <li class="separator">/</li>
                            <li class="current">Search Results</li>
                        </ul>
                    </nav>
                    <h1 style="margin-bottom: 1rem;">Search Results for "${keyword}"</h1>
                    <p class="text-lead">
                        Found ${fn:length(articles)} articles and ${fn:length(topics)} topics.
                    </p>
                </div>

                <!-- Topics Results -->
                <c:if test="${not empty topics}">
                    <div style="margin-bottom: 5rem;">
                        <h2 style="margin-bottom: 2rem; display: flex; align-items: center; gap: 1rem;">
                            <i class="fa-solid fa-tags" style="color: var(--primary);"></i> Topics
                        </h2>
                        <div class="article-grid"
                            style="display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 2rem;">
                            <c:forEach var="topic" items="${topics}">
                                <div class="card topic-card">
                                    <h3 style="margin-bottom: 1rem;">
                                        <a href="topics?action=view&id=${topic.id}"
                                            style="color: inherit; text-decoration: none;">
                                            <c:choose>
                                                <c:when test="${sessionScope.lang == 'fr' && not empty topic.nameFr}">
                                                    ${topic.nameFr}
                                                </c:when>
                                                <c:otherwise>
                                                    ${topic.name}
                                                </c:otherwise>
                                            </c:choose>
                                        </a>
                                    </h3>
                                    <p
                                        style="color: var(--text-muted); font-size: 0.95rem; margin-bottom: 2rem; flex: 1;">
                                        <c:choose>
                                            <c:when
                                                test="${sessionScope.lang == 'fr' && not empty topic.descriptionFr}">
                                                ${topic.descriptionFr}
                                            </c:when>
                                            <c:otherwise>
                                                ${topic.description}
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                    <a href="topics?action=view&id=${topic.id}"
                                        style="color: var(--primary); font-weight: 700; text-decoration: none; font-size: 0.85rem; text-transform: uppercase;">
                                        Explore Topic <i class="fa-solid fa-arrow-right"></i>
                                    </a>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>

                <!-- Article Results -->
                <c:if test="${not empty articles}">
                    <div>
                        <h2 style="margin-bottom: 2rem; display: flex; align-items: center; gap: 1rem;">
                            <i class="fa-solid fa-newspaper" style="color: var(--primary);"></i> Articles
                        </h2>
                        <div class="article-grid"
                            style="display: grid; grid-template-columns: repeat(auto-fill, minmax(350px, 1fr)); gap: 2.5rem;">
                            <c:forEach var="article" items="${articles}">
                                <div class="card article-card-list">
                                    <c:if test="${not empty article.topicName}">
                                        <div class="topic-badge"
                                            style="margin-bottom: 1rem; transform: scale(0.9); transform-origin: left;">
                                            <c:choose>
                                                <c:when
                                                    test="${sessionScope.lang == 'fr' && not empty article.topicNameFr}">
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
                                                <c:when
                                                    test="${sessionScope.lang == 'fr' && not empty article.titleFr}">
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
                                        View Details <i class="fa-solid fa-arrow-right"></i>
                                    </a>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>

                <c:if test="${empty articles && empty topics}">
                    <div class="empty-state">
                        <i class="fa-solid fa-magnifying-glass"></i>
                        <h2>No results found</h2>
                        <p class="text-lead">We couldn't find any articles or topics matching "${keyword}".</p>
                        <div style="margin-top: 3rem;">
                            <a href="articles" class="btn btn-primary">Back to Home</a>
                        </div>
                    </div>
                </c:if>
            </div>

            <%@ include file="includes/footer.jsp" %>