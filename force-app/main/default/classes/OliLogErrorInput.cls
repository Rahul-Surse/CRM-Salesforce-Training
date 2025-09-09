
/***************************************************************************************************
* @Author:        CRM Developer
* @className:     OliLogErrorInput
* @Description:   This class permform operation like insert,update,delete and undelete.
***************************************************************************************************/
public class OliLogErrorInput {
    
    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This method perform insert Operation on list of opportunity Line item and pass the list 
                      of reults of Database.SaveResult to OliLogRecord.oliLogCreation() to create log of failed 
                      record
    * @Param1:        NA
    ***************************************************************************************************/
    public static void insertData() 
    {   
        List<OpportunityLineItem> lstoli =new List<OpportunityLineItem>();
        
            lstoli.add(new OpportunityLineItem(
                OpportunityId = '006dL00000EptonQAB',  
                PricebookEntryId = '01udL000004vlXpQAI',
                Quantity = 3,
                TotalPrice = 10
            ));
            lstoli.add(new OpportunityLineItem(
                OpportunityId = '006dL00000EptonQAB', 
                PricebookEntryId = '01udL000004vlXpQAI',
                Quantity = 3
            ));
            List<Database.SaveResult> results = Database.insert(lstoli,false);
            OliLogRecord.oliLogCreation(results,'Insert');
    }

    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This method perform update Operation on list of opportunity Line item and pass the list of
                      of reults of Database.SaveResult to OliLogRecord.oliLogCreation() to create log of failed 
                      record
    * @Param1:        NA
    ***************************************************************************************************/
    public static void upDateData()
    {  
        List<OpportunityLineItem> lstoli =new List<OpportunityLineItem>();
            lstoli.add(new OpportunityLineItem(
                Id = '00kdL00000HSM2DQAX',
                OpportunityId = '006dL00000DYUDtQAP',  
                PricebookEntryId = '01udL000004vlXpQAI', 
                TotalPrice = 100
            ));
            lstoli.add(new OpportunityLineItem(
                OpportunityId = '006dL00000DYUDtQAP',  
                PricebookEntryId = '01udL000004vlXpQAI', 
                TotalPrice = 100
            ));
           
            List<Database.SaveResult> results = Database.Update(lstoli,false);
            System.debug(results[0].getErrors());
            OliLogRecord.oliLogCreation(results,'Update');
    }

    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This method perform delete Operation on list of opportunity Line item and pass the list of
                      of reults of Database.SaveResult to OliLogRecord.oliLogCreation() to create log of failed 
                      record
    * @Param1:        NA
    ***************************************************************************************************/
    public static void deleteData()
    {  
        List<OpportunityLineItem> lstoli =new List<OpportunityLineItem>();
            lstoli.add(new OpportunityLineItem(
                Id = '00kdL00000HPydVQAT'
            ));
           
            List<Database.DeleteResult> results = Database.Delete(lstoli,false);
            OliLogRecord.oliLogCreation(results,'Delete');
    }

    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This method perform undelete Operation on list of opportunity Line item and pass the list of
                      of reults of Database.SaveResult to OliLogRecord.oliLogCreation() to create log of failed 
                      record
    * @Param1:        NA
    ***************************************************************************************************/
    public static void unDeleteData()
    {  
        List<OpportunityLineItem> lstoli =new List<OpportunityLineItem>();
            lstoli.add(new OpportunityLineItem(
                Id = '00kdL00000HPyjjQAD'
            ));
           
            List<Database.UndeleteResult> results = Database.Undelete(lstoli,false);
            OliLogRecord.oliLogCreation(results,'Undelete');
    }
}