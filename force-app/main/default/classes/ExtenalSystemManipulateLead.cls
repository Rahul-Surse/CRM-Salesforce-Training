/***************************************************************************************************
* @Author:        CRM Developer
* @className:     ExtenalSystemManipulateLead
* @Description:   This class exposes REST endpoints to create, read, update, and delete Leads
*                 so external systems can manipulate Leads in Salesforce.
***************************************************************************************************/
@RestResource(urlMapping='/ExtenalSystemManipulateLead/*')
global with sharing class ExtenalSystemManipulateLead {
    List<Lead_Error_Log__c> lstNewLogRec = new List<Lead_Error_Log__c>();
    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This method retrieves up to 200 Leads from Salesforce.
    * @Param1:        NA
    ***************************************************************************************************/
    @HttpGet
    global static List<Lead> getAllLeads() {
        List<Lead> lstLeads = [
                                    SELECT 
                                        Id, FirstName, LastName, Company, Email, Status
                                    FROM 
                                        Lead
                                    LIMIT 
                                        200
                                ];
        return lstLeads;
    }

    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   Creates a new Lead record from JSON input containing FirstName, LastName, Email,
    *                 and Phone. Returns a response with isSuccess, LeadRecordId, and Status.
    * @Param1:        JSON body representing Lead information
    ***************************************************************************************************/
    @HttpPost
    global static void createLeadRecord() {

        Map<String, Object> mapStrObjectResponse = new Map<String, Object>();

        try {
            String strRequestBody = RestContext.request.requestBody.toString();
            Map<String, Object> mapStrObjectInput = 
                (Map<String, Object>) JSON.deserializeUntyped(strRequestBody);
            Lead objLead = new Lead();
            objLead.FirstName = (String) mapStrObjectInput.get('FirstName');
            objLead.LastName = (String) mapStrObjectInput.get('LastName');
            objLead.Email = (String) mapStrObjectInput.get('Email');
            objLead.Phone = (String) mapStrObjectInput.get('Phone');
            objLead.Company = 'Default Company'; 
            if (String.isBlank(objLead.LastName)) {
                throw new customException('Lastname Required','create record');
            }
            insert objLead;

            mapStrObjectResponse.put('isSuccess', true);
            mapStrObjectResponse.put('LeadRecordId', objLead.Id);
            mapStrObjectResponse.put('Status', 'Success');
            RestContext.response.statusCode = 200;

        } catch (Exception ex) {
            String errType, operation;
            if (ex instanceof customException) {
                errType = 'CustomValidationError';
                operation = 'Validation';
            } else if (ex instanceof CalloutException) {
                errType = 'CalloutError';
                operation = 'Callout';
            } else if (ex instanceof DmlException) {
                errType = 'DMLException';
                operation = 'DML';
            } else {
                errType = 'SystemException';
                operation = 'System';
            }

            ExtenalSystemManipulateLead.createLogRec(
                'createLeadRecord',             
                null,                           
                ex.getMessage(),                
                operation,                      
                RestContext.request.requestBody != null ?
                    RestContext.request.requestBody.toString() : null, 
                'High',                         
                ex.getStackTraceString(),       
                'Failed',                       
                errType,                        
                UserInfo.getName()              
            );

        mapStrObjectResponse.put('isSuccess', false);
        mapStrObjectResponse.put('LeadRecordId', '');
        mapStrObjectResponse.put('Status', ex.getMessage());
        RestContext.response.statusCode = 400;
        }
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(mapStrObjectResponse));
    }
    
    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   Deletes a Lead matching the provided attributes. Returns success or error info.
    * @Param1:        JSON body with FirstName, LastName, Email, and Phone
    ***************************************************************************************************/
    @HttpDelete
    global static void deleteLead() {

        Map<String, Object> responseMap = new Map<String, Object>();
        String recId='';
        try {
            String requestBody = RestContext.request.requestBody.toString();
            Map<String, Object> inputMap = (Map<String, Object>) JSON.deserializeUntyped(requestBody);

            String firstName = (String) inputMap.get('FirstName');
            String lastName  = (String) inputMap.get('LastName');
            String email     = (String) inputMap.get('Email');
            String phone     = (String) inputMap.get('Phone');

            List<Lead> leadsToDelete = [
                                            SELECT 
                                                Id, FirstName, LastName
                                            FROM 
                                                Lead
                                            WHERE 
                                                FirstName = :firstName
                                            AND 
                                                LastName  = :lastName
                                            AND    
                                                Email     = :email
                                            AND 
                                                Phone     = :phone
                                            LIMIT 
                                                1
                                        ];
            if(recId!=null)
            {
                recId=leadsToDelete[0].Id;
            }
            if (!leadsToDelete.isEmpty()) {
                Lead lead = leadsToDelete[0];
                String fullName = lead.FirstName + ' ' + lead.LastName;

                delete lead;

                responseMap.put('isSuccess', true);
                responseMap.put('LeadFullName', fullName);
                responseMap.put('Status', 'Success');
                RestContext.response.statusCode = 200;

            } else {
                responseMap.put('isSuccess', false);
                responseMap.put('LeadFullName', '');
                responseMap.put('Status', 'Lead not found');
                RestContext.response.statusCode = 404;
            }

        } catch (Exception ex) {
             String errType, operation;
            if (ex instanceof customException) {
                errType = 'CustomValidationError';
                operation = 'Validation';
            } else if (ex instanceof CalloutException) {
                errType = 'CalloutError';
                operation = 'Callout';
            } else if (ex instanceof DmlException) {
                errType = 'DMLException';
                operation = 'DML';
            } else {
                errType = 'SystemException';
                operation = 'System';
            }

            
            ExtenalSystemManipulateLead.createLogRec(
                'deleteLead',             
                recId,                           
                ex.getMessage(),                
                operation,                      
                RestContext.request.requestBody != null ?
                    RestContext.request.requestBody.toString() : null, 
                'High',                         
                ex.getStackTraceString(),       
                'Failed',                       
                errType,                        
                UserInfo.getName()              
            );
            responseMap.put('isSuccess', false);
            responseMap.put('LeadFullName', '');
            responseMap.put('Status', ex.getMessage());
            RestContext.response.statusCode = 400;
        } 
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(responseMap));
    }
    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   Updates a Lead record based on FirstName and LastName. Returns JSON response.
    * @Param1:        JSON body containing FirstName, LastName, NewEmail, and NewPhone
    ***************************************************************************************************/
    @HttpPatch
    global static void updateLead() {

        Map<String, Object> responseMap = new Map<String, Object>();
        String recId='';
        try {
            String requestBody = RestContext.request.requestBody.toString();
            Map<String, Object> inputMap = (Map<String, Object>) JSON.deserializeUntyped(requestBody);

            String firstName = (String) inputMap.get('FirstName');
            String lastName  = (String) inputMap.get('LastName');
            String newEmail  = (String) inputMap.get('NewEmail');
            String newPhone  = (String) inputMap.get('NewPhone');

            List<Lead> leadsToUpdate = [
                                            SELECT
                                                Id, Email, Phone
                                            FROM 
                                                Lead
                                            WHERE 
                                                FirstName = :firstName
                                            AND 
                                                LastName  = :lastName
                                            LIMIT 
                                                1
                                        ];
            if(recId!=null)
            {
                recId = leadsToUpdate[0].Id;
            }
            if (!leadsToUpdate.isEmpty()) {
                Lead lead = leadsToUpdate[0];
                if (newEmail != null) lead.Email = newEmail;
                if (newPhone != null) lead.Phone = newPhone;

                update lead;

                responseMap.put('isSuccess', true);
                responseMap.put('LeadRecordId', lead.Id);
                responseMap.put('Status', 'Success');
                RestContext.response.statusCode = 200;

            } else {
                responseMap.put('isSuccess', false);
                responseMap.put('LeadRecordId', '');
                responseMap.put('Status', 'Lead not found');
                RestContext.response.statusCode = 404;
            }

        } catch (Exception ex) {
            String errType, operation;
            if (ex instanceof customException) {
                errType = 'CustomValidationError';
                operation = 'Validation';
            } else if (ex instanceof CalloutException) {
                errType = 'CalloutError';
                operation = 'Callout';
            } else if (ex instanceof DmlException) {
                errType = 'DMLException';
                operation = 'DML';
            } else {
                errType = 'SystemException';
                operation = 'System';
            }

            
            ExtenalSystemManipulateLead.createLogRec(
                'updateLead',             
                recId,                           
                ex.getMessage(),                
                operation,                      
                RestContext.request.requestBody != null ?
                    RestContext.request.requestBody.toString() : null, 
                'High',                         
                ex.getStackTraceString(),       
                'Failed',                       
                errType,                        
                UserInfo.getName()              
            );
            responseMap.put('isSuccess', false);
            responseMap.put('LeadRecordId', '');
            responseMap.put('Status', ex.getMessage());
            RestContext.response.statusCode = 400;
        }

        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(responseMap));
    }

    public static void createLogRec(String method,String recId,String mess,String opp,String body,
                        String severity,String sTrace,String status,String type,String con)
    {
        Lead_Error_Log__c newLog = new Lead_Error_Log__c();
        newLog.Error_Causing_Class_Method__c = method;
        newLog.Error_Causing_Record_Id__c = recId;
        newLog.Message_Long__c = mess;
        newLog.Operation__c = opp;
        newLog.Request_Body__c = body;
        newLog.Severity__c = severity;
        newLog.Stack_Trace__c = sTrace;
        newLog.Status__c = status;
        newLog.Type__c = type;
        newLog.User_Context__c = con;
        
        insert newLog;
    }
}


