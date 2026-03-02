<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Integer accNo = (Integer) session.getAttribute("accountNumber");
    String firstName = (String) session.getAttribute("firstName");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Loan | AceBank</title>
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

        .back-icon {
            font-size: 0.9rem;
            color: #94a3b8;
            transition: 0.2s;
        }

        .back-icon:hover {
            color: #3b82f6;
            transform: translateX(-3px);
        }

        .loan-card {
            background: #1e293b;
            border-radius: 20px;
            padding: 50px;
            border: 1px solid rgba(255,255,255,0.05);
            transition: 0.35s ease;
        }

        .loan-card:hover {
            transform: translateY(-8px) scale(1.01);
            box-shadow: 0 20px 60px rgba(59,130,246,0.25);
        }

        .form-control, .form-select {
            background: #0f172a;
            border: 1px solid rgba(255,255,255,0.08);
            color: white;
            padding: 12px;
            border-radius: 8px;
        }

        .form-control:focus, .form-select:focus {
            background: #020617;
            border-color: #3b82f6;
            box-shadow: none;
            color: white;
        }

        .btn-loan {
            background: #3b82f6;
            color: white;
            padding: 12px;
            border-radius: 8px;
            border: none;
            transition: 0.3s;
            font-weight: 600;
        }

        .btn-loan:hover {
            background: #2563eb;
            transform: translateY(-2px);
        }

        .sub-text {
            color: #94a3b8;
        }

        .error-box {
            background: rgba(220, 53, 69, 0.1);
            border: 1px solid rgba(220, 53, 69, 0.4);
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            color: #ff6b6b;
        }
    </style>
</head>

<body>

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-custom py-3">
    <div class="container">
        <a class="navbar-brand" href="javascript:history.back()">
            <i class="bi bi-arrow-left back-icon"></i>
            AceBank
        </a>
    </div>
</nav>

<!-- MAIN -->
<div class="container mt-5 d-flex justify-content-center">

    <div class="col-md-6">

        <div class="loan-card">

            <h3 class="fw-bold text-center mb-3">Loan Application</h3>
            <p class="text-center sub-text mb-4">
                Apply for instant short-term loans between ₹5,000 – ₹50,000
            </p>

            <% if (error != null) { %>
                <div class="error-box text-center">
                    <% if ("invalidName".equals(error)) { %>
                        Please enter a valid full name.
                    <% } else if ("invalidEmail".equals(error)) { %>
                        Please enter a valid email address.
                    <% } else if ("invalidAadhaar".equals(error)) { %>
                        Aadhaar must be 12 digits.
                    <% } else if ("invalidPan".equals(error)) { %>
                        PAN format is invalid.
                    <% } else if ("invalidAmount".equals(error)) { %>
                        Loan amount must be between ₹5,000 and ₹50,000.
                    <% } else { %>
                        Something went wrong. Please try again.
                    <% } %>
                </div>
            <% } %>

            <form action="<%= request.getContextPath() %>/ApplyLoan" method="POST">

                <div class="mb-3">
                    <label>Full Name</label>
                    <input type="text" name="name" class="form-control" required>
                </div>

                <div class="mb-3">
                    <label>Email Address</label>
                    <input type="email" name="email" class="form-control" required>
                </div>

                <div class="mb-3">
                    <label>Aadhaar Number</label>
                    <input type="text" name="aadhaar" class="form-control" required>
                </div>

                <div class="mb-3">
                    <label>PAN Number</label>
                    <input type="text" name="pan" class="form-control" required>
                </div>

                <div class="mb-4">
                    <label>Loan Amount (₹)</label>
                    <select name="amount" class="form-select" required>
                        <option value="">Select Amount</option>
                        <option>5000</option>
                        <option>10000</option>
                        <option>20000</option>
                        <option>30000</option>
                        <option>50000</option>
                    </select>
                </div>

                <button type="submit" class="btn btn-loan w-100">
                    Submit Application
                </button>

            </form>

            <p class="text-center sub-text mt-4">
                Your information is securely encrypted and protected.
            </p>

        </div>

    </div>
</div>

</body>
</html>