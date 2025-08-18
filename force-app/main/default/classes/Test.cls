public with sharing class Test {
    public String hello() {

       
         System.debug('Inside the test.hello');
          return 'Test complete' ;

    }
    public static void main(){

        Test t=new Test();
        System.debug('main method1');
    }

}