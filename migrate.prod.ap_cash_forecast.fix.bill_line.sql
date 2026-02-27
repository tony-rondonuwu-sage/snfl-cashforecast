/*
accounts_payable_bill_line
*/


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

