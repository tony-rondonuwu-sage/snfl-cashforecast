------ CONTENT OF accounts_receivable_payment_detail

CREATE OR REPLACE VIEW accounts_receivable_payment_detail
  WITH ROW ACCESS POLICY MAIN_DBACCT_DB.SIF_REPLICATION_SCHEMA.ENFORCE_COMPANY_ACCESS ON (cnyNumber)
  AS
SELECT
    accounts_receivable_payment_detail.cny_ AS cnyNumber,
    -- Main fields
    accounts_receivable_payment_detail.DISCOUNTDATE AS discountDate,
    accounts_receivable_payment_detail.RECORD_ AS id,
    accounts_receivable_payment_detail.RECORD_ AS key,
    accounts_receivable_payment_detail.PAYMENTDATE AS paymentDate,
    -- Audit fields
    accounts_receivable_payment_detail.createdby AS audit_createdBy,
    accounts_receivable_payment_detail.whencreated AS audit_createdDateTime,
    accounts_receivable_payment_detail.modifiedby AS audit_modifiedBy,
    accounts_receivable_payment_detail.whenmodified AS audit_modifiedDateTime,
    audit_createdByUser.loginid AS audit_createdByUser_id,
    audit_modifiedByUser.loginid AS audit_modifiedByUser_id,
    -- Base Currency
    accounts_receivable_payment_detail.adjustmentamount AS baseCurrency_adjustmentAmount,
    accounts_receivable_payment_detail.inlineamount AS baseCurrency_inlineAmount,
    accounts_receivable_payment_detail.negbillinvamount AS baseCurrency_negativeInvoiceAmount,
    accounts_receivable_payment_detail.paymentamount AS baseCurrency_paymentAmount,
    accounts_receivable_payment_detail.postedadvanceamount AS baseCurrency_postedAdvanceAmount,
    accounts_receivable_payment_detail.postedoverpaymentamount AS baseCurrency_postedOverPaymentAmount,
    -- Transaction Currency
    accounts_receivable_payment_detail.trx_adjustmentamount AS txnCurrency_adjustmentAmount,
    accounts_receivable_payment_detail.currency AS txnCurrency_currency,
    accounts_receivable_payment_detail.trx_inlineamount AS txnCurrency_inlineAmount,
    accounts_receivable_payment_detail.trx_negbillinvamount AS txnCurrency_negativeInvoiceAmount,
    accounts_receivable_payment_detail.trx_paymentamount AS txnCurrency_paymentAmount,
    accounts_receivable_payment_detail.trx_postedadvanceamount AS txnCurrency_postedAdvanceAmount,
    accounts_receivable_payment_detail.trx_postedoverpaymentamount AS txnCurrency_postedOverPaymentAmount,
    -- AR References
    accounts_receivable_payment_detail.adjustmentkey AS arAdjustment_id,
    accounts_receivable_payment_detail.adjustmententrykey AS arAdjustmentLine_id,
    accounts_receivable_payment_detail.advancekey AS arAdvance_id,
    accounts_receivable_payment_detail.advanceentrykey AS arAdvanceLine_id,
    accounts_receivable_payment_detail.recordkey AS arInvoice_id,
    accounts_receivable_payment_detail.entrykey AS arInvoiceLine_id,
    accounts_receivable_payment_detail.paymentkey AS arPayment_id,
    accounts_receivable_payment_detail.paymententrykey AS arPaymentLine_id,
    accounts_receivable_payment_detail.overpaymentkey AS arPostedOverPayment_id,
    accounts_receivable_payment_detail.overpaymententrykey AS arPostedOverPaymentLine_id,
    -- Other References
    accounts_receivable_payment_detail.inlinekey AS inlineTxn_id,
    accounts_receivable_payment_detail.inlineentrykey AS inlineTxnLine_id,
    accounts_receivable_payment_detail.negbillinvkey AS negativeInvoice_id,
    accounts_receivable_payment_detail.negbillinventrykey AS negativeInvoiceLine_id,
    accounts_receivable_payment_detail.posadjkey AS positiveAdjustment_id,
    accounts_receivable_payment_detail.posadjentrykey AS positiveAdjustmentLine_id,
    accounts_receivable_payment_detail.postedadvancekey AS postedAdvance_id,
    accounts_receivable_payment_detail.postedadvanceentrykey AS postedAdvanceLine_id,
    accounts_receivable_payment_detail.postedoverpaymentkey AS postedOverPayment_id,
    accounts_receivable_payment_detail.postedoverpaymententrykey AS postedOverPaymentLine_id
