@isTest
public class Lightning_CatalogRequestProductsTest {
    
     static testMethod void testUpdateSampleLineItem(){
        List<Sample_Line_Item__c> lineItems = [SELECT Id, Quantity__c, Catalog_Request__c FROM Sample_Line_Item__c LIMIT 1];
        lineItems[0].Quantity__c = 100;
        String sid = lineItems[0].Catalog_Request__c;
        Lightning_CatalogRequestProducts.updateSampleLineItems(lineItems, sid);
        lineItems = [SELECT Id, Quantity__c FROM Sample_Line_Item__c  WHERE Catalog_Request__c = :sid];
        System.assertEquals(100, lineItems[0].Quantity__c);
    }
    
    static testMethod void testGetSampleLineItems(){
        Catalog_Request__c cr = [SELECT Id FROM Catalog_Request__c LIMIT 1];      
        List<Lightning_CatalogRequestProducts.Product> products = Lightning_CatalogRequestProducts.getSampleLineItems(cr.Id);
    }
    
    static testMethod void testRemoveSampleLineItem(){
        List<Sample_Line_Item__c> lineItems = [SELECT Id FROM Sample_Line_Item__c];
        Lightning_CatalogRequestProducts.removeSampleLineItem(String.valueOf(lineItems[0].Id));
    }  

    
    static {
        Product2 product1 = new Product2(Name = 'Product1',isactive = TRUE);
        insert product1;
        Product2 product2 = new Product2(Name = 'Product2',isactive = TRUE);
        insert product2; 
        
        Id pricebookId = Test.getStandardPricebookId(); 
        
        PricebookEntry standardProduct1 = new PricebookEntry(
        Pricebook2Id = pricebookId, Product2Id = product1.Id,
        UnitPrice = 10.00, IsActive = true);
        insert standardProduct1;  
        
        List<PriceBookEntry> priceBookEntries = new List<PriceBookEntry>();
        pricebookentries.add(standardproduct1);   
        
        PricebookEntry standardProduct2 = new PricebookEntry(
        Pricebook2Id = pricebookId, Product2Id = product2.Id,
        UnitPrice = 10.00, IsActive = true);
        insert standardProduct2;       
        
        Account acct = new Account(Name = 'Test Account');
        insert acct;     
        
        Contact c = new Contact(LastName = 'Test', AccountId = acct.Id, Email = 'test@gmail.com', Phone = '3105551212');
        insert c;
        
        Catalog_Request__c cr = new Catalog_Request__c(Contact__c = c.Id, Price_Book__c = pricebookId, Account__c = acct.Id);
        // , Catalog_Type__c = 'Busy Season'
        insert cr;
        List<Sample_Line_Item__c> sls = new List<Sample_Line_Item__c>();
        Sample_Line_Item__c sl1 = new Sample_Line_Item__c(Catalog_Request__c = cr.Id, Product__c = product1.Id, Product_Description__c = 'testing', Quantity__c = 1);
        sls.add(sl1);
        Sample_Line_Item__c sl2 = new Sample_Line_Item__c(Catalog_Request__c = cr.Id, Product__c = product2.Id, Product_Description__c = 'testing 2', Quantity__c = 1);
        sls.add(sl2);
        insert sls;
   }
}