package com.acebank.lite.dao;

import com.acebank.lite.models.AccountRecoveryDTO;
import com.acebank.lite.models.LoginResult;
import com.acebank.lite.models.Transaction;
import com.acebank.lite.models.User;
import com.acebank.lite.util.ConnectionManager;
import com.acebank.lite.util.QueryLoader;
import lombok.extern.java.Log;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Log
public class BankUserDaoImpl implements BankUserDao {

    private Connection getConnection() throws SQLException {
        return ConnectionManager.getConnection();
    }

    // ================= PASSWORD =================

    @Override
    public String getPasswordHash(int accountNo) throws SQLException {
        String sql = QueryLoader.get("user.get_password_by_acc");

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, accountNo);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("PASSWORD_HASH");
                }
            }
        }
        return null;
    }

    @Override
    public boolean updatePassword(int accountNo, String newHash) throws SQLException {
        String sql = QueryLoader.get("user.update_password_by_acc");

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newHash);
            ps.setInt(2, accountNo);

            return ps.executeUpdate() > 0;
        }
    }

    // ================= DAILY WITHDRAWAL =================

    @Override
    public BigDecimal getDailyWithdrawalTotal(int accountNo) throws SQLException {

        String sql = QueryLoader.get("transaction.get_daily_withdrawal_total");

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, accountNo);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    BigDecimal total = rs.getBigDecimal(1);
                    return total != null ? total : BigDecimal.ZERO;
                }
            }
        }
        return BigDecimal.ZERO;
    }

    // ================= LOGIN =================

    @Override
    public boolean login(int accountNo, String password) throws SQLException {
        String sql = "SELECT 1 FROM ACCOUNTS WHERE ACCOUNT_NO = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, accountNo);

            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    // ================= USER DETAILS =================

    @Override
    public LoginResult getUserDetails(int accountNo) throws SQLException {
        String sql = QueryLoader.get("user.get_details");

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, accountNo);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return new LoginResult(
                            rs.getString("FIRST_NAME"),
                            rs.getString("LAST_NAME"),
                            rs.getString("EMAIL"),
                            rs.getBigDecimal("BALANCE"),
                            rs.getInt("ACCOUNT_NO")
                    );
                }
            }
        }

        throw new SQLException("User details not found for account: " + accountNo);
    }

    // ================= SIGNUP =================

    @Override
    public boolean signUp(User user, int accountNo) throws SQLException {

        try (Connection conn = getConnection()) {

            conn.setAutoCommit(false);

            try {
                PreparedStatement ps1 = conn.prepareStatement(
                        QueryLoader.get("user.signup"),
                        Statement.RETURN_GENERATED_KEYS);

                ps1.setString(1, user.firstName());
                ps1.setString(2, user.lastName());
                ps1.setString(3, user.aadhaarNo());
                ps1.setString(4, user.email());
                ps1.setString(5, user.passwordHash());
                ps1.executeUpdate();

                ResultSet rs = ps1.getGeneratedKeys();

                if (rs.next()) {
                    PreparedStatement ps2 = conn.prepareStatement(QueryLoader.get("account.create"));
                    ps2.setInt(1, accountNo);
                    ps2.setInt(2, rs.getInt(1));
                    ps2.executeUpdate();
                }

                conn.commit();
                return true;

            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        }
    }

    // ================= DEPOSIT =================

    @Override
    public boolean deposit(int accountNo, BigDecimal amount) throws SQLException {

        try (Connection conn = getConnection()) {

            conn.setAutoCommit(false);

            try {
                PreparedStatement ps1 = conn.prepareStatement(QueryLoader.get("account.deposit"));
                ps1.setBigDecimal(1, amount);
                ps1.setInt(2, accountNo);
                ps1.executeUpdate();

                PreparedStatement ps2 = conn.prepareStatement(QueryLoader.get("transaction.log"));
                ps2.setInt(1, accountNo);
                ps2.setInt(2, accountNo);
                ps2.setBigDecimal(3, amount);
                ps2.setString(4, "DEPOSIT");
                ps2.setString(5, "Self");
                ps2.executeUpdate();

                conn.commit();
                return true;

            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        }
    }

    // ================= WITHDRAW =================

    @Override
    public boolean withdraw(int accountNo, BigDecimal amount) throws SQLException {

        try (Connection conn = getConnection()) {

            conn.setAutoCommit(false);

            try {
                PreparedStatement psUpdate =
                        conn.prepareStatement(QueryLoader.get("account.withdraw_balance"));

                psUpdate.setBigDecimal(1, amount);
                psUpdate.setInt(2, accountNo);
                psUpdate.setBigDecimal(3, amount);

                if (psUpdate.executeUpdate() == 0) {
                    throw new SQLException("Insufficient funds.");
                }

                PreparedStatement psLog =
                        conn.prepareStatement(QueryLoader.get("transaction.log_withdrawal"));

                psLog.setInt(1, accountNo);
                psLog.setInt(2, accountNo);
                psLog.setBigDecimal(3, amount);
                psLog.executeUpdate();

                conn.commit();
                return true;

            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        }
    }

    // ================= TRANSFER =================

    @Override
    public boolean transfer(int fromAcc, int toAcc, BigDecimal amount) throws SQLException {

        try (Connection conn = getConnection()) {

            conn.setAutoCommit(false);

            try {
                PreparedStatement ps1 = conn.prepareStatement(QueryLoader.get("account.withdraw"));
                ps1.setBigDecimal(1, amount);
                ps1.setInt(2, fromAcc);
                ps1.setBigDecimal(3, amount);

                if (ps1.executeUpdate() == 0) {
                    conn.rollback();
                    return false;
                }

                PreparedStatement ps2 = conn.prepareStatement(QueryLoader.get("account.deposit"));
                ps2.setBigDecimal(1, amount);
                ps2.setInt(2, toAcc);
                ps2.executeUpdate();

                PreparedStatement ps3 = conn.prepareStatement(QueryLoader.get("transaction.log"));
                ps3.setInt(1, fromAcc);
                ps3.setInt(2, toAcc);
                ps3.setBigDecimal(3, amount);
                ps3.setString(4, "TRANSFER");
                ps3.setString(5, "Transfer to " + toAcc);
                ps3.executeUpdate();

                conn.commit();
                return true;

            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        }
    }

    // ================= STATEMENT =================

    @Override
    public List<Transaction> getStatement(int accountNo) throws SQLException {

        List<Transaction> txList = new ArrayList<>();

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(QueryLoader.get("transaction.statement"))) {

            pstmt.setInt(1, accountNo);
            pstmt.setInt(2, accountNo);

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                txList.add(new Transaction(
                        rs.getInt("ID"),
                        rs.getInt("SENDER_ACCOUNT"),
                        rs.getInt("RECEIVER_ACCOUNT"),
                        rs.getBigDecimal("AMOUNT"),
                        rs.getString("TX_TYPE"),
                        rs.getString("REMARK"),
                        rs.getTimestamp("CREATED_AT").toLocalDateTime()
                ));
            }
        }

        return txList;
    }

    // ================= RECOVERY =================

    @Override
    public Optional<AccountRecoveryDTO> getRecoveryDetails(String email) throws SQLException {

        String sql = QueryLoader.get("user.recover_details");

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, email);

            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return Optional.of(new AccountRecoveryDTO(
                        rs.getString("FIRST_NAME"),
                        rs.getString("LAST_NAME"),
                        rs.getInt("ACCOUNT_NO")
                ));
            }
        }

        return Optional.empty();
    }

    @Override
    public boolean accountExists(int accountNo) throws SQLException {

        String sql = "SELECT 1 FROM ACCOUNTS WHERE ACCOUNT_NO = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, accountNo);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    @Override
    public BigDecimal getBalance(int accountNo) throws SQLException {

        String sql = QueryLoader.get("account.get_balance");

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, accountNo);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal("BALANCE");
                }
            }
        }

        return BigDecimal.ZERO;
    }
}