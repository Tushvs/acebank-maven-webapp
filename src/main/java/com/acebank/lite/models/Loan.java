package com.acebank.lite.models;

public class Loan {

    private int accountNumber;
    private String fullName;
    private String aadhaar;
    private String pan;
    private double amount;

    public Loan(int accountNumber, String fullName, String aadhaar, String pan, double amount) {
        this.accountNumber = accountNumber;
        this.fullName = fullName;
        this.aadhaar = aadhaar;
        this.pan = pan;
        this.amount = amount;
    }

    public int getAccountNumber() { return accountNumber; }
    public String getFullName() { return fullName; }
    public String getAadhaar() { return aadhaar; }
    public String getPan() { return pan; }
    public double getAmount() { return amount; }
}