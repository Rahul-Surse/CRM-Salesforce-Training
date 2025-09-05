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
        insert new List<Account>{
            new Account(Name = 'ABC Corp', Website = 'https://www.abc.com'),
            new Account(Name = 'XYZ Ltd', Website = 'xyz.com')
        };
    }
    
    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This method is created for implementing test case on domain abc.com
    * @Param1:        NA
    ***************************************************************************************************/

    @isTest
    static void testMatchingDomainABC() {
        System.Test.startTest();
        Contact c = new Contact(LastName = 'Smith', Email = 'john@abc.com');
        insert c;
        System.Test.stopTest();
        
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
        
        System.assertNotEquals(null, lstContact[0].AccountId, 'fails to Assign account to contact');
    }

    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This method is created for implementing test case on domain xyz.com
    * @Param1:        NA
    ***************************************************************************************************/

    @isTest
    static void testMatchingDomainXYZ() {
        System.Test.startTest();
        Contact c = new Contact(LastName = 'Brown', Email = 'lisa@xyz.com');
        insert c;
        System.Test.stopTest();
        
        List<Contact> lstContact = [
                                        SELECT 
                                            Id, AccountId 
                                        FROM 
                                            Contact 
                                        WHERE 
                                            Id = :c.Id
                                        LIMIT
                                            50000
                                    ];
        
        System.assertNotEquals(null, lstContact[0].AccountId, 'fails to Assign account to contact');
    }

    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This method is created for implementing test case with no email
    * @Param1:        NA
    ***************************************************************************************************/

    @isTest
    static void testNoEmail() {
        System.Test.startTest();
        Contact c = new Contact(LastName = 'Doe');
        insert c;
        System.Test.stopTest();
        
        List<Contact> lstContact = [
                                        SELECT 
                                            Id, AccountId 
                                        FROM 
                                            Contact 
                                        WHERE 
                                            Id = :c.Id
                                        LIMIT 
                                            50000
                                    ];
        
        System.assertEquals(null, lstContact[0].AccountId, 'some problem is there');
    }

     /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This method is created for implementing test case on non-matching domain
    * @Param1:        NA
    ***************************************************************************************************/
    
    @isTest
    static void testNonMatchingDomain() {
        System.Test.startTest();
        Contact c = new Contact(LastName = 'Williams', Email = 'mary@nomatch.com');
        insert c;
        System.Test.stopTest();
        
        List<Contact> lstContact = [
                                        SELECT 
                                            Id, AccountId 
                                        FROM
                                            Contact 
                                        WHERE 
                                            Id = :c.Id
                                        LIMIT 
                                            50000
        ];
        System.assertEquals(null, lstContact[0].AccountId, 'some problem is there');
    }
}
