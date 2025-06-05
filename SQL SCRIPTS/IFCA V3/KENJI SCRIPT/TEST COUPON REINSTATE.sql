SELECT * FROM mgr.ar_debtor A, mgr.ar_debtor_rfid B
WHERE A.debtor_acct = B.debtor_acct AND
B.debtor_acct = '03290' GO


SELECT * FROM
mgr.cp_reservation A,
mgr.cp_reservation_coupon B,
mgr.ar_debtor_coupons C
WHERE A.reservation_no = B.reservation_no AND
A.debtor_acct = B.debtor_acct AND
C.debtor_acct = B.debtor_acct AND
C.coupon_no = B.coupon_no
AND B.c_type = 'P' AND C.availed = 'Y' AND a.Status = 'POSTED'
AND C.debtor_acct = '03290' AND C.rfid_no = '0001549990'
GO
SELECT * FROM mgr.ar_debtor_coupons
WHERE debtor_acct = '03290'
GO
SELECT * FROM mgr.cp_reservation
WHERE debtor_acct = '03290' 
GO
SELECT * FROM mgr.cp_reservation_coupon
WHERE debtor_acct = '03290' 
GO



SELECT  *
FROM    mgr.ar_debtor_consumable INNER JOIN
		mgr.cp_pos_tagging ON mgr.ar_debtor_consumable.debtor_acct = mgr.cp_pos_tagging.debtor_acct AND 
		mgr.ar_debtor_consumable.cconsumable_no = mgr.cp_pos_tagging.coupon_no
WHERE     (mgr.ar_debtor_consumable.status = 'Y') AND (mgr.ar_debtor_consumable.availed = 'Y')
AND mgr.ar_debtor_consumable.debtor_acct = '03290' AND rfid_no = '0001549990'


SELECT * FROM mgr.ar_debtor_consumable
WHERE debtor_acct = '03290' AND rfid_no = '0001549990' AND availed = 'Y'
AND cconsumable_no NOT IN (1000018281,1000018282,1000018283,1000018284,1000018285,1000018286,1000018287,1000018288,1000018289,1000018290,1000018291,1000018292,1000018293)

SELECT * FROM mgr.cp_pos_tagging WHERE debtor_acct = '03290'

