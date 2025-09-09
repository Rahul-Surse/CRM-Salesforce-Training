public with sharing class DuplicateContactOpp implements Database.Batchable<SObject>, Database.Stateful{

    Map<Id, Integer> ownerDuplicateCount = new Map<Id, Integer>();
    Map<String, Integer> nameCountMap = new Map<String, Integer>();
    List<Contact> lstUpdateCon = new List<Contact>();
    public Database.QueryLocator start(Database.BatchableContext bc) {
        SYstem.debug('In start method');
        return Database.getQueryLocator([
                                            SELECT 
                                                Id, Name, AccountId, Account.Name, OwnerId
                                            FROM 
                                                Contact
                                            WHERE 
                                                AccountId != null
                                            LIMIT
                                                50000

        ]);
    }

    public void execute(Database.BatchableContext bc, List<Contact> scope) {
       
        System.debug('in execute method');
        for(Contact c : scope) {
            if(nameCountMap.containsKey(c.Name))
            {
                Contact con = new Contact();
                con.Id = c.Id;
                con.Duplicate_Contact__c = true;
                lstUpdateCon.add(con);
                nameCountMap.put(c.Name,nameCountMap.get(c.Name) + 1 );
                if(ownerDuplicateCount.containsKey(c.OwnerId))
                {
                    ownerDuplicateCount.put(c.OwnerId,nameCountMap.get(c.OwnerId)+1);
                }
                else {
                    ownerDuplicateCount.put(c.OwnerId, 0);
                }
            }
            else {
                nameCountMap.put(c.Name,1);
            }
            
        }

        if(!lstUpdateCon.isEmpty())
        {
            update lstUpdateCon;
        }

    }
     public void finish(Database.BatchableContext bc) {
            EmailHandler.duplicateContactEmailNotify('contact',ownerDuplicateCount);
    }
}

