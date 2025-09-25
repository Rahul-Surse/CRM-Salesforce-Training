
/***************************************************************************************************
* @Author:        CRM Developer
* @className:     scheduleGrcEngineTest
* @Description:   This class is responsible for performing testing on scheduleGrcEngine class with different Scenario
***************************************************************************************************/
@isTest
public class scheduleGrcEngineTest{

     /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This method is created for setup purpose
    * @Param1:        NA
    ***************************************************************************************************/
    @testSetup
    static void setupTestData() {
        List<Event> lstEvents = new List<Event>();

        String jsonAcc = '{"ObjectName":"Account","JSON":{"Name":"Test Account"}}';
        lstEvents.add(new Event(
            Subject = 'Test Event 1',
            Description = jsonAcc,
            StartDateTime = System.now(),
            DurationInMinutes = 60
        ));

        String jsonCon = '{"ObjectName":"Contact","JSON":{"LastName":"Test Contact","Email":"test@example.com"}}';
        lstEvents.add(new Event(
            Subject = 'Test Event 2',
            Description = jsonCon,
            StartDateTime = System.now(),
            DurationInMinutes = 60
        ));

        String invalidJson = 'Invalid JSON String';
        lstEvents.add(new Event(
            Subject = 'Test Event 3',
            Description = invalidJson,
            StartDateTime = System.now(),
            DurationInMinutes = 60
        ));

        insert lstEvents;
    }

     /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This method test the object creation is working well or not
    * @Param1:        NA
    ***************************************************************************************************/
    static testMethod void testObjectCreation() {
        Test.startTest();
        GenericRecordCreationEngine grc = new GenericRecordCreationEngine();
        grc.objectCreation();
        Test.stopTest();

        List<Account> lstAccounts = [
                                        SELECT 
                                            Id
                                        FROM 
                                            Account 
                                        WHERE 
                                            Name = 'Test Account'
                                    ];
        Assert.areEqual(1, lstAccounts.size(), 'One Account should have been created');
        Assert.areEqual('Test Account', lstAccounts[0].Name, 'Account name should match the JSON');

        List<Contact> lstContacts = [
                                        SELECT 
                                            Id
                                        FROM 
                                            Contact 
                                        WHERE 
                                            LastName = 'Test Contact'
                                    ];
        Assert.areEqual(1, lstContacts.size(), 'record is not created');
        Assert.areEqual('test@example.com', lstContacts[0].Email, 'email is not match to json');
    }

     /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This method is test th scenario when we pass Invalid json in description
    * @Param1:        NA
    ***************************************************************************************************/
    static testMethod void testObjectCreationWithInvalidJson() {
        Test.startTest();
        GenericRecordCreationEngine grc = new GenericRecordCreationEngine();
        grc.objectCreation();
        Test.stopTest();

        List<Account> lstAccounts = [
                                        SELECT 
                                            Name 
                                        FROM 
                                            Account 
                                        WHERE 
                                            Name = 'Test Account'
                                    ];
        Assert.areEqual(1, lstAccounts.size(), 'some probem is there');
        Assert.areEqual('Test Account', lstAccounts[0].Name, 'account name not match');

        List<Contact> lstContacts = [
                                        SELECT 
                                            Id
                                        FROM 
                                            Contact 
                                        WHERE 
                                            LastName = 'Test Contact'
                                    ];
        Assert.areEqual(1, lstContacts.size(), 'record get created');
        Assert.areEqual('test@example.com', lstContacts[0].Email, 'email is not match with record');
    }
}
