/*
accounts_payable_payment_detail
accounts_payable_payment
accounts_payable_payment_line
accounts_payable_vendor
accounts_payable_bill
accounts_payable_bill_line
accounts_payable_term

accounts_receivable_payment
accounts_receivable_payment_line
accounts_receivable_customer
accounts_receivable_invoice
accounts_receivable_invoice_line
accounts_receivable_term
company_config_location
*/


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


------ CONTENT OF accounts_payable_payment

CREATE
OR REPLACE SECURE VIEW ACCOUNTS_PAYABLE_PAYMENT
 COMMENT =  "Version=5d46b435-b116-4379-9a89-9ca3a2b867f9 " 
 AS
SELECT

    -- 	end custom fields
    accounts_payable_payment.cny_         AS cnyNumber,
    accounts_payable_payment.cleared      AS cleared,
    accounts_payable_payment.clrdate      AS cleareddate,
    accounts_payable_payment.description  AS description,
    accounts_payable_payment.description2 AS documentid,
    accounts_payable_payment.docnumber    AS documentnumber,
    accounts_payable_payment.record_      AS id,
    accounts_payable_payment.record_ AS key ,
    accounts_payable_payment.inclusivetax AS isinclusivetax ,
    accounts_payable_payment.paymethodkey AS paymentmethodkey ,
    accounts_payable_payment.paymentrequestmethod AS paymentrequestmethod ,
    accounts_payable_payment.recordtype AS recordtype ,
    accounts_payable_payment.state AS state ,
    accounts_payable_payment.systemgenerated AS systemgenerated ,
    accounts_payable_payment.whencreated AS txndate ,
    accounts_payable_payment.whenpaid AS txnpaiddate ,
    accounts_payable_payment.createdby AS audit_createdby ,
    accounts_payable_payment.auwhencreated AS audit_createddatetime ,
    accounts_payable_payment.modifiedby AS audit_modifiedby ,
    accounts_payable_payment.whenmodified AS audit_modifieddatetime ,
    accounts_payable_payment.basecurr AS basecurrency_currency ,
    accounts_payable_payment.totalentered AS basecurrency_totalamount ,
    accounts_payable_payment.totaldue AS basecurrency_totaldue ,
    accounts_payable_payment.totalpaid AS basecurrency_totalpaid ,
    accounts_payable_payment.totalselected AS basecurrency_totalselected ,
    accounts_payable_payment.currency AS txncurrency_currency ,
    accounts_payable_payment.trx_totalentered AS txncurrency_totalamount ,
    accounts_payable_payment.trx_totaldue AS txncurrency_totaldue ,
    accounts_payable_payment.trx_totalpaid AS txncurrency_totalpaid ,
    accounts_payable_payment.trx_totalselected AS txncurrency_totalselected ,
    accounts_payable_payment.locationkey AS entity_key ,
    accounts_payable_payment.financialentity AS financialentity_id ,
    accounts_payable_payment.providerkey AS paymentprovider_key ,
    accounts_payable_payment.taxsolutionkey AS taxsolution_key ,
    accounts_payable_payment.entity AS vendor_entity ,
    accounts_payable_payment.vendorkey AS vendor_key ,
    vendor.vendorid AS vendor_id,
    vendor.name AS vendor_name,
    audit_createdByUser.loginid AS audit_createdByUser_id,
    audit_modifiedByUser.loginid AS audit_modifiedByUser_id,
    melocation.name AS entity_name ,
    exchangerateinfo.exch_rate_date AS exchangeRate_date,
    exchangerateinfo.exchange_rate AS exchangeRate_rate,
    exchangerateinfo.exch_rate_type_id AS EXCHANGERATE_TYPEID,
    accounts_payable_payment.prbatchkey AS paymentSummary_id,
    batch.title AS paymentSummary_title,
    batch.created AS paymentSummary_receiptDate,
    batch.undepfundsacct AS undepositedGLAccount_key,
    accounts_payable_payment.billtopaytokey AS payTo_key,
    payTo.name AS payTo_id

FROM SIF_SAGE_VIEWS.V_SA_prrecord accounts_payable_payment
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_userinfo audit_createdbyuser ON audit_createdbyuser.cny_ = accounts_payable_payment.cny_ and audit_createdbyuser.record_ = accounts_payable_payment.createdby
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_userinfo audit_modifiedbyuser ON audit_modifiedbyuser.cny_ = accounts_payable_payment.cny_ and audit_modifiedbyuser.record_ = accounts_payable_payment.modifiedby
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_LOCATION melocation ON melocation.cny_ = accounts_payable_payment.cny_ and melocation.record_ = accounts_payable_payment.locationkey
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_EXCHANGERATEINFO exchangerateinfo ON exchangerateinfo.cny_ = accounts_payable_payment.cny_ and exchangerateinfo.recordkey = accounts_payable_payment.record_
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_TAXSOLUTION taxsolution ON taxsolution.cny_ = accounts_payable_payment.cny_ and taxsolution.record_ = accounts_payable_payment.taxsolutionkey
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_vendor vendor ON vendor.cny_ = accounts_payable_payment.cny_ and vendor.record_ = accounts_payable_payment.vendorkey
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_PRBATCH batch ON batch.cny_ = accounts_payable_payment.cny_ and batch.record_ = accounts_payable_payment.prbatchkey
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_CONTACT payto ON payto.cny_ = accounts_payable_payment.cny_ and payto.record_ = accounts_payable_payment.billtopaytokey
WHERE accounts_payable_payment.recordtype in ('pp')

;


------ CONTENT OF accounts_payable_payment_line   


CREATE OR REPLACE SECURE VIEW ACCOUNTS_PAYABLE_PAYMENT_LINE
 COMMENT =  "Version=5d46b435-b116-4379-9a89-9ca3a2b867f9 " 
 AS
SELECT
 
    -- 	end custom fields
    accounts_payable_payment_line.cny_ AS cnyNumber,
    accounts_payable_payment_line.baselocation AS baselocation ,
    accounts_payable_payment_line.description AS description ,
    accounts_payable_payment_line.record_ AS id ,
    accounts_payable_payment_line.record_ AS key ,
    accounts_payable_payment_line.istax AS istax ,
    accounts_payable_payment_line.line_no AS linenumber ,
    accounts_payable_payment_line.recordtype AS recordtype ,
    accounts_payable_payment_line.createdby AS audit_createdby ,
    accounts_payable_payment_line.whencreated AS audit_createddatetime ,
    accounts_payable_payment_line.modifiedby AS audit_modifiedby ,
    accounts_payable_payment_line.whenmodified AS audit_modifieddatetime ,
    audit_createdByUser.loginid                        AS audit_createdByUser_id,
    audit_modifiedByUser.loginid                       AS audit_modifiedByUser_id,
    accounts_payable_payment_line.amount AS basecurrency_amount ,
    accounts_payable_payment_line.basecurr AS basecurrency_currency ,
    accounts_payable_payment_line.totalpaid AS basecurrency_totalpaid ,
    accounts_payable_payment_line.totalselected AS basecurrency_totalselected ,
    dimensions_class.classid                           AS dimensions_class_id,
    dimensions_class.record_                           AS dimensions_class_key,
    dimensions_class.name                              AS dimensions_class_name,
    dimensions_contract.contractid                     AS dimensions_contract_id,
    dimensions_contract.record_                        AS dimensions_contract_key,
    dimensions_contract.name                           AS dimensions_contract_name,
    dimensions_costType.costtypeid                     AS dimensions_costtype_id,
    dimensions_costType.record_                        AS dimensions_costtype_key,
    dimensions_costType.name                           AS dimensions_costtype_name,
    dimensions_customer.customerid                     AS dimensions_customer_id,
    dimensions_customer.record_                        AS dimensions_customer_key,
    dimensions_customer.name                           AS dimensions_customer_name,
    dimensions_department.dept_no                      AS dimensions_department_id,
    dimensions_department.record_                      AS dimensions_department_key,
    dimensions_department.title                        AS dimensions_department_name,
    dimensions_employee.employeeid                     AS dimensions_employee_id,
    dimensions_employee.record_                        AS dimensions_employee_key,
    dimensions_item.itemid                             AS dimensions_item_id,
    dimensions_item.record_                            AS dimensions_item_key,
    dimensions_item.name                               AS dimensions_item_name,
    dimensions_location.location_no                    AS dimensions_location_id,
    dimensions_location.record_                        AS dimensions_location_key,
    dimensions_location.name                           AS dimensions_location_name,
    dimensions_project.projectid                       AS dimensions_project_id,
    dimensions_project.record_                         AS dimensions_project_key,
    dimensions_project.name                            AS dimensions_project_name,
    dimensions_task.taskid                             AS dimensions_task_id,
    dimensions_task.record_                            AS dimensions_task_key,
    dimensions_task.name                               AS dimensions_task_name,
    dimensions_vendor.vendorid                         AS dimensions_vendor_id,
    dimensions_vendor.record_                          AS dimensions_vendor_key,
    dimensions_vendor.name                             AS dimensions_vendor_name,
    dimensions_warehouse.warehouseid                   AS dimensions_warehouse_id,
    dimensions_warehouse.record_                       AS dimensions_warehouse_key,
    dimensions_warehouse.name                          AS dimensions_warehouse_name,
    accounts_payable_payment_line.exch_rate_date AS exchangerate_date ,
    accounts_payable_payment_line.exchange_rate AS exchangerate_rate ,
    accounts_payable_payment_line.exch_rate_type_id AS exchangerate_typeid ,
    accounts_payable_payment_line.trx_amount AS txncurrency_amount ,
    accounts_payable_payment_line.currency AS txncurrency_currency ,
    accounts_payable_payment_line.trx_totalpaid AS txncurrency_totalpaid ,
    accounts_payable_payment_line.trx_totalselected AS txncurrency_totalselected ,
    accounts_payable_payment_line.recordkey AS appayment_id ,
    alloc.allocationid                                 AS allocation_id,
    glaccount.acct_no                                  AS glAccount_id,
    accounts_payable_payment_line.accountkey           AS glAccount_key,
    glaccount.title                                    AS glAccount_name,
    offsetglaccount.acct_no                            AS offsetGLAccount_id,
    accounts_payable_payment_line.offsetaccountkey     AS offsetGLAccount_key
