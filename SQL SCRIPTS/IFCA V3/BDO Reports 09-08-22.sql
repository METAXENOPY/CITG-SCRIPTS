USE dclubv3_cu_live
GO


SELECT mgr.citg_ar_rps_clientfile.merchant_num,   
       mgr.citg_ar_rps_clientfile.card_num,   
       mgr.citg_ar_rps_clientfile.cardholder_name,   
       mgr.citg_ar_rps_clientfile.merchant_billnum,   
       mgr.citg_ar_rps_clientfile.transaction_date,   
       mgr.citg_ar_rps_clientfile.transaction_amt,   
       mgr.citg_ar_rps_clientfile.description,   
       mgr.citg_ar_rps_clientfile.filler,   
       mgr.citg_ar_rps_clientfile.processed_date,   
       mgr.citg_ar_rps_clientfile.processed_code,   	   
       mgr.citg_ar_rps_clientfile.area_code,   
       mgr.citg_ar_rps_clientfile.bill_code,   
       mgr.citg_ar_rps_clientfile.misc_code,   
       mgr.citg_ar_rps_clientfile.debitcredit_indicator,   
       mgr.citg_ar_rps_clientfile.rps_type,   
       mgr.citg_ar_rps_clientfile.issuer,   
       mgr.citg_ar_rps_clientfile.authorization_code,   
       mgr.citg_ar_rps_clientfile.expiry_date,   
       mgr.citg_ar_rps_clientfile.sequence_number,   
       mgr.citg_ar_rps_clientfile.cvc2_value,   
       mgr.citg_ar_rps_clientfile.filler2,   
       mgr.citg_ar_rps_clientfile.reason_code,   
       mgr.citg_ar_rps_clientfile.date_imported,   
       mgr.citg_ar_rps_clientfile.usr_login,   
       mgr.citg_ar_rps_clientfile.source_file,   
       mgr.citg_ar_rps_clientfile.import_batchnum,   
	    mgr.citg_ar_rps_clientfile.debtor_acctlnk,
	    ISNULL((SELECT mgr.ar_debtor.name FROM mgr.ar_debtor WHERE mgr.ar_debtor.debtor_acct = mgr.citg_ar_rps_clientfile.debtor_acctlnk),'') as name, 
	    mgr.citg_m_rpsproccode.process_desc,
	    mgr.citg_m_rpsproccode.listorder,
	    ISNULL((SELECT mgr.citg_ar_rps_forprocess.is_amex FROM mgr.citg_ar_rps_forprocess 
				   WHERE mgr.citg_ar_rps_forprocess.debtor_acctlnk = mgr.citg_ar_rps_clientfile.debtor_acctlnk AND 
            			mgr.citg_ar_rps_forprocess.merchant_num = mgr.citg_ar_rps_clientfile.merchant_num AND 
				         mgr.citg_ar_rps_forprocess.card_num = mgr.citg_ar_rps_clientfile.card_num AND 
             			mgr.citg_ar_rps_forprocess.merchant_billnum = mgr.citg_ar_rps_clientfile.merchant_billnum ),0) as is_amex,
	    ISNULL((SELECT mgr.citg_ar_rps_forprocess.cheque_no FROM mgr.citg_ar_rps_forprocess 
 				   WHERE mgr.citg_ar_rps_forprocess.debtor_acctlnk = mgr.citg_ar_rps_clientfile.debtor_acctlnk AND 
              		   mgr.citg_ar_rps_forprocess.merchant_num = mgr.citg_ar_rps_clientfile.merchant_num AND 
              			mgr.citg_ar_rps_forprocess.card_num = mgr.citg_ar_rps_clientfile.card_num AND 
             			mgr.citg_ar_rps_forprocess.merchant_billnum = mgr.citg_ar_rps_clientfile.merchant_billnum ),'') as cheque_no,
	    ISNULL((SELECT mgr.citg_ar_rps_forprocess.cheque_date FROM mgr.citg_ar_rps_forprocess 
				   WHERE mgr.citg_ar_rps_forprocess.debtor_acctlnk = mgr.citg_ar_rps_clientfile.debtor_acctlnk AND 
						   mgr.citg_ar_rps_forprocess.merchant_num = mgr.citg_ar_rps_clientfile.merchant_num AND 
						   mgr.citg_ar_rps_forprocess.card_num = mgr.citg_ar_rps_clientfile.card_num AND 
						   mgr.citg_ar_rps_forprocess.merchant_billnum = mgr.citg_ar_rps_clientfile.merchant_billnum), mgr.citg_ar_rps_clientfile.transaction_date) as cheque_date,
		 mgr.citg_m_rpsenrollee.debtor_loc,
	    ISNULL((SELECT (CASE WHEN mgr.citg_m_rpsenrollee.debtor_loc = 'C' THEN mgr.citg_m_rpsparam.bankcharge ELSE mgr.citg_m_rpsparam.bankcharge_mla END) FROM mgr.citg_m_rpsparam),0)  as bankcharge,
	    ISNULL((SELECT (CASE WHEN mgr.citg_m_rpsenrollee.debtor_loc = 'C' THEN mgr.citg_m_rpsparam.bankcharge_amex ELSE mgr.citg_m_rpsparam.bankcharge_amex_mla END) FROM mgr.citg_m_rpsparam),0) as bankcharge_amex,
		(SELECT mgr.citg_ar_post_dated_adaf.debtor_acct
			   FROM mgr.citg_ar_rps_forprocess, mgr.citg_ar_post_dated_adaf
               WHERE ( mgr.citg_ar_rps_clientfile.debtor_acctlnk = mgr.citg_ar_rps_forprocess.debtor_acctlnk ) and  
                     ( mgr.citg_ar_rps_clientfile.card_num = mgr.citg_ar_rps_forprocess.card_num ) and  
                     ( mgr.citg_ar_rps_clientfile.merchant_billnum = mgr.citg_ar_rps_forprocess.merchant_billnum ) and  
                     ( mgr.citg_ar_rps_forprocess.debtor_acctlnk = mgr.citg_ar_post_dated_adaf.debtor_acctlnk ) and  
                     ( mgr.citg_ar_rps_forprocess.ccard_no = mgr.citg_ar_post_dated_adaf.ccard_no ) and  
                     ( mgr.citg_ar_rps_forprocess.ccard_expiry = mgr.citg_ar_post_dated_adaf.ccard_expiry ) and  
                     ( mgr.citg_ar_rps_forprocess.trx_type = mgr.citg_ar_post_dated_adaf.trx_type ) and  
                     ( mgr.citg_ar_rps_forprocess.cheque_date = mgr.citg_ar_post_dated_adaf.cheque_date)) as debtor_acct
