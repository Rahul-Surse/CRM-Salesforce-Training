/***************************************************************************************************
* @Author:        CRM Developer
* @TriggerName:   OpportunityTrigger
* @Description:   This Trigger is responsible for handling the event which occur on  Opportunity Records.
***************************************************************************************************/
// trigger OpportunityTrigger on Opportunity (
//     // before insert,before update, after insert,after update
//     after insert,after update,after delete
//     ) {
//     // if ((Trigger.isBefore) && (Trigger.isInsert || Trigger.isUpdate)) {
//     //     OpportunityTriggerHandler.validateOpportunityData(Trigger.new);
//     // }

//     // if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate))
//     // {
//     //     OpportunityTriggerHandler.salesPriceforassociatedOpportunityProduct(Trigger.new);
//     //     if(Trigger.isAfter && Trigger.isUpdate)
//     //     {
//     //         OpportunityTriggerHandler.updateSalesPriceAccordingToLineItemDiscount(Trigger.new);
//     //     }
//     // }/
//     // System.debug('triggered');
//     // if(Trigger.isAfter &&(Trigger.isInsert || Trigger.isUpdate)){			
// 		//     OpportunityTriggerHandler.updateTotalPriceOfAsssociatedApportunities(Trigger.new);	
//     // }
//     // if(Trigger.isAfter && Trigger.IsDelete)
//     // {
//     //     OpportunityTriggerHandler.updateTotalPriceOfAsssociatedApportunities(Trigger.old);
//     // }
// }


trigger OpportunityTrigger on Opportunity (after update)
{
 
  if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate))
  {
      TestOpportunityTriggerHandler.createPaymentRecord(Trigger.new);
  }

}