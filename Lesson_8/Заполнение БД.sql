CREATE DATABASE TravelAgency2023;

ALTER TABLE FctSales
DROP CONSTRAINT FK_ClientID_FctSales;
ALTER TABLE FctSales
DROP CONSTRAINT FK_HotelID_FctSales;
ALTER TABLE FctSales
DROP CONSTRAINT FK_ManagerID_FctSales;
ALTER TABLE FctSales
DROP CONSTRAINT FK_AvailID_FctSales;

DROP TABLE IF EXISTS DimClients;
DROP TABLE IF EXISTS FctSales;
DROP TABLE IF EXISTS DimManagers;
DROP TABLE IF EXISTS DimAirFlight;
DROP TABLE IF EXISTS DimHotels;

alter table DimClients
alter column FirstName NVARCHAR(50) NOT NULL
alter table DimClients
alter column lastName NVARCHAR(50) NOT NULL
alter table DimClients
alter column Passport NVARCHAR(8) NOT NULL
alter table DimClients
add CONSTRAINT PK_ClientID_DimClients PRIMARY KEY(ClientID)
alter table DimClients
add CONSTRAINT UQ_Passport_DimClients UNIQUE (Passport)

alter table DimManagers
alter column FirstName NVARCHAR(50) NOT NULL
alter table DimManagers
alter column lastName NVARCHAR(50) NOT NULL
alter table DimManagers
alter column Passport NVARCHAR(8) NOT NULL
alter table DimManagers
add CONSTRAINT PK_ManagerID_DimManagers PRIMARY KEY(ManagerID)
alter table DimManagers
add CONSTRAINT UQ_Passport_DimManagers UNIQUE (Passport)

alter table DimAirFlight
alter column CityDeparture NVARCHAR(25) NOT NULL
alter table DimAirFlight
alter column TerritoryDeparture NVARCHAR(2) NOT NULL
alter table DimAirFlight
alter column TerritoryArrival  NVARCHAR(2) NOT NULL
alter table DimAirFlight
alter column CityArrival NVARCHAR(25) NOT NULL
alter table DimAirFlight
alter column Departure DATETIME NOT NULL
alter table DimAirFlight
alter column Arrival DATETIME NOT NULL
alter table DimAirFlight
add CONSTRAINT PK_AvialID_DimAirFlight PRIMARY KEY(AvialID)

alter table DimHotels
alter column HotelName NVARCHAR(50) NOT NULL
alter table DimHotels
alter column HotelType NVARCHAR(15) 
EXEC sp_rename 'dbo.DimHotels.Country', 'Territory', 'COLUMN';
alter table DimHotels
alter column Territory NVARCHAR(2) NOT NULL
alter table DimHotels
alter column City NVARCHAR(30) NOT NULL
alter table DimHotels
alter column LocationType NVARCHAR(20)
alter table DimHotels
alter column Price MONEY 
alter table DimHotels
alter column RoomType NVARCHAR(5)
alter table DimHotels
alter column TypeFood NVARCHAR(5)
alter table DimHotels
add CONSTRAINT DF_Price_DimHotels DEFAULT 200 for Price
alter table DimHotels
add HotelID INT IDENTITY
alter table DimHotels
add CONSTRAINT PK_HotelID_DimHotels PRIMARY KEY(HotelID)
alter table DimHotels
add CONSTRAINT CK_Price_DimHotels CHECK(Price>40)

