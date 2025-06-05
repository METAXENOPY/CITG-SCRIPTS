USE TEST_dclubv3_cu_live
GO


SELECT * FROM mgr.xtrf_status --NULL
GO

SELECT * FROM mgr.users_menu_language --NULL
GO

--SELECT COUNT(*) FROM mgr.users_menu
SELECT * FROM mgr.users_menu --Has Values
WHERE USER_GROUP = 'MGR' AND APPLICATION = 'transutil' -- 'dclubar' | 'transutil'
GO

SELECT * FROM mgr.tx_witholding --NULL
GO

--SELECT COUNT(*) FROM mgr.tx_ledger
SELECT * FROM mgr.tx_ledger --Has Values
WHERE tax_scheme = 'NA' -- 'VAT1' | 'NA'
GO

SELECT * FROM mgr.SM_PROSPECT --NULL
GO

SELECT * FROM mgr.SM_INCOME --NULL
GO

SELECT * FROM mgr.SM_APPLICANT --NULL
GO

--SELECT COUNT(*) FROM mgr.security_users
SELECT * FROM mgr.security_users --Has Values
WHERE application ='dclub' AND status = 'N' AND active ='N'
GO

UPDATE mgr.security_users
SET entity_cd = 'CU', project_no = ''
WHERE name = 'GEMELYN.T' AND application ='dclub' AND status = 'N' AND active ='N'
GO

--SELECT COUNT(*) FROM mgr.security_template
SELECT * FROM mgr.security_template --Has Values
GO

SELECT * FROM mgr.security_info --NULL
GO

--SELECT COUNT(*) FROM mgr.security_groupings
SELECT * FROM mgr.security_groupings --Has Values
WHERE application = 'dclubar' -- 'dclub' ' | 'dclubar'
ORDER BY group_name ASC
GO

--SELECT COUNT(*) FROM mgr.security_apps
SELECT * FROM mgr.security_apps --Has Values
GO

SELECT * FROM mgr.pm_activity_cd --NULL
GO

SELECT * FROM mgr.pl_project --NULL
GO

SELECT * FROM mgr.pl_costcode --NULL
GO

SELECT * FROM mgr.object_library_language --NULL
GO

SELECT * FROM mgr.object_library --Has Values
WHERE program_category = 'AD'
-- 'AD' | 'AR' | 'ART' | 'CE' | 'CS' | 'CWRC' | 'DA' | 'DEP' | 'GGM' | 'GHN'
-- 'GI' | 'GMF' | 'GMM' | 'GTM' | 'LCP' | 'LOC' | 'MM' | 'MS' | 'OUT' | 'QC' | 'SA' 
ORDER BY program_category ASC
GO

SELECT * FROM mgr.Next_Number --Has Values (Incremental)
GO

SELECT * FROM mgr.module_language --NULL
GO

SELECT * FROM mgr.MODULE --Has Values (Might have a connection to table mgr.object_library)
GO