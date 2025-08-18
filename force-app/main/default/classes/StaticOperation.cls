public with sharing class StaticOperation {
    
   
        public static Integer a = 100;
       
        public void check() {
            a++;
            System.debug(a);
        }
    

    public static void mainMethod() {
        System.debug('The static variable in class is ' + StaticOperation.a);
        
        StaticOperation o = new StaticOperation();
        o.check();
        o.check();
    }
}
// StaticOperation.a