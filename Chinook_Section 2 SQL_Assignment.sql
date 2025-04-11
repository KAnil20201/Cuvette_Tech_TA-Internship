USE chinook;
-- Show all tables
SHOW TABLES;

-- Preview some data
SELECT * FROM customer LIMIT 5;
SELECT * FROM invoice LIMIT 5;

-- Section 2: SQL (30–45 mins)
-- Dataset: Chinook Database (Music Store)
-- You can run it on SQLite Online or import into any SQL IDE.

-- Tasks:
-- 1. List the top 5 customers by total purchase amount.
SELECT 
    c.CustomerId,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    SUM(i.Total) AS TotalPurchase
FROM 
    customer c
JOIN 
    invoice i ON c.CustomerId = i.CustomerId
GROUP BY 
    c.CustomerId
ORDER BY 
    TotalPurchase DESC
LIMIT 5;


-- 2. Find the most popular genre in terms of total tracks sold.
SELECT 
    g.Name AS Genre,
    COUNT(il.TrackId) AS TotalTracksSold
FROM 
    InvoiceLine il
JOIN 
    Track t ON il.TrackId = t.TrackId
JOIN 
    Genre g ON t.GenreId = g.GenreId
GROUP BY 
    g.GenreId
ORDER BY 
    TotalTracksSold DESC
LIMIT 1;



-- 3. Retrieve all employees who are managers along with their subordinates.
SELECT 
    m.EmployeeId AS ManagerID,
    CONCAT(m.FirstName, ' ', m.LastName) AS ManagerName,
    e.EmployeeId AS SubordinateID,
    CONCAT(e.FirstName, ' ', e.LastName) AS SubordinateName
FROM 
    Employee e
JOIN 
    Employee m ON e.ReportsTo = m.EmployeeId
ORDER BY 
    ManagerName, SubordinateName;


-- 4. For each artist, find their most sold album.
SELECT 
    a.Name AS Artist,
    al.Title AS Album,
    COUNT(il.TrackId) AS TracksSold
FROM 
    Artist a
JOIN 
    Album al ON a.ArtistId = al.ArtistId
JOIN 
    Track t ON al.AlbumId = t.AlbumId
JOIN 
    InvoiceLine il ON t.TrackId = il.TrackId
GROUP BY 
    a.ArtistId, al.AlbumId
HAVING 
    TracksSold = (
        SELECT 
            MAX(SalesCount)
        FROM (
            SELECT 
                COUNT(il2.TrackId) AS SalesCount
            FROM 
                Album al2
            JOIN 
                Track t2 ON al2.AlbumId = t2.AlbumId
            JOIN 
                InvoiceLine il2 ON t2.TrackId = il2.TrackId
            WHERE 
                al2.ArtistId = a.ArtistId
            GROUP BY 
                al2.AlbumId
        ) AS SubQuery
    )
ORDER BY Artist;


-- 5. Write a query to get monthly sales trends in the year 2013.
SELECT 
    MONTH(InvoiceDate) AS Month,
    SUM(Total) AS MonthlySales
FROM 
    invoice
WHERE 
    YEAR(InvoiceDate) = 2013
GROUP BY 
    Month
ORDER BY 
    Month;

SELECT 
    DISTINCT YEAR(InvoiceDate) AS Year
FROM 
    invoice;
    
    SELECT 
    YEAR(InvoiceDate) AS Year,
    MONTH(InvoiceDate) AS Month,
    SUM(Total) AS TotalSales
FROM 
    invoice
WHERE 
    YEAR(InvoiceDate) BETWEEN 2021 AND 2025
GROUP BY 
    YEAR(InvoiceDate), MONTH(InvoiceDate)
ORDER BY 
    Year, Month;


