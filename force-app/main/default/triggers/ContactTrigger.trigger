
/***************************************************************************************************
* @Author:        CRM Developer
* @TriggerName:   ContactTrigger
* @Description:   This Trigger is responsible for handling the event which occur on Contact Records.
***************************************************************************************************/
trigger ContactTrigger on Contact (before insert,before update) {
    // if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
    //     ContactTriggerHandler.checkDuplicates(Trigger.new);
    // }
    if (Trigger.isBefore && Trigger.isInsert) {
        ContactTriggerHandler.associateContactsToAccount(Trigger.new);
    }
}