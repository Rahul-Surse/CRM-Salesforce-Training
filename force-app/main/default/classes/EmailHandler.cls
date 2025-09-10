public with sharing class EmailHandler {

// Map<String,DupliacteAccountOppWrapper> mapIdvsDupAccOppWrapper
    public static  void duplicateContactEmailNotify()
    {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        System.debug('-----------In mail handler---------------');
        for (String ownerId : mapIdvsDupAccOppWrapper.keySet()) {
            DupliacteAccountOppWrapper dupAccOppWrapper = mapIdvsDupAccOppWrapper.get(ownerId);
            Integer dupConCount = dupAccOppWrapper.dupCon;
            Integer dupOppCount = dupAccOppWrapper.dupOpp;
            User u = [SELECT Email FROM User WHERE Id = :ownerId LIMIT 1];
            List<String> email=new List<String>();
            email.add(u.Email);
            // String email=u.Email;
            // String[] mails = new String[] {email}
            System.debug('Email is'+ email);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(email);
            mail.setSubject('Duplicate contact and oportunity Found');
            mail.setPlainTextBody('Hi, we found ' + dupConCount + ' duplicate Contact  And '+ dupOppCount +' Opportnity  records under your ownership.');
            System.debug('Hi, we found ' + dupConCount + ' duplicate Contact  And '+ dupOppCount +' Opportnity  records under your ownership.');
            emails.add(mail);
        }
        if (!emails.isEmpty()) {
            System.debug('-----------Sending handler---------------');
            System.debug(emails);
            Messaging.sendEmail(emails);
        }


      
    }
}
