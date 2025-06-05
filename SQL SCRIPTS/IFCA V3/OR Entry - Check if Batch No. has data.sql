USE TEST_dclubv3_cu_live
GO

DECLARE @batch VARCHAR(10)
SET @batch = '17694'

--For OR Entry
SELECT * FROM mgr.ar_paytrx where batch_no = @batch