FROM mgr.citg_ar_rps_clientfile, mgr.citg_m_rpsproccode, mgr.citg_m_rpsenrollee
WHERE mgr.citg_ar_rps_clientfile.processed_code = mgr.citg_m_rpsproccode.process_code AND mgr.citg_ar_rps_clientfile.debtor_acctlnk = mgr.citg_m_rpsenrollee.debtor_acct 
GO

SELECT * FROM mgr.citg_ar_rps_clientfile WHERE debtor_acctlnk = '65321' --Y
SELECT * FROM mgr.citg_ar_rps_clientfile WHERE debtor_acctlnk = '65163' --Y

SELECT * FROM [mgr].[v_rps_processed_bdo] WHERE debtor_acct = '65321' --N
SELECT * FROM [mgr].[v_rps_processed_bdo] WHERE debtor_acct = '65163' --N

SELECT * FROM mgr.citg_ar_rps_forprocess WHERE debtor_acctlnk = '65321' --Y
SELECT * FROM mgr.citg_ar_rps_forprocess WHERE debtor_acctlnk = '65163' --Y

SELECT * FROM mgr.citg_ar_post_dated_adaf WHERE debtor_acctlnk = '65321' AND cheque_date = '2022-08-17 00:00:00.000' --Y
SELECT * FROM mgr.citg_ar_post_dated_adaf WHERE debtor_acctlnk = '65163' AND cheque_date = '2022-08-30 00:00:00.000' --Y

SELECT * FROM mgr.citg_ar_post_dated_adaf WHERE cheque_no = '5230-8100-6977-9273 MC'
DELETE mgr.citg_ar_post_dated_adaf WHERE cheque_no = '5230-8100-6977-9273 MC'

--DELETED 09-08-22
--65321               	5230810069779273	NULL	2024-10-31 00:00:00.000	CU	NULL	NULL	ADA	5230-8100-6977-9273 MC        	2022-08-17 00:00:00.000	2022-09-08 10:02:14.000	MEM  DUES - JUN2019 - NOV2019	NULL	9960.00	NULL	CREDIT CRD COL	NULL	PHP	1.0000000000	0.00	jessica.b	2022-09-08 10:09:20.857	0	NULL	N	A	N	jessica.b 	2022-09-08 10:09:20.857	NULL	NULL	DUES      	0	NULL	NULL	NULL	NULL

--65163
--65321

