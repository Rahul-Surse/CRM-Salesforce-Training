
/***************************************************************************************************
* @Author:        CRM Developer
* @TriggerName:   EftTransactionStatusTrigger
* @Description:   This Trigger is responsible for handling the event occur on EFT Transaction Status
***************************************************************************************************/
trigger EftTransactionStatusTrigger on EFT_Transaction_Status__c (after insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        EftTransactionStatusTriggerHandler.createCaseForDeclinedTransactions(Trigger.new);
    }
}