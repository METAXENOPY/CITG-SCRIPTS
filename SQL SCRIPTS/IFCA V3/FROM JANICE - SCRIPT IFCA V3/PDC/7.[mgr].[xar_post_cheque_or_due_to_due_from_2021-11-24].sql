
/****** Object:  StoredProcedure [mgr].[xar_post_cheque_or_due_to_due_from]    Script Date: 11/21/2021 09:11:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Procedure Name	: xar_post_cheque_or_due_to_due_from		   			*/
/* Function			: Posting Of Post Dated Cheques	to be seen OR Entry */

ALTER PROCEDURE [mgr].[xar_post_cheque_or_due_to_due_from]	
	@rt_entity_cd 	   	varchar (4),
	@rt_debtor_acct		varchar (20),
	@rt_trx_type		varchar (4),
	@rt_cheque_no		varchar (30),
	@rt_cheque_dt		datetime,
	@rt_trx_date		datetime,
	@rt_audit_user		varchar (10),
	@rt_audit_date		datetime,
	@rt_doc_no		varchar(10),
   	@rt_batch_no   		numeric (12),
	@rt_grp_name 		varchar (10)
AS
/******* Declaring All Variables *******/
/* Declaring fetch status variables    */
DECLARE @f_cheque_fetch		numeric (12,0)
DECLARE @f_pay_fetch 		numeric (12,0)

/* Declaring local variables used      */
DECLARE @f_doc_no		varchar (10)
DECLARE @f_local_amt		numeric (21,2)
DECLARE @f_count		numeric(12,0)
DECLARE @f_error_descs		varchar(255)
DECLARE @f_business_id		varchar(10)
DECLARE @f_line_no		numeric(5)

/* Declaring ar_post_dated variables used  */
DECLARE @f_lot_no	       	varchar (20)
DECLARE @f_debtor_acct	 	varchar (20)
DECLARE @f_bank_cd		varchar (20)
DECLARE @f_trx_type		varchar (4)
DECLARE @f_trx_no		numeric (12,0)
DECLARE @f_doc_date		datetime
DECLARE @f_ref_no		varchar (30)
DECLARE @f_descs		varchar (255)
DECLARE @f_trx_amt		numeric (21,2)
DECLARE @f_currency_cd	 	varchar (4)
DECLARE @f_currency_rate 	numeric (21,8)
DECLARE @f_audit_user	 	varchar (10)
DECLARE @f_audit_date  	 	datetime
DECLARE @f_comm_rate		numeric (21,2)
DECLARE @f_local_comm	 	numeric (21,2)
DECLARE @f_comm_acct		varchar (20)


/* Declaring ar_debtor and 			*/
/* ar_debtor_type variables  			*/
DECLARE @f_dr_type		varchar (2)
DECLARE @f_dr_acct		varchar (20)
DECLARE @f_acct_cd		varchar (20)
DECLARE @f_pay_to		varchar (60)
DECLARE @f_class		char (1)
DECLARE @f_trx_date		datetime
DECLARE @f_cnt			numeric (12,0)

BEGIN TRANSACTION

SELECT @f_count = count(*)
FROM mgr.ar_batch
WHERE entity_cd  = @rt_entity_cd
  AND batch_no   = @rt_batch_no

IF @f_count is null or @f_count = 0
BEGIN
	INSERT INTO mgr.ar_batch
	( 	entity_cd,		batch_no,		
		doc_count,		batch_total,		error_flag,
		trx_date,		audit_user,			audit_date,
		ind,			grp_name,			trx_mode)
	VALUES
	(  @rt_entity_cd, @rt_batch_no,   
		0,					0,			'E',
	  @rt_trx_date,	@rt_audit_user,	@rt_audit_date,
	  'M',			@rt_grp_name,		'C' )									

	IF @@ERROR <> 0 
      BEGIN
        ROLLBACK TRANSACTION
        RAISERROR('Could Not Insert Into AR Batch (ar_batch) File.',16,-1)
        RETURN
      END
END