FROM ICRW_SCHEMA.pymtdetailmst accounts_receivable_payment_detail
-- Audit joins
LEFT JOIN SIF_SAGE_VIEWS.v_sa_userinfo audit_createdByUser ON audit_createdByUser.CNY_ = accounts_receivable_payment_detail.CNY_ AND audit_createdByUser.record_ = accounts_receivable_payment_detail.createdby
LEFT JOIN SIF_SAGE_VIEWS.v_sa_userinfo audit_modifiedByUser ON audit_modifiedByUser.CNY_ = accounts_receivable_payment_detail.CNY_ AND audit_modifiedByUser.record_ = accounts_receivable_payment_detail.modifiedby
WHERE accounts_receivable_payment_detail.modulekey = '4.AR'
;


------ CONTENT OF company_config_location


CREATE OR REPLACE SECURE VIEW COMPANY_CONFIG_LOCATION
 COMMENT =  "Version=5d46b435-b116-4379-9a89-9ca3a2b867f9 "
 AS SELECT

-- 	end custom fields
company_config_location.cny_ AS cnyNumber,
company_config_location.end_date AS enddate ,
company_config_location.location_no AS id ,
company_config_location.record_ AS key ,
company_config_location.custtitle AS locationreportingtitle ,
company_config_location.name AS name ,
company_config_location.start_date AS startdate ,
company_config_location.status AS status ,
company_config_location.taxid AS taxid ,
company_config_location.createdby AS audit_createdby ,
company_config_location.whencreated AS audit_createddatetime ,
company_config_location.modifiedby AS audit_modifiedby ,
company_config_location.whenmodified AS audit_modifieddatetime ,
contacts_primary.name AS contactinfo_contactname ,
contacts_primary.record_ AS contactkey ,
contacts_shipto.name AS shipto_contactname ,
contacts_shipto.record_ AS shiptokey ,
manageremp.record_ AS manager_key ,
mcontact.name AS manager_name ,
parent.location_no AS parent_id ,
company_config_location.parentkey AS parent_key ,
parent.name AS parent_name,
entity.location_no AS entity_id,
company_config_location.entitykey AS entity_key,
entity.name AS entity_name
FROM  SIF_SAGE_VIEWS.V_SA_location  company_config_location

LEFT JOIN SIF_SAGE_VIEWS.V_SA_userinfo audit_createdbyuser ON audit_createdbyuser.cny_ = company_config_location.cny_ and audit_createdbyuser.record_ = company_config_location.createdby
LEFT JOIN SIF_SAGE_VIEWS.V_SA_userinfo audit_modifiedbyuser ON audit_modifiedbyuser.cny_ = company_config_location.cny_ and audit_modifiedbyuser.record_ = company_config_location.modifiedby
LEFT JOIN SIF_SAGE_VIEWS.V_SA_contact contacts_primary ON contacts_primary.cny_ = company_config_location.cny_ and contacts_primary.record_ = company_config_location.contactkey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_contact contacts_shipto ON contacts_shipto.cny_ = company_config_location.cny_ and contacts_shipto.record_ = company_config_location.shiptokey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_location parent ON parent.cny_ = company_config_location.cny_ and parent.record_ = company_config_location.parentkey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_employee manageremp ON manageremp.cny_ = company_config_location.cny_ and manageremp.employeeid = company_config_location.employeekey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_contact mcontact ON manageremp.cny_ = company_config_location.cny_ and manageremp.employeeid = company_config_location.employeekey and mcontact.cny_ = company_config_location.cny_  and mcontact.record_ = manageremp.contactkey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_LOCATION entity ON entity.cny_ = company_config_location.cny_ AND entity.record_ = company_config_location.entitykey

;
