/***************************************************************************************************
* @Author:        CRM Developer
* @TriggerName:   OpportunityTrigger
* @Description:   This Trigger is responsible for handling the event which occur on  Opportunity Records.
***************************************************************************************************/
trigger OpportunityTrigger on Opportunity (before insert,before update, after insert) {
    if ((Trigger.isBefore) && (Trigger.isInsert || Trigger.isUpdate)) {
        OpportunityTriggerHandler.validateOpportunityData(Trigger.new);
    }

    if(Trigger.isAfter && Trigger.isInsert)
    {
        
    }
}