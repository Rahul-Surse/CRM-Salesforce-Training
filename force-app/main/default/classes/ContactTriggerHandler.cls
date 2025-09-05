/***************************************************************************************************
* @Author:            CRM Developer
* @TestclassName:     ContactTriggerHandlerTest
* @Description:       This is a handler class of contactTrigger. 
***************************************************************************************************/
public with sharing class ContactTriggerHandler { 
    
/***************************************************************************************************
* @Author:        CRM Developer
* @Description:   This method checks for duplicate Contacts based on Email or Phone before inserting
                  or updating records.
* @Param1:        lstContacts:- The list of Contact records from Trigger.new.
***************************************************************************************************/
    // public static void checkDuplicates(List<Contact> lstContacts) {
    //     Set<String> setEmails = new Set<String>();
    //     Set<String> setPhones = new Set<String>();
        
    //     for(Contact c : lstContacts) {
    //         if(c.Email != null) setEmails.add(c.Email.toLowerCase());
    //         if(c.Phone != null) setPhones.add(c.Phone);
    //     }
    //     List<Contact> lstDbContacts = [
    //                                     SELECT 
    //                                         Id, Email, Phone 
    //                                     FROM 
    //                                         Contact 
    //                                     WHERE 
    //                                         Email IN :setEmails 
    //                                     OR 
    //                                         Phone IN :setPhones
    //                                     LIMIT 
    //                                         50000
    //                                   ];
    //     Map<String, Id> emailMap = new Map<String, Id>();
    //     Map<String, Id> phoneMap = new Map<String, Id>();
    //     for(Contact c : lstDbContacts) {    
    //         if(c.Email != null) emailMap.put(c.Email.toLowerCase(), c.Id);
    //         if(c.Phone != null) phoneMap.put(c.Phone, c.Id);
    //     }
    //     for(Contact c : lstContacts) {
    //         if(c.Email != null && emailMap.containsKey(c.Email.toLowerCase())) {
    //             c.addError('A Contact with the same email address already exists in the system.');
    //         }
    //         else if(c.Phone != null && phoneMap.containsKey(c.Phone)) {
    //             c.addError('A Contact with the same phone number already exists in the system.');
    //         }
    //     }
    // }
/***************************************************************************************************
* @Author:        CRM Developer
* @Description:   This method assign the account to each contact according to the email domain and
                  website of contact
* @Param1:        lstContacts:- The list of Contact records from Trigger.new.
***************************************************************************************************/
    public static void associateContactsToAccount(List<Contact> lstContacts)
    {
        Map<String, Id> domainToAccount = new Map<String, Id>();

        for (Account acc : [
                                SELECT 
                                    Website
                                FROM 
                                    Account
                                WHERE 
                                    Website != null
                                LIMIT
                                    50000
                            ]){
            if (String.isNotBlank(acc.Website)) {
                String website = acc.Website.toLowerCase();
                website = website.replaceFirst('^(https?://|ftp://)?(www\\.)?', '');
                website = website.replaceFirst('/.*$', ''); 
                domainToAccount.put(website, acc.Id);
            }
        }

        for (Contact con : lstContacts) {
            if (String.isNotBlank(con.Email) && con.Email.contains('@')) {
                String domain = con.Email.substringAfter('@').toLowerCase();
                if (domainToAccount.containsKey(domain)) {
                    con.AccountId = domainToAccount.get(domain);
                }
            }
        }
    }
}


