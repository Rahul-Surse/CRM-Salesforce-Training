public with sharing class AccountFutureMethod {
    
    @future
    public static void updateAccountDescription(Set<Id> setAccountIds)
    {
        System.debug('---------future method call---');
        List<Account> lstAcc = [SELECT Id, Description FROM Account WHERE Id IN :setAccountIds];
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
