public with sharing class SoslOperation {
     public static void findTestInNameFields() {
        
        List<List<SObject>> lstAccConLeadUser = [
                FIND
                    'test*' 
                IN NAME FIELDS
                RETURNING 
                        Account(Id, Name), 
                        Contact(Id, FirstName, LastName), 
                        Lead(Id, FirstName, LastName), 
                        User(Id, FirstName, LastName)

                LIMIT 
                        2000
                ];

       
        for (List<SObject> res : lstAccConLeadUser) {
                for (SObject obj : res) {
                        if (obj instanceof Account) {
                                Account acc = (Account)obj;
                                System.debug('Account => Id: ' + acc.Id + ', Name: ' + acc.Name);
                        } else if (obj instanceof Contact) {
                                Contact con = (Contact)obj;
                                System.debug('Contact => Id: ' + con.Id + ', Name: ' + con.FirstName + ' ' + con.LastName);
                         } else if (obj instanceof Lead) {
                                Lead lead = (Lead)obj;
                                System.debug('Lead => Id: ' + lead.Id + ', Name: ' + lead.FirstName + ' ' + lead.LastName);
                         } else if (obj instanceof User) {
                                  User user = (User)obj;
                                  System.debug('User => Id: ' + user.Id + ', Name: ' + user.FirstName + ' ' + user.LastName);
                        }
                }
        }
 
}
}