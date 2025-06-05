--USE [Dclub_ritz]
--GO

--/****** Object:  Table [mgr].[ar_post_dated]    Script Date: 10/19/2021 14:03:19 ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

--SET ANSI_PADDING ON
--GO

--CREATE TABLE [mgr].[ar_post_dated](
--	[entity_cd] [varchar](4) NOT NULL,
--	[project_no] [varchar](20) NULL,
--	[debtor_acct] [varchar](20) NOT NULL,
--	[trx_type] [varchar](4) NOT NULL,
--	[cheque_no] [varchar](30) NOT NULL,
--	[cheque_date] [datetime] NOT NULL,
--	[trx_date] [datetime] NOT NULL,
--	[descs] [varchar](255) NULL,
--	[ref_no] [varchar](30) NULL,
--	[cheque_amt] [numeric](21, 2) NOT NULL,
--	[print_flag] [char](1) NULL,
--	[bank_cd] [varchar](20) NOT NULL,
--	[receive_no] [varchar](10) NULL,
--	[currency_cd] [varchar](4) NOT NULL,
--	[currency_rate] [numeric](21, 10) NOT NULL,
--	[comm_rate] [numeric](21, 2) NOT NULL,
--	[audit_user] [varchar](10) NOT NULL,
--	[audit_date] [datetime] NOT NULL
--) ON [PRIMARY]

--GO

--SET ANSI_PADDING OFF
--GO

Alter Table [mgr].[ar_post_dated]
ADD bank_acct_cd varchar(20) NULL,
	bank_branch varchar(60) NULL,
	pr_trx_type varchar(4) NULL,
	pr_no	varchar(10) NULL,
	pr_date		datetime NULL,
	pr_descs	varchar(255) NULL,
	alloc_flag	char(1) NULL,
	hold_date	datetime NULL,
	cancel_date datetime NULL,
	dishonor_date datetime NULL,
	pullout_date datetime NULL,
	deposit_date datetime NULL,
	submit_date	datetime NULL,
	brstn varchar(20) NULL,
	paid_by varchar(255) NULL,
	venue varchar(4) NULL
	