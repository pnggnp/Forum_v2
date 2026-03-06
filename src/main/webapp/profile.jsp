<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ include file="includes/header.jsp" %>

        <div class="container py-section">
            <div class="card" style="max-width: 900px; margin: 0 auto;">
                <div class="text-center" style="margin-bottom: 3rem;">
                    <div
                        style="width: 140px; height: 140px; border-radius: 50%; background: rgba(0,0,0,0.2); border: 3px solid var(--primary); margin: 0 auto 1.5rem; display: flex; align-items: center; justify-content: center; font-size: 4rem; font-weight: 800; overflow: hidden; color: var(--primary);">
                        <c:choose>
                            <c:when test="${sessionScope.user.profilePicture == 'default_profile.png'}">
                                ${sessionScope.user.username.substring(0,1).toUpperCase()}
                            </c:when>
                            <c:otherwise>
                                <img src="${sessionScope.user.profilePicture}" alt="Profile"
                                    style="width: 100%; height: 100%; object-fit: cover;">
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <h1>${sessionScope.user.username}</h1>
                    <p class="text-lead">${sessionScope.user.email}</p>
                </div>

                <div
                    style="display: grid; grid-template-columns: 1fr 1fr; gap: 2rem; border-top: 1px solid rgba(255,255,255,0.1); padding-top: 3rem;">
                    <div>
                        <label class="meta">PROFESSIONAL STATUS</label>
                        <p style="font-size: 1.25rem; font-weight: 700;">Verified Member</p>
                    </div>
                    <div>
                        <label class="meta">MEMBER SINCE</label>
                        <p style="font-size: 1.25rem; font-weight: 700;">
                            <fmt:formatDate value="${sessionScope.user.joinDate}" pattern="MMMM yyyy" />
                        </p>
                    </div>
                </div>

                <div style="margin-top: 4rem; display: flex; gap: 1rem;">
                    <a href="#" class="btn btn-primary" style="flex: 1;">Edit Profile</a>
                    <a href="dashboard" class="btn btn-outline" style="flex: 1;">Go to Dashboard</a>
                </div>
            </div>
        </div>

        <%@ include file="includes/footer.jsp" %>