public with sharing class BasicProgramming {
    public BasicProgramming() {

    }
//-------------------------------------------------------------------------------------------------
    public static void checkPrime(Integer n)
    {
        
        Boolean flag = true;
        if(n <= 1) {
            System.debug(n + ' is not a prime number.');
            flag=false;
        }

        for(Integer i = 2; i < n; i++) {
            if(Math.mod(n, i)==0)
            {
                flag = false;
                break;
            }
        }

        if(flag) {
            System.debug(n + ' is a prime number.');
        } else {
            System.debug(n + ' is not a prime number.');
        }
    }





//--------------------------------------------------------------------------------------------------

    public static void checkPalindrome(String str) {

    str = str.toLowerCase();
    Integer j = str.length() - 1;
    Boolean flag = false;
    for (Integer i = 0; i < str.length() / 2; i++) {
        if (str.charAt(i) != str.charAt(j)) {
       
            flag=true;
            break;
        } 
        j--;
    }

    if (flag) {
         System.debug(str + ' is not a palindrome');
    }
    else {
         System.debug(str + ' is  a palindrome');
    }
}
//----------------------------------------------------------------------------------------------------
public static void replaceCharacter(List<String> arr, String ch) {

   
   for (Integer i = 0; i < arr.size(); i++) {
        String str = arr[i];
        str = str.replace(ch, 'b');
        arr[i] = str; 
    }

    System.debug(arr);
}
//--------------------------------------------------------------------------------------------------
public static void countStringLength(String str) 
{
    Integer count=0;
    for(Character c:str.toCharArray())
    {
        count++;
    }
    System.debug('the length of string is'+count);
}

//---------------------------------------------------------------------------------------------------

public static void findUniqueNumbers(List<Integer> numbers) {

    Set<Integer> uniqueSet = new Set<Integer>();
    for (Integer num : numbers) {
        uniqueSet.add(num);
    }
    System.debug('rahul\'s unique set'+uniqueSet);
}

}
