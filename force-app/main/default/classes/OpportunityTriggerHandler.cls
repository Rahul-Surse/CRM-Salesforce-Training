/***************************************************************************************************
* @Author:          CRM Developer
* @TestClassName:   OpportunityTriggerHandler
* @Description:     This class manages validation rules for Opportunity records that 
*                   are executed from the Opportunity trigger. 
***************************************************************************************************/
public with sharing class OpportunityTriggerHandler {

    private static Boolean isSalesPriceRunning = false;
    private static Boolean isProcessing = false;
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

    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This method assign Sales Price of its associated Opportunity Product to 
                      the custom field 
    * @Param1:        lstOpportunities:- The list of Opportunity records from Trigger.new.
    ***************************************************************************************************/
    public static void salesPriceforassociatedOpportunityProduct(List <Opportunity> lstOpportunities){
        List<Opportunity> lstUpdateOpportunities = new List<Opportunity>();
        if (!isSalesPriceRunning) {
            isSalesPriceRunning = true;
            List<AggregateResult> lstAggResults =   [
                                                        SELECT 
                                                            OpportunityId,
                                                            SUM(TotalPrice) totalSales
                                                        FROM 
                                                            OpportunityLineItem
                                                        WHERE 
                                                            OpportunityId 
                                                        IN 
                                                            :lstOpportunities
                                                        GROUP BY
                                                            OpportunityId
                                                        LIMIT
                                                            50000
                                                    ];
            for (AggregateResult ar : lstAggResults) {
                Opportunity oppToUpdate = new Opportunity(
                    Id = (Id) ar.get('OpportunityId'),
                    Sales_Price__c = (Decimal) ar.get('totalSales')
                );
                lstUpdateOpportunities.add(oppToUpdate);
            }
            if (!lstUpdateOpportunities.isEmpty()) {
                update lstUpdateOpportunities;
            }
        }
       
    }

    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This method update the sales price of the product by updating its discount
    * @Param1:        lstOpportunities:- The list of Opportunity records from Trigger.new.
    ***************************************************************************************************/
    public static void updateSalesPriceAccordingToLineItemDiscount(List<Opportunity> lstOpportunities) {
         if (!isProcessing){
            isProcessing = true;
            Map<Id, Decimal> oppDiscountMap = new Map<Id, Decimal>();
            for (Opportunity opp : [
                                        SELECT 
                                            Line_Item_Discount__c
                                        FROM 
                                            Opportunity
                                        WHERE 
                                            Id 
                                        IN 
                                            :lstOpportunities
                                        LIMIT 
                                            50000
                                    ]){
                oppDiscountMap.put(opp.Id, opp.Line_Item_Discount__c);
            }
    
            List<OpportunityLineItem> lstOpp = [
                                                    SELECT 
                                                        Id, OpportunityId, UnitPrice, Quantity,ListPrice
                                                    FROM 
                                                        OpportunityLineItem
                                                    WHERE 
                                                        OpportunityId 
                                                    IN 
                                                        :lstOpportunities
                                                    LIMIT
                                                        50000
                                               ];
            List<OpportunityLineItem> lstOliToUpdate = new List<OpportunityLineItem>();
            for (OpportunityLineItem oli : lstOpp) {
                Decimal discount1 = oppDiscountMap.get(oli.OpportunityId);
                if (discount1 != null) {
                    // Decimal updatedUnitPrice = oli.ListPrice	* (1 - discount / 100);
                    // OpportunityLineItem oppLineItem = 
                    // oppLineItem.Id = oli.Id;
                    // oppLineItem.UnitPrice = updatedUnitPrice;
                    // oppLineItem.discount=discount;
                    lstOliToUpdate.add(
                                            new OpportunityLineItem(
                                                Id = oli.Id,
                                                discount=discount1
                                            )
                                        );
                    }
            }
            if (!lstOliToUpdate.isEmpty()) {
                update lstOliToUpdate;
            }
            isProcessing = false;
         } 
    }

    public static void updateTotalPriceOfAsssociatedApportunities(List <Opportunity> lstOpportunities)
    {
        Set<Id> setOppId = new set<Id>();
		for(Opportunity opp : lstOpportunities)
		{
			setOppId.add(opp.AccountId);
		}
		List<AggregateResult> lstAcc = [
                                            SELECT
                                                sum(amount) totalOpp,AccountId  
                                            FROM 
                                                Opportunity 
                                            GROUP BY
                                                AccountId 
                                            HAVING 
                                                AccountId IN : setOppId
                                        ];
		List<Account> lstUpdateAcc = new List<Account>();
        if(lstAcc.isEmpty())
        {
            // lstUpdateAcc.add(new Account(id = (Id)agg.get('AccountId'),Total_Amount__c = 0));
        }
        else {
                for(AggregateResult Agg :lstAcc ){
                    Decimal totalOppAmount = (Decimal)agg.get('totalOpp');
                    lstUpdateAcc.add(new Account(id = (Id)agg.get('AccountId'),Total_Amount__c = totalOppAmount));
		         }
        }
		
		update lstUpdateAcc;
    }
}