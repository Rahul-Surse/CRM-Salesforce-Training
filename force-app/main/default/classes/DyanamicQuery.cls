public with sharing class DyanamicQuery { 
   public static List<String> getTextFields(String objectName){// Q1
		List<String> lstTextFields = new List<String>();
		Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);
		Map<String, Schema.SObjectField> fieldsMap = objType.getDescribe().fields.getMap();
		for (String fieldName : fieldsMap.keySet()){
			Schema.DisplayType type = fieldsMap.get(fieldName).getDescribe().getType();
			if (type == Schema.DisplayType.String) {
				System.debug('Fieldname:'+fieldName);
				lstTextFields.add(fieldName);
			}
		}
		System.debug(lstTextFields);

		return lstTextFields;
	}


	public static void fetchFiveRecords(String obj)
	{
		List<String> fields = getTextFields(obj);
		String firstField = fields[0];
		System.debug(firstField);
		String soql = 'SELECT ' + String.join(fields, ',') + ' FROM ' + obj + ' LIMIT 5';
		List<SObject> lstRes = Database.query(soql);
		System.debug(lstRes);
		System.debug(lstRes.size());

	}

	 public static void getByUsingWhereClause(String obj,String Value)
	{
		List<String> lstfields = getTextFields(obj);
		String firstField = lstfields[0];
		String soql = 'SELECT ' + String.join(lstfields, ',') + ' FROM ' + obj + ' Where '+firstField +'= :Value';
		List<SObject> lstRes = Database.query(soql);
		System.debug(lstRes);
		System.debug(lstRes.size());

	}

	public static void addDynamicOrderByLimitOffdet(
		String obj,
		String orderByValue,
		String limitinput,
		String offseinput
	)
	{
		List<String> fields = getTextFields(obj);
		String firstField = fields[0];
		String soql = 'SELECT ' + String.join(fields, ',') + ' FROM ' + obj +
					  ' ORDER BY ' + orderByValue + ' '+
					  ' LIMIT ' + limitinput +
					  ' OFFSET ' + offseinput;
		List<SObject> lstRes = Database.query(soql);

		for(SObject obj1:lstRes)
		{
			System.debug(obj1);
		}
	}
} 
