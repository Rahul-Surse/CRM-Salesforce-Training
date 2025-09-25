public with sharing class AccountManagerController {
    public List<Account> lstAccounts { get; set; }
    public String message { get; set; }
    public String searchKey { get; set; }
    public String searchBychar { get; set; }

    public AccountManagerController() {
        allRecord();
    }

    private void allRecord() {
        lstAccounts = [
                            SELECT 
                                Id, Name, Phone, Website, Email__c
                            FROM 
                                Account
                            LIMIT 
                                1000
                        ];
        message = 'Accounts found: ' + lstAccounts.size();
    }

    public void searchAccounts() {
        if (searchKey.trim().length() < 3) {
            message = 'Input at least 3 characters';
        } else {
            lstAccounts = [
                SELECT 
                    Id, Name, Phone, Website, Email__c
                FROM 
                    Account
                WHERE 
                    Name 
                LIKE 
                    :('%' + searchKey + '%')
                LIMIT 
                    1000
            ];
            message = 'Accounts found: ' + lstAccounts.size();
        }
    }

    public void clearSearch() {
        searchKey = '';
        allRecord(); 
    }

    public void searchBychar() {
        if (!String.isBlank(searchBychar)) {
            lstAccounts = [
                            SELECT 
                                Id, Name, Phone, Website, Email__c
                            FROM 
                                Account
                            WHERE 
                                Name LIKE : (searchBychar + '%')
                            LIMIT 
                                1000
                        ];
            message = 'Accounts starting with "' + searchBychar + '": ' + lstAccounts.size();
        }
    }
   
}
