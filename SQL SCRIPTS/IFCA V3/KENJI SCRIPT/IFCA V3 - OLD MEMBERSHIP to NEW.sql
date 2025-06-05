USE dclubv3_cu_live

SELECT * FROM mgr.ar_debtor WHERE debtor_acct = '71291'

UPDATE mgr.ar_debtor
SET name = 'Zamora, Myra D.' --Daanoy, Evangeline R.
WHERE debtor_acct = '71291' AND seq_no = '7151'

SELECT * FROM mgr.ar_debtor_rfid WHERE debtor_acct = '71291'
SELECT * FROM mgr.cf_business WHERE  SEQ_NO = '7151'
SELECT * FROM mgr.MA_MEMBER WHERE DEBTOR_ACCT = '71291'
SELECT * FROM mgr.MA_MSHIP WHERE DEBTOR_ACCT = '71291'

