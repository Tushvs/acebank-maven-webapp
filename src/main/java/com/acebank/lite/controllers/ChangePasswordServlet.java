package com.acebank.lite.controllers;

import com.acebank.lite.service.BankService;
import com.acebank.lite.service.BankServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/change-password")
public class ChangePasswordServlet extends HttpServlet {

    private final BankService bankService = new BankServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("accountNumber") == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        request.getRequestDispatcher("/change-password.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("accountNumber") == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        int accountNo = (int) session.getAttribute("accountNumber");

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (currentPassword == null || newPassword == null || confirmPassword == null ||
                currentPassword.isBlank() || newPassword.isBlank() || confirmPassword.isBlank()) {

            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("/change-password.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "New passwords do not match.");
            request.getRequestDispatcher("/change-password.jsp").forward(request, response);
            return;
        }

        if (newPassword.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters.");
            request.getRequestDispatcher("/change-password.jsp").forward(request, response);
            return;
        }

        try {
            boolean changed = bankService.changePassword(accountNo, currentPassword, newPassword);

            if (!changed) {
                request.setAttribute("error", "Current password is incorrect.");
                request.getRequestDispatcher("/change-password.jsp").forward(request, response);
                return;
            }

            response.sendRedirect(request.getContextPath() + "/password-success.jsp");

        } catch (Exception e) {
            request.setAttribute("error", "Something went wrong. Try again.");
            request.getRequestDispatcher("/change-password.jsp").forward(request, response);
        }
    }
}