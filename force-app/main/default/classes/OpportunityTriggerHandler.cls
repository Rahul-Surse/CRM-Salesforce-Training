
/***************************************************************************************************
* @Author:        CRM Developer
* @className:     ContactTriggerHandler
* @Description:   This class manages validation rules for Opportunity records that 
*                 are executed from the Opportunity trigger. 
***************************************************************************************************/
public with sharing class OpportunityTriggerHandler {
    
    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   Checks a list of Opportunity records and validates that if the StageName is 'Closed Won', 
                      then the Description field must contain a value. or duplicate Contacts based on Email or Phone before inserting
                      or updating records.
    * @Param1:        lstOpportunity:- The list of Opportunity records from Trigger.new.
    ***************************************************************************************************/
    public static void validateOpportunityData(List <Opportunity> lstOpportunity){
        for(Opportunity opp : lstOpportunity) {
            if(opp.StageName.equals('Closed Won') && String.isBlank(opp.Description)) {
                opp.Description.addError('Description is required when Opportunity Stage is Closed Won.');
            }
        }
    }

    public static void calculate




}