public with sharing class SetIntersection {
    
    public static Set<Integer> intersection(Set<Integer> s1, Set<Integer> s2) {
        Set<Integer> result = new Set<Integer>();
        // result =s1.retainAll(s2); retainAll having a boolean type to retain
        // System.debug('Hiii');
        
        // for (Integer i : s1) {
        //     if (s2.contains(i)) {
        //         result.add(i);
        //     }
        // }

        s1.retainAll(s2);

        System.debug(s1);
        
        return result;
    }

    public static void main() {
        Set<Integer> s1 = new Set<Integer>{1, 2, 3, 4, 5};
        Set<Integer> s2 = new Set<Integer>{4, 5, 6, 7, 8};
        Set<Integer> result = intersection(s1, s2);
        System.debug('Result is: ' + result); 
    }


}
