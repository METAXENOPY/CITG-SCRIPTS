USE dclubar_cuvc_live

 

SELECT * FROM dbo.citg_ar_rps_forprocess WHERE debtor_acctlnk = '15-60250' AND ccard_no = '4889079110301910'
SELECT debtor_acctlnk, ccard_no, trans_date, trans_amt, description, DATALENGTH(description) AS LENGTH FROM dbo.citg_ar_rps_forprocess ORDER BY DATALENGTH(description) DESC

UPDATE dbo.citg_ar_rps_forprocess
SET description = 'MEMDUES-JUN2018-MAY2019BAL'
WHERE trans_date = '2022-07-15 15:40:02.170' AND trans_amt = '4640.00' AND debtor_acctlnk = '15-30130'


update dbo.citg_ar_rps_forprocess set description = REPLACE(description, ' ', '')


update dbo.citg_m_rpsparam
set billnum_lock_stat = 0,
billnum_lock_msg = '',
filenum_lock_stat = 0,
filenum_lock_msg = ''

SELECT DB_ID('dclubar_cu_train') --13
SELECT DB_ID('dclubar_cu_live') --19