public with sharing class TestOpportunityTriggerHandler {
    
    public static Boolean flag =false;
    public static Boolean payflag = false;
    public static Boolean oliflag = false;
    public static void createPaymentRecord(List<Opportunity> lstOpportunites)
    {
        Set<Id> setOppIds = new Set<Id>();
        List<Payment__c> lstNewPayments = new List<Payment__c>();
        List<Opportunity> lstUpdatOpportunities = new List<Opportunity>();
        List<OpportunityLineItem> lstUpdateOli = new List<OpportunityLineItem>();
        for(Opportunity opp:lstOpportunites)
        {
            if(opp.StageName.equals('Closed Won'))
            {
                System.debug('close won find');
                setOppIds.add(opp.Id);
            }
        }
        List<Opportunity> lstClosedStageOpp = [
                                                    select 
                                                        id,name,CloseDate, 
                                                        (select id,Related_to_Acc__c,Payment_Date__c from Payments__r),
                                                        (select id from OpportunityLineItems)
                                                    from 
                                                        Opportunity 
                                                    where 
                                                        Id = :setOppIds And Paid__c != true 
                                                ];
        for(Opportunity opp :lstClosedStageOpp){
            List<Payment__c> lstPayemts = opp.Payments__r;
            List<OpportunityLineItem> lstOli = opp.OpportunityLineItems;
            Integer month  = opp.CloseDate.month();
            Date closeDate = opp.CloseDate;
            System.debug('closed Month  '+ month); 
            if(lstPayemts.isEmpty()){
                Date payDate = closeDate.addMonths(-month);
                System.debug('The Payemnt Month '+payDate);
                for(Integer i=0;i<month;i++){
                    payDate = payDate.addMonths(1);
                    lstNewPayments.add(new Payment__C
                    (Name = 'Test1',Amount__c = 100,Related_To_Opp__c = opp.Id,Payment_Date__c = payDate));
                }
                
                for(OpportunityLineItem oli :lstOli ){
                    lstUpdateOli.add(new OpportunityLineItem(Id = oli.Id,Is_Closed__c=True));
                }
            
            }else {
                System.debug('Else debug');
                Date payDate = closeDate.addMonths(-month);
                Set<Integer> setPayId = new Set<Integer>();
                for(Payment__c pay : lstPayemts ) 
                {
                    Id accid = pay.Related_to_Acc__c;
                    Integer monthup  = pay.Payment_Date__c.month();
                    for(Integer i=1;i<=month;i++){
                        payDate = payDate.addMonths(i);
                        if(monthup!=i)
                        {
                            lstNewPayments.add(new Payment__C
                            (Name = 'Test1',Amount__c = 100,Related_To_Opp__c = opp.Id,Payment_Date__c = payDate,Related_to_Acc__c=accid));
                            break;
                        }
                    }     
                }
                for(OpportunityLineItem oli :lstOli ){
                    lstUpdateOli.add(new OpportunityLineItem(Id = oli.Id,Is_Closed__c=True));
                }
            }
            lstUpdatOpportunities.add(new Opportunity(Id = opp.Id,Paid__c = True));
        }
        if(!payflag)
        {
            payflag=true;
            if(!lstNewPayments.isEmpty()){
                 System.debug('In insert deg');
                insert lstNewPayments;
               
            }
        }
        
        if (!oliflag) {
            oliflag = true;
            if(!lstUpdateOli.isEmpty()){
                update lstUpdateOli;
            }
        }
        
        if(!flag)
        {
            if(!lstUpdatOpportunities.isEmpty()){
                flag=true;
                update lstUpdatOpportunities; 
            }
        }
       
    }
}