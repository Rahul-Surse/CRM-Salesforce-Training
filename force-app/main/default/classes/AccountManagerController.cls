public with sharing class AccountManagerController {
    public List<Account> lstAccounts { get; set; }
    public String message { get; set; }
    public String searchKey { get; set; }
     public String selectedLetter { get; set; }

   public List<String> getAlphabetList() {
        return new List<String>{
            'A','B','C','D','E','F','G','H','I','J','K','L','M',
            'N','O','P','Q','R','S','T','U','V','W','X','Y','Z','ALL'
        };
    }


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
        if(selectedLetter=='ALL')
        {
            allRecord();
        }
        else if (selectedLetter != null && selectedLetter != '') {
            lstAccounts = [
                            SELECT 
                                Id, Name, Phone, Website, Email__c
                            FROM 
                                Account 
                            WHERE 
                                Name LIKE :selectedLetter + '%'
                            ORDER BY 
                                Name
                        ];
            } else {
                lstAccounts = new List<Account>();
            }
    }

    @RemoteAction
    public static String deleteAccount(Id accountId) {
        try {
            delete [SELECT Id FROM Account WHERE Id = :accountId];
            return 'success';
        } catch (Exception e) {
            return e.getMessage();
        }
}

  
}
