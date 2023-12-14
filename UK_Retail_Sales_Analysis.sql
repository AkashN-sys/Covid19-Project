-- Select all from UK retail
SELECT * FROM `UK retail`.uk_retail;

-- Total sales per Item country wise
WITH sales AS (
    SELECT 
        Country,
        Description,
        Quantity * Price AS total_price 
    FROM 
        uk_retail
)
SELECT 
    Country, 
    Description,
    SUM(total_price) AS total_sales
FROM 
    sales
GROUP BY 
    Country, Description
ORDER BY 
    total_sales DESC;
    
-- Average sales country wise
SELECT 
    AVG(Quantity * Price) AS AVG_SALES, 
    Country
FROM  
    uk_retail
GROUP BY 
    Country;

-- Total sales country wise from 2009-2012
WITH countrytotal AS (
    SELECT 
        Country, 
        SUM(Quantity * Price) AS totalsales
    FROM 
        uk_retail
    GROUP BY 
        Country
)
SELECT 
    Country,  
    totalsales, 
    RANK() OVER (ORDER BY totalsales DESC) AS countrysalesrank
FROM 
    countrytotal
GROUP BY 
    Country, totalsales;

-- Total sales country-wise in the year 2009
WITH countrytotal AS (
    SELECT
        Country,
        SUM(Quantity * Price) AS totalsales
    FROM
        uk_retail
    WHERE
        InvoiceDate BETWEEN '2009-01-01' AND '2010-01-01'
    GROUP BY
        Country
)
SELECT
    Country,
    totalsales,
    RANK() OVER (ORDER BY totalsales DESC) AS countrysalesrank
FROM
    countrytotal
GROUP BY
    Country, totalsales
LIMIT 100;

-- Total sales country-wise in the year 2010
WITH countrytotal AS (
    SELECT
        Country,
        SUM(Quantity * Price) AS totalsales
    FROM
        uk_retail
    WHERE
        InvoiceDate BETWEEN '2010-01-01' AND '2011-01-01'
    GROUP BY
        Country
)
SELECT
    Country,
    totalsales,
    RANK() OVER (ORDER BY totalsales DESC) AS countrysalesrank
FROM
    countrytotal
GROUP BY
    Country, totalsales
LIMIT 100;

-- Total sales country-wise in the year 2011
WITH countrytotal AS (
    SELECT
        Country,
        SUM(Quantity * Price) AS totalsales
    FROM
        uk_retail
    WHERE
        InvoiceDate BETWEEN '2011-01-01' AND '2012-01-01'
    GROUP BY
        Country
)
SELECT
    Country,
    totalsales,
    RANK() OVER (ORDER BY totalsales DESC) AS countrysalesrank
FROM
    countrytotal
GROUP BY
    Country, totalsales
LIMIT 100;

-- Count occurrences of each Customer ID
SELECT 
    `Customer ID`, 
    COUNT(*) AS Occurrences
FROM 
    uk_retail
GROUP BY 
    `Customer ID`
ORDER BY 
    Occurrences DESC;

-- Top 3 customers country wise
WITH TopCustomers AS (
    SELECT
        Country,
        `Customer ID`,
        COUNT(*) AS Occurrences,
        RANK() OVER (PARTITION BY Country ORDER BY COUNT(*) DESC) AS customer_rank
    FROM
        uk_retail
    GROUP BY
        Country, `Customer ID`
)
SELECT
    customer_rank,
    `Customer ID`,
    Country
FROM
    TopCustomers
WHERE
    customer_rank <= 3
ORDER BY 
    Country;

-- Customer ranks
WITH customerpower AS (
    SELECT
        `Customer ID`,
        AVG(`Quantity` * `Price`) AS AVG_SALES,
        SUM(`Quantity` * `Price`) AS total_sales,
        ROW_NUMBER() OVER (PARTITION BY Country ORDER BY SUM(`Quantity` * `Price`) DESC) AS customer_rank,
        Country
    FROM 
        uk_retail
    GROUP BY 
        Country, `Customer ID`
)
SELECT
    customer_rank,
    `Customer ID`,
    Country,
    total_sales
FROM 
    customerpower
WHERE 
    customer_rank <= 3 AND total_sales > AVG_SALES
ORDER BY 
    total_sales desc;
