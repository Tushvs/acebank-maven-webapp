<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login | AceBank</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Inter', sans-serif;
            height: 100vh;
            margin: 0;
            background: linear-gradient(135deg, #0f172a, #1e3a8a);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .auth-card {
            width: 100%;
            max-width: 420px;
            background: rgba(30, 41, 59, 0.75);
            backdrop-filter: blur(18px);
            border-radius: 18px;
            padding: 40px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.4);
            animation: zoomIn 0.6s ease;
            color: #e2e8f0;
            transition: all 0.35s ease;
        }

        .auth-card:hover {
            transform: translateY(-10px) scale(1.02);
            box-shadow: 0 35px 70px rgba(59,130,246,0.4);
        }

        @keyframes zoomIn {
            from { opacity: 0; transform: scale(0.9); }
            to { opacity: 1; transform: scale(1); }
        }

        .form-control-custom {
            background: rgba(255,255,255,0.05);
            border: 1px solid rgba(255,255,255,0.1);
            color: white;
            border-radius: 10px;
            padding: 12px;
            transition: all 0.3s ease;
        }

        .form-control-custom:focus,
        .form-control-custom:active {
            background: #ffffff !important;
            color: #000000 !important;
            border-color: #3b82f6;
            box-shadow: 0 0 12px rgba(59,130,246,0.6);
        }

        input:-webkit-autofill,
        input:-webkit-autofill:focus,
        input:-webkit-autofill:hover,
        input:-webkit-autofill:active {
            -webkit-box-shadow: 0 0 0 1000px #ffffff inset !important;
            -webkit-text-fill-color: #000000 !important;
            transition: background-color 5000s ease-in-out 0s;
        }

        .btn-login {
            background: #3b82f6;
            border: none;
            padding: 12px;
            font-weight: 600;
            border-radius: 10px;
            transition: 0.3s;
        }

        .btn-login:hover {
            background: #2563eb;
            transform: translateY(-3px);
            box-shadow: 0 12px 25px rgba(59,130,246,0.4);
        }

        .auth-link {
            color: #3b82f6;
            text-decoration: none;
        }

        .auth-link:hover {
            text-decoration: underline;
        }

        .brand {
            position: absolute;
            top: 30px;
            left: 40px;
            font-weight: 700;
            font-size: 1.4rem;
            color: #3b82f6;
        }

        .back-home {
            position: absolute;
            top: 30px;
            right: 40px;
        }

        .back-home a {
            color: #e2e8f0;
            text-decoration: none;
        }

        .back-home a:hover {
            color: #3b82f6;
        }
    </style>
</head>

<body>

<div class="brand">AceBank</div>

<div class="back-home">
    <a href="index.jsp">← Back to Home</a>
</div>

<div class="auth-card">

    <h2 class="fw-bold mb-2">Welcome Back</h2>
    <p class="text-secondary">Login to access your secure dashboard.</p>

    <form action="Login" method="POST" class="mt-4">

        <div class="mb-3">
            <input type="text"
                   name="accountNumber"
                   class="form-control form-control-custom"
                   value="${savedAccount}"
                   required
                   placeholder="Account Number">
        </div>

        <div class="mb-3">
            <input type="password"
                   name="password"
                   class="form-control form-control-custom"
                   required
                   placeholder="Password">
        </div>

        <div class="mb-3 form-check">
            <input type="checkbox"
                   name="rememberMe"
                   class="form-check-input"
                   id="remember"
                   ${not empty savedAccount ? 'checked' : ''}>
            <label class="form-check-label" for="remember">
                Remember Me
            </label>
        </div>

        <div class="text-end mb-3">
            <a href="ForgotPassword.jsp" class="auth-link">
                Forgot Password?
            </a>
        </div>

        <button type="submit" class="btn btn-login w-100">
            Login to Account
        </button>

    </form>

    <div class="mt-4 text-center">
        <span class="text-secondary">New here?</span>
        <a href="sign-up.jsp" class="auth-link">
            Create an account
        </a>
    </div>

</div>

</body>
</html>