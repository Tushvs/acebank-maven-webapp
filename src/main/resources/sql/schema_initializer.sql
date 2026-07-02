-- CREATE DATABASE IF NOT EXISTS acebank;
-- USE acebank;

-- Tables (IF NOT EXISTS)
CREATE TABLE IF NOT EXISTS USERS (
                                     USER_ID INT AUTO_INCREMENT PRIMARY KEY,
                                     FIRST_NAME VARCHAR(255) NOT NULL,
    LAST_NAME VARCHAR(255) NOT NULL,
    AADHAAR_NO VARCHAR(12) UNIQUE NOT NULL,
    EMAIL VARCHAR(255) UNIQUE NOT NULL,
    PASSWORD_HASH VARCHAR(255) NOT NULL,
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

CREATE TABLE IF NOT EXISTS ACCOUNTS (
                                        ACCOUNT_NO INT PRIMARY KEY,
                                        USER_ID INT,
                                        ACCOUNT_TYPE ENUM('SAVINGS', 'CHECKING', 'LOAN') DEFAULT 'SAVINGS',
    BALANCE DECIMAL(15, 2) NOT NULL DEFAULT 0.00,
    STATUS ENUM('ACTIVE', 'BLOCKED', 'CLOSED') DEFAULT 'ACTIVE',
    FOREIGN KEY (USER_ID) REFERENCES USERS(USER_ID) ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS TRANSACTIONS (
                                            ID INT AUTO_INCREMENT PRIMARY KEY,
                                            SENDER_ACCOUNT INT NULL,   -- NULL for Deposits
                                            RECEIVER_ACCOUNT INT NULL, -- NULL for Withdrawals
                                            AMOUNT DECIMAL(15, 2) NOT NULL,
    TX_TYPE ENUM('TRANSFER', 'DEPOSIT', 'WITHDRAWAL') NOT NULL,
    REMARK VARCHAR(255),
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (SENDER_ACCOUNT) REFERENCES ACCOUNTS(ACCOUNT_NO)
    );

-- PERFORMANCE INDEXES
-- Without this, "WHERE SENDER_ACCOUNT = ? OR RECEIVER_ACCOUNT = ?" (account statement query)
-- forces a full table scan whenever it needs to match on RECEIVER_ACCOUNT, since only
-- SENDER_ACCOUNT has an implicit index (from its FK constraint).
-- Note: plain CREATE INDEX (no IF NOT EXISTS) for compatibility with standard MySQL.
-- This script is meant to run once against a fresh schema. If you re-run it against
-- an existing DB, drop these two indexes first or guard with a check.
CREATE INDEX idx_receiver_account ON TRANSACTIONS(RECEIVER_ACCOUNT);

-- Speeds up the daily withdrawal total lookup (SENDER_ACCOUNT + TX_TYPE + date range).
CREATE INDEX idx_sender_type_created ON TRANSACTIONS(SENDER_ACCOUNT, TX_TYPE, CREATED_AT);