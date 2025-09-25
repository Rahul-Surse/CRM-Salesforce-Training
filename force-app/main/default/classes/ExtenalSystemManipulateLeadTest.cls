/***************************************************************************************************
* @Author:        CRM Developer
* @className:     ExtenalSystemManipulateLeadTest
* @Description:   This class is responsible for performing testing on ExtenalSystemManipulateLead REST Service
***************************************************************************************************/
@isTest
public class ExtenalSystemManipulateLeadTest {

    @testSetup
    static void setupData() {
        Lead objLead = new Lead(
            FirstName = 'John',
            LastName  = 'Doe',
            Company   = 'Default Company',
            Email     = 'john.doe@test.com',
            Phone     = '1111111111',
            Status    = 'Open - Not Contacted'
        );
        insert objLead;
    }

    @isTest
    static void testGetAllLeads() {
        Test.startTest();
        List<Lead> lstLeads = ExtenalSystemManipulateLead.getAllLeads();
        Test.stopTest();
        Assert.areNotEqual(0, lstLeads.size(), 'failed to fetch leads');
    }

    @isTest
    static void testCreateLeadRecordSuccess() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf(
            '{"FirstName":"Lisa","LastName":"Smith","Email":"lisa@test.com","Phone":"2222222222"}'
        );
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        ExtenalSystemManipulateLead.createLeadRecord();
        Test.stopTest();

        String body = RestContext.response.responseBody.toString();
        Assert.areNotEqual(-1, body.indexOf('Success'), 'Lead creation did not return success');
    }

    @isTest
    static void testInvalidJsonCoversCatchBlock() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf('not json');
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        ExtenalSystemManipulateLead.createLeadRecord(); // hit catch block once
        Test.stopTest();

        String body = RestContext.response.responseBody.toString();
        Assert.areNotEqual(-1, body.indexOf('false'), 'Expected failure on invalid JSON');
    }

    @isTest
    static void testUpdateLeadSuccess() {
        Lead existingLead = [SELECT FirstName, LastName FROM Lead LIMIT 1];
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf(
            '{"FirstName":"'+existingLead.FirstName+'","LastName":"'+existingLead.LastName+'","NewEmail":"new@test.com"}'
        );
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        ExtenalSystemManipulateLead.updateLead();
        Test.stopTest();

        String body = RestContext.response.responseBody.toString();
        Assert.areNotEqual(-1, body.indexOf('Success'), 'Lead update did not return success');
    }

    @isTest
    static void testUpdateLeadNotFound() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf('{"FirstName":"No","LastName":"Match"}');
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        ExtenalSystemManipulateLead.updateLead();
        Test.stopTest();

        String body = RestContext.response.responseBody.toString();
        Assert.areNotEqual(-1, body.indexOf('Lead not found'), 'UpdateLead did not handle missing lead');
    }

    @isTest
    static void testDeleteLeadSuccess() {
        Lead delLead = new Lead(
                                    FirstName = 'ToDelete',
                                    LastName  = 'Lead',
                                    Company   = 'Default Company',
                                    Email     = 'delete@test.com',
                                    Phone     = '1234567890',
                                    Status    = 'Open - Not Contacted'
                                );
        insert delLead;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf(
            '{"FirstName":"ToDelete","LastName":"Lead","Email":"delete@test.com","Phone":"1234567890"}'
        );
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        ExtenalSystemManipulateLead.deleteLead();
        Test.stopTest();

        String body = RestContext.response.responseBody.toString();
        Assert.areNotEqual(-1, body.indexOf('Success'), 'DeleteLead did not return success');
    }

    @isTest
    static void testDeleteLeadNotFound() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf(
            '{"FirstName":"X","LastName":"Y","Email":"nomatch@test.com","Phone":"0000000000"}'
        );
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        ExtenalSystemManipulateLead.deleteLead();
        Test.stopTest();

        String body = RestContext.response.responseBody.toString();
        Assert.areNotEqual(-1, body.indexOf('Lead not found'), 'DeleteLead did not handle missing lead');
    }

    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This method is created for implementing test case to force code into catch(Exception e)
    * @Param1:        NA
    ***************************************************************************************************/
    @isTest
    static void testUpdateLeadForceCatchBlock() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf('{bad json}');
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        ExtenalSystemManipulateLead.updateLead();
        Test.stopTest();

        String body = RestContext.response.responseBody.toString();
        System.assert(body.contains('false'));
        System.assertEquals(400, RestContext.response.statusCode);
    }


}
