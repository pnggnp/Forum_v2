<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ include file="includes/header.jsp" %>

        <div style="width: 100%; margin: 2rem 0;">
            <div class="card">
                <h1>
                    <fmt:message key="article.create" />
                </h1>
                <p class="meta" style="margin-bottom: 2rem;">Share your knowledge with the community.</p>

                <c:if test="${not empty error}">
                    <p style="color: var(--danger); margin-bottom: 1rem;">${error}</p>
                </c:if>

                <c:set var="isEn" value="${sessionScope.lang == 'en' || empty sessionScope.lang}" />
                <c:set var="currentLang" value="${isEn ? 'en' : 'fr'}" />
                <c:set var="targetLang" value="${isEn ? 'fr' : 'en'}" />

                <form action="articles" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="save">
                    <div class="form-group">
                        <label for="topicId">
                            <fmt:message key="article.topic" />
                        </label>
                        <select id="topicId" name="topicId"
                            style="width: 100%; padding: 0.75rem; border: 1px solid var(--border-color); border-radius: 0.5rem; font-family: inherit;">
                            <option value="">-- Select a Topic --</option>
                            <c:forEach var="topic" items="${topics}">
                                <option value="${topic.id}" ${param.topicId==topic.id ? 'selected' : '' }>
                                    <c:choose>
                                        <c:when test="${!isEn && not empty topic.nameFr}">
                                            ${topic.nameFr}
                                        </c:when>
                                        <c:otherwise>
                                            ${topic.name}
                                        </c:otherwise>
                                    </c:choose>
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group mb-huge">
                        <label for="primary_title" style="display: block; margin-bottom: 0.5rem; font-weight: 600;">
                            <fmt:message key="article.title" />
                        </label>
                        <input type="text" id="primary_title" name="${isEn ? 'title' : 'title_fr'}" required
                            placeholder="Enter a compelling title...">
                        <input type="hidden" id="secondary_title" name="${isEn ? 'title_fr' : 'title'}">
                    </div>

                    <div class="form-group mb-huge">
                        <label for="primary_content" style="display: block; margin-bottom: 0.5rem; font-weight: 600;">
                            <fmt:message key="article.content" />
                        </label>
                        <textarea id="primary_content" name="${isEn ? 'content' : 'content_fr'}" rows="10" required
                            placeholder="Write your article content here..."></textarea>
                        <input type="hidden" id="secondary_content" name="${isEn ? 'content_fr' : 'content'}">
                    </div>

                    <div class="form-group">
                        <label for="photo">
                            <i class="fa-solid fa-camera" style="margin-right: 0.5rem; color: var(--primary);"></i>
                            <fmt:message key="profile.edit_picture" /> (Optional)
                        </label>
                        <input type="file" id="photo" name="photo" accept="image/*"
                            style="border: 1px dashed rgba(255, 255, 255, 0.1); padding: 1rem; border-radius: var(--radius-md); background: rgba(0, 0, 0, 0.2); width: 100%;">
                    </div>

                    <div style="display: flex; gap: 1rem; margin-top: 2rem;">
                        <button type="submit" class="btn btn-primary" style="flex: 1; justify-content: center;">
                            <fmt:message key="article.create" />
                        </button>
                        <a href="articles" class="btn"
                            style="flex: 1; border: 1px solid var(--border-color); display: flex; align-items: center; justify-content: center;">Cancel</a>
                    </div>
                </form>

                <script>
                    document.addEventListener('DOMContentLoaded', () => {
                        setupAutoTranslation('primary_title', 'secondary_title', '${targetLang}', '${currentLang}');
                        setupAutoTranslation('primary_content', 'secondary_content', '${targetLang}', '${currentLang}');
                    });
                </script>
            </div>
        </div>

        <%@ include file="includes/footer.jsp" %>