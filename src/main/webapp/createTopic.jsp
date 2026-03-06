<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ include file="includes/header.jsp" %>

        <div class="container py-section">
            <div class="card" style="max-width: 600px; margin: 0 auto; padding: 3rem;">
                <h1 class="text-center mb-huge">Create New Topic</h1>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger mb-large"
                        style="background: #fee2e2; color: #991b1b; padding: 1rem; border-radius: 0.5rem;">
                        ${error}
                    </div>
                </c:if>

                <c:set var="isEn" value="${sessionScope.lang == 'en' || empty sessionScope.lang}" />
                <c:set var="currentLang" value="${isEn ? 'en' : 'fr'}" />
                <c:set var="targetLang" value="${isEn ? 'fr' : 'en'}" />

                <form action="topics" method="post" id="topicForm">
                    <input type="hidden" name="action" value="save">

                    <div class="form-group mb-huge">
                        <label for="primary_name" style="display: block; margin-bottom: 0.5rem; font-weight: 600;">
                            <fmt:message key="article.topic" />
                        </label>
                        <input type="text" id="primary_name" name="${isEn ? 'name' : 'name_fr'}" required
                            placeholder="e.g. Jazz, Rock, Mixing">
                        <input type="hidden" id="secondary_name" name="${isEn ? 'name_fr' : 'name'}">
                    </div>

                    <div class="form-group mb-huge">
                        <label for="primary_desc" style="display: block; margin-bottom: 0.5rem; font-weight: 600;">
                            Description
                        </label>
                        <textarea id="primary_desc" name="${isEn ? 'description' : 'description_fr'}" rows="5" required
                            placeholder="Describe what this topic is about..."></textarea>
                        <input type="hidden" id="secondary_desc" name="${isEn ? 'description_fr' : 'description'}">
                    </div>

                    <div style="display: flex; gap: 1rem;">
                        <button type="submit" class="btn btn-primary" style="flex: 1; justify-content: center;">
                            <fmt:message key="topics.create" />
                        </button>
                        <a href="topics" class="btn"
                            style="flex: 1; border: 1px solid var(--border-color); display: flex; align-items: center; justify-content: center;">Cancel</a>
                    </div>
                </form>

                <script>
                    document.addEventListener('DOMContentLoaded', () => {
                        setupAutoTranslation('primary_name', 'secondary_name', '${targetLang}', '${currentLang}');
                        setupAutoTranslation('primary_desc', 'secondary_desc', '${targetLang}', '${currentLang}');
                    });
                </script>
            </div>
        </div>

        <%@ include file="includes/footer.jsp" %>