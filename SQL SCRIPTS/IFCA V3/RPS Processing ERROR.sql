USE dclubv3_cu_live
-- 09230
-- 4233053301850129
-- MEM  DUES - JUNE2022 - MAY2023

SELECT mgr.citg_ar_post_dated_adaf.debtor_acctlnk,   
         mgr.citg_ar_post_dated_adaf.ccard_no,   
         mgr.citg_ar_post_dated_adaf.ccard_last3,   
         mgr.citg_ar_post_dated_adaf.cheque_amt,   
         mgr.citg_ar_post_dated_adaf.cheque_date,   
         mgr.citg_ar_post_dated_adaf.ccard_expiry,   
         mgr.citg_ar_post_dated_adaf.cheque_no,   
         mgr.citg_ar_post_dated_adaf.trx_type,   
         mgr.citg_ar_post_dated_adaf.rpstype,   
         mgr.citg_ar_post_dated_adaf.descs,   
         mgr.citg_m_ccardtype.is_amex,   
         '' as merchant_billnum,   
         mgr.citg_m_ccardtype.ccard_short,   
         mgr.citg_m_rpsenrollee.debtor_loc,   
         mgr.citg_m_rpsenrollee_ccard.ccard_name,   
         mgr.ar_debtor.name,   
         mgr.citg_ar_post_dated_adaf.usr_login,   
         'UNPROCESS' as rpsstat,   
         'PDC' as source,   
         'R' as cmode  
    FROM mgr.citg_ar_post_dated_adaf,   
         mgr.citg_m_rpsenrollee_ccard,   
         mgr.citg_m_ccardtype,   
         mgr.citg_m_rpsenrollee,   
         mgr.ar_debtor  
   WHERE ( mgr.citg_ar_post_dated_adaf.debtor_acctlnk = mgr.citg_m_rpsenrollee_ccard.debtor_acct ) and  
         ( mgr.citg_ar_post_dated_adaf.ccard_no = mgr.citg_m_rpsenrollee_ccard.ccard_no ) and  
         ( mgr.citg_ar_post_dated_adaf.ccard_expiry = mgr.citg_m_rpsenrollee_ccard.ccard_expiry ) and  
         ( mgr.citg_m_rpsenrollee_ccard.ccard_type = mgr.citg_m_ccardtype.ccard_type ) and  
         ( mgr.citg_m_rpsenrollee.debtor_acct = mgr.citg_ar_post_dated_adaf.debtor_acctlnk ) and  
         ( mgr.citg_ar_post_dated_adaf.debtor_acctlnk *= mgr.ar_debtor.debtor_acct ) and  
         ( ( mgr.citg_m_rpsenrollee_ccard.rec_status = 'A') ) AND  
         ( mgr.citg_m_rpsenrollee.rec_status = 'A') AND  
         ( (mgr.citg_ar_post_dated_adaf.rps_procflag = 0) OR  
         (mgr.citg_ar_post_dated_adaf.rps_procflag IS NULL) ) AND  
         ( 'A' = 'A' OR  
         mgr.citg_m_rpsenrollee.debtor_loc = 'A' ) AND  
         ( mgr.citg_m_ccardtype.is_amex = 0 ) AND  
         ( mgr.citg_ar_post_dated_adaf.rec_status = 'A' ) AND  
         ( (mgr.citg_ar_post_dated_adaf.cheque_date BETWEEN '07/04/2022 00:00:00.000' and '07/04/2022 23:59:59.000') OR  
         (( mgr.citg_ar_post_dated_adaf.cheque_date BETWEEN '11/01/2010 00:00:00.000' and '07/04/2022 00:00:00.000') AND  
         ('07/04/2022 00:00:00.000' > '11/01/2010 00:00:00.000')) )  

  UNION ALL

