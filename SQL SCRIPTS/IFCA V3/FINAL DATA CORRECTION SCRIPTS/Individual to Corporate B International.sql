--- INDIVIDUAL TO CORPORATION B INTERNATIONAL ----

use TEST_dclubv3_cu_live
go

declare @ar_debtor varchar (8) = '78441' -- DEBTOR ACCOUNT NUMBER
DECLARE @DebtorName VARCHAR(15)
SELECT @DebtorName = contact_person FROM mgr.ar_debtor WHERE debtor_acct = @ar_debtor
DECLARE @seq_no NUMERIC(12,0)
SELECT @seq_no = seq_no FROM mgr.ar_debtor WHERE debtor_acct = @ar_debtor
DECLARE @election_date DATE
SELECT @election_date = ELECTION_DATE FROM mgr.MA_MSHIP WHERE DEBTOR_ACCT = @ar_debtor

select * from mgr.ar_debtor where DEBTOR_ACCT = @ar_debtor -- TABLE 1
SELECT * FROM mgr.cf_business WHERE SEQ_NO = @seq_no -- TABLE 2
select * from mgr.MA_MEMBER where DEBTOR_ACCT = @ar_debtor -- TABLE 3
select * from mgr.MA_MSHIP where DEBTOR_ACCT = @ar_debtor -- TABLE 4
select * from mgr.interface_member where v_member_id = @ar_debtor -- TABLE 5

update mgr.ar_debtor
set class = 'C',
column1 = NULL
where debtor_acct = @ar_debtor

update mgr.cf_business
set category = 'C' ,
SALUTATION = NULL,
column1 = NULL 
where SEQ_NO = @seq_no

update mgr.MA_MSHIP
set MSHIP_TYPE = 'C',
CATEGORY_CD = 'CBI',
NO_OF_NOMINEE = 1,
NOM_EXPDT = GETDATE(),
ELECTION_DATE = @election_date,
COLUMN1 = NULL
where DEBTOR_ACCT = @ar_debtor

delete from mgr.MA_MEMBER 
where DEBTOR_ACCT = @ar_debtor and MEMBER_ID = @ar_debtor and MSHIP_ID = @ar_debtor

INSERT INTO [mgr].[interface_member]
([v_debtor_acct],[v_member_id],[v_name],[v_record_type],[v_status],[v_action_flag]
,[v_action_description],[v_credit_balance],[v_no_of_card],[v_limit_flag]
,[v_principle_amt],[v_staff_limit],[v_period_year],[v_vip_flag],[v_seq_no]
,[audit_user],[audit_date],[credit_flag],[trigger_flag])
VALUES
(@ar_debtor,@ar_debtor,@DebtorName,'C','A','A','Active',0.00,0,'A',0.00,0.00,0
,'N',@seq_no,'AR',GETDATE(),'C',NULL)