<%@ include file="includes/header.jsp" %>

    <div class="container py-section">
        <div class="auth-wrapper">
            <div class="card w-100">
                <h1 class="text-center">Verification</h1>
                <p class="text-lead text-center">Confirm your professional identity.</p>

                <c:if test="${not empty message}">
                    <div
                        style="background: rgba(16, 185, 129, 0.1); color: var(--success); padding: 1rem; border-radius: var(--radius-md); margin-bottom: 1.5rem; border: 1px solid var(--success);">
                        ${message}
                    </div>
                </c:if>

                <c:if test="${not empty warning}">
                    <div
                        style="background: rgba(245, 158, 11, 0.1); color: #f59e0b; padding: 1rem; border-radius: var(--radius-md); margin-bottom: 1.5rem; border: 1px solid #f59e0b;">
                        ${warning}
                    </div>
                </c:if>

                <c:if test="${not empty error}">
                    <div
                        style="background: rgba(239, 68, 68, 0.1); color: var(--danger); padding: 1rem; border-radius: var(--radius-md); margin-bottom: 1.5rem; border: 1px solid var(--danger);">
                        ${error}
                    </div>
                </c:if>

                <form action="verify" method="post" class="text-center">
                    <div class="form-group">
                        <label for="code">6-DIGIT SECURITY CODE</label>
                        <input type="text" id="code" name="code" maxlength="6" required
                            style="font-size: 2.5rem; text-align: center; letter-spacing: 0.75rem; font-weight: 900; padding: 1.5rem; background: rgba(0,0,0,0.3);"
                            placeholder="000000" pattern="\d{6}">
                    </div>
                    <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 1.5rem;">
                        Confirm & Activate
                    </button>
                    <c:if test="${not empty param.email or not empty email}">
                        <input type="hidden" name="email" value="${not empty email ? email : param.email}">
                    </c:if>
                </form>

                <div style="margin-top: 2rem; text-align: center;">
                    <p class="text-muted" style="font-size: 0.85rem;">
                        Didn't receive the code? Check your spam folder or
                        <c:choose>
                            <c:when test="${not empty param.email or not empty email}">
                                <a href="resend-code?email=${not empty email ? email : param.email}"
                                    style="color: var(--primary); font-weight: 700;">Resend Code</a>
                            </c:when>
                            <c:otherwise>
                                <a href="register" style="color: var(--primary);">retry registration</a>
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="includes/footer.jsp" %>