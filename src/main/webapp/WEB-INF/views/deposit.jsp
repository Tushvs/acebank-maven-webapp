<%@ page contentType="text/html;charset=UTF-8" %>
<%
    Integer accNo = (Integer) session.getAttribute("accountNumber");
    String firstName = (String) session.getAttribute("firstName");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Deposit Money | AceBank</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #0f172a, #1e3a8a);
            color: #e2e8f0;
        }

        /* Navbar */
        .navbar-custom {
            background: rgba(15, 23, 42, 0.9);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid rgba(255,255,255,0.05);
        }

        .navbar-brand {
            color: #3b82f6 !important;
            font-weight: 700;
        }

        /* Card */
        .deposit-card {
            max-width: 450px;
            margin: 80px auto;
            background: #1e293b;
            border-radius: 20px;
            padding: 40px;
            border: 1px solid rgba(255,255,255,0.05);
            transition: 0.4s ease;
        }

        .deposit-card:hover {
            transform: translateY(-10px) scale(1.02);
            box-shadow: 0 20px 50px rgba(59,130,246,0.3);
        }

        .form-control {
            background: #0f172a;
            border: 1px solid rgba(255,255,255,0.1);
            color: white;
        }

        .form-control:focus {
            background: #0f172a;
            color: white;
            border-color: #3b82f6;
            box-shadow: 0 0 10px rgba(59,130,246,0.5);
        }

        .btn-deposit {
            background: #3b82f6;
            border: none;
            font-weight: 600;
            transition: 0.3s;
        }

        .btn-deposit:hover {
            background: #2563eb;
            transform: translateY(-2px);
        }

        .back-btn {
            font-size: 0.9rem;
            text-decoration: none;
            color: #94a3b8;
        }

        .back-btn:hover {
            color: #3b82f6;
        }
    </style>
</head>

<body>

<!-- NAVBAR -->
<nav class="navbar navbar-custom px-4 py-3">
    <a href="<%= request.getContextPath() %>/home" class="navbar-brand">
        ← AceBank
    </a>
</nav>

<!-- CARD -->
<div class="deposit-card text-center">

    <h3 class="fw-bold mb-3">Deposit Money</h3>
    <p class="text-secondary mb-4">
        Add funds securely to your account
    </p>

    <form action="<%= request.getContextPath() %>/deposit" method="post">

        <div class="mb-4 text-start">
            <label class="form-label">Enter Amount (₹)</label>
            <input type="number"
                   name="amount"
                   class="form-control"
                   placeholder="e.g. 5000"
                   required>
        </div>

        <button type="submit" class="btn btn-deposit w-100 py-2">
            Deposit Now
        </button>

    </form>

    <div class="mt-4">
        <a href="<%= request.getContextPath() %>/home" class="back-btn">
            ← Back to Dashboard
        </a>
    </div>

</div>

</body>
</html>