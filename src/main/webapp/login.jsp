<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ include file="includes/header.jsp" %>

        <div class="container py-section">
            <div class="auth-wrapper">
                <div class="card w-100">
                    <h1 class="text-center">
                        <fmt:message key="auth.welcome" />
                    </h1>
                    <p class="text-lead text-center">Login to your corporate account.</p>

                    <c:if test="${not empty message}">
                        <div
                            style="background: rgba(16, 185, 129, 0.1); color: var(--success); padding: 1rem; border-radius: var(--radius-md); margin-bottom: 1.5rem; border: 1px solid var(--success);">
                            ${message}
                        </div>
                    </c:if>

                    <c:if test="${not empty error}">
                        <div
                            style="background: rgba(239, 68, 68, 0.1); color: var(--danger); padding: 1rem; border-radius: var(--radius-md); margin-bottom: 1.5rem; border: 1px solid var(--danger);">
                            ${error}
                        </div>
                    </c:if>

                    <form action="login" method="post">
                        <div class="form-group">
                            <label for="identifier">
                                Email or Username
                            </label>
                            <input type="text" id="identifier" name="identifier" required
                                placeholder="name@company.com or username">
                        </div>
                        <div class="form-group">
                            <label for="password">
                                <fmt:message key="auth.password" />
                            </label>
                            <input type="password" id="password" name="password" required placeholder="********">
                        </div>
                        <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 1rem;">
                            <fmt:message key="auth.login" />
                        </button>
                    </form>

                    <p class="text-center" style="margin-top: 2rem; font-size: 0.9rem;">
                        Don't have an account? <a href="register"
                            style="color: var(--primary); font-weight: 600;">Register
                            Now</a>
                    </p>
                    <p class="text-center" style="margin-top: 0.5rem; font-size: 0.85rem; opacity: 0.7;">
                        Already registered? <a href="verify"
                            style="color: var(--text-main); text-decoration: underline;">Verify Account</a>
                    </p>
                </div>
            </div>
        </div>

        <%@ include file="includes/footer.jsp" %>