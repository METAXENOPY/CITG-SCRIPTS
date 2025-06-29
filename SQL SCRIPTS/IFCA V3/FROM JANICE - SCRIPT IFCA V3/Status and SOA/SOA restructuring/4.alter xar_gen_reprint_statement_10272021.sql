--USE [dclub_coupon]
--GO
/****** Object:  StoredProcedure [mgr].[xar_gen_reprint_statement]    Script Date: 10/08/2021 09:03:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure mgr.xar_gen_reprint_statement    Script Date: 9/29/2004 7:33:44 PM ******/
/* Procedure Name : xar_gen_reprint_statement				*/
/* Function       : Generation Of Membership Statement			*/
/* Parameters     : Start Date, End Date, Statement Type, Debtor Account*/
/*		    Category, Debtor Type				*/
/* Author         : Eunice Poh						*/
/* Date           : 22nd May 1996					*/
/* GRANT ALL ON mgr.xar_gen_reprint_statement TO pbteam */
/* DROP PROCEDURE mgr.xar_gen_reprint_statement	        */


ALTER  PROCEDURE [mgr].[xar_gen_reprint_statement] 
	@rt_entity_cd       char (4),
	@rt_start_date		datetime,
	@rt_end_date		datetime,
	@rt_pay_due			datetime,
	@rt_statement_type	char (1),
	@rt_debtor_acct		char (20),
	@rt_debtor_seq		numeric(12, 0),
	@rt_debtor_type		char (4),
	@rt_circular_cd     char (4),
	@rt_init_flag       char (1),
	@rt_filter_flag     char (1),
	@rt_mail_flag       char (1),
	@rt_stmnt_no		numeric(12, 0)
AS
/* Declaring Fetch Variables */
DECLARE @f_debtor_fetch	numeric(12,0)
DECLARE @f_ledger_fetch	numeric(12,0)
DECLARE @f_alloc_fetch	numeric(12,0)

/* Declaring Statement Variables */
DECLARE @f_debtor_acct		char (20)
DECLARE @f_name				char (60)
DECLARE @f_addr1			char (60)
DECLARE @f_addr2			char (60)
DECLARE @f_addr3			char (60)
DECLARE @f_postcode			char (10)
DECLARE @f_mship_id			char (20)
DECLARE @f_mship_type		char (1)
DECLARE @f_filter_date			char (10)
DECLARE @f_doc_no			char (24)
DECLARE @f_doc_date			datetime
DECLARE @f_balance			numeric(21,2)
DECLARE @f_desc				varchar (255)
DECLARE @f_doc_amt			numeric(21,2)
DECLARE @f_trx_mode			char (1)
DECLARE @f_member_id		char (20)
DECLARE @f_ref_no			char (30)
DECLARE @f_trx_type			char (4)
DECLARE @f_sort_no			char (1)
DECLARE @f_currency_cd		char (4)
DECLARE @f_currency_rate 	numeric (21,0)
DECLARE @f_fdoc_amt			numeric(21,2)
DECLARE @f_advance_amt		numeric(21,2)
DECLARE @f_deposit_amt		numeric(21,2)
DECLARE @f_contact_person	char (60)
DECLARE @f_status			char (1)
DECLARE @f_class			char (1)
DECLARE @f_ref_code			char (1)
DECLARE @f_ppd_amt			numeric (12, 2)

/* Declaring Local Variables */
DECLARE @f_bal_bf					numeric(21,2)
DECLARE @f_alloc_amt				numeric(21,2)
DECLARE @f_credit_date				datetime
DECLARE @f_debit_date				datetime
DECLARE @f_days						numeric(12,0)
DECLARE @f_month					numeric(12,0)
DECLARE @f_year						numeric(12,0)
DECLARE @f_rdays					numeric(12,0)
DECLARE @f_rmonth					numeric(12,0)
DECLARE @f_ryear					numeric(12,0)
DECLARE @f_no_months				numeric(12,0)
DECLARE @f_v_month					numeric(12,0)
DECLARE @f_aging_day				numeric(12,0)
DECLARE @f_age1_amt					numeric(21,2)
DECLARE @f_age2_amt					numeric(21,2)
DECLARE @f_age3_amt					numeric(21,2)
DECLARE @f_age4_amt					numeric(21,2)
DECLARE @f_age5_amt					numeric(21,2)
DECLARE @f_age6_amt					numeric(21,2)
DECLARE @f_member_type				char (1)
DECLARE @f_cnt						numeric(12,0)
DECLARE @f_cnt2						numeric(12,0)
DECLARE @f_giro_ind					char (1)
DECLARE @f_print_cnt           		numeric (1,0)
DECLARE @f_dummy					char (20)
DECLARE @f_today					datetime
DECLARE @f_due_date		  			datetime
DECLARE @monthdues_trxtype	  		varchar( 4)
DECLARE @monthdues_threshold 		numeric (2,0)
DECLARE @monthdues_soaflag	  		varchar( 4)
DECLARE @monthdues_allocamt	 		numeric(21,2)
DECLARE @f_md_threshold_date		datetime
DECLARE @f_monthdues_debit_doc_no	char (24)
DECLARE @f_monthdues_credit_doc_no	char (24)
DECLARE @f_monthdues_debit_balance	numeric(21,2)
DECLARE @f_monthdues_credit_balance	numeric(21,2)
DECLARE @f_monthdues_credit_date	datetime
DECLARE @f_insertdt           		numeric (1,0)
DECLARE @f_allocdate           		datetime
DECLARE @f_future_alloc_amt			numeric(21,2)
DECLARE @f_currbal_amt	 			numeric(21,2)
DECLARE @f_lessbf           		numeric (1,0)
DECLARE @f_prev_alloc_amt			numeric(21,2)
DECLARE  @f_stmnt_no				numeric(12, 0)
DECLARE  @f_ok						varchar(1)
DECLARE  @f_seqno					numeric (5,0)

--customization for palms/timberland
declare	@PayDesc				varchar(60),    @PayAmt					numeric(21,2),
		@InterestDesc			varchar(60),	@InterestAmt			numeric(21,2),
		@ChargesDesc			varchar(60),	@Charges				numeric(21,2),
		@DepositDesc			varchar(60),	@DepositDesc2			varchar(60),		
		@Deposit				numeric(21,2),	@RebatesDesc			varchar(60),		
		@Rebates				numeric(21,2),	@AdjustmentDesc			varchar(60),	
		@AdjustmentDesc2		varchar(60),	@Adjustments2			numeric(21,2),	  
		@Adjustments			numeric(21,2),	@DepositBalancebfDesc	varchar(60),		
		@DepositBalancebf		numeric(21,2),	@InterestTrxType		varchar( 4),
		@rebate_trxtype			varchar( 4),	@PrevYrDeposit			numeric(21,2),
		@CurrentYrDeposit		numeric(21,2),	@PrevYrDepositDate		datetime,
		@CurrentYrDepositDate	datetime,		@DepositMonthApp		numeric( 2),
		@deprec_trxtype			varchar( 4)

SELECT	@monthdues_trxtype		= monthly_dues_trx_type,
		@monthdues_threshold	= isnull( monthly_dues_threshold, 2),
		@monthdues_soaflag		= isnull( monthly_dues_soa_flag, 'N'),
		@InterestTrxType		= interest_trx,
		@rebate_trxtype			= isnull( rebate_trx_type, ''),
		@deprec_trxtype			= isnull( deprec_trx_type, '')		 
FROM	mgr.AR_SPEC

SELECT @f_seqno = 1

