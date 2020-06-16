public class TriggerUtil_CatalogRequests {

    
    public static void CountCatalogs(list<Catalog_Request__c> cats){
		set<id> accountIds = new set<id>();        
        For(Catalog_Request__c c: cats){
            accountIds.add(c.account__c);
        }
        
        list<account> accounts = [SELECT id,Total_Catalogs_Sent__c, (SELECT account__c FROM Catalog_Requests__r WHERE request_date__c = THIS_YEAR) FROM account WHERE ID IN: accountIds];
        
        list<account> accountsToUpdate = new list<account>();
        For(account a: accounts){
            if(a.Total_Catalogs_Sent__c != a.Catalog_Requests__r.size()){
                a.Total_Catalogs_Sent__c = a.Catalog_Requests__r.size();
                accountsToUpdate.add(a);
            } 
        }
        if(!accountsToUpdate.isEmpty()) update accountsToUpdate;

    }

}