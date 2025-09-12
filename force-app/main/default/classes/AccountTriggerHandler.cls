
/***************************************************************************************************
* @Author:        CRM Developer
* @className:     AccountTriggerHandler
* @Description:   This class is responsible for handling the functionality of the AccountTrigger 
***************************************************************************************************/
public with sharing class AccountTriggerHandler {
    
    private static Boolean cloneFlag = false;
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


    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This method is responsible for updaing account description 
    * @Param1:        lstNewAccounts:- The list of Account records from Trigger.new.
    ***************************************************************************************************/
    public static void updateAccountDescription(List<Account> lstAccounts){
        if (isFirstRun) {
            isFirstRun = false;
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
        
    }
    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This method is responsible for updaing account Account Name with prefix cti 
    * @Param1:        lstNewAccounts:- The list of Account records from Trigger.new.
    ***************************************************************************************************/
    public static void accountNamePrefixCti(List<Account> lstAccounts){
        Set<Id> setAccIds = new Set<Id>();
        List<Account> lstUpdateAccounts = new List<Account>();
        for (Account acc : lstAccounts) {
            if ( !acc.Name.startsWith('CTI - ')){
                lstUpdateAccounts.add(new Account(Id=acc.Id,Name = 'CTI - '+acc.Name));
            }    
        }
        if (!lstUpdateAccounts.isEmpty()) {
            System.enqueueJob(new AccountQueueableHandler(lstUpdateAccounts));
        }
    }
} 