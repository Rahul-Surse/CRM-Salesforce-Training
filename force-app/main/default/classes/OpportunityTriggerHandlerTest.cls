/***************************************************************************************************
* @Author:        CRM Developer
* @className:     OpportunityTriggerHandlerTest
* @Description:   This class is responsible for performing testing on OpportunityTriggerHandlerTest
***************************************************************************************************/
@isTest
public with sharing class OpportunityTriggerHandlerTest {
  /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This method creates test data that will be available for all test methods in this class
    * @Param1:        NA
    ***************************************************************************************************/
    @testSetup
    static void setupData() {
        Id standardPBId = Test.getStandardPricebookId();
        Product2 prod = new Product2(Name = 'Test Product', IsActive = true);
        insert prod;
        PricebookEntry stdPbe = new PricebookEntry(
                                                        Pricebook2Id = standardPBId,
                                                        Product2Id = prod.Id,
                                                        UnitPrice = 100,
                                                        IsActive = true
                                                  );
        insert stdPbe;
        Opportunity opp1 = new Opportunity(
                                                Name = 'Opp With OLI',
                                                StageName = 'Prospecting',
                                                CloseDate = Date.today(),
                                                Pricebook2Id = standardPBId
                                         );
        Opportunity opp2 = new Opportunity(
                                                Name = 'Opp Without OLI',
                                                StageName = 'Prospecting',
                                                CloseDate = Date.today(),
                                                Pricebook2Id = standardPBId
                                          );
        Opportunity opp3 = new Opportunity(
                                                Name = 'Bulk Opp',
                                                StageName = 'Prospecting',
                                                CloseDate = Date.today(),
                                                Pricebook2Id = standardPBId
                                         );
        insert new List<Opportunity>{opp1, opp2, opp3};
        OpportunityLineItem oli1 = new OpportunityLineItem(
                                                                OpportunityId = opp1.Id,
                                                                PricebookEntryId = stdPbe.Id,
                                                                Quantity = 3,
                                                                UnitPrice = 100
                                                          );
        insert oli1;
    }

    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This method tests discount update on OpportunityLineItem
    * @Param1:        NA
    ***************************************************************************************************/
    @isTest
    static void testDiscountUpdate() {
        List<Opportunity> lstopp = [
                                        SELECT 
                                            Id 
                                        FROM 
                                            Opportunity 
                                        WHERE 
                                            Name = 'Opp With OLI' 
                                        LIMIT 
                                            1
                                    ];
        Opportunity opp = lstopp[0];
        opp.Line_Item_Discount__c = 10;
        Test.startTest();
        update opp;
        Test.stopTest();

        List<OpportunityLineItem> lstOli = [
                                        SELECT
                                            Id, UnitPrice 
                                        FROM 
                                            OpportunityLineItem 
                                        WHERE 
                                            OpportunityId = :opp.Id 
                                        LIMIT 
                                            1
                                  ];
        OpportunityLineItem oli = lstOli[0];
        Assert.areEqual(100, oli.UnitPrice, 'Unit Price not updated'); 
    }

    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This method tests Sales Price when Opportunity has no OLIs
    * @Param1:        NA
    ***************************************************************************************************/
    @isTest
    static void testNoOpportunityLineItem() {
        Test.startTest();
        List<Opportunity> lstopp = [
                                        SELECT 
                                            Id 
                                        FROM 
                                            Opportunity 
                                        WHERE 
                                            Name = 'Opp Without OLI' 
                                        LIMIT 
                                            1
                                    ];
        Opportunity opp = lstopp[0];
        Test.stopTest();
        List<Opportunity> lstopp1  = [
                                        SELECT 
                                            Sales_Price__c 
                                        FROM 
                                            Opportunity 
                                        WHERE 
                                            Id = :opp.Id
                                        LIMIT 
                                            1
                                    ];
        Opportunity opp1 = lstopp1[0];
        Assert.areEqual(null, opp1.Sales_Price__c, 'There is Line item Which is invalid');
    }

    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This method tests that UnitPrice remains unchanged when no discount is applied
    * @Param1:        NA
    ***************************************************************************************************/
    @isTest
    static void testNoDiscount() {
        List<Opportunity> lstopp = [
                                        SELECT 
                                            Id 
                                        FROM 
                                            Opportunity 
                                        WHERE 
                                            Name = 'Opp With OLI' 
                                        LIMIT 
                                            1
                                    ];
        Opportunity opp = lstopp[0];                             
        opp.Line_Item_Discount__c = null;

        Test.startTest();
        update opp;
        Test.stopTest();

        List<OpportunityLineItem> lstOli  = [
                                                SELECT 
                                                    Id, UnitPrice 
                                                FROM 
                                                    OpportunityLineItem 
                                                WHERE 
                                                    OpportunityId = :opp.Id 
                                                LIMIT 
                                                    1
                                    ];
        OpportunityLineItem oli = lstOli[0];                        
        Assert.areEqual(100, oli.UnitPrice, 'Unit Price should remain unchanged when discount is null');
    }
}