<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ include file="includes/header.jsp" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

            <div class="container py-section">
                <nav aria-label="breadcrumb">
                    <ul class="breadcrumb">
                        <li><a href="articles">Articles</a></li>
                        <li class="separator">/</li>
                        <c:if test="${not empty article.topicName}">
                            <li><a href="topics?action=view&id=${article.topicId}">${article.topicName}</a></li>
                            <li class="separator">/</li>
                        </c:if>
                        <li class="current">Details</li>
                    </ul>
                </nav>

                <article class="card"
                    style="padding: clamp(2rem, 5vw, 4rem); border: none; background: rgba(255, 255, 255, 0.02); backdrop-filter: blur(20px);">
                    <div class="article-header">
                        <span class="category-badge">
                            <i class="fa-solid fa-folder-open" style="margin-right: 0.5rem;"></i>
                            <c:choose>
                                <c:when test="${sessionScope.lang == 'fr' && not empty article.topicNameFr}">
                                    ${article.topicNameFr}
                                </c:when>
                                <c:otherwise>
                                    ${article.topicName}
                                </c:otherwise>
                            </c:choose>
                        </span>
                        <h1
                            style="font-size: 3.5rem; line-height: 1.1; margin: 1.5rem 0; font-weight: 800; letter-spacing: -2px;">
                            <c:choose>
                                <c:when test="${sessionScope.lang == 'fr' && not empty article.titleFr}">
                                    ${article.titleFr}
                                </c:when>
                                <c:otherwise>
                                    ${article.title}
                                </c:otherwise>
                            </c:choose>
                        </h1>
                        <div class="meta" style="font-size: 1.1rem; gap: 2rem;">
                            <span><i class="fa-solid fa-user" style="margin-right: 0.5rem; opacity: 0.5;"></i>
                                <fmt:message key="article.author" /> <strong>${article.authorName}</strong>
                            </span>
                            <span style="opacity: 0.2;">|</span>
                            <span><i class="fa-solid fa-calendar" style="margin-right: 0.5rem; opacity: 0.5;"></i>
                                <fmt:formatDate value="${article.createdAt}" pattern="MMMM d, yyyy" />
                            </span>
                        </div>
                        </header>

                        <div class="article-body">
                            ${fn:trim(article.content)}
                        </div>

                        <!-- Photo Gallery -->
                        <c:if test="${not empty photos}">
                            <h3 style="margin-bottom: 2rem; font-size: 1.5rem;">Visual Insights</h3>
                            <div class="photo-gallery">
                                <c:forEach var="photo" items="${photos}">
                                    <div class="photo-item" style="position: relative;">
                                        <img src="${photo.photoUrl}" alt="Article photo">
                                        <div
                                            style="position: absolute; bottom: 0; left: 0; right: 0; padding: 0.5rem; background: rgba(0,0,0,0.6); font-size: 0.75rem; color: #fff; text-align: center;">
                                            By ${photo.uploaderName}
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:if>

                        <c:if test="${not empty sessionScope.user}">
                            <!-- Photo Upload Section -->
                            <div class="upload-section">
                                <h4 style="margin-bottom: 1.5rem; display: flex; align-items: center; gap: 0.75rem;">
                                    <i class="fa-solid fa-camera-retro" style="color: var(--primary);"></i>
                                    Contribute Visual Insights
                                </h4>
                                <p style="font-size: 0.9rem; opacity: 0.7; margin-bottom: 2rem;">
                                    Collaborate with the community by sharing relevant photos for this perspective.
                                </p>
                                <form action="uploadPhoto" method="post" enctype="multipart/form-data"
                                    style="display: flex; gap: 1.5rem; align-items: center; flex-wrap: wrap;">
                                    <input type="hidden" name="articleId" value="${article.id}">
                                    <input type="file" name="photo" accept="image/*" required
                                        style="flex: 1; border: 1px dashed rgba(255, 255, 255, 0.1); padding: 1rem; border-radius: var(--radius-md); background: rgba(0, 0, 0, 0.2);">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fa-solid fa-upload" style="margin-right: 0.5rem;"></i> Upload Insight
                                    </button>
                                </form>
                            </div>
                        </c:if>

                        <c:if test="${sessionScope.user.id == article.authorId || sessionScope.user.admin}">
                            <div
                                style="display: flex; gap: 1rem; margin-top: 2rem; padding-top: 3rem; border-top: 1px solid rgba(255, 255, 255, 0.05);">
                                <a href="articles?action=edit&id=${article.id}" class="btn btn-outline"
                                    style="min-width: 150px;">
                                    <i class="fa-solid fa-pen-to-square"></i>
                                    <fmt:message key="article.edit" />
                                </a>
                                <a href="articles?action=delete&id=${article.id}" class="btn btn-outline"
                                    style="border-color: var(--danger); color: var(--danger); min-width: 150px;"
                                    onclick="return confirm('Silently remove this perspective?')">
                                    <i class="fa-solid fa-trash-can"></i>
                                    <fmt:message key="article.delete" />
                                </a>
                            </div>
                        </c:if>
                </article>

                <!-- Comments Section -->
                <section style="max-width: 900px; margin: 6rem auto 0;">
                    <div
                        style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 3rem;">
                        <h2 style="font-size: 2rem; margin: 0;">Community Perspectives</h2>
                        <div
                            style="padding: 0.5rem 1rem; background: var(--surface-dark); border-radius: 2rem; font-size: 0.9rem; font-weight: 700; color: var(--primary);">
                            ${fn:length(comments)} Comments
                        </div>
                    </div>

                    <c:if test="${not empty sessionScope.user}">
                        <div class="card"
                            style="margin-bottom: 4rem; background: rgba(255, 255, 255, 0.01); border-color: rgba(255, 255, 255, 0.05);">
                            <form action="comments" method="post">
                                <input type="hidden" name="action" value="add">
                                <input type="hidden" name="articleId" value="${article.id}">
                                <div class="form-group">
                                    <label style="font-size: 1rem; color: var(--text-white); margin-bottom: 1rem;">
                                        <i class="fa-solid fa-comment-dots" style="color: var(--primary);"></i> Share
                                        your
                                        thoughts
                                    </label>
                                    <textarea name="content" rows="4" required
                                        placeholder="What are your thoughts on this perspective?"
                                        style="background: rgba(0, 0, 0, 0.3); border-color: rgba(255, 255, 255, 0.1); font-size: 1.1rem; padding: 1.5rem;"></textarea>
                                </div>
                                <button type="submit" class="btn btn-primary" style="padding: 1rem 2.5rem;">
                                    Post Comment <i class="fa-solid fa-paper-plane" style="margin-left: 0.5rem;"></i>
                                </button>
                            </form>
                        </div>
                    </c:if>

                    <div class="comment-list">
                        <c:forEach var="comment" items="${comments}">
                            <div class="comment-card">
                                <div
                                    style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 1rem;">
                                    <div>
                                        <p
                                            style="font-weight: 800; font-size: 1.1rem; margin-bottom: 0.25rem; color: var(--primary);">
                                            ${comment.username}</p>
                                        <p class="meta" style="font-size: 0.8rem; opacity: 0.6;">
                                            <i class="fa-solid fa-clock" style="margin-right: 0.3rem;"></i>
                                            <fmt:formatDate value="${comment.createdAt}"
                                                pattern="MMM d, yyyy · HH:mm" />
                                        </p>
                                    </div>
                                    <c:if test="${sessionScope.user.id == comment.userId || sessionScope.user.admin}">
                                        <form action="comments" method="post" style="display: inline;">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="${comment.id}">
                                            <input type="hidden" name="articleId" value="${article.id}">
                                            <button type="submit" class="btn"
                                                style="padding: 0.5rem; color: var(--danger); background: transparent; opacity: 0.5;"
                                                onclick="return confirm('Remove this comment?')">
                                                <i class="fa-solid fa-trash-can"></i>
                                            </button>
                                        </form>
                                    </c:if>
                                </div>
                                <p style="color: var(--text-white); font-size: 1.1rem; line-height: 1.6; opacity: 0.9;">
                                    ${comment.content}</p>
                            </div>
                        </c:forEach>

                        <c:if test="${empty comments}">
                            <div class="empty-state" style="padding: 4rem;">
                                <i class="fa-solid fa-comments"></i>
                                <p class="text-lead" style="margin: 0;">
                                    <fmt:message key="comment.none" />
                                </p>
                            </div>
                        </c:if>
                    </div>
                </section>
            </div>

            <%@ include file="includes/footer.jsp" %>