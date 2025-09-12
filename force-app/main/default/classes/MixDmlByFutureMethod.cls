/***************************************************************************************************
* @Author:        CRM Developer
* @className:     MixDmlByFutureMethod
* @Description:   This class is created for to avoid Mix Dml Error.
***************************************************************************************************/
public with sharing class MixDmlByFutureMethod {
    public static void mixDmlOperation(){
        Account acc = new Account(Name = 'sam');
        insert acc;   
        createUser();
    }

    /***************************************************************************************************
    * @Author:        CRM Developer
    * @Description:   This is future annoted method which create a user. 
    * @Param1:        NA
    ***************************************************************************************************/
    @future
    public static void createUser(){
        String proId='';
        List<Profile> lstProfiles = [
                                        SELECT 
                                            Id 
                                        FROM 
                                            Profile 
                                        WHERE 
                                            Name = 'Standard User' 
                                        LIMIT 
                                            1
                                    ];
        if(!lstProfiles.isEmpty())
        {
            proId = lstProfiles[0].Id;
            if(!String.isBlank(proId)){
                User newUser = new User(
                                            LastName = 'User',
                                            Alias = 'tusr',
                                            Email = 'testuser' + System.currentTimeMillis() + '@example.com',
                                            Username = 'testuser' + System.currentTimeMillis() + '@example.com',
                                            ProfileId = proId,
                                            TimeZoneSidKey = 'Asia/Kolkata',
                                            LocaleSidKey = 'en_IN',
                                            EmailEncodingKey = 'UTF-8',
                                            LanguageLocaleKey = 'en_US'
                                        );
                insert newUser;
            }  
        }                      
    }
}