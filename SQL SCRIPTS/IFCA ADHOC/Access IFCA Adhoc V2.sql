USE dclubar_cuvc_live

--Compare two account's access 1. Do work 2. Doesn't

SELECT * FROM [dbo].[citg_m_user] WHERE user_idno = 'JOVELLEE'
SELECT * FROM [dbo].[citg_m_user] WHERE user_idno = 'TEODOROJS'

UPDATE [dbo].[citg_m_user]
SET updsts = 'U'
WHERE user_idno = 'TeodoroJS '

SELECT * FROM [dbo].[citg_m_user_grp] WHERE user_idno = 'JOVELLEE'
SELECT * FROM [dbo].[citg_m_user_grp] WHERE user_idno = 'TEODOROJS'

INSERT INTO [dbo].[citg_m_user_grp]
VALUES ('TeodoroJS', '8', 'A', 'N', 'CITG', getdate())
