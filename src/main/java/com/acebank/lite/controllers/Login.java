package com.acebank.lite.controllers;

import java.io.IOException;
import java.io.Serial;
import java.util.List;
import java.util.Optional;

import com.acebank.lite.dao.BankUserDao;
import com.acebank.lite.dao.BankUserDaoImpl;
import com.acebank.lite.models.LoginResult;
import com.acebank.lite.models.Transaction;
import com.acebank.lite.service.BankService;
import com.acebank.lite.service.BankServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import lombok.extern.java.Log;

@Log
@WebServlet(name = "Login", urlPatterns = "/Login")
public class Login extends HttpServlet {

    @Serial
    private static final long serialVersionUID = 1L;

    private final BankService bankService = new BankServiceImpl();
    private final BankUserDao userDao = new BankUserDaoImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accStr = request.getParameter("accountNumber");
        String password = request.getParameter("password");

        try {
            int accountNo = Integer.parseInt(accStr);

            Optional<LoginResult> loginResultOpt =
                    bankService.authenticate(accountNo, password);

            if (loginResultOpt.isPresent()) {

                var details = loginResultOpt.get();
                HttpSession session = request.getSession(true);

                session.setAttribute("accountNumber", accountNo);
                session.setAttribute("firstName", details.firstName());
                session.setAttribute("lastName", details.lastName());
                session.setAttribute("email", details.email());
                session.setAttribute("balance", details.balance());

                List<Transaction> statement =
                        userDao.getStatement(accountNo);

                session.setAttribute("transactionDetailsList", statement);

                log.info("User " + accountNo + " logged in successfully.");

                // 🔥 CHANGE HERE
                // Redirect to summary page instead of full dashboard
                response.sendRedirect(request.getContextPath() + "/index.jsp");

            } else {
                log.warning("Authentication failed for account: " + accStr);
                response.sendRedirect(request.getContextPath() + "/Login");
            }

        } catch (Exception e) {
            log.severe("Login Error: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/Login");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("login.jsp")
                .forward(request, response);
    }
}