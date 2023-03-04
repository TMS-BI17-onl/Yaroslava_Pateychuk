/****** Скрипт для команды SelectTopNRows из среды SSMS  ******/

/*ClientID, HotelID, ManagerID,AvialID,Discount,SalesID, SalesDate,	StartDate,EndDate,duration_day,Price*/
WITH T (DCPassport, DHHotelName, DHPrice, DMPassport, DAFFlightNumber,DAFduration_min, FSSalesID, 
		FSSalesDate,FSStartDate,FSEndDate,FSduration_day)	
		AS(
			SELECT DC.Passport,  -- ClientID
					DH.HotelName, DH.Price, -- HotelID
					DM.Passport, -- ManagerID
					DAF.FlightNumber,DAF.duration_min, --AvialID
					--FS.Discount,
					FS.SalesID, 
					FS.SalesDate,
					FS.StartDate,
					FS.EndDate,
					FS.duration_day
					--FS.Price				
			FROM FctSales FS
			INNER JOIN DimClients DC ON
			FS.ClientID = DC.ClientID
			INNER JOIN DimManagers DM ON
			FS.ManagerID = DM.ManagerID 
			INNER JOIN DimAirFlight DAF ON
			FS.AvialID = DAF.AvialID
			INNER JOIN DimHotels DH ON
			FS.HotelID = DH.HotelID
			
		)
SELECT TOP (10) DCPassport, DHHotelName, DHPrice, DMPassport, DAFFlightNumber,DAFduration_min,
	cast((ABS(CHECKSUM(NEWID())) % 40) as int) as FSDiscount, 
	FSSalesID,FSSalesDate,FSStartDate,FSEndDate,FSduration_day,
	FLOOR(RAND(CHECKSUM(NEWID()))*(65231-8721+1)+8721) as FSPrice
FROM T
order by FSSalesID desc

			

alter table DimHotels
alter column RoomType nvarchar (5)

select count(1) 
from DimClients
select count(1)
from (select distinct passport from DimClients) T

select count(1) 
from DimManagers
select count(1)
from (select distinct passport from DimManagers) T

select count(1) 
from DimAirFlight
select count(1)
from (select distinct FlightNumber,duration_min from DimAirFlight) T

select count(1) 
from DimHotels
select count(1)
from (select distinct HotelName,Price from DimHotels) T

select *
from FctSales
order by SalesID desc