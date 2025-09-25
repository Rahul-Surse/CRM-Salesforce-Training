/***************************************************************************************************
* @Author:        CRM Developer
* @className:     DuplicateContactAndOpportunityTest
* @Description:   This class is responsible for performing testing on DuplicateContactAndOpportunity class
***************************************************************************************************/
@istest
public with sharing class DuplicateContactAndOpportunityTest {
    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This method create a data set which required for testing
    * @Param1:        NA
    ***************************************************************************************************/
    @testSetup
    static void setupData() {

        Account acc1 = new Account(Name = 'CTI - Acc With Duplicates');
        insert acc1;

        Contact con1 = new Contact(LastName = 'SameName', AccountId = acc1.Id);
        Contact con2 = new Contact(LastName = 'SameName', AccountId = acc1.Id);
        // Contact conNew = new Contact(LastName = 'SameName', AccountId = acc1.Id);
        insert new List<Contact>{con1, con2};

        Opportunity opp1 = new Opportunity(
                                                Name = 'DupOpp',
                                                StageName = 'Prospecting',
                                                Amount = 100,
                                                CloseDate = Date.today().addDays(10),
                                                AccountId = acc1.Id
                                            );
        Opportunity opp2 = new Opportunity(
                                                Name = 'DupOpp',
                                                StageName = 'Prospecting',
                                                Amount = 200,
                                                CloseDate = Date.today().addDays(10),
                                                AccountId = acc1.Id
                                            );
        insert new List<Opportunity>{opp1, opp2};

        Account acc2 = new Account(Name = 'CTI - Acc Without Duplicates');
        insert acc2;

        Contact con3 = new Contact(LastName = 'UniqueName', AccountId = acc2.Id);
        insert con3;

        Opportunity opp3 = new Opportunity  (
                                                Name = 'UniqueOpp',
                                                StageName = 'Prospecting',
                                                Amount = 300,
                                                CloseDate = Date.today().addDays(10),
                                                AccountId = acc2.Id
                                            );
        insert opp3;
    }

    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This method test the duplicate contact and Opportunity
    * @Param1:        NA
    ***************************************************************************************************/

    @IsTest
    static void DuplicateContactAndOpportunityTest() {
        Test.startTest();
        Database.executeBatch(new DuplicateContactAndOpportunity(), 200);
        Test.stopTest();
        List<Account> lstAcc1 = [
                                    SELECT 
                                        Id 
                                    FROM 
                                        Account 
                                    WHERE 
                                        Name = 'CTI - Acc With Duplicates' 
                                    LIMIT 
                                        1
                                 ];
        List<Account> lstAcc2 = [
                                    SELECT 
                                        Id 
                                    FROM 
                                        Account 
                                    WHERE 
                                        Name = 'CTI - Acc Without Duplicates' 
                                    LIMIT
                                        1
                                ];
        List<AggregateResult> lstAggRes = [
                                                SELECT 
                                                    count(Id) totalDup
                                                FROM 
                                                    Contact
                                                WHERE 
                                                    AccountId = :lstAcc1[0].Id  
                                                AND 
                                                    Duplicate_Contact__c = true
                                                Group by
                                                    Duplicate_Contact__c
                                                LIMIT
                                                    200
                                            ];                       
        Decimal count = 0;
        if(!lstAggRes.isEmpty()){
            AggregateResult rs = lstAggRes[0];
            count = (Decimal) rs.get('totalDup');
        }

        System.assertEquals(1, count,'Contact count not calculated well');

        List<AggregateResult> flaggedOpps = [
                                                SELECT 
                                                    count(Id) totalDupOpp
                                                FROM 
                                                    Opportunity
                                                WHERE 
                                                    AccountId = :lstAcc1[0].Id And Duplicate_Opp__c = true
                                                GROUP BY
                                                    Duplicate_Opp__c
                                                LIMIT   
                                                    200
                                            ];
        Decimal oppCount = 0;
        if(!flaggedOpps.isEmpty()){
            AggregateResult rs = flaggedOpps[0];
            oppCount = (Decimal) rs.get('totalDupOpp');
        }

        System.assertEquals(1, oppCount,'Opportunity not calculated well');

        Contact c2 = [
                        SELECT 
                            Id, Duplicate_Contact__c 
                        FROM 
                            Contact 
                        WHERE 
                            AccountId = :lstAcc2[0].Id 
                        LIMIT 
                        1
                    ];
        System.assertEquals(false, c2.Duplicate_Contact__c);

        Opportunity o3 = [
                            SELECT 
                                Id, Duplicate_Opp__c 
                            FROM 
                                Opportunity 
                            WHERE 
                                AccountId = :lstAcc2[0].Id 
                            LIMIT 
                                1
                         ];
        System.assertEquals(false, o3.Duplicate_Opp__c);
    }

    @istest
    static void bulkTest()
    {
        System.debug('In Bulk Test');
        Test.loadData(Account.sObjectType,'AccountData');
        System.debug('Account Inserted');
        Test.loadData(Contact.sObjectType,'ContactRecord');
        System.debug('Contact Inserted');
        Test.loadData(Opportunity.SObjectType,'OpportunityData');
        System.debug('Opportunity Inserted');
        

        System.debug('BEfore Bacth Call');
        Test.startTest();
        Database.executeBatch(new DuplicateContactAndOpportunity(), 2);
        Test.stopTest();
        System.debug('After Batch Call');

        List<Account> lstAcc1 = [
                                    SELECT 
                                        Id 
                                    FROM 
                                        Account 
                                    WHERE 
                                        Name = 'AccBulkTest' 
                                    LIMIT 
                                        1
                                 ];

    List<Contact> lstcon = [select Duplicate_Contact__c from contact where Duplicate_Contact__c =True ];

    Integer count = 0;
    for(Contact c :lstcon)
    {
        if(c.Duplicate_Contact__c == True)
        {
            count++;
        }
    }
    System.debug(count);
    // List<AggregateResult> lstAggRes = new List<AggregateResult>();
    // for (AggregateResult ar : [
    //                                 SELECT 
    //                                     COUNT(Id) totalDup
    //                                 FROM 
    //                                     Contact
    //                                 WHERE 
    //                                     AccountId = :lstAcc1[0].Id  
    //                                 AND 
    //                                     Duplicate_Contact__c = true
    //                                 GROUP BY 
    //                                     Duplicate_Contact__c
    //                                 LIMIT 
    //                                     100
    //                          ]) {
    //     lstAggRes.add(ar);
    // }

    // Decimal count = 0;
    // if (!lstAggRes.isEmpty()) {
    //     count = (Decimal) lstAggRes[0].get('totalDup');
    // }

        System.assertEquals(1000, count,'Contact count not calculated well');
    }
}