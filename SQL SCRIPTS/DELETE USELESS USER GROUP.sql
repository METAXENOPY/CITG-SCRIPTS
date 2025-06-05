USE dclubv3_cu_live
GO

SELECT * FROM mgr.security_users
DELETE FROM mgr.security_users
WHERE name IN()
GO

SELECT DISTINCT(USER_GROUP) FROM mgr.users_menu ORDER BY USER_GROUP
DELETE FROM mgr.users_menu
WHERE user_group IN
()
GO