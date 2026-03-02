<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Integer accNo = (Integer) session.getAttribute("accountNumber");
    if (accNo == null) {
        response.sendRedirect(request.getContextPath() + "/Login");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Reset Password | AceBank</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Inter', sans-serif;
            background: #0f172a;
            color: #e2e8f0;
        }

        .card-box {
            background: #1e293b;
            padding: 50px;
            border-radius: 20px;
            margin-top: 100px;
            transition: 0.3s;
        }

        .card-box:hover {
            transform: translateY(-6px);
            box-shadow: 0 20px 60px rgba(59,130,246,0.3);
        }

        .form-control {
            background: #0f172a;
            border: 1px solid rgba(255,255,255,0.1);
            color: white;
        }

        .form-control:focus {
            background: #020617;
            color: white;
            border-color: #3b82f6;
            box-shadow: none;
        }

        .btn-custom {
            background: #3b82f6;
            border: none;
        }

        .btn-custom:hover {
            background: #2563eb;
        }
    </style>
</head>
<body>

<div class="container d-flex justify-content-center">
    <div class="col-md-5">
        <div class="card-box">

            <h3 class="text-center mb-4">Reset Password</h3>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <form method="POST" action="<%= request.getContextPath() %>/change-password">

                <div class="mb-3">
                    <label>Current Password</label>
                    <input type="password" name="currentPassword" class="form-control" required>
                </div>

                <div class="mb-3">
                    <label>New Password</label>
                    <input type="password" name="newPassword" class="form-control" required>
                </div>

                <div class="mb-4">
                    <label>Confirm New Password</label>
                    <input type="password" name="confirmPassword" class="form-control" required>
                </div>

                <button type="submit" class="btn btn-custom w-100">
                    Update Password
                </button>

            </form>

        </div>
    </div>
</div>

</body>
</html>