SELECT  @PrevYrDeposit = sum( a.mdoc_amt * -1), @PrevYrDepositDate = max( a.doc_date)
FROM	mgr.ar_ledger a
WHERE	a.entity_cd		= @rt_entity_cd
AND		a.debtor_acct	= @rt_debtor_acct
AND		a.class			= 'S'
AND		DatePart( year, a.doc_date) = DatePart( year, dateadd( year, -1, @rt_start_date)) 

SELECT  @CurrentYrDeposit = sum( a.mdoc_amt * -1), @CurrentYrDepositDate = max( a.doc_date)
FROM	mgr.ar_ledger a
WHERE	a.entity_cd		= @rt_entity_cd
AND		a.debtor_acct	= @rt_debtor_acct
AND		a.class			= 'S'	
AND		DatePart( year, a.doc_date) = DatePart( year,  @rt_start_date) 


IF @PrevYrDeposit is null select @PrevYrDeposit = 0.00
IF @CurrentYrDeposit is null select @CurrentYrDeposit = 0.00

IF @CurrentYrDeposit <> 0
BEGIN
	SELECT @DepositMonthApp = DateDiff( month, @CurrentYrDepositDate,  @rt_start_date) 

	IF @DepositMonthApp > 0
	BEGIN
		SELECT @Deposit			 = Round( (@CurrentYrDeposit / 12) * @DepositMonthApp , 2) 
		SELECT @DepositBalancebf = @CurrentYrDeposit *-1
		SELECT @f_deposit_amt    = @Deposit
	END 	
	ELSE
	BEGIN
		SELECT @Deposit			 =  0.00
		SELECT @f_deposit_amt	 = 0.00
		SELECT @DepositBalancebf = @CurrentYrDeposit * -1
	END	
END  
ELSE
BEGIN
	IF @PrevYrDeposit <> 0
	BEGIN
		SELECT @DepositMonthApp = DateDiff( month, @PrevYrDepositDate,  @rt_start_date) 
		IF @DepositMonthApp > 0 and @DepositMonthApp <= 12 
		BEGIN
			SELECT @Deposit = Round( @PrevYrDeposit / 12 * @DepositMonthApp, 2)
			SELECT @DepositBalancebf = @PrevYrDeposit *-1
			SELECT @f_deposit_amt = @Deposit 
		END 	
	END 
END 

SELECT	@PayAmt			= SUM(CASE WHEN b.trx_class = 'M' THEN ISNULL(a.mdoc_amt,0) * -1 ELSE 0 END),
		@PayDesc		= mgr.f_paymentdetails(@rt_entity_cd, @rt_debtor_acct, @rt_start_date, @rt_end_date),
		@InterestAmt	= SUM(CASE WHEN a.trx_type = @InterestTrxType THEN ISNULL(a.mdoc_amt, 0) ELSE 0 END),		
		@Charges		= SUM(CASE WHEN b.trx_class = 'I' THEN a.mdoc_amt ELSE 0 END),	
		@Adjustments 	= SUM(CASE WHEN b.trx_class = 'D' THEN ISNULL(a.mdoc_amt,0) ELSE 0 END),
		@Adjustments2 	= SUM(CASE WHEN b.trx_class = 'C' AND a.trx_type <> @rebate_trxtype AND a.trx_type <> @deprec_trxtype THEN
		                  ISNULL(a.mdoc_amt * -1,0) ELSE 0 END),
		@Rebates		= SUM(CASE WHEN a.trx_type = @rebate_trxtype THEN ISNULL(a.mdoc_amt * -1,0) ELSE 0 END),
		@Deposit		= SUM(CASE WHEN a.trx_type = @deprec_trxtype THEN ISNULL(a.mdoc_amt * -1,0) ELSE 0 END) 
FROM	mgr.ar_ledger a, mgr.cf_trx_type b
WHERE	a.entity_cd		= @rt_entity_cd
AND		a.debtor_acct	= @rt_debtor_acct
AND		a.doc_date	   >= @rt_start_date
AND 	a.doc_date     <= @rt_end_date
AND		a.trx_type		= b.trx_type
AND		a.entity_cd		= b.entity_cd

IF @PayAmt       IS NULL SELECT @PayAmt       = 0.00
IF @Charges      IS NULL SELECT @Charges      = 0.00
IF @InterestAmt  IS NULL SELECT @InterestAmt  = 0.00
IF @Adjustments  IS NULL SELECT @Adjustments  = 0.00
IF @Adjustments2 IS NULL SELECT @Adjustments2 = 0.00

IF @paydesc IS NULL 
	SELECT @PayDesc = 'Less: Payment' 
ELSE 
	SELECT @PayDesc = 'Less: Payment ' + @PayDesc

SELECT @InterestDesc = 'Penalties from unpaid balance'
SELECT @ChargesDesc	 = 'Current Charges (' + SUBSTRING(DATENAME(mm,@rt_start_date),1,3) + ' ' + DATENAME(dd,@rt_start_date) +
                       '-' + DATENAME(dd,@rt_end_date) + ', '  + DATENAME(yy,@rt_end_date) + ')'
SELECT @DepositDesc	 = 'Applied Deposit on Monthly Dues'
SELECT @DepositDesc2 = 'Less: Applied as of this month'

SELECT @RebatesDesc			 = 'Rebate'
SELECT @AdjustmentDesc 		 = 'Debit Adjustments'
SELECT @AdjustmentDesc2 	 = 'Credit Adjustments'
SELECT @DepositBalancebfDesc = 'Advance Deposit Previous Balance' 

IF @Deposit          IS NULL SELECT @Deposit          = 0.00
IF @Rebates          IS NULL SELECT @Rebates          = 0.00
IF @DepositBalancebf IS NULL SELECT @DepositBalancebf = 0.00
IF @f_deposit_amt    IS NULL SELECT @f_deposit_amt 	  = 0.00

SELECT @f_md_threshold_date = DATEADD(MONTH,2,@rt_end_date)
SELECT @f_today    = GETDATE()
SELECT @f_ok	   = 1
SELECT @f_stmnt_no = 0

DECLARE @f_prev_bal_date    DATETIME
DECLARE @f_prev_bal_debit   NUMERIC(21,2)
DECLARE @f_prev_bal_credit  NUMERIC(21,2)
DECLARE @f_bf_fetch 		NUMERIC(12,0)
DECLARE @f_cumulative_bal 	NUMERIC(21,2)
DECLARE @f_current_bal 		NUMERIC(21,2)

BEGIN TRANSACTION
IF @rt_init_flag = 'N'
BEGIN
	DELETE FROM mgr.ar_stmnt_hd
    WHERE debtor_acct = @rt_debtor_acct
    IF @@ERROR <> 0
    BEGIN
		ROLLBACK TRANSACTION
		RAISERROR( "Could not delete Statement Header (ar_stmnt_hd) file.",16,-1)
		RETURN
    END
    DELETE FROM mgr.ar_stmnt_dt
    WHERE debtor_acct = @rt_debtor_acct
    IF @@ERROR <> 0
    BEGIN
		ROLLBACK TRANSACTION
		RAISERROR( "Could not delete Statement Detail (ar_stmnt_dt) file.",16,-1)
		RETURN
	END
END

SELECT	@f_debtor_acct = debtor_acct,
		@f_advance_amt = advance_amt,
		@f_status      = status,
		@f_mship_type  = class
FROM	mgr.ar_debtor
WHERE	debtor_acct = @rt_debtor_acct
AND		type        = @rt_debtor_type
IF @@ERROR <> 0
BEGIN
	ROLLBACK TRANSACTION
	RAISERROR( "Could not read Debtor Master(ar_debtor) file.",16,-1)
	RETURN
END

/* Edit by Daniel - 17/09/1999 */
DECLARE	@f_mail			VARCHAR(1),
		@f_comp_seq_no	NUMERIC(12,0),
		@f_cat			VARCHAR(1)

