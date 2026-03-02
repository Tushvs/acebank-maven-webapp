package com.acebank.lite.controllers;

import com.acebank.lite.service.BankService;
import com.acebank.lite.service.BankServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/ApplyLoan")
public class ApplyLoan extends HttpServlet {

    private final BankService bankService = new BankServiceImpl();

    // =========================
    // HANDLE FORM SUBMISSION
    // =========================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // 🔐 Security Check
        if (session == null || session.getAttribute("accountNumber") == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        try {

            int accountNumber = (int) session.getAttribute("accountNumber");

            // Get parameters
            String fullName = request.getParameter("name"); // match loan.jsp field
            String email = request.getParameter("email");
            String aadhaar = request.getParameter("aadhaar");
            String pan = request.getParameter("pan");
            String amountStr = request.getParameter("amount");

            // ===== VALIDATION =====

            if (fullName == null || fullName.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/loan.jsp?error=invalidName");
                return;
            }

            if (email == null || !email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {
                response.sendRedirect(request.getContextPath() + "/loan.jsp?error=invalidEmail");
                return;
            }

            if (aadhaar == null || !aadhaar.matches("\\d{12}")) {
                response.sendRedirect(request.getContextPath() + "/loan.jsp?error=invalidAadhaar");
                return;
            }

            if (pan == null || !pan.matches("[A-Z]{5}[0-9]{4}[A-Z]")) {
                response.sendRedirect(request.getContextPath() + "/loan.jsp?error=invalidPan");
                return;
            }

            double amount = Double.parseDouble(amountStr);

            if (amount < 5000 || amount > 50000) {
                response.sendRedirect(request.getContextPath() + "/loan.jsp?error=invalidAmount");
                return;
            }

            // ===== BUSINESS LOGIC =====
            bankService.applyLoan(accountNumber, fullName, email, aadhaar, pan, amount);

            // ✅ PRG Pattern — Redirect to success page
            response.sendRedirect(request.getContextPath() + "/loan-success.jsp");

        } catch (NumberFormatException e) {

            response.sendRedirect(request.getContextPath() + "/loan.jsp?error=invalidAmount");

        } catch (Exception e) {

            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/loan.jsp?error=serverError");
        }
    }
}