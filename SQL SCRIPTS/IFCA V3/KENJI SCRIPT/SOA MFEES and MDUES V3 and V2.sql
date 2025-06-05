USE dclubcu080321
GO

--DECLARE @debtoracct VARCHAR(30) = '83880'
--DECLARE @seqno VARCHAR(30) = (SELECT seq_no FROM mgr.ar_debtor WHERE debtor_acct = @debtoracct)
--SELECT * FROM mgr.ar_stmnt_dt WHERE debtor_acct = @debtoracct -- ONLY 1 DATA FOR NOW
--SELECT * FROM mgr.ar_stmnt_hd WHERE debtor_acct = @debtoracct -- ONLY 1 DATA FOR NOW
--SELECT * FROM mgr.ar_debtor WHERE debtor_acct = @debtoracct -- 10406 DATAS
--SELECT * FROM mgr.CF_BUSINESS WHERE SEQ_NO = @seqno
--SELECT * FROM mgr.ar_circular -- NULL
GO

-- To View Data For SOA MFEES
DECLARE @debtoracct VARCHAR(30) = '83880'
SELECT mgr.ar_stmnt_hd.debtor_acct,mgr.ar_stmnt_dt.doc_date,mgr.ar_stmnt_dt.doc_no,mgr.ar_stmnt_hd.name, mgr.ar_stmnt_hd.mail_addr1,mgr.ar_stmnt_hd.mail_addr2,mgr.ar_stmnt_hd.mail_addr3,mgr.ar_stmnt_hd.mail_post_cd,mgr.ar_stmnt_hd.advance_amt,mgr.ar_stmnt_hd.deposit_amt,mgr.ar_stmnt_hd.age1_amt,mgr.ar_stmnt_hd.age2_amt,mgr.ar_stmnt_hd.age3_amt,mgr.ar_stmnt_hd.age4_amt,mgr.ar_stmnt_hd.age5_amt,mgr.ar_stmnt_hd.age6_amt,
mgr.ar_stmnt_hd.balance_bf,mgr.ar_stmnt_dt.ref_no,mgr.ar_stmnt_dt.descs,mgr.ar_stmnt_dt.doc_amt,mgr.ar_stmnt_dt.currency_cd,mgr.ar_stmnt_dt.fdoc_amt,
mgr.ar_stmnt_dt.trx_mode,mgr.ar_stmnt_hd.start_date,mgr.ar_stmnt_hd.end_date,mgr.ar_stmnt_dt.currency_rate,mgr.ar_circular.circular_descs,mgr.CF_BUSINESS.SALUTATION,
cc_new_trx = ISNULL((SELECT SUM(mgr.ar_stmnt_dt.doc_amt)   								
FROM mgr.ar_stmnt_dt  								
WHERE mgr.ar_stmnt_dt.doc_date >= mgr.ar_stmnt_hd.start_date AND mgr.ar_stmnt_dt.doc_date <= mgr.ar_stmnt_hd.end_date AND mgr.ar_stmnt_dt.class = 'I' AND mgr.ar_stmnt_dt.debtor_acct = mgr.ar_stmnt_hd.debtor_acct),0),
cc_pay_trx = ISNULL((SELECT SUM(mgr.ar_stmnt_dt.doc_amt)   								
FROM mgr.ar_stmnt_dt  								
WHERE mgr.ar_stmnt_dt.doc_date >= mgr.ar_stmnt_hd.start_date AND mgr.ar_stmnt_dt.doc_date <= mgr.ar_stmnt_hd.end_date AND mgr.ar_stmnt_dt.debtor_acct = mgr.ar_stmnt_hd.debtor_acct AND mgr.ar_stmnt_dt.class = 'M'),0),
cc_adj_trx = ISNULL((SELECT SUM(CASE mgr.ar_stmnt_dt.trx_mode
WHEN 'C' THEN mgr.ar_stmnt_dt.doc_amt * -1
WHEN 'D' THEN mgr.ar_stmnt_dt.doc_amt END )
FROM mgr.ar_stmnt_dt
WHERE mgr.ar_stmnt_dt.doc_date >= mgr.ar_stmnt_hd.start_date AND mgr.ar_stmnt_dt.doc_date <= mgr.ar_stmnt_hd.end_date AND mgr.ar_stmnt_dt.debtor_acct = mgr.ar_stmnt_hd.debtor_acct AND mgr.ar_stmnt_dt.class in ('C','D')),0),
mgr.ar_stmnt_hd.statement_no,mgr.CF_BUSINESS.tax_No,mgr.CF_BUSINESS.contact_person,mgr.CF_BUSINESS.tel_no,mgr.CF_BUSINESS.address1,mgr.CF_BUSINESS.address2,mgr.ar_stmnt_hd.mf_statement_date,	mgr.ar_stmnt_hd.mf_due_date,
mgr.ar_stmnt_hd.mf_monthly_amortization, mgr.ar_stmnt_hd.mf_amount_due,mgr.ar_stmnt_hd.mf_purchase_price,mgr.ar_stmnt_hd.mf_total_paid,mgr.ar_stmnt_hd.mf_balance,mgr.ar_stmnt_hd.mf_last_paydate,mgr.ar_stmnt_hd.mf_last_payamount,
mgr.ar_stmnt_hd.mf_covered_month, mgr.ar_stmnt_hd.mf_last_desc
FROM mgr.ar_stmnt_dt,mgr.ar_stmnt_hd,mgr.ar_debtor,mgr.ar_circular,mgr.CF_BUSINESS
WHERE (( mgr.ar_stmnt_hd.circular_code *= mgr.ar_circular.circular_code) AND ( mgr.ar_stmnt_hd.debtor_acct = mgr.ar_stmnt_dt.debtor_acct ) AND ( mgr.ar_stmnt_hd.debtor_acct = mgr.ar_debtor.debtor_acct ) AND
( mgr.ar_debtor.seq_no = mgr.CF_BUSINESS.SEQ_NO ) AND ( ( mgr.ar_stmnt_dt.class <> 'A' ) AND ( mgr.ar_stmnt_dt.class <> 'S' ) ) AND ( mgr.ar_stmnt_hd.statement_type = 'I' ) AND
( ( mgr.ar_stmnt_dt.doc_date >= mgr.ar_stmnt_hd.start_date ) AND ( mgr.ar_stmnt_dt.doc_date <= mgr.ar_stmnt_hd.end_date ) OR ( mgr.ar_stmnt_dt.doc_date is Null ) )  ) AND
(((mgr.ar_stmnt_hd.debtor_acct = @debtoracct)))
ORDER BY mgr.ar_stmnt_hd.debtor_acct ASC,mgr.ar_stmnt_dt.doc_date ASC,mgr.ar_stmnt_dt.descs ASC,mgr.ar_stmnt_dt.doc_no ASC
GO

