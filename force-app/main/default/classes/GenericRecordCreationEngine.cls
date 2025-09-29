
/***************************************************************************************************
* @Author:            CRM Developer
* @TestclassName:     GenericRecordCreationEngine
* @Description:       This class is responsible for creating records according to the json enter in the 
                      even description
***************************************************************************************************/
public with sharing class GenericRecordCreationEngine{  
    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This method is responsible for creating Object which pass through the description of 
                      The event
    * @Param1:        NA
    ***************************************************************************************************/
    public  void  objectCreation() { 

        List<SObject> lstCreateSobject = new List<SObject>();
        List<Event> lstEvents = [
                                    SELECT 
                                        Description
                                    FROM 
                                        Event
                                    LIMIT
                                        50000
                                ];
        Map<String,Object> mapStrvsObject = new Map<String,Object>();
        try {
            for(Event e : lstEvents){
                if(!String.isBlank(e.Description)){
                    mapStrvsObject =(Map<String,Object>) JSON.deserializeUntyped(e.Description);
                    String strObj =(String) mapStrvsObject.get('ObjectName');
                    SObject obj = Schema.getGlobalDescribe().get(strObj).newSObject();
                    Map<String,Object> mapStrVsObj = (Map<String,Object>)mapStrvsObject.get('JSON');
                    for(String field : mapStrVsObj.keySet()){
                        obj.put(field,mapStrVsObj.get(field));
                    }
                    lstCreateSobject.add(obj);
                }     
                System.debug(lstCreateSobject);
            }
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        if (!lstCreateSobject.isEmpty()) {
            insert lstCreateSobject;
        }
       
    }
}