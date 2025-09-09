public with sharing class AccountQueueableHandler implements Queueable {

    private Set<Id> accountIds;
     

    public AccountQueueableHandler(Set<Id> accIds) {
        this.accountIds = accIds;
    }

     public void execute(QueueableContext context) {
        List<Account> accountsToUpdate = [
            SELECT Id, Name
            FROM Account
            WHERE Id IN :accountIds
        ];


         for (Account acc : accountsToUpdate) {
            if ( !acc.Name.startsWith('CTI - '))
             {
                acc.Name = 'CTI - ' + acc.Name;
            }
        }

        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }

}