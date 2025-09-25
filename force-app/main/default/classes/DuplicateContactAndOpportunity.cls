
/***************************************************************************************************
* @Author:        CRM Developer
* @TesClassName:  DuplicateContactAndOpportunity
* @Description:   This class is Responsible for the counting duplicate contact and opportunity record's associated to a account.
***************************************************************************************************/
public class DuplicateContactAndOpportunity implements Database.Batchable<SObject>, Database.Stateful {

    Map<String,DupliacteAccountOppWrapper> mapIdvsDupAccOppWrapper = new map<String,DupliacteAccountOppWrapper>();
    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This is start method of batch Apex. 
    * @Param1:        bc:- it is a reference of Database.BatchableContext.
    ***************************************************************************************************/
    public Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('Start method');
        return Database.getQueryLocator([
                                            SELECT 
                                                Id, Name, OwnerId, Owner.Name,
                                                (
                                                    SELECT 
                                                        Id, Name, Email,CreatedDate
                                                    FROM 
                                                        Contacts
                                                    ORDER BY
                                                        CreatedDate
                                                    Asc
                                                    LIMIT  
                                                        50000
                                                ),
                                                (
                                                    SELECT 
                                                        Id, Name, StageName, Amount 
                                                    FROM    
                                                        Opportunities
                                                    ORDER BY
                                                        CreatedDate
                                                    Asc
                                                    LIMIT
                                                        50000
                                                )
                                            FROM 
                                                Account
                                            // WHERE 
                                            //     Name like 'CTI - Review%' 
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
        System.debug('execute method');
        List<Contact> lstUpdateContacts = new List<Contact>();
        List<Opportunity> lstUpdateOpportunites = new List<Opportunity>();
       
        for(Account acc : scope){
            
            Map<String,Integer> mapDupCon = new Map<String,Integer>();
            Map<String,Integer> mapDupopp = new Map<String,Integer>();
            String accOwnerId = acc.OwnerId;
            Boolean isDuplicate = false;
            Integer dupCon=0;
            Integer dupOpp=0;
            System.debug('Initialization');
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
            System.debug('contacts done');
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
            System.debug('opportunities done');
            if(isDuplicate){
                if(mapIdvsDupAccOppWrapper.containsKey(accOwnerId)){
                    DupliacteAccountOppWrapper dupAccOppWrapper1 = mapIdvsDupAccOppWrapper.get(accOwnerId);
                    dupAccOppWrapper1.dupCon = dupAccOppWrapper1.dupCon + dupCon;
                    dupAccOppWrapper1.dupOpp = dupAccOppWrapper1.dupOpp + dupOpp;
                }else {
                    DupliacteAccountOppWrapper dupAccOppWrapper = new DupliacteAccountOppWrapper(accOwnerId,dupCon,dupOpp);
                    mapIdvsDupAccOppWrapper.put(accOwnerId, dupAccOppWrapper);
                }
            }  
        }
        System.debug('duplicate calculation end');
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
        System.debug('finish method');
        List<Messaging.SingleEmailMessage> mails =new List<Messaging.SingleEmailMessage>();
        Map <Id, User> mapIdvsUser = new Map<Id, User>([
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
        Messaging.SendEmailResult[] results = Messaging.sendEmail(mails);
        system.debug('total can Called :'+Limits.getLimitEmailInvocations());
        system.debug('total Called :'+Limits.getEmailInvocations());

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