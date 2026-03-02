<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("accountNumber") == null) {
        response.sendRedirect(request.getContextPath() + "/Login");
        return;
    }

    String type = request.getParameter("type");
    String amount = request.getParameter("amount");
    String toAccount = request.getParameter("to");

    String title = "";
    String message = "";

    if ("deposit".equalsIgnoreCase(type)) {
        title = "Deposit Successful!";
        message = "₹ " + amount + " has been successfully deposited into your account.";
    }
    else if ("transfer".equalsIgnoreCase(type)) {
        title = "Transfer Successful!";
        message = "₹ " + amount + " has been successfully transferred to Account No: " + toAccount + ".";
    }
    else if ("withdraw".equalsIgnoreCase(type)) {
        title = "Withdrawal Successful!";
        message = "₹ " + amount + " has been successfully withdrawn from your account.";
    }
    else {
        title = "Transaction Completed";
        message = "Your transaction was processed successfully.";
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Transaction Success | AceBank</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <!-- Font -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Inter', sans-serif;
            background: #0f172a;
            color: #e2e8f0;
        }

        .success-card {
            background: #1e293b;
            border-radius: 20px;
            padding: 60px;
            margin-top: 120px;
            text-align: center;
            border: 1px solid rgba(255,255,255,0.05);
            transition: 0.35s ease;
        }

        .success-card:hover {
            transform: translateY(-8px) scale(1.02);
            box-shadow: 0 25px 70px rgba(34,197,94,0.35);
        }

        .success-icon {
            font-size: 70px;
            color: #22c55e;
        }

        .btn-home {
            background: #3b82f6;
            color: white;
            padding: 12px 30px;
            border-radius: 8px;
            border: none;
            font-weight: 600;
            transition: 0.3s;
        }

        .btn-home:hover {
            background: #2563eb;
            transform: translateY(-2px);
        }

        .sub-text {
            color: #94a3b8;
        }
    </style>
</head>

<body>

<div class="container d-flex justify-content-center">
    <div class="col-md-6">
        <div class="success-card">

            <div class="success-icon mb-4">
                <i class="bi bi-check-circle-fill"></i>
            </div>

            <h3 class="fw-bold mb-3">
                <%= title %>
            </h3>

            <p class="sub-text mb-4">
                <%= message %>
            </p>

            <a href="<%= request.getContextPath() %>/home"
               class="btn btn-home">
                Back to Dashboard
            </a>

        </div>
    </div>
</div>

</body>
</html>