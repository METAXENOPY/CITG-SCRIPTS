/****** Object:  Table [mgr].[ar_hist_post_dated]    Script Date: 11/20/2021 19:44:59 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING OFF
GO

CREATE TABLE [mgr].[ar_hist_post_dated](
	[entity_cd] [varchar](4) NOT NULL,
	[project_no] [varchar](20) NOT NULL,
	[debtor_acct] [varchar](20) NOT NULL,
	[trx_type] [varchar](4) NOT NULL,
	[cheque_no] [varchar](30) NOT NULL,
	[cheque_date] [datetime] NOT NULL,
	[trx_date] [datetime] NOT NULL,
	[descs] [varchar](255) NOT NULL,
	[ref_no] [varchar](30) NULL,
	[cheque_amt] [numeric](21, 2) NOT NULL,
	[print_flag] [char](1) NULL,
	[bank_cd] [varchar](20) NOT NULL,
	[bank_acct_cd] [varchar](20) NOT NULL,
	[receive_no] [varchar](10) NULL,
	[currency_cd] [varchar](4) NOT NULL,
	[currency_rate] [numeric](9, 4) NOT NULL,
	[comm_rate] [numeric](21, 2) NOT NULL,
	[bank_branch] [char](60) NULL,
	[pr_trx_type] [varchar](4) NOT NULL,
	[pr_no] [char](10) NOT NULL,
	[deposit_date] [datetime] NULL,
	[submit_date] [datetime] NULL,
	[reason_cd] [varchar](4) NULL,
	[trx_no] [numeric](12, 0) NULL,
	[audit_user] [char](10) NOT NULL,
	[audit_date] [datetime] NOT NULL,
	[pr_date] [datetime] NULL,
	[hold_date] [datetime] NULL,
	[cancel_date] [datetime] NULL,
	[dishonor_date] [datetime] NULL,
	[pullout_date] [datetime] NULL
) ON [PRIMARY]
SET ANSI_PADDING ON
ALTER TABLE [mgr].[ar_hist_post_dated] ADD [alloc_flag] [char](1) NULL
ALTER TABLE [mgr].[ar_hist_post_dated] ADD [column1] [varchar](60) NULL
ALTER TABLE [mgr].[ar_hist_post_dated] ADD [column2] [varchar](60) NULL
ALTER TABLE [mgr].[ar_hist_post_dated] ADD [column3] [varchar](60) NULL
ALTER TABLE [mgr].[ar_hist_post_dated] ADD [column4] [varchar](60) NULL
ALTER TABLE [mgr].[ar_hist_post_dated] ADD [column5] [varchar](60) NULL
ALTER TABLE [mgr].[ar_hist_post_dated] ADD [remarks] [varchar](255) NULL
ALTER TABLE [mgr].[ar_hist_post_dated] ADD 	brstn varchar(20) NULL
ALTER TABLE [mgr].[ar_hist_post_dated] ADD 	paid_by varchar(255) NULL
ALTER TABLE [mgr].[ar_hist_post_dated] ADD 	venue varchar(4) NULL

GO

SET ANSI_PADDING OFF
GO


