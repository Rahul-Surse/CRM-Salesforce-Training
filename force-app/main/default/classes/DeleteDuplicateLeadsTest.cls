/***************************************************************************************************
* @Author:            CRM Developer
* @TestclassName:     DeleteDuplicateLeadsTest
* @Description:       This class is responsible for testing DeleteDuplicateLeads class functionality
***************************************************************************************************/
@isTest
private class DeleteDuplicateLeadsTest {

    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This method is created for setup purpose
    * @Param1:        NA
    ***************************************************************************************************/
    @testSetup
    static void setupTestData() {
        List<Lead> lstLeads = new List<Lead>();
        lstLeads.add(new Lead(FirstName = 'John', LastName = 'Smith', Company='Company A', Email = 'john.smith@test.com'));
        lstLeads.add(new Lead(FirstName = 'Mary', LastName = 'Jane', Company='Company B', Email = 'mary.jane@test.com'));
        lstLeads.add(new Lead(FirstName = 'John', LastName = 'Smith2', Company='Company C', Email = 'john.smith@test.com'));
        lstLeads.add(new Lead(FirstName = 'Mary', LastName = 'Jane', Company='Company D', Email = 'different.mary@test.com'));

        insert lstLeads;
    }

    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This method test that the duplicated leads are deleted or not
    * @Param1:        NA
    ***************************************************************************************************/
    static testMethod void testDeleteDuplicateLeads() {
        Integer intBeforeCount = [
                                    SELECT 
                                        count() 
                                    FROM 
                                        Lead 
                                    LIMIT 
                                        50000
                                 ];
        Test.startTest();
        DeleteDuplicateLeads objDelete = new DeleteDuplicateLeads();
        objDelete.deleteDuplicateLeads();
        Test.stopTest();

        List<Lead> lstRemainingLeads = [
                                            SELECT 
                                                Id
                                            FROM 
                                                Lead 
                                            LIMIT 50000
                                        ];
        Assert.areEqual(
            2, 
            lstRemainingLeads.size(),
            'Not deleted'
        );
    }

    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This method is created for to test the duplicate record
    * @Param1:        NA
    ***************************************************************************************************/
    static testMethod void testNoDuplicateLeads() {
        List<Lead> lstUniqueLeads = new List<Lead>();
        lstUniqueLeads.add(new Lead(FirstName = 'Alice', LastName='Wonder', Company='Company E', Email='alice@test.com'));
        lstUniqueLeads.add(new Lead(FirstName = 'Bob', LastName='Marley', Company='Company F', Email='bob@test.com'));
        insert lstUniqueLeads;

        Test.startTest();
        DeleteDuplicateLeads objDelete = new DeleteDuplicateLeads();
        objDelete.deleteDuplicateLeads();
        Test.stopTest();

        List<Lead> lstRemaining = [
                                        SELECT 
                                            Id, Name, Email 
                                        FROM 
                                            Lead 
                                        WHERE 
                                            Email IN ('alice@test.com','bob@test.com') 
                                        LIMIT 50000
                                    ];
        Assert.areEqual(
            2, 
            lstRemaining.size(),
            'no duplicates.'
        );
    }
}
