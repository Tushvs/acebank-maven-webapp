<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Integer accNo = (Integer) session.getAttribute("accountNumber");
    String firstName = (String) session.getAttribute("firstName");

    if (accNo == null) {
        response.sendRedirect(request.getContextPath() + "/Login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Loan Submitted | AceBank</title>
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

        .success-card {
            background: #1e293b;
            border-radius: 20px;
            padding: 60px;
            border: 1px solid rgba(255,255,255,0.05);
            text-align: center;
            transition: 0.35s ease;
        }

        .success-card:hover {
            transform: translateY(-8px) scale(1.02);
            box-shadow: 0 20px 60px rgba(59,130,246,0.3);
        }

        .success-icon {
            font-size: 70px;
            color: #22c55e;
        }

        .btn-home {
            background: #3b82f6;
            color: white;
            padding: 12px 25px;
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

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-custom py-3">
    <div class="container">
        <a class="navbar-brand" href="<%= request.getContextPath() %>/home">
            AceBank
        </a>
    </div>
</nav>

<!-- MAIN -->
<div class="container mt-5 d-flex justify-content-center">

    <div class="col-md-6">

        <div class="success-card">

            <div class="success-icon mb-4">
                <i class="bi bi-check-circle-fill"></i>
            </div>

            <h3 class="fw-bold mb-3">
                Loan Request Submitted Successfully!
            </h3>

            <p class="sub-text mb-4">
                Dear <%= firstName %>, your loan application has been received.
                Our team will review your request and contact you shortly.
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