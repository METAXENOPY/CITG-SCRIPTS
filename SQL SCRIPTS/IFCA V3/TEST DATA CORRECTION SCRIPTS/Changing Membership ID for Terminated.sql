-- CHANGING MEMBER'S ID - TERMINATED

--DECLARE @debtor_acct VARCHAR(8) = '78441' -- DEBTOR ACCOUNT TO VIEW
--SELECT * from mgr.ar_debtor WHERE DEBTOR_ACCT = @debtor_acct
--SELECT * from mgr.MA_MSHIP WHERE DEBTOR_ACCT = @debtor_acct 
--SELECT * FROM mgr.MA_MEMBER WHERE DEBTOR_ACCT = @debtor_acct OR MEMBER_ID = @debtor_acct OR MSHIP_ID = @debtor_acct ORDER BY NAME_ON_CARD
--SELECT * FROM mgr.interface_member WHERE v_debtor_acct = @debtor_acct


use TEST_dclubv3_cu_live
go

declare @debtor_acct varchar(8) = 'XXX78441' --EXISTING DEBTOR ACCOUNT
declare @new_debtor_acct varchar(8) = 'XXX78441' --NEW DEBTOR ACCOUNT
declare @new_v_member_id varchar(8) = 'XXX78441' --NEW v MEMBER ID
declare @seq_no numeric(12,0)
select @seq_no = seq_no from mgr.ar_debtor where debtor_acct = @debtor_acct


update mgr.ar_debtor
SET debtor_acct = @new_debtor_acct
where seq_no = @seq_no

update mgr.MA_MSHIP
SET MSHIP_ID = @new_debtor_acct, debtor_acct = @new_debtor_acct
where seq_no = @seq_no

UPDATE mgr.MA_MEMBER
SET MEMBER_ID = @new_debtor_acct, DEBTOR_ACCT = @new_debtor_acct, MSHIP_ID = @new_debtor_acct
where SEQ_NO = @seq_no

update mgr.interface_member
SET v_member_id = @new_v_member_id
WHERE v_debtor_acct = @debtor_acct