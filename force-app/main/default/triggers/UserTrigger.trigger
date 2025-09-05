/***************************************************************************************************
* @Author:        CRM Developer
* @TriggerName:   UserTrigger
* @Description:   This Trigger is responsible for handling the event which occur on User Records.
***************************************************************************************************/
trigger UserTrigger on User (after insert,after update) {

    if(Trigger.isAfter && Trigger.isInsert){
        UserTriggerHandler.updateRoleOfUserAccordingFirstName(Trigger.new);
    }
    if(Trigger.isAfter && Trigger.isUpdate){
        UserTriggerHandler.decisionActivateOrDeactivateUser(Trigger.new);
    }
}