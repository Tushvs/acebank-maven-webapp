package com.acebank.lite.dao;

import com.acebank.lite.models.Loan;
import com.acebank.lite.util.ConnectionManager;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class LoanDaoImpl implements LoanDao {

    @Override
    public void applyLoan(Loan loan) throws Exception {

        String sql = "INSERT INTO loans (account_number, full_name, aadhaar, pan, amount) VALUES (?, ?, ?, ?, ?)";

        try (Connection con = ConnectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, loan.getAccountNumber());
            ps.setString(2, loan.getFullName());
            ps.setString(3, loan.getAadhaar());
            ps.setString(4, loan.getPan());
            ps.setDouble(5, loan.getAmount());

            ps.executeUpdate();
        }
    }
}