-- Cleaning the data using SQL


SELECT *
FROM FinancialConsumerComplaint.dbo.FCC;

drop table FinancialConsumerComplaint.dbo.FCC;

-- 1. Add new columns for standardized date formats

ALTER TABLE FinancialConsumerComplaint.dbo.FCC
ADD "Date_Submitted_Standard" DATE;

ALTER TABLE FinancialConsumerComplaint.dbo.FCC
ADD "Date_Received_Standard" DATE;

UPDATE FinancialConsumerComplaint.dbo.FCC
SET Date_Submitted_Standard = CONVERT(DATE, DateSubmbitted),
    Date_Received_Standard = CONVERT(DATE, DateReceived);


-- 2. Dropping the old date columns 

ALTER TABLE FinancialConsumerComplaint.dbo.FCC
DROP COLUMN "DateSubmbitted";

ALTER TABLE FinancialConsumerComplaint.dbo.FCC
DROP COLUMN "DateReceived";


-- 3. Remove leading/trailing whitespaces from text fields

UPDATE FinancialConsumerComplaint.dbo.FCC
SET 
    Product = LTRIM(RTRIM(Product)),
    Subproduct = LTRIM(RTRIM(Subproduct)),
    Issue = LTRIM(RTRIM(Issue)),
    SubIssue = LTRIM(RTRIM(SubIssue)),
    CompanyPublicResponse = LTRIM(RTRIM(CompanyPublicResponse)),
    Company = LTRIM(RTRIM(Company)),
    State = LTRIM(RTRIM(State)),
    ZIPCode = LTRIM(RTRIM(ZIPCode)),
    Tags = LTRIM(RTRIM(Tags)),
    ConsumerConsentProvided = LTRIM(RTRIM(ConsumerConsentProvided)),
    SubmittedVia = LTRIM(RTRIM(SubmittedVia)),
    CompanyResponseToConsumer = LTRIM(RTRIM(CompanyResponseToConsumer)),
    TimelyResponse = LTRIM(RTRIM(TimelyResponse)),
    ConsumerDisputed = LTRIM(RTRIM(ConsumerDisputed));

-- 4. Ensure ZIP codes are in a consistent format (5-digit format)

UPDATE FinancialConsumerComplaint.dbo.FCC
SET ZIPCode = LEFT(ZIPCode, 5);


--5. Checking for inconsistent data 

SELECT DISTINCT TimelyResponse
FROM FinancialConsumerComplaint.dbo.FCC;

SELECT DISTINCT ConsumerDisputed
FROM FinancialConsumerComplaint.dbo.FCC;


SELECT *
FROM FinancialConsumerComplaint.dbo.FCC;

--6.  Identify duplicates based on all columns

SELECT 
    ComplaintID,
    Date_Submitted_Standard,
    Product,
    Subproduct,
    Issue,
    SubIssue,
    CompanyPublicResponse,
    Company,
    State,
    ZIPCode,
    Tags,
    ConsumerConsentProvided,
    SubmittedVia,
    Date_Received_Standard,
    CompanyResponseToConsumer,
    TimelyResponse,
    ConsumerDisputed,
    COUNT(*) AS DuplicateCount
FROM 
    FinancialConsumerComplaint.dbo.FCC
GROUP BY 
    ComplaintID,
    Date_Submitted_Standard,
    Product,
    Subproduct,
    Issue,
    SubIssue,
    CompanyPublicResponse,
    Company,
    State,
    ZIPCode,
    Tags,
    ConsumerConsentProvided,
    SubmittedVia,
    Date_Received_Standard,
    CompanyResponseToConsumer,
    TimelyResponse,
    ConsumerDisputed
HAVING 
    COUNT(*) > 1;


--7.  Checking got null values

SELECT *
FROM FinancialConsumerComplaint.dbo.FCC;