SELECT	@f_contact_person = name,
		@f_mail		      = mail_type,
		@f_cat		      = category,
		@f_comp_seq_no    = company_seq_no
FROM	mgr.cf_business
WHERE	seq_no  = @rt_debtor_seq

IF @rt_mail_flag = 'M'
BEGIN
	IF @f_mail <> 'C'
	BEGIN
		SELECT	@f_name =	RTRIM(LTRIM(ISNULL(mgr.cf_business.salutation + ' ', '')  +
							RTRIM(LTRIM((CASE WHEN CHARINDEX(',',mgr.cf_business.name, 1) > 1 THEN
							LTRIM(SUBSTRING(mgr.cf_business.name,CHARINDEX(',',mgr.cf_business.name,1) + 1,  
							(DATALENGTH(mgr.cf_business.name) - CHARINDEX(',',mgr.cf_business.name,1)))) + ' ' + 
							SUBSTRING(mgr.cf_business.name,1, (CASE WHEN CHARINDEX(',',mgr.cf_business.name,1) > 1 THEN 
							(CHARINDEX(',',mgr.cf_business.name,1) - 1) ELSE 0 END)) ELSE mgr.cf_business.name END))))),
				@f_addr1 	= mail_addr1,
				@f_addr2  	= mail_addr2,
				@f_addr3 	= mail_addr3,
				@f_postcode = mail_post_cd,
				@f_contact_person = ''
		FROM	mgr.cf_business (nolock)
		WHERE	seq_no    = @rt_debtor_seq
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RAISERROR('Could Not Read Business (cf_business) File.',16,-1)
			RETURN
		END
	END
	ELSE
	BEGIN
		IF @f_cat <> 'I'
		BEGIN
			SELECT	@f_name     = b.name,
					@f_addr1    = b.address1,
					@f_addr2    = b.address2, 
					@f_addr3    = b.address3,
					@f_postcode = b.post_cd
 			FROM	mgr.cf_business a (NOLOCK),	mgr.cf_business b (NOLOCK)
			WHERE	a.seq_no = @rt_debtor_seq
			AND	    b.seq_no = a.seq_no 
			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RAISERROR('Could Not Read Business (cf_business) File.',16,-1)
				RETURN
			END

			IF @f_name IS NULL
			BEGIN
				SELECT	@f_name     = a.name,
						@f_addr1    = a.address1,
						@f_addr2    = a.address2, 
						@f_addr3    = a.address3,
						@f_postcode = a.post_cd
	 			FROM	mgr.cf_business a (NOLOCK)
				WHERE	a.seq_no  = @rt_debtor_seq
				IF @@ERROR <> 0
				BEGIN
					ROLLBACK TRANSACTION
					RAISERROR('Could Not Read Business (cf_business) File.',16,-1)
					RETURN
				END
			END
		END
		ELSE
		BEGIN
			SELECT	@f_name =	RTRIM(LTRIM(ISNULL(mgr.cf_business.salutation + ' ','')  +
								RTRIM(LTRIM((CASE WHEN CHARINDEX(',',mgr.cf_business.name,1) > 1 THEN
								LTRIM(SUBSTRING(mgr.cf_business.name,CHARINDEX(',',mgr.cf_business.name,1) + 1,  
								(DATALENGTH(mgr.cf_business.name) - CHARINDEX(',',mgr.cf_business.name,1)))) + ' ' + 
								SUBSTRING(mgr.cf_business.name,1,(CASE WHEN CHARINDEX(',',mgr.cf_business.name,1) > 1 
								THEN (charindex(',',mgr.cf_business.name,1) - 1) ELSE 0 END))
								ELSE mgr.cf_business.name END))))),
					@f_addr1	= mail_addr1,
					@f_addr2  	= mail_addr2,
					@f_addr3 	= mail_addr3,
					@f_postcode = mail_post_cd,
					@f_contact_person = ''
			FROM	mgr.cf_business (NOLOCK)
			WHERE	seq_no = @rt_debtor_seq
			IF @@ERROR <> 0
			BEGIN
				ROLLBACK TRANSACTION
				RAISERROR('Could Not Read Business (cf_business) File.',16,-1)
				RETURN
			END
		END
	END
 END

 IF @rt_mail_flag = 'R'
 BEGIN
	IF @f_cat <> 'C'
	BEGIN
		SELECT	@f_name =	RTRIM(LTRIM(ISNULL(mgr.cf_business.salutation + ' ','') +
							RTRIM(LTRIM((CASE WHEN CHARINDEX(',',mgr.cf_business.name,1) > 1 THEN
							LTRIM(SUBSTRING(mgr.cf_business.name,CHARINDEX(',',mgr.cf_business.name,1) + 1,  
							(DATALENGTH(mgr.cf_business.name) - CHARINDEX(',',mgr.cf_business.name,1)))) + ' ' +  
							SUBSTRING(mgr.cf_business.name,1, (CASE WHEN CHARINDEX(',',mgr.cf_business.name, 1) > 1 
							THEN (CHARINDEX(',',mgr.cf_business.name,1)-1) ELSE 0 END))
							ELSE mgr.cf_business.name END))))),
				@f_addr1	= address1,
				@f_addr2	= address2, 
				@f_addr3	= address3,
				@f_postcode = post_cd,
				@f_contact_person = contact_person
		FROM	mgr.cf_business
		WHERE	seq_no = @rt_debtor_seq
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RAISERROR('Could Not Read Business (cf_business) File.',16,-1)
			RETURN
		END
 	END
	ELSE
	BEGIN
		SELECT	@f_name	          = name,
				@f_addr1 	      = mail_addr1,
				@f_addr2  	      = mail_addr2,
				@f_addr3 		  = mail_addr3,
				@f_postcode 	  = mail_post_cd,
				@f_contact_person = contact_person
		FROM	mgr.cf_business (NOLOCK)
		WHERE	seq_no = @rt_debtor_seq
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RAISERROR('Could Not Read Business (cf_business) File.',16,-1)
			RETURN
		END
	END
 END

IF @rt_mail_flag = 'C'
BEGIN
	IF @f_comp_seq_no IS NULL
	BEGIN
		SELECT	@f_name		= name,
				@f_addr1 	= mail_addr1,
				@f_addr2  	= mail_addr2,
				@f_addr3 	= mail_addr3,
				@f_postcode	= mail_post_cd,
				@f_contact_person = contact_person
		FROM    mgr.cf_business (NOLOCK)
		WHERE   seq_no = @rt_debtor_seq
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RAISERROR('Could Not Read Business (cf_business) File.',16,-1)
			RETURN
		END
	END
	ELSE
	BEGIN
		SELECT	@f_name     = b.name,
				@f_addr1    = b.address1,
				@f_addr2    = b.address2, 
				@f_addr3    = b.address3,
				@f_postcode = b.post_cd,
				@f_contact_person = b.contact_person
		FROM	mgr.cf_business a (NOLOCK), mgr.cf_business b (NOLOCK)
		WHERE	a.seq_no = @rt_debtor_seq
		AND		b.seq_no = a.seq_no 
	END
END

SELECT @f_name = CASE WHEN (patindex("%*%",@f_name)- 1) <= 0 THEN @f_name ELSE SUBSTRING(@f_name,1,(patindex("%*%",@f_name)- 1)) END
IF @@ERROR <> 0
BEGIN
	ROLLBACK TRANSACTION
	RAISERROR( "Could not read Business Master(cf_business) file.",16,-1)
	RETURN
END

