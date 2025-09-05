/***************************************************************************************************
* @Author:        CRM Developer
* @className:     EftTransactionStatusTriggerHandler
* @Description:   This is a handler class of EftTransactionStatus Trigger. 
***************************************************************************************************/
public with sharing class EftTransactionStatusTriggerHandler {
    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This method is responsible for creating a case record.
    * @Param1:        lstEftTransStatus:- The list of EFT Transaction object records from Trigger.new.
    ***************************************************************************************************/       
    public static void createCaseForDeclinedTransactions(List<EFT_Transaction_Status__c> lstEftTransStatus){
        List<Case> lstCases = new List<Case>();
        String AvsQueueId = '';
        String assignmentRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Assignment').getRecordTypeId();
        List<Group> grpList = [
                                SELECT
                                    Id 
                                FROM 
                                    Group 
                                WHERE 
                                    DeveloperName = 'AVS_Queue' 
                                LIMIT 
                                    1
                                ];
        if (!grpList.isEmpty()) {
            AvsQueueId = grpList[0].Id;
        }
        Set<Id> salesHeaderIds = new Set<Id>();
        for(EFT_Transaction_Status__c eft : lstEftTransStatus) {
            if(eft.SalesHeader__c != null) {
                salesHeaderIds.add(eft.SalesHeader__c);
            }
        }
        Map<Id, SalesHeader__c> salesHeaderMap = new Map<Id, SalesHeader__c>([
                                                                                SELECT 
                                                                                    Id,Name, Status__c, Bill_to_CustomerAcc__c, 
                                                                                    Bill_to_CustomerCon__c,Bill_to_CustomerAcc__r.Name
                                                                                FROM 
                                                                                    SalesHeader__c
                                                                                WHERE Id 
                                                                                    IN :salesHeaderIds 
                                                                                LIMIT
                                                                                    50000
                                                                            ]);
        for(EFT_Transaction_Status__c eft : lstEftTransStatus) {
        SalesHeader__c sh = salesHeaderMap.get(eft.SalesHeader__c);
            if(eft.Method_Name__c == 'Credit Card Address Verify' &&
                eft.Transaction_Status__c == 'Declined' &&
                sh != null && sh.Status__c == 'Open'){
                Case newCase = new Case(
                    AccountId = sh.Bill_to_CustomerAcc__c,
                    ContactId = sh.Bill_to_CustomerCon__c,
                    Origin = 'Internal',
                    Reason = 'Address Did Not Verify',
                    Priority = 'High',
                    Status = 'New',
                    Type = 'Address Did Not Verify',
                    Open_Sales_Order__c = sh.Id,
                    Transaction_Status__c = eft.Transaction_Status__c,
                    Sales_Order_Number__c = sh.Name,
                    Order_Date__c = eft.Transaction_Date__c
                );
                
                newCase.Subject = sh.Bill_to_CustomerAcc__r.Name + '  ' + newCase.Type;
                if(String.isNotBlank(assignmentRecordTypeId) || String.isNotBlank(AvsQueueId)){
                    newCase.RecordTypeId = assignmentRecordTypeId;
                    newCase.OwnerId = AvsQueueId;
                }
                lstCases.add(newCase);
            }
        }
        if(!lstCases.isEmpty()) {
            insert lstCases;
        }
    }
}