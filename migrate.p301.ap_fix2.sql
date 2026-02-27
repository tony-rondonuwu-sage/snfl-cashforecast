----------------------------------------------------------------------------
-- Fix AP Bill miising fields

CREATE OR REPLACE SECURE VIEW ACCOUNTS_PAYABLE_BILL
 COMMENT =  "Version=5d46b435-b116-4379-9a89-9ca3a2b867f9 " 
 AS
SELECT
 
    -- 	end custom fields
    accounts_payable_bill.cny_ AS cnyNumber,
    accounts_payable_bill.recordid AS billnumber ,
    accounts_payable_bill.whencreated AS createddate ,
    accounts_payable_bill.description AS description ,
    accounts_payable_bill.whendiscount AS discountcutoffdate ,
    accounts_payable_bill.whendue AS duedate ,
    accounts_payable_bill.record_ AS id ,
    accounts_payable_bill.record_ AS key ,
    accounts_payable_bill.onhold AS isonhold ,
    accounts_payable_bill.systemgenerated AS issystemgenerated ,
    accounts_payable_bill.inclusivetax AS istaxinclusive ,
    accounts_payable_bill.paymentpriority AS paymentpriority ,
    accounts_payable_bill.recpaymentdate AS recommendedpaymentdate ,
    accounts_payable_bill.recordtype AS recordtype ,
    accounts_payable_bill.docnumber AS referencenumber ,
    accounts_payable_bill.modulekey AS sourcemodule ,
    accounts_payable_bill.state AS rawstate ,
    accounts_payable_bill.totalentered AS totalbaseamount ,
    accounts_payable_bill.totaldue AS totalbaseamountdue ,
    accounts_payable_bill.trx_totalentered AS totaltxnamount ,
    accounts_payable_bill.trx_totaldue AS totaltxnamountdue ,
    accounts_payable_bill.createdby AS audit_createdby ,
    accounts_payable_bill.modifiedby AS audit_modifiedby ,
    audit_createdByUser.loginid                        AS audit_createdByUser_id,
    audit_modifiedByUser.loginid                       AS audit_modifiedByUser_id,
    accounts_payable_bill.whencreated AS audit_createddatetime ,
    accounts_payable_bill.whenmodified AS audit_modifieddatetime ,
    accounts_payable_bill.basecurr AS currency_basecurrency ,
    accounts_payable_bill.currency AS currency_txncurrency ,
    accounts_payable_bill.whenpaid AS paymentinformation_fullypaiddate ,
    accounts_payable_bill.totalpaid AS paymentinformation_totalbaseamountpaid ,
    accounts_payable_bill.totalselected AS paymentinformation_totalbaseamountselectedforpayment ,
    accounts_payable_bill.trx_totalpaid AS paymentinformation_totaltxnamountpaid ,
    accounts_payable_bill.trx_totalselected AS paymentinformation_totaltxnamountselectedforpayment ,
    accounts_payable_bill.retainagepercentage AS retainage_defaultpercentage ,
    accounts_payable_bill.totalretained AS retainage_totalbaseamountretained ,
    accounts_payable_bill.trx_totalreleased AS retainage_totaltxnamountreleased ,
    accounts_payable_bill.trx_totalretained AS retainage_totaltxnamountretained ,
    accounts_payable_bill.prbatchkey AS billsummary_id ,
    accounts_payable_bill.locationkey AS location_key ,
    accounts_payable_bill.description2 AS purchasing_id ,
    accounts_payable_bill.schopkey AS recurringschedule_id ,
    accounts_payable_bill.taxsolutionkey AS taxsolution_key ,
    accounts_payable_bill.termkey AS term_key ,
    accounts_payable_bill.vendorkey AS vendor_key ,
    vendor.totaldue AS vendor_vendordue,
    vendor.totaldue AS vendor_id,
    CASE
        WHEN accounts_payable_bill.STATE = 'V' THEN 'Reversal'
        WHEN accounts_payable_bill.STATE = 'D' THEN 'Draft'
        WHEN accounts_payable_bill.STATE = 'PA' THEN 'Partially Approved'
        WHEN accounts_payable_bill.STATE = 'S' THEN 'Submitted'
        WHEN accounts_payable_bill.STATE = 'U' THEN 'Declined'
        WHEN accounts_payable_bill.TRX_TOTALENTERED = 0 THEN 'No Value'
        WHEN accounts_payable_bill.TRX_TOTALSELECTED = 0
             AND accounts_payable_bill.TRX_TOTALPAID = 0 THEN 'Posted'
        WHEN accounts_payable_bill.TRX_TOTALDUE = 0 THEN 'Paid'
        WHEN accounts_payable_bill.TRX_TOTALSELECTED != 0 THEN 'Selected'
        WHEN accounts_payable_bill.TRX_TOTALPAID != 0 THEN 'Partially Paid'
        ELSE accounts_payable_bill.STATE
    END AS state
FROM  SIF_SAGE_VIEWS.V_SA_prrecord  accounts_payable_bill