FROM  SIF_SAGE_VIEWS.V_SA_prentry  accounts_payable_payment_line
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_userinfo audit_createdbyuser ON audit_createdbyuser.cny_ = accounts_payable_payment_line.cny_ and audit_createdbyuser.record_ = accounts_payable_payment_line.createdby
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_userinfo audit_modifiedbyuser ON audit_modifiedbyuser.cny_ = accounts_payable_payment_line.cny_ and audit_modifiedbyuser.record_ = accounts_payable_payment_line.modifiedby
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_class dimensions_class ON dimensions_class.cny_ = accounts_payable_payment_line.cny_ and dimensions_class.record_ = accounts_payable_payment_line.classdimkey
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_contract dimensions_contract ON dimensions_contract.cny_ = accounts_payable_payment_line.cny_ and dimensions_contract.record_ = accounts_payable_payment_line.contractdimkey
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_costtype dimensions_costtype ON dimensions_costtype.cny_ = accounts_payable_payment_line.cny_ and dimensions_costtype.record_ = accounts_payable_payment_line.costtypedimkey
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_customer dimensions_customer ON dimensions_customer.cny_ = accounts_payable_payment_line.cny_ and dimensions_customer.record_ = accounts_payable_payment_line.customerdimkey
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_department dimensions_department ON dimensions_department.cny_ = accounts_payable_payment_line.cny_ and dimensions_department.record_ = accounts_payable_payment_line.dept_
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_employee dimensions_employee ON dimensions_employee.cny_ = accounts_payable_payment_line.cny_ and dimensions_employee.record_ = accounts_payable_payment_line.employeedimkey
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_icitem dimensions_item ON dimensions_item.cny_ = accounts_payable_payment_line.cny_ and dimensions_item.record_ = accounts_payable_payment_line.itemdimkey
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_location dimensions_location ON dimensions_location.cny_ = accounts_payable_payment_line.cny_ and dimensions_location.record_ = accounts_payable_payment_line.location_
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_project dimensions_project ON dimensions_project.cny_ = accounts_payable_payment_line.cny_ and dimensions_project.record_ = accounts_payable_payment_line.projectdimkey
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_task dimensions_task ON dimensions_task.cny_ = accounts_payable_payment_line.cny_ and dimensions_task.record_ = accounts_payable_payment_line.taskdimkey
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_vendor dimensions_vendor ON dimensions_vendor.cny_ = accounts_payable_payment_line.cny_ and dimensions_vendor.record_ = accounts_payable_payment_line.vendordimkey
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_icwarehouse dimensions_warehouse ON dimensions_warehouse.cny_ = accounts_payable_payment_line.cny_ and dimensions_warehouse.record_ = accounts_payable_payment_line.warehousedimkey
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_GLACCOUNT glaccount ON glaccount.cny_ = accounts_payable_payment_line.cny_ and glaccount.record_ = accounts_payable_payment_line.accountkey
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_GLACCOUNT offsetglaccount ON offsetglaccount.cny_ = accounts_payable_payment_line.cny_ and offsetglaccount.record_ = accounts_payable_payment_line.offsetaccountkey
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_CONTACT contact ON contact.cny_ = accounts_payable_payment_line.cny_ and contact.record_ = dimensions_employee.contactkey and contact.cny_ = accounts_payable_payment_line.cny_ and dimensions_employee.record_ = accounts_payable_payment_line.employeedimkey
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_ALLOCATION alloc ON alloc.cny_ = accounts_payable_payment_line.cny_ and alloc.record_ = accounts_payable_payment_line.allocationkey
WHERE accounts_payable_payment_line.recordtype in ('pp')

;   

------ CONTENT OF accounts_payable_vendor   


CREATE OR REPLACE SECURE VIEW ACCOUNTS_PAYABLE_VENDOR
 COMMENT =  "Version=5d46b435-b116-4379-9a89-9ca3a2b867f9 " 
 AS
SELECT
 
    -- 	end custom fields
    accounts_payable_vendor.cny_ AS cnyNumber,
    accounts_payable_vendor.alwayscreatebill AS alwayscreatebill ,
    accounts_payable_vendor.billingtype AS billingtype ,
    accounts_payable_vendor.creditlimit AS creditlimit ,
    accounts_payable_vendor.currency AS currency ,
    accounts_payable_vendor.default_lead_time AS defaultleadtime ,
    accounts_payable_vendor.discount AS discountpercent ,
    accounts_payable_vendor.displaytermdiscount AS displaytermdiscountoncheckstub ,
    accounts_payable_vendor.displocacctnocheck AS displayvendoraccountoncheckstub ,
    accounts_payable_vendor.donotcutcheck AS donotpay ,
    accounts_payable_vendor.filepaymentservice AS filepaymentservice ,
    accounts_payable_vendor.vendorid AS id ,
    accounts_payable_vendor.onhold AS isonhold ,
    accounts_payable_vendor.onetime AS isonetimeuse ,
    accounts_payable_vendor.record_ AS key ,
    accounts_payable_vendor.createdby AS audit_createdby ,
    accounts_payable_vendor.whencreated AS audit_createddatetime ,
    accounts_payable_vendor.modifiedby AS audit_modifiedby ,
    accounts_payable_vendor.whenmodified AS audit_modifieddatetime ,
    audit_createdByUser.loginid                        AS audit_createdByUser_id,
    audit_modifiedByUser.loginid                       AS audit_modifiedByUser_id,
    accounts_payable_vendor.mergepaymentreq AS mergepaymentrequests ,
    accounts_payable_vendor.name AS name ,
    accounts_payable_vendor.comments AS notes ,
    accounts_payable_vendor.paymentpriority AS paymentpriority ,
    accounts_payable_vendor.paymethodkey AS preferredpaymentmethod ,
    accounts_payable_vendor.retainagepercentage AS retainagepercentage ,
    accounts_payable_vendor.paymentnotify AS sendpaymentnotification ,
    accounts_payable_vendor.state AS state ,
    accounts_payable_vendor.status AS status ,
    accounts_payable_vendor.taxid AS taxid ,
    accounts_payable_vendor.totaldue AS totaldue ,
    vendoracctno.accountno AS vendoraccountnumber ,
    accounts_payable_vendor.achaccountnumber AS ach_accountnumber ,
    accounts_payable_vendor.achaccounttype AS ach_accounttype ,
    accounts_payable_vendor.achenabled AS ach_enablepayments ,
    accounts_payable_vendor.achremittancetype AS ach_remittancetype ,
    accounts_payable_vendor.achbankroutingnumber AS ach_routingnumber ,
    accounts_payable_vendor.pymtcountrycode AS bankfiles_paymentcountrycode ,
    accounts_payable_vendor.pymtcurrency AS bankfiles_paymentcurrency ,
    accounts_payable_vendor.form1099box AS form1099_box ,
    accounts_payable_vendor.name1099 AS form1099_nameon1099 ,
    accounts_payable_vendor.form1099type AS form1099_type ,
    accounts_payable_vendor.ist5018enabled AS t5018_ist5018enabled ,
    accounts_payable_vendor.t5018number AS t5018_t5018number ,
    accounts_payable_vendor.istparenabled AS tpar_istparenabled ,
    accounts_payable_vendor.nametpar AS tpar_name ,
    glgroup.name AS accountgroup_id ,
    accounts_payable_vendor.glgrpkey AS accountgroup_key ,
    accounts_payable_vendor.accountlabelkey AS accountlabel_key ,
    apaccountlabel.label AS accountlabel_id ,
    accounts_payable_vendor.accountkey AS defaultexpenseglaccount_key ,
    glaccount.acct_no                                  AS defaultexpenseglaccount_id,
    glaccount.title                                    AS defaultexpenseglaccount_name,
    accounts_payable_vendor.locationkey AS entity_key ,
    melocation.name AS entity_name ,
    parent.vendorid AS parent_id ,
    accounts_payable_vendor.parentkey AS parent_key ,
    parent.name AS parent_name ,
    pricelist.name AS pricelist_id ,
    accounts_payable_vendor.oeprclstkey AS pricelist_key ,
    accounts_payable_vendor.oepriceschedkey AS priceschedule_id ,
    term.name AS term_id ,
    accounts_payable_vendor.termskey AS term_key ,
    vendtype.name AS vendortype_id ,
    accounts_payable_vendor.vendtypekey AS vendortype_key
FROM  SIF_SAGE_VIEWS.V_SA_vendor  accounts_payable_vendor
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_userinfo audit_createdbyuser ON audit_createdbyuser.cny_ = accounts_payable_vendor.cny_ and audit_createdbyuser.record_ = accounts_payable_vendor.createdby
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_userinfo audit_modifiedbyuser ON audit_modifiedbyuser.cny_ = accounts_payable_vendor.cny_ and audit_modifiedbyuser.record_ = accounts_payable_vendor.modifiedby
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_ACCOUNTLABEL apaccountlabel ON apaccountlabel.cny_ = accounts_payable_vendor.cny_ and apaccountlabel.record_ = accounts_payable_vendor.accountlabelkey
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_TERM term ON term.cny_ = accounts_payable_vendor.cny_ and term.record_ = accounts_payable_vendor.termskey
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_GLACCOUNT glaccount ON glaccount.cny_ = accounts_payable_vendor.cny_ and glaccount.record_ = accounts_payable_vendor.accountkey
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_LOCATION melocation ON melocation.cny_ = accounts_payable_vendor.cny_ and melocation.record_ = accounts_payable_vendor.locationkey
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_VENDOR parent ON parent.cny_ = accounts_payable_vendor.cny_ and parent.record_ = accounts_payable_vendor.parentkey
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_vendortrxsummary vendortrxsummary ON vendortrxsummary.cny_ = accounts_payable_vendor.cny_ and vendortrxsummary.record_ = accounts_payable_vendor.record_
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_GLACCTGRP glgroup ON glgroup.cny_ = accounts_payable_vendor.cny_ and glgroup.record_ = accounts_payable_vendor.glgrpkey
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_PRICELIST pricelist ON pricelist.recordno = accounts_payable_vendor.oeprclstkey
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_GLACCOUNT apaccount ON apaccount.cny_ = accounts_payable_vendor.cny_ and apaccount.record_ = accounts_payable_vendor.accountkey
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_vendoracctno vendoracctno ON vendoracctno.cny_ = accounts_payable_vendor.cny_ and vendoracctno.record_ = accounts_payable_vendor.vendoracctnokey
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_VENDTYPE vendtype ON vendtype.cny_ = accounts_payable_vendor.cny_ and vendtype.record_ = accounts_payable_vendor.vendtypekey

;   


------ CONTENT OF accounts_payable_bill   


CREATE OR REPLACE SECURE VIEW ACCOUNTS_PAYABLE_BILL
 COMMENT =  "Version=5d46b435-b116-4379-9a89-9ca3a2b867f9 "
 AS
SELECT

    --  end custom fields
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


------ CONTENT OF accounts_payable_bill_line   


CREATE OR REPLACE SECURE VIEW ACCOUNTS_PAYABLE_BILL_LINE
 COMMENT =  "Version=5d46b435-b116-4379-9a89-9ca3a2b867f9 " 
 AS
