SELECT * FROM mgr.ar_trxdt WHERE debtor_acct = '098078'
DELETE FROM mgr.ar_trxdt WHERE debtor_acct = '098078' AND doc_no LIKE '%RM%'

SELECT * FROM mgr.ar_temp_alloc_dt WHERE batch_no IN (28099,28096,28095,28094,28092)
SELECT * FROM mgr.ar_temp_alloc WHERE batch_no IN (28099,28096,28095,28094,28092)
DELETE FROM mgr.ar_temp_alloc WHERE batch_no IN (28099,28096,28095,28094,28092)

SELECT * FROM mgr.ar_batch WHERE batch_no IN (28099,28096,28095,28094,28092)
DELETE FROM mgr.ar_batch WHERE batch_no IN (28099,28096,28095,28094,28092)

SELECT * FROM mgr.ar_paytrx WHERE batch_no IN (28099,28096,28095,28094,28092)
DELETE FROM mgr.ar_paytrx WHERE batch_no IN (28099,28096,28095,28094,28092)

delete  mgr.ar_temp_alloc_dt
where debtor_acct = '098078'
--and doc_no = 'RM2000758'
go

delete  mgr.ar_temp_alloc
where debtor_acct = '098078'
--and doc_no = 'RM2000758'
go


