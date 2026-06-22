-- Create Database for Stock Analysis
CREATE DATABASE StockAnalysisDB;
USE StockAnalysisDB;

-- 1. Company Profiles
CREATE TABLE CompanyProfiles (
    CompanyID INT PRIMARY KEY,
    Ticker VARCHAR(10),
    CompanyName VARCHAR(100),
    Sector VARCHAR(50)
);

-- 2. Daily Stock Prices
CREATE TABLE DailyPrices (
    PriceID INT PRIMARY KEY,
    CompanyID INT,
    TradingDate DATE,
    ClosePrice DECIMAL(10, 2),
    Volume INT
);

-- 3. Corporate Actions / Dividends
CREATE TABLE Dividends (
    DividendID INT PRIMARY KEY,
    Ticker VARCHAR(10),
    ExDate DATE,
    DividendAmount DECIMAL(10, 2)
);

-- Insert Sample Market Data
INSERT INTO CompanyProfiles VALUES 
(1, 'RECLTD', 'REC Limited', 'Financials'),
(2, 'INFY', 'Infosys Limited', 'Technology'),
(3, 'TCS', 'Tata Consultancy Services', 'Technology'),
(4, 'RELIANCE', 'Reliance Industries', 'Energy');

INSERT INTO DailyPrices VALUES 
(101, 1, '2026-06-19', 520.00, 1500000),
(102, 1, '2026-06-22', 525.50, 1200000), 
(103, 2, '2026-06-19', 1480.00, 800000),
(104, 2, '2026-06-22', 1475.00, 950000),  
(105, 3, '2026-06-22', 3850.00, 500000);   

INSERT INTO Dividends VALUES 
(501, 'RECLTD', '2026-06-19', 4.50),
(502, 'INFY', '2026-06-15', 18.00),
(503, 'WITHOUT_PROFILE', '2026-06-20', 5.00);


-- MASTER JOINS QUERIES --

-- 1. INNER JOIN & LEFT JOIN (Active Prices and Dividends)
SELECT CP.Ticker, CP.CompanyName, DP.TradingDate, DP.ClosePrice, D.DividendAmount
FROM CompanyProfiles CP
INNER JOIN DailyPrices DP ON CP.CompanyID = DP.CompanyID
LEFT JOIN Dividends D ON CP.Ticker = D.Ticker AND DP.TradingDate = D.ExDate
WHERE DP.TradingDate = '2026-06-22';

-- 2. RIGHT JOIN (Unmapped Corporate Actions)
SELECT CP.Ticker AS ProfileTicker, D.Ticker AS DividendTicker, D.DividendAmount
FROM CompanyProfiles CP
RIGHT JOIN Dividends D ON CP.Ticker = D.Ticker;

-- 3. FULL OUTER JOIN (Emulated via UNION)
SELECT CP.Ticker, CP.CompanyName, D.DividendAmount FROM CompanyProfiles CP
LEFT JOIN Dividends D ON CP.Ticker = D.Ticker
UNION
SELECT CP.Ticker, CP.CompanyName, D.DividendAmount FROM CompanyProfiles CP
RIGHT JOIN Dividends D ON CP.Ticker = D.Ticker;

-- 4. SELF JOIN (Day-over-Day Price Performance)
SELECT CP.Ticker, Today.ClosePrice AS TodayClose, Yesterday.ClosePrice AS PrevClose,
       (Today.ClosePrice - Yesterday.ClosePrice) AS PriceChange
FROM DailyPrices Today
JOIN DailyPrices Yesterday ON Today.CompanyID = Yesterday.CompanyID AND Yesterday.TradingDate = '2026-06-19'
JOIN CompanyProfiles CP ON Today.CompanyID = CP.CompanyID
WHERE Today.TradingDate = '2026-06-22';

-- 5. CROSS JOIN (Sector Risk Matrix)
SELECT A.Sector AS Sector_A, B.Sector AS Sector_B
FROM (SELECT DISTINCT Sector FROM CompanyProfiles) A
CROSS JOIN (SELECT DISTINCT Sector FROM CompanyProfiles) B
WHERE A.Sector < B.Sector;
