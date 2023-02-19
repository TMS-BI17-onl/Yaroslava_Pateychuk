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
	('����','����������','�����',2,3),
	('�������','����������','�����',NULL,NULL),
	('��������','����������','�����',NULL,NULL),
	('�����','����������','������',5,6),
	('�������','����������','������',7,NULL),
	('���������','�������������','������',NULL,NULL),
	('�������','����������','������',NULL,NULL)

SELECT * FROM People

TRUNCATE TABLE People

DROP TABLE IF EXISTS People 

SELECT 
	A.FirstName AS ���_�������, A.ParentName AS ��������_�������, A.LastName AS �������_�������,
	B.FirstName AS ���_����, B.ParentName AS ��������_����, B.LastName AS �������_����	
FROM People A 
INNER JOIN People B ON
A.ID_Father = B.ID
WHERE A.ParentName = '����������'
