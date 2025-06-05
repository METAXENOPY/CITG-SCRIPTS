USE dclubv3_cu_live
GO

  SELECT mgr.MA_MSHIP.MSHIP_ID,              mgr.MA_MSHIP.DEBTOR_ACCT,              mgr.MA_MSHIP.SEQ_NO,              mgr.MA_MSHIP.MSHIP_TYPE,              mgr.CF_BUSINESS.CATEGORY,              mgr.CF_BUSINESS.NAME,              mgr.MAS_STATUS.STATUS_COLOR,              mgr.MA_MSHIP.STATUS_CD,              mgr.MA_MSHIP.AUDIT_USER,              mgr.MA_MSHIP.AUDIT_DATE,              mgr.MA_MSHIP.CATEGORY_CD,              mgr.CF_BUSINESS.VIP_FLAG        
  FROM mgr.CF_BUSINESS,              mgr.MA_MSHIP,              mgr.MAS_STATUS       
  WHERE ( mgr.MA_MSHIP.SEQ_NO = mgr.CF_BUSINESS.SEQ_NO ) and             ( mgr.MAS_STATUS.STATUS_CD = mgr.MA_MSHIP.STATUS_CD )       and (((mgr.MA_MSHIP.MSHIP_ID = '60761')))
  GO
GO
  SELECT mgr.MA_MSHIP.MSHIP_ID,   
         mgr.MA_MSHIP.SCH_CD,   
         mgr.MA_MSHIP.MSHIP_TYPE,   
         mgr.MA_MSHIP.APPLICATION_NO,   
         mgr.MA_MSHIP.PROPOSAL,   
         mgr.MA_MSHIP.SECONDER,   
         mgr.MA_MSHIP.MEMBER_FEE,   
         mgr.MA_MSHIP.CREDIT_LIMIT,   
         mgr.MA_MSHIP.AGENT_CD,   
         mgr.MA_MSHIP.ELECTION_DATE,   
         mgr.MA_MSHIP.CERT_NO,   
         mgr.AR_DEBTOR.STATEMENT_TYPE,   
         mgr.AR_DEBTOR.SEND_OR,   
         mgr.AR_DEBTOR.SEND_REM,   
         mgr.AR_DEBTOR.CREDIT_TERMS,   
         mgr.MA_MSHIP.DEBTOR_ACCT,   
         mgr.MA_MSHIP.SEQ_NO,   
         mgr.MA_MSHIP.JOIN_DATE,   
         mgr.MA_MSHIP.EXPIRY_DATE,   
         mgr.MA_MSHIP.NO_OF_NOMINEE,   
         mgr.MA_MSHIP.NOM_EXPDT,   
         mgr.MA_MSHIP.REMARKS,   
         mgr.MA_MSHIP.STATUS_CD,   
         mgr.MA_MSHIP.COLUMN1,   
         mgr.MA_MSHIP.COLUMN2,   
         mgr.MA_MSHIP.AUDIT_DATE,   
         mgr.MA_MSHIP.AUDIT_USER,   
         mgr.MA_MSHIP.COLUMN5,   
         mgr.MA_MSHIP.COLUMN4,   
         mgr.MA_MSHIP.COLUMN3,   
         mgr.AR_DEBTOR.DEBTOR_ACCT,   
         mgr.AR_DEBTOR.SEQ_NO,   
         mgr.AR_DEBTOR.JOIN_DATE,   
         mgr.AR_DEBTOR.LAST_INT_DATE,   
         mgr.AR_DEBTOR.REMINDER,   
         mgr.AR_DEBTOR.REM_DATE1,   
         mgr.AR_DEBTOR.REM_DATE2,   
         mgr.AR_DEBTOR.REM_DATE3,   
         mgr.AR_DEBTOR.REM_DATE4,   
         mgr.AR_DEBTOR.LAST_PAY_DATE,   
         mgr.AR_DEBTOR.CURRENCY_CD,   
         mgr.AR_DEBTOR.CREDIT_LIMIT,   
         mgr.AR_DEBTOR.INVOICE_AMT,   
         mgr.AR_DEBTOR.INTEREST_AMT,   
         mgr.AR_DEBTOR.DR_NOTE_AMT,   
         mgr.AR_DEBTOR.CR_NOTE_AMT,   
         mgr.AR_DEBTOR.RECEIPT_AMT,   
         mgr.AR_DEBTOR.WITHOLDING_AMT,   
         mgr.AR_DEBTOR.FOREX_AMT,   
         mgr.AR_DEBTOR.BALANCE_AMT,   
         mgr.AR_DEBTOR.TAX_AMT,   
         mgr.AR_DEBTOR.DEPOSIT_AMT,   
         mgr.AR_DEBTOR.REMARKS,   
         mgr.AR_DEBTOR.STATUS, 
         mgr.AR_DEBTOR.INT_FLAG,  
         mgr.AR_DEBTOR.COLUMN1,   
         mgr.AR_DEBTOR.COLUMN2,   
         mgr.AR_DEBTOR.COLUMN3,   
         mgr.AR_DEBTOR.COLUMN4,   
         mgr.AR_DEBTOR.COLUMN5,   
         mgr.AR_DEBTOR.AUDIT_USER,   
         mgr.AR_DEBTOR.AUDIT_DATE,   
         mgr.MA_MSHIP.CATEGORY_CD,   
         mgr.cf_business.SEQ_NO,   
         mgr.cf_business.NAME,   
         mgr.cf_business.BUSINESS_ID,   
         mgr.cf_business.MIN_SPEND_CODE,   
         mgr.cf_business.CATEGORY,   
         mgr.cf_business.SALUTATION,   
         mgr.cf_business.ADDRESS1,   
         mgr.cf_business.ADDRESS2,   
         mgr.cf_business.ADDRESS3,   
         mgr.cf_business.POST_CD,   
         mgr.cf_business.TEL_NO,   
         mgr.cf_business.HAND_PHONE,   
         mgr.cf_business.FAX_NO,   
         mgr.cf_business.PAGER_CENTER,   
         mgr.cf_business.PAGER_NO,   
         mgr.cf_business.EMAIL_ADDR,   
         mgr.cf_business.SEX,   
         mgr.cf_business.RACE_CD,   
         mgr.cf_business.BIRTH_DATE,   
         mgr.cf_business.NATIONALITY_CD,   
         mgr.cf_business.MARITAL_STATUS,   
         mgr.cf_business.TAX_NO,   
         mgr.cf_business.PHOTO,   
         mgr.cf_business.SIGNATURE,   
         mgr.cf_business.MAIL_TYPE,   
         mgr.cf_business.MAIL_ADDR1,   
         mgr.cf_business.MAIL_ADDR2,   
         mgr.cf_business.MAIL_ADDR3,   
         mgr.cf_business.MAIL_POST_CD,   
         mgr.cf_business.CONTACT_PERSON,   
         mgr.cf_business.DESIGNATION,   
         mgr.cf_business.ANNUAL_INCOME,   
         mgr.cf_business.BUSINESS_TYPE,   
         mgr.cf_business.REMARK,   
         mgr.cf_business.COLUMN1,   
         mgr.cf_business.COLUMN2,   
         mgr.cf_business.COLUMN3,   
         mgr.cf_business.COLUMN4,   
         mgr.cf_business.COLUMN5,   
         mgr.cf_business.AUDIT_USER,   
         mgr.cf_business.AUDIT_DATE,   
         mgr.AR_DEBTOR.DEBTOR_TYPE,   
         mgr.AR_DEBTOR.ADVANCE_AMT,   
         mgr.AR_DEBTOR.SERVICE_CHARGE,   
         mgr.cf_business.VIP_FLAG,   
         mgr.cf_business.COMPANY_SEQ_NO,
			'proposer_name' = (SELECT 	mgr.cf_business.NAME  
										FROM 	mgr.cf_business,
												mgr.MA_MSHIP a
										WHERE a.seq_no = mgr.CF_BUSINESS.seq_no AND
												a.MSHIP_ID = mgr.MA_MSHIP.proposal),
			'seconder_name' = (SELECT 	mgr.cf_business.NAME  
										FROM 	mgr.cf_business,
												mgr.MA_MSHIP a
										WHERE a.seq_no = mgr.CF_BUSINESS.seq_no AND
												a.MSHIP_ID = mgr.MA_MSHIP.seconder),
			mgr.MA_MSHIP.FEE_START_DATE,
			billsch_chk = 0,
			mgr.mas_category.union_use,
			mgr.AR_DEBTOR.PPD_FLAG ,
			mgr.MA_MSHIP.venue_code 
    FROM mgr.cf_business,   
         mgr.MA_MSHIP,   
         mgr.AR_DEBTOR,
			mgr.mas_category  
   WHERE ( mgr.MA_MSHIP.SEQ_NO = mgr.cf_business.SEQ_NO ) and  
         ( mgr.MA_MSHIP.DEBTOR_ACCT = mgr.AR_DEBTOR.DEBTOR_ACCT ) and  
         ( mgr.MA_MSHIP.SEQ_NO = mgr.cf_business.seq_no ) AND  
         ( mgr.MA_MSHIP.MSHIP_ID = '60761' )    And
			( mgr.mas_category.category_cd = mgr.ma_mship.category_cd )
