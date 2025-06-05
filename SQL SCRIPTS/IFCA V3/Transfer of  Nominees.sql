use TEST_dclubv3_cu_live
go

--SELECT * FROM mgr.cf_business, mgr.MA_MSHIP, mgr.AR_DEBTOR, mgr.mas_category WHERE ( mgr.MA_MSHIP.SEQ_NO = mgr.cf_business.SEQ_NO ) and ( mgr.MA_MSHIP.DEBTOR_ACCT = mgr.AR_DEBTOR.DEBTOR_ACCT ) and ( mgr.MA_MSHIP.SEQ_NO = mgr.cf_business.seq_no ) AND ( mgr.MA_MSHIP.MSHIP_ID = '70151' ) AND ( mgr.mas_category.category_cd = mgr.ma_mship.category_cd )

--SELECT * FROM  mgr.MA_MEMBER left outer join mgr.AR_DEBTOR on ( mgr.MA_MEMBER.DEBTOR_ACCT = mgr.AR_DEBTOR.DEBTOR_ACCT ) ,   
--         mgr.cf_business left outer join mgr.CF_BUSINESS B on  ( mgr.cf_business.COMPANY_SEQ_NO = B.SEQ_No) left outer join   
--         mgr.CF_NATIONALITY on  ( mgr.cf_business.NATIONALITY_CD = mgr.CF_NATIONALITY.NATIONALITY_CD ) left outer join   
--         mgr.CF_RACE on  ( mgr.cf_business.RACE_CD = mgr.CF_RACE.RACE_CD ) left outer join   
--         mgr.CF_BUSINESS_TYPE on( ( mgr.cf_business.BUSINESS_TYPE = mgr.CF_BUSINESS_TYPE.business_type ) and ( mgr.CF_BUSINESS_TYPE.TYPE = mgr.CF_BUSINESS.CATEGORY ) ),   
--         mgr.MA_MSHIP  
--WHERE  ( mgr.MA_MEMBER.SEQ_NO = mgr.cf_business.SEQ_NO ) and  
--         ( mgr.MA_MSHIP.MSHIP_ID = mgr.MA_MEMBER.MSHIP_ID ) and  
--         ( mgr.MA_MEMBER.MEM_TYPE = 'N' ) AND  
--         ( mgr.MA_MEMBER.MSHIP_ID = '60411' ); 

DECLARE @FROM_MEMBERSHIP_ID VARCHAR(100) = '70151' -- From this debtor
DECLARE @TO_MEMBERSHIP_ID VARCHAR(100) = '60411' -- To this debtor

UPDATE mgr.MA_MEMBER
SET MSHIP_ID = @TO_MEMBERSHIP_ID
WHERE mgr.MA_MEMBER.MEM_TYPE = 'N'  AND  mgr.MA_MEMBER.MSHIP_ID = @FROM_MEMBERSHIP_ID