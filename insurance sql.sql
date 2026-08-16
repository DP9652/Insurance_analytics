drop database  insurancedb;
CREATE DATABASE InsuranceDB;
USE InsuranceDB;

CREATE TABLE CustomerInformation
(
    CustomerID VARCHAR(20) PRIMARY KEY,
    Name VARCHAR(100),
    Gender VARCHAR(20),
    Age INT,
    Occupation VARCHAR(100),
    MaritalStatus VARCHAR(30),
    Address VARCHAR(255)
);

CREATE TABLE PolicyDetails
(
    PolicyID VARCHAR(20) PRIMARY KEY,
    PolicyType VARCHAR(50),
    CoverageAmount DECIMAL(12,2),
    PremiumAmount DECIMAL(10,2),
    PolicyStartDate DATE,
    PolicyEndDate DATE,
    PaymentFrequency VARCHAR(30),
    Status VARCHAR(30),
    CustomerID VARCHAR(20) ,
    FOREIGN KEY (CustomerID)
    REFERENCES CustomerInformation(CustomerID)
);


CREATE TABLE Claims
(
    ClaimID VARCHAR(20) PRIMARY KEY,
    DateOfClaim DATE,
    ClaimAmount DECIMAL(12,2),
    ClaimStatus VARCHAR(30),
    ReasonForClaim VARCHAR(100),
    SettlementDate DATE,
    PolicyID VARCHAR(20) ,
    FOREIGN KEY (PolicyID)
    REFERENCES PolicyDetails(PolicyID)
);



CREATE TABLE PaymentHistory
(
    PaymentID  VARCHAR(20) PRIMARY KEY,
    DateOfPayment DATE,
    AmountPaid DECIMAL(10,2),
    PaymentMethod VARCHAR(30),
    PaymentStatus VARCHAR(30),
    PolicyID VARCHAR(20) ,
    FOREIGN KEY (PolicyID)
    REFERENCES PolicyDetails(PolicyID)

);


CREATE TABLE AdditionalFields
(
    AgentID VARCHAR(20) ,
    RenewalStatus VARCHAR(30),
    PolicyDiscounts DECIMAL(10,2),
    RiskScore INT,
    PolicyID VARCHAR(20) ,
    FOREIGN KEY (PolicyID)
    REFERENCES PolicyDetails(PolicyID)
);



SELECT * FROM CustomerInformation;

SELECT * FROM Claims;

SELECT * FROM AdditionalFields;

SELECT * FROM PolicyDetails;

SELECT * FROM PaymentHistory;


SELECT Name, Age
FROM CustomerInformation
WHERE Age > 35;
# active status
SELECT *
FROM PolicyDetails
WHERE Status = 'Active';


SELECT SUM(PremiumAmount)
FROM PolicyDetails;


SELECT AVG(CoverageAmount)
FROM PolicyDetails;

# no of customer
SELECT COUNT(*)
FROM CustomerInformation;

#Total claims
SELECT COUNT(*)
FROM Claims;

#Highest claim amount

SELECT MAX(ClaimAmount)
FROM Claims;

#Join Customers and Policies
SELECT
    c.Name,
    p.PolicyType,
    p.Status
FROM CustomerInformation c
INNER JOIN PolicyDetails p
ON c.CustomerID = p.CustomerID;

#Total Payments by Customer

SELECT
    c.Name,
    SUM(ph.AmountPaid) AS TotalPaid
FROM CustomerInformation c
JOIN PolicyDetails p
ON c.CustomerID = p.CustomerID
JOIN PaymentHistory ph
ON p.PolicyID = ph.PolicyID
GROUP BY c.Name;



# customer without claims
SELECT
    c.Name
FROM CustomerInformation c
JOIN PolicyDetails p
ON c.CustomerID = p.CustomerID
LEFT JOIN Claims cl
ON p.PolicyID = cl.PolicyID
WHERE cl.ClaimID IS NULL;

# premium amount
SELECT
    PolicyType,
    SUM(PremiumAmount) AS TotalPremium
FROM PolicyDetails
GROUP BY PolicyType;
# gender
SELECT Gender,
COUNT(*) TotalCustomers
FROM CustomerInformation
GROUP BY Gender;

# married
SELECT COUNT(*)
FROM CustomerInformation
WHERE MaritalStatus='Married';


# renewal rate
SELECT
ROUND(
SUM(CASE WHEN RenewalStatus='Renewed' THEN 1 ELSE 0 END)*100.0/
COUNT(*),2) RenewalRate
FROM AdditionalFields;


#high claim
SELECT MAX(ClaimAmount)
FROM Claims;

SELECT Min(ClaimAmount)
FROM Claims;

SELECT COUNT(*)
FROM Claims
WHERE ClaimStatus='Pending';

# failed
SELECT COUNT(*)
FROM PaymentHistory
WHERE PaymentStatus='Failed';


# payment success rate
SELECT
ROUND(
SUM(CASE WHEN PaymentStatus='Successful' THEN 1 ELSE 0 END)*100.0/
COUNT(*),2) SuccessRate
FROM PaymentHistory;


# claim ratio
SELECT
ROUND(
SUM(c.ClaimAmount)/SUM(p.CoverageAmount)*100,2)
AS ClaimsRatio
FROM Claims c
JOIN PolicyDetails p
ON c.PolicyID=p.PolicyID;


