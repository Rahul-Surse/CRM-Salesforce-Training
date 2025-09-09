
/***************************************************************************************************
* @Author:        CRM Developer
* @className:     OliLogRecord
* @Description:   This class create a record for the Error log record object 
***************************************************************************************************/
public with sharing class OliLogRecord {
   
    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This method take a list Database.SaveResult and a string as aparameter.By Iterating 
                      database.saveresult according to non success record it create error log with the error message
    * @Param1:        results:- The list of Database.SaveResult which having information of both record which 
                                was save as well as faild record.
      @Param2:        opp:- It is a string parameter which store the operation type
    ***************************************************************************************************/
    Public static void oliLogCreation(List<Database.SaveResult> results,String opp)
    {   List<Error_Log_Record__c> lstErrorLog = new List<Error_Log_Record__c>();
        for(Integer i=0;i<results.size();i++)
        {
            Database.SaveResult sr = results[i];
            if (!results[i].isSuccess()) {
                Error_Log_Record__c log = new Error_Log_Record__c();
                String allerror = '';
                for (Database.Error err : sr.getErrors()) {
                    allerror +=err.getMessage();
                }
                log.Error_Message__c = allerror;
                log.Opertaion_Type__c = opp;
                lstErrorLog.add(log);
                Insert lstErrorLog;
            }
        } 
    }

    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This method take a list Database.DeleteResult and a string as aparameter.By Iterating 
                      Database.DeleteResult according to non success record it create error log with the error message
    * @Param1:        results:- The list of Database.DeleteResult which having information of both record which 
                                was save as well as faild record.
      @Param2:        opp:- It is a string parameter which store the operation type
    ***************************************************************************************************/
    Public static  void oliLogCreation(List<Database.DeleteResult> results,String opp)
    {
        List<Error_Log_Record__c> lstErrorLog = new List<Error_Log_Record__c>();
        for(Integer i=0;i<results.size();i++)
        {
            Database.DeleteResult sr = results[i];
            if (!results[i].isSuccess()) {
                Error_Log_Record__c log = new Error_Log_Record__c();
                String allerror = '';
                for (Database.Error err : sr.getErrors()) {
                    allerror +=err.getMessage();
                }
                log.Error_Message__c = allerror;
                log.Opertaion_Type__c = opp;
                lstErrorLog.add(log);
                Insert lstErrorLog;
            }
        }
    }

    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This method take a list Database.UndeleteResult and a string as aparameter.By Iterating 
                     Database.UndeleteResult according to non success record it create error log with the error message
    * @Param1:        results:- The list of Database.UndeleteResult which having information of both record which 
                                was save as well as faild record.
      @Param2:        opp:- It is a string parameter which store the operation type
    ***************************************************************************************************/
    Public static void oliLogCreation(List<Database.UndeleteResult> results,String opp)
    {
       List<Error_Log_Record__c> lstErrorLog = new List<Error_Log_Record__c>();
        for(Integer i=0;i<results.size();i++)
        {
            Database.UndeleteResult sr = results[i];
            if (!results[i].isSuccess()) {
                Error_Log_Record__c log = new Error_Log_Record__c();
                String allerror = '';
                for (Database.Error err : sr.getErrors()) {
                    allerror +=err.getMessage();
                }
                log.Error_Message__c = allerror;
                log.Opertaion_Type__c = opp;
                lstErrorLog.add(log);
                Insert lstErrorLog;
            }
        }
    }
}