SELECT
 
    -- 	end custom fields
    accounts_payable_bill_line.cny_ AS cnyNumber,
    accounts_payable_bill_line.amount AS baseamount ,
    accounts_payable_bill_line.entry_date AS createddate ,
    accounts_payable_bill_line.form1099 AS hasform1099 ,
    accounts_payable_bill_line.record_ AS id ,
    accounts_payable_bill_line.record_ AS key ,
    accounts_payable_bill_line.subtotal AS issubtotal ,
    accounts_payable_bill_line.line_no AS linenumber ,
    accounts_payable_bill_line.description AS memo ,
    accounts_payable_bill_line.releasetopay AS releasetopay ,
    accounts_payable_bill_line.trx_amount AS txnamount ,
    accounts_payable_bill_line.basecurr AS currency_basecurrency ,
    accounts_payable_bill_line.currency AS currency_txncurrency ,
    accounts_payable_bill_line.exch_rate_date AS currencyexchangerate_date ,
    accounts_payable_bill_line.exchange_rate AS currencyexchangerate_rate ,
    accounts_payable_bill_line.exch_rate_type_id AS currencyexchangerate_typeid ,
    accounts_payable_bill_line.includetaxinassetcost AS fixedasset_includetaxinassetcost ,
    accounts_payable_bill_line.assetname AS fixedasset_nameofacquiredasset ,
    accounts_payable_bill_line.whencreated AS audit_createddatetime ,
    accounts_payable_bill_line.whenmodified AS audit_modifieddatetime ,
    accounts_payable_bill_line.createdby AS audit_createdby ,
    accounts_payable_bill_line.modifiedby AS audit_modifiedby ,
    audit_createdByUser.loginid                        AS audit_createdByUser_id,
    audit_modifiedByUser.loginid                       AS audit_modifiedByUser_id,
    accounts_payable_bill_line.form1099box AS form1099_box ,
    accounts_payable_bill_line.form1099type AS form1099_type ,
    accounts_payable_bill_line.totalpaid AS paymentinformation_totalbaseamountpaid ,
    accounts_payable_bill_line.totalselected AS paymentinformation_totalbaseamountselectedforpayment ,
    accounts_payable_bill_line.trx_totalpaid AS paymentinformation_totaltxnamountpaid ,
    accounts_payable_bill_line.trx_totalselected AS paymentinformation_totaltxnamountselectedforpayment ,
    accounts_payable_bill_line.billable AS project_isbillable ,
    accounts_payable_bill_line.billed AS project_isbilled ,
    accounts_payable_bill_line.amountretained AS retainage_baseamountretained ,
    accounts_payable_bill_line.hasretainage AS retainage_hasretainage ,
    accounts_payable_bill_line.retainagepercentage AS retainage_percentage ,
    accounts_payable_bill_line.retainagereleased AS retainage_release ,
    accounts_payable_bill_line.trx_amountreleased AS retainage_txnamountreleased ,
    accounts_payable_bill_line.trx_amountretained AS retainage_txnamountretained ,
    accounts_payable_bill_line.accountlabelkey AS accountlabel_key ,
    accounts_payable_bill_line.allocationkey AS allocation_key ,
    accounts_payable_bill_line.baselocation AS baselocation_key ,
    accounts_payable_bill_line.recordkey AS bill_id ,
    accounts_payable_bill_line.accountkey AS glaccount_key ,
    accounts_payable_bill_line.offsetaccountkey AS overrideoffsetglaccount_key,
    dimensions_class.classid                           AS dimensions_class_id,
    dimensions_class.record_                           AS dimensions_class_key,
    dimensions_class.name                              AS dimensions_class_name,
    dimensions_contract.contractid                     AS dimensions_contract_id,
    dimensions_contract.record_                        AS dimensions_contract_key,
    dimensions_contract.name                           AS dimensions_contract_name,
    dimensions_costType.costtypeid                     AS dimensions_costtype_id,
    dimensions_costType.record_                        AS dimensions_costtype_key,
    dimensions_costType.name                           AS dimensions_costtype_name,
    dimensions_customer.customerid                     AS dimensions_customer_id,
    dimensions_customer.record_                        AS dimensions_customer_key,
    dimensions_customer.name                           AS dimensions_customer_name,
    dimensions_department.dept_no                      AS dimensions_department_id,
    dimensions_department.record_                      AS dimensions_department_key,
    dimensions_department.title                        AS dimensions_department_name,
    dimensions_employee.employeeid                     AS dimensions_employee_id,
    dimensions_employee.record_                        AS dimensions_employee_key,
    dimensions_item.itemid                             AS dimensions_item_id,
    dimensions_item.record_                            AS dimensions_item_key,
    dimensions_item.name                               AS dimensions_item_name,
    dimensions_location.location_no                    AS dimensions_location_id,
    dimensions_location.record_                        AS dimensions_location_key,
    dimensions_location.name                           AS dimensions_location_name,
    dimensions_project.projectid                       AS dimensions_project_id,
    dimensions_project.record_                         AS dimensions_project_key,
    dimensions_project.name                            AS dimensions_project_name,
    dimensions_task.taskid                             AS dimensions_task_id,
    dimensions_task.record_                            AS dimensions_task_key,
    dimensions_task.name                               AS dimensions_task_name,
    dimensions_vendor.vendorid                         AS dimensions_vendor_id,
    dimensions_vendor.record_                          AS dimensions_vendor_key,
    dimensions_vendor.name                             AS dimensions_vendor_name,
    dimensions_warehouse.warehouseid                   AS dimensions_warehouse_id,
    dimensions_warehouse.record_                       AS dimensions_warehouse_key,
    dimensions_warehouse.name                          AS dimensions_warehouse_name,
FROM  SIF_SAGE_VIEWS.V_SA_prentry  accounts_payable_bill_line

LEFT JOIN SIF_SAGE_VIEWS.V_SA_userinfo audit_createdbyuser ON audit_createdbyuser.cny_ = accounts_payable_bill_line.cny_ and audit_createdbyuser.record_ = accounts_payable_bill_line.createdby 
LEFT JOIN SIF_SAGE_VIEWS.V_SA_userinfo audit_modifiedbyuser ON audit_modifiedbyuser.cny_ = accounts_payable_bill_line.cny_ and audit_modifiedbyuser.record_ = accounts_payable_bill_line.modifiedby 
LEFT JOIN SIF_SAGE_VIEWS.V_SA_apaccountlabel apaccountlabel ON apaccountlabel.cnyno = accounts_payable_bill_line.cny_ and apaccountlabel.recordno = accounts_payable_bill_line.accountlabelkey 
LEFT JOIN SIF_SAGE_VIEWS.V_SA_glaccount glaccount ON glaccount.cny_ = accounts_payable_bill_line.cny_ and glaccount.record_ = accounts_payable_bill_line.accountkey 
LEFT JOIN SIF_SAGE_VIEWS.V_SA_glaccount offsetglaccountno ON offsetglaccountno.cny_ = accounts_payable_bill_line.cny_ and offsetglaccountno.record_ = accounts_payable_bill_line.offsetaccountkey 
LEFT JOIN SIF_SAGE_VIEWS.V_SA_ALLOCATION alloc ON alloc.cny_ = accounts_payable_bill_line.cny_ and alloc.record_ = accounts_payable_bill_line.allocationkey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_class dimensions_class ON dimensions_class.cny_ = accounts_payable_bill_line.cny_ and dimensions_class.record_ = accounts_payable_bill_line.classdimkey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_contract dimensions_contract ON dimensions_contract.cny_ = accounts_payable_bill_line.cny_ and dimensions_contract.record_ = accounts_payable_bill_line.contractdimkey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_costtype dimensions_costtype ON dimensions_costtype.cny_ = accounts_payable_bill_line.cny_ and dimensions_costtype.record_ = accounts_payable_bill_line.costtypedimkey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_customer dimensions_customer ON dimensions_customer.cny_ = accounts_payable_bill_line.cny_ and dimensions_customer.record_ = accounts_payable_bill_line.customerdimkey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_department dimensions_department ON dimensions_department.cny_ = accounts_payable_bill_line.cny_ and dimensions_department.record_ = accounts_payable_bill_line.dept_
LEFT JOIN SIF_SAGE_VIEWS.V_SA_employee dimensions_employee ON dimensions_employee.cny_ = accounts_payable_bill_line.cny_ and dimensions_employee.record_ = accounts_payable_bill_line.employeedimkey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_icitem dimensions_item ON dimensions_item.cny_ = accounts_payable_bill_line.cny_ and dimensions_item.record_ = accounts_payable_bill_line.itemdimkey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_location dimensions_location ON dimensions_location.cny_ = accounts_payable_bill_line.cny_ and dimensions_location.record_ = accounts_payable_bill_line.location_
LEFT JOIN SIF_SAGE_VIEWS.V_SA_project dimensions_project ON dimensions_project.cny_ = accounts_payable_bill_line.cny_ and dimensions_project.record_ = accounts_payable_bill_line.projectdimkey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_task dimensions_task ON dimensions_task.cny_ = accounts_payable_bill_line.cny_ and dimensions_task.record_ = accounts_payable_bill_line.taskdimkey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_vendor dimensions_vendor ON dimensions_vendor.cny_ = accounts_payable_bill_line.cny_ and dimensions_vendor.record_ = accounts_payable_bill_line.vendordimkey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_icwarehouse dimensions_warehouse ON dimensions_warehouse.cny_ = accounts_payable_bill_line.cny_ and dimensions_warehouse.record_ = accounts_payable_bill_line.warehousedimkey

WHERE accounts_payable_bill_line.recordtype = 'pi'
;


------ CONTENT OF accounts_payable_term   


CREATE OR REPLACE SECURE VIEW ACCOUNTS_PAYABLE_TERM
 COMMENT =  "Version=5d46b435-b116-4379-9a89-9ca3a2b867f9 " 
 AS
SELECT
 
    -- 	end custom fields
    accounts_payable_term.cny_ AS cnyNumber,
    accounts_payable_term.description AS description ,
    accounts_payable_term.name AS id ,
    accounts_payable_term.record_ AS key ,
    accounts_payable_term.status AS status ,
    accounts_payable_term.createdby AS audit_createdby ,
    accounts_payable_term.whencreated AS audit_createddatetime ,
    audit_createdByUser.loginid                        AS audit_createdByUser_id,
    audit_modifiedByUser.loginid                       AS audit_modifiedByUser_id,
    accounts_payable_term.modifiedby AS audit_modifiedby ,
    accounts_payable_term.whenmodified AS audit_modifieddatetime ,
    accounts_payable_term.discamount AS discount_amount ,
    accounts_payable_term.disccalcon AS discount_calculation ,
    accounts_payable_term.discdate AS discount_days ,
    accounts_payable_term.discfrom AS discount_from ,
    accounts_payable_term.discfudgedays AS discount_gracedays ,
    accounts_payable_term.discpercamn AS discount_unit ,
    accounts_payable_term.duedate AS due_days ,
    accounts_payable_term.duefrom AS due_from ,
    accounts_payable_term.penamount AS penalty_amount ,
    accounts_payable_term.pen_types AS penalty_cycle ,
    accounts_payable_term.penfudgedays AS penalty_gracedays ,
    accounts_payable_term.penpercamn AS penalty_unit
