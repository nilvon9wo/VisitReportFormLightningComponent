@IsTest
public class Lightning_SearchProductsTest {
    
            
        //Lightning_SearchProducts.searchProductsServer(cr.id, 'Product1');
        //Lightning_SearchProducts.addSampleLineItems(pricebookentries, cr.id);
        static testMethod void testAddOpportunitylines(){
            Product2 product1 = new Product2(Name = 'Product1',isactive = TRUE);
            insert product1;
            Product2 product2 = new Product2(Name = 'Product2',isactive = TRUE);
            insert product2; 
            
            Id pricebookId = Test.getStandardPricebookId(); 
            
            PricebookEntry standardProduct1 = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = product1.Id,
            UnitPrice = 10.00, IsActive = true);
            insert standardProduct1;     
            
            PricebookEntry standardProduct2 = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = product2.Id,
            UnitPrice = 10.00, IsActive = true);
            insert standardProduct2;  
            Catalog_Request__c cr = [SELECT Id FROM Catalog_Request__c LIMIT 1];   
            List<PricebookEntry> pbes = Lightning_SearchProducts.searchProductsServer(cr.Id, 'Product1');
            List<PricebookEntry> pbes1 = new List<PricebookEntry>();
            pbes1.add(standardProduct1);
            pbes1.add(standardProduct2);
            if (pbes1.size()>0){
			Lightning_SearchProducts.addSampleLineItems(pbes1, cr.id);
            }
            
    	}
    
		static testMethod void testGetSampleLineItems(){
            Catalog_Request__c cr = [SELECT Id FROM Catalog_Request__c LIMIT 1];      
            Lightning_SearchProducts.searchProductsServer(cr.id, 'Product1');
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
            Sample_Line_Item__c sl1 = new Sample_Line_Item__c(Catalog_Request__c = cr.Id, Product__c = product1.Id, Product_Description__c = 'testing', Quantity__c = 1 , Contact__c = c.Id);
            sls.add(sl1);
            Sample_Line_Item__c sl2 = new Sample_Line_Item__c(Catalog_Request__c = cr.Id, Product__c = product2.Id, Product_Description__c = 'testing 2', Quantity__c = 1 , Contact__c = c.Id);
            sls.add(sl2);
            insert sls;       
    }
    
}