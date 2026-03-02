package com.acebank.lite.service;

import com.acebank.lite.dao.BankUserDao;
import com.acebank.lite.dao.BankUserDaoImpl;
import com.acebank.lite.dao.LoanDao;
import com.acebank.lite.dao.LoanDaoImpl;
import com.acebank.lite.models.*;
import com.acebank.lite.util.MailUtil;
import com.acebank.lite.util.PasswordUtil;
import lombok.extern.java.Log;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.ThreadLocalRandom;

@Log
public class BankServiceImpl implements BankService {

    private final BankUserDao userDao = new BankUserDaoImpl();
    private final LoanDao loanDao = new LoanDaoImpl();
    private static final BigDecimal DAILY_LIMIT = new BigDecimal("500.00");

    // ================= AUTH =================

    @Override
    public Optional<LoginResult> authenticate(int accountNo, String plainPassword) {

        try {
            String storedHash = userDao.getPasswordHash(accountNo);

            if (storedHash == null) {
                return Optional.empty();
            }

            if (PasswordUtil.checkPassword(plainPassword, storedHash)) {
                return Optional.of(userDao.getUserDetails(accountNo));
            }

        } catch (SQLException e) {
            log.severe("Database error during login: " + e.getMessage());
        }

        return Optional.empty();
    }

    // 🔥 FIXED VERSION
    @Override
    public boolean changePassword(int accountNo, String oldPlain, String newPlain) throws SQLException {

        String storedHash = userDao.getPasswordHash(accountNo);

        if (storedHash == null) {
            return false;
        }

        if (!PasswordUtil.checkPassword(oldPlain, storedHash)) {
            return false;
        }

        String newSecureHash = PasswordUtil.hashPassword(newPlain);

        return userDao.updatePassword(accountNo, newSecureHash);
    }

    // ================= DEPOSIT =================

    @Override
    public boolean processDeposit(int accountNo, BigDecimal amount) {

        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            return false;
        }