FROM  SIF_SAGE_VIEWS.V_SA_apterm  accounts_payable_term
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_userinfo audit_createdbyuser ON audit_createdbyuser.cny_ = accounts_payable_term.cny_ and audit_createdbyuser.record_ = accounts_payable_term.createdby
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_userinfo audit_modifiedbyuser ON audit_modifiedbyuser.cny_ = accounts_payable_term.cny_ and audit_modifiedbyuser.record_ = accounts_payable_term.modifiedby

;   

    

------ CONTENT OF accounts_receivable_payment


CREATE OR REPLACE SECURE VIEW accounts_receivable_payment
    COMMENT =  "Version=5d46b435-b116-4379-9a89-9ca3a2b867f9 "
AS SELECT
    accounts_receivable_payment.cny_               AS cnyNumber,
    accounts_receivable_payment.CLRDATE            AS bankReconciliationDate,
    accounts_receivable_payment.CLEARED            AS bankReconciliationStatus,
    accounts_receivable_payment.DESCRIPTION        AS description,
    accounts_receivable_payment.DOCNUMBER          AS documentNumber,
    accounts_receivable_payment.RECORD_            AS id,
    accounts_receivable_payment.RECORD_            AS key,
    accounts_receivable_payment.WHENPAID           AS paidDate,
    accounts_receivable_payment.PAYERNAME          AS payerName,
    accounts_receivable_payment.RECORDTYPE         AS recordType,
    accounts_receivable_payment.RECORDID           AS referenceNumber,
    accounts_receivable_payment.state              AS state,
    accounts_receivable_payment.createdby          AS audit_createdBy,
    accounts_receivable_payment.auwhencreated      AS audit_createdDateTime,
    accounts_receivable_payment.modifiedby         AS audit_modifiedBy,
    accounts_receivable_payment.whenmodified       AS audit_modifiedDateTime,
    audit_createdByUser.loginid                    AS audit_createdByUser_id,
    audit_modifiedByUser.loginid                   AS audit_modifiedByUser_id,
    accounts_receivable_payment.basecurr           AS baseCurrency_currency,
    accounts_receivable_payment.totalentered       AS baseCurrency_totalAmount,
    accounts_receivable_payment.totaldue           AS baseCurrency_totalDue,
    accounts_receivable_payment.totalpaid          AS baseCurrency_totalPaid,
    contacts_payTo.name                            AS contacts_payTo_id,
    contacts_payTo.record_                         AS contacts_payTo_key,
    exchangerateinfo.exch_rate_date                AS exchangeRate_date,
    exchangerateinfo.exchange_rate                 AS exchangeRate_rate,
    exchangerateinfo.exch_rate_type_id             AS exchangeRate_typeId,
    accounts_receivable_payment.financialentity    AS financialEntity_entityId,
    financialaccount.type                          AS financialEntity_entityType,
    accounts_receivable_payment.currency           AS txnCurrency_currency,
    accounts_receivable_payment.trx_totalentered   AS txnCurrency_totalAmount,
    accounts_receivable_payment.trx_totaldue       AS txnCurrency_totalDue,
    accounts_receivable_payment.trx_totalpaid      AS txnCurrency_totalPaid,
    supdoc.documentid                              AS attachment_id,
    accounts_receivable_payment.custentity         AS customer_entity,
    customer.customerid                            AS customer_id,
    customer.record_                               AS customer_key,
    customer.name                                  AS customer_name,
    melocation.location_no                         AS entity_id,
    accounts_receivable_payment.locationkey        AS entity_key,
    melocation.name                                AS entity_name,
    accounts_receivable_payment.multientitypymtkey AS multiEntityPayment_key,
    accounts_receivable_payment.prbatchkey         AS paymentSummary_id,
    batch.title                                    AS paymentSummary_title,
    batch.created                                  AS paymentSummary_receiptDate,
    batch.undepfundsacct                           AS undepositedGLAccount_key,
FROM  SIF_SAGE_VIEWS.V_SA_prrecord accounts_receivable_payment
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_userinfo audit_createdbyuser ON audit_createdbyuser.cny_ = accounts_receivable_payment.cny_ AND audit_createdbyuser.record_ = accounts_receivable_payment.createdby
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_userinfo audit_modifiedbyuser ON audit_modifiedbyuser.cny_ = accounts_receivable_payment.cny_ AND audit_modifiedbyuser.record_ = accounts_receivable_payment.modifiedby
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_PRBATCH batch ON batch.cny_ = accounts_receivable_payment.cny_ AND batch.record_ = accounts_receivable_payment.prbatchkey
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_CUSTOMER customer ON customer.cny_ = accounts_receivable_payment.cny_ AND customer.record_ = accounts_receivable_payment.customerkey
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_CONTACT contacts_payTo ON contacts_payTo.cny_ = accounts_receivable_payment.cny_ AND contacts_payTo.record_ = accounts_receivable_payment.billtopaytokey
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_EXCHANGERATEINFO exchangerateinfo ON exchangerateinfo.cny_ = accounts_receivable_payment.cny_ AND exchangerateinfo.recordkey = accounts_receivable_payment.record_
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_LOCATION melocation ON melocation.cny_ = accounts_receivable_payment.cny_ AND melocation.record_ = accounts_receivable_payment.locationkey
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_FINANCIALACCOUNT financialaccount ON financialaccount.cny_ = accounts_receivable_payment.cny_ AND financialaccount.entity = accounts_receivable_payment.financialentity
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_supdoc supdoc ON supdoc.cny_ = accounts_receivable_payment.cny_ AND supdoc.record_ = accounts_receivable_payment.record_

WHERE accounts_receivable_payment.RECORDTYPE in ('rp', 'rr', 'ro')
;



------ CONTENT OF accounts_receivable_payment_line


CREATE OR REPLACE SECURE VIEW accounts_receivable_payment_line
    COMMENT =  "Version=5d46b435-b116-4379-9a89-9ca3a2b867f9 "
AS SELECT
    accounts_receivable_payment_line.cny_              AS cnyNumber,
    accounts_receivable_payment_line.RECORD_           AS id,
    accounts_receivable_payment_line.RECORD_           AS key,
    accounts_receivable_payment_line.LINE_NO           AS lineNumber,
    accounts_receivable_payment_line.DESCRIPTION       AS memo,
    accounts_receivable_payment_line.createdby         AS audit_createdBy,
    accounts_receivable_payment_line.whencreated       AS audit_createdDateTime,
    accounts_receivable_payment_line.modifiedby        AS audit_modifiedBy,
    accounts_receivable_payment_line.whenmodified      AS audit_modifiedDateTime,
    audit_createdByUser.loginid                        AS audit_createdByUser_id,
    audit_modifiedByUser.loginid                       AS audit_modifiedByUser_id,
    accounts_receivable_payment_line.amount            AS baseCurrency_amount,
    accounts_receivable_payment_line.basecurr          AS baseCurrency_currency,
    accounts_receivable_payment_line.totalpaid         AS baseCurrency_totalPaid,
    accounts_receivable_payment_line.totalselected     AS baseCurrency_totalSelected,
    dimensions_class.classid                           AS dimensions_class_id,
    dimensions_class.record_                           AS dimensions_class_key,
    dimensions_class.name                              AS dimensions_class_name,
    dimensions_contract.contractid                     AS dimensions_contract_id,
    dimensions_contract.record_                        AS dimensions_contract_key,
    dimensions_contract.name                           AS dimensions_contract_name,
    dimensions_costType.costtypeid                     AS dimensions_costtype_id,
    dimensions_costType.record_                        AS dimensions_costtype_key,
    dimensions_costType.name                           AS dimensions_costtype_name,
    dimensions_customer.customerid                     AS dimensions_customer_id,
    dimensions_customer.record_                        AS dimensions_customer_key,
    dimensions_customer.name                           AS dimensions_customer_name,
    dimensions_department.dept_no                      AS dimensions_department_id,
    dimensions_department.record_                      AS dimensions_department_key,
    dimensions_department.title                        AS dimensions_department_name,
    dimensions_employee.employeeid                     AS dimensions_employee_id,
    dimensions_employee.record_                        AS dimensions_employee_key,
    dimensions_item.itemid                             AS dimensions_item_id,
    dimensions_item.record_                            AS dimensions_item_key,
    dimensions_item.name                               AS dimensions_item_name,
    dimensions_location.location_no                    AS dimensions_location_id,
    dimensions_location.record_                        AS dimensions_location_key,
    dimensions_location.name                           AS dimensions_location_name,
    dimensions_project.projectid                       AS dimensions_project_id,
    dimensions_project.record_                         AS dimensions_project_key,
    dimensions_project.name                            AS dimensions_project_name,
    dimensions_task.taskid                             AS dimensions_task_id,
    dimensions_task.record_                            AS dimensions_task_key,
    dimensions_task.name                               AS dimensions_task_name,
    dimensions_vendor.vendorid                         AS dimensions_vendor_id,
    dimensions_vendor.record_                          AS dimensions_vendor_key,
    dimensions_vendor.name                             AS dimensions_vendor_name,
    dimensions_warehouse.warehouseid                   AS dimensions_warehouse_id,
    dimensions_warehouse.record_                       AS dimensions_warehouse_key,
    dimensions_warehouse.name                          AS dimensions_warehouse_name,
    accounts_receivable_payment_line.exch_rate_date    AS exchangeRate_date,
    accounts_receivable_payment_line.exchange_rate     AS exchangeRate_rate,
    accounts_receivable_payment_line.exch_rate_type_id AS exchangeRate_typeId,
    accounts_receivable_payment_line.trx_amount        AS txnCurrency_amount,
    accounts_receivable_payment_line.currency          AS txnCurrency_currency,
    accounts_receivable_payment_line.trx_totalpaid     AS txnCurrency_totalPaid,
    accounts_receivable_payment_line.trx_totalselected AS txnCurrency_totalSelected,
    alloc.allocationid                                 AS allocation_id,
    accounts_receivable_payment_line.recordkey         AS arPayment_id,
    glaccount.acct_no                                  AS glAccount_id,
    accounts_receivable_payment_line.accountkey        AS glAccount_key,
    glaccount.title                                    AS glAccount_name,
    offsetglaccount.acct_no                            AS offsetGLAccount_id,
    accounts_receivable_payment_line.offsetaccountkey  AS offsetGLAccount_key
