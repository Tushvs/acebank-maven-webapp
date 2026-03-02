package com.acebank.lite.controllers;

import com.acebank.lite.service.BankService;
import com.acebank.lite.service.BankServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/deposit")
public class Deposit extends HttpServlet {

    private final BankService bankService = new BankServiceImpl();

    // ✅ Show Deposit Page
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("accountNumber") == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/deposit.jsp")
                .forward(request, response);
    }

    // ✅ Handle Deposit Logic
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("accountNumber") == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        Integer accNo = (Integer) session.getAttribute("accountNumber");
        String amountStr = request.getParameter("amount");

        try {

            // 🔍 Validate input
            if (amountStr == null || amountStr.trim().isEmpty()) {
                request.setAttribute("error", "Amount cannot be empty");
                request.getRequestDispatcher("/WEB-INF/views/deposit.jsp")
                        .forward(request, response);
                return;
            }

            BigDecimal amount = new BigDecimal(amountStr);

            if (amount.compareTo(BigDecimal.ZERO) <= 0) {
                request.setAttribute("error", "Amount must be greater than 0");
                request.getRequestDispatcher("/WEB-INF/views/deposit.jsp")
                        .forward(request, response);
                return;
            }

            // 💰 Perform deposit
            boolean success = bankService.processDeposit(accNo, amount);

            if (!success) {
                request.setAttribute("error", "Deposit failed. Try again.");
                request.getRequestDispatcher("/WEB-INF/views/deposit.jsp")
                        .forward(request, response);
                return;
            }

            // 🔄 Update session balance
            BigDecimal currentBalance =
                    (BigDecimal) session.getAttribute("balance");

            if (currentBalance == null) {
                currentBalance = BigDecimal.ZERO;
            }

            session.setAttribute("balance", currentBalance.add(amount));

            // ✅ REDIRECT TO SUCCESS PAGE (THIS IS THE FIX)
            response.sendRedirect(
                    request.getContextPath()
                            + "/transaction-success.jsp?type=deposit&amount="
                            + amount
            );

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid amount format");
            request.getRequestDispatcher("/WEB-INF/views/deposit.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Something went wrong.");
            request.getRequestDispatcher("/WEB-INF/views/deposit.jsp")
                    .forward(request, response);
        }
    }
}