--GET ALL BATCH_NO THAT HAS DOC_AMT AND FOREIGN_TRX_AMT AND TRX_MODE = NULL
SELECT * FROM mgr.ar_temp_alloc WHERE debtor_acct = '15-70410' AND doc_no = 'IN9925'
SELECT * FROM mgr.ar_temp_alloc WHERE batch_no = '28290'

delete mgr.ar_temp_alloc
where debtor_acct = '15-70410'
and doc_no IN ('IN8688')
and batch_no in (12893000)
go

--GET ALL BATCH_NO THAT HAS STATUS = ''
SELECT * FROM mgr.ar_temp_alloc_dt WHERE debtor_acct = '15-70410' AND doc_no = 'IN9925'
SELECT * FROM mgr.ar_temp_alloc_dt WHERE batch_no = '28290'

delete mgr.ar_temp_alloc_dt
where debtor_acct = '15-70410'
and doc_no IN ('IN8688')
and batch_no in (12893)
go