FROM  SIF_SAGE_VIEWS.V_SA_prentry accounts_receivable_payment_line
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_userinfo audit_createdbyuser ON audit_createdbyuser.cny_ = accounts_receivable_payment_line.cny_ and audit_createdbyuser.record_ = accounts_receivable_payment_line.createdby
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_userinfo audit_modifiedbyuser ON audit_modifiedbyuser.cny_ = accounts_receivable_payment_line.cny_ and audit_modifiedbyuser.record_ = accounts_receivable_payment_line.modifiedby
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_class dimensions_class ON dimensions_class.cny_ = accounts_receivable_payment_line.cny_ and dimensions_class.record_ = accounts_receivable_payment_line.classdimkey
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_contract dimensions_contract ON dimensions_contract.cny_ = accounts_receivable_payment_line.cny_ and dimensions_contract.record_ = accounts_receivable_payment_line.contractdimkey
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_costtype dimensions_costtype ON dimensions_costtype.cny_ = accounts_receivable_payment_line.cny_ and dimensions_costtype.record_ = accounts_receivable_payment_line.costtypedimkey
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_customer dimensions_customer ON dimensions_customer.cny_ = accounts_receivable_payment_line.cny_ and dimensions_customer.record_ = accounts_receivable_payment_line.customerdimkey
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_employee dimensions_employee ON dimensions_employee.cny_ = accounts_receivable_payment_line.cny_ and dimensions_employee.record_ = accounts_receivable_payment_line.employeedimkey
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_icitem dimensions_item ON dimensions_item.cny_ = accounts_receivable_payment_line.cny_ and dimensions_item.record_ = accounts_receivable_payment_line.itemdimkey
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_project dimensions_project ON dimensions_project.cny_ = accounts_receivable_payment_line.cny_ and dimensions_project.record_ = accounts_receivable_payment_line.projectdimkey
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_task dimensions_task ON dimensions_task.cny_ = accounts_receivable_payment_line.cny_ and dimensions_task.record_ = accounts_receivable_payment_line.taskdimkey
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_vendor dimensions_vendor ON dimensions_vendor.cny_ = accounts_receivable_payment_line.cny_ and dimensions_vendor.record_ = accounts_receivable_payment_line.vendordimkey
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_icwarehouse dimensions_warehouse ON dimensions_warehouse.cny_ = accounts_receivable_payment_line.cny_ and dimensions_warehouse.record_ = accounts_receivable_payment_line.warehousedimkey
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_department dimensions_department ON  dimensions_department.cny_ = accounts_receivable_payment_line.cny_ and dimensions_department.record_ = accounts_receivable_payment_line.dept_
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_location dimensions_location ON  dimensions_location.cny_ = accounts_receivable_payment_line.cny_ and dimensions_location.record_ = accounts_receivable_payment_line.location_
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_GLACCOUNT glaccount ON glaccount.cny_ = accounts_receivable_payment_line.cny_ and glaccount.record_ = accounts_receivable_payment_line.accountkey
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_GLACCOUNT offsetglaccount ON offsetglaccount.cny_ = accounts_receivable_payment_line.cny_ and offsetglaccount.record_ = accounts_receivable_payment_line.offsetaccountkey
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_ARACCOUNTLABEL araccountlabel ON araccountlabel.cnyno = accounts_receivable_payment_line.cny_ and araccountlabel.recordno = accounts_receivable_payment_line.accountlabelkey
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_ALLOCATION alloc ON alloc.cny_ = accounts_receivable_payment_line.cny_ and alloc.record_ = accounts_receivable_payment_line.allocationkey

WHERE accounts_receivable_payment_line.RECORDTYPE in ('rp', 'rr', 'ro')
;




------ CONTENT OF accounts_receivable_customer


CREATE OR REPLACE SECURE VIEW ACCOUNTS_RECEIVABLE_CUSTOMER
 COMMENT =  "Version=5d46b435-b116-4379-9a89-9ca3a2b867f9 "
 AS SELECT

-- 	end custom fields
accounts_receivable_customer.cny_ AS cnyNumber,
accounts_receivable_customer.activationdate AS activationdate ,
accounts_receivable_customer.advbillby AS advancebillby ,
accounts_receivable_customer.advbillbytype AS advancebillbytype ,
accounts_receivable_customer.creditlimit AS creditlimit ,
accounts_receivable_customer.currency AS currency ,
accounts_receivable_customer.deliveryoptions AS deliveryoptions ,
accounts_receivable_customer.discount AS discountpercent ,
accounts_receivable_customer.emailoptin AS emailoptin ,
accounts_receivable_customer.enableonlineachpayment AS enableonlineachpayment ,
accounts_receivable_customer.enableonlinecardpayment AS enableonlinecardpayment ,
accounts_receivable_customer.customerid AS id ,
accounts_receivable_customer.onhold AS isonhold ,
accounts_receivable_customer.onetime AS isonetimeuse ,
accounts_receivable_customer.record_ AS key ,
accounts_receivable_customer.lastinvoicedate AS lastinvoicecreateddate ,
accounts_receivable_customer.laststatementdate AS laststatementgenerateddate ,
accounts_receivable_customer.name AS name ,
accounts_receivable_customer.comments AS notes ,
accounts_receivable_customer.prclst_override AS overridepricelist ,
accounts_receivable_customer.resale_number AS resalenumber ,
accounts_receivable_customer.retainagepercentage AS retainagepercentage ,
accounts_receivable_customer.status AS status ,
accounts_receivable_customer.subscriptionenddate AS subscriptionenddate ,
accounts_receivable_customer.taxid AS taxid ,
accounts_receivable_customer.totaldue AS totaldue ,
accounts_receivable_customer.createdby AS audit_createdby ,
accounts_receivable_customer.whencreated AS audit_createddatetime ,
accounts_receivable_customer.modifiedby AS audit_modifiedby ,
accounts_receivable_customer.whenmodified AS audit_modifieddatetime ,
contacts_billto.name AS billto_contactname ,
contacts_billto.record_ AS billtokey ,
contacts_default.name AS displaycontact_contactname ,
contacts_default.record_ AS displaycontactkey ,
contacts_primary.name AS contactinfo_contactname ,
contacts_primary.record_ AS contactkey ,
contacts_shipto.name AS shipto_contactname ,
contacts_shipto.record_ AS shiptokey ,
glgroup.name AS accountgroup_id ,
accounts_receivable_customer.glgrpkey AS accountgroup_key ,
accounts_receivable_customer.accountlabelkey AS accountlabel_key ,
accounts_receivable_customer.custmessageid AS customermessage_id ,
custtype.name AS customertype_id ,
accounts_receivable_customer.custtypekey AS customertype_key ,
accounts_receivable_customer.accountkey AS defaultrevenueglaccount_key ,
accounts_receivable_customer.locationkey AS entity_key ,
melocation.name AS entity_name ,
accounts_receivable_customer.offsetaccountkey AS overrideoffsetglaccount_key ,
parent.customerid AS parent_id ,
accounts_receivable_customer.parentkey AS parent_key ,
parent.name AS parent_name ,
accounts_receivable_customer.oeprclstkey AS pricelist_key ,
accounts_receivable_customer.oepriceschedkey AS priceschedule_key ,
custrep.record_ AS salesrepresentative_key ,
custrepcontact.name AS salesrepresentative_name ,
shipmethod.name AS shippingmethod_id ,
accounts_receivable_customer.shipviakey AS shippingmethod_key ,
term.name AS term_id ,
accounts_receivable_customer.termskey AS term_key ,
accounts_receivable_customer.territorykey AS territory_key ,
territory.name AS territory_name
FROM  SIF_SAGE_VIEWS.V_SA_customer  accounts_receivable_customer

LEFT JOIN SIF_SAGE_VIEWS.V_SA_userinfo audit_createdbyuser ON audit_createdbyuser.cny_ = accounts_receivable_customer.cny_ and audit_createdbyuser.record_ = accounts_receivable_customer.createdby
LEFT JOIN SIF_SAGE_VIEWS.V_SA_userinfo audit_modifiedbyuser ON audit_modifiedbyuser.cny_ = accounts_receivable_customer.cny_ and audit_modifiedbyuser.record_ = accounts_receivable_customer.modifiedby
LEFT JOIN SIF_SAGE_VIEWS.V_SA_contact contacts_billto ON contacts_billto.cny_ = accounts_receivable_customer.cny_ and contacts_billto.record_ = accounts_receivable_customer.billtokey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_contact contacts_default ON contacts_default.cny_ = accounts_receivable_customer.cny_ and contacts_default.record_ = accounts_receivable_customer.displaycontactkey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_contact contacts_primary ON contacts_primary.cny_ = accounts_receivable_customer.cny_ and contacts_primary.record_ = accounts_receivable_customer.contactkey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_contact contacts_shipto ON contacts_shipto.cny_ = accounts_receivable_customer.cny_ and contacts_shipto.record_ = accounts_receivable_customer.shiptokey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_customer parent ON parent.cny_ = accounts_receivable_customer.cny_ and parent.record_ = accounts_receivable_customer.parentkey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_GLACCTGRP glgroup ON glgroup.cny_ = accounts_receivable_customer.cny_ and glgroup.record_ = accounts_receivable_customer.glgrpkey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_ACCOUNTLABEL accountlabel ON accountlabel.cny_ = accounts_receivable_customer.cny_ and accountlabel.record_ = accounts_receivable_customer.accountlabelkey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_CUSTTYPE custtype ON custtype.cny_ = accounts_receivable_customer.cny_ and custtype.record_ = accounts_receivable_customer.custtypekey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_GLACCOUNT araccount ON araccount.cny_ = accounts_receivable_customer.cny_ and araccount.record_ = accounts_receivable_customer.accountkey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_GLACCOUNT offsetglaccountno ON offsetglaccountno.cny_ = accounts_receivable_customer.cny_ and offsetglaccountno.record_ = accounts_receivable_customer.offsetaccountkey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_employee custrep ON custrep.cny_ = accounts_receivable_customer.cny_ and custrep.employeeid = accounts_receivable_customer.custrepkey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_CONTACT custrepcontact ON custrepcontact.cny_ = accounts_receivable_customer.cny_ and custrepcontact.record_ = custrep.contactkey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_SHIPMETHOD shipmethod ON shipmethod.cny_ = accounts_receivable_customer.cny_ and shipmethod.record_ = accounts_receivable_customer.shipviakey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_TERM term ON term.cny_ = accounts_receivable_customer.cny_ and term.record_ = accounts_receivable_customer.termskey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_TERRITORY territory ON territory.cny_ = accounts_receivable_customer.cny_ and territory.territoryid = accounts_receivable_customer.territorykey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_LOCATION melocation ON melocation.cny_ = accounts_receivable_customer.cny_ and melocation.record_ = accounts_receivable_customer.locationkey

