/***************************************************************************************************
* @Author:        CRM Developer
* @className:     AccountFutureMethod
* @Description:   This class is created to  handle future methods of account class
***************************************************************************************************/
public with sharing class AccountFutureMethod {
    

    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This method is responsible to change the description.
    * @Param1:        setAccountIds:- This set contain the ids of account which description getting change
    ***************************************************************************************************/
    @future
    public static void updateAccountDescription(Set<Id> setAccountIds){
        List<Account> lstAcc = [
                                    SELECT 
                                        Description 
                                    FROM 
                                        Account 
                                    WHERE 
                                        Id 
                                    IN 
                                        :setAccountIds
                                    LIMIT
                                        50000
                                ];
        for(Account acc : lstAcc){
            acc.Description = 'Account Description';
        }
        if(!lstAcc.isEmpty()){
            update lstAcc;
        }
    }
}
