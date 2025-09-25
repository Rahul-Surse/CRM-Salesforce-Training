
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
        Test.stopTest();

        List<User> createdUsers = [
                                        SELECT 
                                            Id, Username, Email, ProfileId
                                        FROM 
                                            User
                                        WITH SECURITY_ENFORCED
                                        LIMIT 
                                            1
                                  ];
        Assert.areNotEqual(lstacc.isEmpty(), lstacc.size());
        Assert.areNotEqual(createdUsers.isEmpty(), createdUsers.size());
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
    
   
}