;


------ CONTENT OF accounts_receivable_invoice


CREATE OR REPLACE SECURE VIEW ACCOUNTS_RECEIVABLE_INVOICE
 COMMENT =  "Version=5d46b435-b116-4379-9a89-9ca3a2b867f9 "
 AS SELECT

-- 	end custom fields
accounts_receivable_invoice.cny_ AS cnyNumber,
accounts_receivable_invoice.description AS description ,
accounts_receivable_invoice.whendiscount AS discountcutoffdate ,
accounts_receivable_invoice.description2 AS documentid ,
accounts_receivable_invoice.whendue AS duedate ,
accounts_receivable_invoice.record_ AS id ,
accounts_receivable_invoice.record_ AS key ,
accounts_receivable_invoice.whencreated AS invoicedate ,
accounts_receivable_invoice.recordid AS invoicenumber ,
accounts_receivable_invoice.systemgenerated AS issystemgenerateddocument ,
accounts_receivable_invoice.modulekey AS modulekey ,
accounts_receivable_invoice.recordtype AS recordtype ,
accounts_receivable_invoice.docnumber AS referencenumber ,
accounts_receivable_invoice.totalentered AS totalbaseamount ,
accounts_receivable_invoice.totaldue AS totalbaseamountdue ,
accounts_receivable_invoice.trx_totalentered AS totaltxnamount ,
accounts_receivable_invoice.trx_totaldue AS totaltxnamountdue ,
accounts_receivable_invoice.createdby AS audit_createdby ,
accounts_receivable_invoice.auwhencreated AS audit_createddatetime ,
accounts_receivable_invoice.modifiedby AS audit_modifiedby ,
accounts_receivable_invoice.whenmodified AS audit_modifieddatetime ,
accounts_receivable_invoice.billtopaytokey AS contactspayto_key ,
accounts_receivable_invoice.shiptoreturntokey AS contactsreturnto_key ,
accounts_receivable_invoice.basecurr AS currency_basecurrency ,
accounts_receivable_invoice.currency AS currency_txncurrency ,
accounts_receivable_invoice.whenpaid AS paymentinformation_fullypaiddate ,
accounts_receivable_invoice.totalpaid AS paymentinformation_totalbaseamountpaid ,
accounts_receivable_invoice.totalselected AS paymentinformation_totalbaseamountselectedforpayment ,
accounts_receivable_invoice.trx_totalpaid AS paymentinformation_totaltxnamountpaid ,
accounts_receivable_invoice.trx_totalselected AS paymentinformation_totaltxnamountselectedforpayment ,
accounts_receivable_invoice.schopkey AS recurringschedule_key ,
accounts_receivable_invoice.billbacktemplatekey AS billbacktemplate_key ,
customer.totaldue AS customer_customerdue ,
customer.customerid AS customer_id ,
accounts_receivable_invoice.custmessageid AS customermessage_id ,
accounts_receivable_invoice.locationkey AS entity_key ,
accounts_receivable_invoice.prbatchkey AS invoicesummary_key ,
accounts_receivable_invoice.termkey AS term_key,
CASE
    WHEN accounts_receivable_invoice.STATE = 'V' THEN 'Reversal'
    WHEN accounts_receivable_invoice.STATE = 'D' THEN 'Draft'
    WHEN accounts_receivable_invoice.TRX_TOTALENTERED = 0 THEN 'No Value'
    WHEN accounts_receivable_invoice.TRX_TOTALSELECTED = 0
         AND accounts_receivable_invoice.TRX_TOTALPAID = 0 THEN 'Posted'
    WHEN accounts_receivable_invoice.TRX_TOTALDUE = 0 THEN 'Paid'
    WHEN accounts_receivable_invoice.TRX_TOTALSELECTED != 0 THEN 'Selected'
    WHEN accounts_receivable_invoice.TRX_TOTALPAID != 0 THEN 'Partially Paid'
    ELSE accounts_receivable_invoice.STATE
END AS state

FROM  SIF_SAGE_VIEWS.V_SA_prrecord  accounts_receivable_invoice

LEFT JOIN SIF_SAGE_VIEWS.V_SA_userinfo audit_createdbyuser ON audit_createdbyuser.cny_ = accounts_receivable_invoice.cny_ and audit_createdbyuser.record_ = accounts_receivable_invoice.createdby
LEFT JOIN SIF_SAGE_VIEWS.V_SA_userinfo audit_modifiedbyuser ON audit_modifiedbyuser.cny_ = accounts_receivable_invoice.cny_ and audit_modifiedbyuser.record_ = accounts_receivable_invoice.modifiedby
LEFT JOIN SIF_SAGE_VIEWS.V_SA_PRBATCH batch ON batch.cny_ = accounts_receivable_invoice.cny_ and batch.record_ = accounts_receivable_invoice.prbatchkey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_CUSTOMER customer ON customer.cny_ = accounts_receivable_invoice.cny_ and customer.record_ = accounts_receivable_invoice.customerkey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_CONTACT billto ON billto.cny_ = accounts_receivable_invoice.cny_ and billto.record_ = accounts_receivable_invoice.billtopaytokey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_CONTACT shipto ON shipto.cny_ = accounts_receivable_invoice.cny_ and shipto.record_ = accounts_receivable_invoice.shiptoreturntokey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_TAXSOLUTION taxsolution ON taxsolution.cny_ = accounts_receivable_invoice.cny_ and taxsolution.record_ = accounts_receivable_invoice.taxsolutionkey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_EXCHANGERATEINFO exchangerateinfo ON exchangerateinfo.cny_ = accounts_receivable_invoice.cny_ and exchangerateinfo.recordkey = accounts_receivable_invoice.record_
LEFT JOIN SIF_SAGE_VIEWS.V_SA_LOCATION melocation ON melocation.cny_ = accounts_receivable_invoice.cny_ and melocation.record_ = accounts_receivable_invoice.locationkey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_TERM term ON term.cny_ = accounts_receivable_invoice.cny_ and term.record_ = accounts_receivable_invoice.termkey

WHERE accounts_receivable_invoice.RECORDTYPE = 'ri'
;


------ CONTENT OF accounts_receivable_invoice_line


CREATE OR REPLACE SECURE VIEW ACCOUNTS_RECEIVABLE_INVOICE_LINE
 COMMENT =  "Version=5d46b435-b116-4379-9a89-9ca3a2b867f9 "
 AS SELECT

-- 	end custom fields
accounts_receivable_invoice_line.cny_ AS cnyNumber,
accounts_receivable_invoice_line.amount AS baseamount ,
accounts_receivable_invoice_line.entry_date AS createddate ,
accounts_receivable_invoice_line.record_ AS id ,
accounts_receivable_invoice_line.record_ AS key ,
accounts_receivable_invoice_line.subtotal AS issubtotal ,
accounts_receivable_invoice_line.line_no AS linenumber ,
accounts_receivable_invoice_line.description AS memo ,
accounts_receivable_invoice_line.trx_amount AS txnamount ,
accounts_receivable_invoice_line.createdby AS audit_createdby ,
accounts_receivable_invoice_line.whencreated AS audit_createddatetime ,
accounts_receivable_invoice_line.modifiedby AS audit_modifiedby ,
accounts_receivable_invoice_line.whenmodified AS audit_modifieddatetime ,
accounts_receivable_invoice_line.basecurr AS currency_basecurrency ,
accounts_receivable_invoice_line.currency AS currency_txncurrency ,
accounts_receivable_invoice_line.exch_rate_date AS currencyexchangerate_date ,
accounts_receivable_invoice_line.exchange_rate AS currencyexchangerate_rate ,
accounts_receivable_invoice_line.exch_rate_type_id AS currencyexchangerate_typeid ,
dimensions_class.record_ AS classdimkey ,
dimensions_contract.record_ AS contractdimkey ,
dimensions_costtype.record_ AS costtypedimkey ,
dimensions_customer.record_ AS customerdimkey ,
dimensions_employee.record_ AS employeedimkey ,
dimensions_item.record_ AS itemdimkey ,
dimensions_location.record_ AS location_ ,
dimensions_project.record_ AS projectdimkey ,
dimensions_task.record_ AS taskdimkey ,
dimensions_vendor.record_ AS vendordimkey ,
dimensions_warehouse.record_ AS warehousedimkey ,
accounts_receivable_invoice_line.totalpaid AS paymentinformation_totalbaseamountpaid ,
accounts_receivable_invoice_line.totalselected AS paymentinformation_totalbaseamountselectedforpayment ,
accounts_receivable_invoice_line.trx_totalpaid AS paymentinformation_totaltxnamountpaid ,
accounts_receivable_invoice_line.trx_totalselected AS paymentinformation_totaltxnamountselectedforpayment ,
accounts_receivable_invoice_line.accountlabelkey AS accountlabel_key ,
accounts_receivable_invoice_line.allocationkey AS allocation_key ,
accounts_receivable_invoice_line.baselocation AS baselocation_key ,
accounts_receivable_invoice_line.accountkey AS glaccount_key ,
accounts_receivable_invoice_line.recordkey AS invoice_id
FROM  SIF_SAGE_VIEWS.V_SA_prentry  accounts_receivable_invoice_line

