WITH T1 (FirstName, LastName , Passport, Year, Month, Day, DaySalesCount, Rating) AS
(
select distinct *,
   (CASE WHEN DaySalesCount<5 then 1 
        when DaySalesCount>=5 and DaySalesCount<=10 then 2 
		when DaySalesCount>10 then 3 end) as Rating
from (
	select m.FirstName, m.LastName , m.Passport, YEAR(SalesDate) as Year ,MONTH(SalesDate) AS Month,
	       DAY(SalesDate) as Day, 
		   count (Passport) over(partition by passport, year(salesdate),month(salesdate),day(salesdate)) as DaySalesCount
	from FctSales s right join DimManagers m on
	s.ManagerID=m.ManagerID
	) T
)
select TOP 50 WITH TIES FirstName, LastName , Passport, sum(Rating) as ResultRating
from T1
group by FirstName, LastName , Passport
order by ResultRating desc