alter table FctSales
add SalesDate DATETIME 
alter table FctSales
add StartDate DATETIME 
alter table FctSales
add EndDate DATETIME 
alter table FctSales
alter column SalesDate DATETIME NOT NULL 
alter table FctSales
add CONSTRAINT DF_SalesDate_FctSales DEFAULT (getdate()) for SalesDate
alter table FctSales
add CONSTRAINT DF_Price_FctSales DEFAULT 100 for Price
alter table FctSales
add CONSTRAINT DF_Discount_FctSales DEFAULT 5 for Discount
alter table FctSales
add CONSTRAINT PK_SalesID_FctSales PRIMARY KEY(SalesID)
alter table FctSales
add CONSTRAINT FK_ClientID_FctSales FOREIGN KEY(ClientID) REFERENCES dbo.DimClients(ClientID)
alter table FctSales
add CONSTRAINT FK_HotelID_FctSales FOREIGN KEY(HotelID) REFERENCES dbo.DimHotels(HotelID)
alter table FctSales
add CONSTRAINT FK_ManagerID_FctSales FOREIGN KEY(ManagerID) REFERENCES dbo.DimManagers(ManagerID)
alter table FctSales
add CONSTRAINT FK_AvialID_FctSales FOREIGN KEY(AvialID) REFERENCES dbo.DimAirFlight(AvialID)
alter table FctSales
add CONSTRAINT CK_Discount_FctSales CHECK(Discount<40)
alter table FctSales
add CONSTRAINT CK_Price_FctSales CHECK(Price>100)

ALTER TABLE dbo.R_adress
ADD AdressID INT IDENTITY(1,1);
ALTER TABLE dbo.R_country_city
ADD AdressID INT IDENTITY(1,1);
ALTER TABLE dbo.R_first_name
ADD AdressID INT IDENTITY(1,1);
ALTER TABLE dbo.R_last_name
ADD AdressID INT IDENTITY(1,1);

WITH
	L0   AS (SELECT c FROM (SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL 
							SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL 
							SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1) AS D(c)), -- 9^1
	L1   AS (SELECT 1 AS c FROM L0 AS A CROSS JOIN L0 AS B),       -- 9^2
	L2   AS (SELECT 1 AS c FROM L1 AS A CROSS JOIN L1 AS B),       -- 9^4
	L3   AS (SELECT 1 AS c FROM L2 AS A CROSS JOIN L2 AS B),       -- 9^6
	NUMS AS (SELECT ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS k FROM L3)
select k as id , 
		(select R_first_name from R_first_name where AdressID=		
			IIF (k<1000,cast((ABS(CHECKSUM(NEWID())) % k+1) as int),
				cast((ABS(CHECKSUM(NEWID())) % 1000) as int))) as first_name,
		(select R_last_name from R_last_name where AdressID= 
			IIF (k<1000,cast((ABS(CHECKSUM(NEWID())) % k+1) as varchar),
				cast((ABS(CHECKSUM(NEWID())) % 1000) as varchar))) as last_name	
INTO R_People
from NUMS
where k <= 531441

WITH CTE(first_name, 
	last_name,
	DuplicateCount)
AS (SELECT first_name, 
			last_name, 			   
			ROW_NUMBER() OVER(PARTITION BY first_name, 
											last_name
			ORDER BY id) AS DuplicateCount
	FROM R_People)
DELETE FROM CTE
WHERE DuplicateCount > 1 OR first_name IS NULL OR last_name IS NULL;

insert into dbo.DimClients (FirstName,LastName) 
SELECT top (100000) first_name,last_name FROM R_People ORDER BY id;

insert into dbo.DimManagers (FirstName,LastName) 
SELECT top (100000) first_name,last_name FROM R_People ORDER BY id desc;

insert into dbo.DimAirFlight (citydeparture,territorydeparture) 
SELECT top (1) percent cit,cont FROM R_adress_X2;

alter table dbo.DimAirFlight
drop column AvialID
alter table dbo.DimAirFlight
add AvialID INT IDENTITY (1,1) 

UPDATE DimAirFlight
SET cityarrival = (select cit from R_adress_X2 x2 where x2.id=DimAirFlight.AvialID )
UPDATE DimAirFlight
SET territoryarrival = (select cont from R_adress_X2 x2 where x2.id=DimAirFlight.AvialID )

alter table dbo.DimClients
add ClientID INT IDENTITY (1,1)

alter table dbo.DimManagers
add ManagerID INT IDENTITY (1,1)

alter table dbo.DimAirFlight
add AvialID INT IDENTITY (1,1)

