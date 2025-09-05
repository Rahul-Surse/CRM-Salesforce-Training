public with sharing class DmlOperation //Q1
{
	public static void OperationOnLeadLogs(){
		List<Lead> lstLead = new List<Lead>();
		Boolean flag=true;
		for(Integer i = 1; i <= 25; i++) {
			Integer randomNumber = Integer.valueOf((Math.random() * 100)) + 1;
			if(Math.mod(randomNumber,2)==0){
				Lead l = new Lead(FirstName = 'Test' + i, Email='email' + i, Rating='1234', Salutation='12');
				lstLead.add(l);
			}
			else{
				if(flag)
				{
					Lead l = new Lead(FirstName = 'Test' + i, LastName = 'LS' + i, Company = 'CTI',city='pune');
					flag=false;
					lstLead.add(l);
				}
				else 
				{
					Lead l = new Lead(FirstName = 'Test' + i, LastName = 'LS' + i, Company = 'CTI',city='mumbai');
					flag=true;
					lstLead.add(l);
				}	
			}
		}
			
			List<AssignmentRule> lstAR = [select id,Name from AssignmentRule where SobjectType = 'Lead' and Active = true limit 1];
			String ArId = '';
			// for(AssignmentRule AR:lstAR)
			// {
			// 	if(AR.Name=='Lead Assignment')
			// 	{
			// 		ArId=AR.Id;
			// 		System.debug(ArId);
			// 	}
			// }
			Database.DMLOptions dmlOpts = new Database.DMLOptions();
			dmlOpts.assignmentRuleHeader.assignmentRuleId= ArId;
			Database.SaveResult[] results = Database.insert(lstLead, dmlOpts);
			List<Logs__c> lstLog = new List<Logs__c>();
			for (Integer i = 0; i < results.size(); i++)
			{
				Database.SaveResult sr = results[i];
				String allErrors = '';
				if (!sr.isSuccess()) 
				{
					Lead failedLead = lstLead[i];
					for (Database.Error err : sr.getErrors())
					{
						allErrors += err.getMessage()+';';  
					}
					Logs__c logRecord = new Logs__c();
					logRecord.error__c = allErrors;
					logRecord.name=failedLead.FirstName;
					lstLog.add(logRecord);
				}
			}
		

		Insert lstLog;
	} 
	
	
	public static void deletePastInactiveAccounts() //Q2
	{
		// Date ninetyDaysAgo = Date.today().addDays(-90);
		List<Account> lstAccountsToDelete = [
			SELECT 
					Id, Name, CreatedDate, Active__c
			FROM 
					Account
			WHERE 
					CreatedDate >= LAST_90_DAYS
			AND 
					Active__c = 'No'
			LIMIT
					50000
		];

		
		if (!lstAccountsToDelete.isEmpty()) {
			delete lstAccountsToDelete;
			System.debug(lstAccountsToDelete.size() + ' inactive Accounts deleted.');
		} else {
			System.debug('No inactive Accounts found to delete.');
		}
	}

	public static void getCampaignRecord()  // Q4
	{
		List<Campaign> lstCampaignsAsc=[
			SELECT 
					Id,Name 
			FROM
					Campaign 
			ORDER BY
					 name
			ASC 
			LIMIT 10
			];

			System.debug('Ascending Order: ' + lstCampaignsAsc);


		List<Campaign> lstCampaignsDsc=[
			SELECT
				 Id,Name 
			FROM 
				Campaign 
			ORDER BY
				name 
			DESC LIMIT 10
		];
			System.debug('descending Order: ' + lstCampaignsDsc);

	}

	/***************************************************************************************************
	* @Author:          CRM Developer
	* @Description:     Description of the method, purpose Description of the method, purpose Description of the method, purpose
						Description of the method, purpose
	* @Param:          str: usecase of the parameter
	***************************************************************************************************/
	public static void getContactRecordFilterLastmodifiedByToday()  //Q5
	{

		List<Contact> lstContacts = [
			SELECT 
				id,name,LastModifiedDate 
			FROM 
				contact 
			WHERE 
				LastModifiedDate = today
			LIMIT
				50000
			];

		for(contact con:lstContacts)
		{
			System.debug(con );
		}
	}
}



