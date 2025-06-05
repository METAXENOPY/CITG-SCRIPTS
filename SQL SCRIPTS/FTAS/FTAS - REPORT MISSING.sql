USE FTACCTNG

SELECT * FROM dbo.tbl_M_user WHERE username LIKE '%ella%'
SELECT * FROM dbo.tbl_M_user WHERE userfullname LIKE '%MARIBEL%'
SELECT * FROM dbo.tbl_M_user WHERE userfullname LIKE '%Deniega%'
SELECT * FROM dbo.tbl_M_user ORDER BY userid DESC

SELECT * FROM dbo.tbl_M_user WHERE userfullname LIKE '%CITG%'

UPDATE dbo.tbl_M_user
SET usergroupid = '4'
WHERE userid = '214' AND username = 'Arlene.Deniega'

SELECT userid,r_spu_e FROM tbl_M_userreport WHERE userid = '214'

SELECT * FROM dbo.tbl_M_userreport WHERE userid = '101'

INSERT INTO dbo.tbl_M_userreport
VALUES ('217', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1')
