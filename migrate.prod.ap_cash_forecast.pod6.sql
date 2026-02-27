/*
accounts_payable_payment_detail
accounts_payable_payment
accounts_payable_payment_line
accounts_payable_vendor
accounts_payable_bill
accounts_payable_bill_line
accounts_payable_term
*/


------ CONTENT OF accounts_payable_payment_detail

CREATE OR REPLACE SECURE VIEW accounts_payable_payment_detail
  WITH ROW ACCESS POLICY SIF_REPLICATION_SCHEMA.ENFORCE_COMPANY_ACCESS ON (cnyNumber)
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

CREATE OR REPLACE SECURE VIEW ACCOUNTS_PAYABLE_PAYMENT
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
    exchangerateinfo.exch_rate_type_id AS exchangeRate_typeId,
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

