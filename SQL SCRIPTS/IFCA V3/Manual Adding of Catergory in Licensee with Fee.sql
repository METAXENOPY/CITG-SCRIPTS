--Manual Adding of Catergory in Licensee with Fee
-- Data from V2 as it is missing in V3

--Prior to error must test!

use TEST_dclubv3_cu_live
go
--Inserting value for Membership Fee of 2K
--SELECT * FROM mgr.MAS_FEE_HD
INSERT INTO mgr.MAS_FEE_HD(SCH_CD,DESCS,CURRENCY_CD,FEE_AMT,AUDIT_USER,AUDIT_DATE)
VALUES ('MEM','Membership Dues','PHP','2000.00','mgr',GETDATE())

--Inserting value for Debtor Type
--SELECT * FROM mgr.ar_debtor_type
INSERT INTO mgr.ar_debtor_type (debtor_type,descs,debtor_ctl_acct,deposit_acct,advance_acct,audit_user,audit_date,accrual_acct,deferred_rev_acct)
VALUES ('VIS','VISITOR','116010','116010','116010','mgr',GETDATE(),'116010', NULL)

--Inserting the Category Visitor and Licensee
--SELECT * FROM mgr.MAS_CATEGORY
INSERT INTO mgr.MAS_CATEGORY ( CATEGORY_CD, DESCS, APPROVAL_STATUS, DEBTOR_TYPE, INDIVIDUAL_USE, CORPORATE_USE, LICENSEE_USE, AUDIT_DATE, AUDIT_USER, GOLFER_FLAG, MARINA_FLAG, CONV_RIGHT, VOTE_RIGHT, TRANS_RIGHT, UNION_USE, CREDIT_LIMIT, SCH_CD ) VALUES ( 'LIC', 'Licensee', 'A', 'MEM', 0, 0, 1, '3-16-2022 11:52:4.513', 'mgr', 0, 0, 1, 0, 1, 0, 0.0000, 'MEM' )
INSERT INTO mgr.MAS_CATEGORY ( CATEGORY_CD, DESCS, APPROVAL_STATUS, DEBTOR_TYPE, INDIVIDUAL_USE, CORPORATE_USE, LICENSEE_USE, AUDIT_DATE, AUDIT_USER, GOLFER_FLAG, MARINA_FLAG, CONV_RIGHT, VOTE_RIGHT, TRANS_RIGHT, UNION_USE, CREDIT_LIMIT, SCH_CD ) VALUES ( 'VIS', 'Visitor', 'A', 'VIS', 0, 0, 1, '3-16-2022 11:55:0.966', 'mgr', 0, 0, 1, 0, 0, 0, 0.0000, 'MEM' )