SELECT
    SUM(CASE WHEN ComplaintID IS NULL OR ComplaintID = '' THEN 1 ELSE 0 END) AS ComplaintID_NullOrEmptyCount,
    SUM(CASE WHEN Date_Submitted_Standard IS NULL OR Date_Submitted_Standard = '' THEN 1 ELSE 0 END) AS DateSubmbitted_NullOrEmptyCount,
    SUM(CASE WHEN Product IS NULL OR Product = '' THEN 1 ELSE 0 END) AS Product_NullOrEmptyCount,
    SUM(CASE WHEN Subproduct IS NULL OR Subproduct = '' THEN 1 ELSE 0 END) AS Subproduct_NullOrEmptyCount,
    SUM(CASE WHEN Issue IS NULL OR Issue = '' THEN 1 ELSE 0 END) AS Issue_NullOrEmptyCount,
    SUM(CASE WHEN SubIssue IS NULL OR SubIssue = '' THEN 1 ELSE 0 END) AS SubIssue_NullOrEmptyCount,
    SUM(CASE WHEN CompanyPublicResponse IS NULL OR CompanyPublicResponse = '' THEN 1 ELSE 0 END) AS CompanyPublicResponse_NullOrEmptyCount,
    SUM(CASE WHEN Company IS NULL OR Company = '' THEN 1 ELSE 0 END) AS Company_NullOrEmptyCount,
    SUM(CASE WHEN State IS NULL OR State = '' THEN 1 ELSE 0 END) AS State_NullOrEmptyCount,
    SUM(CASE WHEN ZIPCode IS NULL OR ZIPCode = '' THEN 1 ELSE 0 END) AS ZIPCode_NullOrEmptyCount,
    SUM(CASE WHEN Tags IS NULL OR Tags = '' THEN 1 ELSE 0 END) AS Tags_NullOrEmptyCount,
    SUM(CASE WHEN ConsumerConsentProvided IS NULL OR ConsumerConsentProvided = '' THEN 1 ELSE 0 END) AS ConsumerConsentProvided_NullOrEmptyCount,
    SUM(CASE WHEN SubmittedVia IS NULL OR SubmittedVia = '' THEN 1 ELSE 0 END) AS SubmittedVia_NullOrEmptyCount,
    SUM(CASE WHEN Date_Received_Standard IS NULL OR Date_Received_Standard = '' THEN 1 ELSE 0 END) AS DateReceived_NullOrEmptyCount,
    SUM(CASE WHEN CompanyResponseToConsumer IS NULL OR CompanyResponseToConsumer = '' THEN 1 ELSE 0 END) AS CompanyResponseToConsumer_NullOrEmptyCount,
    SUM(CASE WHEN TimelyResponse IS NULL OR TimelyResponse = '' THEN 1 ELSE 0 END) AS TimelyResponse_NullOrEmptyCount,
    SUM(CASE WHEN ConsumerDisputed IS NULL OR ConsumerDisputed = '' THEN 1 ELSE 0 END) AS ConsumerDisputed_NullOrEmptyCount
FROM
    FinancialConsumerComplaint.dbo.FCC;



--8. Updating columns to replace null or empty values with default values

UPDATE FinancialConsumerComplaint.dbo.FCC
SET 
    Product = ISNULL(NULLIF(Product, ''), 'Unknown'),
    Subproduct = ISNULL(NULLIF(Subproduct, ''), 'Unknown'),
    Issue = ISNULL(NULLIF(Issue, ''), 'Unknown'),
    SubIssue = ISNULL(NULLIF(SubIssue, ''), 'Unknown'),
    CompanyPublicResponse = ISNULL(NULLIF(CompanyPublicResponse, ''), 'No Response'),
    Company = ISNULL(NULLIF(Company, ''), 'Unknown'),
    Tags = ISNULL(NULLIF(Tags, ''), 'None'),
    ConsumerConsentProvided = ISNULL(NULLIF(ConsumerConsentProvided, ''), 'Not Provided'),
    SubmittedVia = ISNULL(NULLIF(SubmittedVia, ''), 'Unknown'),
    CompanyResponseToConsumer = ISNULL(NULLIF(CompanyResponseToConsumer, ''), 'No Response'),
    TimelyResponse = ISNULL(NULLIF(TimelyResponse, ''), 'Unknown'),
    ConsumerDisputed = ISNULL(NULLIF(ConsumerDisputed, ''), 'Unknown');


SELECT *
FROM FinancialConsumerComplaint.dbo.FCC;