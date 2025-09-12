public with sharing class AccountQueueableHandler implements Queueable {

    private Set<Id> accountIds;
    List<Account> lstUpdateAccounts;

    public AccountQueueableHandler( List<Account> lstUpdateAccounts) {
        this.lstUpdateAccounts=lstUpdateAccounts;
    }
    public void execute(QueueableContext context) {
        if (!lstUpdateAccounts.isEmpty()) {
            update lstUpdateAccounts;
        }
    }
}