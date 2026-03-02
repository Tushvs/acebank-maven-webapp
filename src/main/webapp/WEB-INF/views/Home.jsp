<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Account | AceBank</title>
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
            background: rgba(15, 23, 42, 0.95);
            border-bottom: 1px solid rgba(255,255,255,0.05);
            padding: 15px 0;
        }

        .navbar-brand {
            font-weight: 700;
            color: #3b82f6 !important;
        }

        .dashboard-header {
            margin-top: 50px;
            text-align: center;
        }

        .dashboard-header h1 {
            font-size: 2.2rem;
            font-weight: 700;
        }

        .dashboard-header p {
            color: #94a3b8;
        }

        .balance-box {
            background: #1e293b;
            border-radius: 20px;
            padding: 40px;
            margin-top: 30px;
            text-align: center;
            transition: 0.3s ease;
        }

        .balance-box:hover {
            transform: translateY(-6px);
            box-shadow: 0 20px 50px rgba(59,130,246,0.3);
        }

        .balance-amount {
            font-size: 2.5rem;
            font-weight: 800;
            color: #3b82f6;
        }

        .feature-card {
            background: #1e293b;
            border-radius: 18px;
            padding: 35px;
            transition: 0.35s ease;
            height: 100%;
        }

        .feature-card:hover {
            transform: translateY(-10px) scale(1.03);
            box-shadow: 0 20px 50px rgba(59,130,246,0.3);
        }

        .feature-icon {
            font-size: 2rem;
            color: #3b82f6;
            margin-bottom: 15px;
        }

        .feature-card h5 {
            font-weight: 600;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-custom">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/index.jsp">
            <i class="bi bi-arrow-left"></i> AceBank
        </a>

        <div>
            <!-- ✅ UPDATED LINK -->
            <a href="${pageContext.request.contextPath}/change-password"
               class="btn btn-outline-light me-2">
                Reset Password
            </a>

            <a href="${pageContext.request.contextPath}/Logout"
               class="btn btn-danger">
                Logout
            </a>
        </div>
    </div>
</nav>

<div class="container">

    <div class="dashboard-header">
        <h1>Manage Your Account</h1>
        <p>Welcome back, ${sessionScope.firstName}</p>
        <p>Account No: ${sessionScope.accountNumber}</p>
    </div>

    <div class="balance-box">
        <h5>Total Balance</h5>
        <div class="balance-amount">
            ₹ ${sessionScope.balance}
        </div>
        <small class="text-secondary">Available for withdrawal</small>
    </div>

    <div class="row g-4 mt-5">

        <div class="col-md-3">
            <div class="feature-card text-center">
                <div class="feature-icon">
                    <i class="bi bi-cash-stack"></i>
                </div>
                <h5>Deposit Money</h5>
                <p class="text-secondary">
                    Add funds instantly to your account balance.
                </p>
                <a href="${pageContext.request.contextPath}/deposit"
                   class="btn btn-primary w-100">
                    Deposit
                </a>
            </div>
        </div>

        <div class="col-md-3">
            <div class="feature-card text-center">
                <div class="feature-icon">
                    <i class="bi bi-arrow-left-right"></i>
                </div>
                <h5>Transfer Money</h5>
                <p class="text-secondary">
                    Securely send money to another account.
                </p>
                <a href="${pageContext.request.contextPath}/transfer"
                   class="btn btn-success w-100">
                    Transfer
                </a>
            </div>
        </div>

        <div class="col-md-3">
            <div class="feature-card text-center">
                <div class="feature-icon">
                    <i class="bi bi-bank"></i>
                </div>
                <h5>Withdraw Funds</h5>
                <p class="text-secondary">
                    Withdraw money safely from your account.
                </p>
                <a href="${pageContext.request.contextPath}/withdraw"
                   class="btn btn-danger w-100">
                    Withdraw
                </a>
            </div>
        </div>

        <div class="col-md-3">
            <div class="feature-card text-center">
                <div class="feature-icon">
                    <i class="bi bi-clock-history"></i>
                </div>
                <h5>Transaction History</h5>
                <p class="text-secondary">
                    View and download all past transactions.
                </p>
                <a href="${pageContext.request.contextPath}/transactions"
                   class="btn btn-dark w-100">
                    View Transactions
                </a>
            </div>
        </div>

    </div>

</div>

</body>
</html>