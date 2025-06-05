USE DCLUBAR_CUVC_LIVE

SELECT * FROM dbo.citg_m_user WHERE user_idno LIKE '%DORRIE%'
SELECT * FROM dbo.citg_m_user WHERE user_idno LIKE '%MAUREEN%'
INSERT INTO dbo.citg_m_user
VALUES ('MAUREENM', 'Maureen', 'Maisog', '', 'S', 'N', 'CITG', GETDATE())
INSERT INTO dbo.citg_m_user
VALUES ('MAUREENM', 'Maureen', 'Maisog', '', 'A', 'N', 'CITG', GETDATE())


SELECT * FROM dbo.citg_m_user_grp WHERE user_idno LIKE '%GLEACY%'
SELECT * FROM dbo.citg_m_user_grp WHERE user_idno LIKE '%MAUREEN%'
INSERT INTO dbo.citg_m_user_grp
VALUES ('MAUREENM', '8', 'A', 'U', 'CITG', GETDATE())
INSERT INTO dbo.citg_m_user_grp
VALUES ('MAUREENM', '4', 'A', 'U', 'CITG', GETDATE())

SELECT * FROM mgr.cfs_user_entity WHERE userid LIKE '%GLEACY%'
SELECT * FROM mgr.cfs_user_entity WHERE userid LIKE '%MAUREEN%'
INSERT INTO mgr.cfs_user_entity
VALUES ('MAUREENM', 'CU', 'mgr', GETDATE())
INSERT INTO mgr.cfs_user_entity
VALUES ('MAUREENM', '18', 'mgr', GETDATE())

SELECT * FROM mgr.cfs_user_mstr WHERE userid LIKE '%GLEACY%'
SELECT * FROM mgr.cfs_user_mstr WHERE userid LIKE '%MAUREEN%'

SELECT * FROM mgr.co_con_entity