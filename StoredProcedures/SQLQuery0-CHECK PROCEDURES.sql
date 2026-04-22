--SQLQuery0-CHECK PROCEDURES.sql
USE P_421_Import;

--DELETE FROM Schedule;

EXECUTE sp_InsertSchedule N'P_421', N'%MS SQL Server', N'Юыху', N'2026-03-26', N'14:00'
EXECUTE sp_SelectSchedule;