alter table dbo.FctSales
add SalesID INT IDENTITY (1,1)

update dbo.DimClients
set BithDate = DATEADD(DAY, RAND(CHECKSUM(NEWID()))*(1+DATEDIFF(DAY, '01-01-1945', '01-01-2005')),'01-01-1945')
UPDATE DimAirFlight
SET departure = DATEADD(DAY, RAND(CHECKSUM(NEWID()))*(1+DATEDIFF(DAY, '01-01-2022', '01-01-2023')),'01-01-2022')
UPDATE DimAirFlight
SET departure = DATEADD(SECOND ,RAND(CHECKSUM(NEWID())) * 86400,CONVERT(datetime,CONVERT(varchar(8),GETDATE(),112)))
UPDATE DimAirFlight
SET Arrival = DATEADD(SECOND,FLOOR(RAND(CHECKSUM(NEWID()))*86400),departure) 
alter table dimairflight
add duration_min int 
UPDATE DimAirFlight
SET duration_min = datediff(SECOND,departure,Arrival)/60  
update dbo.DimClients
set PhoneNumber = FORMAT(FLOOR(RAND(CHECKSUM(NEWID()))*(999999-100000+1)+100000),'##-##-##')
update dbo.DimManagers
set PhoneNumber = FORMAT(FLOOR(RAND(CHECKSUM(NEWID()))*(999999-100000+1)+100000),'##-##-##')
update dbo.DimClients
set Passport = CONCAT(LEFT(firstname,1),LEFT(lastname,1),FLOOR(RAND(CHECKSUM(NEWID()))*(999999-100000+1)+100000))
update dbo.DimManagers
set Passport = CONCAT(LEFT(firstname,1),LEFT(lastname,1),FLOOR(RAND(CHECKSUM(NEWID()))*(999999-100000+1)+100000))
update dbo.DimManagers
set Email = CONCAT(LOWER(LEFT(firstname,3)),LOWER(LEFT(lastname,3)),'@manager.com')
update dbo.DimAirFlight
set territoryarrival =(select cont from R_adress_X2 x2 where x2.id=DimAirFlight.avialid+2000 )
where cityarrival is null
update dbo.DimAirFlight
set cityarrival =(select cit from R_adress_X2 x2 where x2.id=DimAirFlight.avialid+2000 )
where cityarrival is null
update dbo.DimClients
set TypeClient = (CASE CEILING(RAND(CHECKSUM(NEWID()))*3)
		WHEN 1 THEN 'x'
		WHEN 2 THEN 'y'
		ELSE 'z'
		END)
update dbo.DimManagers
set Position = (CASE CEILING(RAND(CHECKSUM(NEWID()))*3)
		WHEN 1 THEN 'a'
		WHEN 2 THEN 'b'
		ELSE 'c'
		END)
update dbo.DimAirFlight
set flightnumber = concat((CASE CEILING(RAND(CHECKSUM(NEWID()))*5)
		WHEN 1 THEN 'aa'
		WHEN 2 THEN 'bb'
		WHEN 3 THEN 'cc'
		WHEN 4 THEN 'dd'
		ELSE 'ee'
		END),TerritoryDeparture,TerritoryArrival,datepart(dd,departure),datepart(MM,departure))
update dbo.DimAirFlight
set baggage = (CASE CEILING(RAND(CHECKSUM(NEWID()))*5)
		WHEN 1 THEN 'animals'
		WHEN 2 THEN 'outsized'
		WHEN 3 THEN 'heavy' 
		WHEN 4 THEN 'bags'
		ELSE 'rucksacks' 
		END)
update DimManagers
set passport = CONCAT(LEFT(firstname,1),LEFT(lastname,1),FLOOR(RAND(CHECKSUM(NEWID()))*(999999-100000+1)+100000))
where passport in (SELECT passport FROM [dbo].[DimManagers] group by passport having count(passport)>1)

delete from R_hotel where LEFT(price,1) like '[%a-z]'

