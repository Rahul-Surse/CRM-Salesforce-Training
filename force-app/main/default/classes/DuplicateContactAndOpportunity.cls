
/***************************************************************************************************
* @Author:        CRM Developer
* @className:     DuplicateContactAndOpportunity
* @Description:   This class is Responsible for the counting duplicate contact and opportunity of associated to account.
***************************************************************************************************/
public class DuplicateContactAndOpportunity implements Database.Batchable<SObject>, Database.Stateful {

    Map<String,DupliacteAccountOppWrapper> mapIdvsDupAccOppWrapper = new map<String,DupliacteAccountOppWrapper>();
    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This is start method of batch Apex. 
    * @Param1:        bc:- it is a reference of Database.BatchableContext.
    ***************************************************************************************************/
    public Database.QueryLocator start(Database.BatchableContext bc) {
    return Database.getQueryLocator([
                                        SELECT 
                                            Id, Name,OwnerId,Owner.Name,
                                                (SELECT 
                                                    Id, Name, Email
                                                FROM 
                                                    Contacts
                                                LIMIT  
                                                    50000
                                                ),
                                                (SELECT 
                                                    Id, Name, StageName, Amount 
                                                FROM    
                                                    Opportunities
                                               
                                                LIMIT
                                                    50000
                                                )
                                        FROM 
                                            Account
                                        WHERE 
                                            LastModifiedDate  = TODAY 
                                        LIMIT
                                            50000
                                    ]);
    }
    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This is excute method of batch Apex. 
    * @Param1:        bc:- it is a reference of Database.BatchableContext.
    ***************************************************************************************************/
    public void execute(Database.BatchableContext bc, List<Account> scope) {
        
        List<Contact> lstUpdateContacts = new List<Contact>();
        List<Opportunity> lstUpdateOpportunites = new List<Opportunity>();
       
        for(Account acc : scope){
            
            Map<String,Integer> mapDupCon = new Map<String,Integer>();
            Map<String,Integer> mapDupopp = new Map<String,Integer>();
            String id = acc.OwnerId;
            Boolean isDuplicate = false;
            Integer dupCon=0;
            Integer dupOpp=0;
            
            List<Contact> lstcontacts = acc.Contacts;
            for(Contact con : lstcontacts){
                if(mapDupCon.containsKey(con.Name)){
                    lstUpdateContacts.add(new Contact(Id = con.Id,Duplicate_Contact__c = true));
                    mapDupCon.put(con.Name,mapDupCon.get(con.Name)+1);
                    dupCon=dupCon + 1;
                    isDuplicate = true;
                }
                else {
                    mapDupCon.put(con.Name, 1);
                }
            }
            List<Opportunity> lstOpportunities = acc.Opportunities;
            for(Opportunity opp : lstOpportunities){
                if(mapDupopp.containsKey(opp.Name)){
                    lstUpdateOpportunites.add(new Opportunity(Id = opp.Id,Duplicate_Opp__c = true,Description = 'desc'));
                    mapDupopp.put(opp.Name,mapDupopp.get(opp.Name)+1);
                    dupOpp=dupOpp + 1;
                    isDuplicate = true;
                }
                else {
                    mapDupopp.put(opp.Name, 1);
                }
            }
            if(isDuplicate)
            {
                if(mapIdvsDupAccOppWrapper.containsKey(id)){
                    DupliacteAccountOppWrapper dupAccOppWrapper1 = mapIdvsDupAccOppWrapper.get(id);
                    dupAccOppWrapper1.dupCon = dupAccOppWrapper1.dupCon + dupCon;
                    dupAccOppWrapper1.dupOpp = dupAccOppWrapper1.dupOpp + dupOpp;
                }
                else {
                    DupliacteAccountOppWrapper dupAccOppWrapper = new DupliacteAccountOppWrapper(id,dupCon,dupOpp);
                    mapIdvsDupAccOppWrapper.put(id, dupAccOppWrapper);
                }
            }  
        }
        if(!lstUpdateContacts.isEmpty())
        {
            update lstUpdateContacts;
        }
        if(!lstUpdateOpportunites.isEmpty())
        {
            update lstUpdateOpportunites;
        }

    }
    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This is finish method of batch Apex. 
    * @Param1:        bc:- it is a reference of Database.BatchableContext.
    ***************************************************************************************************/
    public void finish(Database.BatchableContext bc){
        List<Messaging.SingleEmailMessage> mails =new List<Messaging.SingleEmailMessage>();
        Map <Id,User> mapIdvsUser = new Map<Id,User>([
                                                        SELECT
                                                            email
                                                        FROM
                                                            user
                                                        LIMIT
                                                            50000
                                                     ]);
        for (String ownerId : mapIdvsDupAccOppWrapper.keySet()) {
                DupliacteAccountOppWrapper dupAccOppWrapper = mapIdvsDupAccOppWrapper.get(ownerId);
                Integer dupConCount = dupAccOppWrapper.dupCon;
                Integer dupOppCount = dupAccOppWrapper.dupOpp;
                User u = mapIdvsUser.get(ownerId);
                String ownerEmail = u.Email;
                String subject = 'Duplicate contact and opportunity Found';
                String body = 'Hi, we found ' + dupConCount + ' duplicate Contact and ' + dupOppCount + ' Opportunity records under your ownership.';
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new String[] {ownerEmail});
                mail.setSubject(subject);
                mail.setPlainTextBody(body);
                mails.add(mail);
                System.debug('mail'+mail);
            
        }
        // Messaging.SendEmailResult[] results = Messaging.sendEmail(
        //     new Messaging.SingleEmailMessage[] mails);
    }
}


// 1 Account
//     opp:
//     1 opp 
//     1 opp
//     con
//     1 con
//     1 con
//     con: 1 opp: 1

// 2 Account
//     opp:
//     1 opp1 
//     1 opp
//     con
//     1 con2
//     1 con

//     opp: 0
//     con: 0

// Mail : con 1 opp 1