SELECT Year, [1] as January, [2] as February, [12] as December
FROM 
(SELECT YEAR(StartDate) Year, Month(StartDate) Month,OrderQty
    FROM Production.WorkOrder  
)  AS SourceTable 
PIVOT
( 
	SUM(OrderQty)
	FOR Month IN ([1],[2],[12])
) 
AS PivotTable
order by Year

