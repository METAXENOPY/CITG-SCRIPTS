SELECT * FROM mgr.cp_gen_coupon WHERE debtor_acct = '70931' -- Remarks is here
SELECT * FROM mgr.cp_gen_coupon WHERE debtor_acct = '70932' -- No data


SELECT * FROM mgr.ar_debtor_coupons WHERE debtor_acct = '70931' --Principal
SELECT * FROM mgr.ar_debtor_coupons WHERE debtor_acct = '70932' --Nominee

SELECT  mgr.v_cu_coupon_ledger.member_id ,
mgr.v_cu_coupon_ledger.member_name ,           mgr.v_cu_coupon_ledger.rfid ,
mgr.v_cu_coupon_ledger.class ,           mgr.v_cu_coupon_ledger.coupon_series ,
mgr.v_cu_coupon_ledger.coupon_category ,           mgr.v_cu_coupon_ledger.coupon_type ,
mgr.v_cu_coupon_ledger.coupon_status ,           mgr.v_cu_coupon_ledger.sbu_hotel ,
mgr.v_cu_coupon_ledger.outlet ,           mgr.v_cu_coupon_ledger.room_category ,
mgr.v_cu_coupon_ledger.tagging_date ,           mgr.v_cu_coupon_ledger.audit_user ,
mgr.v_cu_coupon_ledger.audit_date ,           mgr.v_cu_coupon_ledger.coupon_source ,
mgr.v_cu_coupon_ledger.issue_date ,           mgr.v_cu_coupon_ledger.remarks
FROM mgr.v_cu_coupon_ledger     WHERE (((mgr.v_cu_coupon_ledger.member_id = '70932')))