SELECT mgr.citg_ar_rps_forprocess.debtor_acctlnk,   
         mgr.citg_ar_rps_forprocess.ccard_no,   
         mgr.citg_ar_rps_forprocess.cvc2_value as ccard_last3,   
         mgr.citg_ar_rps_forprocess.trans_amt as cheque_amt,  
         mgr.citg_ar_rps_forprocess.cheque_date,  
         mgr.citg_ar_rps_forprocess.ccard_expiry,
         mgr.citg_ar_rps_forprocess.cheque_no,   
         mgr.citg_ar_rps_forprocess.trx_type,   
         mgr.citg_ar_rps_forprocess.rpstype,   
         mgr.citg_ar_rps_forprocess.description as descs,   
         mgr.citg_ar_rps_forprocess.is_amex,   
         mgr.citg_ar_rps_forprocess.merchant_billnum,   
         mgr.citg_m_ccardtype.ccard_short,   
         mgr.citg_m_rpsenrollee.debtor_loc,   
	    mgr.citg_m_rpsenrollee_ccard.ccard_name,
         mgr.ar_debtor.name as ifcaname,
         mgr.citg_ar_rps_forprocess.usr_login, 
         mgr.citg_m_rpsproccode.process_desc as rpsstat,
         'REP' as source,   
         'R' as cmode  
FROM mgr.citg_ar_rps_forprocess, 
           mgr.citg_m_rpsproccode,
	      mgr.citg_m_rpsenrollee_ccard,
           mgr.citg_m_ccardtype,   
           mgr.citg_m_rpsenrollee,
	      mgr.ar_debtor   
WHERE (mgr.citg_ar_rps_forprocess.processed_code = mgr.citg_m_rpsproccode.process_code) AND
		   (mgr.citg_ar_rps_forprocess.debtor_acctlnk = mgr.citg_m_rpsenrollee_ccard.debtor_acct  and mgr.citg_m_rpsenrollee_ccard.rec_status = 'A') AND
         	   (mgr.citg_ar_rps_forprocess.ccard_no = mgr.citg_m_rpsenrollee_ccard.ccard_no) and  
         	   (mgr.citg_ar_rps_forprocess.ccard_expiry = mgr.citg_m_rpsenrollee_ccard.ccard_expiry) and  
             (mgr.citg_m_rpsenrollee_ccard.ccard_type = mgr.citg_m_ccardtype.ccard_type) and  
             (mgr.citg_m_rpsenrollee.debtor_acct = mgr.citg_ar_rps_forprocess.debtor_acctlnk and mgr.citg_m_rpsenrollee.rec_status = 'A')  and
	        (mgr.citg_ar_rps_forprocess.debtor_acctlnk *= mgr.ar_debtor.debtor_acct) and
             (mgr.citg_m_rpsproccode.isforreproc = 1) and ((mgr.citg_ar_rps_forprocess.remarks IS NULL) OR (mgr.citg_ar_rps_forprocess.remarks <> 'REPROCESSED')) and
             ('A' = 'A' or mgr.citg_m_rpsenrollee.debtor_loc = 'A') and 
         	   (mgr.citg_ar_rps_forprocess.is_amex = 0) and
	        (mgr.citg_ar_rps_forprocess.trans_date >= '11/01/2010 00:00:00.000' ) and
		   ( mgr.citg_ar_rps_forprocess.rec_status = 'A')


GO

mgr.citg_ar_post_dated_adaf --Y
mgr.citg_ar_rps_forprocess, 
           mgr.citg_m_rpsproccode,
	      mgr.citg_m_rpsenrollee_ccard, --Y
           mgr.citg_m_ccardtype,   
           mgr.citg_m_rpsenrollee, -- Y
	      mgr.ar_debtor  

SELECT * FROM mgr.citg_ar_post_dated_adaf WHERE debtor_acct = '09230'

UPDATE mgr.citg_m_rpsenrollee_ccard
SET ccard_name = 'DELA PEÑA, LORFEL IAN'
WHERE debtor_acct = '09230' AND ccard_no = '4233053301850129'

UPDATE mgr.citg_ar_post_dated_adaf
SET descs = 'MEM DUES-JUNE2022-MAY2023'
WHERE cheque_date = '2022-07-04 00:00:00.000' AND debtor_acct = '09230'

update mgr.citg_m_rpsparam
set billnum_lock_stat = 0,
billnum_lock_msg = '',
filenum_lock_stat = 0,
filenum_lock_msg = ''
