  --CHANGE DEBTOR,MEMBERSHIP IDs on IFCA v2 System - Licensee
    
  use dclubar_cu_live
  go
  
  
  
  SELECT * FROM mgr.cf_business WHERE seq_no = 79133
  SELECT * FROM mgr.MA_MSHIP WHERE seq_no = 79133
  SELECT * FROM mgr.AR_DEBTOR WHERE DEBTOR_ACCT = '69767-00'
  SELECT * FROM mgr.interface_member WHERE v_debtor_acct = '69767-00'
  
  UPDATE mgr.AR_DEBTOR
  SET debtor_acct = '69767'
  WHERE seq_no = 79133
  UPDATE mgr.MA_MSHIP
  SET MSHIP_ID = '69767',DEBTOR_ACCT = '69767'
  WHERE seq_no = 79133
  UPDATE mgr.interface_member
  SET v_debtor_acct = '69767',v_member_id = '69767'
  WHERE v_seq_no = 79133