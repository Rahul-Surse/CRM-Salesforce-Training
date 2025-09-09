
/***************************************************************************************************
* @Author:        CRM Developer
* @className:     AccountTriggerHandler
* @Description:   This class is responsible for handling the functionality of the AccountTrigger 
***************************************************************************************************/
public with sharing class AccountTriggerHandler {
    
    private static Boolean cloneFlag=false;
    public static Boolean isFirstRun = true;
    public static Boolean flag = true;
    
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

    public static void updateAccountDescription(List<Account> lstAccounts)
    {

         if (!isFirstRun) {
            return; 
        }
        isFirstRun = false;
         System.debug('---------updateAccountDescription handler---');
         Set<Id> accIds = new Set<Id>();
        for(Account acc : lstAccounts){
            accIds.add(acc.Id);
        }
        
        if(!accIds.isEmpty()){
            if(System.IsBatch() == false && System.isFuture() == false){ 
                AccountFutureMethod.updateAccountDescription(accIds);
            }
            else{
                System.debug('Another Future is running');
            }
        }
    }
    public static void accountNamePrefixCti(List<Account> lstAccounts)
    {
        Set<Id> setAccIds = new Set<Id>();
        for (Account acc : lstAccounts) {
            setAccIds.add(acc.Id);
        }

        if (!setAccIds.isEmpty() && (flag == True)) {
            try {
                System.enqueueJob(new AccountQueueableHandler(setAccIds));
                flag = false;
            } catch (Exception e) {
                System.debug(e);
            }
           
        }
        flag = true;
    }
} 