USE TEST_dclubv3_cu_live

SELECT * FROM mgr.ar_debtor_rfid WHERE rfid_no = '0001234892'
UPDATE mgr.ar_debtor_rfid
SET rfid_no = '0001429734'
WHERE debtor_acct = '71282'

SELECT * FROM mgr.ar_debtor WHERE debtor_acct = '03690'
SELECT * FROM mgr.ar_debtor WHERE debtor_acct = '71282'

SELECT * FROM mgr.cf_business WHERE SEQ_NO = '8624'
SELECT * FROM mgr.cf_business WHERE SEQ_NO = '10969'

SELECT * FROM mgr.ar_debtor_consumable WHERE debtor_acct = '03690'
SELECT * FROM mgr.ar_debtor_consumable WHERE debtor_acct = '71282'

SELECT * FROM mgr.ar_debtor_coupons WHERE debtor_acct = '03690'
SELECT * FROM mgr.ar_debtor_coupons WHERE debtor_acct = '71282'
UPDATE mgr.ar_debtor_coupons
SET rfid_no = '0001429734'
WHERE debtor_acct = '71282'


SELECT * FROM mgr.ar_debtor_coupons WHERE debtor_acct = '03690' AND availed = 'Y'SELECT * FROM mgr.ar_debtor_coupons WHERE debtor_acct = '71282' AND availed = 'Y'SELECT * FROM mgr.cp_reservation WHERE debtor_acct = '03690' --AUDITDATE: 2022-11-14 10:33:29.020 --ARRIVALDATE: 2022-12-11 00:00:00.000SELECT * FROM mgr.cp_reservation WHERE debtor_acct = '71282' --2022-05-10 15:04:01.230 --2022-06-07 00:00:00.000UPDATE mgr.cp_reservationSET rfid_no = '0001234892'WHERE reservation_name = 'Ong, Edwin P.'SELECT * FROM mgr.cp_reservation_coupon WHERE debtor_acct = '03690'SELECT * FROM mgr.cp_reservation_coupon WHERE debtor_acct = '71282'