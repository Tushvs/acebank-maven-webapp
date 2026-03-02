<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("accountNumber") == null) {
        response.sendRedirect(request.getContextPath() + "/Login");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Password Updated | AceBank</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            background: #0f172a;
            color: #e2e8f0;
            font-family: 'Inter', sans-serif;
        }

        .success-box {
            background: #1e293b;
            padding: 60px;
            border-radius: 20px;
            margin-top: 150px;
            text-align: center;
        }

        .success-box:hover {
            transform: translateY(-6px);
            box-shadow: 0 20px 60px rgba(34,197,94,0.4);
        }

        .btn-home {
            background: #3b82f6;
            border: none;
        }
    </style>
</head>
<body>

<div class="container d-flex justify-content-center">
    <div class="col-md-6">
        <div class="success-box">
            <h3 class="mb-3">Password Updated Successfully!</h3>
            <p>Your login password has been changed securely.</p>
            <a href="<%= request.getContextPath() %>/home" class="btn btn-home">
                Back to Dashboard
            </a>
        </div>
    </div>
</div>

</body>
</html>