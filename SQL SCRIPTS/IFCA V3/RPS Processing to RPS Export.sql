USE dclubv3_cuvc_live

ALTER TABLE mgr.citg_ar_rps_forprocess
ALTER COLUMN description VARCHAR(30) NOT NULL

SELECT debtor_acctlnk, ccard_no, trans_date, trans_amt, description, DATALENGTH(description) AS LENGTH FROM mgr.citg_ar_rps_forprocess ORDER BY DATALENGTH(description) DESC

SELECT * FROM mgr.citg_ar_rps_forprocess WHERE debtor_acctlnk = '15-60250' AND ccard_no = '4889079110301910'
SELECT debtor_acctlnk, ccard_no, trans_date, trans_amt, description, DATALENGTH(description) AS LENGTH FROM mgr.citg_ar_rps_forprocess ORDER BY DATALENGTH(description) DESC


update mgr.citg_m_rpsparam
set billnum_lock_stat = 0,
billnum_lock_msg = '',
filenum_lock_stat = 0,
filenum_lock_msg = ''


UPDATE dbo.citg_ar_rps_forprocess
SET description = 'MEMDUES-JUN2018-MAY2019BAL'
WHERE trans_date = '2022-07-15 15:40:02.170' AND trans_amt = '4640.00' AND debtor_acctlnk = '15-30130'