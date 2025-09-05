public with sharing class WrapperDemo {

    public class AccountWrapper{
        public String accId;
        public String industry;
        public String Name;
    }

    public static void main(){
        AccountWrapper accWrap = new AccountWrapper();
        accWrap.accId = 'accId';
        accWrap.industry = 'Media';
        accWrap.Name = 'CTI';
        System.debug(accWrap);
    }
}
    
// WrapperDemo.main();