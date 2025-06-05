--66703 --090438
SELECT * FROM mgr.ar_debtor WHERE debtor_acct = '66703'
SELECT * FROM mgr.ar_debtor WHERE debtor_acct = '090438'

SELECT * FROM mgr.cf_business WHERE SEQ_NO = '8724'
SELECT * FROM mgr.cf_business WHERE SEQ_NO = '30654'

SELECT * FROM mgr.MA_member WHERE DEBTOR_ACCT = '66703'
SELECT * FROM mgr.MA_member WHERE DEBTOR_ACCT = '090438'

SELECT * FROM mgr.MA_MSHIP WHERE DEBTOR_ACCT = '66703'
SELECT * FROM mgr.MA_MSHIP WHERE DEBTOR_ACCT = '090438'

SELECT * FROM mgr.ar_debtor_rfid WHERE debtor_acct = '66703'
SELECT * FROM mgr.ar_debtor_rfid WHERE debtor_acct = '090438'

UPDATE mgr.ar_debtor_rfid
SET rfid_no = '0002061971'
WHERE debtor_acct = '090438'

UPDATE mgr.ar_debtor_rfid
SET rfid_no = '0001199315'
WHERE debtor_acct = '66703'

SELECT * FROM mgr.ar_debtor_consumable WHERE debtor_acct = '66703'
SELECT * FROM mgr.ar_debtor_consumable WHERE debtor_acct = '090438'

SELECT * FROM mgr.ar_debtor_coupons WHERE debtor_acct = '66703'
SELECT * FROM mgr.ar_debtor_coupons WHERE debtor_acct = '090438'

UPDATE mgr.ar_debtor_coupons
SET rfid_no = '0002061971'
WHERE debtor_acct = '090438'

UPDATE mgr.ar_debtor_coupons
SET rfid_no = '0001199315'
WHERE debtor_acct = '66703'
GO
--019930 --67442
SELECT * FROM mgr.ar_debtor WHERE debtor_acct = '019930'
SELECT * FROM mgr.ar_debtor WHERE debtor_acct = '67442'

SELECT * FROM mgr.cf_business WHERE SEQ_NO = '29891'
SELECT * FROM mgr.cf_business WHERE SEQ_NO = '6887'

SELECT * FROM mgr.MA_member WHERE DEBTOR_ACCT = '019930'
SELECT * FROM mgr.MA_member WHERE DEBTOR_ACCT = '67442'

SELECT * FROM mgr.MA_MSHIP WHERE DEBTOR_ACCT = '019930'
SELECT * FROM mgr.MA_MSHIP WHERE DEBTOR_ACCT = '67442'

SELECT * FROM mgr.ar_debtor_rfid WHERE debtor_acct = '019930'
SELECT * FROM mgr.ar_debtor_rfid WHERE debtor_acct = '67442'

UPDATE mgr.ar_debtor_rfid
SET rfid_no = '0001189655'
WHERE debtor_acct = '019930'

UPDATE mgr.ar_debtor_rfid
SET rfid_no = '0001573853'
WHERE debtor_acct = '67442'

SELECT * FROM mgr.ar_debtor_consumable WHERE debtor_acct = '019930'
SELECT * FROM mgr.ar_debtor_consumable WHERE debtor_acct = '67442'

UPDATE mgr.ar_debtor_consumable
SET rfid_no = '0001573853'
WHERE debtor_acct = '67442'

SELECT * FROM mgr.ar_debtor_coupons WHERE debtor_acct = '019930'
SELECT * FROM mgr.ar_debtor_coupons WHERE debtor_acct = '67442'

UPDATE mgr.ar_debtor_coupons
SET rfid_no = '0001189655'
WHERE debtor_acct = '019930'

UPDATE mgr.ar_debtor_coupons
SET rfid_no = '0001573853'
WHERE debtor_acct = '67442'
GO
--64372 --72641
SELECT * FROM mgr.ar_debtor WHERE debtor_acct = '64372'
SELECT * FROM mgr.ar_debtor WHERE debtor_acct = '72641'

SELECT * FROM mgr.cf_business WHERE SEQ_NO = '7799'
SELECT * FROM mgr.cf_business WHERE SEQ_NO = '8491'

SELECT * FROM mgr.MA_member WHERE DEBTOR_ACCT = '64372'
SELECT * FROM mgr.MA_member WHERE DEBTOR_ACCT = '72641'

SELECT * FROM mgr.MA_MSHIP WHERE DEBTOR_ACCT = '64372'
SELECT * FROM mgr.MA_MSHIP WHERE DEBTOR_ACCT = '72641'

SELECT * FROM mgr.ar_debtor_rfid WHERE debtor_acct = '64372'
SELECT * FROM mgr.ar_debtor_rfid WHERE debtor_acct = '72641'

UPDATE mgr.ar_debtor_rfid
SET rfid_no = '0001150770'
WHERE debtor_acct = '64372'

UPDATE mgr.ar_debtor_rfid
SET rfid_no = '0007875849'
WHERE debtor_acct = '72641'

SELECT * FROM mgr.ar_debtor_consumable WHERE debtor_acct = '64372'
SELECT * FROM mgr.ar_debtor_consumable WHERE debtor_acct = '72641'

SELECT * FROM mgr.ar_debtor_coupons WHERE debtor_acct = '64372'
SELECT * FROM mgr.ar_debtor_coupons WHERE debtor_acct = '72641'

UPDATE mgr.ar_debtor_coupons
SET rfid_no = '0001150770'
WHERE debtor_acct = '64372'
GO

UPDATE mgr.ar_debtor_coupons
SET rfid_no = '0007875849'
WHERE debtor_acct = '72641'
GO


--FOR TP (CUVC)
SELECT * FROM mgr.ar_debtor WHERE debtor_acct = '15-49400'
SELECT * FROM mgr.cf_business WHERE SEQ_NO = '22793'
SELECT * FROM mgr.MA_member WHERE DEBTOR_ACCT = '15-49400'
SELECT * FROM mgr.MA_MSHIP WHERE DEBTOR_ACCT = '15-49400'
SELECT * FROM mgr.ar_debtor_rfid WHERE debtor_acct = '15-49400'

UPDATE mgr.ar_debtor_rfid
SET rfid_no = '0001137418 '
WHERE debtor_acct = '15-49400'

SELECT * FROM mgr.ar_debtor_consumable WHERE debtor_acct = '15-4940'
SELECT * FROM mgr.ar_debtor_coupons WHERE debtor_acct = '15-4940'