/* Declaring Cursor For Batch Header File */
DECLARE cheque_cursor CURSOR FOR  
 SELECT debtor_acct,         trx_type,   
        cheque_no,           cheque_date,   
        cheque_amt,          bank_cd,   
        currency_cd,         currency_rate,   
        comm_rate,           audit_user,   
        audit_date,	     column1  
 FROM  mgr.ar_post_dated  
 WHERE entity_cd   = @rt_entity_cd
 AND   debtor_acct = @rt_debtor_acct
 AND   trx_type    = @rt_trx_type
 AND   cheque_no   = @rt_cheque_no
 AND   cheque_date = @rt_cheque_dt

  OPEN cheque_cursor

  SELECT @f_cheque_fetch = 0
  /* start of ar_batch loop */
  WHILE (@f_cheque_fetch <> -1)
  BEGIN
    FETCH NEXT FROM cheque_cursor 
	  INTO @f_debtor_acct,     @f_trx_type,   
          @f_ref_no,          @f_doc_date,   
          @f_trx_amt,         @f_bank_cd,   
          @f_currency_cd,     @f_currency_rate,   
          @f_comm_rate,       @f_audit_user,   
          @f_audit_date,      @f_doc_no  	

    SELECT @f_cheque_fetch = @@FETCH_STATUS
    IF (@f_cheque_fetch <> -1) 
    BEGIN
	   	SELECT @f_trx_date   = @rt_trx_date
		SELECT @f_audit_user = @rt_audit_user
		SELECT @f_audit_date = @rt_audit_date
		SELECT @f_doc_no     = @rt_doc_no
      
		IF @f_doc_no = '' OR @f_doc_no IS NULL
			BEGIN 
				EXEC mgr.get_document_no  @rt_entity_cd,		@f_trx_type,
												  'AR',					@f_doc_no OUTPUT,
												  @f_descs OUTPUT
		      IF @@ERROR <> 0
		      BEGIN
		        ROLLBACK TRANSACTION
		        DEALLOCATE cheque_cursor
		        RAISERROR('',16,-1)
		        RETURN
		      END
			END 
		 ELSE
			BEGIN
			  SELECT   @f_descs    = descs  
			  FROM   mgr.cf_trx_type  
			  WHERE  entity_cd = @rt_entity_cd
			  AND    trx_type  = @f_trx_type
			  AND    module    = 'AR'
				IF @@ERROR <> 0
		      BEGIN
		        ROLLBACK TRANSACTION
		        DEALLOCATE cheque_cursor
		        RAISERROR('Could Not Read Trasnaction Type (cf_trx_type) Master File',16,-1)
		        RETURN
		      END
			END

	      SELECT @f_count = ISNULL(COUNT(*),0)
	      FROM mgr.ar_ledger
	      WHERE entity_cd = @rt_entity_cd
	      AND doc_no = @rt_doc_no
	      IF @@ERROR <> 0 
	      BEGIN 
		  ROLLBACK TRANSACTION
	          RAISERROR('Could Not Read AR Ledger (ar_ledger) File for checking of duplicate OR No.',16,-1)
				 DEALLOCATE cheque_cursor
		       RAISERROR('',16,-1)
	          RETURN
	      END

  	     IF @f_count > 0 
	      BEGIN
		  ROLLBACK TRANSACTION
	          SELECT @f_error_descs = 'Duplicate OR No. ' + @rt_doc_no + ' on AR Ledger '
	          RAISERROR(@f_error_descs,16,-1)
		  DEALLOCATE cheque_cursor
	          RAISERROR('',16,-1)
	          RETURN
	      END


	      SELECT @f_count = ISNULL(COUNT(*),0)
	      FROM mgr.ar_paytrx
	      WHERE entity_cd = @rt_entity_cd
	      AND doc_no = @rt_doc_no
	      IF @@ERROR <> 0 
	      BEGIN 
		  ROLLBACK TRANSACTION
	          RAISERROR('Could Not Read AR Payment Transaction (ar_lpaytrx) File for checking of duplicate OR No.',16,-1)
		  DEALLOCATE cheque_cursor
		  RAISERROR('',16,-1)
	          RETURN
	      END

	      IF @f_count > 0 
	      BEGIN
		  ROLLBACK TRANSACTION
	          SELECT @f_error_descs = 'Duplicate OR No. ' + @rt_doc_no + ' on OR Payment Entry '
	          RAISERROR(@f_error_descs,16,-1)
		  DEALLOCATE cheque_cursor
	          RAISERROR('',16,-1)
	          RETURN
	      END

		
		SELECT @f_line_no = max(line_no)
		FROM mgr.ar_paytrx
		WHERE entity_cd = @rt_entity_cd
		AND   batch_no  = @rt_batch_no
	      IF @@ERROR <> 0 
	      BEGIN 
		  ROLLBACK TRANSACTION
	          RAISERROR('Could Not Read AR Paytrx (ar_paytrx) File for Checking of Line No.',16,-1)
				 DEALLOCATE cheque_cursor
		       RAISERROR('',16,-1)
	          RETURN
	      END

		IF @f_line_no is null
			SELECT @f_line_no = 1
		ELSE
			SELECT @f_line_no = @f_line_no + 1


		SELECT @f_business_id = business_id
		FROM mgr.ar_debtor
		WHERE debtor_acct = @f_debtor_acct
		IF @@ERROR <> 0 
	      BEGIN 
		  ROLLBACK TRANSACTION
	          RAISERROR('Could Not Read AR Debtor (ar_debtor) Master File.',16,-1)
				 DEALLOCATE cheque_cursor
		       RAISERROR('',16,-1)
	          RETURN
	      END


		INSERT INTO mgr.ar_paytrx
		(	entity_cd,			batch_no,				line_no,		doc_no,
			debtor_acct,		trx_type,				doc_date,		trx_mode,
			bank_cd,			ref_no,					descs,			trx_amt,	currency_cd,
			currency_rate,		alloc_flag,			alloc_amt,		status,		audit_user,
			audit_date,			deduct_amt,			pay_type,		cancel_flag)

		VALUES (@rt_entity_cd,		@rt_batch_no,			@f_line_no,		@f_doc_no,	
				@f_debtor_acct,		@f_trx_type,			@f_doc_date, 	'C',
				@f_bank_cd,			@f_ref_no,				@f_descs,		@f_trx_amt,	@f_currency_cd,
				@f_currency_rate, 	'M',					@f_trx_amt,		'E',		@f_audit_user,
         		@f_audit_date, 		0,						'2',			'N')
	IF @@ERROR <> 0 
      BEGIN 
			ROLLBACK TRANSACTION
			RAISERROR('Could Not Insert Into AR Paytrx (ar_paytrx) File.',16,-1)
			 DEALLOCATE cheque_cursor
	       RAISERROR('',16,-1)
          RETURN
      END

		UPDATE mgr.ar_batch
		SET doc_count = doc_count + 1,
			batch_total = batch_total + @f_trx_amt
		WHERE entity_cd = @rt_entity_cd
			AND batch_no = @rt_batch_no

	IF @@ERROR <> 0 
      	BEGIN 
	  	ROLLBACK TRANSACTION
          	RAISERROR('Could Not IUpdate Into AR Batch (ar_batch) File.',16,-1)
		DEALLOCATE cheque_cursor
	       	RAISERROR('',16,-1)
          	RETURN
      	END

