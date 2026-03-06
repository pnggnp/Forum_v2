<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ include file="includes/header.jsp" %>

        <div class="container py-section">
            <div class="section-header mb-huge text-center">
                <h1>
                    <fmt:message key="topics.title" />
                </h1>
                <p class="text-lead">
                    <fmt:message key="topics.subtitle" />
                </p>
            </div>

            <div class="topics-grid"
                style="display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 2.5rem;">
                <c:forEach var="topic" items="${topics}">
                    <a href="articles?action=list&topicId=${topic.id}" class="topic-card">
                        <div class="topic-badge">Subject</div>
                        <h3>
                            <c:choose>
                                <c:when test="${sessionScope.lang == 'fr' && not empty topic.nameFr}">
                                    ${topic.nameFr}
                                </c:when>
                                <c:otherwise>
                                    ${topic.name}
                                </c:otherwise>
                            </c:choose>
                        </h3>
                        <p>
                            <c:choose>
                                <c:when test="${sessionScope.lang == 'fr' && not empty topic.descriptionFr}">
                                    ${topic.descriptionFr}
                                </c:when>
                                <c:otherwise>
                                    ${topic.description}
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </a>
                </c:forEach>
            </div>

            <c:if test="${empty topics}">
                <div class="empty-state">
                    <i class="fa-solid fa-folder-open"></i>
                    <p class="text-lead" style="margin-bottom: 3rem;">
                        <fmt:message key="topics.empty" />
                    </p>
                    <c:if test="${not empty sessionScope.user}">
                        <a href="topics?action=create" class="btn btn-primary">
                            <i class="fa-solid fa-plus"></i>
                            <fmt:message key="topics.create" />
                        </a>
                    </c:if>
                </div>
            </c:if>

            <c:if test="${not empty topics && not empty sessionScope.user}">
                <div style="margin-top: 5rem; text-align: center;">
                    <a href="topics?action=create" class="btn btn-outline">
                        <i class="fa-solid fa-plus"></i>
                        <fmt:message key="topics.create" />
                    </a>
                </div>
            </c:if>
        </div>

        <%@ include file="includes/footer.jsp" %>