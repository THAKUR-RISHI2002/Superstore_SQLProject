--1. LIST the top 10 orders with the highest sales from the EachOrderBreakdown table.
SELECT TOP 10 *
FROM EachOrderBreakdown
ORDER BY Sales DESC

--2. Show the number of orders for each product category in the EachOrderBreakdown table.
SELECT Category,COUNT(*) AS NumberofOrders
FROM EachOrderBreakdown
GROUP BY Category

--3. Find the total profit for each sub_category in the EachordeBreakdown
SELECT SubCategory,SUM(Profit) AS TotalProfit
FROM EachOrderBreakdown
GROUP BY SubCategory

--4.Identify the customer with the highest total sales across all orders.
SELECT*
FROM OrdersList
SELECT*
FROM EachOrderBreakdown
SELECT TOP 1 CustomerName,SUM(Sales) AS TotalSales
FROM OrdersList AS ol
JOIN EachOrderBreakdown AS ob
ON ol.OrderID = ob.OrderID
GROUP BY CustomerName
ORDER BY TotalSales DESC

--5.Find the month with the highest average sales in the OrderList table.
SELECT * FROM OrdersList
SELECT * FROM EachOrderBreakdown

SELECT TOP 1 MONTH(OrderDate) AS Month,AVG(Sales) AS AverageSales
FROM OrdersList AS ol
JOIN EachOrderBreakdown AS ob
ON ol.OrderID = ob.OrderID
GROUP BY MONTH(OrderDate)
ORDER BY AverageSales DESC

--6.Find out the average quantity ordered by customers whose first name starts with an alphabet 's'.
SELECT AVG(Quantity) AS AverageQuantity
FROM OrdersList AS ol
JOIN EachOrderBreakdown AS ob
ON ol.OrderID = ob.OrderID
WHERE LEFT(CustomerName,1)= 'S'

--7. Find out how many new customers were acquired in the year 2014?
SELECT COUNT(*) AS NumberofNewCustomers FROM(
SELECT CustomerName,MIN(OrderDate) AS FirstOrderDate
FROM Orderslist
GROUP BY CustomerName
HAVING YEAR(MIN(OrderDate))='2014') AS CustwithFirstOrder2014

--8. Calculate the percentage of total profit contributed by each sub_category to the overall profit.
SELECT Subcategory,SUM(Profit) AS SubCategoryProfit,
SUM(Profit)/(SELECT SUM(Profit) FROM EachOrderBreakdown)*100 AS percentageoftotalcontribution
FROM EachOrderBreakdown
GROUP BY SubCategory 
--9.Find the average sales per customer ,considering only customers who have made more than one order.
WITH CustomerAvgSales AS(
SELECT CustomerName,COUNT(DISTINCT ol.OrderID) AS NumberOfOrders,AVG(Sales) AS AvgSales
FROM OrdersList ol
JOIN EachOrderBreakdown ob
ON ol.OrderID=ob.OrderID
GROUP BY CustomerName
)
SELECT CustomerName,AvgSales
FROM CustomerAvgSales
WHERE NumberofOrders>12

--10.Identify the top-performing subcategory in each category based on total sales. Include the sub-category
with topsubcategory AS(
SELECT Category,SubCategory,SUM(Sales) AS TotalSales,
RANK() OVER(PARTITION BY Category ORDER BY SUM(Sales) DESC) AS SubcategoryRank
FROM EachOrderBreakdown
GROUP BY Category,SubCategory
)
SELECT*
FROM topsubcategory
WHERE SubcategoryRank=1