/****** Скрипт для команды SelectTopNRows из среды SSMS  ******/
alter table data_for_merge
add ID tinyint 
UPDATE data_for_merge
set ID=1

WITH T (Function_name, Function_count) AS
	 (select Alex, count(ID) over (partition by Alex) as 'Количество' from data_for_merge)
select *
into result
from T

select * 
from result
select*
from data_for_merge



WITH T (Function_name, Function_count) AS
	   (select Carlos, count(ID) over (partition by Carlos) as 'Количество' from data_for_merge where Carlos LIKE '_%_%')
MERGE INTO result R
USING T
ON T.Function_name = R.Function_name
WHEN MATCHED THEN
  UPDATE SET R.Function_count = R.Function_count + T.Function_count
WHEN NOT MATCHED THEN
  INSERT (Function_name, Function_count)
  VALUES (T.Function_name, T.Function_count);

WITH T (Function_name, Function_count) AS
	   (select Charles, count(ID) over (partition by Charles) as 'Количество' from data_for_merge where Charles LIKE '_%_%')
MERGE INTO result R
USING T
ON T.Function_name = R.Function_name
WHEN MATCHED THEN
  UPDATE SET R.Function_count = R.Function_count + T.Function_count
WHEN NOT MATCHED THEN
  INSERT (Function_name, Function_count)
  VALUES (T.Function_name, T.Function_count);

WITH T (Function_name, Function_count) AS
	   (select Daniel, count(ID) over (partition by Daniel) as 'Количество' from data_for_merge where Daniel LIKE '_%_%')
MERGE INTO result R
USING T
ON T.Function_name = R.Function_name
WHEN MATCHED THEN
  UPDATE SET R.Function_count = R.Function_count + T.Function_count
WHEN NOT MATCHED THEN
  INSERT (Function_name, Function_count)
  VALUES (T.Function_name, T.Function_count);

WITH T (Function_name, Function_count) AS
	   (select Esteban, count(ID) over (partition by Esteban) as 'Количество' from data_for_merge where Esteban LIKE '_%_%')
MERGE INTO result R
USING T
ON T.Function_name = R.Function_name
WHEN MATCHED THEN
  UPDATE SET R.Function_count = R.Function_count + T.Function_count
WHEN NOT MATCHED THEN
  INSERT (Function_name, Function_count)
  VALUES (T.Function_name, T.Function_count);

WITH T (Function_name, Function_count) AS
	   (select Fred, count(ID) over (partition by Fred) as 'Количество' from data_for_merge where Fred LIKE '_%_%')
MERGE INTO result R
USING T
ON T.Function_name = R.Function_name
WHEN MATCHED THEN
  UPDATE SET R.Function_count = R.Function_count + T.Function_count
WHEN NOT MATCHED THEN
  INSERT (Function_name, Function_count)
  VALUES (T.Function_name, T.Function_count);

WITH T (Function_name, Function_count) AS
	   (select George, count(ID) over (partition by George) as 'Количество' from data_for_merge where George LIKE '_%_%')
MERGE INTO result R
USING T
ON T.Function_name = R.Function_name
WHEN MATCHED THEN
  UPDATE SET R.Function_count = R.Function_count + T.Function_count
WHEN NOT MATCHED THEN
  INSERT (Function_name, Function_count)
  VALUES (T.Function_name, T.Function_count);

WITH T (Function_name, Function_count) AS
	   (select Lando, count(ID) over (partition by Lando) as 'Количество' from data_for_merge where Lando LIKE '_%_%')
MERGE INTO result R
USING T
ON T.Function_name = R.Function_name
WHEN MATCHED THEN
  UPDATE SET R.Function_count = R.Function_count + T.Function_count
WHEN NOT MATCHED THEN
  INSERT (Function_name, Function_count)
  VALUES (T.Function_name, T.Function_count);

WITH T (Function_name, Function_count) AS
	   (select Lewis, count(ID) over (partition by Lewis) as 'Количество' from data_for_merge where Lewis LIKE '_%_%')
MERGE INTO result R
USING T
ON T.Function_name = R.Function_name
WHEN MATCHED THEN
  UPDATE SET R.Function_count = R.Function_count + T.Function_count
WHEN NOT MATCHED THEN
  INSERT (Function_name, Function_count)
  VALUES (T.Function_name, T.Function_count);



  
