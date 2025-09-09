public with sharing class MixDmlByFutureMethod {

    public static void mixDmlOperation()
    {
        Account acc = new Account(Name = 'sam');
        insert acc;

        
    }

    @future
    public static void createUser()
    {
        User newUser = new User(
            LastName = 'User',
            Alias = 'tusr',
            Email = 'testuser' + System.currentTimeMillis() + '@example.com',
            Username = 'testuser' + System.currentTimeMillis() + '@example.com',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert newUser;
    }

}