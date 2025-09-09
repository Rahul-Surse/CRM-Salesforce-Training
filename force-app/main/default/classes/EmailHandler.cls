public with sharing class EmailHandler {




    public static  void duplicateContactEmailNotify(String objectLabel,Map<Id, Integer> ownerDuplicateCount)
    {
         List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        for (Id ownerId : ownerDuplicateCount.keySet()) {
            Integer count = ownerDuplicateCount.get(ownerId);
            User u = [SELECT Email FROM User WHERE Id = :ownerId LIMIT 1];

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new List<String>{u.Email});
            mail.setSubject('Duplicate ' + objectLabel + 's Found');
            mail.setPlainTextBody('Hi, we found ' + count + ' duplicate ' + objectLabel + ' records under your ownership.');
            emails.add(mail);
        }
        if (!emails.isEmpty()) {
            Messaging.sendEmail(emails);
        }
    }
    }
