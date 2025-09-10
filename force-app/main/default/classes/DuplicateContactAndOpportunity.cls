public with sharing class DuplicateContactAndOpportunity implements Database.Batchable<SObject>, Database.Stateful {

    Map<String,DupliacteAccountOppWrapper> mapIdvsDupAccOppWrapper = new map<String,DupliacteAccountOppWrapper>();
    public Database.QueryLocator start(Database.BatchableContext bc) {
    SYstem.debug('-----------In start method---------------');
    return Database.getQueryLocator([
                                        SELECT 
                                            Id, Name,OwnerId,
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
        System.debug('-----------In Execute method---------------');
        Map<String,Integer> mapDupCon = new Map<String,Integer>();
        Map<String,Integer> mapDupopp = new Map<String,Integer>();
        for(Account acc : scope)
        {
            String id = acc.OwnerId;
            System.debug(id);
            Integer dupCon=0;
            Integer dupOpp=0;
            List<Contact> lstcontacts = acc.Contacts;
            for(Contact con : lstcontacts){
                if(mapDupCon.containsKey(con.Name))
                {
                    mapDupCon.put(con.Name,mapDupCon.get(con.Name)+1);
                    dupCon++;
                }
                else {
                    mapDupCon.put(con.Name, 0);
                }
            }
            List<Opportunity> lstOpportunities = acc.Opportunities;
            for(Opportunity opp : lstOpportunities){
                if(mapDupopp.containsKey(opp.Name)){
                    mapDupopp.put(opp.Name,mapDupopp.get(opp.Name)+1);
                    dupOpp++;
                }
                else {
                    mapDupopp.put(opp.Name, 0);
                }
            }
            DupliacteAccountOppWrapper dupAccOppWrapper = new DupliacteAccountOppWrapper(id,dupCon,dupOpp);
            if(mapIdvsDupAccOppWrapper.containsKey(id)){
                DupliacteAccountOppWrapper dupAccOppWrapper1= mapIdvsDupAccOppWrapper.get(id);
                Integer totalCon = dupAccOppWrapper1.dupCon+ dupCon;
                Integer totalOpp = dupAccOppWrapper1.dupOpp + dupOpp;
                mapIdvsDupAccOppWrapper.put(id, new DupliacteAccountOppWrapper(id,totalCon,totalOpp));
            }
            else {
                mapIdvsDupAccOppWrapper.put(id, dupAccOppWrapper);
            }
        }
    }
    public void finish(Database.BatchableContext bc){
             System.debug('-----------In finish method---------------');
        
        for (String ownerId : mapIdvsDupAccOppWrapper.keySet()) {
            DupliacteAccountOppWrapper dupAccOppWrapper = mapIdvsDupAccOppWrapper.get(ownerId);
            Integer dupConCount = dupAccOppWrapper.dupCon;
            Integer dupOppCount = dupAccOppWrapper.dupOpp;
            User u = [SELECT Email FROM User WHERE Id = :ownerId LIMIT 1];
            String address = u.Email;
            String subject = 'Duplicate contact and oportunity Found';
            String body ='Hi, we found ' + dupConCount + ' duplicate Contact  And '+ dupOppCount +' Opportnity  records under your ownership.';
             Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {address};
            mail.setToAddresses(toAddresses);
            mail.setSubject(subject);
            mail.setPlainTextBody(body);
            // List<String> email=new List<String>();
            // email.add(u.Email);
            // String email=u.Email;
            // String[] mails = new String[] {email}
            // System.debug('Email is'+ email);
            // Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            //  Messaging.SendEmailResult[] results = Messaging.sendEmail(
            //                      new Messaging.SingleEmailMessage[] { mail });
            // mail.setToAddresses(email);
            // mail.setSubject('Duplicate contact and oportunity Found');
            // mail.setPlainTextBody('Hi, we found ' + dupConCount + ' duplicate Contact  And '+ dupOppCount +' Opportnity  records under your ownership.');
            // System.debug('Hi, we found ' + dupConCount + ' duplicate Contact  And '+ dupOppCount +' Opportnity  records under your ownership.');
            // emails.add(mail);
        }
        if (!emails.isEmpty()) {
            System.debug('-----------Sending handler---------------');
            System.debug(emails);
            Messaging.sendEmail(emails);
        }



        // String address = 'xodepic781@inupup.com';
        // String subject = 'Hiiiiii';
        // String body ='Hello';
        // Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        // String[] toAddresses = new String[] {address};
        // mail.setToAddresses(toAddresses);
        // mail.setSubject(subject);
        // mail.setPlainTextBody(body);
        //  Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        // String[] toAddresses = new String[] {address};
        // mail.setToAddresses(toAddresses);
        // mail.setSubject(subject);
        // mail.setPlainTextBody(body);
        // // Pass this email message to the built-in sendEmail method 
        // // of the Messaging class
        // Messaging.SendEmailResult[] results = Messaging.sendEmail(
        //                          new Messaging.SingleEmailMessage[] { mail });


        // EmailHandler.duplicateContactEmailNotify(mapIdvsDupAccOppWrapper);
    }
    
}