with T (HotelName,HotelType,Adress,LocationType,RoomType,TypeFood,Price,HotelID) 
	as (select top (1000) * , row_number() over (order by hotel_name) as HotelID from R_hotel) 
select 
 HotelName,HotelType,LocationType,RoomType,TypeFood,Price,HotelID,
 (select cont from R_adress_X2 where R_adress_X2.id=T.HotelID+4000) as Country,
 (select cit from R_adress_X2 where R_adress_X2.id=T.HotelID+4000) as City,
 concat(Adress,', ',FLOOR(RAND(CHECKSUM(NEWID()))*200+1)) as Adress
INTO DimHotels
from T

WITH
	L0   AS (SELECT c FROM (SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL 
							SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL 
							SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL
							SELECT 1) AS D(c)), -- 10^1
	L1   AS (SELECT 1 AS c FROM L0 AS A CROSS JOIN L0 AS B),       -- 10^2
	L2   AS (SELECT 1 AS c FROM L1 AS A CROSS JOIN L1 AS B),       -- 10^4
	L3   AS (SELECT 1 AS c FROM L2 AS A CROSS JOIN L2 AS B),       -- 10^4
	NUMS AS (SELECT ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS k FROM L3)
select 
		(IIF (k<100000,cast((ABS(CHECKSUM(NEWID())) % k+1) as int),
				    cast((ABS(CHECKSUM(NEWID())) % 100000) as int))) as ClientID,
		(IIF (k<1000,cast((ABS(CHECKSUM(NEWID())) % k+1) as int),
				    cast((ABS(CHECKSUM(NEWID())) % 1000) as int))) as HotelID,
		(IIF (k<100000,cast((ABS(CHECKSUM(NEWID())) % k+1) as int),
				    cast((ABS(CHECKSUM(NEWID())) % 100000) as int))) as ManagerID,
		(IIF (k<1000,cast((ABS(CHECKSUM(NEWID())) % k+1) as int),
				    cast((ABS(CHECKSUM(NEWID())) % 1000) as int))) as AvialID,
		cast((ABS(CHECKSUM(NEWID())) % 40) as int) as Discount
INTO FctSales
from NUMS
where k <= 1000000

UPDATE FctSales
SET SalesDate = (select DATEADD(SECOND,-FLOOR(RAND(CHECKSUM(NEWID()))*6546013),departure) 
						from DimAirFlight where DimAirFlight.AvialID=FctSales.AvialID)

UPDATE FctSales
SET StartDate = (select DATEADD(SECOND,FLOOR(RAND(CHECKSUM(NEWID()))*86400),Arrival) 
						from DimAirFlight where DimAirFlight.AvialID=FctSales.AvialID)

UPDATE FctSales
SET EndDate = (select DATEADD(day,FLOOR(RAND(CHECKSUM(NEWID()))*180+1),StartDate) 
						from DimAirFlight where DimAirFlight.AvialID=FctSales.AvialID)

alter table fctsales
add duration_day int

update fctsales
set duration_day = datediff(DAY,StartDate,EndDate) 

alter table fctsales
add Price money

update fctsales 
set Price = duration_day* (SELECT dh.price
							FROM DimHotels DH where
							fctsales.HotelID=DH.HotelID)* (1- Discount/100)

SELECT *
FROM FctSales 
where startdate is null

Update  FctSales
set SalesDate = coalesce(SalesDate,DATEADD(DAY, RAND(CHECKSUM(NEWID()))*(1+DATEDIFF(DAY, '01-01-2022', '01-01-2023')),'01-01-2023'))

update fctSales
set ManagerID=RAND()*1000+1 where ManagerID=0
update fctSales
set ClientID=RAND()*1000+1 where ClientID=0
update fctSales
set AvialID=RAND()*1000+1 where AvialID=0
update fctSales
set HotelID=RAND()*1000+1 where HotelID=0

select *
FROM FctSales fct
left join  DimAirFlight on
fct.avialid=DimAirFlight.avialid
where DimAirFlight.avialid is null