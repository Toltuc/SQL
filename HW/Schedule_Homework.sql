-- ДЗ: заполнить расписание для группы P421 от начала обучения по сей день

USE P_421_Import;
GO

DECLARE @group_name NVARCHAR(16) = 'P421';
DECLARE @start_date DATE = '2023-09-01';
DECLARE @end_date DATE = CAST(GETDATE() AS DATE);

DECLARE @group_id INT = (SELECT MIN(group_id) FROM Groups WHERE group_name = @group_name);
DECLARE @discipline_id SMALLINT = (SELECT MIN(discipline_id) FROM Disciplines);
DECLARE @teacher_id INT = (SELECT MIN(teacher_id) FROM Teachers);

IF @group_id IS NOT NULL AND @discipline_id IS NOT NULL AND @teacher_id IS NOT NULL
BEGIN
    WHILE @start_date <= @end_date
    BEGIN
        INSERT INTO Schedule ([date], [time], [group], discipline, teacher, subject, spent)
        VALUES (
            @start_date, 
            '18:00:00',
            @group_id, 
            @discipline_id, 
            @teacher_id, 
            'Темы по SQL',
            1
        );
        SET @start_date = DATEADD(DAY, 7, @start_date);
    END
    PRINT 'Готово';
END
ELSE
BEGIN
    PRINT 'Ошибка: группа, предмет или преподаватель не найдены';
END
GO

SELECT * FROM Schedule 
WHERE [group] = (SELECT group_id FROM Groups WHERE group_name = 'P421')
ORDER BY [date] DESC;