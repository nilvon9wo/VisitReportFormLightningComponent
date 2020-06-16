public class Lightning_SearchProducts {
    
   @AuraEnabled
    public static List<PriceBookEntry> searchProductsServer(String catalogRequestId, String searchString) {
        Id pb2Id = [Select Price_Book__c FROM Catalog_Request__c where id = :catalogRequestId].Price_Book__c;
        system.debug('what is the pricebook ' + pb2Id);
        String qString = 'select Id, Pricebook2Id, IsActive, Product2.ProductCode, Product2.Name, Product2.Id, Product2.Family, Product2.IsActive, UnitPrice from PricebookEntry where IsActive=true and Pricebook2Id = \'' + pb2Id + '\' and Product2.ProductCode like \'%' + searchString + '%\' ';
	// Firas:  Product2.Description
    //    if(searchString!=null){
      //      qString+= ' and (Product2.ProductCode like \'%' + searchString + '%\')';
    //    }

//        qString+= ' order by Product2.ProductCode';
        qString+= ' limit 1001';
        
        system.debug('qString:' +qString);      
        list<priceBookEntry> AvailableProducts  = new list<priceBookEntry>();
        AvailableProducts = database.query(qString);
        system.debug('How many results found: ' + AvailableProducts.size());
        return AvailableProducts;
    } 
    
    @AuraEnabled
    public static Integer addSampleLineItems(List<PriceBookEntry> priceBookEntries, String catalogRequestId){
        List<Sample_Line_Item__c> sampleLineItems = new List<Sample_Line_Item__c>();
        // Firas
        Contact contacts = [SELECT Id FROM Contact WHERE Id IN (SELECT Contact__c FROM Catalog_Request__c WHERE Id = : catalogRequestId)];
        for(PriceBookEntry pbe : priceBookEntries){
            Sample_Line_Item__c sli = new Sample_Line_Item__c();
            sli.Name = pbe.Product2.Name;
            sli.Quantity__c = 1;
            sli.Product__c = pbe.Product2.Id;
            sli.Contact__c = contacts.Id;
            sli.Catalog_Request__c = catalogRequestId;
         //   sli.Product_Description__c = pbe.product2.description;
            sampleLineItems.add(sli);
        }
        insert sampleLineItems;
        return sampleLineItems.size();
    }
}