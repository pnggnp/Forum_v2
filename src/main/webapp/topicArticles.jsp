<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ include file="includes/header.jsp" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

            <div class="container py-section">
                <div class="mb-huge">
                    <nav aria-label="breadcrumb">
                        <ul class="breadcrumb">
                            <li><a href="topics">
                                    <fmt:message key="nav.topics" />
                                </a></li>
                            <li class="separator">/</li>
                            <li class="current">
                                <c:choose>
                                    <c:when test="${sessionScope.lang == 'fr' && not empty topic.nameFr}">
                                        ${topic.nameFr}
                                    </c:when>
                                    <c:otherwise>
                                        ${topic.name}
                                    </c:otherwise>
                                </c:choose>
                            </li>
                        </ul>
                    </nav>

                    <div
                        style="display: flex; justify-content: space-between; align-items: flex-end; flex-wrap: wrap; gap: 2rem;">
                        <div>
                            <div class="topic-badge">Topic View</div>
                            <h1 style="margin: 0 0 0.5rem 0;">
                                <c:choose>
                                    <c:when test="${sessionScope.lang == 'fr' && not empty topic.nameFr}">
                                        ${topic.nameFr}
                                    </c:when>
                                    <c:otherwise>
                                        ${topic.name}
                                    </c:otherwise>
                                </c:choose>
                            </h1>
                            <p class="text-lead" style="margin: 0;">
                                <c:choose>
                                    <c:when test="${sessionScope.lang == 'fr' && not empty topic.descriptionFr}">
                                        ${topic.descriptionFr}
                                    </c:when>
                                    <c:otherwise>
                                        ${topic.description}
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                        <c:if test="${not empty sessionScope.user}">
                            <a href="articles?action=create&topicId=${topic.id}" class="btn btn-primary">
                                <i class="fa-solid fa-plus"></i>
                                <fmt:message key="article.create" />
                            </a>
                        </c:if>
                    </div>
                </div>

                <div class="article-grid"
                    style="display: grid; grid-template-columns: repeat(auto-fill, minmax(350px, 1fr)); gap: 2.5rem;">
                    <c:forEach var="article" items="${articles}">
                        <div class="card article-card-list">
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
                                Read Full Insight <i class="fa-solid fa-arrow-right"></i>
                            </a>
                        </div>
                    </c:forEach>
                </div>

                <c:if test="${empty articles}">
                    <div class="card text-center" style="padding: 5rem;">
                        <p class="text-lead">No articles found in this topic yet.</p>
                    </div>
                </c:if>
            </div>

            <%@ include file="includes/footer.jsp" %>