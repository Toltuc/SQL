--SQLQuery2-AGGREGATION.sql
--COUNT - кількість рядків;
--SUM   - сума значень у розрізі груп;
--AVG   - середньо-арифметичне значення;
--MIN   - мінімальне значення;
--MAX   - максимальне значення;
--SELECT
USE P_421_Import;

--SELECT COUNT(*) FROM Directions;

--SELECT
--		[Напрям навчання]	=	direction_name,
--		[Кількість груп]		=	COUNT(group_id)
--FROM	Groups,Directions
--WHERE	direction=direction_id
--GROUP BY direction_name
--;

--SELECT
--		[Група]				=	group_name,
--		[Кількість студентів]	=	COUNT(stud_id)
--FROM	Students,Groups
--WHERE	[group]=group_id
--GROUP BY group_name
--;

--SELECT 
--		[Студент]	=	FORMATMESSAGE(N'%s %s %s', last_name, first_name, middle_name),
--		[Вік]	=	DATEDIFF(HOUR, birth_date, GETDATE())/8766
--		--DATEDIFF(HOUR, birth_date, GETDATE())/8766 AS N'Вік'
--FROM	Students
--WHERE	DATEDIFF(HOUR, birth_date, GETDATE())/8766 BETWEEN 20 AND 40
--ORDER BY [Вік]

SELECT
		[Група]				=	group_name,
		[Кількість студентів]	=	(SELECT COUNT(stud_id) FROM Students WHERE [group]=group_id)
FROM	Groups
WHERE	(SELECT COUNT(stud_id) FROM Students WHERE [group]=group_id)=0
;
--(SELECT COUNT(stud_id) FROM Students, Groups WHERE [group]=group_id)
