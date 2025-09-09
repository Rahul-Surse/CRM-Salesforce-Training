/***************************************************************************************************
* @Author:        CRM Developer
* @TriggerName:   AccountTrigger
* @Description:   This Trigger is responsible for handling the event which occur on Account Records.
***************************************************************************************************/

trigger AccountTrigger on Account (after insert,after update,before insert) {
    // if(Trigger.isAfter && Trigger.isInsert){
    //     AccountTriggerHandler.afterInsertCreateClone(Trigger.new);
    // }

    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)){
        System.debug('---------trigger hited---');
        AccountTriggerHandler.updateAccountDescription(Trigger.new);
    }
    if(Trigger.isBefore)
    {
        AccountTriggerHandler.accountNamePrefixCti(Trigger.new);
    }
       

}