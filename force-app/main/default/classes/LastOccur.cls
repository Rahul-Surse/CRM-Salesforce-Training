public with sharing class LastOccur {

    public static Integer LastOccurOpertion(List<Integer> arr, Integer target) {
        Integer ind = -1; 
        for (Integer i = 0; i < arr.size(); i++) {
            if (arr[i] == target) {
                ind = i;
            }
        }
        return ind;
    }

    public static void main() {
        List<Integer> list1 = new List<Integer>{1, 2, 3, 4, 5, 6, 2};
        Integer target = 2;

        Integer result =LastOccur.LastOccurOpertion(list1, target);
        System.debug('Last occurrence index of ' + target + ' is' + result);
    }
}