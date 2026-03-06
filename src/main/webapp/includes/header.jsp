<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <fmt:setBundle basename="messages" />

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>
                    <fmt:message key="app.title" />
                </title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=1.6">
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <script>
                    async function translateText(text, targetLang, sourceLang) {
                        try {
                            const url = 'https://translate.googleapis.com/translate_a/single?client=gtx&sl=' + sourceLang + '&tl=' + targetLang + '&dt=t&q=' + encodeURIComponent(text);
                            const response = await fetch(url);
                            const data = await response.json();
                            return data[0][0][0];
                        } catch (e) {
                            console.error("Translation failed:", e);
                            return text;
                        }
                    }

                    function setupAutoTranslation(sourceId, targetId, targetLang, sourceLang) {
                        const source = document.getElementById(sourceId);
                        const target = document.getElementById(targetId);
                        if (!source || !target) return;

                        let timeout;
                        source.addEventListener('input', () => {
                            clearTimeout(timeout);
                            timeout = setTimeout(async () => {
                                if (source.value.trim()) {
                                    target.value = await translateText(source.value, targetLang, sourceLang);
                                }
                            }, 1000);
                        });
                    }
                </script>
            </head>

            <body>
                <header class="site-header">
                    <div class="container">
                        <nav>
                            <a href="${pageContext.request.contextPath}/articles" class="logo">FORUM.</a>

                            <form action="${pageContext.request.contextPath}/search" method="get" class="navbar-search">
                                <i class="fa-solid fa-magnifying-glass"></i>
                                <input type="text" name="keyword" placeholder="Search insights & topics..."
                                    value="${param.keyword}">
                            </form>

                            <ul class="nav-links">
                                <li><a href="${pageContext.request.contextPath}/articles">
                                        <fmt:message key="nav.home" />
                                    </a></li>
                                <li><a href="${pageContext.request.contextPath}/topics">
                                        <fmt:message key="nav.topics" />
                                    </a></li>
                                <li class="divider"
                                    style="width: 1px; height: 1.5rem; background: rgba(255, 255, 255, 0.1); margin: 0 0.5rem;">
                                </li>
                                <li style="display: flex; gap: 0.5rem; align-items: center;">
                                    <a href="${pageContext.request.contextPath}/language?lang=en"
                                        class="lang-link ${sessionScope.lang == 'en' || empty sessionScope.lang ? 'active' : ''}">EN</a>
                                    <span style="opacity: 0.3;">/</span>
                                    <a href="${pageContext.request.contextPath}/language?lang=fr"
                                        class="lang-link ${sessionScope.lang == 'fr' ? 'active' : ''}">FR</a>
                                </li>
                                <li class="divider"
                                    style="width: 1px; height: 1.5rem; background: rgba(255, 255, 255, 0.1); margin: 0 0.5rem;">
                                </li>
                                <c:choose>
                                    <c:when test="${not empty sessionScope.user}">
                                        <li><a href="${pageContext.request.contextPath}/dashboard">
                                                <fmt:message key="nav.dashboard" />
                                            </a></li>
                                        <li><a href="${pageContext.request.contextPath}/profile">
                                                <fmt:message key="nav.profile" />
                                            </a></li>
                                        <c:if test="${sessionScope.user.admin}">
                                            <li><a href="${pageContext.request.contextPath}/admin">
                                                    <fmt:message key="nav.admin" />
                                                </a></li>
                                        </c:if>
                                        <li><a href="${pageContext.request.contextPath}/logout">
                                                <fmt:message key="nav.logout" />
                                            </a></li>
                                    </c:when>
                                    <c:otherwise>
                                        <li><a href="${pageContext.request.contextPath}/login">
                                                <fmt:message key="nav.login" />
                                            </a></li>
                                        <li><a href="${pageContext.request.contextPath}/register">
                                                <fmt:message key="nav.register" />
                                            </a></li>
                                    </c:otherwise>
                                </c:choose>
                            </ul>
                        </nav>
                    </div>
                </header>
                <main class="container" style="padding-top: 2rem;">