@isTest
public class SecurityTest {
   public static testMethod void testRunAs() {
       EMPLOYEE__c emp = new EMPLOYEE__c(
       	Name ='somesome',
           First_Name__c= 'Seum',
           Last_Name__c ='Srum',
           Date_of_Birth__c = Date.valueOf(System.now().addYears(-22))  ,
           Date_of_Joining__c = Date.valueOf(System.now()),
           Zip__c = '422002',
           Resignation_Date__c = Date.valueOf(System.now().addMonths(4))
       );
       User u = new User(Id = '005dL00000zlZSNQA2');
        System.runAs(u) {
            insert emp;
            System.debug(emp);
          }
    }
}