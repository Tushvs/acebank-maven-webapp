package com.acebank.lite.controllers;

import com.acebank.lite.models.Transaction;
import com.acebank.lite.service.BankService;
import com.acebank.lite.service.BankServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import lombok.extern.java.Log;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@Log
@WebServlet("/home")
public class Home extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final BankService bankService = new BankServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // 🔐 Security check
        if (session == null || session.getAttribute("accountNumber") == null) {
            log.warning("Unauthorized access attempt to /home");
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        int accountNumber = (int) session.getAttribute("accountNumber");

        try {
            // Refresh latest balance + transactions
            updateSessionData(session, accountNumber);

            // ✅ CORRECT: Forward to REAL dashboard
            request.getRequestDispatcher("/WEB-INF/views/Home.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            log.severe("Error rendering Home Dashboard: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Dashboard load failed.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("accountNumber") == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        int accountNumber = (int) session.getAttribute("accountNumber");

        String depositAmtStr = request.getParameter("deposit");
        String toAccountStr = request.getParameter("toAccount");
        String toAmountStr = request.getParameter("toAmount");
        String withdrawAmount = request.getParameter("withdraw");

        try {

            // 💰 Deposit
            if (depositAmtStr != null && !depositAmtStr.trim().isEmpty()) {
                BigDecimal amount = new BigDecimal(depositAmtStr);
                bankService.processDeposit(accountNumber, amount);
            }

            // 🏧 Withdraw
            else if (withdrawAmount != null && !withdrawAmount.trim().isEmpty()) {
                BigDecimal amount = new BigDecimal(withdrawAmount);
                bankService.withdraw(accountNumber, amount);
            }

            // 🔁 Transfer
            else if (toAccountStr != null &&
                    toAmountStr != null &&
                    !toAccountStr.trim().isEmpty()) {

                int recipientAcc = Integer.parseInt(toAccountStr);
                BigDecimal amount = new BigDecimal(toAmountStr);
                bankService.processTransfer(accountNumber, recipientAcc, amount);
            }

        } catch (Exception e) {
            log.severe("Transaction Error: " + e.getMessage());
        }

        // PRG Pattern (Prevents form resubmission)
        response.sendRedirect(request.getContextPath() + "/home");
    }

    private void updateSessionData(HttpSession session, int accountNumber) {

        log.info("Refreshing session data for account: " + accountNumber);

        BigDecimal newBalance =
                bankService.getBalance(accountNumber);

        List<Transaction> newList =
                bankService.getTransactionHistory(accountNumber);

        session.setAttribute("balance", newBalance);
        session.setAttribute("transactionDetailsList", newList);
    }
}