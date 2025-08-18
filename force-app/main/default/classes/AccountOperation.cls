public with sharing class AccountOperation {
    

  public static Map<String, Account> getAccountsByPhone(List<Account> accounts)
   {
        Map<String, Account> phoneMap = new Map<String, Account>();

        for (Account acc : accounts) {
            if (acc.Phone != null) {
                phoneMap.put(acc.Phone, acc);
            }
        }

     
        return phoneMap;
    }
    

    public static void CallOperation()
    {   System.debug('HEllo');
        List<Account> listAcc = [SELECT Name, AccountNumber, Phone FROM Account];

         System.debug(AccountOperation.getAccountsByPhone(listAcc));
    }
}