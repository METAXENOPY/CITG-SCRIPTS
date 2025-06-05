-- VIEW ALL RESERVATION UNDER DEBTOR ACCT.
SELECT * FROM mgr.cp_reservation WHERE debtor_acct = '010280'

-- VIEW ALL RESERVED COUPONS UNDER DEBTOR ACCT. and RESERVATION NO. (ASK FOR RESERVATION NO.)
SELECT * FROM mgr.cp_reservation_dt WHERE debtor_acct = '010280' AND reservation_no = '1000010694'

-- VIEW ALL USED COUPONS UNDER RESERVATION NO. and DEBTOR ACCT.
SELECT * FROM mgr.cp_reservation_coupon WHERE debtor_acct = '010280' AND reservation_no = '1000010694'

-- VIEW ALL COUPONS IF AVAILED
SELECT * FROM mgr.ar_debtor_coupons WHERE debtor_acct = '010280' AND coupon_no IN ('1010114929','1010114930','1010114927','1010114928','1010114929','1010114930')
SELECT * FROM mgr.ar_debtor_consumable WHERE debtor_acct = '010280' AND cconsumable_no IN ('1000020601','1000020602','1000020603','1000020604','1000078675','1000020569')


--UPDATE mgr.ar_debtor_consumable
--SET availed = 'Y',
--availed_date = '2024-04-18 00:00:00.000'
--WHERE cconsumable_no = '1000023585'

--INSERT INTO mgr.cp_reservation_coupon
--VALUES ('1000006699', '70021', '70021', '1000023585', 'C', '500.00', GETDATE(), 'mgr', '2024-07-08 00:00:00.000')


--UPDATE UNAVAILED COUPON
--UPDATE mgr.ar_debtor_coupons
--SET availed = 'Y',
--availed_date = '2024-03-07 00:00:00.000'
--WHERE coupon_no = '1010120200' AND debtor_acct = '41840'

--DELETE IF RESERVATIONS NO. IS CONFIRMED
--DELETE FROM mgr.cp_reservation_coupon WHERE debtor_acct = '01590' AND reservation_no = '1000010574' AND coupon_no = '1000067875'

--DELETE RESERVATION_DT IF RESERVATIONS NO. IS CONFIRMED
--DELETE FROM mgr.cp_reservation_dt WHERE debtor_acct = '01590' AND reservation_no = '1000010574'