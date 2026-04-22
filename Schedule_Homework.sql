-- ============================================================
-- ДЗ: Заполнение расписания для группы P421
-- ============================================================
-- ВЫПОЛНЕНО:
--   1. Проверка занятости преподавателя (не занят ли на это время)
--   2. Предотвращение дубликатов (уникальность по дате+времени+группе)
--   3. Заполнение не только по одному дню — поддержка нескольких дней недели
--   4. Вывод расписания через JOIN (имена вместо ID)
-- ============================================================

USE P_421_Import;
GO

-- ============================================================
-- ШАГ 1: Настройка параметров
-- ============================================================
DECLARE @group_name  NVARCHAR(16) = 'P421';
DECLARE @start_date  DATE         = '2023-09-01';   -- Начало учёбы
DECLARE @end_date    DATE         = CAST(GETDATE() AS DATE); -- Сегодня
DECLARE @lesson_time TIME(0)      = '18:00:00';

-- Дни недели для занятий: 2=Вт, 4=Чт (можно добавить другие)
-- DATEPART(WEEKDAY, ...) зависит от @@DATEFIRST. При стандарте воскресенье=1:
--   1=Вс, 2=Пн, 3=Вт, 4=Ср, 5=Чт, 6=Пт, 7=Сб
-- Для вторника и четверга: 3 и 5

-- ============================================================
-- ШАГ 2: Получаем нужные ID
-- ============================================================
DECLARE @group_id      INT      = (SELECT MIN(group_id)      FROM Groups      WHERE group_name = @group_name);
DECLARE @discipline_id SMALLINT = (SELECT MIN(discipline_id) FROM Disciplines);
DECLARE @teacher_id    INT      = (SELECT MIN(teacher_id)    FROM Teachers);

-- ============================================================
-- ШАГ 3: Цикл вставки по вторникам и четвергам
-- ============================================================
IF @group_id IS NOT NULL AND @discipline_id IS NOT NULL AND @teacher_id IS NOT NULL
BEGIN
    DECLARE @current_date DATE = @start_date;
    DECLARE @day_of_week  INT;
    DECLARE @inserted_count INT = 0;
    DECLARE @skipped_count  INT = 0;

    WHILE @current_date <= @end_date
    BEGIN
        -- Получаем день недели: с @@DATEFIRST=7 (по умолчанию SQL Server):
        -- 1=Вс, 2=Пн, 3=Вт, 4=Ср, 5=Чт, 6=Пт, 7=Сб
        SET @day_of_week = DATEPART(WEEKDAY, @current_date);

        -- Занятия только по вторникам (3) и четвергам (5)
        IF @day_of_week IN (3, 5)
        BEGIN
            -- Проверка 1: нет дубликата (та же группа, дата, время)
            -- Проверка 2: преподаватель НЕ занят в это время (другая группа)
            IF NOT EXISTS (
                SELECT 1 FROM Schedule
                WHERE [date]  = @current_date
                  AND [time]  = @lesson_time
                  AND [group] = @group_id
            )
            AND NOT EXISTS (
                SELECT 1 FROM Schedule
                WHERE [date]    = @current_date
                  AND [time]    = @lesson_time
                  AND teacher   = @teacher_id
            )
            BEGIN
                INSERT INTO Schedule ([date], [time], [group], discipline, teacher, [subject], spent)
                VALUES (
                    @current_date,
                    @lesson_time,
                    @group_id,
                    @discipline_id,
                    @teacher_id,
                    'Темы по SQL',
                    1   -- урок состоялся (spent = true)
                );
                SET @inserted_count = @inserted_count + 1;
            END
            ELSE
            BEGIN
                SET @skipped_count = @skipped_count + 1;
            END
        END

        -- Переходим к следующему дню
        SET @current_date = DATEADD(DAY, 1, @current_date);
    END

    PRINT 'Готово! Добавлено записей: ' + CAST(@inserted_count AS NVARCHAR)
        + '. Пропущено (дубликат или преподаватель занят): ' + CAST(@skipped_count AS NVARCHAR);
END
ELSE
BEGIN
    PRINT 'Ошибка: группа P421 не найдена, либо в базе нет предметов или преподавателей.';
END
GO

-- ============================================================
-- ШАГ 4: Вывод расписания с JOIN (слова вместо цифр)
-- ============================================================
SELECT
    S.lesson_id                                             AS [#],
    S.[date]                                                AS [Дата],
    DATENAME(WEEKDAY, S.[date])                             AS [День недели],
    CONVERT(NVARCHAR(5), S.[time])                          AS [Время],
    G.group_name                                            AS [Группа],
    D.discipline_name                                       AS [Дисциплина],
    T.last_name + ' ' + LEFT(T.first_name, 1) + '.'
        + ISNULL(' ' + LEFT(T.middle_name, 1) + '.', '')   AS [Преподаватель],
    S.[subject]                                             AS [Тема],
    CASE S.spent WHEN 1 THEN 'Проведён' ELSE 'Не проведён' END AS [Статус]
FROM Schedule S
JOIN Groups      G ON S.[group]     = G.group_id
JOIN Disciplines D ON S.discipline  = D.discipline_id
JOIN Teachers    T ON S.teacher     = T.teacher_id
WHERE G.group_name = 'P421'
ORDER BY S.[date] DESC;
GO
