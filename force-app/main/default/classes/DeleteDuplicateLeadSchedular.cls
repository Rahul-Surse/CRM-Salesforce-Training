/***************************************************************************************************
* @Author:        CRM Developer
* @className:     DeleteDuplicateLeadSchedular
* @Description:   This class is a scheduler class of DeleteDuplicateLeads class.
***************************************************************************************************/
public with sharing class DeleteDuplicateLeadSchedular implements Schedulable {
    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This method create Object of  deleteDupLeadsRecord and call method deleteDuplicateLeads
                      after specifice time of interval
    * @Param1:        sc:- The reference of Schedulable context.
    ***************************************************************************************************/
    public void execute(SchedulableContext sc) {
        DeleteDuplicateLeads deleteDupLeadsRecord = new DeleteDuplicateLeads();
        deleteDupLeadsRecord.deleteDuplicateLeads();
    }
}
