public with sharing class AccountQueueableHandler implements Queueable {

    private Set<Id> accountIds;
    List<Account> lstUpdateAccounts;

    public AccountQueueableHandler( List<Account> lstUpdateAccounts) {
          System.debug('------------Q Construtor get Called-------------');
        this.lstUpdateAccounts=lstUpdateAccounts;
    }

     public void execute(QueueableContext context) {
        // List<Account> accountsToUpdate = [
        //     SELECT Id, Name
        //     FROM Account
        //     WHERE Id IN :accountIds
        // ];

        System.debug('------------Perform Logis-----------');
         for (Account acc : lstUpdateAccounts) {
                acc.Name = 'CTI - ' + acc.Name;
        }
            System.debug(lstUpdateAccounts);
        if (!lstUpdateAccounts.isEmpty()) {
            update lstUpdateAccounts;
        }
    }

}