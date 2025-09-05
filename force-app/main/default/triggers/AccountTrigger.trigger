/***************************************************************************************************
* @Author:        CRM Developer
* @TriggerName:   AccountTrigger
* @Description:   This Trigger is responsible for handling the event which occur on Account Records.
***************************************************************************************************/

trigger AccountTrigger on Account (after insert) {
    if(Trigger.isAfter && Trigger.isInsert){
        AccountTriggerHandler.afterInsertCreateClone(Trigger.new);
    }
}