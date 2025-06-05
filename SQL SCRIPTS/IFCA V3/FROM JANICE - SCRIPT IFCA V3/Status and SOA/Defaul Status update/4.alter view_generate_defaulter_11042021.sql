/****** Object:  View [mgr].[View_generate_defaulter]    Script Date: 10/28/2021 09:30:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER View [mgr].[View_generate_defaulter]
As

SELECT	debtor_acct = mgr.AR_DEBTOR.DEBTOR_ACCT,   
		debtor_name = mgr.CF_BUSINESS.NAME,   
		category_cd	= mgr.MA_MSHIP.CATEGORY_CD,   
		status_cd	= mgr.MA_MSHIP.STATUS_CD,   
		mship_id    = mgr.MA_MSHIP.MSHIP_ID,
		class		= mgr.AR_DEBTOR.class
FROM	mgr.AR_DEBTOR,   
		mgr.CF_BUSINESS,   
		mgr.MA_MSHIP
WHERE	( mgr.AR_DEBTOR.SEQ_NO = mgr.CF_BUSINESS.SEQ_NO ) 
and		( mgr.AR_DEBTOR.DEBTOR_ACCT = mgr.MA_MSHIP.DEBTOR_ACCT ) 
and		( mgr.AR_DEBTOR.status = 'A' )    
and		( mgr.AR_DEBTOR.DEBTOR_ACCT NOT IN (select member_id FROM mgr.MA_STATSCHE_DEFAULTER WHERE status = 'P') 
and     mgr.AR_DEBTOR.DEBTOR_ACCT NOT IN (select member_id FROM mgr.MA_STATSCHE WHERE status = 'P'))
 --MDUES (3 months)
AND	    ( mgr.AR_DEBTOR.DEBTOR_ACCT in (	SELECT mgr.ar_ledger.debtor_acct FROM mgr.ar_ledger
											WHERE mgr.ar_ledger.trx_type = 'MDPC' AND mgr.ar_ledger.mbal_amt > 0
											AND mgr.ar_ledger.doc_no NOT IN (select mgr.ar_temp_alloc.doc_no 
											from mgr.ar_temp_alloc 
											where mgr.ar_temp_alloc.entity_cd = mgr.ar_ledger.entity_cd 
											and mgr.ar_temp_alloc.debtor_acct = mgr.ar_ledger.debtor_acct  )
											GROUP BY mgr.ar_ledger.debtor_acct
											HAVING DATEDIFF(MONTH,MIN(mgr.ar_ledger.doc_date),GETDATE()) >= 3 
											AND COUNT(mgr.ar_ledger.debtor_acct) >= 3 )	OR
		  mgr.AR_DEBTOR.DEBTOR_ACCT in (	SELECT debtor_acct FROM mgr.ar_ledger
											WHERE (YEAR(doc_date)* 100 + MONTH(doc_date)) <= (YEAR(GETDATE())* 100 + MONTH(GETDATE()))
											AND trx_mode = 'C' AND trx_type IN ('CMFC','CMFD','CMFM','CMFQ','CMFR')
											GROUP BY debtor_acct
											HAVING DATEDIFF(MONTH,MAX(doc_date),GETDATE()) > 1)OR
-- MFEE (1 MONTH)
		  mgr.AR_DEBTOR.DEBTOR_ACCT in  (	SELECT d.debtor_acct --b.*
											FROM mgr.ma_billsch_restructure  b, mgr.ma_mship c, mgr.ar_debtor d
											WHERE b.mship_id = c.MSHIP_ID
											AND c.DEBTOR_ACCT = d.debtor_acct
											AND b.restructure_type = 'F' 
											AND b.restructure_level = (	SELECT isnull(MAX(a.restructure_level),0) 
																		FROM mgr.ma_billsch_restructure a	
																		WHERE b.mship_id = a.MSHIP_ID 
																		AND	a.restructure_type = 'F')
											--AND	d.debtor_acct = 'DEF-0003'						 
											AND DATEDIFF(MONTH,b.bill_date,GETDATE()) = 1 --rsgerman10292021
											AND b.status = 'P'))
-- CHECK IF NOT RESTRUCTURED
AND 	mgr.AR_DEBTOR.DEBTOR_ACCT NOT IN (	SELECT	d.debtor_acct
											FROM	mgr.ma_billsch_restructure  b, mgr.ma_mship c, mgr.ar_debtor d
											WHERE	b.mship_id			= c.MSHIP_ID
											AND		c.DEBTOR_ACCT		= d.debtor_acct
											AND		b.restructure_type	= 'D' 
											AND		b.restructure_level = (	SELECT ISNULL(MAX(a.restructure_level),0) 
											FROM   mgr.ma_billsch_restructure a	
											WHERE  b.mship_id = a.MSHIP_ID AND a.restructure_type = 'D')
											and		b.status = 'P'	)
											
UNION ALL

SELECT	debtor_acct = mgr.AR_DEBTOR.DEBTOR_ACCT,   
		debtor_name = mgr.CF_BUSINESS.NAME,   
		category_cd	= mgr.MA_MSHIP.CATEGORY_CD,   
		status_cd	= mgr.MA_MSHIP.STATUS_CD,   
		mship_id    = mgr.MA_MSHIP.MSHIP_ID,
		class		= mgr.AR_DEBTOR.class
FROM	mgr.AR_DEBTOR,   
		mgr.CF_BUSINESS,   
		mgr.MA_MSHIP
WHERE	( mgr.AR_DEBTOR.SEQ_NO = mgr.CF_BUSINESS.SEQ_NO ) 
and		( mgr.AR_DEBTOR.DEBTOR_ACCT = mgr.MA_MSHIP.DEBTOR_ACCT ) 
and		( mgr.AR_DEBTOR.status = 'A' )    
and		( mgr.AR_DEBTOR.DEBTOR_ACCT NOT IN (select member_id FROM mgr.MA_STATSCHE_DEFAULTER WHERE status = 'P') 
and     mgr.AR_DEBTOR.DEBTOR_ACCT NOT IN (select member_id FROM mgr.MA_STATSCHE WHERE status = 'P'))
-- CHECK IF RESTRUCTURED
 AND 	mgr.AR_DEBTOR.DEBTOR_ACCT IN (	SELECT	d.debtor_acct
											FROM	mgr.ma_billsch_restructure  b, mgr.ma_mship c, mgr.ar_debtor d
											WHERE	b.mship_id			= c.MSHIP_ID
											AND		c.DEBTOR_ACCT		= d.debtor_acct
											AND		b.restructure_type	= 'D' 
											AND		b.restructure_level = (	SELECT ISNULL(MAX(a.restructure_level),0) 
											FROM   mgr.ma_billsch_restructure a	
											WHERE  b.mship_id = a.MSHIP_ID AND a.restructure_type = 'D')
											and		b.status = 'P'	)
 --MDUES (1 month) 
AND	   ( mgr.AR_DEBTOR.DEBTOR_ACCT IN (	SELECT	d.debtor_acct
										FROM	mgr.ma_billsch_restructure  b, mgr.ma_mship c, mgr.ar_debtor d
										WHERE	b.mship_id			= c.MSHIP_ID
										AND		c.DEBTOR_ACCT		= d.debtor_acct
										AND		b.restructure_type	= 'D' 
										AND		b.restructure_level = (	SELECT ISNULL(MAX(a.restructure_level),0) 
										FROM   mgr.ma_billsch_restructure a	
										WHERE  b.mship_id = a.MSHIP_ID AND a.restructure_type = 'D')
										and		b.status = 'P'	
										GROUP BY d.debtor_acct
										HAVING	DATEDIFF(MONTH,MIN(b.bill_date),GETDATE()) >= 1 
										AND		COUNT(d.debtor_acct) >= 1	)	 
																				
										OR
--MFEES (1 month) 										
				  mgr.AR_DEBTOR.DEBTOR_ACCT in  (	SELECT d.debtor_acct --b.*
											FROM mgr.ma_billsch_restructure  b, mgr.ma_mship c, mgr.ar_debtor d
											WHERE b.mship_id = c.MSHIP_ID
											AND c.DEBTOR_ACCT = d.debtor_acct
											AND b.restructure_type = 'F' 
											AND b.restructure_level = (	SELECT isnull(MAX(a.restructure_level),0) 
																		FROM mgr.ma_billsch_restructure a	
																		WHERE b.mship_id = a.MSHIP_ID 
																		AND	a.restructure_type = 'F')
											--AND	d.debtor_acct = 'DEF-0003'						 
											AND DATEDIFF(MONTH,b.bill_date,GETDATE()) = 1 --rsgerman10292021
											AND b.status = 'P'))																		
				
GO


