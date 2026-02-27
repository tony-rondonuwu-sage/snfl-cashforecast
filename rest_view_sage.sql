   


   ------ CONTENT OF general_ledger_detail   


   CREATE OR REPLACE SECURE VIEW GENERAL_LEDGER_DETAIL
    COMMENT =  "Version=cfdda6ed-e587-4d5c-b4c6-ce9b5b6e58c3 " 
    AS SELECT 
    
 	-- 	end custom fields 
  general_ledger_detail.cny_ AS cnyNumber, 
 	general_ledger_detail.batch_ || '-' || general_ledger_detail.record_ || '-' || prgl.prentrykey || '-' || prgl.cbprentrykey || '-' || lower(bj.bookid) AS id , 
 	 glb.referenceno AS journalentryreferencenumber , 
 	(select max(p.record_)  from DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_glbudgettype p  where p.budgeting = 't' and general_ledger_detail.entry_date between p.start_date and p.end_date)  AS periodkey , 
 	general_ledger_detail.batch_ AS batchkey , 
 	general_ledger_detail.adj AS isadjustmententry , 
 	general_ledger_detail.record_ AS generalledgerjournalentrykey , 
 	general_ledger_detail.line_no AS linenumber , 
 	general_ledger_detail.entry_date AS entrydate , 
 	general_ledger_detail.tr_type AS debitorcredit , 
 	general_ledger_detail.document AS journalentrydocumentcolumn , 
 	general_ledger_detail.account_ AS accountkey , 
 	general_ledger_detail.cleared AS clearedbank , 
 	general_ledger_detail.clrdate AS clearedbankdate , 
 	general_ledger_detail.timeperiod AS timeperiod , 
 	general_ledger_detail.location_ AS locationkey , 
 	general_ledger_detail.dept_ AS departmentkey , 
 	general_ledger_detail.customerdimkey AS customerdimkey , 
 	general_ledger_detail.projectdimkey AS projectdimkey , 
 	general_ledger_detail.vendordimkey AS vendordimkey , 
 	general_ledger_detail.employeedimkey AS employeedimkey , 
 	general_ledger_detail.itemdimkey AS itemdimkey , 
 	general_ledger_detail.classdimkey AS classdimkey , 
 	general_ledger_detail.contractdimkey AS contractdimkey , 
 	general_ledger_detail.taskdimkey AS taskdimkey , 
 	general_ledger_detail.warehousedimkey AS warehousedimkey , 
 	general_ledger_detail.costtypedimkey AS costtypedimkey , 
 	general_ledger_detail.class2dimkey AS class2dimkey , 
 	general_ledger_detail.assetdimkey AS assetdimkey , 
 	general_ledger_detail.customdimensions AS customdimension , 
 	general_ledger_detail.basecurr AS basecurrency , 
 	decode(prgl.currency, null, general_ledger_detail.currency, prgl.currency) AS transactioncurrency , 
 	decode(prgl.description, null, general_ledger_detail.description, prgl.description) AS description , 
 	decode(general_ledger_detail.tr_type, 1, decode(prgl.amount, null, general_ledger_detail.amount, prgl.amount), 0) AS debitamount , 
 	decode(general_ledger_detail.tr_type, -1, decode(prgl.amount, null, general_ledger_detail.amount, prgl.amount), 0)  AS creditamount , 
 	decode(prgl.amount, null, general_ledger_detail.amount, prgl.amount) * general_ledger_detail.tr_type  AS amount , 
 	decode(general_ledger_detail.tr_type, 1, decode(prgl.trx_amount, null, general_ledger_detail.trx_amount, prgl.trx_amount), 0)  AS txndebitamount , 
 	decode(general_ledger_detail.tr_type, -1, decode(prgl.trx_amount, null, general_ledger_detail.trx_amount, prgl.trx_amount), 0) AS txncreditamount , 
 	decode(prgl.trx_amount, null, general_ledger_detail.trx_amount, prgl.trx_amount) * general_ledger_detail.tr_type  AS txnamount , 
 	pe.description AS documententrymemo , 
 	substr(pr.custentity, 2) AS customer , 
 	substr(pr.vendentity, 2)  AS vendor , 
 	substr(pr.empentity, 2) AS employeeentity , 
 	substr(pr.locentity, 2) AS ietsourceentity , 
 	decode(pr.recordtype, null, '', 'cb', 'debit card transaction', 'cc', 'credit card fees', 'cd', 'deposit slips','ch', 'bank charge', 'ci', 'credit card charge', 'ck', 'manual check', 'cn', 'bank interest', 'cp','credit card payment', 'cq', 'quick invoice', 'cr', 'other receipts', 'ct', 'funds transfer', 'cw','cash mgmt printed quick check', 'cx', 'charge payoff (payment)', 'ei', 'employee expenses', 'em','expense expense realized multi-currency gain/loss', 'eo', 'applied emplyee advance', 'ep','employee reimbursements', 'er', 'employee advance', 'pa', 'ap adjustments', 'pd', 'ar discount', 'pe','inter-entity payable', 'pi', 'ap bill', 'pm', 'ap realized multi-currency gain/loss', 'po','ap applied advance', 'pp', 'ap payment', 'pr', 'ap advance', 'ra', 'ar adjustments', 'rd', 'ar discount','re', 'inter-entity receivable', 'ri', 'ar invoice', 'rm', 'ar realized multi-currency gain/loss', 'ro','ar applied advance/overpayment', 'rp', 'ar receipts', 'rr', 'ar advance','other recordtype')  AS recordtype , 
 	pr.state AS state , 
 	pr.whencreated AS createddate , 
 	pr.description AS documentdescription , 
 	pr.cleared AS txncleared , 
 	pr.clrdate AS txncleardate , 
 	general_ledger_detail.state AS glentrystate , 
 	general_ledger_detail.whencreated AS audit_whencreated , 
 	general_ledger_detail.whenmodified AS audit_whenmodified , 
 	general_ledger_detail.createdby AS audit_createdby , 
 	general_ledger_detail.modifiedby AS audit_modifiedb 
 FROM  DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_glentry  general_ledger_detail 
 	INNER JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_glbatch glb ON general_ledger_detail.batch_ = glb.record_ and general_ledger_detail.cny_ = glb.cny_ 
 	INNER JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_glaccount gla ON gla.record_ = general_ledger_detail.account_ and general_ledger_detail.cny_ = gla.cny_ 
 	INNER JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_bookjournals bj ON bj.journalkey = glb.journal_ and general_ledger_detail.cny_ = bj.cny_ 
  
 	LEFT OUTER JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_prglentryresolve prgl ON general_ledger_detail.record_ = prgl.glentrykey and general_ledger_detail.cny_ = prgl.cny_ 
 	LEFT OUTER JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_prentry pe ON prgl.prentrykey = pe.record_ and general_ledger_detail.cny_ = pe.cny_ 
 	LEFT OUTER JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_prrecord pr ON pe.recordkey = pr.record_ and general_ledger_detail.cny_ = pr.cny_ 
  ;   


   ------ CONTENT OF general_ledger_reporting_period   


   CREATE OR REPLACE SECURE VIEW GENERAL_LEDGER_REPORTING_PERIOD
    COMMENT =  "Version=545ba1c3-ac47-4130-adca-d54a00b28080 " 
    AS SELECT 
    
 	-- 	end custom fields 
  general_ledger_reporting_period.cny_ AS cnyNumber, 
 	general_ledger_reporting_period.header1 AS columnheader1 , 
 	general_ledger_reporting_period.header2 AS columnheader2 , 
 	general_ledger_reporting_period.datetype AS datetype , 
 	general_ledger_reporting_period.end_date AS enddate , 
 	general_ledger_reporting_period.name AS id , 
 	general_ledger_reporting_period.budgeting AS isbudgetable , 
 	general_ledger_reporting_period.record_ AS key , 
 	general_ledger_reporting_period.start_date AS startdate , 
 	general_ledger_reporting_period.status AS status , 
 	general_ledger_reporting_period.createdby AS audit_createdby , 
 	general_ledger_reporting_period.whencreated AS audit_createddatetime , 
 	general_ledger_reporting_period.modifiedby AS audit_modifiedby , 
 	general_ledger_reporting_period.whenmodified AS audit_modifieddatetime 
 FROM  DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_glbudgettype  general_ledger_reporting_period 
  
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_createdbyuser ON audit_createdbyuser.cny_ = general_ledger_reporting_period.cny_ and audit_createdbyuser.record_ = general_ledger_reporting_period.createdby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_modifiedbyuser ON audit_modifiedbyuser.cny_ = general_ledger_reporting_period.cny_ and audit_modifiedbyuser.record_ = general_ledger_reporting_period.modifiedby 
  
  ;   


   ------ CONTENT OF accounts_payable_recurring_bill   


   CREATE OR REPLACE SECURE VIEW ACCOUNTS_PAYABLE_RECURRING_BILL
    COMMENT =  "Version=cfdda6ed-e587-4d5c-b4c6-ce9b5b6e58c3 " 
    AS SELECT 
    
 	-- 	end custom fields 
  accounts_payable_recurring_bill.cny_ AS cnyNumber, 
 	accounts_payable_recurring_bill.cny_ AS cnynumber , 
 	accounts_payable_recurring_bill.recordid AS billnumber , 
 	accounts_payable_recurring_bill.description AS description , 
 	accounts_payable_recurring_bill.record_ AS id , 
 	accounts_payable_recurring_bill.inclusivetax AS istaxinclusive , 
 	accounts_payable_recurring_bill.modulekey AS modulekey , 
 	accounts_payable_recurring_bill.docnumber AS referencenumber , 
 	accounts_payable_recurring_bill.status AS status , 
 	accounts_payable_recurring_bill.totalentered AS totalentered , 
 	accounts_payable_recurring_bill.trx_totalentered AS txntotalentered , 
 	accounts_payable_recurring_bill.createdby AS audit_createdby , 
 	accounts_payable_recurring_bill.whencreated AS audit_createddatetime , 
 	accounts_payable_recurring_bill.modifiedby AS audit_modifiedby , 
 	accounts_payable_recurring_bill.whenmodified AS audit_modifieddatetime , 
 	accounts_payable_recurring_bill.basecurr AS currency_basecurrency , 
 	accounts_payable_recurring_bill.currency AS currency_txncurrency , 
 	schedule.enddate AS schedule_enddate , 
 	schedule.execcount AS schedule_executioncount , 
 	schedule.nextexecdate AS schedule_nextexecutiondate , 
 	schedule.startdate AS schedule_startdate , 
 	accounts_payable_recurring_bill.contractdesc AS contract_description , 
 	accounts_payable_recurring_bill.contractid AS contract_id , 
 	accounts_payable_recurring_bill.locationkey AS entity_key , 
 	accounts_payable_recurring_bill.schopkey AS recurringschedule_id , 
 	accounts_payable_recurring_bill.taxsolutionkey AS taxsolution_key , 
 	accounts_payable_recurring_bill.termkey AS term_key , 
 	vendor.record_ AS vendor_key 
 FROM  DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_recurbillscheduledop  accounts_payable_recurring_bill 
  
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_TERM term ON term.cny_ = accounts_payable_recurring_bill.cny_ and term.record_ = accounts_payable_recurring_bill.termkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_LOCATION melocation ON melocation.cny_ = accounts_payable_recurring_bill.cny_ and melocation.record_ = accounts_payable_recurring_bill.locationkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_vendor vendor ON vendor.cny_ = accounts_payable_recurring_bill.cny_ and vendor.entity = accounts_payable_recurring_bill.record_ 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_schedule schedule ON schedule.cny_ = accounts_payable_recurring_bill.cny_ and schedule.record_ = accounts_payable_recurring_bill.schopkey 
  
  ;   


   ------ CONTENT OF core_scheduled_operation   


   CREATE OR REPLACE SECURE VIEW CORE_SCHEDULED_OPERATION
    COMMENT =  "Version=cfdda6ed-e587-4d5c-b4c6-ce9b5b6e58c3 " 
    AS SELECT 
    
 	-- 	end custom fields 
  core_scheduled_operation.cny_ AS cnyNumber, 
 	core_scheduled_operation.description AS description , 
 	core_scheduled_operation.name AS id , 
 	core_scheduled_operation.record_ AS key , 
 	core_scheduled_operation.operation_ AS operation_ , 
 	core_scheduled_operation.schedule_ AS schedule_ey , 
 	core_scheduled_operation.status AS status 
 FROM  DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_scheduledoperation  core_scheduled_operation 
  
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo userinfo ON userinfo.record_ = core_scheduled_operation.user_ and userinfo.cny_ = core_scheduled_operation.cny_ 
  
  ;   


   ------ CONTENT OF core_operation   


   CREATE OR REPLACE SECURE VIEW CORE_OPERATION
    COMMENT =  "Version=cfdda6ed-e587-4d5c-b4c6-ce9b5b6e58c3 " 
    AS SELECT 
    
 	-- 	end custom fields 
  core_operation.cny_ AS cnyNumber, 
 	core_operation.action AS action , 
 	core_operation.contactemail AS contactemail , 
 	core_operation.description AS description , 
 	core_operation.entity AS entity , 
 	core_operation.name AS id , 
 	core_operation.record_ AS key , 
 	core_operation.locationkey AS locationkey , 
 	core_operation.modulekey AS modulekey , 
 	core_operation.status AS status , 
 	core_operation.user_ AS userkey 
 FROM  DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_operation  core_operation 
  
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo userinfo ON userinfo.record_ = core_operation.user_ and userinfo.cny_ = core_operation.cny_ 
  
  ;   


   ------ CONTENT OF general_ledger_journal_entry   


   CREATE OR REPLACE SECURE VIEW GENERAL_LEDGER_JOURNAL_ENTRY
    COMMENT =  "Version=cfdda6ed-e587-4d5c-b4c6-ce9b5b6e58c3 " 
    AS SELECT 
    
 	-- 	end custom fields 
  general_ledger_journal_entry.cny_ AS cnyNumber, 
 	general_ledger_journal_entry.batch_title AS description , 
 	general_ledger_journal_entry.record_ AS id , 
 	general_ledger_journal_entry.modulekey AS modulename , 
 	general_ledger_journal_entry.batch_date AS postingdate , 
 	general_ledger_journal_entry.referenceno AS referencenumber , 
 	reversedbatch.batch_date AS reversedfromdate , 
 	general_ledger_journal_entry.journalseqno AS sequencenumber , 
 	general_ledger_journal_entry.state AS state , 
 	general_ledger_journal_entry.batch_no AS txnnumber , 
 	general_ledger_journal_entry.createdby AS audit_createdby , 
 	general_ledger_journal_entry.whencreated AS audit_createddatetime , 
 	general_ledger_journal_entry.modifiedby AS audit_modifiedby , 
 	general_ledger_journal_entry.whenmodified AS audit_modifieddatetime , 
 	general_ledger_journal_entry.taximplication AS tax_taximplication , 
 	tax_contact.record_ AS vatcontactkey , 
 	tax_customer.record_ AS vatcustomerkey , 
 	tax_vendor.record_ AS vatvendorkey , 
 	general_ledger_journal_entry.glacctallocationrunkey AS accountallocationrun_id , 
 	supdoc.record_ AS attachment_key , 
 	general_ledger_journal_entry.baselocation AS baselocation_key , 
 	general_ledger_journal_entry.locationkey AS entity_key , 
 	general_ledger_journal_entry.reversedkey AS reversedby_id 
 FROM  DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_glbatch  general_ledger_journal_entry 
  
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_glbatch reversedbatch ON reversedbatch.cny_ = general_ledger_journal_entry.cny_ and reversedbatch.record_ = general_ledger_journal_entry.reversedkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_createdbyuser ON audit_createdbyuser.cny_ = general_ledger_journal_entry.cny_ and audit_createdbyuser.record_ = general_ledger_journal_entry.createdby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_modifiedbyuser ON audit_modifiedbyuser.cny_ = general_ledger_journal_entry.cny_ and audit_modifiedbyuser.record_ = general_ledger_journal_entry.modifiedby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_contact tax_contact ON tax_contact.cny_ = general_ledger_journal_entry.cny_ and tax_contact.record_ = general_ledger_journal_entry.contactkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_customer tax_customer ON tax_customer.cny_ = general_ledger_journal_entry.cny_ and tax_customer.record_ = general_ledger_journal_entry.customerkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_vendor tax_vendor ON tax_vendor.cny_ = general_ledger_journal_entry.cny_ and tax_vendor.record_ = general_ledger_journal_entry.vendorkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_location melocation ON melocation.cny_ = general_ledger_journal_entry.cny_ and melocation.record_ = general_ledger_journal_entry.locationkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_location baseloc ON baseloc.cny_ = general_ledger_journal_entry.cny_ and baseloc.record_ = general_ledger_journal_entry.baselocation 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_gljournal journal ON journal.cny_ = general_ledger_journal_entry.cny_ and journal.record_ = general_ledger_journal_entry.journal_ 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_supdoc supdoc ON supdoc.record_ = general_ledger_journal_entry.record_  
  
  ;   


   ------ CONTENT OF general_ledger_budget   


   CREATE OR REPLACE SECURE VIEW GENERAL_LEDGER_BUDGET
    COMMENT =  "Version=cfdda6ed-e587-4d5c-b4c6-ce9b5b6e58c3 " 
    AS SELECT 
    
 	-- 	end custom fields 
  general_ledger_budget.cny_ AS cnyNumber, 
 	general_ledger_budget.isconsolidated AS consolidateamounts , 
 	general_ledger_budget.currency AS currency , 
 	general_ledger_budget.description AS description , 
 	general_ledger_budget.budgetid AS id , 
 	general_ledger_budget.default_budget AS isdefault , 
 	general_ledger_budget.record_ AS key , 
 	general_ledger_budget.ispcnbudget AS postprojectcontract , 
 	general_ledger_budget.ispabudget AS postprojectestimate , 
 	general_ledger_budget.status AS status , 
 	general_ledger_budget.whencreated AS audit_createddatetime , 
 	general_ledger_budget.whenmodified AS audit_modifieddatetime , 
 	audit_createdbyuser.record_ AS createdby , 
 	audit_modifiedbyuser.record_ AS modifiedby , 
 	general_ledger_budget.melockey AS entity_key 
 FROM  DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_budgetheader  general_ledger_budget 
  
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_createdbyuser ON audit_createdbyuser.cny_ = general_ledger_budget.cny_ and audit_createdbyuser.record_ = general_ledger_budget.createdby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_modifiedbyuser ON audit_modifiedbyuser.cny_ = general_ledger_budget.cny_ and audit_modifiedbyuser.record_ = general_ledger_budget.modifiedby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_location melocation ON melocation.cny_ = general_ledger_budget.cny_ and melocation.record_ = general_ledger_budget.record_ 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_USERINFO userinfo ON general_ledger_budget.cny_ and userinfo.record_ = general_ledger_budget.userkey 
  
  ;   


   ------ CONTENT OF accounts_receivable_customer_type   


   CREATE OR REPLACE SECURE VIEW ACCOUNTS_RECEIVABLE_CUSTOMER_TYPE
    COMMENT =  "Version=cfdda6ed-e587-4d5c-b4c6-ce9b5b6e58c3 " 
    AS SELECT 
    
 	-- 	end custom fields 
  accounts_receivable_customer_type.cny_ AS cnyNumber, 
 	accounts_receivable_customer_type.name AS id , 
 	accounts_receivable_customer_type.record_ AS key , 
 	accounts_receivable_customer_type.status AS status , 
 	accounts_receivable_customer_type.createdby AS audit_createdby , 
 	accounts_receivable_customer_type.whencreated AS audit_createddatetime , 
 	accounts_receivable_customer_type.modifiedby AS audit_modifiedby , 
 	accounts_receivable_customer_type.whenmodified AS audit_modifieddatetime , 
 	accounts_receivable_customer_type.locationkey AS entity_key , 
 	melocation.name AS entity_name , 
 	parent.name AS parent_id 
 FROM  DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_custtype  accounts_receivable_customer_type 
  
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_createdbyuser ON audit_createdbyuser.cny_ = accounts_receivable_customer_type.cny_ and audit_createdbyuser.record_ = accounts_receivable_customer_type.createdby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_modifiedbyuser ON audit_modifiedbyuser.cny_ = accounts_receivable_customer_type.cny_ and audit_modifiedbyuser.record_ = accounts_receivable_customer_type.modifiedby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_LOCATION melocation ON melocation.cny_ = accounts_receivable_customer_type.cny_ and melocation.record_ = accounts_receivable_customer_type.locationkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_custtype parent ON parent.cny_ = accounts_receivable_customer_type.cny_ and parent.record_ = accounts_receivable_customer_type.parentkey 
  
  ;   


   ------ CONTENT OF cash_management_bank_transaction   


   CREATE OR REPLACE SECURE VIEW CASH_MANAGEMENT_BANK_TRANSACTION
    COMMENT =  "Version=cfdda6ed-e587-4d5c-b4c6-ce9b5b6e58c3 " 
    AS SELECT 
    
 	-- 	end custom fields 
  cash_management_bank_transaction.cny_ AS cnyNumber, 
 	cash_management_bank_transaction.record_ AS id , 
 	cash_management_bank_transaction.trxtype AS txntype , 
 	cash_management_bank_transaction.acctreconkey AS bankreconciliationkey , 
 	cash_management_bank_transaction.postingdate AS postingdate , 
 	cash_management_bank_transaction.doc_ AS documentnumber , 
 	cash_management_bank_transaction.doctype AS documenttype , 
 	cash_management_bank_transaction.payee AS payee , 
 	cash_management_bank_transaction.cleared AS   reconciliationstate , 
 	cash_management_bank_transaction.createdby AS audit_createdby , 
 	cash_management_bank_transaction.whencreated AS audit_createddatetime , 
 	cash_management_bank_transaction.modifiedby AS audit_modifiedby , 
 	cash_management_bank_transaction.whenmodified AS audit_modifieddatetime , 
 	cash_management_bank_transaction.category AS   categorydata_category , 
 	cash_management_bank_transaction.bankrefnumber AS bankreferencenumber , 
 	cash_management_bank_transaction.displaylettragecode AS displayletteragecode 
 FROM  DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_FINACCTTXNRECORD  cash_management_bank_transaction 
  
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_createdbyuser ON audit_createdbyuser.cny_ = cash_management_bank_transaction.cny_ and audit_createdbyuser.record_ = cash_management_bank_transaction.createdby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_modifiedbyuser ON audit_modifiedbyuser.cny_ = cash_management_bank_transaction.cny_ and audit_modifiedbyuser.record_ = cash_management_bank_transaction.modifiedby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_FINACCTTXNFEED finaccttxnfeed ON cash_management_bank_transaction.finaccttxnfeedkey = finaccttxnfeed.record_ and finaccttxnfeed.cny_ = cash_management_bank_transaction.cny_ 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_BANKACCOUNT financialaccount ON cash_management_bank_transaction.finaccttxnfeedkey = finaccttxnfeed.record_ and finaccttxnfeed.cny_ = cash_management_bank_transaction.cny_ and financialaccount.cny_ = finaccttxnfeed.cny_  and financialaccount.accountid = finaccttxnfeed.financialentity 
  
  ;   


   ------ CONTENT OF accounts_receivable_invoice   


   CREATE OR REPLACE SECURE VIEW ACCOUNTS_RECEIVABLE_INVOICE
    COMMENT =  "Version=cfdda6ed-e587-4d5c-b4c6-ce9b5b6e58c3 " 
    AS SELECT 
    
 	-- 	end custom fields 
  accounts_receivable_invoice.cny_ AS cnyNumber, 
 	accounts_receivable_invoice.description AS description , 
 	accounts_receivable_invoice.whendiscount AS discountcutoffdate , 
 	accounts_receivable_invoice.description2 AS documentid , 
 	accounts_receivable_invoice.whendue AS duedate , 
 	accounts_receivable_invoice.record_ AS id , 
 	accounts_receivable_invoice.whencreated AS invoicedate , 
 	accounts_receivable_invoice.recordid AS invoicenumber , 
 	accounts_receivable_invoice.systemgenerated AS issystemgenerateddocument , 
 	accounts_receivable_invoice.modulekey AS modulekey , 
 	accounts_receivable_invoice.recordtype AS recordtype , 
 	accounts_receivable_invoice.docnumber AS referencenumber , 
 	accounts_receivable_invoice.state AS state , 
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
 	accounts_receivable_invoice.custmessageid AS customermessage_id , 
 	accounts_receivable_invoice.locationkey AS entity_key , 
 	accounts_receivable_invoice.prbatchkey AS invoicesummary_key , 
 	accounts_receivable_invoice.termkey AS term_key 
 FROM  DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_prrecord  accounts_receivable_invoice 
  
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_createdbyuser ON audit_createdbyuser.cny_ = accounts_receivable_invoice.cny_ and audit_createdbyuser.record_ = accounts_receivable_invoice.createdby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_modifiedbyuser ON audit_modifiedbyuser.cny_ = accounts_receivable_invoice.cny_ and audit_modifiedbyuser.record_ = accounts_receivable_invoice.modifiedby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_PRBATCH batch ON batch.cny_ = accounts_receivable_invoice.cny_ and batch.record_ = accounts_receivable_invoice.prbatchkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_CUSTOMER customer ON customer.cny_ = accounts_receivable_invoice.cny_ and customer.record_ = accounts_receivable_invoice.customerkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_CONTACT billto ON billto.cny_ = accounts_receivable_invoice.cny_ and billto.record_ = accounts_receivable_invoice.billtopaytokey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_CONTACT shipto ON shipto.cny_ = accounts_receivable_invoice.cny_ and shipto.record_ = accounts_receivable_invoice.shiptoreturntokey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_TAXSOLUTION taxsolution ON taxsolution.cny_ = accounts_receivable_invoice.cny_ and taxsolution.record_ = accounts_receivable_invoice.taxsolutionkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_EXCHANGERATEINFO exchangerateinfo ON exchangerateinfo.cny_ = accounts_receivable_invoice.cny_ and exchangerateinfo.recordkey = accounts_receivable_invoice.record_ 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_LOCATION melocation ON melocation.cny_ = accounts_receivable_invoice.cny_ and melocation.record_ = accounts_receivable_invoice.record_ 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_TERM term ON term.cny_ = accounts_receivable_invoice.cny_ and term.record_ = accounts_receivable_invoice.termkey 
  
  ;   


   ------ CONTENT OF accounts_payable_term   


   CREATE OR REPLACE SECURE VIEW ACCOUNTS_PAYABLE_TERM
    COMMENT =  "Version=cfdda6ed-e587-4d5c-b4c6-ce9b5b6e58c3 " 
    AS SELECT 
    
 	-- 	end custom fields 
  accounts_payable_term.cny_ AS cnyNumber, 
 	accounts_payable_term.description AS description , 
 	accounts_payable_term.name AS id , 
 	accounts_payable_term.record_ AS key , 
 	accounts_payable_term.status AS status , 
 	accounts_payable_term.createdby AS audit_createdby , 
 	accounts_payable_term.whencreated AS audit_createddatetime , 
 	accounts_payable_term.modifiedby AS audit_modifiedby , 
 	accounts_payable_term.whenmodified AS audit_modifieddatetime , 
 	accounts_payable_term.discamount AS discount_amount , 
 	accounts_payable_term.disccalcon AS discount_calculateon , 
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
 FROM  DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_apterm  accounts_payable_term 
  
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_createdbyuser ON audit_createdbyuser.cny_ = accounts_payable_term.cny_ and audit_createdbyuser.record_ = accounts_payable_term.createdby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_modifiedbyuser ON audit_modifiedbyuser.cny_ = accounts_payable_term.cny_ and audit_modifiedbyuser.record_ = accounts_payable_term.modifiedby 
  
  ;   


   ------ CONTENT OF accounts_payable_payment   


   CREATE OR REPLACE SECURE VIEW ACCOUNTS_PAYABLE_PAYMENT
    COMMENT =  "Version=cfdda6ed-e587-4d5c-b4c6-ce9b5b6e58c3 " 
    AS SELECT 
    
 	-- 	end custom fields 
  accounts_payable_payment.cny_ AS cnyNumber, 
 	accounts_payable_payment.cleared AS cleared , 
 	accounts_payable_payment.clrdate AS cleareddate , 
 	accounts_payable_payment.description AS description , 
 	accounts_payable_payment.description2 AS documentid , 
 	accounts_payable_payment.docnumber AS documentnumber , 
 	accounts_payable_payment.record_ AS id , 
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
 	accounts_payable_payment.billtopaytokey AS payto_key , 
 	accounts_payable_payment.providerkey AS paymentprovider_key , 
 	accounts_payable_payment.prbatchkey AS paymentsummary_id , 
 	accounts_payable_payment.taxsolutionkey AS taxsolution_key , 
 	accounts_payable_payment.entity AS vendor_entity , 
 	accounts_payable_payment.vendorkey AS vendor_key 
 FROM  DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_prrecord  accounts_payable_payment 
  
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_createdbyuser ON audit_createdbyuser.cny_ = accounts_payable_payment.cny_ and audit_createdbyuser.record_ = accounts_payable_payment.createdby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_modifiedbyuser ON audit_modifiedbyuser.cny_ = accounts_payable_payment.cny_ and audit_modifiedbyuser.record_ = accounts_payable_payment.modifiedby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_LOCATION melocation ON melocation.cny_ = accounts_payable_payment.cny_ and melocation.record_ = accounts_payable_payment.locationkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_EXCHANGERATEINFO exchangerateinfo ON exchangerateinfo.cny_ = accounts_payable_payment.cny_ and exchangerateinfo.recordkey = accounts_payable_payment.record_ 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_TAXSOLUTION taxsolution ON taxsolution.cny_ = accounts_payable_payment.cny_ and taxsolution.record_ = accounts_payable_payment.taxsolutionkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_vendor vendor ON vendor.cny_ = accounts_payable_payment.cny_ and vendor.record_ = accounts_payable_payment.vendorkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_PRBATCH batch ON batch.cny_ = accounts_payable_payment.cny_ and batch.record_ = accounts_payable_payment.prbatchkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_CONTACTVERSION payto ON payto.cny_ = accounts_payable_payment.cny_ and payto.record_ = accounts_payable_payment.billtopaytokey 
  
  ;   


   ------ CONTENT OF company_config_entity   


   CREATE OR REPLACE SECURE VIEW COMPANY_CONFIG_ENTITY
    COMMENT =  "Version=cfdda6ed-e587-4d5c-b4c6-ce9b5b6e58c3 " 
    AS SELECT 
    
 	-- 	end custom fields 
  company_config_entity.cny_ AS cnyNumber, 
 	company_config_entity.accountingtype AS accountingtype , 
 	company_config_entity.businessdays AS businessdays , 
 	company_config_entity.siret AS businessid , 
 	company_config_entity.addresscountrydefault AS defaultcountryforaddresses , 
 	company_config_entity.ierel AS enableinterentityrelationships , 
 	company_config_entity.end_date AS enddate , 
 	company_config_entity.federalid AS federalid , 
 	company_config_entity.firstmonth AS firstfiscalmonth , 
 	company_config_entity.firstmonthtax AS firsttaxmonth , 
 	company_config_entity.location_no AS id , 
 	company_config_entity.defaultpartialexempt AS isdefaultpartialexempt , 
 	company_config_entity.ispartialexempt AS ispartialexempt , 
 	company_config_entity.isroot AS isroot , 
 	company_config_entity.record_ AS key , 
 	company_config_entity.name AS name , 
 	company_config_entity.startopen AS openbooksstartdate , 
 	company_config_entity.start_date AS startdate , 
 	company_config_entity.status AS status , 
 	company_config_entity.weekstart AS weekstart , 
 	company_config_entity.weekends AS weekends , 
 	company_config_entity.createdby AS audit_createdby , 
 	company_config_entity.whencreated AS audit_createddatetime , 
 	company_config_entity.modifiedby AS audit_modifiedby , 
 	company_config_entity.whenmodified AS audit_modifieddatetime , 
 	contacts_primary.name AS contactinfo_contactname , 
 	contacts_primary.record_ AS contactkey , 
 	contacts_shipto.name AS shipto_contactname , 
 	contacts_shipto.record_ AS shiptokey , 
 	company_config_entity.enablelegalcontacttpar AS legalcontact_enableontpar , 
 	company_config_entity.enablelegalcontact AS legalcontact_enableontaxforms , 
 	company_config_entity.legalname AS legalcontact_name , 
 	company_config_entity.legaladdress1 AS legalcontactaddress_address1 , 
 	company_config_entity.legaladdress2 AS legalcontactaddress_address2 , 
 	company_config_entity.legaladdress3 AS legalcontactaddress_address3 , 
 	company_config_entity.legalcity AS legalcontactaddress_city , 
 	company_config_entity.legalcountry AS legalcontactaddress_country , 
 	company_config_entity.legalcountrycode AS legalcontactaddress_countrycode , 
 	company_config_entity.legalstate AS legalcontactaddress_state , 
 	company_config_entity.legalzipcode AS legalcontactaddress_zipcode , 
 	company_config_entity.legalbranchnumber AS legalcontacttpar_branchnumber , 
 	company_config_entity.legalcontactemail AS legalcontacttparcontact_email , 
 	company_config_entity.legalcontactfax AS legalcontacttparcontact_fax , 
 	company_config_entity.legalcontactname AS legalcontacttparcontact_name , 
 	company_config_entity.legalcontactphone AS legalcontacttparcontact_phone , 
 	company_config_entity.custtitle AS texts_customtitle , 
 	company_config_entity.footnotetext AS texts_footnote , 
 	company_config_entity.marketing_text AS texts_marketing , 
 	company_config_entity.message_text AS texts_message , 
 	company_config_entity.reportprintas AS texts_reportprintas , 
 	customer.name AS customer_name , 
 	manageremp.record_ AS manager_key , 
 	mcontact.name AS manager_name , 
 	vendor.name AS vendor_name 
 FROM  DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_location  company_config_entity 
  
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_createdbyuser ON audit_createdbyuser.cny_ = company_config_entity.cny_ and audit_createdbyuser.record_ = company_config_entity.createdby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_modifiedbyuser ON audit_modifiedbyuser.cny_ = company_config_entity.cny_ and audit_modifiedbyuser.record_ = company_config_entity.modifiedby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_contact contacts_primary ON contacts_primary.cny_ = company_config_entity.cny_ and contacts_primary.record_ = company_config_entity.contactkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_contact contacts_shipto ON contacts_shipto.cny_ = company_config_entity.cny_ and contacts_shipto.record_ = company_config_entity.shiptokey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_customer customer ON customer.cny_ = company_config_entity.cny_ and customer.entity = company_config_entity.custentity 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_vendor vendor ON  vendor.cny_ = company_config_entity.cny_ and vendor.entity = company_config_entity.vendentity 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_GLACCOUNT glaccount ON  glaccount.cny_ = company_config_entity.cny_ and glaccount.record_ = company_config_entity.unrecoverabletaxacctkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_TAXSOLUTION taxsolution ON taxsolution.cny_ = company_config_entity.cny_ and taxsolution.record_ = company_config_entity.taxsolutionkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_GLACCOUNT iepayable ON iepayable.cny_ = company_config_entity.cny_ and iepayable.record_ = company_config_entity.iepayableacctkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_GLACCOUNT iereceivable ON iereceivable.cny_ = company_config_entity.cny_ and iereceivable.record_ = company_config_entity.iereceivableacctkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_employee manageremp ON manageremp.cny_ = company_config_entity.cny_ and manageremp.employeeid = company_config_entity.employeekey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_contact mcontact ON manageremp.cny_ = company_config_entity.cny_ and manageremp.employeeid = company_config_entity.employeekey and mcontact.cny_ = company_config_entity.cny_  and mcontact.record_ = manageremp.contactkey 
  
  ;   


   ------ CONTENT OF accounts_payable_bill   


   CREATE OR REPLACE SECURE VIEW ACCOUNTS_PAYABLE_BILL
    COMMENT =  "Version=cfdda6ed-e587-4d5c-b4c6-ce9b5b6e58c3 " 
    AS SELECT 
    
 	-- 	end custom fields 
  accounts_payable_bill.cny_ AS cnyNumber, 
 	accounts_payable_bill.recordid AS billnumber , 
 	accounts_payable_bill.whencreated AS createddate , 
 	accounts_payable_bill.description AS description , 
 	accounts_payable_bill.whendiscount AS discountcutoffdate , 
 	accounts_payable_bill.whendue AS duedate , 
 	accounts_payable_bill.record_ AS id , 
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
 	vendor.totaldue AS vendor_vendordue 
 FROM  DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_prrecord  accounts_payable_bill 
  
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_createdbyuser ON audit_createdbyuser.cny_ = accounts_payable_bill.cny_ and audit_createdbyuser.record_ = accounts_payable_bill.createdby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_modifiedbyuser ON audit_modifiedbyuser.cny_ = accounts_payable_bill.cny_ and audit_modifiedbyuser.record_ = accounts_payable_bill.modifiedby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_TAXSOLUTION taxsolution ON taxsolution.cny_ = accounts_payable_bill.cny_ and taxsolution.record_ = accounts_payable_bill.taxsolutionkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_TERM term ON term.cny_ = accounts_payable_bill.cny_ and term.record_ = accounts_payable_bill.termkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_vendor vendor ON vendor.cny_ = accounts_payable_bill.cny_ and vendor.record_ = accounts_payable_bill.vendorkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_LOCATION melocation ON melocation.cny_ = accounts_payable_bill.cny_ and melocation.record_ = accounts_payable_bill.locationkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_PRBATCH batch ON batch.cny_ = accounts_payable_bill.cny_ and batch.record_ = accounts_payable_bill.prbatchkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_EXCHANGERATEINFO exchangerateinfo ON exchangerateinfo.cny_ = accounts_payable_bill.cny_ and exchangerateinfo.recordkey = accounts_payable_bill.record_ 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_DOCHDR podocument ON podocument.cnyno = accounts_payable_bill.cny_ and podocument.tempprrecordkey = accounts_payable_bill.record_ 
  
   WHERE accounts_payable_bill.recordtype = 'pi';   


   ------ CONTENT OF accounts_payable_bill_line   


   CREATE OR REPLACE SECURE VIEW ACCOUNTS_PAYABLE_BILL_LINE
    COMMENT =  "Version=cfdda6ed-e587-4d5c-b4c6-ce9b5b6e58c3 " 
    AS SELECT 
    
 	-- 	end custom fields 
  accounts_payable_bill_line.cny_ AS cnyNumber, 
 	accounts_payable_bill_line.amount AS baseamount , 
 	accounts_payable_bill_line.entry_date AS createddate , 
 	accounts_payable_bill_line.form1099 AS hasform1099 , 
 	accounts_payable_bill_line.record_ AS id , 
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
 	accounts_payable_bill_line.offsetaccountkey AS overrideoffsetglaccount_key 
 FROM  DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_prentry  accounts_payable_bill_line 
  
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_createdbyuser ON audit_createdbyuser.cny_ = accounts_payable_bill_line.cny_ and audit_createdbyuser.record_ = accounts_payable_bill_line.createdby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_modifiedbyuser ON audit_modifiedbyuser.cny_ = accounts_payable_bill_line.cny_ and audit_modifiedbyuser.record_ = accounts_payable_bill_line.modifiedby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_apaccountlabel apaccountlabel ON apaccountlabel.cnyno = accounts_payable_bill_line.cny_ and apaccountlabel.recordno = accounts_payable_bill_line.accountlabelkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_glaccount glaccount ON glaccount.cny_ = accounts_payable_bill_line.cny_ and glaccount.record_ = accounts_payable_bill_line.accountkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_glaccount offsetglaccountno ON offsetglaccountno.cny_ = accounts_payable_bill_line.cny_ and offsetglaccountno.record_ = accounts_payable_bill_line.offsetaccountkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_ALLOCATION alloc ON alloc.cnyno = accounts_payable_bill_line.cny_ and alloc.record_ = accounts_payable_bill_line.allocationkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_PRRECORD apbill ON apbill.cny_ = accounts_payable_bill_line.cny_ and apbill.record_ = accounts_payable_bill_line.recordkey 
  
   WHERE APBILL.recordtype = 'pi';   


   ------ CONTENT OF general_ledger_journal_entry_line   


   CREATE OR REPLACE SECURE VIEW GENERAL_LEDGER_JOURNAL_ENTRY_LINE
    COMMENT =  "Version=cfdda6ed-e587-4d5c-b4c6-ce9b5b6e58c3 " 
    AS SELECT 
    
 	-- 	end custom fields 
  general_ledger_journal_entry_line.cny_ AS cnyNumber, 
 	general_ledger_journal_entry_line.timeperiod AS accountingperiod , 
 	general_ledger_journal_entry_line.amount AS baseamount , 
 	general_ledger_journal_entry_line.description AS description , 
 	general_ledger_journal_entry_line.document AS documentid , 
 	general_ledger_journal_entry_line.entry_date AS entrydate , 
 	general_ledger_journal_entry_line.record_ AS id , 
 	general_ledger_journal_entry_line.billable AS isbillable , 
 	general_ledger_journal_entry_line.billed AS isbilled , 
 	general_ledger_journal_entry_line.line_no AS linenumber , 
 	general_ledger_journal_entry_line.units AS numberofunits , 
 	general_ledger_journal_entry_line.state AS state , 
 	general_ledger_journal_entry_line.trx_amount AS txnamount , 
 	general_ledger_journal_entry_line.tr_type AS txntype , 
 	general_ledger_journal_entry_line.createdby AS audit_createdby , 
 	general_ledger_journal_entry_line.whencreated AS audit_createddatetime , 
 	general_ledger_journal_entry_line.modifiedby AS audit_modifiedby , 
 	general_ledger_journal_entry_line.whenmodified AS audit_modifieddatetime , 
 	general_ledger_journal_entry_line.basecurr AS currency_basecurrency , 
 	general_ledger_journal_entry_line.exchange_rate AS currency_exchangerate , 
 	general_ledger_journal_entry_line.exch_rate_date AS currency_exchangeratedate , 
 	general_ledger_journal_entry_line.exch_rate_type_id AS currency_exchangeratetypeid , 
 	general_ledger_journal_entry_line.currency AS currency_txncurrency , 
 	dimensions_class.record_ AS classdimkey , 
 	dimensions_contract.record_ AS contractdimkey , 
 	dimensions_costtype.record_ AS costtypedimkey , 
 	dimensions_customer.record_ AS customerdimkey , 
 	dimensions_department.record_ AS departmentkey , 
 	dimensions_employee.record_ AS employeedimkey , 
 	dimensions_item.record_ AS itemdimkey , 
 	dimensions_location.record_ AS locationkey , 
 	dimensions_project.record_ AS projectdimkey , 
 	dimensions_task.record_ AS taskdimkey , 
 	dimensions_vendor.record_ AS vendordimkey , 
 	dimensions_warehouse.record_ AS warehousedimkey , 
 	general_ledger_journal_entry_line.cleared AS reconciliationgroup_cleared , 
 	general_ledger_journal_entry_line.clrdate AS reconciliationgroup_clearingdate , 
 	general_ledger_journal_entry_line.recon_date AS reconciliationgroup_reconciliationdate , 
 	general_ledger_journal_entry_line.allocationkey AS allocation_key , 
 	general_ledger_journal_entry_line.account_ AS glaccount_key , 
 	general_ledger_journal_entry_line.batch_ AS journalentry_id 
 FROM  DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_glentry  general_ledger_journal_entry_line 
  
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_createdbyuser ON audit_createdbyuser.cny_ = general_ledger_journal_entry_line.cny_ and audit_createdbyuser.record_ = general_ledger_journal_entry_line.createdby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_modifiedbyuser ON audit_modifiedbyuser.cny_ = general_ledger_journal_entry_line.cny_ and audit_modifiedbyuser.record_ = general_ledger_journal_entry_line.modifiedby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_class dimensions_class ON dimensions_class.cny_ = general_ledger_journal_entry_line.cny_ and dimensions_class.record_ = general_ledger_journal_entry_line.classdimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_contract dimensions_contract ON dimensions_contract.cny_ = general_ledger_journal_entry_line.cny_ and dimensions_contract.record_ = general_ledger_journal_entry_line.contractdimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_costtype dimensions_costtype ON dimensions_costtype.cny_ = general_ledger_journal_entry_line.cny_ and dimensions_costtype.record_ = general_ledger_journal_entry_line.costtypedimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_customer dimensions_customer ON dimensions_customer.cny_ = general_ledger_journal_entry_line.cny_ and dimensions_customer.record_ = general_ledger_journal_entry_line.customerdimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_department dimensions_department ON dimensions_department.cny_ = general_ledger_journal_entry_line.cny_ and dimensions_department.record_ = general_ledger_journal_entry_line.dept_ 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_employee dimensions_employee ON dimensions_employee.cny_ = general_ledger_journal_entry_line.cny_ and dimensions_employee.record_ = general_ledger_journal_entry_line.employeedimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_icitem dimensions_item ON dimensions_item.cny_ = general_ledger_journal_entry_line.cny_ and dimensions_item.record_ = general_ledger_journal_entry_line.itemdimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_location dimensions_location ON dimensions_location.cny_ = general_ledger_journal_entry_line.cny_ and dimensions_location.record_ = general_ledger_journal_entry_line.location_ 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_project dimensions_project ON dimensions_project.cny_ = general_ledger_journal_entry_line.cny_ and dimensions_project.record_ = general_ledger_journal_entry_line.projectdimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_task dimensions_task ON dimensions_task.cny_ = general_ledger_journal_entry_line.cny_ and dimensions_task.record_ = general_ledger_journal_entry_line.taskdimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_vendor dimensions_vendor ON dimensions_vendor.cny_ = general_ledger_journal_entry_line.cny_ and dimensions_vendor.record_ = general_ledger_journal_entry_line.vendordimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_icwarehouse dimensions_warehouse ON dimensions_warehouse.cny_ = general_ledger_journal_entry_line.cny_ and dimensions_warehouse.record_ = general_ledger_journal_entry_line.warehousedimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_GLACCOUNT glaccount ON glaccount.cny_ = general_ledger_journal_entry_line.cny_ and glaccount.record_ = general_ledger_journal_entry_line.account_ 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_ALLOCATION allocation ON allocation.cny_ = general_ledger_journal_entry_line.cny_ and allocation.record_ = general_ledger_journal_entry_line.allocationkey 
  
  ;   


   ------ CONTENT OF general_ledger_budget_detail   


   CREATE OR REPLACE SECURE VIEW GENERAL_LEDGER_BUDGET_DETAIL
    COMMENT =  "Version=cfdda6ed-e587-4d5c-b4c6-ce9b5b6e58c3 " 
    AS SELECT 
    
 	-- 	end custom fields 
  general_ledger_budget_detail.cny_ AS cnyNumber, 
 	general_ledger_budget_detail.amount AS amount , 
 	general_ledger_budget_detail.record_ AS id , 
 	general_ledger_budget_detail.note AS notes , 
 	general_ledger_budget_detail.basedon AS budgetgrowth_basedon , 
 	general_ledger_budget_detail.growby AS budgetgrowth_growby , 
 	general_ledger_budget_detail.perperiod AS budgetgrowth_perperiod , 
 	dimensions_class.record_ AS classdimkey , 
 	dimensions_contract.record_ AS contractdimkey , 
 	dimensions_costtype.record_ AS costtypedimkey , 
 	dimensions_customer.record_ AS customerdimkey , 
 	dimensions_department.record_ AS deptkey , 
 	dimensions_employee.record_ AS employeedimkey , 
 	dimensions_item.record_ AS itemdimkey , 
 	dimensions_location.record_ AS locationkey , 
 	dimensions_project.record_ AS projectdimkey , 
 	dimensions_task.record_ AS taskdimkey , 
 	dimensions_vendor.record_ AS vendordimkey , 
 	dimensions_warehouse.record_ AS warehousedimkey , 
 	general_ledger_budget_detail.budgetkey AS budget_key , 
 	general_ledger_budget_detail.account_ AS glaccount_key 
 FROM  DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_glbudget  general_ledger_budget_detail 
  
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_createdbyuser ON audit_createdbyuser on audit_createdbyuser.cny_ = general_ledger_budget_detail.cny_ and audit_createdbyuser.record_ = general_ledger_budget_detail.createdby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_modifiedbyuser ON audit_modifiedbyuser.cny_ = general_ledger_budget_detail.cny_ and audit_modifiedbyuser.record_ = general_ledger_budget_detail.modifiedby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_class dimensions_class ON dimensions_class.cny_ = general_ledger_budget_detail.cny_ and dimensions_class.record_ = general_ledger_budget_detail.classdimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_contract dimensions_contract ON dimensions_contract.cny_ = general_ledger_budget_detail.cny_ and dimensions_contract.record_ = general_ledger_budget_detail.contractdimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_costtype dimensions_costtype ON dimensions_costtype.cny_ = general_ledger_budget_detail.cny_ and dimensions_costtype.record_ = general_ledger_budget_detail.costtypedimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_customer dimensions_customer ON dimensions_customer.cny_ = general_ledger_budget_detail.cny_ and dimensions_customer.record_ = general_ledger_budget_detail.customerdimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_department dimensions_department ON dimensions_department.cny_ = general_ledger_budget_detail.cny_ and dimensions_department.record_ = general_ledger_budget_detail.dept_ 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_employee dimensions_employee ON dimensions_employee.cny_ = general_ledger_budget_detail.cny_ and dimensions_employee.record_ = general_ledger_budget_detail.employeedimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_icitem dimensions_item ON dimensions_item.cny_ = general_ledger_budget_detail.cny_ and dimensions_item.record_ = general_ledger_budget_detail.itemdimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_location dimensions_location ON dimensions_location.cny_ = general_ledger_budget_detail.cny_ and dimensions_location.record_ = general_ledger_budget_detail.location_ 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_project dimensions_project ON dimensions_project.cny_ = general_ledger_budget_detail.cny_ and dimensions_project.record_ = general_ledger_budget_detail.projectdimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_task dimensions_task ON dimensions_task.cny_ = general_ledger_budget_detail.cny_ and dimensions_task.record_ = general_ledger_budget_detail.taskdimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_vendor dimensions_vendor ON dimensions_vendor.cny_ = general_ledger_budget_detail.cny_ and dimensions_vendor.record_ = general_ledger_budget_detail.vendordimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_icwarehouse dimensions_warehouse ON dimensions_warehouse.cny_ = general_ledger_budget_detail.cny_ and dimensions_warehouse.record_ = general_ledger_budget_detail.warehousedimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_BUDGETHEADER budgetheader ON budgetheader.cny_ = general_ledger_budget_detail.cny_ and budgetheader.record_ = general_ledger_budget_detail.budgetkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_BASEACCOUNT baseaccount ON budgetheader.cny_ = general_ledger_budget_detail.cny_ and baseaccount.record_ = general_ledger_budget_detail.account_ 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_glbudgettype reportingperiod ON reportingperiod.cnyno = general_ledger_budget_detail.cny_ and reportingperiod.record_ = general_ledger_budget_detail.bud_type_ 
  
  ;   


   ------ CONTENT OF general_ledger_journal   


   CREATE OR REPLACE SECURE VIEW GENERAL_LEDGER_JOURNAL
    COMMENT =  "Version=cfdda6ed-e587-4d5c-b4c6-ce9b5b6e58c3 " 
    AS SELECT 
    
 	-- 	end custom fields 
  general_ledger_journal.cny_ AS cnyNumber, 
 	general_ledger_journal.bookid AS bookid , 
 	general_ledger_journal.booktype AS booktype , 
 	general_ledger_journal.symbol AS id , 
 	general_ledger_journal.adj AS isadjustment , 
 	general_ledger_journal.billable AS isbillable , 
 	general_ledger_journal.record_ AS key , 
 	general_ledger_journal.title AS name , 
 	general_ledger_journal.status AS status , 
 	general_ledger_journal.createdby AS audit_createdby , 
 	general_ledger_journal.whencreated AS audit_createddatetime , 
 	general_ledger_journal.modifiedby AS audit_modifiedby , 
 	general_ledger_journal.whenmodified AS audit_modifieddatetime 
 FROM  DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_gljournal  general_ledger_journal 
  
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_createdbyuser ON audit_createdbyuser.cny_ = general_ledger_journal.cny_ and audit_createdbyuser.record_ = general_ledger_journal.createdby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_modifiedbyuser ON audit_modifiedbyuser.cny_ = general_ledger_journal.cny_ and audit_modifiedbyuser.record_ = general_ledger_journal.modifiedby 
  
  ;   


   ------ CONTENT OF accounts_payable_recurring_bill_line   


   CREATE OR REPLACE SECURE VIEW ACCOUNTS_PAYABLE_RECURRING_BILL_LINE
    COMMENT =  "Version=cfdda6ed-e587-4d5c-b4c6-ce9b5b6e58c3 " 
    AS SELECT 
    
 	-- 	end custom fields 
  accounts_payable_recurring_bill_line.cny_ AS cnyNumber, 
 	accounts_payable_recurring_bill_line.cny_ AS cnynumber , 
 	accounts_payable_recurring_bill_line.record_ AS key , 
 	accounts_payable_recurring_bill_line.trx_amount AS txnamount , 
 	accounts_payable_recurring_bill_line.createdby AS audit_createdby , 
 	accounts_payable_recurring_bill_line.whencreated AS audit_createddatetime , 
 	accounts_payable_recurring_bill_line.modifiedby AS audit_modifiedby , 
 	accounts_payable_recurring_bill_line.whenmodified AS audit_modifieddatetime , 
 	accounts_payable_recurring_bill_line.basecurr AS currency_basecurrency , 
 	accounts_payable_recurring_bill_line.currency AS currency_txncurrency , 
 	dimensions_class.record_ AS classdimkey , 
 	dimensions_contract.record_ AS contractdimkey , 
 	dimensions_costtype.record_ AS costtypedimkey , 
 	dimensions_customer.record_ AS customerdimkey , 
 	dimensions_department.record_ AS dept_ , 
 	dimensions_employee.record_ AS employeedimkey , 
 	dimensions_item.record_ AS itemdimkey , 
 	dimensions_location.record_ AS location_ , 
 	dimensions_project.record_ AS projectdimkey , 
 	dimensions_task.record_ AS taskdimkey , 
 	dimensions_vendor.record_ AS vendordimkey , 
 	dimensions_warehouse.record_ AS warehousedimkey , 
 	accounts_payable_recurring_bill_line.accountlabelkey AS accountlabel_key , 
 	accounts_payable_recurring_bill_line.allocationkey AS allocation_id , 
 	accounts_payable_recurring_bill_line.accountkey AS glaccount_key , 
 	accounts_payable_recurring_bill_line.recordkey AS recurringbill_id 
 FROM  DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_recurprentry  accounts_payable_recurring_bill_line 
  
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_createdbyuser ON audit_createdbyuser.cny_ = accounts_payable_recurring_bill_line.cny_ and audit_createdbyuser.record_ = accounts_payable_recurring_bill_line.createdby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_modifiedbyuser ON audit_modifiedbyuser.cny_ = accounts_payable_recurring_bill_line.cny_ and audit_modifiedbyuser.record_ = accounts_payable_recurring_bill_line.modifiedby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_class dimensions_class ON dimensions_class.cny_ = accounts_payable_recurring_bill_line.cny_ and dimensions_class.record_ = accounts_payable_recurring_bill_line.classdimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_contract dimensions_contract ON dimensions_contract.cny_ = accounts_payable_recurring_bill_line.cny_ and dimensions_contract.record_ = accounts_payable_recurring_bill_line.contractdimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_costtype dimensions_costtype ON dimensions_costtype.cny_ = accounts_payable_recurring_bill_line.cny_ and dimensions_costtype.record_ = accounts_payable_recurring_bill_line.costtypedimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_customer dimensions_customer ON dimensions_customer.cny_ = accounts_payable_recurring_bill_line.cny_ and dimensions_customer.record_ = accounts_payable_recurring_bill_line.customerdimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_department dimensions_department ON dimensions_department.cny_ = accounts_payable_recurring_bill_line.cny_ and dimensions_department.record_ = accounts_payable_recurring_bill_line.dept_ 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_employee dimensions_employee ON dimensions_employee.cny_ = accounts_payable_recurring_bill_line.cny_ and dimensions_employee.record_ = accounts_payable_recurring_bill_line.employeedimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_icitem dimensions_item ON dimensions_item.cny_ = accounts_payable_recurring_bill_line.cny_ and dimensions_item.record_ = accounts_payable_recurring_bill_line.itemdimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_location dimensions_location ON dimensions_location.cny_ = accounts_payable_recurring_bill_line.cny_ and dimensions_location.record_ = accounts_payable_recurring_bill_line.location_ 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_project dimensions_project ON dimensions_project.cny_ = accounts_payable_recurring_bill_line.cny_ and dimensions_project.record_ = accounts_payable_recurring_bill_line.projectdimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_task dimensions_task ON dimensions_task.cny_ = accounts_payable_recurring_bill_line.cny_ and dimensions_task.record_ = accounts_payable_recurring_bill_line.taskdimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_vendor dimensions_vendor ON dimensions_vendor.cny_ = accounts_payable_recurring_bill_line.cny_ and dimensions_vendor.record_ = accounts_payable_recurring_bill_line.vendordimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_icwarehouse dimensions_warehouse ON dimensions_warehouse.cny_ = accounts_payable_recurring_bill_line.cny_ and dimensions_warehouse.record_ = accounts_payable_recurring_bill_line.warehousedimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_GLACCOUNT offsetglaccountno ON offsetglaccountno.cny_ = accounts_payable_recurring_bill_line.cny_ and offsetglaccountno.record_ = accounts_payable_recurring_bill_line.gloffset 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_ACCOUNTLABEL apaccountlabel ON apaccountlabel.cny_ = accounts_payable_recurring_bill_line.cny_ and apaccountlabel.record_ = accounts_payable_recurring_bill_line.accountlabelkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_ALLOCATION alloc ON alloc.cny_ = accounts_payable_recurring_bill_line.cny_ and alloc.record_ = accounts_payable_recurring_bill_line.allocationkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_GLACCOUNT glaccount ON glaccount.cny_ = accounts_payable_recurring_bill_line.cny_ and glaccount.record_ = accounts_payable_recurring_bill_line.accountkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_CONTACT contact ON contact.cny_ = accounts_payable_recurring_bill_line.cny_ and contact.record_ = dimensions_employee.contactkey and contact.cny_ = accounts_payable_recurring_bill_line.cny_ and dimensions_employee.record_ = accounts_payable_recurring_bill_line.employeedimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_recurprrecord aprecurbill ON aprecurbill.record_ = accounts_payable_recurring_bill_line.recordkey and aprecurbill.cny_ = accounts_payable_recurring_bill_line.cny_ and aprecurbill.recordtype = 'pi' 
  
  ;   


   ------ CONTENT OF accounts_payable_vendor   


   CREATE OR REPLACE SECURE VIEW ACCOUNTS_PAYABLE_VENDOR
    COMMENT =  "Version=cfdda6ed-e587-4d5c-b4c6-ce9b5b6e58c3 " 
    AS SELECT 
    
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
 	accounts_payable_vendor.accountkey AS defaultexpenseglaccount_key , 
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
 FROM  DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_vendor  accounts_payable_vendor 
  
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_createdbyuser ON audit_createdbyuser.cny_ = accounts_payable_vendor.cny_ and audit_createdbyuser.record_ = accounts_payable_vendor.createdby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_modifiedbyuser ON audit_modifiedbyuser.cny_ = accounts_payable_vendor.cny_ and audit_modifiedbyuser.record_ = accounts_payable_vendor.modifiedby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_GLACCOUNT offsetglaccountno ON offsetglaccountno.cny_ = accounts_payable_vendor.cny_ and offsetglaccountno.record_ = accounts_payable_vendor.offsetaccountkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_ACCOUNTLABEL apaccountlabel ON apaccountlabel.cny_ = accounts_payable_vendor.cny_ and apaccountlabel.record_ = accounts_payable_vendor.accountlabelkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_TERM term ON term.cny_ = accounts_payable_vendor.cny_ and term.record_ = accounts_payable_vendor.termskey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_GLACCOUNT glaccount ON glaccount.cny_ = accounts_payable_vendor.cny_ and glaccount.record_ = accounts_payable_vendor.accountkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_LOCATION melocation ON melocation.cny_ = accounts_payable_vendor.cny_ and melocation.record_ = accounts_payable_vendor.locationkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_VENDOR parent ON parent.cny_ = accounts_payable_vendor.cny_ and parent.record_ = accounts_payable_vendor.parentkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_vendortrxsummary vendortrxsummary ON vendortrxsummary.cny_ = accounts_payable_vendor.cny_ and vendortrxsummary.record_ = accounts_payable_vendor.record_ 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_GLACCTGRP glgroup ON glgroup.cny_ = accounts_payable_vendor.cny_ and glgroup.record_ = accounts_payable_vendor.glgrpkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_PRICELIST pricelist ON pricelist.recordno = accounts_payable_vendor.oeprclstkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_GLACCOUNT apaccount ON apaccount.cny_ = accounts_payable_vendor.cny_ and apaccount.record_ = accounts_payable_vendor.accountkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_vendoracctno vendoracctno ON vendoracctno.cny_ = accounts_payable_vendor.cny_ and vendoracctno.record_ = accounts_payable_vendor.vendoracctnokey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_VENDTYPE vendtype ON vendtype.cny_ = accounts_payable_vendor.cny_ and vendtype.record_ = accounts_payable_vendor.vendtypekey 
  
  ;   


   ------ CONTENT OF cash_management_bank_feed   


   CREATE OR REPLACE SECURE VIEW CASH_MANAGEMENT_BANK_FEED
    COMMENT =  "Version=cfdda6ed-e587-4d5c-b4c6-ce9b5b6e58c3 " 
    AS SELECT 
    
 	-- 	end custom fields 
  cash_management_bank_feed.cny_ AS cnyNumber, 
 	cash_management_bank_feed.financialentity AS id , 
 	cash_management_bank_feed.feeddate AS feeddate , 
 	case  when financialaccount_accounttype = 'ba' then ( select name as financialaccount_accountname from bankaccount bamst where bamst.cny_ = cash_management_bank_feed.cny_ and bamst.accountid =  cash_management_bank_feed.financialentity limit 1) when financialaccount_accounttype = 'cc' then ( select cardtype as financialaccount_accountname from icrw_schema.ccdata ccmst where ccmst.cny_ = cash_management_bank_feed.cny_ and ccmst.cardid = cash_management_bank_feed.financialentity  limit 1) end AS financialaccount_accountname , 
 	cash_management_bank_feed.filetype AS feedtype , 
 	cash_management_bank_feed.state AS state , 
 	cash_management_bank_feed.filename AS filename , 
 	cash_management_bank_feed.acctreconkey AS accountreconciliationkey , 
 	cash_management_bank_feed.parentfeedkey AS parentfeedkey , 
 	cash_management_bank_feed.importid AS importid , 
 	cash_management_bank_feed.downloadedtranactions AS downloadedtxnquantity , 
 	cash_management_bank_feed.createdby AS audit_createdby , 
 	cash_management_bank_feed.whencreated AS audit_createddatetime , 
 	cash_management_bank_feed.modifiedby AS audit_modifiedby , 
 	cash_management_bank_feed.whenmodified AS audit_modifieddatetime , 
 	cash_management_bank_feed.locationkey AS location_key , 
 	cash_management_bank_feed.errormsg AS errormessage 
 FROM  DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_FINACCTTXNFEED  cash_management_bank_feed 
  
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_createdbyuser ON audit_createdbyuser.cny_ = cash_management_bank_feed.cny_ and audit_createdbyuser.record_ = cash_management_bank_feed.createdby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_modifiedbyuser ON audit_modifiedbyuser.cny_ = cash_management_bank_feed.cny_ and audit_modifiedbyuser.record_ = cash_management_bank_feed.modifiedby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_LOCATION melocation ON melocation.cny_ = cash_management_bank_feed.cny_ and melocation.record_ = cash_management_bank_feed.locationkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_FINACCTTXNFEED parent ON parent.cny_ = cash_management_bank_feed.cny_ and parent.record_ = cash_management_bank_feed.parentfeedkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_FINANCIALACCOUNT financialaccount ON financialaccount.cny_ = cash_management_bank_feed.cny_ and financialaccount.entity = cash_management_bank_feed.financialentity 
  
  ;   


   ------ CONTENT OF accounts_receivable_term   


   CREATE OR REPLACE SECURE VIEW ACCOUNTS_RECEIVABLE_TERM
    COMMENT =  "Version=cfdda6ed-e587-4d5c-b4c6-ce9b5b6e58c3 " 
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
 FROM  DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_arterm  accounts_receivable_term 
  
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_createdbyuser ON audit_createdbyuser.cny_ = accounts_receivable_term.cny_ and audit_createdbyuser.record_ = accounts_receivable_term.createdby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_modifiedbyuser ON audit_modifiedbyuser.cny_ = accounts_receivable_term.cny_ and audit_modifiedbyuser.record_ = accounts_receivable_term.modifiedby 
  
  ;   


   ------ CONTENT OF cash_management_reconciliation_source_record   


   CREATE OR REPLACE SECURE VIEW CASH_MANAGEMENT_RECONCILIATION_SOURCE_RECORD
    COMMENT =  "Version=cfdda6ed-e587-4d5c-b4c6-ce9b5b6e58c3 " 
    AS SELECT 
    
 	-- 	end custom fields 
  cash_management_reconciliation_source_record.cny_ AS cnyNumber, 
 	cash_management_reconciliation_source_record.record_ AS key , 
 	cash_management_reconciliation_source_record.recordkey AS  recordkey , 
 	cash_management_reconciliation_source_record.recordtype AS subledgerrecordtype , 
 	cash_management_reconciliation_source_record.financialentity AS financialentity , 
 	cash_management_reconciliation_source_record.glentrykey AS glentrykey , 
 	cash_management_reconciliation_source_record.ioitemskey AS  ioitemskey , 
 	cash_management_reconciliation_source_record.transferlinkkey AS transferlinkkey , 
 	cash_management_reconciliation_source_record.locationkey AS location_key , 
 	cash_management_reconciliation_source_record.transactiontype AS transactiontype , 
 	cash_management_reconciliation_source_record.currency AS txncurrency , 
 	cash_management_reconciliation_source_record.basecurrency AS basecurrency , 
 	cash_management_reconciliation_source_record.postingdate AS postingdate , 
 	cash_management_reconciliation_source_record.payee AS payee , 
 	cash_management_reconciliation_source_record.description AS description , 
 	cash_management_reconciliation_source_record.createdby AS audit_createdby , 
 	cash_management_reconciliation_source_record.whencreated AS audit_createddatetime , 
 	cash_management_reconciliation_source_record.modifiedby AS audit_modifiedby , 
 	cash_management_reconciliation_source_record.whenmodified AS audit_modifieddatetime , 
 	cash_management_reconciliation_source_record.whenmatched AS whenmatched , 
 	cash_management_reconciliation_source_record.matchedby AS matchedby 
 FROM  DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_ACCTRECONRECORD  cash_management_reconciliation_source_record 
  
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_createdbyuser ON audit_createdbyuser.cny_ = cash_management_reconciliation_source_record.cny_ and audit_createdbyuser.record_ = cash_management_reconciliation_source_record.createdby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_modifiedbyuser ON audit_modifiedbyuser.cny_ = cash_management_reconciliation_source_record.cny_ and audit_modifiedbyuser.record_ = cash_management_reconciliation_source_record.modifiedby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_LOCATION melocation ON melocation.cny_ = cash_management_reconciliation_source_record.cny_ and melocation.record_ = cash_management_reconciliation_source_record.locationkey 
  
  ;   


   ------ CONTENT OF accounts_receivable_account_label   


   CREATE OR REPLACE SECURE VIEW ACCOUNTS_RECEIVABLE_ACCOUNT_LABEL
    COMMENT =  "Version=cfdda6ed-e587-4d5c-b4c6-ce9b5b6e58c3 " 
    AS SELECT 
    
 	-- 	end custom fields 
  accounts_receivable_account_label.cny_ AS cnyNumber, 
 	accounts_receivable_account_label.description AS description , 
 	accounts_receivable_account_label.label AS id , 
 	accounts_receivable_account_label.subtotal AS issubtotal , 
 	accounts_receivable_account_label.istax AS istax , 
 	accounts_receivable_account_label.taxable AS istaxable , 
 	accounts_receivable_account_label.record_ AS key , 
 	accounts_receivable_account_label.status AS status , 
 	accounts_receivable_account_label.taxcategory AS taxcode , 
 	accounts_receivable_account_label.createdby AS audit_createdby , 
 	accounts_receivable_account_label.whencreated AS audit_createddatetime , 
 	accounts_receivable_account_label.modifiedby AS audit_modifiedby , 
 	accounts_receivable_account_label.whenmodified AS audit_modifieddatetime , 
 	accounts_receivable_account_label.locationkey AS entity_key 
 FROM  DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_accountlabel  accounts_receivable_account_label 
  
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_createdbyuser ON audit_createdbyuser.cny_ = accounts_receivable_account_label.cny_ and audit_createdbyuser.record_ = accounts_receivable_account_label.createdby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_modifiedbyuser ON audit_modifiedbyuser.cny_ = accounts_receivable_account_label.cny_ and audit_modifiedbyuser.record_ = accounts_receivable_account_label.modifiedby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_LOCATION melocation ON melocation.cny_ = accounts_receivable_account_label.cny_ and melocation.record_ = accounts_receivable_account_label.locationkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_GLACCOUNT glaccount ON glaccount.cny_ = accounts_receivable_account_label.cny_ and glaccount.record_ = accounts_receivable_account_label.glaccountrecordno 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_GLACCOUNT glosaccount ON glosaccount.cny_ = accounts_receivable_account_label.cny_ and glosaccount.record_ = accounts_receivable_account_label.gloffsetkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_TAXGRP taxgroup ON taxgroup.cny_ = accounts_receivable_account_label.cny_ and taxgroup.record_ = accounts_receivable_account_label.taxgrpkey 
  
  ;   


   ------ CONTENT OF accounts_payable_payment_line   


   CREATE OR REPLACE SECURE VIEW ACCOUNTS_PAYABLE_PAYMENT_LINE
    COMMENT =  "Version=cfdda6ed-e587-4d5c-b4c6-ce9b5b6e58c3 " 
    AS SELECT 
    
 	-- 	end custom fields 
  accounts_payable_payment_line.cny_ AS cnyNumber, 
 	accounts_payable_payment_line.baselocation AS baselocation , 
 	accounts_payable_payment_line.description AS description , 
 	accounts_payable_payment_line.record_ AS id , 
 	accounts_payable_payment_line.istax AS istax , 
 	accounts_payable_payment_line.line_no AS linenumber , 
 	accounts_payable_payment_line.recordtype AS paymentlinerecord , 
 	accounts_payable_payment_line.createdby AS audit_createdby , 
 	accounts_payable_payment_line.whencreated AS audit_createddatetime , 
 	accounts_payable_payment_line.modifiedby AS audit_modifiedby , 
 	accounts_payable_payment_line.whenmodified AS audit_modifieddatetime , 
 	accounts_payable_payment_line.amount AS basecurrency_amount , 
 	accounts_payable_payment_line.basecurr AS basecurrency_currency , 
 	accounts_payable_payment_line.totalpaid AS basecurrency_totalpaid , 
 	accounts_payable_payment_line.totalselected AS basecurrency_totalselected , 
 	dimensions_class.record_ AS classdimkey , 
 	dimensions_contract.record_ AS contractdimkey , 
 	dimensions_costtype.record_ AS costtypedimkey , 
 	dimensions_customer.record_ AS customerdimkey , 
 	dimensions_department.record_ AS departmentkey , 
 	dimensions_employee.record_ AS employeedimkey , 
 	dimensions_item.record_ AS itemdimkey , 
 	dimensions_location.record_ AS locationkey , 
 	dimensions_project.record_ AS projectdimkey , 
 	dimensions_task.record_ AS taskdimkey , 
 	dimensions_vendor.record_ AS vendordimkey , 
 	dimensions_warehouse.record_ AS warehousedimkey , 
 	accounts_payable_payment_line.exch_rate_date AS exchangerate_date , 
 	accounts_payable_payment_line.exchange_rate AS exchangerate_rate , 
 	accounts_payable_payment_line.exch_rate_type_id AS exchangerate_typeid , 
 	accounts_payable_payment_line.trx_amount AS txncurrency_amount , 
 	accounts_payable_payment_line.currency AS txncurrency_currency , 
 	accounts_payable_payment_line.trx_totalpaid AS txncurrency_totalpaid , 
 	accounts_payable_payment_line.trx_totalselected AS txncurrency_totalselected , 
 	accounts_payable_payment_line.recordkey AS appayment_id , 
 	accounts_payable_payment_line.accountkey AS glaccount_key , 
 	accounts_payable_payment_line.taxdetail_ AS taxdetail_key 
 FROM  DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_prentry  accounts_payable_payment_line 
  
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_createdbyuser ON audit_createdbyuser.cny_ = accounts_payable_payment_line.cny_ and audit_createdbyuser.record_ = accounts_payable_payment_line.createdby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_modifiedbyuser ON audit_modifiedbyuser.cny_ = accounts_payable_payment_line.cny_ and audit_modifiedbyuser.record_ = accounts_payable_payment_line.modifiedby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_class dimensions_class ON dimensions_class.cny_ = accounts_payable_payment_line.cny_ and dimensions_class.record_ = accounts_payable_payment_line.classdimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_contract dimensions_contract ON dimensions_contract.cny_ = accounts_payable_payment_line.cny_ and dimensions_contract.record_ = accounts_payable_payment_line.contractdimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_costtype dimensions_costtype ON dimensions_costtype.cny_ = accounts_payable_payment_line.cny_ and dimensions_costtype.record_ = accounts_payable_payment_line.costtypedimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_customer dimensions_customer ON dimensions_customer.cny_ = accounts_payable_payment_line.cny_ and dimensions_customer.record_ = accounts_payable_payment_line.customerdimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_department dimensions_department ON dimensions_department.cny_ = accounts_payable_payment_line.cny_ and dimensions_department.record_ = accounts_payable_payment_line.dept_ 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_employee dimensions_employee ON dimensions_employee.cny_ = accounts_payable_payment_line.cny_ and dimensions_employee.record_ = accounts_payable_payment_line.employeedimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_icitem dimensions_item ON dimensions_item.cny_ = accounts_payable_payment_line.cny_ and dimensions_item.record_ = accounts_payable_payment_line.itemdimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_location dimensions_location ON dimensions_location.cny_ = accounts_payable_payment_line.cny_ and dimensions_location.record_ = accounts_payable_payment_line.location_ 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_project dimensions_project ON dimensions_project.cny_ = accounts_payable_payment_line.cny_ and dimensions_project.record_ = accounts_payable_payment_line.projectdimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_task dimensions_task ON dimensions_task.cny_ = accounts_payable_payment_line.cny_ and dimensions_task.record_ = accounts_payable_payment_line.taskdimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_vendor dimensions_vendor ON dimensions_vendor.cny_ = accounts_payable_payment_line.cny_ and dimensions_vendor.record_ = accounts_payable_payment_line.vendordimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_icwarehouse dimensions_warehouse ON dimensions_warehouse.cny_ = accounts_payable_payment_line.cny_ and dimensions_warehouse.record_ = accounts_payable_payment_line.warehousedimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_GLACCOUNT glaccount ON glaccount.cny_ = accounts_payable_payment_line.cny_ and glaccount.record_ = accounts_payable_payment_line.accountkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_CONTACT contact ON contact.cny_ = accounts_payable_payment_line.cny_ and contact.record_ = dimensions_employee.contactkey and contact.cny_ = accounts_payable_payment_line.cny_ and dimensions_employee.record_ = accounts_payable_payment_line.employeedimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_TAXDETAIL detail ON detail.cny_ = accounts_payable_payment_line.cny_ and detail.record_ = accounts_payable_payment_line.taxdetail_ 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_prrecord accounts_payable_payment ON accounts_payable_payment.recordtype in ('pp','pr') 
  
  ;   


   ------ CONTENT OF company_config_contact   


   CREATE OR REPLACE SECURE VIEW COMPANY_CONFIG_CONTACT
    COMMENT =  "Version=cfdda6ed-e587-4d5c-b4c6-ce9b5b6e58c3 " 
    AS SELECT 
    
 	-- 	end custom fields 
  company_config_contact.cny_ AS cnyNumber, 
 	company_config_contact.url1 AS url1 , 
 	company_config_contact.url2 AS url2 , 
 	company_config_contact.companyname AS companyname , 
 	company_config_contact.discount AS discount , 
 	company_config_contact.email1 AS email1 , 
 	company_config_contact.email2 AS email2 , 
 	company_config_contact.fax AS fax , 
 	company_config_contact.firstname AS firstname , 
 	company_config_contact.name AS id , 
 	company_config_contact.record_ AS key , 
 	company_config_contact.lastname AS lastname , 
 	company_config_contact.mi AS middlename , 
 	company_config_contact.cellphone AS mobile , 
 	company_config_contact.pager AS pager , 
 	company_config_contact.phone1 AS phone1 , 
 	company_config_contact.phone2 AS phone2 , 
 	company_config_contact.mrms AS prefix , 
 	company_config_contact.printas AS printas , 
 	company_config_contact.visible AS showincontactlist , 
 	company_config_contact.status AS status , 
 	company_config_contact.oepriceschedkey AS priceschedule_key , 
 	company_config_contact.taxable AS tax_istaxable , 
 	company_config_contact.taxid AS tax_taxid , 
 	tax_group.name AS taxgroup , 
 	tax_group.record_ AS taxgroupkey , 
 	company_config_contact.locationkey AS entity_key , 
 	melocation.name AS entity_name , 
 	company_config_contact.oeprclstkey AS pricelist_key 
 FROM  DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_contact  company_config_contact 
  
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_taxgrp tax_group ON tax_group.cny_ = company_config_contact.cny_ and tax_group.record_ = company_config_contact.taxgroupkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_location melocation ON melocation.cny_ = company_config_contact.cny_ and melocation.record_ = company_config_contact.locationkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_MAILADDRESS mailaddress ON mailaddress.cny_ = company_config_contact.cny_ and mailaddress.record_ = company_config_contact.mailaddrkey 
  
  ;   


   ------ CONTENT OF company_config_department   


   CREATE OR REPLACE SECURE VIEW COMPANY_CONFIG_DEPARTMENT
    COMMENT =  "Version=cfdda6ed-e587-4d5c-b4c6-ce9b5b6e58c3 " 
    AS SELECT 
    
 	-- 	end custom fields 
  company_config_department.cny_ AS cnyNumber, 
 	company_config_department.dept_no AS id , 
 	company_config_department.record_ AS key , 
 	company_config_department.title AS name , 
 	company_config_department.custtitle AS reporttitle , 
 	company_config_department.status AS status , 
 	company_config_department.createdby AS audit_createdby , 
 	company_config_department.whencreated AS audit_createddatetime , 
 	company_config_department.modifiedby AS audit_modifiedby , 
 	company_config_department.whenmodified AS audit_modifieddatetime , 
 	parent.dept_no AS parent_id , 
 	company_config_department.parent_ AS parent_key , 
 	parent.title AS parent_name , 
 	manager.record_ AS supervisor_key 
 FROM  DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_department  company_config_department 
  
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_createdbyuser ON audit_createdbyuser.cny_ = company_config_department.cny_ and audit_createdbyuser.record_ = company_config_department.createdby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_modifiedbyuser ON audit_modifiedbyuser.cny_ = company_config_department.cny_ and audit_modifiedbyuser.record_ = company_config_department.modifiedby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_employee manager ON manager.cny_ = company_config_department.cny_ and manager.employeeid = company_config_department.employeekey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_contact contact ON contact.cny_ = company_config_department.cny_ and manager.employeeid = company_config_department.employeekey and contact.cny_ = company_config_department.cny_  and contact.record_ = manager.contactkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_department parent ON parent.cny_ = company_config_department.cny_ and parent.record_ = company_config_department.parent_ 
  
  ;   


   ------ CONTENT OF accounts_receivable_invoice_line   


   CREATE OR REPLACE SECURE VIEW ACCOUNTS_RECEIVABLE_INVOICE_LINE
    COMMENT =  "Version=cfdda6ed-e587-4d5c-b4c6-ce9b5b6e58c3 " 
    AS SELECT 
    
 	-- 	end custom fields 
  accounts_receivable_invoice_line.cny_ AS cnyNumber, 
 	accounts_receivable_invoice_line.amount AS baseamount , 
 	accounts_receivable_invoice_line.entry_date AS createddate , 
 	accounts_receivable_invoice_line.record_ AS id , 
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
 FROM  DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_prentry  accounts_receivable_invoice_line 
  
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_createdbyuser ON audit_createdbyuser.cny_ = accounts_receivable_invoice_line.cny_ and audit_createdbyuser.record_ = accounts_receivable_invoice_line.createdby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_modifiedbyuser ON audit_modifiedbyuser.cny_ = accounts_receivable_invoice_line.cny_ and audit_modifiedbyuser.record_ = accounts_receivable_invoice_line.modifiedby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_class dimensions_class ON dimensions_class.cny_ = accounts_receivable_invoice_line.cny_ and dimensions_class.record_ = accounts_receivable_invoice_line.classdimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_contract dimensions_contract ON dimensions_contract.cny_ = accounts_receivable_invoice_line.cny_ and dimensions_contract.record_ = accounts_receivable_invoice_line.contractdimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_costtype dimensions_costtype ON dimensions_costtype.cny_ = accounts_receivable_invoice_line.cny_ and dimensions_costtype.record_ = accounts_receivable_invoice_line.costtypedimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_customer dimensions_customer ON dimensions_customer.cny_ = accounts_receivable_invoice_line.cny_ and dimensions_customer.record_ = accounts_receivable_invoice_line.customerdimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_employee dimensions_employee ON dimensions_employee.cny_ = accounts_receivable_invoice_line.cny_ and dimensions_employee.record_ = accounts_receivable_invoice_line.employeedimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_icitem dimensions_item ON dimensions_item.cny_ = accounts_receivable_invoice_line.cny_ and dimensions_item.record_ = accounts_receivable_invoice_line.itemdimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_project dimensions_project ON dimensions_project.cny_ = accounts_receivable_invoice_line.cny_ and dimensions_project.record_ = accounts_receivable_invoice_line.projectdimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_task dimensions_task ON dimensions_task.cny_ = accounts_receivable_invoice_line.cny_ and dimensions_task.record_ = accounts_receivable_invoice_line.taskdimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_vendor dimensions_vendor ON dimensions_vendor.cny_ = accounts_receivable_invoice_line.cny_ and dimensions_vendor.record_ = accounts_receivable_invoice_line.vendordimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_icwarehouse dimensions_warehouse ON dimensions_warehouse.cny_ = accounts_receivable_invoice_line.cny_ and dimensions_warehouse.record_ = accounts_receivable_invoice_line.warehousedimkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_department dimensions_department ON  dimensions_department.cny_ = accounts_receivable_invoice_line.cny_ and dimensions_department.record_ = accounts_receivable_invoice_line.dept_ 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_location dimensions_location ON  dimensions_location.cny_ = accounts_receivable_invoice_line.cny_ and dimensions_location.record_ = accounts_receivable_invoice_line.location_ 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_GLACCOUNT offsetglaccountno ON offsetglaccountno.cny_ = accounts_receivable_invoice_line.cny_ and offsetglaccountno.record_ = accounts_receivable_invoice_line.offsetaccountkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_ARACCOUNTLABEL araccountlabel ON araccountlabel.cnyno = accounts_receivable_invoice_line.cny_ and araccountlabel.recordno = accounts_receivable_invoice_line.accountlabelkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_ALLOCATION alloc ON alloc.cny_ = accounts_receivable_invoice_line.cny_ and alloc.record_ = accounts_receivable_invoice_line.allocationkey 
  
   WHERE RECORDTYPE = 'ri';   


   ------ CONTENT OF core_schedule   


   CREATE OR REPLACE SECURE VIEW CORE_SCHEDULE
    COMMENT =  "Version=cfdda6ed-e587-4d5c-b4c6-ce9b5b6e58c3 " 
    AS SELECT 
    
 	-- 	end custom fields 
  core_schedule.cny_ AS cnyNumber, 
 	core_schedule.cronid AS cronid , 
 	core_schedule.description AS description , 
 	core_schedule.duedate AS duedate , 
 	core_schedule.enddate AS enddate , 
 	core_schedule.endon AS endon , 
 	core_schedule.execcount AS executioncount , 
 	core_schedule.exectype AS executiontype , 
 	core_schedule.name AS id , 
 	core_schedule.record_ AS key , 
 	core_schedule.lastexecdate AS lastexecutiondate , 
 	core_schedule.nextexecdate AS nextexecutiondate , 
 	core_schedule.repeatby AS repeatby , 
 	core_schedule.repeatcount AS repeatcount , 
 	core_schedule.repeatdate AS repeatdate , 
 	core_schedule.repeatinterval AS repeatinterval , 
 	core_schedule.startdate AS startdate , 
 	core_schedule.starton AS starton , 
 	core_schedule.status AS status 
 FROM  DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_schedule  core_schedule 
  
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo userinfo ON userinfo.record_ = core_schedule.user_ and userinfo.cny_ = core_schedule.cny_ 
  
  ;   


   ------ CONTENT OF company_config_location   


   CREATE OR REPLACE SECURE VIEW COMPANY_CONFIG_LOCATION
    COMMENT =  "Version=cfdda6ed-e587-4d5c-b4c6-ce9b5b6e58c3 " 
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
 FROM  DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_location  company_config_location 
  
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_createdbyuser ON audit_createdbyuser.cny_ = company_config_location.cny_ and audit_createdbyuser.record_ = company_config_location.createdby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_modifiedbyuser ON audit_modifiedbyuser.cny_ = company_config_location.cny_ and audit_modifiedbyuser.record_ = company_config_location.modifiedby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_contact contacts_primary ON contacts_primary.cny_ = company_config_location.cny_ and contacts_primary.record_ = company_config_location.contactkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_contact contacts_shipto ON contacts_shipto.cny_ = company_config_location.cny_ and contacts_shipto.record_ = company_config_location.shiptokey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_location parent ON parent.cny_ = company_config_location.cny_ and parent.record_ = company_config_location.parentkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_employee manageremp ON manageremp.cny_ = company_config_location.cny_ and manageremp.employeeid = company_config_location.employeekey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_contact mcontact ON manageremp.cny_ = company_config_location.cny_ and manageremp.employeeid = company_config_location.employeekey and mcontact.cny_ = company_config_location.cny_  and mcontact.record_ = manageremp.contactkey 
  
  ;   


   ------ CONTENT OF general_ledger_account   


   CREATE OR REPLACE SECURE VIEW GENERAL_LEDGER_ACCOUNT
    COMMENT =  "Version=cfdda6ed-e587-4d5c-b4c6-ce9b5b6e58c3 " 
    AS SELECT 
    
 	-- 	end custom fields 
  general_ledger_account.cny_ AS cnyNumber, 
 	general_ledger_account.account_type AS accounttype , 
 	general_ledger_account.alternativeaccount AS alternativeglaccount , 
 	general_ledger_account.closeable AS closingtype , 
 	general_ledger_account.subledgercontrolon AS disallowdirectposting , 
 	general_ledger_account.acct_no AS id , 
 	general_ledger_account.taxable AS istaxable , 
 	general_ledger_account.record_ AS key , 
 	general_ledger_account.mrccode AS mrccode , 
 	general_ledger_account.title AS name , 
 	general_ledger_account.normal_balance AS normalbalance , 
 	general_ledger_account.status AS status , 
 	general_ledger_account.taxcode AS taxcode , 
 	general_ledger_account.createdby AS audit_createdby , 
 	general_ledger_account.whencreated AS audit_createddatetime , 
 	general_ledger_account.modifiedby AS audit_modifiedby , 
 	general_ledger_account.whenmodified AS audit_modifieddatetime , 
 	general_ledger_account.requireasset AS requiredimensions_asset , 
 	general_ledger_account.requireclass AS requiredimensions_class , 
 	general_ledger_account.requirecontract AS requiredimensions_contract , 
 	general_ledger_account.requirecustomer AS requiredimensions_customer , 
 	general_ledger_account.requiredept AS requiredimensions_department , 
 	general_ledger_account.requireemployee AS requiredimensions_employee , 
 	general_ledger_account.requireitem AS requiredimensions_item , 
 	general_ledger_account.requireloc AS requiredimensions_location , 
 	general_ledger_account.requireproject AS requiredimensions_project , 
 	general_ledger_account.requirevendor AS requiredimensions_vendor , 
 	general_ledger_account.requirewarehouse AS requiredimensions_warehouse , 
 	close_to_account.acct_no AS closetoglaccount_id , 
 	general_ledger_account.closetoacctkey AS closetoglaccount_key , 
 	general_ledger_account.locationkey AS entity_key 
 FROM  DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_glaccount  general_ledger_account 
  
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_createdbyuser ON audit_createdbyuser.cny_ = general_ledger_account.cny_ and audit_createdbyuser.record_ = general_ledger_account.createdby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_modifiedbyuser ON audit_modifiedbyuser.cny_ = general_ledger_account.cny_ and audit_modifiedbyuser.record_ = general_ledger_account.modifiedby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_IACOACAT category ON category.record_ = general_ledger_account.categorykey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_glaccount close_to_account ON close_to_account.cny_ = general_ledger_account.cny_ and close_to_account.record_ = general_ledger_account.closetoacctkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_location melocation ON melocation.cny_ = general_ledger_account.cny_ and melocation.record_ = general_ledger_account.locationkey 
  
  ;   


   ------ CONTENT OF accounts_receivable_customer   


   CREATE OR REPLACE SECURE VIEW ACCOUNTS_RECEIVABLE_CUSTOMER
    COMMENT =  "Version=cfdda6ed-e587-4d5c-b4c6-ce9b5b6e58c3 " 
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
 	pricelist.name AS pricelist_id , 
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
 FROM  DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_customer  accounts_receivable_customer 
  
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_createdbyuser ON audit_createdbyuser.cny_ = accounts_receivable_customer.cny_ and audit_createdbyuser.record_ = accounts_receivable_customer.createdby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_modifiedbyuser ON audit_modifiedbyuser.cny_ = accounts_receivable_customer.cny_ and audit_modifiedbyuser.record_ = accounts_receivable_customer.modifiedby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_contact contacts_billto ON contacts_billto.cny_ = accounts_receivable_customer.cny_ and contacts_billto.record_ = accounts_receivable_customer.billtokey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_contact contacts_default ON contacts_default.cny_ = accounts_receivable_customer.cny_ and contacts_default.record_ = accounts_receivable_customer.displaycontactkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_contact contacts_primary ON contacts_primary.cny_ = accounts_receivable_customer.cny_ and contacts_primary.record_ = accounts_receivable_customer.contactkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_contact contacts_shipto ON contacts_shipto.cny_ = accounts_receivable_customer.cny_ and contacts_shipto.record_ = accounts_receivable_customer.shiptokey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_customer parent ON parent.cny_ = accounts_receivable_customer.cny_ and parent.record_ = accounts_receivable_customer.parentkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_GLACCTGRP glgroup ON glgroup.cny_ = accounts_receivable_customer.cny_ and glgroup.record_ = accounts_receivable_customer.glgrpkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_ACCOUNTLABEL accountlabel ON accountlabel.cny_ = accounts_receivable_customer.cny_ and accountlabel.record_ = accounts_receivable_customer.accountlabelkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_CUSTMESSAGE custmessage ON custmessage.cny_ = accounts_receivable_customer.cny_ and custmessage.messageid = accounts_receivable_customer.custmessageid 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_CUSTTYPE custtype ON custtype.cny_ = accounts_receivable_customer.cny_ and custtype.record_ = accounts_receivable_customer.custtypekey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_GLACCOUNT araccount ON araccount.cny_ = accounts_receivable_customer.cny_ and araccount.record_ = accounts_receivable_customer.accountkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_GLACCOUNT offsetglaccountno ON offsetglaccountno.cny_ = accounts_receivable_customer.cny_ and offsetglaccountno.record_ = accounts_receivable_customer.offsetaccountkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_PRICELIST pricelist ON pricelist.recordno = accounts_receivable_customer.oeprclstkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_employee custrep ON custrep.cny_ = accounts_receivable_customer.cny_ and custrep.record_ = accounts_receivable_customer.custrepkey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_CONTACT custrepcontact ON custrepcontact.cny_ = accounts_receivable_customer.cny_ and custrepcontact.record_ = custrep.contactkey and custrep.cny_ = accounts_receivable_customer.cny_ and accounts_receivable_customer.custrepkey = custrep.record_ 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_SHIPMETHOD shipmethod ON shipmethod.cny_ = accounts_receivable_customer.cny_ and shipmethod.record_ = accounts_receivable_customer.shipviakey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_TERM term ON term.cny_ = accounts_receivable_customer.cny_ and term.record_ = accounts_receivable_customer.termskey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_TERRITORY territory ON territory.cny_ = accounts_receivable_customer.cny_ and territory.record_ = accounts_receivable_customer.territorykey 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_prrecord accounts_receivable_invoice ON accounts_receivable_customer.cny_ = accounts_receivable_invoice.cny_ 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_LOCATION melocation ON melocation.cny_ = accounts_receivable_invoice.cny_ and melocation.record_ = accounts_receivable_invoice.record_ 
  
  ;   


   ------ CONTENT OF general_ledger_reporting_period   


   CREATE OR REPLACE SECURE VIEW GENERAL_LEDGER_REPORTING_PERIOD
    COMMENT =  "Version=545ba1c3-ac47-4130-adca-d54a00b28080 " 
    AS SELECT 
    
 	-- 	end custom fields 
  general_ledger_reporting_period.cny_ AS cnyNumber, 
 	general_ledger_reporting_period.header1 AS columnheader1 , 
 	general_ledger_reporting_period.header2 AS columnheader2 , 
 	general_ledger_reporting_period.datetype AS datetype , 
 	general_ledger_reporting_period.end_date AS enddate , 
 	general_ledger_reporting_period.name AS id , 
 	general_ledger_reporting_period.budgeting AS isbudgetable , 
 	general_ledger_reporting_period.record_ AS key , 
 	general_ledger_reporting_period.start_date AS startdate , 
 	general_ledger_reporting_period.status AS status , 
 	general_ledger_reporting_period.createdby AS audit_createdby , 
 	general_ledger_reporting_period.whencreated AS audit_createddatetime , 
 	general_ledger_reporting_period.modifiedby AS audit_modifiedby , 
 	general_ledger_reporting_period.whenmodified AS audit_modifieddatetime 
 FROM  DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_glbudgettype  general_ledger_reporting_period 
  
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_createdbyuser ON audit_createdbyuser.cny_ = general_ledger_reporting_period.cny_ and audit_createdbyuser.record_ = general_ledger_reporting_period.createdby 
 	LEFT JOIN DATA_SHARE_SAGE.SIF_SAGE_VIEWS.V_SA_userinfo audit_modifiedbyuser ON audit_modifiedbyuser.cny_ = general_ledger_reporting_period.cny_ and audit_modifiedbyuser.record_ = general_ledger_reporting_period.modifiedby 
  
  ;