LEFT JOIN SIF_SAGE_VIEWS.V_SA_userinfo audit_createdbyuser ON audit_createdbyuser.cny_ = accounts_receivable_invoice_line.cny_ and audit_createdbyuser.record_ = accounts_receivable_invoice_line.createdby
LEFT JOIN SIF_SAGE_VIEWS.V_SA_userinfo audit_modifiedbyuser ON audit_modifiedbyuser.cny_ = accounts_receivable_invoice_line.cny_ and audit_modifiedbyuser.record_ = accounts_receivable_invoice_line.modifiedby
LEFT JOIN SIF_SAGE_VIEWS.V_SA_class dimensions_class ON dimensions_class.cny_ = accounts_receivable_invoice_line.cny_ and dimensions_class.record_ = accounts_receivable_invoice_line.classdimkey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_contract dimensions_contract ON dimensions_contract.cny_ = accounts_receivable_invoice_line.cny_ and dimensions_contract.record_ = accounts_receivable_invoice_line.contractdimkey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_costtype dimensions_costtype ON dimensions_costtype.cny_ = accounts_receivable_invoice_line.cny_ and dimensions_costtype.record_ = accounts_receivable_invoice_line.costtypedimkey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_customer dimensions_customer ON dimensions_customer.cny_ = accounts_receivable_invoice_line.cny_ and dimensions_customer.record_ = accounts_receivable_invoice_line.customerdimkey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_employee dimensions_employee ON dimensions_employee.cny_ = accounts_receivable_invoice_line.cny_ and dimensions_employee.record_ = accounts_receivable_invoice_line.employeedimkey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_icitem dimensions_item ON dimensions_item.cny_ = accounts_receivable_invoice_line.cny_ and dimensions_item.record_ = accounts_receivable_invoice_line.itemdimkey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_project dimensions_project ON dimensions_project.cny_ = accounts_receivable_invoice_line.cny_ and dimensions_project.record_ = accounts_receivable_invoice_line.projectdimkey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_task dimensions_task ON dimensions_task.cny_ = accounts_receivable_invoice_line.cny_ and dimensions_task.record_ = accounts_receivable_invoice_line.taskdimkey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_vendor dimensions_vendor ON dimensions_vendor.cny_ = accounts_receivable_invoice_line.cny_ and dimensions_vendor.record_ = accounts_receivable_invoice_line.vendordimkey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_icwarehouse dimensions_warehouse ON dimensions_warehouse.cny_ = accounts_receivable_invoice_line.cny_ and dimensions_warehouse.record_ = accounts_receivable_invoice_line.warehousedimkey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_department dimensions_department ON  dimensions_department.cny_ = accounts_receivable_invoice_line.cny_ and dimensions_department.record_ = accounts_receivable_invoice_line.dept_
LEFT JOIN SIF_SAGE_VIEWS.V_SA_location dimensions_location ON  dimensions_location.cny_ = accounts_receivable_invoice_line.cny_ and dimensions_location.record_ = accounts_receivable_invoice_line.location_
LEFT JOIN SIF_SAGE_VIEWS.V_SA_GLACCOUNT offsetglaccountno ON offsetglaccountno.cny_ = accounts_receivable_invoice_line.cny_ and offsetglaccountno.record_ = accounts_receivable_invoice_line.offsetaccountkey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_ARACCOUNTLABEL araccountlabel ON araccountlabel.cnyno = accounts_receivable_invoice_line.cny_ and araccountlabel.recordno = accounts_receivable_invoice_line.accountlabelkey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_ALLOCATION alloc ON alloc.cny_ = accounts_receivable_invoice_line.cny_ and alloc.record_ = accounts_receivable_invoice_line.allocationkey

WHERE accounts_receivable_invoice_line.RECORDTYPE = 'ri'
;


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

------ CONTENT OF accounts_receivable_recurring_invoice

CREATE OR REPLACE VIEW accounts_receivable_recurring_invoice AS
SELECT
    accounts_receivable_recurring_invoice.DESCRIPTION AS description,
    accounts_receivable_recurring_invoice.RECORDNO AS id,
    accounts_receivable_recurring_invoice.RECORDNO AS key,
    accounts_receivable_recurring_invoice.RECORDID AS invoiceNumber,
    accounts_receivable_recurring_invoice.DOCNUMBER AS referenceNumber,
    accounts_receivable_recurring_invoice.STATUS AS status,
    accounts_receivable_recurring_invoice.TOTALENTERED AS totalEntered,
    accounts_receivable_recurring_invoice.TRX_TOTALENTERED AS txnTotalEntered,
    accounts_receivable_recurring_invoice.createdby AS audit_createdBy,
    accounts_receivable_recurring_invoice.auwhencreated AS audit_createdDateTime,
    accounts_receivable_recurring_invoice.modifiedby AS audit_modifiedBy,
    accounts_receivable_recurring_invoice.whenmodified AS audit_modifiedDateTime,
    audit_createdByUser.loginid AS audit_createdByUser_id,
    audit_modifiedByUser.loginid AS audit_modifiedByUser_id,
    contacts_billTo.name AS BILLTOCONTACTNAME,
    contacts_billTo.record# AS BILLTOPAYTOKEY,
    contacts_shipTo.name AS SHIPTOCONTACTNAME,
    contacts_shipTo.record# AS SHIPTORETURNTOKEY,
    accounts_receivable_recurring_invoice.contractdesc AS contract_description,
    accounts_receivable_recurring_invoice.contractid AS contract_id,
    accounts_receivable_recurring_invoice.basecurr AS currency_baseCurrency,
    accounts_receivable_recurring_invoice.currency AS currency_txnCurrency,
    accounts_receivable_recurring_invoice.arrecurpayment.accounttype AS payment_accountType,
    accounts_receivable_recurring_invoice.arrecurpayment.bankaccountid AS payment_bankAccountID,
    accounts_receivable_recurring_invoice.arrecurpayment.creditcardtype AS payment_creditCardType,
    accounts_receivable_recurring_invoice.arrecurpayment.payinfull AS payment_payInFull,
    accounts_receivable_recurring_invoice.arrecurpayment.paymentamount AS payment_paymentAmount,
    accounts_receivable_recurring_invoice.paymethod AS payment_paymentMethod, -- Note: the alias for 'paymethod' was corrected here
    accounts_receivable_recurring_invoice.arrecurpayment.glaccountkey AS payment_undepositedFundsAccountId,
    accounts_receivable_recurring_invoice.schedule.enddate AS schedule_endDate,
    accounts_receivable_recurring_invoice.schedule.lastexecdate AS schedule_lastExecutionDate,
    accounts_receivable_recurring_invoice.schedule.nextexecdate AS schedule_nextExecutionDate,
    accounts_receivable_recurring_invoice.schedule.repeatby AS schedule_repeatBy,
    accounts_receivable_recurring_invoice.schedule.repeatcount AS schedule_repeatCount,
    accounts_receivable_recurring_invoice.schedule.repeatinterval AS schedule_repeatInterval,
    accounts_receivable_recurring_invoice.schedule.startdate AS schedule_startDate,
    accounts_receivable_recurring_invoice.schedule.execcount AS schedule_txnCount,
    accounts_receivable_recurring_invoice.supdoc.documentid AS attachment_id,
    accounts_receivable_recurring_invoice.supdoc.record# AS attachment_key,
    accounts_receivable_recurring_invoice.customer.customerid AS customer_id,
    accounts_receivable_recurring_invoice.customer.record# AS customer_key,
    accounts_receivable_recurring_invoice.customer.name AS customer_name,
    accounts_receivable_recurring_invoice.custmessageid AS customerMessage_id,
    accounts_receivable_recurring_invoice.custmessagekey AS customerMessage_key,
    accounts_receivable_recurring_invoice.melocation.location_no AS entity_id,
    accounts_receivable_recurring_invoice.locationkey AS entity_key,
    accounts_receivable_recurring_invoice.melocation.name AS entity_name,
    accounts_receivable_recurring_invoice.schopkey AS scheduledOperation_id,
    accounts_receivable_recurring_invoice.taxsolution.solutionid AS taxSolution_id,
    accounts_receivable_recurring_invoice.taxsolutionkey AS taxSolution_key,
    accounts_receivable_recurring_invoice.term.name AS term_id,
    accounts_receivable_recurring_invoice.termkey AS term_key
FROM
    ICRW_SCHEMA.v_sa_recrprrecschdleop accounts_receivable_recurring_invoice
LEFT JOIN ICRW_SCHEMA.userinfo audit_createdByUser ON audit_createdByUser.CNY_ = accounts_receivable_recurring_invoice.CNY_ AND audit_createdByUser.record_ = accounts_receivable_recurring_invoice.createdby
LEFT JOIN ICRW_SCHEMA.userinfo audit_modifiedByUser ON audit_modifiedByUser.CNY_ = accounts_receivable_recurring_invoice.CNY_ AND audit_modifiedByUser.record_ = accounts_receivable_recurring_invoice.modifiedby
LEFT JOIN ICRW_SCHEMA.contact contacts_billTo ON contacts_billTo.CNY_ = accounts_receivable_recurring_invoice.CNY_ AND contacts_billTo.record_ = accounts_receivable_recurring_invoice.BILLTOPAYTOKEY
LEFT JOIN ICRW_SCHEMA.contact contacts_shipTo ON contacts_shipTo.CNY_ = accounts_receivable_recurring_invoice.CNY_ AND contacts_shipTo.record_ = accounts_receivable_recurring_invoice.SHIPTORETURNTOKEY
;


------ CONTENT OF accounts_receivable_recurring_invoice_line