IF @f_mship_type = 'N'
BEGIN
	SELECT	@f_mship_id   = mship_id,
			@f_mship_type = mem_type,
			@f_status     = status_cd
	FROM	mgr.ma_member
	WHERE	member_id = @rt_debtor_acct
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RAISERROR( "Could not read Member Master(ma_member) file.",16,-1)
		RETURN
	END
END
ELSE
	IF @f_mship_type = 'C' OR @f_mship_type = 'I' OR @f_mship_type = 'L'
	BEGIN
		SELECT  @f_mship_id   = mship_id,
				@f_mship_type = mship_type,
				@f_status     = status_cd
		FROM	mgr.ma_mship
		WHERE	mship_id      = @rt_debtor_acct
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION
			RAISERROR( "Could not read Membership Master(ma_mship) file.",16,-1)
			RETURN
		END
END

SELECT @f_age1_amt  = 0
SELECT @f_age2_amt  = 0
SELECT @f_age3_amt  = 0
SELECT @f_age4_amt  = 0
SELECT @f_age5_amt  = 0
SELECT @f_age6_amt  = 0
SELECT @f_balance   = 0
SELECT @f_bal_bf    = 0
SELECT @f_print_cnt = 0
SELECT @f_insertdt  = 0
SELECT @f_lessbf    = 0	
SELECT @f_prev_alloc_amt = 0
select @f_monthdues_debit_balance  = 0.00
select @f_monthdues_credit_balance = 0.00
select @f_currbal_amt = 0.00
  
DECLARE bf_cursor CURSOR FOR
SELECT	doc_no,			doc_date,	mbal_amt,	descs,			mdoc_amt, 	trx_mode,
		member_id,		ref_no,		trx_type,	currency_cd,	fdoc_amt,	class,
		currency_rate,	due_date 
FROM	mgr.ar_ledger
WHERE	entity_cd   = @rt_entity_cd
AND		debtor_acct = @f_debtor_acct
AND		doc_date   <=  @rt_end_date
AND		class	   <> 'S'
AND		class	   <> 'A'
ORDER BY doc_date, doc_no ASC

OPEN bf_cursor
SELECT @f_bf_fetch = 1
/* BF Fetch While Loop */
WHILE (@f_bf_fetch <> -1)
BEGIN
	FETCH NEXT FROM bf_cursor
	INTO @f_doc_no,		   @f_doc_date, @f_balance,	 @f_desc,		 @f_doc_amt,  @f_trx_mode, 
		 @f_member_id,	   @f_ref_no,	@f_trx_type, @f_currency_cd, @f_fdoc_amt, @f_class,
		 @f_currency_rate, @f_due_date 

    SELECT @f_bf_fetch = @@FETCH_STATUS
    /* BF Fetch If Statement */
    IF (@f_bf_fetch <> -1)
    BEGIN
	    IF @f_trx_mode = 'D' AND @f_class <> 'M'
			SELECT @f_bal_bf = @f_bal_bf + @f_balance
	    ELSE
			SELECT @f_bal_bf = @f_bal_bf - @f_balance

		IF DATEDIFF(MONTH,@f_doc_date, @rt_end_date) = 0 SELECT @f_aging_day = 1
		IF DATEDIFF(MONTH,@f_doc_date, @rt_end_date) = 1 SELECT @f_aging_day = 2
		IF DATEDIFF(MONTH,@f_doc_date, @rt_end_date) = 2 SELECT @f_aging_day = 3
		IF DATEDIFF(MONTH,@f_doc_date, @rt_end_date) = 3 SELECT @f_aging_day = 4
		IF DATEDIFF(MONTH,@f_doc_date, @rt_end_date) = 4 SELECT @f_aging_day = 5
		IF DATEDIFF(MONTH,@f_doc_date, @rt_end_date)>= 5 SELECT @f_aging_day = 6

		IF @f_trx_mode = 'D'
		BEGIN
			IF @f_aging_day = 1 SELECT @f_age1_amt = @f_age1_amt + @f_balance 
			IF @f_aging_day = 2	SELECT @f_age2_amt = @f_age2_amt + @f_balance 
			IF @f_aging_day = 3	SELECT @f_age3_amt = @f_age3_amt + @f_balance 
			IF @f_aging_day = 4	SELECT @f_age4_amt = @f_age4_amt + @f_balance 
			IF @f_aging_day = 5	SELECT @f_age5_amt = @f_age5_amt + @f_balance 
			IF @f_aging_day = 6 SELECT @f_age6_amt = @f_age6_amt + @f_balance 
		END
		/* If f_trx_mode = 'D' */
		ELSE
		/* If f_trx_mode = 'C' */
		BEGIN
			SELECT @f_future_alloc_amt = SUM(ISNULL(local_amt,0)),
				   @f_allocdate = MAX(debit_date)
			FROM   mgr.ar_alloc
			WHERE  entity_cd   = @rt_entity_cd
			AND    debtor_acct = @f_debtor_acct
			AND    credit_doc  = @f_doc_no
			AND    credit_date = @f_doc_date
			AND    debit_date  > @rt_end_date
			AND    credit_trx  = @f_trx_type
	                
			IF @f_alloc_amt IS NULL  SELECT @f_alloc_amt = 0

			IF DATEDIFF(MONTH,@rt_end_date,@f_allocdate) > 0 AND @f_future_alloc_amt > 0 
			BEGIN
				IF @f_aging_day = 1 SELECT @f_age1_amt = @f_age1_amt 	
			END
			ELSE
			BEGIN
			   IF @f_aging_day = 1 SELECT @f_age1_amt = @f_age1_amt - @f_balance 
			   IF @f_aging_day = 2 SELECT @f_age2_amt = @f_age2_amt - @f_balance 
			   IF @f_aging_day = 3 SELECT @f_age3_amt = @f_age3_amt - @f_balance 
			   IF @f_aging_day = 4 SELECT @f_age4_amt = @f_age4_amt - @f_balance 
			   IF @f_aging_day = 5 SELECT @f_age5_amt = @f_age5_amt - @f_balance 
			   IF @f_aging_day = 6 SELECT @f_age6_amt = @f_age6_amt - @f_balance 
			END 
		END
	END
END

DEALLOCATE bf_cursor

SELECT @f_cumulative_bal   = 0	
SELECT @f_cumulative_bal   = @f_bal_bf
SELECT @f_current_bal	   = 0
SELECT @f_future_alloc_amt = 0

IF @f_ppd_amt is null SELECT @f_ppd_amt = 0.00

DECLARE ledger_cursor CURSOR FOR
SELECT	a.doc_no,		 a.doc_date,	a.mdoc_amt,
		a.descs,		 a.mdoc_amt, 	a.trx_mode,
		a.member_id,	 a.ref_no,		a.trx_type,
		a.currency_cd,	 a.fdoc_amt,	a.class,
		a.currency_rate, a.due_date ,	ISNULL(b.stamp_duty,'N'),  
		a.mbal_amt
FROM	mgr.ar_ledger a, mgr.cf_trx_type b
WHERE	a.entity_cd   = @rt_entity_cd
AND     a.debtor_acct = @f_debtor_acct
AND	    a.doc_date   >= @rt_start_date
AND 	a.doc_date   <= @rt_end_date
AND	    a.class	     <> 'S'
AND	    a.class	     <> 'A'
AND     a.trx_type    = b.trx_type
AND	    a.entity_cd   = b.entity_cd
ORDER BY doc_date, doc_no ASC