/*   Modified By: ALbert Tio 07-17-2008
      UPDATE mgr.ar_post_dated  
      SET    print_flag  = 'P',
				 receive_no  = @rt_doc_no,
				 trx_date    = @rt_trx_date,
				 audit_user  = @rt_audit_user,
				 audit_date  = @rt_audit_date
 	   WHERE entity_cd   = @rt_entity_cd
 		AND   project_no  = @rt_project_no
 		AND   debtor_acct = @rt_debtor_acct
 		AND   trx_type    = @rt_trx_type
 		AND   cheque_no   = @rt_cheque_no
 		AND   cheque_date = @rt_cheque_dt
*/

      UPDATE mgr.ar_post_dated  
      SET        print_flag  = 'P',
		 receive_no  = @rt_doc_no,  
		 submit_date = @rt_trx_date
        WHERE entity_cd   = @rt_entity_cd
	AND   debtor_acct = @rt_debtor_acct
	AND   trx_type    = @rt_trx_type
	AND   cheque_no   = @rt_cheque_no
	AND   cheque_date = @rt_cheque_dt
      IF @@ERROR <> 0 
      BEGIN
        	ROLLBACK TRANSACTION
		DEALLOCATE cheque_cursor
        	RAISERROR('Could Not Update Post Dated Cheque (ar_post_dated) File.',16,-1)
        	RETURN
      END

      SELECT @f_cnt = ISNULL(COUNT(cheque_no),0)
	 FROM  mgr.ar_post_dated  
	 WHERE entity_cd   = @rt_entity_cd
	 AND   debtor_acct = @rt_debtor_acct
	 AND   trx_type    = @rt_trx_type
	 AND   cheque_no   = @rt_cheque_no
	 AND   cheque_date = @rt_cheque_dt
      IF @@ERROR <> 0 
      BEGIN
        	ROLLBACK TRANSACTION
		DEALLOCATE cheque_cursor
        	RAISERROR('Could Not Read Post Dated Cheque History (ar_hist_post_dated) File.',16,-1)
        	RETURN
      END

      SELECT @f_cnt = @f_cnt + 1

	INSERT mgr.ar_hist_post_dated(
	       entity_cd, 		project_no,
	       debtor_acct,          	trx_type,
	       cheque_no,               cheque_date,
	       trx_date,                descs,
	       ref_no,                  cheque_amt,
	       print_flag, 			bank_cd,
	       bank_acct_cd,            receive_no,
	       currency_cd, 		currency_rate,
	       comm_rate,                bank_branch,
	       pr_trx_type,		pr_no,
	       deposit_date,            submit_date,
	       audit_user, 		audit_date,
	       reason_cd,		trx_no)
	SELECT entity_cd, 		project_no,
	       debtor_acct,          	trx_type,
	       cheque_no,               cheque_date,
	       trx_date,                descs,
	       ref_no,                  cheque_amt,
	       print_flag, 		bank_cd,
	       bank_acct_cd,            receive_no,
	       currency_cd, 		currency_rate,
	       comm_rate,               bank_branch,
	       pr_trx_type,		pr_no,
	       deposit_date,            submit_date,
	       @rt_audit_user, 		@rt_audit_date,
	       '',			@f_cnt                                           
	 FROM  mgr.ar_post_dated  
	 WHERE entity_cd   = @rt_entity_cd
	 AND   debtor_acct = @rt_debtor_acct
	 AND   trx_type    = @rt_trx_type
	 AND   cheque_no   = @rt_cheque_no
	 AND   cheque_date = @rt_cheque_dt
      IF @@ERROR <> 0 
      BEGIN
        	ROLLBACK TRANSACTION
		DEALLOCATE cheque_cursor
        	RAISERROR('Could Not Insert Post Dated Cheque History (ar_hist_post_dated) File.',16,-1)
        	RETURN
      END



    END
  END
  /* end of ar_batch Loop */
  DEALLOCATE cheque_cursor

  COMMIT TRANSACTION

RETURN
/* End Of Procedure */




