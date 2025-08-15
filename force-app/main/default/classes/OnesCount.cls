public with sharing class OnesCount {
   
    static  Integer  countOfOnes(List<Integer> arr)
    {

        
        Integer count = 0;
        Integer max =0;
        for(Integer i=0; i<arr.size(); i++)
        {
             
            if(arr[i] == 1){
                count++;
            }
            else {
                
                if(count > max)
                {
                    max=count;
                }
                count=0;
            }
        }
        if(count > max)
                {
                    max=count;
                }
        return max;
    }

    public  static void main() {
        List<Integer> arr = new List<Integer>{1,0,1,1,0,1,1,1,1,1};

        Integer res=OnesCount.countOfOnes(arr);
        System.debug(res);
    }
}