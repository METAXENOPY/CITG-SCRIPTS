SELECT * FROM mgr.ar_paytrx WHERE doc_no LIKE '%RC%' ORDER BY doc_no ASC
SELECT * FROM mgr.ar_paytrx WHERE batch_no LIKE '%27544%'

SELECT  mgr.cf_document_ctl.prefix ,           mgr.cf_document_ctl.entity_cd ,           mgr.cf_document_ctl.descs ,
mgr.cf_document_ctl.auto_gen_flag ,           mgr.cf_document_ctl.next_doc_no ,           mgr.cf_document_ctl.audit_user ,
mgr.cf_document_ctl.audit_date ,           mgr.cf_document_ctl.print_hdr     FROM mgr.cf_document_ctl   WHERE entity_cd = 'CU'  ORDER BY mgr.cf_document_ctl.prefix          ASC

-- TO UPDATE THE DOCUMENT NUMBER
UPDATE mgr.cf_document_ctl
SET next_doc_no = '3011894'
WHERE prefix = 'RC'
