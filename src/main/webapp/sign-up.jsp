<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Create Account | AceBank</title>
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
            max-width: 500px;
            background: rgba(30, 41, 59, 0.75);
            backdrop-filter: blur(18px);
            border-radius: 18px;
            padding: 45px;
            box-shadow: 0 25px 50px rgba(0,0,0,0.5);
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

        .btn-signup {
            background: #3b82f6;
            border: none;
            padding: 13px;
            font-weight: 600;
            border-radius: 10px;
            transition: 0.3s;
        }

        .btn-signup:hover {
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

        .back-login {
            position: absolute;
            top: 30px;
            right: 40px;
        }

        .back-login a {
            color: #e2e8f0;
            text-decoration: none;
        }

        .back-login a:hover {
            color: #3b82f6;
        }
    </style>
</head>

<body>

<div class="brand">AceBank</div>

<div class="back-login">
    <a href="login.jsp">Already have an account?</a>
</div>

<div class="auth-card">

    <h2 class="fw-bold mb-2">Create Account</h2>
    <p class="text-secondary">Join thousands of users managing money smarter.</p>

    <form action="signup" method="POST" class="mt-4">

        <div class="row">
            <div class="col-md-6 mb-3">
                <input type="text"
                       name="firstName"
                       class="form-control form-control-custom"
                       placeholder="First Name"
                       required>
            </div>

            <div class="col-md-6 mb-3">
                <input type="text"
                       name="lastName"
                       class="form-control form-control-custom"
                       placeholder="Last Name"
                       required>
            </div>
        </div>

        <div class="mb-3">
            <input type="text"
                   name="aadharNumber"
                   class="form-control form-control-custom"
                   placeholder="Aadhar Number (12 digits)"
                   maxlength="12"
                   required>
        </div>

        <div class="mb-3">
            <input type="email"
                   name="email"
                   class="form-control form-control-custom"
                   placeholder="Email Address"
                   required>
        </div>

        <div class="mb-4">
            <input type="password"
                   name="password"
                   class="form-control form-control-custom"
                   placeholder="Password (Min. 10 characters)"
                   required>
        </div>

        <button type="submit" class="btn btn-signup w-100">
            Create Account
        </button>

    </form>

    <div class="mt-4 text-center">
        <span class="text-secondary">Already registered?</span>
        <a href="login.jsp" class="auth-link">
            Login here
        </a>
    </div>

</div>

</body>
</html>