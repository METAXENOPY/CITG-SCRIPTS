--USE [dclub_coupon]
--GO

/****** Object:  Table [mgr].[ma_billsch_restructure]    Script Date: 09/28/2021 09:15:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[mgr].[ma_billsch_restructure]') AND type in (N'U'))
DROP TABLE [mgr].[ma_billsch_restructure]
GO

--USE [dclub_coupon]
--GO

/****** Object:  Table [mgr].[ma_billsch_restructure]    Script Date: 09/28/2021 09:15:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [mgr].[ma_billsch_restructure](
	[mship_id] [varchar](20) NOT NULL,
	[pay_sch] [varchar](4) NOT NULL,
	[stg_no] [numeric](12, 0) NOT NULL,
	[trx_cd] [varchar](4) NOT NULL,
	[financier_cd] [varchar](4) NULL,
	[bill_date] [datetime] NOT NULL,
	[bill_amt] [numeric](21, 2) NULL,
	[post_date] [datetime] NULL,
	[print_count] [numeric](12, 0) NULL,
	[descs] [varchar](255) NULL,
	[scheme_cd] [varchar](4) NOT NULL,
	[currency_cd] [varchar](4) NOT NULL,
	[audit_date] [datetime] NOT NULL,
	[audit_user] [varchar](10) NOT NULL,
	[status] [char](1) NULL,
	[or_doc] [varchar](10) NULL,
	[or_amt] [numeric](21, 2) NULL,
	[restructure_type] [char](1) NULL,
	[restructure_level] [numeric](12, 0) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


