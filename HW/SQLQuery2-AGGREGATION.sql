--SQLQuery2-AGGREGATION.sql (Код с экрана преподавателя + мои примеры)
--COUNT - количество записей;
--SUM   - сумма значений в разных записях;
--AVG   - среднее-арифметическое значений;
--MIN   - минимальное значение;
--MAX   - максимальное значение;

USE P_421_Import;
GO

-----------------------------------------------------------
-- 1. COUNT (Количество)
-----------------------------------------------------------
-- Считаем общее количество направлений (базовый запрос с урока):
SELECT COUNT(*) FROM Directions;

-- Бонус:
SELECT COUNT(student_id) AS [Количество студентов] FROM Students;

-----------------------------------------------------------
-- 2. SUM (Сумма)
-----------------------------------------------------------
SELECT SUM(number_of_lessons) AS [Всего уроков по всем предметам] FROM Disciplines;

-----------------------------------------------------------
-- 3. AVG (Среднее значение)
-----------------------------------------------------------
SELECT AVG(rate) AS [Средняя ставка преподавателя] FROM Teachers;
SELECT AVG(grade) AS [Средний балл за экзамены] FROM Exams;

-----------------------------------------------------------
-- 4. MIN (Минимальное значение)
-----------------------------------------------------------
SELECT MIN(rate) AS [Минимальная ставка] FROM Teachers;
SELECT MIN(birth_date) AS [Дата рождения самого старшего студента] FROM Students;

-----------------------------------------------------------
-- 5. MAX (Максимальное значение)
-----------------------------------------------------------
SELECT MAX(number_of_lessons) AS [Максимальное число уроков] FROM Disciplines;

-----------------------------------------------------------
-- 6. GROUP BY (ОБЪЕДИНЕНИЕ + ГРУППИРОВКА КАК У УЧИТЕЛЯ)
-----------------------------------------------------------
-- Считаем количество групп на каждом "направлении" (вариант через старый WHERE как на уроке):
SELECT
    [Направление обучения] = direction_name,
    [Количество групп]     = COUNT(group_id)
FROM Groups, Directions
WHERE direction = direction_id
GROUP BY direction_name;

-- Продвинутый вариант через JOIN:
SELECT 
    [Группа]               = Groups.group_name,
    [Количество студентов] = COUNT(Students.student_id)
FROM Students
JOIN Groups ON Students.[group] = Groups.group_id
GROUP BY Groups.group_name;

-----------------------------------------------------------
-- 7. КОЛИЧЕСТВО СТУДЕНТОВ НА КАЖДОМ НАПРАВЛЕНИИ (в стиле учителя)
-----------------------------------------------------------
SELECT 
    [Направление]          = direction_name, 
    [Количество студентов] = COUNT(student_id)
FROM   Students, Groups, Directions
WHERE  Students.[group] = Groups.group_id
  AND  Groups.direction = Directions.direction_id
GROUP BY direction_name
;

-----------------------------------------------------------
-- 8. КОЛИЧЕСТВО ПРЕПОДАВАТЕЛЕЙ ПО ДИСЦИПЛИНАМ (через JOIN)
-----------------------------------------------------------
SELECT 
    [Дисциплина]                = Disciplines.discipline_name,
    [Количество преподавателей] = COUNT(TeachersDisciplinesRelation.teacher)
FROM   Disciplines
JOIN   TeachersDisciplinesRelation ON Disciplines.discipline_id = TeachersDisciplinesRelation.discipline
GROUP BY Disciplines.discipline_name
;

-----------------------------------------------------------
-- 9. ВЫВЕСТИ СТУДЕНТОВ ОТ 25 ДО 35 ЛЕТ
-----------------------------------------------------------
SELECT 
    last_name AS [Фамилия],
    first_name AS [Имя],
    birth_date AS [Дата рождения],
    DATEDIFF(YEAR, birth_date, GETDATE()) AS [Возраст]
FROM Students
WHERE DATEDIFF(YEAR, birth_date, GETDATE()) BETWEEN 25 AND 35
;