CREATE OR REPLACE VIEW accounts_receivable_recurring_invoice_line AS
SELECT
    -- Main fields
    accounts_receivable_recurring_invoice_line.AMOUNT AS amount,
    accounts_receivable_recurring_invoice_line.ENTRYDESCRIPTION AS description,
    accounts_receivable_recurring_invoice_line.REVRECENDDATE AS endDate,
    accounts_receivable_recurring_invoice_line.RECORDNO AS id,
    accounts_receivable_recurring_invoice_line.RECORDNO AS key,
    accounts_receivable_recurring_invoice_line.BILLABLE AS isBillable,
    accounts_receivable_recurring_invoice_line.SUBTOTAL AS isSubTotal,
    accounts_receivable_recurring_invoice_line.ISTAX AS isTax,
    accounts_receivable_recurring_invoice_line.LINE_NO AS lineNumber,
    accounts_receivable_recurring_invoice_line.REVRECSTARTDATE AS startDate,
    accounts_receivable_recurring_invoice_line.STATUS AS status,
    accounts_receivable_recurring_invoice_line.TOTALTRXAMOUNT AS totalTxnAmount,
    accounts_receivable_recurring_invoice_line.TRX_AMOUNT AS txnAmount,
    -- Audit fields
    accounts_receivable_recurring_invoice_line.createdby AS audit_createdBy,
    accounts_receivable_recurring_invoice_line.whencreated AS audit_createdDateTime,
    accounts_receivable_recurring_invoice_line.modifiedby AS audit_modifiedBy,
    accounts_receivable_recurring_invoice_line.whenmodified AS audit_modifiedDateTime,
    audit_createdByUser.loginid AS audit_createdByUser_id,
    audit_modifiedByUser.loginid AS audit_modifiedByUser_id,
    -- Currency fields
    accounts_receivable_recurring_invoice_line.basecurr AS currency_baseCurrency,
    accounts_receivable_recurring_invoice_line.exchange_rate AS currency_exchangeRate,
    accounts_receivable_recurring_invoice_line.exch_rate_date AS currency_exchangeRateDate,
    accounts_receivable_recurring_invoice_line.exch_rate_type_id AS currency_exchangeRateTypeId,
    accounts_receivable_recurring_invoice_line.currency AS currency_txnCurrency,
    -- Dimension: Affiliate Entity
    dimensions_affiliateEntity.affiliateentityid AS AFFILIATEENTITYID,
    dimensions_affiliateEntity.record# AS AFFILIATEENTITYDIMKEY,
    dimensions_affiliateEntity.name AS AFFILIATEENTITYNAME,
    -- Dimension: Class
    dimensions_class.classid AS CLASSID,
    dimensions_class.record# AS CLASSDIMKEY,
    dimensions_class.name AS CLASSNAME,
    -- Dimension: Contract
    dimensions_contract.contractid AS CONTRACTID,
    dimensions_contract.record# AS CONTRACTDIMKEY,
    dimensions_contract.name AS CONTRACTNAME,
    -- Dimension: Cost Type
    dimensions_costType.costtypeid AS COSTTYPEID,
    dimensions_costType.record# AS COSTTYPEDIMKEY,
    dimensions_costType.name AS COSTTYPENAME,
    -- Dimension: Customer
    dimensions_customer.customerid AS CUSTOMERID,
    dimensions_customer.record# AS CUSTOMERDIMKEY,
    dimensions_customer.name AS CUSTOMERNAME,
    -- Dimension: Department
    dimensions_department.dept_no AS DEPARTMENTID,
    dimensions_department.record# AS DEPT#,
    dimensions_department.title AS DEPARTMENTNAME,
    -- Dimension: Employee
    dimensions_employee.employeeid AS EMPLOYEEID,
    dimensions_employee.record# AS EMPLOYEEDIMKEY,
    dimensions_employee.contact.name AS EMPLOYEENAME,
    -- Dimension: Item
    dimensions_item.itemid AS ITEMID,
    dimensions_item.record# AS ITEMDIMKEY,
    dimensions_item.name AS ITEMNAME,
    -- Dimension: Location
    dimensions_location.location_no AS LOCATIONID,
    dimensions_location.record# AS LOCATION#,
    dimensions_location.name AS LOCATIONNAME,
    -- Dimension: Project
    dimensions_project.projectid AS PROJECTID,
    dimensions_project.record# AS PROJECTDIMKEY,
    dimensions_project.name AS PROJECTNAME,
    -- Dimension: Task
    dimensions_task.taskid AS TASKID,
    dimensions_task.record# AS TASKDIMKEY,
    dimensions_task.name AS TASKNAME,
    -- Dimension: Vendor
    dimensions_vendor.vendorid AS VENDORID,
    dimensions_vendor.record# AS VENDORDIMKEY,
    dimensions_vendor.name AS VENDORNAME,
    -- Dimension: Warehouse
    dimensions_warehouse.warehouseid AS WAREHOUSEID,
    dimensions_warehouse.record# AS WAREHOUSEDIMKEY,
    dimensions_warehouse.name AS WAREHOUSENAME,
    -- Account Label
    accounts_receivable_recurring_invoice_line.araccountlabel.label AS accountLabel_id,
    accounts_receivable_recurring_invoice_line.accountlabelkey AS accountLabel_key,
    -- Allocation
    accounts_receivable_recurring_invoice_line.alloc.allocationid AS allocation_id,
    accounts_receivable_recurring_invoice_line.allocationkey AS allocation_key,
    -- Deferred Revenue GL Account
    accounts_receivable_recurring_invoice_line.dracct.acct_no AS deferredRevenueGLAccount_id,
    accounts_receivable_recurring_invoice_line.deferredrevacctkey AS deferredRevenueGLAccount_key,
    accounts_receivable_recurring_invoice_line.dracct.title AS deferredRevenueGLAccount_name,
    -- GL Account
    accounts_receivable_recurring_invoice_line.glaccount.acct_no AS glAccount_id,
    accounts_receivable_recurring_invoice_line.accountkey AS glAccount_key,
    accounts_receivable_recurring_invoice_line.glaccount.title AS glAccount_name,
    -- Offset GL Account
    accounts_receivable_recurring_invoice_line.offsetglaccountno.acct_no AS offsetGLAccount_id,
    accounts_receivable_recurring_invoice_line.offset AS offsetGLAccount_key,
    accounts_receivable_recurring_invoice_line.offsetglaccountno.title AS offsetGLAccount_name,
    -- Recurring Invoice
    accounts_receivable_recurring_invoice_line.recordkey AS recurringInvoice_id,
    -- Tax Detail
    accounts_receivable_recurring_invoice_line.detail.detailid AS taxDetail_id,
    accounts_receivable_recurring_invoice_line.taxdetail# AS taxDetail_key,
    accounts_receivable_recurring_invoice_line.detail.value AS taxDetail_taxRate
FROM ICRW_SCHEMA.recurprentry accounts_receivable_recurring_invoice_line
-- Audit joins
LEFT JOIN ICRW_SCHEMA.userinfo audit_createdByUser ON audit_createdByUser.CNY_ = accounts_receivable_recurring_invoice_line.CNY_ AND audit_createdByUser.record_ = accounts_receivable_recurring_invoice_line.createdby
LEFT JOIN ICRW_SCHEMA.userinfo audit_modifiedByUser ON audit_modifiedByUser.CNY_ = accounts_receivable_recurring_invoice_line.CNY_ AND audit_modifiedByUser.record_ = accounts_receivable_recurring_invoice_line.modifiedby
-- Dimension joins
LEFT JOIN ICRW_SCHEMA.v_affiliateentity dimensions_affiliateEntity ON dimensions_affiliateEntity.CNY_ = accounts_receivable_recurring_invoice_line.CNY_ AND dimensions_affiliateEntity.record_ = accounts_receivable_recurring_invoice_line.AFFILIATEENTITYDIMKEY
LEFT JOIN ICRW_SCHEMA.class dimensions_class ON dimensions_class.CNY_ = accounts_receivable_recurring_invoice_line.CNY_ AND dimensions_class.record_ = accounts_receivable_recurring_invoice_line.CLASSDIMKEY
LEFT JOIN ICRW_SCHEMA.contract dimensions_contract ON dimensions_contract.CNY_ = accounts_receivable_recurring_invoice_line.CNY_ AND dimensions_contract.record_ = accounts_receivable_recurring_invoice_line.CONTRACTDIMKEY
LEFT JOIN ICRW_SCHEMA.costtype dimensions_costType ON dimensions_costType.CNY_ = accounts_receivable_recurring_invoice_line.CNY_ AND dimensions_costType.record_ = accounts_receivable_recurring_invoice_line.COSTTYPEDIMKEY
LEFT JOIN ICRW_SCHEMA.customer dimensions_customer ON dimensions_customer.CNY_ = accounts_receivable_recurring_invoice_line.CNY_ AND dimensions_customer.record_ = accounts_receivable_recurring_invoice_line.CUSTOMERDIMKEY
LEFT JOIN ICRW_SCHEMA.department dimensions_department ON dimensions_department.CNY_ = accounts_receivable_recurring_invoice_line.CNY_ AND dimensions_department.record_ = accounts_receivable_recurring_invoice_line.DEPT#
LEFT JOIN ICRW_SCHEMA.employee dimensions_employee ON dimensions_employee.CNY_ = accounts_receivable_recurring_invoice_line.CNY_ AND dimensions_employee.record_ = accounts_receivable_recurring_invoice_line.EMPLOYEEDIMKEY
LEFT JOIN ICRW_SCHEMA.icitem dimensions_item ON dimensions_item.CNY_ = accounts_receivable_recurring_invoice_line.CNY_ AND dimensions_item.record_ = accounts_receivable_recurring_invoice_line.ITEMDIMKEY
LEFT JOIN ICRW_SCHEMA.location dimensions_location ON dimensions_location.CNY_ = accounts_receivable_recurring_invoice_line.CNY_ AND dimensions_location.record_ = accounts_receivable_recurring_invoice_line.LOCATION#
LEFT JOIN ICRW_SCHEMA.project dimensions_project ON dimensions_project.CNY_ = accounts_receivable_recurring_invoice_line.CNY_ AND dimensions_project.record_ = accounts_receivable_recurring_invoice_line.PROJECTDIMKEY
LEFT JOIN ICRW_SCHEMA.task dimensions_task ON dimensions_task.CNY_ = accounts_receivable_recurring_invoice_line.CNY_ AND dimensions_task.record_ = accounts_receivable_recurring_invoice_line.TASKDIMKEY
LEFT JOIN ICRW_SCHEMA.vendor dimensions_vendor ON dimensions_vendor.CNY_ = accounts_receivable_recurring_invoice_line.CNY_ AND dimensions_vendor.record_ = accounts_receivable_recurring_invoice_line.VENDORDIMKEY
LEFT JOIN ICRW_SCHEMA.icwarehouse dimensions_warehouse ON dimensions_warehouse.CNY_ = accounts_receivable_recurring_invoice_line.CNY_ AND dimensions_warehouse.record_ = accounts_receivable_recurring_invoice_line.WAREHOUSEDIMKEY
;

------ CONTENT OF accounts_receivable_term


CREATE OR REPLACE SECURE VIEW ACCOUNTS_RECEIVABLE_TERM
 COMMENT =  "Version=5d46b435-b116-4379-9a89-9ca3a2b867f9 "
 AS SELECT

-- 	end custom fields
accounts_receivable_term.cny_ AS cnyNumber,
accounts_receivable_term.description AS description ,
accounts_receivable_term.name AS id ,
accounts_receivable_term.record_ AS key ,
accounts_receivable_term.status AS status ,
accounts_receivable_term.createdby AS audit_createdby ,
accounts_receivable_term.whencreated AS audit_createddatetime ,
accounts_receivable_term.modifiedby AS audit_modifiedby ,
accounts_receivable_term.whenmodified AS audit_modifieddatetime ,
accounts_receivable_term.discamount AS discount_amount ,
accounts_receivable_term.disccalcon AS discount_calculation ,
accounts_receivable_term.discdate AS discount_days ,
accounts_receivable_term.discfrom AS discount_from ,
accounts_receivable_term.discfudgedays AS discount_gracedays ,
accounts_receivable_term.discpercamn AS discount_unit ,
accounts_receivable_term.duedate AS due_days ,
accounts_receivable_term.duefrom AS due_from ,
accounts_receivable_term.penamount AS penalty_amount ,
accounts_receivable_term.pen_types AS penalty_cycle ,
accounts_receivable_term.penfudgedays AS penalty_gracedays ,
accounts_receivable_term.penpercamn AS penalty_unit
FROM  SIF_SAGE_VIEWS.V_SA_arterm  accounts_receivable_term

LEFT JOIN SIF_SAGE_VIEWS.V_SA_userinfo audit_createdbyuser ON audit_createdbyuser.cny_ = accounts_receivable_term.cny_ and audit_createdbyuser.record_ = accounts_receivable_term.createdby
LEFT JOIN SIF_SAGE_VIEWS.V_SA_userinfo audit_modifiedbyuser ON audit_modifiedbyuser.cny_ = accounts_receivable_term.cny_ and audit_modifiedbyuser.record_ = accounts_receivable_term.modifiedby

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

