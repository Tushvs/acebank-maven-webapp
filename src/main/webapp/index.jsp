<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Integer accNo = (Integer) session.getAttribute("accountNumber");
    String firstName = (String) session.getAttribute("firstName");
    java.math.BigDecimal balance =
            (java.math.BigDecimal) session.getAttribute("balance");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>AceBank | Digital Banking</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Inter', sans-serif;
            background: #0f172a;
            color: #e2e8f0;
        }

        .navbar-custom {
            background: rgba(15, 23, 42, 0.9);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid rgba(255,255,255,0.05);
            position: sticky;
            top: 0;
            z-index: 999;
        }

        .navbar-brand {
            color: #3b82f6 !important;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .back-icon {
            font-size: 0.95rem;
            color: #94a3b8;
            transition: 0.2s ease;
        }

        .back-icon:hover {
            color: #3b82f6;
            transform: translateX(-3px);
        }

        .btn-outline-light-custom {
            border: 1px solid #3b82f6;
            color: #3b82f6;
            transition: 0.3s;
        }

        .btn-outline-light-custom:hover {
            background: #3b82f6;
            color: white;
        }

        /* HERO */
        .hero-section {
            padding: 120px 0;
            background: linear-gradient(135deg, #1e3a8a, #0f172a);
            text-align: center;
        }

        .hero-section h1 {
            font-size: 3rem;
            font-weight: 800;
        }

        .btn-hero {
            background: #3b82f6;
            color: white;
            padding: 14px 32px;
            border-radius: 8px;
            border: none;
            transition: 0.3s;
        }

        .btn-hero:hover {
            background: #2563eb;
            transform: translateY(-3px);
        }

        /* FEATURES */
        .features-section {
            padding: 70px 0 40px;
        }

        /* ✅ FIX: equal height cards */
        .feature-card {
            background: #1e293b;
            border: 1px solid rgba(255,255,255,0.05);
            border-radius: 16px;
            padding: 40px 25px;
            transition: 0.35s ease;

            display: flex;
            flex-direction: column;
            justify-content: space-between;
            height: 100%;
        }

        .feature-card:hover {
            transform: translateY(-10px) scale(1.05);
            box-shadow: 0 15px 40px rgba(59,130,246,0.2);
        }

        /* TRUST */
        .trust-section {
            padding: 50px 0 80px;
            background: #0f172a;
        }

        .trust-card {
            background: #1e293b;
            padding: 40px 20px;
            border-radius: 16px;
            transition: 0.3s ease;
            cursor: pointer;
            border: 1px solid rgba(255,255,255,0.05);
        }

        .trust-card:hover {
            transform: scale(1.1);
            box-shadow: 0 20px 40px rgba(59,130,246,0.3);
        }

        .trust-number {
            font-size: 2.5rem;
            font-weight: 800;
            color: #3b82f6;
        }

        footer {
            background: #020617;
            padding: 20px 0;
            text-align: center;
            color: #94a3b8;
        }

        /* DASHBOARD */
        .dashboard-card {
            background: #1e293b;
            border-radius: 20px;
            padding: 55px;
            border: 1px solid rgba(255,255,255,0.05);
            text-align: center;
            transition: 0.35s ease;
        }

        .dashboard-card:hover {
            transform: translateY(-8px) scale(1.02);
            box-shadow: 0 20px 60px rgba(59,130,246,0.3);
        }

        .welcome-text {
            font-size: 2rem;
            font-weight: 700;
        }

        .account-text {
            font-size: 1.1rem;
            color: #94a3b8;
        }

        .balance-text {
            font-size: 2.5rem;
            font-weight: 800;
            color: #3b82f6;
        }

        .eye-btn {
            background: none;
            border: none;
            color: #94a3b8;
            font-size: 1.3rem;
            margin-left: 10px;
            cursor: pointer;
            transition: 0.3s;
        }

        .eye-btn:hover {
            color: #3b82f6;
        }

        .action-card {
            background: #1e293b;
            border-radius: 18px;
            padding: 35px;
            border: 1px solid rgba(255,255,255,0.05);
            transition: 0.35s ease;
            height: 100%;
        }

        .action-card:hover {
            transform: translateY(-8px) scale(1.02);
            box-shadow: 0 15px 40px rgba(59,130,246,0.3);
        }
    </style>
</head>

<body>

<nav class="navbar navbar-expand-lg navbar-custom py-3">
    <div class="container">
        <% if (accNo != null) { %>
            <a class="navbar-brand fs-4" href="javascript:history.back()">
                <i class="bi bi-arrow-left back-icon"></i>
                AceBank
            </a>
        <% } else { %>
            <a class="navbar-brand fs-4" href="#">AceBank</a>
        <% } %>

        <div>
            <% if (accNo != null) { %>
                <a href="<%= request.getContextPath() %>/Logout"
                   class="btn btn-danger">Logout</a>
            <% } else { %>
                <a href="<%= request.getContextPath() %>/Login"
                   class="btn btn-outline-light-custom">Login</a>
            <% } %>
        </div>
    </div>
</nav>

<% if (accNo == null) { %>

<section class="hero-section">
    <div class="container">
        <h1>Banking Made Simple & Secure</h1>
        <p class="mt-4 text-secondary">
            Experience modern digital banking with real-time transfers,
            smart insights, and seamless financial control.
        </p>
        <div class="mt-5">
            <a href="<%= request.getContextPath() %>/sign-up.jsp"
               class="btn btn-hero">Create Free Account</a>
        </div>
    </div>
</section>

<section class="features-section">
    <div class="container">
        <div class="row text-center g-4">

            <div class="col-md-4 d-flex">
                <div class="feature-card w-100">
                    <h5 class="fw-bold mb-3">Instant Transfers</h5>
                    <p class="text-secondary">
                        Send and receive money instantly with secure processing.
                    </p>
                </div>
            </div>

            <div class="col-md-4 d-flex">
                <div class="feature-card w-100">
                    <h5 class="fw-bold mb-3">Smart Dashboard</h5>
                    <p class="text-secondary">
                        Track balance and transactions in real time.
                    </p>
                </div>
            </div>

            <div class="col-md-4 d-flex">
                <div class="feature-card w-100">
                    <h5 class="fw-bold mb-3">Quick Loans</h5>
                    <p class="text-secondary">
                        Apply for short-term loans with fast processing.
                    </p>
                </div>
            </div>

        </div>
    </div>
</section>

<section class="trust-section text-center">
    <div class="container">
        <div class="row g-4">
            <div class="col-md-4">
                <div class="trust-card">
                    <div class="trust-number">2M+</div>
                    <div class="text-secondary">Active Users</div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="trust-card">
                    <div class="trust-number">₹10B+</div>
                    <div class="text-secondary">Transactions Processed</div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="trust-card">
                    <div class="trust-number">99.9%</div>
                    <div class="text-secondary">Secure Infrastructure</div>
                </div>
            </div>
        </div>
    </div>
</section>

<footer>
    © 2026 AceBank. Built for the future of digital finance.
</footer>

<% } else { %>

<div class="container mt-5">

    <div class="dashboard-card mb-5">
        <div class="welcome-text">
            Welcome, <%= firstName %>
        </div>

        <div class="account-text mt-2">
            Account Number: <%= accNo %>
        </div>

        <div class="d-flex justify-content-center align-items-center mt-4">
            <span id="balance" class="balance-text">₹ ••••••</span>
            <button class="eye-btn" onclick="toggleBalance()">👁</button>
        </div>
    </div>

    <div class="row g-4">

        <div class="col-md-6">
            <div class="action-card">
                <h5 class="fw-bold mb-3">Manage Your Account</h5>
                <p class="text-secondary">
                    Deposit money, withdraw funds, transfer between accounts,
                    and view your transaction history.
                </p>
                <a href="<%= request.getContextPath() %>/home"
                   class="btn btn-primary w-100">Manage Account</a>
            </div>
        </div>

        <div class="col-md-6">
            <div class="action-card">
                <h5 class="fw-bold mb-3">Apply for Quick Loan</h5>
                <p class="text-secondary">
                    Instant short-term loans with secure and fast approval.
                </p>
                <a href="<%= request.getContextPath() %>/loan.jsp"
                   class="btn btn-success w-100">Apply For Loan</a>
            </div>
        </div>

    </div>
</div>

<script>
    let visible = false;
    function toggleBalance() {
        const balanceEl = document.getElementById("balance");
        if (!visible) {
            balanceEl.innerHTML = "₹ <%= balance %>";
            visible = true;
        } else {
            balanceEl.innerHTML = "₹ ••••••";
            visible = false;
        }
    }
</script>

<% } %>

</body>
</html>