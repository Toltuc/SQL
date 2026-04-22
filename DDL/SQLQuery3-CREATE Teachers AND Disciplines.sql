--SQLQuery3-CREATE Teachers AND Disciplines.sql
USE P_421_DDL;

--CREATE TABLE Teachers
--(
--	teacher_id	INT			PRIMARY KEY,
--	last_name	NVARCHAR(50)NOT NULL,
--	first_name	NVARCHAR(50)NOT NULL,
--	middle_name	NVARCHAR(50),
--	birth_date	DATE		NOT NULL,
--	email		NVARCHAR(50),
--	phone		NVARCHAR(20),
--	photo		VARBINARY(MAX),
--	work_since	DATE		NOT NULL,
--	rate		MONEY		NOT NULL
--);

CREATE TABLE Disciplines
(
	discipline_id		SMALLINT		PRIMARY KEY,
	discipline_name		NVARCHAR(150)	NOT NULL,
	number_of_lessons	SMALLINT		NOT NULL
);

CREATE TABLE TeacherDisciplinesRelation
(
	teacher		INT
	CONSTRAINT	FK_TDR_Teachers		FOREIGN KEY REFERENCES Teachers(teacher_id),
	discipline	SMALLINT
	CONSTRAINT	FK_TDR_Disciplines	FOREIGN KEY REFERENCES Disciplines(discipline_id),
	PRIMARY KEY (teacher,discipline)
);
CREATE TABLE DisciplinesDirectionsRelation
(
	discipline	SMALLINT,
	direction	TINYINT,
	PRIMARY KEY(discipline,direction),
	CONSTRAINT	FK_DDR_Disciplines	FOREIGN KEY(discipline)	REFERENCES Disciplines(discipline_id),
	CONSTRAINT	FK_DDR_Directions	FOREIGN KEY(direction)	REFERENCES Directions(direction_id)
);
