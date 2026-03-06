<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ include file="includes/header.jsp" %>

        <div style="width: 100%; margin: 2rem 0;">
            <div class="card">
                <h1>
                    <fmt:message key="article.edit" />
                </h1>

                <c:set var="isEn" value="${sessionScope.lang == 'en' || empty sessionScope.lang}" />
                <c:set var="currentLang" value="${isEn ? 'en' : 'fr'}" />
                <c:set var="targetLang" value="${isEn ? 'fr' : 'en'}" />

                <form action="articles" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" value="${article.id}">

                    <div class="form-group mb-huge">
                        <label for="primary_title" style="display: block; margin-bottom: 0.5rem; font-weight: 600;">
                            <fmt:message key="article.title" />
                        </label>
                        <input type="text" id="primary_title" name="${isEn ? 'title' : 'title_fr'}" required
                            value="${isEn ? article.title : article.titleFr}" placeholder="Enter a compelling title...">
                        <input type="hidden" id="secondary_title" name="${isEn ? 'title_fr' : 'title'}"
                            value="${isEn ? article.titleFr : article.title}">
                    </div>

                    <div class="form-group mb-huge">
                        <label for="primary_content" style="display: block; margin-bottom: 0.5rem; font-weight: 600;">
                            <fmt:message key="article.content" />
                        </label>
                        <textarea id="primary_content" name="${isEn ? 'content' : 'content_fr'}" rows="10" required
                            placeholder="Write your article content here...">${isEn ? article.content : article.contentFr}</textarea>
                        <input type="hidden" id="secondary_content" name="${isEn ? 'content_fr' : 'content'}"
                            value="${isEn ? article.contentFr : article.content}">
                    </div>

                    <div style="display: flex; gap: 1rem; margin-top: 2rem;">
                        <button type="submit" class="btn btn-primary" style="flex: 1; justify-content: center;">
                            <fmt:message key="article.edit" />
                        </button>
                        <a href="articles?action=details&id=${article.id}" class="btn"
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