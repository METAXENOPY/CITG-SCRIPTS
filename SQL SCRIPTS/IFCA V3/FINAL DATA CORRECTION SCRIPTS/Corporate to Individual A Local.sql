use dclubv3_cu_live
go

declare @debtor_acct varchar(8) = '64481'	-- ENTER DEBTOR ACCT
declare @category_cd varchar(2) = 'A'		-- ENTER NEW INDIVIDUAL CATEGORY
declare @surname varchar(30)	= 'LIM'	-- ENTER SURNAME OF MEMBER
declare @seq_no numeric(12,0)
declare @name varchar(60)
select @seq_no = seq_no, @name = name from mgr.ar_debtor
where debtor_acct = @debtor_acct


--SELECT * FROM mgr.ar_debtor WHERE debtor_acct = @debtor_acct
--SELECT * FROM mgr.cf_business WHERE SEQ_NO = @seq_no
--SELECT * FROM mgr.MA_MEMBER WHERE DEBTOR_ACCT = @debtor_acct
--SELECT * FROM mgr.MA_MSHIP WHERE DEBTOR_ACCT = @debtor_acct
--SELECT * FROM mgr.interface_member WHERE v_member_id = @debtor_acct


update mgr.ar_debtor
set class = 'I' ,
column1 = @surname
where debtor_acct = @debtor_acct

update mgr.cf_business
set category = 'I'  ,
column1 = @surname
where SEQ_NO = @seq_no

update mgr.MA_MSHIP
set MSHIP_TYPE = 'I',
CATEGORY_CD = @category_cd,
NO_OF_NOMINEE = null,
NOM_EXPDT = null,
ELECTION_DATE = null,
COLUMN1 = @surname
where DEBTOR_ACCT = @debtor_acct

INSERT INTO mgr.MA_MEMBER
([MEMBER_ID],[DEBTOR_ACCT],[MSHIP_ID],[SEQ_NO],[MEM_TYPE],[JOIN_DATE],[EXPIRY_DATE],[NAME_ON_CARD],[CARD_ISSUE_DATE],
[CARD_EXPIRY_DATE],[CREDIT_LIMIT],[REMARKS],[STATUS_CD],[COLUMN1],[COLUMN2],[COLUMN3],[COLUMN4],[COLUMN5],[AUDIT_USER],
[AUDIT_DATE],[CREDIT_FLAG],[PROPOSAL],[SECONDER],[CREDIT_CARDNO],[venue_code],[guaranteed_chk],[xempt_cons],
[reservation_no])
SELECT DEBTOR_ACCT,DEBTOR_ACCT, MSHIP_ID,SEQ_NO, 'I', JOIN_DATE,NULL,@name,NULL,NULL,0.00,NULL,'A',@surname,NULL,
'Y',NULL,NULL,'mgr',GETDATE(),'I',NULL,NULL,NULL,NULL,'N','N',NULL
from mgr.ma_mship where DEBTOR_ACCT = @debtor_acct
