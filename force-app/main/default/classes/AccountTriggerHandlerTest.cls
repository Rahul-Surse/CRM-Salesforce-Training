
/***************************************************************************************************
* @Author:        CRM Developer
* @className:     AccountTriggerHandlerTest
* @Description:   This class is responsible for performing testing on AccountTriggerHandler
***************************************************************************************************/

@istest
private class AccountTriggerHandlerTest {

    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This method test future method which handle dml exception
    * @Param1:        NA
    ***************************************************************************************************/
    @isTest
    static void mixDmlOperationTest() {
        Test.startTest();
        MixDmlByFutureMethod.mixDmlOperation();
        List<Account> lstacc =   [
                                    SELECT 
                                        Id, Name 
                                    FROM 
                                        Account 
                                    WHERE 
                                        Name = 'sam' 
                                    LIMIT 1
                                ];
        List<User> createdUsers = [
                                        SELECT 
                                            Id, Username, Email, ProfileId
                                        FROM 
                                            User
                                        LIMIT 
                                            1
                                  ];

        Test.stopTest();
        Assert.areEqual('sam', lstacc[0].Name, 'Account was not created');
        Assert.areNotEqual(null, createdUsers[0].ProfileId, 'ProfileId must be assigned');
    }

    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This method test Account descriptions are updating or not
    * @Param1:        NA
    ***************************************************************************************************/
    @istest
    public static void updateAccountDescriptionTest()
    {
        List<Account> lstAccounts = new List<Account> {
                                                            new Account(Name = 'Future Test Acc 1'),
                                                            new Account(Name = 'Future Test Acc 2')
                                                      };
        Set<Id> lstAccIds = new Set<Id>();
        insert lstAccounts;
        for(Account acc : lstAccounts){
                lstAccIds.add(acc.Id);
        }
        Test.startTest();
        AccountFutureMethod.updateAccountDescription(lstAccIds);
        Test.stopTest();
        List<Account> lstupdatedAcc = [
                                    SELECT 
                                        Id, Description
                                    FROM 
                                        Account
                                    WHERE 
                                        Id 
                                    IN 
                                        :lstAccounts
                                ];

        for (Account a : lstupdatedAcc) {
            Assert.areEqual('Account Description', a.Description,'Account description is not Updated');
            Assert.areNotEqual(null, a.Description,'Account description is not Updated');
        }
    }

    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This method test the account prefix is append or not
    * @Param1:        NA
    ***************************************************************************************************/
    @isTest
    static void testAccountNamePrefixCtiAndQueueable() {
        List<Account> lstaccts = new List<Account>{
                                                    new Account(Name = 'My Company 1'),
                                                    new Account(Name = 'CTI - AlreadyPrefixed')
                                                };
        insert lstaccts;
        Test.startTest();
        AccountTriggerHandler.accountNamePrefixCti(lstaccts);
        Test.stopTest(); 

        Account updatedAcc1 = [
                                SELECT 
                                    Name 
                                FROM 
                                    Account 
                                WHERE 
                                    Id = :lstaccts[0].Id
                             ];

        Assert.areEqual('CTI - My Company 1', updatedAcc1.Name, 'prefix is not append');
        Account updatedAcc2 = [
                                    SELECT 
                                        Name 
                                    FROM 
                                        Account 
                                    WHERE 
                                        Id = :lstaccts[1].Id
                                    LIMIT
                                        200
                                ];
        assert.areEqual('CTI - AlreadyPrefixed', updatedAcc2.Name,'Not properly assign the prefix');
    }
    
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

        Opportunity opp3 = new Opportunity(
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
        
        List<Contact> flaggedContacts = [
                                            SELECT 
                                                Duplicate_Contact__c
                                            FROM 
                                                Contact
                                            WHERE 
                                                AccountId = :lstAcc1[0].Id
                                            LIMIT
                                                200
                                        ];
        Integer flaggedContactCount = 0;
        for (Contact c : flaggedContacts) {
            if (c.Duplicate_Contact__c) {
                flaggedContactCount++;
            }
        }
        System.assertEquals(1, flaggedContactCount,'Contact count not calculated well');

        List<Opportunity> flaggedOpps = [
                                            SELECT 
                                                Duplicate_Opp__c
                                            FROM 
                                                Opportunity
                                            WHERE 
                                                AccountId = :lstAcc1[0].Id
                                            LIMIT   
                                                200
                                        ];
        Integer flaggedOppCount = 0;
        for (Opportunity o : flaggedOpps) {
            if (o.Duplicate_Opp__c){
                flaggedOppCount++;
            }
        }

        System.assertEquals(1, flaggedOppCount,'Opportunity not calculated well');

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
}


