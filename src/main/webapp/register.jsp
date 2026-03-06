<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ include file="includes/header.jsp" %>

        <div class="container py-section">
            <div class="auth-wrapper">
                <div class="card w-100">
                    <h1 class="text-center">
                        <fmt:message key="auth.register" />
                    </h1>
                    <p class="text-lead text-center">Join our professional community.</p>

                    <c:if test="${not empty error}">
                        <div
                            style="background: rgba(239, 68, 68, 0.1); color: var(--danger); padding: 1rem; border-radius: var(--radius-md); margin-bottom: 1.5rem; border: 1px solid var(--danger);">
                            ${error}
                        </div>
                    </c:if>

                    <form action="register" method="post" id="registerForm">
                        <div class="form-group">
                            <label for="username">
                                <fmt:message key="auth.username" />
                            </label>
                            <input type="text" id="username" name="username" required
                                placeholder="Your professional name">
                        </div>
                        <div class="form-group">
                            <label for="email">
                                <fmt:message key="auth.email" />
                            </label>
                            <input type="email" id="email" name="email" required placeholder="work@company.com">
                        </div>
                        <div class="form-group">
                            <label for="password">
                                <fmt:message key="auth.password" />
                            </label>
                            <input type="password" id="password" name="password" required placeholder="********">
                        </div>
                        <button type="submit" id="submitBtn" class="btn btn-primary"
                            style="width: 100%; margin-top: 1rem;">
                            <fmt:message key="auth.signup" />
                        </button>
                    </form>

                    <script>
                        document.getElementById('registerForm').addEventListener('submit', function () {
                            const btn = document.getElementById('submitBtn');
                            btn.disabled = true;
                            btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Creating Account...';
                            btn.style.opacity = '0.7';
                            btn.style.cursor = 'not-allowed';
                        });
                    </script>

                    <p class="text-center" style="margin-top: 2rem; font-size: 0.9rem;">
                        Already part of the team? <a href="login" style="color: var(--primary); font-weight: 600;">Log
                            in</a>
                    </p>
                </div>
            </div>
        </div>

        <%@ include file="includes/footer.jsp" %>