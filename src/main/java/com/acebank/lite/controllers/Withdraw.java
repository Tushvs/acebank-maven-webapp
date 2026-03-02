package com.acebank.lite.controllers;

import com.acebank.lite.service.BankService;
import com.acebank.lite.service.BankServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/withdraw")
public class Withdraw extends HttpServlet {

    private final BankService bankService = new BankServiceImpl();

    // ================= OPEN WITHDRAW PAGE =================

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("accountNumber") == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/withdraw.jsp")
                .forward(request, response);
    }

    // ================= HANDLE WITHDRAW =================

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("accountNumber") == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        int accountNumber = (int) session.getAttribute("accountNumber");
        String amountStr = request.getParameter("amount");

        try {

            // 🔍 Validate amount presence
            if (amountStr == null || amountStr.isBlank()) {
                request.setAttribute("error", "Amount is required.");
                request.getRequestDispatcher("/WEB-INF/views/withdraw.jsp")
                        .forward(request, response);
                return;
            }

            BigDecimal amount = new BigDecimal(amountStr.trim());

            // 🔍 Validate amount > 0
            if (amount.compareTo(BigDecimal.ZERO) <= 0) {
                request.setAttribute("error", "Amount must be greater than 0.");
                request.getRequestDispatcher("/WEB-INF/views/withdraw.jsp")
                        .forward(request, response);
                return;
            }

            // 🔥 Call service layer
            String result = bankService.withdraw(accountNumber, amount);

            if (!"SUCCESS".equalsIgnoreCase(result)) {
                request.setAttribute("error", result);
                request.getRequestDispatcher("/WEB-INF/views/withdraw.jsp")
                        .forward(request, response);
                return;
            }

            // ✅ Refresh balance from DB instead of subtracting blindly
            BigDecimal updatedBalance = bankService.getBalance(accountNumber);
            session.setAttribute("balance", updatedBalance);

            // ✅ Redirect to success page
            response.sendRedirect(
                    request.getContextPath()
                            + "/transaction-success.jsp?type=withdraw"
                            + "&amount=" + amount
            );

        } catch (NumberFormatException e) {

            request.setAttribute("error", "Invalid amount format.");
            request.getRequestDispatcher("/WEB-INF/views/withdraw.jsp")
                    .forward(request, response);

        } catch (Exception e) {

            e.printStackTrace(); // IMPORTANT for debugging
            request.setAttribute("error", "System error. Please try again.");
            request.getRequestDispatcher("/WEB-INF/views/withdraw.jsp")
                    .forward(request, response);
        }
    }
}