GO
  SELECT mgr.MA_MEMBER.MEMBER_ID,   
         mgr.MA_MEMBER.DEBTOR_ACCT,   
         mgr.MA_MEMBER.MSHIP_ID,   
         mgr.MA_MEMBER.SEQ_NO,   
         mgr.MA_MEMBER.MEM_TYPE,   
         mgr.MA_MEMBER.JOIN_DATE,   
         mgr.MA_MEMBER.EXPIRY_DATE,   
         mgr.MA_MEMBER.NAME_ON_CARD,   
         mgr.MA_MEMBER.CARD_ISSUE_DATE,   
         mgr.MA_MEMBER.CARD_EXPIRY_DATE,   
         mgr.MA_MEMBER.CREDIT_LIMIT,   
         mgr.MA_MEMBER.REMARKS,   
         mgr.MA_MEMBER.STATUS_CD,   
         mgr.MA_MEMBER.CREDIT_FLAG,
         mgr.MA_MEMBER.COLUMN1,   
         mgr.MA_MEMBER.COLUMN2,   
         mgr.MA_MEMBER.COLUMN3,   
         mgr.MA_MEMBER.COLUMN4,   
         mgr.MA_MEMBER.COLUMN5,   
			mgr.MA_MEMBER.PROPOSAL,
			mgr.MA_MEMBER.SECONDER,
         mgr.MA_MEMBER.AUDIT_USER,   
         mgr.MA_MEMBER.AUDIT_DATE,   
         mgr.cf_business.SEQ_NO,   
         mgr.cf_business.MIN_SPEND_CODE,   
         mgr.cf_business.CATEGORY,   
         mgr.cf_business.NAME,   
         mgr.cf_business.SALUTATION,   
         mgr.cf_business.EMAIL_ADDR,   
         mgr.cf_business.SEX,   
         mgr.cf_business.RACE_CD,   
         mgr.cf_business.BIRTH_DATE,   
         mgr.cf_business.NATIONALITY_CD,   
         mgr.cf_business.MARITAL_STATUS,   
         mgr.cf_business.TAX_NO,   
         mgr.cf_business.PHOTO,   
         mgr.cf_business.SIGNATURE,   
         mgr.cf_business.MAIL_TYPE,   
         mgr.cf_business.MAIL_ADDR1,   
         mgr.cf_business.MAIL_ADDR2,   
         mgr.cf_business.MAIL_ADDR3,   
         mgr.cf_business.MAIL_POST_CD,   
         mgr.cf_business.CONTACT_PERSON,   
         mgr.cf_business.DESIGNATION,   
         mgr.cf_business.ANNUAL_INCOME,   
         mgr.cf_business.BUSINESS_TYPE,   
         mgr.cf_business.REMARK,   
         mgr.AR_DEBTOR.DEBTOR_ACCT,   
         mgr.AR_DEBTOR.SEQ_NO,   
         mgr.AR_DEBTOR.JOIN_DATE,   
         mgr.AR_DEBTOR.STATEMENT_TYPE,   
         mgr.AR_DEBTOR.INT_FLAG,   
         mgr.AR_DEBTOR.LAST_INT_DATE,   
         mgr.AR_DEBTOR.SEND_OR,   
         mgr.AR_DEBTOR.REMINDER,   
         mgr.AR_DEBTOR.SEND_REM,   
         mgr.AR_DEBTOR.REM_DATE1,   
         mgr.AR_DEBTOR.REM_DATE2,   
         mgr.AR_DEBTOR.REM_DATE3,   
         mgr.AR_DEBTOR.REM_DATE4,   
         mgr.AR_DEBTOR.LAST_PAY_DATE,   
         mgr.AR_DEBTOR.DEBTOR_TYPE,   
         mgr.AR_DEBTOR.CURRENCY_CD,   
         mgr.AR_DEBTOR.CREDIT_TERMS,   
         mgr.AR_DEBTOR.CREDIT_LIMIT,   
         mgr.AR_DEBTOR.INVOICE_AMT,   
         mgr.AR_DEBTOR.INTEREST_AMT,   
         mgr.AR_DEBTOR.DR_NOTE_AMT,   
         mgr.AR_DEBTOR.CR_NOTE_AMT,   
         mgr.AR_DEBTOR.RECEIPT_AMT,   
         mgr.AR_DEBTOR.WITHOLDING_AMT,   
         mgr.AR_DEBTOR.FOREX_AMT,   
         mgr.AR_DEBTOR.BALANCE_AMT,   
         mgr.AR_DEBTOR.TAX_AMT,   
         mgr.AR_DEBTOR.DEPOSIT_AMT,   
         mgr.AR_DEBTOR.REMARKS,   
         mgr.AR_DEBTOR.STATUS,   
         mgr.cf_business.VIP_FLAG,   
         mgr.CF_NATIONALITY.DESCS,   
         mgr.CF_RACE.DESCS,   
         mgr.CF_BUSINESS_TYPE.descs,   
         mgr.cf_business.COMPANY_SEQ_NO,   
         B.NAME,   
         mgr.cf_business.BUSINESS_ID,   
         mgr.cf_business.ADDRESS1,   
         mgr.cf_business.ADDRESS2,   
         mgr.cf_business.ADDRESS3,   
         mgr.cf_business.POST_CD,   
         mgr.cf_business.TEL_NO,   
         mgr.cf_business.HAND_PHONE,   
         mgr.cf_business.FAX_NO,   
         mgr.cf_business.PAGER_CENTER,   
         mgr.cf_business.PAGER_NO,   
         mgr.MA_MSHIP.CATEGORY_CD,
			b.NAME,
			'proposer_name' = (SELECT 	mgr.cf_business.NAME  
										FROM 	mgr.cf_business,
												mgr.MA_MEMBER a
										WHERE a.seq_no = mgr.CF_BUSINESS.seq_no AND
												a.MEMBER_ID = mgr.MA_MEMBER.proposal),
			'seconder_name' = (SELECT 	mgr.cf_business.NAME  
										FROM 	mgr.cf_business,
												mgr.MA_MEMBER a
										WHERE a.seq_no = mgr.CF_BUSINESS.seq_no AND
												a.MEMBER_ID = mgr.MA_MEMBER.seconder),
         mgr.MA_MSHIP.FEE_START_DATE,
			mgr.AR_DEBTOR.PPD_FLAG  ,mgr.MA_MEMBER.VENUE_CODE   , mgr.ma_member.xempt_cons,mgr.ma_member.guaranteed_chk, reservation_no
    FROM  mgr.MA_MEMBER left outer join mgr.AR_DEBTOR on ( mgr.MA_MEMBER.DEBTOR_ACCT = mgr.AR_DEBTOR.DEBTOR_ACCT ) ,   
         mgr.cf_business left outer join mgr.CF_BUSINESS B on  ( mgr.cf_business.COMPANY_SEQ_NO = B.SEQ_No) left outer join   
         mgr.CF_NATIONALITY on  ( mgr.cf_business.NATIONALITY_CD = mgr.CF_NATIONALITY.NATIONALITY_CD ) left outer join   
         mgr.CF_RACE on  ( mgr.cf_business.RACE_CD = mgr.CF_RACE.RACE_CD ) left outer join   
         mgr.CF_BUSINESS_TYPE on( ( mgr.cf_business.BUSINESS_TYPE = mgr.CF_BUSINESS_TYPE.business_type ) and ( mgr.CF_BUSINESS_TYPE.TYPE = mgr.CF_BUSINESS.CATEGORY ) ),   
         mgr.MA_MSHIP  
   WHERE  ( mgr.MA_MEMBER.SEQ_NO = mgr.cf_business.SEQ_NO ) and  
         ( mgr.MA_MSHIP.MSHIP_ID = mgr.MA_MEMBER.MSHIP_ID ) and  
         ( mgr.MA_MEMBER.MEM_TYPE = 'N' ) AND  
         ( mgr.MA_MEMBER.MSHIP_ID = '60761' )
