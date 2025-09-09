/***************************************************************************************************
* @Author:        CRM Developer
* @className:     ContactTriggerHandlerTest
* @Description:   This class is responsible for performing testing on contact trigger handler
***************************************************************************************************/
@isTest
public class ContactTriggerHandlerTest {

    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This method creates test data that will be available for all test methods in this class
    * @Param1:        NA
    ***************************************************************************************************/

    @testSetup
    static void setupData() {
        List<Account> lstAccounts = new List<Account>();
        Account acc1=new Account(Name = 'ABC Corp', Website = 'https://www.abc.com');
        Account acc2=new Account(Name = 'XYZ Ltd', Website = 'xyz.com');
        lstAccounts.add(acc1);
        lstAccounts.add(acc2);
        insert lstAccounts;
    }
    
    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This method is created for implementing test case on domain abc.com
    * @Param1:        NA
    ***************************************************************************************************/

    @isTest
    static void testMatchingDomainABC() {
        Contact c = new Contact(LastName = 'Smith', Email = 'john@abc.com');
        Test.startTest();
        insert c;
        Test.stopTest();
        
        List<Contact> lstContact =  [
                                        SELECT 
                                            AccountId 
                                        FROM 
                                            Contact 
                                        WHERE 
                                            Id = :c.Id
                                        LIMIT 
                                            50000
                                    ];
        
        Assert.areNotEqual(null, lstContact[0].AccountId, 'failed to Assign account to contact');
    }

    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This method is created for implementing test case on domain xyz.com
    * @Param1:        NA
    ***************************************************************************************************/

    @isTest
    static void testMatchingDomainXYZ() {
        Contact c = new Contact(LastName = 'Brown', Email = 'lisa@xyz.com');
        Test.startTest();
        insert c;
        Test.stopTest();
        
        List<Contact> lstContact = [
                                        SELECT 
                                            AccountId 
                                        FROM 
                                            Contact 
                                        WHERE 
                                            Id = :c.Id
                                        LIMIT
                                            50000
                                    ];
        Assert.areNotEqual(null, lstContact[0].AccountId, 'fails to Assign account to contact');
    }

    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This method is created for implementing test case with no email
    * @Param1:        NA
    ***************************************************************************************************/

    @isTest
    static void testNoEmail() {
        Contact c = new Contact(LastName = 'Doe');
        Test.startTest();
        insert c;
        Test.stopTest();
        
        List<Contact> lstContact = [
                                        SELECT 
                                             AccountId 
                                        FROM 
                                            Contact 
                                        WHERE 
                                            Id = :c.Id
                                        LIMIT 
                                            1
                                    ];
        Assert.areEqual(null, lstContact[0].AccountId, 'Account assign to contact have no eamil');
    }

    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This method is created for implementing test case on non-matching domain
    * @Param1:        NA
    ***************************************************************************************************/
    
    @isTest
    static void testNonMatchingDomain() {
        Contact c = new Contact(LastName = 'Williams', Email = 'mary@nomatch.com');
        Test.startTest();
        insert c;
        Test.stopTest();
        
        List<Contact> lstContact = [
                                        SELECT 
                                            AccountId 
                                        FROM
                                            Contact 
                                        WHERE 
                                            Id = :c.Id
                                        LIMIT 
                                            50000
        ];
        Assert.areEqual(null, lstContact[0].AccountId, 'Domain is not match still account get assign to contact');
    }
}
