USE dclubv3_cu_live
GO

--DECLARE @debtor_acct VARCHAR(8) = '69767'	-- ENTER DEBTOR ACCT
--DECLARE @seq_no NUMERIC(12,0)
--DECLARE @name VARCHAR(60)
--SELECT @seq_no = seq_no, @name = name FROM mgr.ar_debtor
--WHERE debtor_acct = @debtor_acct
--SELECT * FROM mgr.interface_member WHERE v_debtor_acct = @debtor_acct
--SELECT * FROM mgr.ar_debtor WHERE debtor_acct = @debtor_acct
--SELECT * FROM mgr.cf_business WHERE SEQ_NO = @seq_no
--SELECT * FROM [mgr].[MA_MEMBER] WHERE DEBTOR_ACCT = @debtor_acct
--GO

DECLARE @debtor_acct VARCHAR(8) = '67546'	-- ENTER DEBTOR ACCT
DECLARE @category_cd VARCHAR(2) = 'AI'		-- ENTER NEW INDIVIDUAL CATEGORY
DECLARE @surname VARCHAR(30)	= 'Parajes'	-- ENTER SURNAME OF MEMBER
DECLARE @seq_no NUMERIC(12,0)
DECLARE @name VARCHAR(60)
SELECT @seq_no = seq_no, @name = name FROM mgr.ar_debtor
WHERE debtor_acct = @debtor_acct
DECLARE @member_id VARCHAR(30)
SELECT @member_id = MEMBER_ID FROM mgr.MA_MEMBER WHERE MSHIP_ID = @debtor_acct

DELETE mgr.interface_member WHERE v_debtor_acct = @debtor_acct

UPDATE mgr.ar_debtor
SET class = 'I' ,
name = name + ' (Licensee)',
column1 = @surname
WHERE debtor_acct = @debtor_acct

UPDATE mgr.cf_business
SET category = 'I'  ,
NAME = NAME + ' (Licensee)',
column1 = @surname
WHERE SEQ_NO = @seq_no

INSERT INTO [mgr].[MA_MEMBER]
([MEMBER_ID],[DEBTOR_ACCT],[MSHIP_ID],[SEQ_NO],[MEM_TYPE],[JOIN_DATE],[EXPIRY_DATE],[NAME_ON_CARD],[CARD_ISSUE_DATE],
[CARD_EXPIRY_DATE],[CREDIT_LIMIT],[REMARKS],[STATUS_CD],[COLUMN1],[COLUMN2],[COLUMN3],[COLUMN4],[COLUMN5],[AUDIT_USER],
[AUDIT_DATE],[CREDIT_FLAG],[PROPOSAL],[SECONDER],[CREDIT_CARDNO],[venue_code],[guaranteed_chk],[xempt_cons],
[reservation_no])
SELECT DEBTOR_ACCT,DEBTOR_ACCT, MSHIP_ID,SEQ_NO, 'I', JOIN_DATE,NULL,@name + ' (Licensee)',NULL,NULL,0.00,NULL,'A',@surname,NULL,
'Y',NULL,NULL,'mgr',GETDATE(),'I',NULL,NULL,NULL,NULL,'N','N',NULL
from mgr.ma_mship where DEBTOR_ACCT = @debtor_acct

update mgr.MA_MSHIP
set MSHIP_TYPE = 'I',
CATEGORY_CD = @category_cd,
NO_OF_NOMINEE = null,
NOM_EXPDT = null,
ELECTION_DATE = null,
COLUMN1 = @surname
where DEBTOR_ACCT = @debtor_acct

--This will transfer its nominess
UPDATE mgr.MA_MEMBER
SET MEM_TYPE = 'D'
WHERE MEMBER_ID = @member_id