--To View Data For SOA MDUES
DECLARE @debtoracct VARCHAR(30) = '83880'
SELECT mgr.ar_stmnt_hd.debtor_acct,mgr.ar_stmnt_dt.doc_date,mgr.ar_stmnt_dt.doc_no,mgr.ar_stmnt_hd.name,mgr.ar_stmnt_hd.mail_addr1,mgr.ar_stmnt_hd.mail_addr2,
mgr.ar_stmnt_hd.mail_addr3,mgr.ar_stmnt_hd.mail_post_cd,mgr.ar_stmnt_hd.advance_amt,mgr.ar_stmnt_hd.deposit_amt,mgr.ar_stmnt_hd.age1_amt,mgr.ar_stmnt_hd.age2_amt,
mgr.ar_stmnt_hd.age3_amt,mgr.ar_stmnt_hd.age4_amt,mgr.ar_stmnt_hd.age5_amt,mgr.ar_stmnt_hd.age6_amt,mgr.ar_stmnt_hd.balance_bf,mgr.ar_stmnt_dt.ref_no,
mgr.ar_stmnt_dt.descs,mgr.ar_stmnt_dt.doc_amt,mgr.ar_stmnt_dt.currency_cd,mgr.ar_stmnt_dt.fdoc_amt,mgr.ar_stmnt_dt.trx_mode,mgr.ar_stmnt_hd.start_date,
mgr.ar_stmnt_hd.end_date,mgr.ar_stmnt_dt.currency_rate,mgr.ar_circular.circular_descs,mgr.CF_BUSINESS.SALUTATION,
cc_new_trx = ISNULL((SELECT SUM(mgr.ar_stmnt_dt.doc_amt)   								
FROM mgr.ar_stmnt_dt  								
WHERE mgr.ar_stmnt_dt.doc_date >= mgr.ar_stmnt_hd.start_date AND mgr.ar_stmnt_dt.doc_date <= mgr.ar_stmnt_hd.end_date AND mgr.ar_stmnt_dt.class = 'I' AND mgr.ar_stmnt_dt.debtor_acct = mgr.ar_stmnt_hd.debtor_acct),0),
cc_pay_trx = ISNULL((SELECT SUM(mgr.ar_stmnt_dt.doc_amt)   								
FROM mgr.ar_stmnt_dt  								
WHERE mgr.ar_stmnt_dt.doc_date >= mgr.ar_stmnt_hd.start_date AND mgr.ar_stmnt_dt.doc_date <= mgr.ar_stmnt_hd.end_date AND mgr.ar_stmnt_dt.debtor_acct = mgr.ar_stmnt_hd.debtor_acct AND mgr.ar_stmnt_dt.class = 'M'),0),
cc_adj_trx = ISNULL((SELECT SUM(CASE mgr.ar_stmnt_dt.trx_mode WHEN 'C' THEN mgr.ar_stmnt_dt.doc_amt * -1
WHEN 'D' THEN mgr.ar_stmnt_dt.doc_amt END )
FROM mgr.ar_stmnt_dt
WHERE mgr.ar_stmnt_dt.doc_date >= mgr.ar_stmnt_hd.start_date AND mgr.ar_stmnt_dt.doc_date <= mgr.ar_stmnt_hd.end_date AND mgr.ar_stmnt_dt.debtor_acct = mgr.ar_stmnt_hd.debtor_acct AND
mgr.ar_stmnt_dt.class IN ('C','D')),0),mgr.ar_stmnt_hd.statement_no, mgr.CF_BUSINESS.tax_No, mgr.CF_BUSINESS.contact_person, mgr.CF_BUSINESS.tel_no, mgr.CF_BUSINESS.address1,
mgr.CF_BUSINESS.address2, mgr.ar_stmnt_hd.mf_statement_date, mgr.ar_stmnt_hd.mf_due_date, mgr.ar_stmnt_hd.md_current_dues, mgr.ar_stmnt_hd.md_amout_due, mgr.ar_stmnt_hd.md_last_paydate,
mgr.ar_stmnt_hd.md_last_payamount, mgr.ar_stmnt_hd.md_last_desc, mgr.ar_stmnt_hd.md_terms, mgr.ar_stmnt_hd.md_past_due, mgr.ar_stmnt_hd.md_no_months, mgr.ar_stmnt_hd.md_total_past_due
FROM mgr.ar_stmnt_dt, mgr.ar_stmnt_hd, mgr.ar_debtor, mgr.ar_circular, mgr.CF_BUSINESS
WHERE (( mgr.ar_stmnt_hd.circular_code *= mgr.ar_circular.circular_code) AND ( mgr.ar_stmnt_hd.debtor_acct = mgr.ar_stmnt_dt.debtor_acct ) AND
( mgr.ar_stmnt_hd.debtor_acct = mgr.ar_debtor.debtor_acct ) AND ( mgr.ar_debtor.seq_no = mgr.CF_BUSINESS.SEQ_NO ) AND ( ( mgr.ar_stmnt_dt.class <> 'A' ) AND
( mgr.ar_stmnt_dt.class <> 'S' ) ) AND ( mgr.ar_stmnt_hd.statement_type = 'I' ) AND ( ( mgr.ar_stmnt_dt.doc_date >= mgr.ar_stmnt_hd.start_date ) AND
( mgr.ar_stmnt_dt.doc_date <= mgr.ar_stmnt_hd.end_date ) OR ( mgr.ar_stmnt_dt.doc_date IS NULL ) )  ) AND (((mgr.ar_stmnt_hd.debtor_acct = @debtoracct)))
ORDER BY mgr.ar_stmnt_hd.debtor_acct ASC, mgr.ar_stmnt_dt.doc_date ASC, mgr.ar_stmnt_dt.descs ASC, mgr.ar_stmnt_dt.doc_no ASC