        try {
            return userDao.deposit(accountNo, amount);
        } catch (SQLException e) {
            log.severe("Deposit Error for " + accountNo + ": " + e.getMessage());
            return false;
        }
    }

    // ================= WITHDRAW =================

    @Override
    public String withdraw(int accountNo, BigDecimal amount) {

        try {

            if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
                return "Invalid amount.";
            }

            BigDecimal alreadyWithdrawn = userDao.getDailyWithdrawalTotal(accountNo);
            BigDecimal projectedTotal = alreadyWithdrawn.add(amount);

            if (projectedTotal.compareTo(DAILY_LIMIT) > 0) {
                BigDecimal remaining = DAILY_LIMIT.subtract(alreadyWithdrawn);
                return "Limit exceeded. You can only withdraw ₹" + remaining + " more today.";
            }

            boolean success = userDao.withdraw(accountNo, amount);
            return success ? "SUCCESS" : "Insufficient balance or account error.";

        } catch (SQLException e) {
            log.severe("Withdraw error: " + e.getMessage());
            return "System error. Please try later.";
        }
    }

    // ================= REGISTER =================

    @Override
    public Optional<LoginResult> registerUser(User user) {

        int accountNumber = ThreadLocalRandom.current().nextInt(10000000, 99999999);

        String secureHash = PasswordUtil.hashPassword(user.passwordHash());

        User secureUser = new User(
                user.userId(),
                user.firstName(),
                user.lastName(),
                user.aadhaarNo(),
                user.email(),
                secureHash,
                user.createdAt()
        );

        try {

            boolean isSaved = userDao.signUp(secureUser, accountNumber);

            if (isSaved) {

                sendWelcomeEmail(user, accountNumber);

                return Optional.of(new LoginResult(
                        user.firstName(),
                        user.lastName(),
                        user.email(),
                        BigDecimal.ZERO,
                        accountNumber
                ));
            }

        } catch (Exception e) {
            log.severe("Signup Error: " + e.getMessage());
        }

        return Optional.empty();
    }

    private void sendWelcomeEmail(User user, int accNo) {

        String subject = "Welcome to AceBank";

        String body = String.format(
                "Dear %s,\n\nWelcome! Your account number is: %d.\nKeep it safe!\n\nAceBank Team",
                user.firstName(), accNo
        );

        MailUtil.sendMailAsync(user.email(), subject, body);
    }

    // ================= BALANCE =================

    @Override
    public BigDecimal getBalance(int accountNo) {

        try {
            return userDao.getBalance(accountNo);
        } catch (SQLException e) {
            log.severe("Could not fetch balance for: " + accountNo);
            return BigDecimal.ZERO;
        }
    }

    @Override
    public List<Transaction> getTransactionHistory(int accountNo) {

        try {
            return userDao.getStatement(accountNo);
        } catch (SQLException e) {
            log.severe("Could not fetch transactions for: " + accountNo);
            return List.of();
        }
    }

    // ================= TRANSFER =================

    @Override
    public ServiceResponse processTransfer(int fromAcc, int toAcc, BigDecimal amount) {

        if (fromAcc == toAcc) {
            return new ServiceResponse(false, "You cannot transfer money to your own account.");
        }

        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            return new ServiceResponse(false, "Please enter a valid amount greater than zero.");
        }

        try {

            if (!userDao.accountExists(toAcc)) {
                return new ServiceResponse(false, "Recipient account number " + toAcc + " not found.");
            }

            BigDecimal currentBalance = userDao.getBalance(fromAcc);

            if (currentBalance.compareTo(amount) < 0) {
                return new ServiceResponse(false,
                        "Insufficient balance. Your current balance is ₹" + currentBalance);
            }

            boolean success = userDao.transfer(fromAcc, toAcc, amount);

            if (success) {
                log.info("Transfer Successful: ₹" + amount + " from " + fromAcc + " to " + toAcc);
                return new ServiceResponse(true, "Transfer Successful!");
            }

            return new ServiceResponse(false, "Transfer could not be processed. Please try again.");

        } catch (SQLException e) {
            log.severe("SQL Error during transfer: " + e.getMessage());
            return new ServiceResponse(false, "Database connection error.");
        }
    }

    // ================= RECOVERY =================

    @Override
    public boolean recoverAccount(String email) {

        try {

            Optional<AccountRecoveryDTO> detailsOpt = userDao.getRecoveryDetails(email);

            if (detailsOpt.isPresent()) {

                AccountRecoveryDTO details = detailsOpt.get();

                String subject = "AceBank - Account Recovery";

                String body = "Hi " + details.firstName() + " " + details.lastName() + ",\n\n"
                        + "Account Number: " + details.accountNo() + "\n\n"
                        + "For security reasons, password is not shared.\n\n"
                        + "AceBank Team";

                MailUtil.sendMailAsync(email, subject, body);
                return true;
            }

        } catch (Exception e) {
            log.severe("Recovery failed: " + e.getMessage());
        }

        return false;
    }

    // ================= LOAN =================

    @Override
    public void applyLoan(int accountNumber,
                          String fullName,
                          String email,
                          String aadhaar,
                          String pan,
                          double amount) throws Exception {

        if (amount < 5000 || amount > 50000) {
            throw new IllegalArgumentException("Loan amount must be between 5000 and 50000");
        }

        Loan loan = new Loan(accountNumber, fullName, aadhaar, pan, amount);
        loanDao.applyLoan(loan);

        String subject = "Loan Application Received - AceBank";

        String body = String.format(
                "Dear %s,\n\nYour loan request of ₹%.2f has been submitted successfully.\n\n"
                        + "Our team will review it shortly.\n\nRegards,\nAceBank Team",
                fullName, amount
        );

        MailUtil.sendMailAsync(email, subject, body);
    }

    @Override
    public boolean applyForLoan(String firstName, String email, String loanType) {

        String subject = "Loan Application Received - AceBank";

        String body = String.format(
                "Dear %s,\n\nThank you for applying for a %s loan.\n\nAceBank Team",
                firstName, loanType
        );

        try {
            MailUtil.sendMailAsync(email, subject, body);
            return true;
        } catch (Exception e) {
            log.severe("Failed to send loan confirmation email: " + e.getMessage());
            return false;
        }
    }
}