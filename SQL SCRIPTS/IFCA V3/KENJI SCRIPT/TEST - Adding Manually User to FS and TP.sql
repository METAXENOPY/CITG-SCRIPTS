SELECT * FROM mgr.cfs_user_mstr WHERE user_name LIKE '%DORRIE%' -- userid = 'ADELYN.N'
SELECT * FROM mgr.cfs_user_mstr WHERE userid = 'CLYDE.M'
SELECT * FROM mgr.cfs_user_mstr WHERE userid = ''

INSERT INTO mgr.cfs_user_mstr
VALUES ('LIANNE.M','LIANNE.M', 'AUDIT', 'N', '-','-','-', 'LIANNE MARIE JOY BALIWAGAN MONCADA','mgr', '1999-01-01 00:00:00.000', 'N', NULL, '', NULL),
('MJ.ABANO','MJ.ABANO', 'AR_MAS', 'M', '-','-','-','Maria Jonna Aba�o','mgr', '1999-01-01 00:00:00.000', 'N', NULL, '', NULL)

SELECT * FROM mgr.cfs_user_entity WHERE userid = 'LIANNE.M'
SELECT * FROM mgr.cfs_user_entity WHERE userid = 'CJ.LUSTE'
SELECT * FROM mgr.cfs_user_entity WHERE userid = 'MJ.ABANO'

INSERT INTO mgr.cfs_user_entity
VALUES ('LIANNE.M','CU','mgr',GETDATE()),
('MJ.ABANO','CU','mgr',GETDATE())

SELECT * FROM mgr.security_users WHERE name = 'LIANNE.M'
SELECT * FROM mgr.security_users WHERE name = 'CJ.LUSTE'

UPDATE mgr.security_users
SET entity_cd = 'CU',
project_no = ''
WHERE name = 'MJ.ABANO'


SELECT * FROM mgr.security_groupings WHERE application = 'dclubar'
SELECT * FROM mgr.security_groupings WHERE user_name = 'CLYDE.M'
SELECT * FROM mgr.security_groupings WHERE user_name = 'LIANNE.M'
SELECT * FROM mgr.security_groupings WHERE user_name = 'CJ.LUSTE'
SELECT * FROM mgr.security_groupings WHERE user_name LIKE '%JOV%'

UPDATE mgr.security_groupings
SET group_name = 'MEMBERSHIP'
WHERE user_name = 'TITO.S'

INSERT INTO mgr.security_groupings (group_name,user_name,AUDIT_USER,AUDIT_DATE,application)
VALUES ('AR','LOWELYN.L','mgr',GETDATE(),'dclub')

UPDATE mgr.security_groupings
SET group_name = 'MC COUPSPEC'
WHERE user_name = 'KEVIN.B' AND application = 'dclub'





SELECT  * FROM mgr.security_users
WHERE (( mgr.security_users.user_type = 1 )   ) AND mgr.security_users.application = 'dclub'