OPEN ledger_cursor
SELECT @f_ledger_fetch = 1
/* Ledger Fetch While Loop */
WHILE (@f_ledger_fetch <> -1)
BEGIN
	FETCH NEXT FROM ledger_cursor
	INTO  @f_doc_no,		@f_doc_date,	@f_balance,		@f_desc,
		  @f_doc_amt,		@f_trx_mode,	@f_member_id,	@f_ref_no,
		  @f_trx_type,		@f_currency_cd, @f_fdoc_amt,	@f_class,
	      @f_currency_rate, @f_due_date,	@f_ref_code,	@f_currbal_amt

	SELECT @f_ledger_fetch = @@FETCH_STATUS
	/* Ledger Fetch If Statement */
	IF (@f_ledger_fetch <> -1)
	BEGIN
		SELECT @f_print_cnt = 1
		SELECT @f_insertdt  = 1

		SELECT @f_member_type = mship_type
		FROM   mgr.ma_mship
		WHERE  mship_id = @f_member_id
		IF @@ROWCOUNT = 0
		BEGIN
			SELECT @f_member_type = mem_type
			FROM   mgr.ma_member
			WHERE  member_id = @f_member_id
			IF @@ROWCOUNT = 0
				SELECT @f_member_type = ""
			ELSE
			BEGIN
				IF @@ERROR <> 0 
				BEGIN
					ROLLBACK TRANSACTION
					DEALLOCATE ledger_cursor
					RAISERROR( "Could not read ma_member details file.",16,-1)
					RETURN
				END
			END
		END
		ELSE
		BEGIN
			IF @@ERROR <> 0 
			BEGIN
  			ROLLBACK TRANSACTION
				DEALLOCATE ledger_cursor
				RAISERROR( "Could not read ma_member details file.",16,-1)
				RETURN
			END
		END

		IF @f_member_type = 'I' OR @f_member_type = 'N'
			SELECT @f_sort_no = '1'
		ELSE
			IF @f_member_type = 'P' 
				SELECT @f_sort_no = '2'
			ELSE
				IF @f_member_type = 'S'
					SELECT @f_sort_no = '3'
				ELSE
					IF @f_member_type = 'D'
						SELECT @f_sort_no = '4'
					ELSE
						SELECT @f_sort_no = '0'
					
		SELECT @f_days 	    = DATEPART(day,@f_doc_date)
		SELECT @f_month	    = DATEPART(month,@f_doc_date)
		SELECT @f_year	    = DATEPART(year, @f_doc_date)
		SELECT @f_rdays	    = DATEPART(day,@rt_start_date)
		SELECT @f_rmonth    = DATEPART(month,@rt_end_date)
		SELECT @f_ryear	    = DATEPART(year, @rt_start_date)
		SELECT @f_no_months = (@f_ryear - @f_year) * 12
		SELECT @f_v_month   = @f_rmonth + @f_no_months

		IF @f_trx_mode = 'D'
		BEGIN
			SELECT @f_alloc_amt = SUM(ISNULL(local_amt,0)),
		   		   @f_monthdues_credit_date = MIN(credit_date)
			FROM   mgr.ar_alloc
			WHERE  entity_cd    = @rt_entity_cd
			AND    debtor_acct 	= @f_debtor_acct
			AND    debit_doc 	= @f_doc_no
			AND    debit_date 	= @f_doc_date
			AND    debit_trx    = @f_trx_type
			IF @f_alloc_amt IS NULL SELECT @f_alloc_amt = 0
		END
		/* If f_trx_mode = 'D' */
		ELSE
		/* If f_trx_mode = 'C' */
		BEGIN
			SELECT @f_alloc_amt = SUM(ISNULL(local_amt,0)),
				   @f_allocdate = MAX(debit_date)
			FROM   mgr.ar_alloc
			WHERE  entity_cd	= @rt_entity_cd
			AND    debtor_acct 	= @f_debtor_acct
			AND    credit_doc 	= @f_doc_no
			AND    credit_date 	= @f_doc_date
			AND    credit_trx   = @f_trx_type
			IF @f_alloc_amt IS NULL	SELECT @f_alloc_amt = 0
		END

		/* If f_trx_mode = 'C' */
		SELECT @f_balance = @f_balance - @f_alloc_amt
		IF @f_trx_mode = 'D'
		BEGIN
			SELECT @f_cumulative_bal = @f_cumulative_bal  + @f_balance 
			SELECT @f_current_bal	 = @f_current_bal     + @f_balance
		END
		ELSE
		BEGIN
			SELECT @f_cumulative_bal = @f_cumulative_bal  - @f_balance 
			SELECT @f_current_bal	 = @f_current_bal     - @f_balance
		END
		
		IF @f_doc_date >= @rt_start_date
		BEGIN
			IF @f_trx_type = @monthdues_trxtype
			BEGIN
				IF @f_currbal_amt = 0.00 and @monthdues_soaflag = 'N'
				BEGIN
					SELECT @f_insertdt = 0
					IF DATEDIFF(MONTH,@rt_start_date,@f_monthdues_credit_date) < 0
					BEGIN
						SELECT @f_lessbf = 1
						SELECT @f_prev_alloc_amt = @f_prev_alloc_amt - @f_alloc_amt	
					END 
				END 
			END

			IF @f_trx_mode = 'C' AND DATEDIFF(MONTH,@rt_end_date,@f_allocdate) > 0 AND @f_alloc_amt > 0 AND @monthdues_soaflag = 'N'
			BEGIN
				SELECT @f_insertdt = 0
			END 	

			IF @f_insertdt > 0 OR @monthdues_soaflag = 'Y'
			BEGIN	
				IF @f_trx_mode = 'C' AND DATEDIFF(MONTH,@rt_end_date,@f_allocdate) > 0 AND @f_alloc_amt > 0 SELECT @f_desc = 'PRE - ' + @f_desc
				IF @f_alloc_amt = 0 AND @f_trx_mode = 'C' SELECT @f_desc = @f_desc 
				
				IF @f_ok = 1 
				BEGIN
					EXEC mgr.x_get_next_number 'statement_no', 'mgr', '', @f_stmnt_no OUTPUT	
					SELECT @f_ok = 0	
				END  	  

				INSERT INTO mgr.ar_stmnt_dt (
					debtor_acct,	mship_id,		member_id,		doc_no,		
					doc_date,		ref_no,			trx_mode,		trx_type,	
					descs,			doc_amt,		currency_cd,	fdoc_amt,
					member_flag,	class,			statement_type,	print_flag, 
					ref_code, 		generated_by,	statement_No,	SEQNO)
				VALUES (
					@f_debtor_acct,	@f_mship_id,	@f_member_id,	@f_doc_no,
					@f_doc_date,	@f_ref_no, 		@f_trx_mode,	@f_trx_type,
					@f_desc,		@f_doc_amt,		@f_currency_cd,	@f_fdoc_amt,
					@f_sort_no,		@f_class,		'I',           	'',
					@f_ref_code,	system_user,	@f_stmnt_no,	@f_seqno)
				IF @@ERROR <> 0 
				BEGIN
					ROLLBACK TRANSACTION
					DEALLOCATE ledger_cursor
					RAISERROR( "Could not insert into ar_stmnt_dt details file.",16,-1)
					RETURN
				END
				SELECT @f_seqno = @f_seqno + 1
			END
		END
	END
    /* Ledger Fetch If Statement */
END
/* Ledger Fetch While Loop */
DEALLOCATE ledger_cursor

SELECT @f_giro_ind = 'N'
SELECT @f_prev_bal_date = DATEADD(day,-1,@rt_start_date)

SELECT @f_prev_bal_debit = ISNULL(SUM(mdoc_amt),0)
FROM   mgr.ar_ledger (NOLOCK)
WHERE  mgr.ar_ledger.debtor_acct = @f_debtor_acct
AND    mgr.ar_ledger.trx_mode    = 'D'
AND    mgr.ar_ledger.class      <> 'S'
AND    mgr.ar_ledger.doc_date   <= @f_prev_bal_date

