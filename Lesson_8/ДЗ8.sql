-- добавление ID в выгрузку
alter table dbo.DimPersons
ADD PersonID INT IDENTITY(1,1);

-- удаление лишнего символа (при выгрузке в БД)
UPDATE dbo.DimPersons
SET LastName=TRIM(';' from LastName);

-- проверка количества записей в DimPersons
DECLARE @size INT;
SET @size = (SELECT COUNT(*) FROM DimPersons);
SELECT @size;

-- заполнение таблицы
WITH
  L0   AS (SELECT c FROM (SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL 
                          SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL 
						  SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL
						  SELECT 1) AS D(c)), -- 10^1
  L1   AS (SELECT 1 AS c FROM L0 AS A CROSS JOIN L0 AS B),       -- 10^2
  L2   AS (SELECT 1 AS c FROM L1 AS A CROSS JOIN L1 AS B),       -- 10^4
  L3   AS (SELECT 1 AS c FROM L2 AS A CROSS JOIN L2 AS B),       -- 10^6
  NUMS AS (SELECT ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS k FROM L3)

select k as id , 
	  (select FirstName from DimPersons where PersonID=		
			IIF (k<8000,cast((ABS(CHECKSUM(NEWID())) % k+1) as int),cast((ABS(CHECKSUM(NEWID())) % 8000) as int))) as FirstName,
	  (select LastName from DimPersons where PersonID= 
	       IIF (k<8000,cast((ABS(CHECKSUM(NEWID())) % k+1) as int),cast((ABS(CHECKSUM(NEWID())) % 8000) as int))) as LastName INTO RandomName
from NUMS
where k <= 1000000

SELECT TOP 20 * FROM RandomName ORDER BY NEWID()











