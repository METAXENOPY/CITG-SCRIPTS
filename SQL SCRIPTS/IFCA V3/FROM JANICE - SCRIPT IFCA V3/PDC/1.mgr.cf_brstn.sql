
/****** Object:  Table [mgr].[cf_brstn]    Script Date: 10/21/2021 13:37:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [mgr].[cf_brstn](
	[brstn_cd] [varchar](20) NOT NULL,
	[descs] [varchar](255) NOT NULL,
	[audit_user] [varchar](10) NOT NULL,
	[audit_date] [datetime] NOT NULL,
	[column1] [varchar](60) NULL,
	[column2] [varchar](60) NULL,
	[column3] [varchar](60) NULL,
	[column4] [varchar](60) NULL,
	[column5] [varchar](60) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


/****** Object:  Index [cf_dept_x]    Script Date: 10/21/2021 13:44:35 ******/
CREATE UNIQUE NONCLUSTERED INDEX [cf_brstn_x] ON [mgr].[cf_brstn] 
(
	[brstn_cd] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