SELECT @f_prev_bal_credit = isnull(sum(mdoc_amt),0)
FROM   mgr.ar_ledger (NOLOCK)
WHERE  mgr.ar_ledger.debtor_acct = @f_debtor_acct
AND    mgr.ar_ledger.trx_mode    = 'C'
AND    mgr.ar_ledger.class      <> 'S'
AND    mgr.ar_ledger.doc_date   <= @f_prev_bal_date

SELECT @f_bal_bf = @f_prev_bal_debit - @f_prev_bal_credit

--rsgerman10072021  
DECLARE @f_mf_due_date				DATETIME, 
		@f_mf_statement_date		DATETIME,
		@f_mf_monthly_amortization	NUMERIC (21,2),
		@f_mf_amount_due			NUMERIC (21,2),
		@f_mf_purchase_price		NUMERIC (21,2),
		@f_mf_total_paid			NUMERIC (21,2),
		@f_mf_balance				NUMERIC (21,2),
		@f_mf_last_paydate			DATETIME ,
		@f_mf_last_or				VARCHAR(20),
		@f_mf_last_payamount		NUMERIC (21,2),
		@f_mf_last_desc				VARCHAR(255),
		@f_md_current_dues			NUMERIC (21,2),	
		@f_md_amout_due				NUMERIC (21,2),		
		@f_md_last_paydate			DATETIME,	
		@f_md_last_payamount		NUMERIC (21,2),	
		@f_md_last_desc				VARCHAR(255),		
		@f_md_terms					CHAR(1),
		@f_md_past_due				NUMERIC (21,2),		
		@f_md_no_months				NUMERIC (12,0),		
		@f_md_due_count				NUMERIC (12,0),	
		@f_md_total_past_due		NUMERIC (21,2)

SELECT @f_mf_statement_date = cast(cast(YEAR(@rt_start_date)*10000 + MONTH(@rt_start_date)*100 + 6 as varchar(255)) as datetime)
SELECT @f_mf_due_date = cast(cast(YEAR(@rt_pay_due)*10000 + MONTH(@rt_pay_due)*100 + 5 as varchar(255)) as datetime)

SELECT	@f_mf_monthly_amortization = b.bill_amt
FROM	mgr.ma_billsch_restructure  b, 
		mgr.ma_mship c, 
		mgr.ar_debtor d
WHERE	b.mship_id			= c.MSHIP_ID
AND		c.DEBTOR_ACCT		= d.debtor_acct
AND		b.restructure_type	= 'F' 
AND		b.restructure_level = (	SELECT ISNULL(MAX(a.restructure_level),0) 
                                FROM   mgr.ma_billsch_restructure a	
								WHERE  b.mship_id = a.MSHIP_ID AND a.restructure_type = 'F')
AND		d.debtor_acct		= @f_debtor_acct 
AND		DATEDIFF(MONTH, b.bill_date, @f_mf_statement_date) = 0 --AND b.stg_no = 1

SELECT	@f_mf_amount_due = ISNULL(SUM(b.bill_amt),0)
FROM	mgr.ma_billsch_restructure  b, 
		mgr.ma_mship c, 
		mgr.ar_debtor d
WHERE	b.mship_id			= c.MSHIP_ID
AND		c.DEBTOR_ACCT		= d.debtor_acct
AND		b.restructure_type	= 'F' 
AND		b.restructure_level = (	SELECT ISNULL(MAX(a.restructure_level),0) 
                                FROM   mgr.ma_billsch_restructure a	
								WHERE  b.mship_id = a.MSHIP_ID AND a.restructure_type = 'F')
AND		d.debtor_acct = @f_debtor_acct 	 
AND		DATEDIFF(MONTH, b.bill_date, @f_mf_statement_date) >= 0
and		b.status = 'P'

SELECT	@f_mf_purchase_price = ISNULL(SUM(a.mdoc_amt),0), 
		@f_mf_total_paid     = ISNULL(SUM(a.mbal_amt),0),
		@f_mf_balance		 = ISNULL(SUM(a.mall_amt),0)
FROM	mgr.ar_ledger a (NOLOCK)
WHERE	a.trx_mode	= 'D'
and		a.class		= 'I'
and		a.trx_type IN ('MFPC','MEF')
and		a.debtor_acct = @f_debtor_acct 	 

SELECT	TOP 1 
		@f_mf_last_paydate	 = b.credit_date, 
		@f_mf_last_payamount = C.mdoc_amt, 
		@f_mf_last_desc		 = C.descs
FROM	mgr.ar_ledger a (NOLOCK), 
		mgr.ar_alloc b  (NOLOCK), 
		mgr.ar_ledger c (NOLOCK)
WHERE	a.entity_cd		= b.entity_cd
and		a.debtor_acct	= b.debtor_acct
and		a.doc_no		= b.debit_doc
and		c.entity_cd		= b.entity_cd
and		c.debtor_acct	= b.debtor_acct
and		c.doc_no		= b.credit_doc
and		a.trx_mode		= 'D'
and		a.class			= 'I'
and		a.trx_type		IN ('MFPC','MEF')
and		a.debtor_acct	= @f_debtor_acct 	
and		DATEDIFF(MONTH, b.credit_date, @f_mf_statement_date) > 0
ORDER BY credit_date DESC

----------------------------------------------
--MDUES
----------------------------------------------


-- CHECK FOR RESTRUCTURING

SELECT	@f_md_due_count	 = COUNT(b.mship_id)
FROM	mgr.ma_billsch_restructure b, 
		mgr.ma_mship c, 
		mgr.ar_debtor d
WHERE	b.mship_id			= c.MSHIP_ID
AND		c.DEBTOR_ACCT		= d.debtor_acct
AND		b.restructure_type	= 'D' 
AND		d.debtor_acct = @f_debtor_acct 
AND		b.status = 'P'


IF @f_md_due_count > 0 
BEGIN
	SELECT	@f_md_current_dues = b.bill_amt
	FROM	mgr.ma_billsch_restructure b, 
			mgr.ma_mship c, 
			mgr.ar_debtor d
	WHERE	b.mship_id			= c.MSHIP_ID
	AND		c.DEBTOR_ACCT		= d.debtor_acct
	AND		b.restructure_type	= 'D' 
	AND		b.restructure_level = (	SELECT ISNULL(MAX(a.restructure_level),0) 
									FROM   mgr.ma_billsch_restructure a	
									WHERE  b.mship_id = a.MSHIP_ID AND a.restructure_type = 'D')
	AND		d.debtor_acct = @f_debtor_acct 
	AND		DATEDIFF(MONTH, b.bill_date, @f_mf_statement_date) = 0

	SELECT	@f_md_amout_due = ISNULL(SUM(b.bill_amt),0)
	FROM	mgr.ma_billsch_restructure  b, 
			mgr.ma_mship c, 
			mgr.ar_debtor d
	WHERE	b.mship_id			= c.MSHIP_ID
	AND		c.DEBTOR_ACCT		= d.debtor_acct
	AND		b.restructure_type	= 'D' 
	AND		b.restructure_level = (	SELECT ISNULL(MAX(a.restructure_level),0) 
									FROM   mgr.ma_billsch_restructure a	
									WHERE  b.mship_id = a.MSHIP_ID AND a.restructure_type = 'D')
	AND		d.debtor_acct		= @f_debtor_acct 	 
	AND		DATEDIFF(MONTH, b.bill_date, @f_mf_statement_date) >= 0
	and		b.status = 'P'

	SELECT	@f_md_no_months		 = ISNULL(MAX(b.stg_no),0), 
			@f_md_total_past_due = ISNULL(SUM(b.bill_amt),0), 
			@f_md_terms			 = ISNULL(MAX(b.ins_mode),'M')
	FROM	mgr.ma_billsch_restructure  b, 
			mgr.ma_mship c, 
			mgr.ar_debtor d
	WHERE	b.mship_id			= c.MSHIP_ID
	AND		c.DEBTOR_ACCT		= d.debtor_acct
	AND		b.restructure_type	= 'D' 
	AND		b.restructure_level = (	SELECT ISNULL(MAX(a.restructure_level),0) 
									FROM   mgr.ma_billsch_restructure a	
									WHERE  b.mship_id = a.MSHIP_ID AND a.restructure_type = 'D')
	AND		d.debtor_acct		= @f_debtor_acct 	 

	SELECT	@f_md_past_due = b.bill_amt
	FROM	mgr.ma_billsch_restructure  b, 
			mgr.ma_mship c, 
			mgr.ar_debtor d
	WHERE	b.mship_id			= c.MSHIP_ID
	AND		c.DEBTOR_ACCT		= d.debtor_acct
	AND		b.restructure_type	= 'D' 
	AND		b.restructure_level = (	SELECT ISNULL(MAX(a.restructure_level),0) 
									FROM   mgr.ma_billsch_restructure a	
									WHERE  b.mship_id = a.MSHIP_ID AND a.restructure_type = 'D')
	AND		d.debtor_acct		= @f_debtor_acct
	and		b.stg_no			= 1

	IF @f_md_past_due IS NULL SELECT @f_md_past_due = 0


