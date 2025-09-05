public with sharing class RelationShipQueries 
{
    public static void getActiveContactsInMediaIndustry() // Q1
    {
        List<Contact> lstcontacts = [
                                        SELECT 
                                            Id, Name, Account.Name
                                        FROM 
                                            Contact
                                        WHERE 
                                            Account.Industry = 'Media'
                                        AND 
                                            Account.Active__c = 'Yes'
                                        LIMIT
                                            50000
                                    ];

        for (Contact con : lstcontacts) {
            System.debug('Contact Name: ' + con.Name + 
                         ' Account Name: ' + con.Account.Name);
        }
    }
    
/***********************************************************************************************************/    
    public static void getJohnRelatedRecord() {
    List<C__c> listC = [
                        SELECT 
                            Name, 
                            Related_to_A__r.Id, 
                            Related_to_A__r.Name, 
                            Related_to_B__r.Id, 
                            Related_to_B__r.Name
                        FROM 
                            C__c
                        WHERE 
                            Name = 'John'
                        LIMIT
                            50000
    ];

    for (C__c data : listC) {
        System.debug('Child Name: ' + data.Name);
        System.debug('Parent A: ' + data.Related_to_A__r.Name);
        System.debug('Parent B: ' + data.Related_to_B__r.Name);
    }
}



/***********************************************************************************************************/
     public static void getAccountsWithContactsNamedJohn()  //Q3
     {
       
        List<Account> accounts = [
                                    SELECT 
                                        Id, 
                                        Name, 
                                    (SELECT 
                                        Id, 
                                        FirstName, 
                                        LastName, 
                                        Email 
                                    FROM 
                                        Contacts 
                                    WHERE 
                                        Name LIKE '%John%' )
                                    FROM 
                                        Account
                                    LIMIT
                                        50000
                                    ];

       
        for (Account acc : accounts) {
            List<Contact> johnContacts = acc.Contacts;
                System.debug('Account Name: ' + acc.Name);
                for (Contact con : johnContacts) {
                    System.debug(con);
                }
          
        }
    }

/***********************************************************************************************************/
    public static void getAccountsWithClosedWonOpportunities()  //Q4
    {
       
        List<Account> lstAccounts = [
                                        SELECT
                                            Id, Name,
                                        (SELECT 
                                                Id, Name, StageName, Amount 
                                        FROM 
                                            Opportunities 
                                        WHERE 
                                            StageName = 'Closed Won')
                                        FROM 
                                            Account
                                        WHERE 
                                            Id IN (
                                                    SELECT AccountId 
                                                    FROM Opportunity 
                                                    WHERE StageName = 'Closed Won'
                                        )
                                        LIMIT
                                             50000
                                        
                                    ];

        
        for (Account acc : lstAccounts) {
            List<Opportunity> closedWonOpps = acc.Opportunities;
                System.debug('Account Name: ' + acc.Name);
                for (Opportunity opp : closedWonOpps) {
                    System.debug(opp);
              
            }
        }
    }

/***********************************************************************************************************/

    public static void getParentsWithJohnChildren() {
        List<A__c> parentRecords = [
                                        SELECT 
                                            Id, Name,
                                                (SELECT 
                                                    Id, Name 
                                                FROM 
                                                    cs__r 
                                                )
                                        FROM 
                                            A__c
                                        WHERE 
                                            Id IN (
                                                SELECT 
                                                    Related_to_A__c 
                                                FROM 
                                                    C__c
                                                WHERE 
                                                    Name = 'John'  
                                            )
                                        LIMIT 
                                            50000
                                    ];

        for (A__c parent : parentRecords) {
            System.debug('Parent '+parent.name);
                for (C__c child : parent.cs__r) {
                System.debug('Child  '+child.name);
            }
        }
    }
}
