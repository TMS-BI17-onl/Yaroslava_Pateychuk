create table People (
	ID INT IDENTITY NOT NULL,
	FirstName nvarchar(20) NOT NULL,
	ParentName nvarchar(20),
	LastName nvarchar(20) NOT NULL,
	ID_Father INT,
	ID_Mother INT,
	CONSTRAINT PK_People_ID PRIMARY KEY (ID),
	CONSTRAINT FK_People_ID_Father FOREIGN KEY (ID_Father)  REFERENCES People(ID),
	CONSTRAINT FK_People_ID_Mother FOREIGN KEY (ID_Mother)  REFERENCES People(ID),
	)

INSERT INTO People 
	(FirstName,ParentName,LastName,ID_Father,ID_Mother)
VALUES
	('Анна','Васильевна','Божук',2,3),
	('Василий','Николаевич','Божук',NULL,NULL),
	('Светлана','Викторовна','Божук',NULL,NULL),
	('Игорь','Дмитриевич','Панько',5,6),
	('Дмитрий','Дмитриевич','Панько',7,NULL),
	('Екатерина','Станиславовна','Панько',NULL,NULL),
	('Дмитрий','Степанович','Панько',NULL,NULL)

SELECT * FROM People

TRUNCATE TABLE People

DROP TABLE IF EXISTS People 

SELECT 
	A.FirstName AS Имя_ребенка, A.ParentName AS Отчество_ребенка, A.LastName AS Фамилия_ребенка,
	B.FirstName AS Имя_отца, B.ParentName AS Отчество_отца, B.LastName AS Фамилия_отца	
FROM People A 
INNER JOIN People B ON
A.ID_Father = B.ID
WHERE A.ParentName = 'Дмитриевич'
