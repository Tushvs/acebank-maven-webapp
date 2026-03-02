<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Transactions | AceBank</title>
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

        .navbar-custom {
            background: rgba(15, 23, 42, 0.9);
            backdrop-filter: blur(10px);
        }

        .navbar-brand {
            color: #3b82f6 !important;
            font-weight: 700;
        }

        .table-card {
            max-width: 1100px;
            margin: 60px auto;
            background: #1e293b;
            padding: 40px;
            border-radius: 20px;
            border: 1px solid rgba(255,255,255,0.05);
            transition: 0.4s;
        }

        .table-card:hover {
            box-shadow: 0 20px 50px rgba(59,130,246,0.25);
        }

        table {
            color: white;
        }

        .badge-deposit {
            background: #16a34a;
        }

        .badge-withdraw {
            background: #dc2626;
        }

        .badge-transfer {
            background: #3b82f6;
        }
    </style>
</head>

<body>

<!-- NAVBAR -->
<nav class="navbar navbar-custom px-4 py-3">
    <a href="${pageContext.request.contextPath}/home" class="navbar-brand">
        ← AceBank
    </a>
</nav>

<div class="table-card">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold">Transaction History</h3>
        <span class="text-secondary">
            Account: ${sessionScope.accountNumber}
        </span>
    </div>

    <!-- TABLE -->
    <div class="table-responsive">
        <table class="table table-dark table-hover align-middle">

            <thead>
            <tr>
                <th>Date</th>
                <th>Type</th>
                <th>Reference</th>
                <th class="text-end">Amount (₹)</th>
            </tr>
            </thead>

            <tbody>

            <!-- 🔥 FIX: using request attribute -->
            <c:forEach var="tx" items="${transactions}">

                <tr>

                    <td>${tx.createdAt()}</td>

                    <td>
                        <c:choose>

                            <c:when test="${tx.txType() == 'DEPOSIT'}">
                                <span class="badge badge-deposit px-3 py-2">
                                    ${tx.txType()}
                                </span>
                            </c:when>

                            <c:when test="${tx.txType() == 'WITHDRAW'}">
                                <span class="badge badge-withdraw px-3 py-2">
                                    ${tx.txType()}
                                </span>
                            </c:when>

                            <c:otherwise>
                                <span class="badge badge-transfer px-3 py-2">
                                    ${tx.txType()}
                                </span>
                            </c:otherwise>

                        </c:choose>
                    </td>

                    <td>${tx.remark()}</td>

                    <td class="text-end fw-bold">
                        ₹ ${tx.amount()}
                    </td>

                </tr>

            </c:forEach>

            </tbody>
        </table>
    </div>

</div>

</body>
</html>