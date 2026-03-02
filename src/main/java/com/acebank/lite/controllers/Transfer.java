package com.acebank.lite.controllers;

import com.acebank.lite.models.ServiceResponse;
import com.acebank.lite.service.BankService;
import com.acebank.lite.service.BankServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/transfer")
public class Transfer extends HttpServlet {

    private final BankService bankService = new BankServiceImpl();

    // ✅ OPEN TRANSFER PAGE
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("accountNumber") == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/transfer.jsp")
                .forward(request, response);
    }

    // ✅ HANDLE TRANSFER
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("accountNumber") == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        int fromAcc = (int) session.getAttribute("accountNumber");

        String toAccStr = request.getParameter("toAccount");
        String amountStr = request.getParameter("amount");

        try {

            // 🔍 Basic validation
            if (toAccStr == null || amountStr == null ||
                    toAccStr.isBlank() || amountStr.isBlank()) {

                request.setAttribute("error", "All fields are required.");
                request.getRequestDispatcher("/WEB-INF/views/transfer.jsp")
                        .forward(request, response);
                return;
            }

            int toAcc = Integer.parseInt(toAccStr);
            BigDecimal amount = new BigDecimal(amountStr);

            if (amount.compareTo(BigDecimal.ZERO) <= 0) {
                request.setAttribute("error", "Amount must be greater than 0.");
                request.getRequestDispatcher("/WEB-INF/views/transfer.jsp")
                        .forward(request, response);
                return;
            }

            ServiceResponse result =
                    bankService.processTransfer(fromAcc, toAcc, amount);

            if (!result.success()) {
                request.setAttribute("error", result.message());
                request.getRequestDispatcher("/WEB-INF/views/transfer.jsp")
                        .forward(request, response);
                return;
            }

            // ✅ Update session balance
            BigDecimal currentBalance =
                    (BigDecimal) session.getAttribute("balance");

            if (currentBalance == null) {
                currentBalance = BigDecimal.ZERO;
            }

            session.setAttribute("balance",
                    currentBalance.subtract(amount));

            // ✅ Redirect to success page
            response.sendRedirect(
                    request.getContextPath()
                            + "/transaction-success.jsp?type=transfer"
                            + "&amount=" + amount
                            + "&to=" + toAcc
            );

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid input format.");
            request.getRequestDispatcher("/WEB-INF/views/transfer.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Something went wrong.");
            request.getRequestDispatcher("/WEB-INF/views/transfer.jsp")
                    .forward(request, response);
        }
    }
}