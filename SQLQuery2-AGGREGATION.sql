USE P_421_Import;
GO

-- COUNT
SELECT COUNT(*) FROM Directions;
SELECT COUNT(student_id) AS [Количество студентов] FROM Students;

-- SUM
SELECT SUM(number_of_lessons) AS [Всего уроков по всем предметам] FROM Disciplines;

-- AVG
SELECT AVG(rate) AS [Средняя ставка преподавателя] FROM Teachers;
SELECT AVG(grade) AS [Средний балл за экзамены] FROM Exams;

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

-- количество студентов на каждом направлении
SELECT 
    [Направление]          = direction_name, 
    [Количество студентов] = COUNT(student_id)
FROM   Students, Groups, Directions
WHERE  Students.[group] = Groups.group_id
  AND  Groups.direction = Directions.direction_id
GROUP BY direction_name;

-- количество преподавателей по дисциплинам
SELECT 
    [Дисциплина]                = Disciplines.discipline_name,
    [Количество преподавателей] = COUNT(TeachersDisciplinesRelation.teacher)
FROM   Disciplines
JOIN   TeachersDisciplinesRelation ON Disciplines.discipline_id = TeachersDisciplinesRelation.discipline
GROUP BY Disciplines.discipline_name;

-- студенты от 25 до 35 лет
SELECT 
    last_name AS [Фамилия],
    first_name AS [Имя],
    birth_date AS [Дата рождения],
    DATEDIFF(YEAR, birth_date, GETDATE()) AS [Возраст]
FROM Students
WHERE DATEDIFF(YEAR, birth_date, GETDATE()) BETWEEN 25 AND 35;

