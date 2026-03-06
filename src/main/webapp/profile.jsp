<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ include file="includes/header.jsp" %>

        <div class="container py-section">
            <div class="card" style="max-width: 900px; margin: 0 auto;">

                <c:if test="${not empty param.success}">
                    <div class="alert alert-success" style="margin-bottom: 2rem;">
                        ${param.success}
                    </div>
                </c:if>
                <c:if test="${not empty param.error}">
                    <div class="alert alert-danger" style="margin-bottom: 2rem;">
                        ${param.error}
                    </div>
                </c:if>

                <!-- Display Mode -->
                <div id="displayMode" class="text-center" style="margin-bottom: 3rem;">
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

                <div id="statsGrid"
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

                <div id="actionButtons" style="margin-top: 4rem; display: flex; gap: 1rem;">
                    <button onclick="toggleEditMode()" class="btn btn-primary" style="flex: 1;">Edit Profile</button>
                    <a href="dashboard" class="btn btn-outline" style="flex: 1;">Go to Dashboard</a>
                </div>

                <!-- Edit Mode Form (Hidden by default) -->
                <div id="editMode" style="display: none; padding-top: 2rem;">
                    <h2 class="text-center" style="margin-bottom: 2rem;">Edit Your Profile</h2>
                    <form action="profile" method="post" style="max-width: 500px; margin: 0 auto;">
                        <div class="form-group" style="margin-bottom: 1.5rem;">
                            <label for="username"
                                style="display: block; margin-bottom: 0.5rem; font-weight: 600;">Username</label>
                            <input type="text" id="username" name="username" class="form-control"
                                value="${sessionScope.user.username}" required
                                style="width: 100%; padding: 0.75rem; border-radius: 6px; border: 1px solid rgba(255,255,255,0.2); background: rgba(255,255,255,0.05); color: white;">
                        </div>
                        <div class="form-group" style="margin-bottom: 2.5rem;">
                            <label for="email"
                                style="display: block; margin-bottom: 0.5rem; font-weight: 600;">Email</label>
                            <input type="email" id="email" name="email" class="form-control"
                                value="${sessionScope.user.email}" required
                                style="width: 100%; padding: 0.75rem; border-radius: 6px; border: 1px solid rgba(255,255,255,0.2); background: rgba(255,255,255,0.05); color: white;">
                        </div>
                        <div style="display: flex; gap: 1rem;">
                            <button type="submit" class="btn btn-primary" style="flex: 1;">Save Changes</button>
                            <button type="button" onclick="toggleEditMode()" class="btn btn-outline"
                                style="flex: 1;">Cancel</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script>
            function toggleEditMode() {
                var displayMode = document.getElementById('displayMode');
                var statsGrid = document.getElementById('statsGrid');
                var actionButtons = document.getElementById('actionButtons');
                var editMode = document.getElementById('editMode');

                if (editMode.style.display === 'none') {
                    displayMode.style.display = 'none';
                    statsGrid.style.display = 'none';
                    actionButtons.style.display = 'none';
                    editMode.style.display = 'block';
                } else {
                    displayMode.style.display = 'block';
                    statsGrid.style.display = 'grid';
                    actionButtons.style.display = 'flex';
                    editMode.style.display = 'none';
                }
            }
        </script>

        <%@ include file="includes/footer.jsp" %>