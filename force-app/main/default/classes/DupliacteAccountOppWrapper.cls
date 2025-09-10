public with sharing class DupliacteAccountOppWrapper {
        @AuraEnabled  public String ownerId {get; set;}
        @AuraEnabled public Integer dupCon {get; set;}
        @AuraEnabled public Integer dupOpp {get; set;}

        public DupliacteAccountOppWrapper(String ownerId,Integer dupCon,Integer dupOpp)
        {
                this.ownerId = ownerId;
                this.dupCon = dupCon;
                this.dupOpp = dupOpp;
        }

}