public with sharing class SoqlQueries { 

    public Static void getAllActiveUsers() 
    {
        List<User> lstActiveUsers = [
                                        SELECT 
                                            Id, Name, Email, 
                                            IsActive 
                                        FROM 
                                            User 
                                        WHERE 
                                            IsActive = TRUE
                                        WITH 
                                            SECURITY_ENFORCED
                                        LIMIT
                                            50000
                                    ];
        Map <Id,User> mapUserUdvsUserObject=new Map<Id,User>(lstActiveUsers);

        
        for(String userId :mapUserUdvsUserObject.keySet())
        {
            User u=mapUserUdvsUserObject.get(userId);
            System.debug(u);
        }
    }
    
/****************************************************************************************************/
    public Static void enrollmentYear()    
    {
        List<Account> lstAccounts1=[
                                        SELECT
                                            Id, Name, Enrollment_Year__c 
                                        FROM 
                                            Account
                                        WHERE 
                                            Enrollment_Year__c  INCLUDES ('2013')
                                        AND 
                                            Enrollment_Year__c INCLUDES ('2014')
                                        WITH 
                                            SECURITY_ENFORCED
                                        LIMIT
                                            50000
                                    ];  
            
        for(Account account1:lstAccounts1)
        {
            System.debug('account1 '+account1);
        }

        List<Account> lstAccounts2=[
                                    SELECT 
                                        Id, Name, Enrollment_Year__c 
                                    FROM 
                                        Account
                                    WHERE 
                                        Enrollment_Year__c INCLUDES ('2010')
                                    WITH 
                                        SECURITY_ENFORCED
                                    LIMIT
                                            50000
                                    ];  
            
        for(Account account2:lstAccounts2)
        {
            System.debug('account2'+account2);
        }
    }


    /************************************************************************************************/

    public static void getFilteredAccounts()   
    {
        List<Account> lstAccounts =[
                                        SELECT 
                                             Id, Name, BillingState
                                        FROM 
                                            Account
                                        WHERE 
                                            BillingState 
                                        NOT IN ('Maharashtra', 'Kerala')
                                        ORDER BY 
                                            BillingState 
                                        DESC NULLS LAST
                                        LIMIT 
                                            10000

                                     ];

       for(Account account2:lstAccounts)
        {
            System.debug(account2);
        }


    }


/************************************************************************************************/
    public static void getFilteredOpportunities() 
    {
        List<Opportunity> lstOpportunities =[
                                                SELECT 
                                                    Id, Name, Amount, CreatedDate
                                                FROM 
                                                    Opportunity
                                                ORDER BY 
                                                    CreatedDate
                                                LIMIT 
                                                    100
                                                OFFSET 
                                                    50  
                                                                     
                                                ];

    for (Opportunity opp : lstOpportunities) {
        System.debug(opp);
    }
}

}