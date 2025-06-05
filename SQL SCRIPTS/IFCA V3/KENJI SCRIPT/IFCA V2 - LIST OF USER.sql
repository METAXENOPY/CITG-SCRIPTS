USE DCLUBAR_CU_LIVE
GO

SELECT T2.*,T1.[GROUP ID], T1.[GROUP NAME], T1.application FROM
(SELECT A.name AS 'GROUP ID', A.description AS 'GROUP NAME', B.user_name AS 'USERNAME', A.application
FROM mgr.security_users A, mgr.security_groupings B
WHERE  A.name = B.group_name) T1
INNER JOIN
(SELECT A.name AS 'USERNAME', A.description AS 'FULLNAME'
FROM mgr.security_users A, mgr.security_groupings B
WHERE  A.name = B.user_name) T2
ON (T1.USERNAME = T2.USERNAME)
ORDER BY T1.USERNAME