
/***************************************************************************************************
* @Author:        CRM Developer
* @className:     AccountTriggerHandler
* @Description:   This class is responsible for handling the functionality of the AccountTrigger 
***************************************************************************************************/
public with sharing class AccountTriggerHandler {
    
    private static Boolean cloneFlag=false;
    
    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This method is responsible for cloning Account records whenever a new Account 
                      is inserted. 
    * @Param1:        lstNewAccounts:- The list of Account records from Trigger.new.
    ***************************************************************************************************/
    public static void afterInsertCreateClone(List<Account> lstNewAccounts)
    {
        if(!cloneFlag)
        {
            List<Account> lstCloneAccounts = new List<Account>();
            for (Account account : lstNewAccounts) {
                Account cloneAccount = account.clone(false, true, false, false);
                cloneAccount.Name = account.Name + ' Clone'; 
                lstCloneAccounts.add(cloneAccount);
            }
            if(!lstNewAccounts.isEmpty())
            {
                cloneFlag = true;
                insert lstCloneAccounts;
            }
        }
    }
}