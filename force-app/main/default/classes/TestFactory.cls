
/***************************************************************************************************
* @Author:        CRM Developer
* @className:     TestFactory
* @Description:   This class fetch and create a record which required for testing of error log object records
***************************************************************************************************/
@istest
public with sharing class TestFactory {

    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This method fetch,create required record and return List of opportunity line item record
    * @Param1:        NA
    ***************************************************************************************************/    
    public static List<OpportunityLineItem> getPriceBookId()
    {

        String pbId = '';
        List<Product2> lstProducts = new List<Product2>();
        List<PricebookEntry> lstPb = new List<PricebookEntry>();
        List<Opportunity> lstOpp = new List<Opportunity>();
        List<OpportunityLineItem> lstOli = new List<OpportunityLineItem>();
        List<Pricebook2> lstPriceBookIds= [
                                                SELECT 
                                                    Id 
                                                FROM
                                                    Pricebook2  
                                                WHERE
                                                    IsStandard = True
                                                LIMIT
                                                    1
                                        ];
        if(!lstPriceBookIds.isEmpty()){
            pbId = lstPriceBookIds[0].Id;
        }                        
        
        for(Integer i=1;i<=10;i++){
            Product2 pro = new Product2 (
                Name = 'Pro' + i,
                ProductCode = '1000' + i
            );
            lstProducts.add(pro);
        }
        insert lstProducts;
        for(Integer i=1;i<=10;i++){
            String pid = 'pro' + i;
            PricebookEntry pbe = new PricebookEntry(
                Pricebook2Id = pbId,
                Product2Id =pid
            );
            lstPb.add(pbe);
        }
        insert lstPb;
        for(Integer i=1;i<=10;i++)
        {
            Opportunity opp = new Opportunity(
                            name = 'opp' + i,
                            CloseDate = Date.today() - (i * 2),
                            StageName = 'Qualification'
                        );
                lstOpp.add(opp);
        }
        insert lstOpp;
        OpportunityLineItem oli1 = new OpportunityLineItem(
                        OpportunityId = 'opp1'                   
        );
        lstOli.add(oli1);
        return lstOli;
    }   
}