END
ELSE
BEGIN
	SELECT	@f_md_current_dues = ISNULL(sum(a.mdoc_amt),0)
	FROM	mgr.ar_ledger a (NOLOCK)
	WHERE	a.trx_mode		= 'D'
	and		a.class			= 'I'
	and		a.trx_type		IN ('MDPC','CONS')
	and		a.debtor_acct	= @f_debtor_acct
	and		a.mall_amt <> a.mdoc_amt
	and		DATEDIFF(MONTH, a.doc_date,@f_mf_statement_date) = 0


	SELECT	@f_md_amout_due = ISNULL(sum(a.mdoc_amt),0)
	FROM	mgr.ar_ledger a (NOLOCK)
	WHERE	a.trx_mode		= 'D'
	and		a.class			= 'I'
	and		a.trx_type		IN ('MDPC','CONS')
	and		a.debtor_acct	= @f_debtor_acct
	and		a.mall_amt <> a.mdoc_amt
	and		DATEDIFF(MONTH, a.doc_date, @f_mf_statement_date) >= 0
	
	
	--select	@f_md_no_months = COUNT(*), 
	--		@f_md_total_past_due = sum(mdoc_amt) , 
	--		@f_md_past_due = AVG(mdoc_amt),
	--		@f_md_terms = 'M'
	--from	mgr.ar_ledger
	--where	debtor_acct = @f_debtor_acct
	--and		trx_mode		= 'D'
	--and		class			= 'I'
	--and		trx_type		IN ('MDPC')
	--and		DATEDIFF(MONTH, doc_date, @f_mf_statement_date) > 0
	--and		mall_amt <> mdoc_amt
		
	select  @f_md_no_months = COUNT(*), 
			@f_md_total_past_due = ISNULL(SUM(total_amt),0),
			@f_md_past_due = AVG(total_amt) from (
	select	batch_no, total_amt = ISNULL(SUM(mdoc_amt),0)
	from	mgr.ar_ledger
	where	debtor_acct = @f_debtor_acct
	and		trx_mode	= 'D'
	and		class		= 'I'
	and		trx_type	IN ('MDPC','CONS')
	and		DATEDIFF(MONTH, doc_date, @f_mf_statement_date) > 0
	and		mall_amt <> mdoc_amt
	group by batch_no ) a

	
	IF @f_md_past_due > 1660 
		SELECT @f_md_terms = 'A'
	ELSE
		SELECT @f_md_terms = 'M'
END


SELECT	TOP 1 
		@f_md_last_paydate   = b.credit_date, 
		@f_md_last_payamount = ISNULL(C.mdoc_amt,0), 
		@f_md_last_desc		 = C.descs
FROM	mgr.ar_ledger a (NOLOCK), 
		mgr.ar_alloc  b (NOLOCK), 
		mgr.ar_ledger c (NOLOCK)
WHERE	a.entity_cd		= b.entity_cd
and		a.debtor_acct	= b.debtor_acct
and		a.doc_no		= b.debit_doc
and		c.entity_cd		= b.entity_cd
and		c.debtor_acct	= b.debtor_acct
and		c.doc_no		= b.credit_doc
and		a.trx_mode		= 'D'
and		a.class			= 'I'
and		a.trx_type		IN ('MDPC')
and		a.debtor_acct	= @f_debtor_acct 	 
and		DATEDIFF(MONTH, b.credit_date, @f_mf_statement_date) > 0
ORDER BY credit_date DESC

IF @f_md_last_payamount IS NULL SELECT @f_md_last_payamount = 0

--SELECT	@f_md_past_due = b.bill_amt
--FROM	mgr.ma_billsch_restructure  b, 
--		mgr.ma_mship c, 
--		mgr.ar_debtor d
--WHERE	b.mship_id			= c.MSHIP_ID
--AND		c.DEBTOR_ACCT		= d.debtor_acct
--AND		b.restructure_type	= 'D' 
--AND		b.restructure_level = (	SELECT ISNULL(MAX(a.restructure_level),0) 
--								FROM   mgr.ma_billsch_restructure a	
--								WHERE  b.mship_id = a.MSHIP_ID AND a.restructure_type = 'D')
--AND		d.debtor_acct		= @f_debtor_acct
--and		b.stg_no			= 1

--IF @f_md_past_due IS NULL SELECT @f_md_past_due = 0
----------------------------------------------------------------------------------------

