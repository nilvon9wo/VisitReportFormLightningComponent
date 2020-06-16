global class PricingImportJob implements Database.Batchable<sObject> {

    global final String query;
    global PricingImportJob() {
        //Build the query of fields dynamically
        List<String> fields = new List<String>(pricing_import__c.SObjectType.getDescribe().fields.getMap().keySet());
        this.query = ' select ' + String.join(fields, ',') + ' from pricing_import__c LIMIT 1';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
      
    }

    global void execute(Database.BatchableContext BC, List<pricing_import__c> scope) {
        
        
      //  delete [select id from Quantity_Tier_Pricing__c];
        
        List<String> pFields = new List<String>(pricing_import__c.SObjectType.getDescribe().fields.getMap().keySet());
        string query = ' select ' + String.join(pFields, ',') + ' from pricing_import__c';
       	List<pricing_import__c> imports = Database.query(query);
		System.debug('number of recs ' + imports.size());
         
        SET<string> productCodes = new Set<string>();
        Map<string,list<pricing_import__c>> importMap = new Map<string,list<pricing_import__c>>();
        For(pricing_import__c p: imports){
            productcodes.add(p.Product_Code__c);
            list<pricing_import__c> importList = new list<pricing_import__c>();
            if(importMap.get(p.Product_Code__c) != NULL) importList = importMap.get(p.Product_Code__c);
            importList.add(p);
            importMap.put(p.Product_Code__c, importList);
        }
        
        list<product2> prods = [SELECT productcode,language__c,isactive FROM product2 WHERE  language__c = 'French'];
        
        id englishPricebookid = [select name from pricebook2 where name = 'French Pricebook'].id;
        list<Quantity_Tier_Pricing__c> tiers = new list<Quantity_Tier_Pricing__c>();
        For(product2 pr: prods){
            if(importMap.get(pr.ProductCode) == NULL) continue;
    		list<pricing_import__c> importListToCreateTiers = importMap.get(pr.ProductCode);
            For(pricing_import__c p: importListToCreateTiers){
                //For each record loop all the fields on it and build the quantity tier record.
                For(string qField: pFields){
                    if(qField.startsWith('q')){
                        string labelField = qField.replace('q','');
                        labelField = labelField.replace('__c','');
                        string stripQ = qField.Replace('q','');
                        list<string> quantities = labelField.split('_');
                        Quantity_Tier_Pricing__c q = new Quantity_Tier_Pricing__c();
                        q.Low_Quantity__c = Integer.ValueOf(quantities[0]);
                        q.High_Quantity__c = Integer.ValueOf(quantities[1])-1;
                        q.Product__c = pr.id;
                        q.Unit_Price__c = (Decimal)p.get(qField);
                        q.currencyisocode = p.currencyisocode;
                        q.price_book__c = englishPricebookid;
                        tiers.add(q);
                    }
                }
            }
        }
        
        insert tiers;
        
           
        

        
        
    }

    global void finish(Database.BatchableContext BC){ }    
}