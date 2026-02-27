/*
accounts_receivable_payment
accounts_receivable_payment_line
accounts_receivable_customer
accounts_receivable_invoice
accounts_receivable_invoice_line
accounts_receivable_term
company_config_location
*/


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
    LEFT JOIN SIF_SAGE_VIEWS.V_SA_LOCATION melocation ON melocation.cny_ = accounts_receivable_payment.cny_ AND melocation.record_ = accounts_receivable_payment.record_
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
LEFT JOIN SIF_SAGE_VIEWS.V_SA_LOCATION melocation ON melocation.cny_ = accounts_receivable_invoice.cny_ and melocation.record_ = accounts_receivable_invoice.record_
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
accounts_receivable_term.disccalcon AS discount_calculateon ,
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
parent.name AS parent_name
FROM  SIF_SAGE_VIEWS.V_SA_location  company_config_location

LEFT JOIN SIF_SAGE_VIEWS.V_SA_userinfo audit_createdbyuser ON audit_createdbyuser.cny_ = company_config_location.cny_ and audit_createdbyuser.record_ = company_config_location.createdby
LEFT JOIN SIF_SAGE_VIEWS.V_SA_userinfo audit_modifiedbyuser ON audit_modifiedbyuser.cny_ = company_config_location.cny_ and audit_modifiedbyuser.record_ = company_config_location.modifiedby
LEFT JOIN SIF_SAGE_VIEWS.V_SA_contact contacts_primary ON contacts_primary.cny_ = company_config_location.cny_ and contacts_primary.record_ = company_config_location.contactkey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_contact contacts_shipto ON contacts_shipto.cny_ = company_config_location.cny_ and contacts_shipto.record_ = company_config_location.shiptokey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_location parent ON parent.cny_ = company_config_location.cny_ and parent.record_ = company_config_location.parentkey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_employee manageremp ON manageremp.cny_ = company_config_location.cny_ and manageremp.employeeid = company_config_location.employeekey
LEFT JOIN SIF_SAGE_VIEWS.V_SA_contact mcontact ON manageremp.cny_ = company_config_location.cny_ and manageremp.employeeid = company_config_location.employeekey and mcontact.cny_ = company_config_location.cny_  and mcontact.record_ = manageremp.contactkey

;

