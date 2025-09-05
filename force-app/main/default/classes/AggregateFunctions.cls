public with sharing class AggregateFunctions {

    public static void getSumOfClossedOpportunityAmount(){
        AggregateResult[] lstAggregateResults = [
                                                    SELECT
                                                        FISCAL_YEAR(CloseDate) fiscalYear, 
                                                        SUM(Amount) totalAmount
                                                    FROM 
                                                        Opportunity
                                                    WHERE 
                                                        IsClosed = true
                                                    AND 
                                                        CloseDate = THIS_FISCAL_YEAR
                                                    GROUP BY 
                                                        FISCAL_YEAR(CloseDate)
                                                    LIMIT
                                                        50000
        ];
        Map<Integer,Decimal > mapYearVsTotalAmount= new Map<Integer, Decimal >();
        for(AggregateResult ar : lstAggregateResults){
            Integer fiscalYear = (Integer) ar.get('fiscalYear');
            Decimal  totalAmount = (Decimal )ar.get('totalAmount');
            mapYearVsTotalAmount.put(fiscalYear, totalAmount);
        }

        for (Integer yearKey : mapYearVsTotalAmount.keySet()) 
        {
                System.debug('Year: ' + yearKey + ' => Total Closed Opportunity Amount: ' + mapYearVsTotalAmount.get(yearKey));
        }

    }

/***********************************************************************************************************/
    Public static void getTotalDistinctLeadRecord()  // Q2
    {
        AggregateResult[] aggregateResultLeadRecord = [
                                                        SELECT 
                                                            LeadSource, COUNT(Id) totalLeads
                                                        FROM 
                                                            Lead
                                                        GROUP BY 
                                                            LeadSource
                                                        HAVING 
                                                            COUNT(Id) > 10
                                                        LIMIT
                                                            50000
        ];

        for(AggregateResult arr:aggregateResultLeadRecord)
        {
            System.debug('leadsource:- '+ arr.get('LeadSource')+'  count:- '+arr.get('totalLeads'));
        }
        
    }


/***********************************************************************************************************/
    public static void getTotalNumberOfLeadByStatusAndSource() //Q3
    {
        List<AggregateResult> lstAggregateLeadRec = [
                                                        SELECT 
                                                            Status, LeadSource, 
                                                            COUNT(Id) totalLeads
                                                        FROM 
                                                            Lead
                                                        GROUP BY 
                                                            status, LeadSource
                                                        LIMIT
                                                            50000
        ];

        
        Map<String, Map<String, Integer>> MapLeadSourceVsLeadsCount = new Map<String, Map<String, Integer>>();

        for (AggregateResult aggrList : lstAggregateLeadRec) {
            String status = (String) aggrList.get('Status');
            String leadSource = (String) aggrList.get('LeadSource');
            Integer countLeads = (Integer) aggrList.get('totalLeads');
            if (!MapLeadSourceVsLeadsCount.containsKey(status)) {
                MapLeadSourceVsLeadsCount.put(status, new Map<String, Integer>());
            }
            MapLeadSourceVsLeadsCount.get(status).put(leadSource, countLeads);
        }
        System.debug('MapLeadSourceVsLeadsCount: ' + MapLeadSourceVsLeadsCount);
        for (String statusKey : MapLeadSourceVsLeadsCount.keySet()) {
            System.debug('Status: ' + statusKey);
            Map<String, Integer> sourceMap = MapLeadSourceVsLeadsCount.get(statusKey);
            for (String sourceKey : sourceMap.keySet()) {
                System.debug('   Lead Source: ' + sourceKey + ', Count: ' + sourceMap.get(sourceKey));
            }
        }
    }
}