IF @f_lessbf > 0 
	SELECT @f_bal_bf = @f_bal_bf - @f_prev_alloc_amt

	IF @rt_filter_flag = 'N'
	BEGIN            
		IF  @f_stmnt_no	= 0 
		BEGIN
			EXEC mgr.x_get_next_number 'statement_no', 'mgr', '', @f_stmnt_no OUTPUT	
		END   	
    
		INSERT INTO mgr.ar_stmnt_hd (
			debtor_acct,		mship_id,			name,						mship_type,
			contact_person,		mail_addr1,			mail_addr2,					mail_addr3,
			mail_post_cd,		status,				advance_amt,				deposit_amt,		
			age1_amt,			statement_type,		age2_amt,					age3_amt,
			age4_amt,			age5_amt,			age6_amt,					balance_bf,
			start_date,			end_date,			circular_code,				giro,
			cumulative_bal,		current_bal,		pay_due,					generated_by,
			ppd_amt,			statement_no,		PayDesc,					PayAmt,
			InterestDesc,		InterestAmt,		ChargesDesc,				Charges,
			DepositDesc,	    DepositDesc2,		Deposit,					RebatesDesc,		
			Rebates,	        AdjustmentDesc,		Adjustments,				DepositBalancebfDesc,		
			DepositBalancebf,	seqno,				AdjustmentDesc2,			Adjustments2,
			mf_statement_date,	mf_due_date,		mf_monthly_amortization,	mf_amount_due,	
			mf_purchase_price,	mf_total_paid,		mf_balance,					mf_last_paydate, 
			mf_last_payamount,	mf_covered_month,	mf_last_desc,
			md_current_dues,	md_amout_due,		md_last_paydate,	
			md_last_payamount,	md_last_desc,		md_terms,
			md_past_due,		md_no_months,		md_total_past_due  )
		VALUES (
			@f_debtor_acct,			@f_mship_id,		@f_name,					@f_mship_type,
			@f_contact_person, 		@f_addr1,			@f_addr2,					@f_addr3,
			@f_postcode,			@f_status,			@f_advance_amt,				@f_deposit_amt,
			@f_age1_amt,			'I',				@f_age2_amt,				@f_age3_amt,		
			@f_age4_amt,			@f_age5_amt,		@f_age6_amt,				@f_bal_bf,
			@rt_start_date,			@rt_end_date,		@rt_circular_cd,			@f_giro_ind,
			@f_cumulative_bal,		@f_current_bal,		@rt_pay_due,				system_user,
			@f_ppd_amt,				@f_stmnt_no,		@PayDesc,					@PayAmt,
			@InterestDesc,			@InterestAmt,		@ChargesDesc,				@Charges,
			@DepositDesc,			@DepositDesc2,		@Deposit,					@RebatesDesc,		
			@Rebates,				@AdjustmentDesc,	@Adjustments,				@DepositBalancebfDesc,		
			@DepositBalancebf,		@f_seqno,			@AdjustmentDesc2,			@Adjustments2,
			@f_mf_statement_date,	@f_mf_due_date,		@f_mf_monthly_amortization,	@f_mf_amount_due,	
			@f_mf_purchase_price,	@f_mf_total_paid,	@f_mf_balance,				@f_mf_last_paydate, 
			@f_mf_last_payamount,	getdate(),			@f_mf_last_desc,
			@f_md_current_dues,		@f_md_amout_due,	@f_md_last_paydate,
			@f_md_last_payamount,	@f_md_last_desc,	@f_md_terms,
			@f_md_past_due,			@f_md_no_months,	@f_md_total_past_due
			)     
		IF @@ERROR <> 0 
		BEGIN
			ROLLBACK TRANSACTION
			RAISERROR( "Could not insert into ar_stmnt_hd file.",16,-1)
			RETURN
		END
	END
	ELSE
	BEGIN
    IF @f_print_cnt > 0 OR @f_bal_bf <> 0
    BEGIN
		IF @f_stmnt_no = 0 
		BEGIN	
			EXEC mgr.x_get_next_number 'statement_no','mgr','',@f_stmnt_no OUTPUT	
		END 	  	

		INSERT INTO mgr.ar_stmnt_hd (
			debtor_acct,		mship_id,			name,						mship_type,
			contact_person,		mail_addr1,			mail_addr2,					mail_addr3,
			mail_post_cd,		status,				advance_amt,				deposit_amt,		
			age1_amt,			statement_type,		age2_amt,					age3_amt,
			age4_amt,			age5_amt,			age6_amt,					balance_bf,
			start_date,			end_date,			circular_code,				giro,
			cumulative_bal,		current_bal,		pay_due,					generated_by,
			ppd_amt,			statement_No,		PayDesc,					PayAmt,
			InterestDesc,		InterestAmt,		ChargesDesc,				Charges,
			DepositDesc,	    DepositDesc2,		Deposit,					RebatesDesc,		
			Rebates,	        AdjustmentDesc,		Adjustments,				DepositBalancebfDesc,		
			DepositBalancebf, 	seqno, 				AdjustmentDesc2,			Adjustments2,
			mf_statement_date,	mf_due_date,		mf_monthly_amortization,	mf_amount_due,	
			mf_purchase_price,	mf_total_paid,		mf_balance,					mf_last_paydate, 
			mf_last_payamount,	mf_covered_month,	mf_last_desc,
			md_current_dues,	md_amout_due,		md_last_paydate,	
			md_last_payamount,	md_last_desc,		md_terms,
			md_past_due,		md_no_months,		md_total_past_due  )                    
		VALUES (
			@f_debtor_acct,			@f_mship_id,		@f_name,					@f_mship_type,
			@f_contact_person, 		@f_addr1,			@f_addr2,					@f_addr3,
			@f_postcode,			@f_status,			@f_advance_amt,				@f_deposit_amt,
			@f_age1_amt,			'I',				@f_age2_amt,				@f_age3_amt,		
			@f_age4_amt,			@f_age5_amt,		@f_age6_amt,				@f_bal_bf,
			@rt_start_date,			@rt_end_date,		@rt_circular_cd,			@f_giro_ind,
			@f_cumulative_bal,		@f_current_bal,		@rt_pay_due,				system_user,
			@f_ppd_amt,				@f_stmnt_no,		@PayDesc,					@PayAmt,
			@InterestDesc,			@InterestAmt,		@ChargesDesc,				@Charges,
			@DepositDesc,			@DepositDesc2,		@Deposit,					@RebatesDesc,		
			@Rebates,				@AdjustmentDesc,	@Adjustments,				@DepositBalancebfDesc,		
			@DepositBalancebf,		@f_seqno,			@AdjustmentDesc2,			@Adjustments2,
			@f_mf_statement_date,	@f_mf_due_date,		@f_mf_monthly_amortization,	@f_mf_amount_due,	
			@f_mf_purchase_price,	@f_mf_total_paid,	@f_mf_balance,				@f_mf_last_paydate, 
			@f_mf_last_payamount,	getdate(),			@f_mf_last_desc,
			@f_md_current_dues,		@f_md_amout_due,	@f_md_last_paydate,
			@f_md_last_payamount,	@f_md_last_desc,	@f_md_terms,
			@f_md_past_due,			@f_md_no_months,	@f_md_total_past_due
			)     
		IF @@ERROR <> 0 
		BEGIN
			ROLLBACK TRANSACTION
			RAISERROR( "Could not insert into ar_stmnt_hd file.",16,-1)
			RETURN
		END
	END
	---rsgerman09292021 INSERT CODE HERE
	--
	--
	--
	--
	--
	--
	--
	
END

SELECT @f_cnt  = COUNT(*) FROM  mgr.ar_stmnt_dt WHERE debtor_acct = @f_debtor_acct
SELECT @f_cnt2 = COUNT(*) FROM  mgr.ar_stmnt_hd WHERE debtor_acct = @f_debtor_acct
IF @@ERROR <> 0
BEGIN
	ROLLBACK TRANSACTION
	RAISERROR( "Could not read ar_stmnt_dt file.",16,-1)
	RETURN
END
ELSE
BEGIN
	IF @f_cnt = 0 AND @f_cnt2 > 0 AND @f_bal_bf <> 0
	BEGIN
		IF @f_ok = 1 
		BEGIN	
			EXEC mgr.x_get_next_number 'statement_no', 'mgr', '',  @f_stmnt_no	OUTPUT
			SELECT @f_ok	= 0	
		END  	  

		INSERT INTO mgr.ar_stmnt_dt (
			debtor_acct,	mship_id,		member_id,		doc_no,		
			doc_date,		ref_no,			trx_mode,		trx_type,	
			descs,			doc_amt,		currency_cd,	fdoc_amt,
			member_flag,	class,			statement_type,	print_flag, 
			ref_code, 		generated_by,	statement_no,	seqno )
		VALUES (
			@f_debtor_acct, @f_debtor_acct,	@f_debtor_acct, '-',
			NULL,			'-',			'D',			'',
			'',				0.00,			'',				0.00,
			'I',			'',				'I',			'Y',
			'',				system_user,	@f_stmnt_no,	@f_seqno )
		IF @@ERROR <> 0 
		BEGIN
			ROLLBACK TRANSACTION
			RAISERROR( "Could not insert into ar_stmnt_hd file (DUMMY).",16,-1)
			RETURN
		END
		SELECT @f_seqno = @f_seqno + 1
	END
END
COMMIT TRANSACTION
RETURN
--/* End Of Procedure */











