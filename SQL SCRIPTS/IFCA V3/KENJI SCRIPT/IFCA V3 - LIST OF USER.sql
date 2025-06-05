USE dclubv3_cu_live
GO

SELECT A.userid AS 'USERNAME', A.user_name AS 'FULLNAME',
'GROUPID' = (SELECT name FROM mgr.security_users WHERE user_type = '1' AND mgr.security_users.name = B.group_name),
'GROUP NAME' = (SELECT description FROM mgr.security_users WHERE user_type = '1' AND mgr.security_users.name = B.group_name),
B.application
FROM mgr.cfs_user_mstr A INNER JOIN mgr.security_groupings B ON A.userid = B.user_name
ORDER BY A.user_name ASC