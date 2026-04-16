-- ALL_IN_ONE.sql
-- 1. Create Database
USE master;
GO

IF DB_ID('P_421_DDL') IS NOT NULL
BEGIN
	ALTER DATABASE P_421_DDL SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE P_421_DDL;
END
GO

CREATE DATABASE P_421_DDL
ON
(
	NAME		= P_421_DDL_dat,
	FILENAME	= 'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\P_421_DDL.mdf',
	SIZE		= 8MB,
	MAXSIZE		= 500MB,
	FILEGROWTH	= 8MB
)
LOG ON
(
	NAME = P_421_DDL_log,
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\P_421_DDL.log',
	SIZE = 8MB,
	MAXSIZE = 500MB,
	FILEGROWTH = 8MB
);
GO

USE P_421_DDL;
GO

-- 2. Create Tables

CREATE TABLE Directions
(
	direction_id TINYINT PRIMARY KEY,
	direction_name NVARCHAR(150) NOT NULL
);

CREATE TABLE Groups
(
	group_id INT PRIMARY KEY,
	group_name NVARCHAR(16) NOT NULL,
	direction TINYINT NOT NULL
	CONSTRAINT FK_Groups_Directions FOREIGN KEY REFERENCES Directions(direction_id)
);

CREATE TABLE Students
(
	student_id INT PRIMARY KEY,
	last_name NVARCHAR(50) NOT NULL,
	first_name NVARCHAR(50) NOT NULL,
	middle_name NVARCHAR(50) NULL,
	birth_date DATE NOT NULL,
	email NVARCHAR(50) NULL,
	phone NVARCHAR(50) NULL,
	photo VARBINARY(MAX) NULL,
	[group] INT
	CONSTRAINT FK_Students_Groups FOREIGN KEY REFERENCES Groups(group_id)
);

CREATE TABLE Teachers
(
	teacher_id INT PRIMARY KEY,
	last_name	NVARCHAR(50)	NOT NULL,
	first_name	NVARCHAR(50)	NOT NULL,
	middle_name	NVARCHAR(50)	NULL,
	birth_date	DATE			NOT NULL,
	email		NVARCHAR(50) NULL,
	phone 		VARCHAR(20) NULL,
	photo		VARBINARY(MAX) NULL,
	rate		MONEY NOT NULL
);

CREATE TABLE Disciplines 
(
	discipline_id SMALLINT PRIMARY KEY,
	discipline_name NVARCHAR(150) NOT NULL,
	number_of_lessons SMALLINT NOT NULL
);

CREATE TABLE TeacherDisciplinesRelation
(
	teacher INT
	CONSTRAINT FK_TDR_Teachers FOREIGN KEY REFERENCES Teachers(teacher_id),
	discipline SMALLINT
	CONSTRAINT FK_TDR_Disciplines FOREIGN KEY REFERENCES Disciplines(discipline_id),
	PRIMARY KEY(teacher, discipline)
);

CREATE TABLE DisciplinesDirectionsRelation
(
	discipline SMALLINT,
	direction TINYINT,
	PRIMARY KEY(discipline, direction),
	CONSTRAINT FK_DDR_Disciplines FOREIGN KEY (discipline) REFERENCES Disciplines(discipline_id),
	CONSTRAINT FK_DDR_Directions FOREIGN KEY (direction) REFERENCES Directions(direction_id)
);

CREATE TABLE Schedule
(
	lesson_id	BIGINT PRIMARY KEY IDENTITY(1,1),
	[date]		DATE NOT NULL,
	[time]		TIME(0) NOT NULL,
	[group]		INT NOT NULL 
	CONSTRAINT FK_Schedule_Groups		FOREIGN KEY REFERENCES Groups(group_id),
	discipline	SMALLINT NOT NULL 
	CONSTRAINT FK_Schedule_Disciplines	FOREIGN KEY REFERENCES Disciplines(discipline_id),
	teacher		INT NOT NULL 
	CONSTRAINT FK_Schedule_Teachers		FOREIGN KEY REFERENCES Teachers(teacher_id),
	[subject]	NVARCHAR(256) NULL,
	spent		BIT	NOT NULL
);

CREATE TABLE Grades
(
	student	 INT	CONSTRAINT		FK_Grades_Students			FOREIGN KEY REFERENCES Students(student_id),
	lesson	 BIGINT CONSTRAINT		FK_Grades_Schedule		    FOREIGN KEY REFERENCES Schedule(lesson_id),
	PRIMARY KEY(student, lesson),
	grade_1 TINYINT CONSTRAINT CK_Grade_1 CHECK(grade_1 > 0 AND grade_1 <= 12),
	grade_2 TINYINT CONSTRAINT CK_Grade_2 CHECK(grade_2 > 0 AND grade_2 <= 12)
);

CREATE TABLE Exams
(
	student		INT		 CONSTRAINT		FK_Exams_Students		FOREIGN KEY REFERENCES Students(student_id),
	teacher		INT		 CONSTRAINT		FK_Exams_Teachers		FOREIGN KEY REFERENCES Teachers(teacher_id),
	discipline  SMALLINT CONSTRAINT		FK_Exams_Disciplines	FOREIGN KEY REFERENCES Disciplines(discipline_id),
	PRIMARY KEY(student, teacher, discipline),
	grade		TINYINT  CONSTRAINT		CK_Grade				CHECK(grade > 0 AND grade <= 12)
);

-- Homeworks tables (таблицы связанные с домашними заданиями)

CREATE TABLE HomeWorks (
    lesson_id BIGINT PRIMARY KEY
	   CONSTRAINT FK_HomeWorks_Schedule FOREIGN KEY REFERENCES Schedule(lesson_id),
    task NVARCHAR(1024) NOT NULL,
    deadline DATE NOT NULL,
    [date] DATE NULL  
);

CREATE TABLE HWresults (
    lesson_id BIGINT
        CONSTRAINT FK_HWresults_HomeWorks FOREIGN KEY (lesson_id) REFERENCES HomeWorks(lesson_id),
    student_id INT
        CONSTRAINT FK_HWresults_Students FOREIGN KEY REFERENCES Students(student_id),
    PRIMARY KEY (lesson_id, student_id),
    submission_date DATE NOT NULL,  
    answer NVARCHAR(1024) NOT NULL,
    grade TINYINT NOT NULL
);
