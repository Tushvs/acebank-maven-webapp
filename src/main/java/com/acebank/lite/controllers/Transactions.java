package com.acebank.lite.controllers;

import com.acebank.lite.models.Transaction;
import com.acebank.lite.service.BankService;
import com.acebank.lite.service.BankServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/transactions")
public class Transactions extends HttpServlet {

    private final BankService bankService = new BankServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // 🔐 Security check
        if (session == null || session.getAttribute("accountNumber") == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        int accountNumber = (int) session.getAttribute("accountNumber");

        try {
            // ✅ Fetch latest transactions
            List<Transaction> transactions =
                    bankService.getTransactionHistory(accountNumber);

            // Store in request (better than session)
            request.setAttribute("transactions", transactions);

            // Forward to JSP
            request.getRequestDispatcher("/WEB-INF/views/transactions.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}