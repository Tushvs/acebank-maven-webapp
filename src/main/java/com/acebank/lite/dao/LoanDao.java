package com.acebank.lite.dao;

import com.acebank.lite.models.Loan;

public interface LoanDao {
    void applyLoan(Loan loan) throws Exception;
}