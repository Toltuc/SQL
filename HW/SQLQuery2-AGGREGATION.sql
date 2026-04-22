--SQLQuery2-AGGREGATION.sql
USE P_421_Import;
GO

-- COUNT
SELECT COUNT(*) FROM Directions;
SELECT COUNT(student_id) AS [Количество студентов] FROM Students;

-- SUM
SELECT SUM(number_of_lessons) AS [Всего уроков] FROM Disciplines;

-- AVG
SELECT AVG(rate) AS [Средняя ставка преподавателя] FROM Teachers;
SELECT AVG(grade) AS [Средний балл] FROM Exams;

-- MIN
SELECT MIN(rate) AS [Минимальная ставка] FROM Teachers;
SELECT MIN(birth_date) AS [Дата рождения самого старшего студента] FROM Students;

-- MAX
SELECT MAX(number_of_lessons) AS [Максимальное число уроков] FROM Disciplines;

-- GROUP BY
SELECT
		[Направление обучения] = direction_name,
		[Количество групп]     = COUNT(group_id)
FROM Groups, Directions
WHERE direction = direction_id
GROUP BY direction_name;

SELECT 
		[Группа]               = Groups.group_name,
		[Количество студентов] = COUNT(Students.student_id)
FROM Students
JOIN Groups ON Students.[group] = Groups.group_id
GROUP BY Groups.group_name;

SELECT 
		[Направление]          = direction_name, 
		[Количество студентов] = COUNT(student_id)
FROM   Students, Groups, Directions
WHERE  Students.[group] = Groups.group_id
  AND  Groups.direction = Directions.direction_id
GROUP BY direction_name
;

SELECT 
		[Дисциплина]                = Disciplines.discipline_name,
		[Количество преподавателей] = COUNT(TeachersDisciplinesRelation.teacher)
FROM   Disciplines
JOIN   TeachersDisciplinesRelation ON Disciplines.discipline_id = TeachersDisciplinesRelation.discipline
GROUP BY Disciplines.discipline_name
;

-- ДЗ 1: вывести студентов в возрасте от 25 до 35 лет
SELECT 
		last_name  AS [Фамилия],
		first_name AS [Имя],
		birth_date AS [Дата рождения],
		DATEDIFF(YEAR, birth_date, GETDATE()) AS [Возраст]
FROM Students
WHERE DATEDIFF(YEAR, birth_date, GETDATE()) BETWEEN 25 AND 35
;

-- ДЗ 2: вывести группы в которых меньше 10 студентов
SELECT
		[Группа]               = group_name,
		[Количество студентов] = COUNT(student_id)
FROM Groups
LEFT JOIN Students ON Students.[group] = Groups.group_id
GROUP BY group_name
HAVING COUNT(student_id) < 10
;

-- ДЗ 3: вывести группы в которых нет студентов
SELECT
		[Группа]               = group_name,
		[Количество студентов] = COUNT(student_id)
FROM Groups
LEFT JOIN Students ON Students.[group] = Groups.group_id
GROUP BY group_name
HAVING COUNT(student_id) = 0
;