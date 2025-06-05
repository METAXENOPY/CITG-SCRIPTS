SELECT * FROM mgr.citg_ar_post_dated_adaf WHERE debtor_acctlnk = '105660'
SELECT * FROM mgr.citg_m_rpsenrollee_ccard WHERE debtor_acct = '105660'

UPDATE mgr.citg_ar_post_dated_adaf
SET ccard_expiry = '2028-10-31 00:00:00.000'
WHERE debtor_acctlnk = '105660' AND ccard_no = '5363470061388828'

UPDATE mgr.citg_m_rpsenrollee_ccard
SET ccard_name = 'LIM, CHARMAINE MARA'
WHERE debtor_acct = '105660' AND ccard_no = '5210690256101489'





SELECT A.debtor_acct, A.ccard_no, A.cheque_date,
	   B.ccard_name, A.ccard_expiry, B.ccard_expiry
FROM mgr.citg_ar_post_dated_adaf	A,
	 mgr.citg_m_rpsenrollee_ccard	B
WHERE	A.debtor_acct = B.debtor_acct
		AND A.debtor_acct = '105660'
		AND A.ccard_expiry = B.ccard_expiry