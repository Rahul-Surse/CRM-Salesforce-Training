/***************************************************************************************************
* @Author:        CRM Developer
* @className:     DeleteDuplicateLeads
* @Description:   This class is responsible for deleting duplicate lead records
***************************************************************************************************/
public with sharing class DeleteDuplicateLeads {

    public  void deleteDuplicateLeads(){
        List<String> lstFields = new List<String>{'Name','Email'};

        List<Lead> leads = [
                                SELECT 
                                    Id, Name, Email
                                FROM 
                                    Lead
                                ORDER BY 
                                    CreatedDate
                                ASC
                                LIMIT 
                                    50000
                            ];

        Set<Lead> setDelLeads = new Set<Lead>();
        for (String fieldName : lstFields) {
            Set<String> setValues = new Set<String>();
            for (Lead l : leads) {
                String val = (String)l.get(fieldName);
                if (setValues.contains(val)) {
                    setDelLeads.add(l);
                } else {
                    setValues.add(val);
                }
            }
        }
        if(!setDelLeads.isEmpty()){
            delete new List<Lead>(setDelLeads);
        }
    }
}
