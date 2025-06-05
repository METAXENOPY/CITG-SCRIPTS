USE comm

SELECT * FROM [dbo].[tbl_dir_crht]

UPDATE [dbo].[tbl_dir_crht]
SET dir_contact_person = 'Supervisor - Margie Balansag'
WHERE dir_department = 'CAFE-GLO' AND dir_local_number = '8044' AND dir_contact_person = 'Supervisor - Margie'


INSERT INTO [dbo].[tbl_dir_crht] (dir_department, dir_contact_person, dir_local_number, dir_update_date)
VALUES ('CITG', 'Network Admin - Jess ', '8903', GETDATE())

INSERT INTO [dbo].[tbl_dir_crht] (dir_department, dir_contact_person, dir_local_number, dir_update_date)
VALUES ('FTRDC', 'Arlene Deniega', '8311', GETDATE())

INSERT INTO [dbo].[tbl_dir_crht] (dir_department, dir_contact_person, dir_local_number, dir_update_date)
VALUES ('CAFE-GLO', 'Supervisor - Margie ', '8044', GETDATE())

DELETE [dbo].[tbl_dir_crht] WHERE dir_contact_person = 'System Analyst' AND dir_local_number = '8909'


USE [comm]

SELECT * FROM [dbo].[tbl_dir_crht] WHERE dir_local_number LIKE '%8214%'
SELECT * FROM [dbo].[tbl_dir_crht] ORDER BY dir_department

INSERT INTO [dbo].[tbl_dir_crht] (dir_department, dir_contact_person, dir_local_number, dir_update_date, dir_sbu)
VALUES ('CU-ACCOUNTING', 'Prana', '8333', GETDATE(), 'CRHT')

ALTER TABLE [dbo].[tbl_dir_crht]
ALTER COLUMN [dir_local_number] VARCHAR(255) NULL


UPDATE [dbo].[tbl_dir_crht]
SET dir_sbu = 'CRHT'
WHERE dir_local_number = '8903'

DELETE FROM [dbo].[tbl_dir_crht]
WHERE dir_department = 'CITG' AND dir_contact_person = 'Helpdesk2'


UPDATE [dbo].[tbl_dir_crht]
SET dir_department = 'HOTEL BILLING'
WHERE dir_department = 'Hotel billing'

