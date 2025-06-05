-- Remarks for Cancelled Consumables
(SELECT CASE A.[cancel_reason] WHEN 'CANC' THEN 'Cancel/ Incorrect coupon entry' WHEN 'ERR' THEN 'Error' ELSE '' END FROM [mgr].[ar_debtor_consumable_cancel] A, mgr.ar_debtor B, mgr.cf_reason C WHERE ( A.debtor_acct = B.debtor_acct ) AND ( A.cancel_reason = C.reason_cd ) AND (A.cconsumable_no = mgr.ar_debtor_consumable_cancel.cconsumable_no))

-- Remarks for Cancelled Bed Coupons
(SELECT CASE A.[cancel_reason] WHEN 'CANC' THEN 'Cancel/ Incorrect coupon entry' WHEN 'ERR' THEN 'Error' ELSE '' END FROM [mgr].[ar_debtor_coupons_cancel] A, mgr.ar_debtor B, mgr.cf_reason C, mgr.cp_gen_coupon D WHERE ( A.debtor_acct = B.debtor_acct ) AND ( A.cancel_reason = C.reason_cd ) AND (D.trx_doc = A.trx_doc) AND (A.coupon_no = mgr.ar_debtor_coupons_cancel.coupon_no))