LEFT JOIN SIF_SAGE_VIEWS.V_SA_userinfo audit_createdbyuser ON audit_createdbyuser.cny_ = accounts_payable_bill.cny_ and audit_createdbyuser.record_ = accounts_payable_bill.createdby 
LEFT JOIN SIF_SAGE_VIEWS.V_SA_userinfo audit_modifiedbyuser ON audit_modifiedbyuser.cny_ = accounts_payable_bill.cny_ and audit_modifiedbyuser.record_ = accounts_payable_bill.modifiedby 
-- LEFT JOIN SIF_SAGE_VIEWS.V_SA_TAXSOLUTION taxsolution ON taxsolution.cny_ = accounts_payable_bill.cny_ and taxsolution.record_ = accounts_payable_bill.taxsolutionkey
-- LEFT JOIN SIF_SAGE_VIEWS.V_SA_TERM term ON term.cny_ = accounts_payable_bill.cny_ and term.record_ = accounts_payable_bill.termkey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_vendor vendor ON vendor.cny_ = accounts_payable_bill.cny_ and vendor.record_ = accounts_payable_bill.vendorkey 
-- LEFT JOIN SIF_SAGE_VIEWS.V_SA_LOCATION melocation ON melocation.cny_ = accounts_payable_bill.cny_ and melocation.record_ = accounts_payable_bill.locationkey
-- LEFT JOIN SIF_SAGE_VIEWS.V_SA_PRBATCH batch ON batch.cny_ = accounts_payable_bill.cny_ and batch.record_ = accounts_payable_bill.prbatchkey
-- LEFT JOIN SIF_SAGE_VIEWS.V_SA_EXCHANGERATEINFO exchangerateinfo ON exchangerateinfo.cny_ = accounts_payable_bill.cny_ and exchangerateinfo.recordkey = accounts_payable_bill.record_

WHERE accounts_payable_bill.recordtype = 'pi'

;


----------------------------------------------------------------------------

------ CONTENT OF accounts_payable_payment_detail

CREATE OR REPLACE SECURE VIEW accounts_payable_payment_detail
  WITH ROW ACCESS POLICY MAIN_DBACCT_DB.SIF_REPLICATION_SCHEMA.ENFORCE_COMPANY_ACCESS ON (cnyNumber)
  AS
SELECT
    accounts_payable_payment_detail.cny_ AS cnyNumber,
    accounts_payable_payment_detail.DISCOUNTDATE AS discountDate,
    accounts_payable_payment_detail.RECORD_ AS id,
    accounts_payable_payment_detail.RECORD_ AS key,
    accounts_payable_payment_detail.MODULEKEY AS moduleKey,
    accounts_payable_payment_detail.PAYMENTDATE AS paymentDate,
    accounts_payable_payment_detail.STATE AS state,
    accounts_payable_payment_detail.createdby AS audit_createdBy,
    accounts_payable_payment_detail.whencreated AS audit_createdDateTime,
    accounts_payable_payment_detail.modifiedby AS audit_modifiedBy,
    accounts_payable_payment_detail.whenmodified AS audit_modifiedDateTime,
    audit_createdByUser.loginid AS audit_createdByUser_id,
    audit_modifiedByUser.loginid AS audit_modifiedByUser_id,
    accounts_payable_payment_detail.adjustmentamount AS baseCurrency_adjustmentAmount,
    accounts_payable_payment_detail.discountamount AS baseCurrency_discountAmount,
    accounts_payable_payment_detail.inlineamount AS baseCurrency_inlineAmount,
    accounts_payable_payment_detail.paymentamount AS baseCurrency_paymentAmount,
    accounts_payable_payment_detail.postedadvanceamount AS baseCurrency_postedAdvanceAmount,
    accounts_payable_payment_detail.trx_adjustmentamount AS txnCurrency_adjustmentAmount,
    accounts_payable_payment_detail.currency AS txnCurrency_currency,
    accounts_payable_payment_detail.trx_discountamount AS txnCurrency_discountAmount,
    accounts_payable_payment_detail.trx_inlineamount AS txnCurrency_inlineAmount,
    accounts_payable_payment_detail.trx_paymentamount AS txnCurrency_paymentAmount,
    accounts_payable_payment_detail.trx_postedadvanceamount AS txnCurrency_postedAdvanceAmount,
    accounts_payable_payment_detail.advancekey AS apAdvance_id,
    accounts_payable_payment_detail.advanceentrykey AS apAdvanceLine_id,
    accounts_payable_payment_detail.posadjkey AS apCreditAdjustment_id,
    accounts_payable_payment_detail.posadjentrykey AS apCreditAdjustmentLine_id,
    accounts_payable_payment_detail.adjustmentkey AS apDebitAdjustment_id,
    accounts_payable_payment_detail.adjustmententrykey AS apDebitAdjustmentLine_id,
    accounts_payable_payment_detail.paymentkey AS apPayment_id,
    accounts_payable_payment_detail.paymententrykey AS apPaymentLine_id,
    accounts_payable_payment_detail.postedadvancekey AS apPostedAdvance_id,
    accounts_payable_payment_detail.postedadvanceentrykey AS apPostedAdvanceLine_id,
    accounts_payable_payment_detail.recordkey AS bill_id,
    accounts_payable_payment_detail.entrykey AS billLine_id,
    accounts_payable_payment_detail.inlinekey AS inlineBill_id,
    accounts_payable_payment_detail.inlineentrykey AS inlineBillLine_id
    -- accounts_payable_payment_detail.jointpayee.record_ AS jointPayee_id,
    -- accounts_payable_payment_detail.jointpayee.jointpayeeprintas AS jointPayee_printAs
FROM
    ICRW_SCHEMA.pymtdetailmst accounts_payable_payment_detail
LEFT JOIN SIF_SAGE_VIEWS.v_sa_userinfo audit_createdByUser ON audit_createdByUser.CNY_ = accounts_payable_payment_detail.CNY_ AND audit_createdByUser.record_ = accounts_payable_payment_detail.createdby
LEFT JOIN SIF_SAGE_VIEWS.v_sa_userinfo audit_modifiedByUser ON audit_modifiedByUser.CNY_ = accounts_payable_payment_detail.CNY_ AND audit_modifiedByUser.record_ = accounts_payable_payment_detail.modifiedby
WHERE accounts_payable_payment_detail.modulekey = '3.AP'
;



