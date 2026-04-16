-- ДОМАШНЕЕ ЗАДАНИЕ (Пункт 2): 
-- Заполнить расписание для группы P421 от начала обучения по сей день.

USE P_421_Import; -- Если база называется так
GO

-- 1. Настраиваем переменные (можете поменять стартовую дату!)
DECLARE @group_name NVARCHAR(16) = 'P421';
DECLARE @start_date DATE = '2023-09-01'; -- ДАТА НАЧАЛА ВАШЕГО ОБУЧЕНИЯ
DECLARE @end_date DATE = CAST(GETDATE() AS DATE); -- Сегодняшний день

-- 2. Автоматически находим нужные ID, чтобы не вписывать вручную
DECLARE @group_id INT = (SELECT MIN(group_id) FROM Groups WHERE group_name = @group_name);
DECLARE @discipline_id SMALLINT = (SELECT MIN(discipline_id) FROM Disciplines);
DECLARE @teacher_id INT = (SELECT MIN(teacher_id) FROM Teachers);

-- 3. ЦИКЛ ЗАПОЛНЕНИЯ РАСПИСАНИЯ
IF @group_id IS NOT NULL AND @discipline_id IS NOT NULL AND @teacher_id IS NOT NULL
BEGIN
    WHILE @start_date <= @end_date
    BEGIN
        -- Записываем проведенный урок
        INSERT INTO Schedule ([date], [time], [group], discipline, teacher, subject, spent)
        VALUES (
            @start_date, 
            '18:00:00',   -- Время занятия
            @group_id, 
            @discipline_id, 
            @teacher_id, 
            'Темы по SQL', -- Название темы
            1             -- Урок состоялся (spent = true)
        );
        
        -- Перепрыгиваем на 1 неделю вперед (каждые 7 дней)
        SET @start_date = DATEADD(DAY, 7, @start_date);
    END
    
    PRINT 'Расписание успешно сгенерировано до сегодняшнего дня!';
END
ELSE
BEGIN
    PRINT 'Ошибка: Не найдена группа P421, либо в базе нет ни одного предмета или преподавателя.';
END
GO

-- Проверяем результат (выведет все уроки этой группы):
SELECT * FROM Schedule 
WHERE [group] = (SELECT group_id FROM Groups WHERE group_name = 'P421')
ORDER BY [date] DESC;
