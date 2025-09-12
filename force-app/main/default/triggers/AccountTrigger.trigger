/***************************************************************************************************
* @Author:        CRM Developer
* @TriggerName:   AccountTrigger
* @Description:   This Trigger is responsible for handling the event which occur on Account Records.p
***************************************************************************************************/

trigger AccountTrigger on Account (after insert,after update,before insert,before update) {
    // if(Trigger.isAfter && Trigger.isInsert){
    //     AccountTriggerHandler.afterInsertCreateClone(Trigger.new);
    // }
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)){
        AccountTriggerHandler.updateAccountDescription(Trigger.new);
    }
    if(Trigger.isAfter &&(Trigger.isInsert || Trigger.isUpdate))
    {
        AccountTriggerHandler.accountNamePrefixCti(Trigger.new);
    }
       

}