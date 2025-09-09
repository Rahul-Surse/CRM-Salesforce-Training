public with sharing class DuplicateContactAndOpportunity implements Database.Batchable<SObject>, Database.Stateful {

        public Database.QueryLocator start(Database.BatchableContext bc) {
        SYstem.debug('In start method');
        return Database.getQueryLocator([
                                            SELECT 
                                                Id, Name,
                                                (SELECT 
                                                    Id, Name, Email
                                                FROM 
                                                    Contacts),
                                                (SELECT 
                                                    Id, Name, StageName, Amount 
                                                FROM    
                                                    Opportunities)
                                            FROM Account

        ]);
    }
    public void execute(Database.BatchableContext bc, List<Account> scope) {


       

























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
    
}