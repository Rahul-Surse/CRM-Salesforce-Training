public with sharing class OpportunityProductLogService {
    //  public static void logOpportunityProductErrors(
    //     List<OpportunityLineItem> lstRecords,
    //     Database.SaveResult[] results
    // ) {
    //     List<Opportunity_Product_ErrorLogs__c> errorLogs = new List<Opportunity_Product_ErrorLogs__c>();

    //     for (Integer i = 0; i < results.size(); i++) {
    //         if (!results[i].isSuccess()) {
    //             OpportunityLineItem failedOli = lstRecords[i];

    //             // Collect all errors into one string
    //             String allErrors = '';
    //             for (Database.Error err : results[i].getErrors()) {
    //                 allErrors += err.getMessage() + ' | ';
    //             }

    //             Opportunity_Product_ErrorLogs__c log = new Opportunity_Product_ErrorLogs__c();
    //             log.name = failedOli.OpportunityId;
    //             log.Product_Id__c = failedOli.Product2Id;
    //             log.Error_Message__c = allErrors.removeEnd(' | '); // remove trailing pipe
    //             errorLogs.add(log);
    //         }
    //     }

    //     if (!errorLogs.isEmpty()) {
    //         insert errorLogs;
    //     }
    // }
}