GO

--Cabañero, Jeanette B. (NOMINEE)
SELECT * FROM mgr.interface_member WHERE v_debtor_acct = '60761'
SELECT * FROM mgr.ar_debtor WHERE debtor_acct = '60761'
SELECT * FROM mgr.CF_BUSINESS WHERE SEQ_NO = '32504'
--Ponce, Marlim O. (PRINCIPAL)
SELECT * FROM mgr.interface_member WHERE v_debtor_acct = '60763'
SELECT * FROM mgr.ar_debtor WHERE debtor_acct = '60763'
SELECT * FROM mgr.CF_BUSINESS WHERE SEQ_NO = '36544'
--NOMINEES UNDER 60761
SELECT * FROM mgr.MA_MEMBER WHERE MSHIP_ID = '60763' AND MEM_TYPE = 'N'
--FOR PRINCIPAL
SELECT * FROM mgr.MA_MSHIP WHERE SEQ_NO = '32504'
GO

UPDATE mgr.interface_member
SET v_record_type = 'N'
--v_debtor_acct ='60761-X',
--v_member_id = '60761-X'
WHERE v_seq_no = '32504'
UPDATE mgr.interface_member
SET v_record_type = 'C'
WHERE v_seq_no = '36544'
GO
UPDATE mgr.ar_debtor
SET class = 'N'
WHERE seq_no = '32504'
UPDATE mgr.ar_debtor
SET class = 'C'
WHERE seq_no = '36544'
GO
UPDATE mgr.cf_business
SET CATEGORY = 'I'
WHERE SEQ_NO = '32504'
UPDATE mgr.cf_business
SET CATEGORY = 'C'
WHERE SEQ_NO = '36544'
GO
DELETE mgr.MA_MEMBER WHERE SEQ_NO = '36544'
UPDATE mgr.MA_MEMBER
SET MSHIP_ID = '60763'
WHERE SEQ_NO = '36542'
UPDATE mgr.MA_MEMBER
SET MSHIP_ID = '60763'
WHERE SEQ_NO = '36544'
GO
UPDATE mgr.MA_MSHIP
SET MSHIP_ID = '60763',
DEBTOR_ACCT = '60763'
WHERE SEQ_NO = '32504'
GO
UPDATE mgr.MA_MSHIP
SET SEQ_NO = '36544'
WHERE MSHIP_ID = '60763' AND DEBTOR_ACCT = '60763'
GO
UPDATE mgr.interface_member
SET v_debtor_acct ='60761-X',
v_member_id = '60761-X'
WHERE v_seq_no = '32504'
INSERT INTO [mgr].[MA_MEMBER]
([MEMBER_ID],[DEBTOR_ACCT],[MSHIP_ID],[SEQ_NO],[MEM_TYPE],[JOIN_DATE],[EXPIRY_DATE],[NAME_ON_CARD],[CARD_ISSUE_DATE],
[CARD_EXPIRY_DATE],[CREDIT_LIMIT],[REMARKS],[STATUS_CD],[COLUMN1],[COLUMN2],[COLUMN3],[COLUMN4],[COLUMN5],[AUDIT_USER],
[AUDIT_DATE],[CREDIT_FLAG],[PROPOSAL],[SECONDER],[CREDIT_CARDNO],[venue_code],[guaranteed_chk],[xempt_cons],
[reservation_no]) VALUES ('60761','60761', '60763','32504', 'N','2008-01-05 00:00:00.000',NULL,'Cabañero, Jeanette B. (NOMINEE)',NULL,NULL,0.00,NULL,'A','Cabañero',NULL,
'Y',NULL,NULL,'mgr','2022-05-23 00:00:00.000','C',NULL,NULL,NULL,NULL,'N','N',NULL
)