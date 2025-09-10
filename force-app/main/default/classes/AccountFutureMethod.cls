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
        System.debug('---------future method call---');
        List<Account> lstAcc = [
                                    SELECT 
                                        Id, Description 
                                    FROM 
                                        Account 
                                    WHERE 
                                        Id 
                                    IN :setAccountIds
                                ];
        for(Account acc : lstAcc){
            if(acc.Description != null){
                acc.Description = 'Account Description';
            } else {
                acc.Description = 'Account Description';
            }
        }
        if(!lstAcc.isEmpty()){
             System.debug('---------Updating record---');
            update lstAcc;
        }
    }
}
