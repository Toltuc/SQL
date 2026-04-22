--SQLQuery1-INSERT.sql
USE P_421_Import;

--SELECT * FROM Students;
--SELECT * FROM Groups;
--SELECT * FROM Directions;

--SELECT
--		group_name,direction_name
--FROM	Groups,Directions 
--WHERE	direction=direction_id;
-------------------------------------------------------------------------
--SELECT
--		stud_id			AS	N'ID',
--		last_name		AS	N'Прізвище',
--		first_name		AS	N'Ім''я',
--		middle_name		AS	N'По батькові',
--		birth_date		AS	N'Дата народження',
--		group_name		AS	N'Група',
--		direction_name	AS	N'Напрям навчання'
--FROM	Students,Groups,Directions
--WHERE	[group]		=	group_id
--AND		direction	=	direction_id
--;
-------------------------------------------------------------------------
SELECT
		[ID]					=	stud_id,
		[Студент]				=	FORMATMESSAGE(N'%s %s %s', last_name, first_name, middle_name),
		[Дата народження]		=	birth_date,
		[Вік]					=	DATEDIFF(HOUR,birth_date,GETDATE())/8766,
		[Група]					=	group_name,
		[Напрям навчання]	=	direction_name
FROM	Students,Groups,Directions
WHERE	[group]		=	group_id
AND		direction	=	direction_id
;
PRINT CAST(DATEDIFF(HOUR,N'2000-04-14', GETDATE())/8766 AS TINYINT);
PRINT DATEDIFF(HOUR,N'2000-04-15', GETDATE())/8766;
