use dclubar_cuvc_live
go

DECLARE @lock VARCHAR(8)
SET @lock = '0'
DECLARE @syscode VARCHAR(10)
SET @syscode = 'AVCEB'

--SELECT * FROM dbo.citg_m_syscon WHERE usr_login = 'BRYANONEZ'

UPDATE dbo.citg_m_syscon
SET sys_lock_stat = @lock ,sys_lock_msg = ''
WHERE sys_code = @syscode