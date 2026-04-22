--SQLQuery2-INSERTSchedule.sql
USE P_421_Import;
SET DATEFIRST 1;
GO

ALTER PROCEDURE sp_InsertSchedule
		@group_name			AS	NVARCHAR(10),
		@discipline_name	AS	NVARCHAR(150),
		@teacher_name		AS	NVARCHAR(50),
		@start_date			AS	DATE,
		@start_time			AS	TIME(0)
AS
BEGIN
		DECLARE @group		AS	INT		=	(SELECT group_id		FROM Groups			WHERE group_name=@group_name);
		DECLARE @discipline	AS	SMALLINT=	(SELECT discipline_id	FROM Disciplines	WHERE discipline_name LIKE @discipline_name);
		DECLARE @number_of_lessons	AS	TINYINT	=	(SELECT number_of_lessons FROM Disciplines	WHERE discipline_id=@discipline)
		DECLARE @lesson_number		AS	TINYINT =	
		(SELECT COUNT(lesson_id) FROM Schedule WHERE [group]=@group AND discipline=@discipline);
		DECLARE @teacher	AS	SMALLINT=	(SELECT teacher_id		FROM Teachers WHERE last_name LIKE @teacher_name OR first_name LIKE @teacher_name);
		DECLARE @date		AS	DATE	=	@start_date;
		DECLARE @time		AS	TIME(0)	=	@start_time;

		WHILE	@lesson_number < @number_of_lessons
		BEGIN
				SET @time = @start_time;
				EXEC sp_InsertLesson @group, @discipline, @teacher, @date, @time OUTPUT, @lesson_number OUTPUT;
				EXEC sp_InsertLesson @group, @discipline, @teacher, @date, @time OUTPUT, @lesson_number OUTPUT;
				SET @date = DATEADD(DAY, IIF(DATEPART(WEEKDAY, @date)=2,2,5), @date);
		END
END