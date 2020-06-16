public class Lightning_PicklistLookup {

    @AuraEnabled
    public static List<DroplistOption> getPicklistOptionValues(String objectName, String fieldName){
        List<DroplistOption> options = new List<DroplistOption>();
        List<String> lstPickvals=new List<String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(objectName);
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get(fieldName).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a : pick_list_values) { 
            DroplistOption dlo = new DroplistOption();
            dlo.value = a.value;
            dlo.label = a.label;
            options.add(dlo);
        }    
        return options;
    }
    
    @AuraEnabled
    public static List<DroplistOption> getOptionValuePairsByQuery(String fieldName1, String fieldName2, String objectName, String whereClause, String lmit){
        List<DroplistOption> options = new List<DroplistOption>();
        String query = 'SELECT ' + fieldName1 + ', ' + fieldName2 + ' FROM ' + objectName;
        if(String.isNotBlank(whereClause)){
            query = query + ' ' + whereClause;
        }
        if(String.isNotBlank(lmit)){
            query = query + ' ' + lmit;
        }
        System.debug('Query: ' + query);
        List<sObject> obs = Database.query(query);
        System.debug('Objects: ' + obs);
        Set<String> dedupe = new Set<String>();
        for(sObject s : obs){
            DroplistOption dlo = new DroplistOption();
            if(fieldName1.indexOf('.') == -1){
                dlo.value = (String)s.get(fieldName1);
            } else {
                String[] cmpnd = fieldName1.split('.');
                dlo.value = (String)s.getSobject(cmpnd[0]).get(cmpnd[1]);
            }
            if(fieldName2.indexOf('.') == -1){
                dlo.label = (String)s.get(fieldName2);
            } else {
                List<String> cmpnd = fieldName2.split('\\.');
                System.debug('Compound: ' + cmpnd.size());
                dlo.label = (String)s.getSobject(cmpnd[0]).get(cmpnd[1]);
                System.debug('DLO Value: ' + dlo.label);
            }
            if(! dedupe.contains(dlo.value)){
                options.add(dlo); 
            } 
            dedupe.add(dlo.value);      
        }
        return options;
    }
    
    public class DroplistOption {
        @AuraEnabled
        public String value {get; set;}
        @AuraEnabled
        public String label {get; set;}
    }
}