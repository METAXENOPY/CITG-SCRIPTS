
/****** Object:  StoredProcedure [mgr].[xar_gen_cheque]    Script Date: 11/16/2021 11:23:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [mgr].[xar_gen_cheque]
	@rt_entity_cd 		varchar (4),
	@rt_project_no		varchar (20),
	@rt_debtor_acct		varchar (20),
	@rt_trx_type 		varchar (4),
	@rt_descs 		varchar (255),
	@rt_ref			varchar (30),
	@rt_bank_cd		varchar (20),   
	@rt_currency_cd		varchar (4),   
	@rt_currency_rate	numeric (9,4),
	@rt_comm_rate		numeric (21,2),
	@rt_start_cheque	varchar (20),
	@rt_end_cheque 		varchar (20),
	@rt_pr_trx_type 	varchar (4),
	@rt_cheq_prefix 	varchar (10),
	@rt_cheque_amt		numeric (21,2),
	@rt_start_date		datetime,
	@rt_base 		char (1),
	@rt_interval		numeric (3,0),
	@rt_branch		varchar (60),
	@rt_audit_user		varchar (10),
    @rt_brstn		varchar (20),
	@rt_pr_date		datetime,
	@rt_paid_by		varchar(255),
	@rt_venue		varchar(4)
AS
/******* Declaring All Variables *******/
DECLARE @f_cheque_date		datetime
DECLARE @f_start_cheque		numeric(20,0)
DECLARE @f_end_cheque		numeric(20,0)
DECLARE @f_cheque_no		numeric(20,0)
DECLARE @f_bank_acct_cd		char (20)
DECLARE @f_currency_rate    	numeric (9,4)
DECLARE @f_next_doc_no		numeric(12,0)
DECLARE @f_temp_next_doc	numeric(12,0)
DECLARE @f_doc_no		varchar (10)
DECLARE @f_cheq_no		varchar (30)
DECLARE @f_prefix		varchar (2)
DECLARE @f_date			datetime
DECLARE @f_date1		datetime
DECLARE @f_descs		varchar(255)
BEGIN TRANSACTION

  SELECT @f_cheque_no 	 = CONVERT(numeric(20),@rt_start_cheque)
  SELECT @f_end_cheque	 = CONVERT(numeric(20),@rt_end_cheque)
  SELECT @f_cheque_date  = @rt_start_date

  SELECT @f_date	 = getdate()
  SELECT @f_date1 	 = CONVERT(datetime,RTRIM(CONVERT(varchar(2),DATEPART(mm,@f_date))) + '/' + RTRIM(CONVERT(varchar(2),DATEPART(dd,@f_date))) + '/' + RTRIM(CONVERT(varchar(4),DATEPART(yy,@f_date))))

/*Get the Next Document No. for the generation of Provisional No.  */

/*09062001  Select @f_prefix = mgr.cf_document_ctl.prefix, 
	 @f_next_doc_no = next_doc_no
  From 	 mgr.cf_document_ctl, mgr.cf_trx_type  
  Where  mgr.cf_document_ctl.entity_cd 	= mgr.cf_trx_type.entity_cd 
  And    mgr.cf_trx_type.prefix 	= mgr.cf_document_ctl.prefix
  And  	mgr.cf_trx_type.module 		= 'AR'
  And 	mgr.cf_document_ctl.entity_cd 	= @rt_entity_cd
  And    mgr.cf_trx_type.trx_type 	= @rt_pr_trx_type
  IF @@ERROR <> 0 OR @@ROWCOUNT = 0
  BEGIN
    ROLLBACK TRANSACTION
    RAISERROR('Could Not Document Control (cf_trx_type) File.',16,-1)
    RETURN
  END*/

 IF @rt_bank_cd <> ''
  BEGIN
    SELECT @f_bank_acct_cd = acct_cd
    FROM mgr.gl_bank  
    WHERE bank_cd = @rt_bank_cd  
    IF @@ERROR <> 0 OR @@ROWCOUNT = 0
    BEGIN
      ROLLBACK TRANSACTION
      RAISERROR('Could Not Read Bank Master (gl_bank) File.',16,-1)
      RETURN
    END
  END
  ELSE
    SELECT @f_bank_acct_cd = ''

  /* start of cheque incremental loop */
  WHILE (@f_cheque_no <= @f_end_cheque) 
  BEGIN

  EXEC mgr.get_document_no @rt_entity_cd, @rt_pr_trx_type,
	'AR', @f_doc_no OUTPUT, @f_descs OUTPUT
  IF @@ERROR <> 0
  BEGIN
	RAISERROR('',16,-1)
	RETURN
  END
--    SELECT @f_doc_no = @rt_pr_trx_type + CONVERT(char (8),@f_next_doc_no)
    SELECT @f_cheq_no = RTRIM(@rt_cheq_prefix) + CONVERT(char(20),@f_cheque_no)

    INSERT mgr.ar_post_dated
	(entity_cd,		project_no,
	 debtor_acct,		trx_type,
	 cheque_no,		cheque_date,
	 trx_date,		descs,
	 ref_no,		cheque_amt,
	 print_flag,		bank_cd,
	 bank_acct_cd,		receive_no,
	 currency_cd,		currency_rate,
	 comm_rate,			bank_branch,
	 pr_trx_type, 		pr_no,
	 deposit_date,		submit_date,
	 audit_user,		audit_date, 
	 venue,				pr_date,
	 paid_by,			brstn )
    VALUES ( @rt_entity_cd,  	@rt_project_no,  
	 @rt_debtor_acct, 	@rt_trx_type, 
	 @f_cheq_no, 		@f_cheque_date, 
	 @f_date1,		@rt_descs,
	 @rt_ref,		@rt_cheque_amt, 
	 'N',			@rt_bank_cd,
	 @f_bank_acct_cd,	' ',
	 @rt_currency_cd,	@rt_currency_rate,
	 @rt_comm_rate,		@rt_branch,
  	 @rt_pr_trx_type, 	@f_doc_no,
	 null, 				null, 
	 @rt_audit_user, 	@f_date, 
	 @rt_venue,			@rt_pr_date,
	 @rt_paid_by,		@rt_brstn)
    IF @@ERROR <> 0
    BEGIN
      ROLLBACK TRANSACTION
      RAISERROR('Could Not Insert Post-Dated Cheque (ar_post_dated) File.',16,-1)
      RETURN
    END    

/* 09062001   SELECT @f_temp_next_doc = @f_next_doc_no
    SELECT @f_next_doc_no = @f_next_doc_no + 1   
	
  Update mgr.cf_document_ctl
    Set	 next_doc_no = @f_next_doc_no
    Where entity_cd   = @rt_entity_cd
    And	 prefix	     = @f_prefix
    And	 next_doc_no = @f_temp_next_doc
    IF @@ERROR <> 0 
    BEGIN
       ROLLBACK TRANSACTION
       RAISERROR('Could Not Read Document Control (cf_document_ctl) File.',16,-1)
       RETURN
    END
*/

    SELECT @f_cheque_no = @f_cheque_no + 1

    IF @rt_base = 'M'
	SELECT @f_cheque_date  = DATEADD(month,@rt_interval,@f_cheque_date)
    IF @rt_base = 'D'
	SELECT @f_cheque_date  = DATEADD(day,@rt_interval,@f_cheque_date)
    IF @rt_base = 'Y'
	SELECT @f_cheque_date  = DATEADD(year,@rt_interval,@f_cheque_date)

  END

COMMIT TRANSACTION


RETURN 
/* End Of Procedure */





