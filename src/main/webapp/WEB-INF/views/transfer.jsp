<%@ page contentType="text/html;charset=UTF-8" %>
<%
    Integer accNo = (Integer) session.getAttribute("accountNumber");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Transfer Money | AceBank</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #0f172a, #1e3a8a);
            color: #e2e8f0;
        }

        .navbar-custom {
            background: rgba(15, 23, 42, 0.9);
            backdrop-filter: blur(10px);
        }

        .navbar-brand {
            color: #3b82f6 !important;
            font-weight: 700;
        }

        .transfer-card {
            max-width: 500px;
            margin: 80px auto;
            background: #1e293b;
            padding: 40px;
            border-radius: 20px;
            border: 1px solid rgba(255,255,255,0.05);
            transition: 0.4s;
        }

        .transfer-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 50px rgba(59,130,246,0.3);
        }

        .form-control {
            background: #0f172a;
            border: 1px solid rgba(255,255,255,0.1);
            color: white;
        }

        .form-control:focus {
            border-color: #3b82f6;
            box-shadow: 0 0 10px rgba(59,130,246,0.5);
        }

        .btn-transfer {
            background: #3b82f6;
            border: none;
            font-weight: 600;
        }

        .btn-transfer:hover {
            background: #2563eb;
            transform: translateY(-2px);
        }
    </style>
</head>

<body>

<nav class="navbar navbar-custom px-4 py-3">
    <a href="<%= request.getContextPath() %>/home" class="navbar-brand">
        ← AceBank
    </a>
</nav>

<div class="transfer-card text-center">

    <h3 class="fw-bold mb-3">Transfer Money</h3>
    <p class="text-secondary mb-4">
        Send money securely to another account
    </p>

    <form action="<%= request.getContextPath() %>/transfer" method="post">

        <div class="mb-3 text-start">
            <label>Recipient Account Number</label>
            <input type="number" name="toAccount" class="form-control" required>
        </div>

        <div class="mb-4 text-start">
            <label>Amount (₹)</label>
            <input type="number" name="amount" class="form-control" required>
        </div>

        <button type="submit" class="btn btn-transfer w-100 py-2">
            Transfer Now
        </button>

    </form>

</div>

</body>
</html>