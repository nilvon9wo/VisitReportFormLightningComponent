@isTest
public class ControllerCatalogRequestPDFTest {

    
    static {
        Id pricebookId = Test.getStandardPricebookId();
        Account account = new Account(Name = 'Test Account', Price_Book__c = pricebookId , BillingCountry = 'France');
        insert account;
        
        Contact contact1 = new Contact(FirstName = 'Contact1', LastName = 'One', AccountId = account.Id, CurrencyIsoCode = 'EUR', Email = 'firas.taamallah@goldstar-europe.com');
        insert contact1;
        
        catalog_request__c r = new catalog_request__c(Contact__c = contact1.Id, Account__c = account.Id, Internal_Email_Sent_To_s__c = 'test@gmail.com,admin@gmail.com', 
                                                      Request_Last_Sent__c = System.today(), Request_Date__c = System.today().addDays(30));
        insert r;
        
        
        
        
    }
    
    static testMethod void testCreateQuotes(){
        
        catalog_request__c r = [SELECT Name, Account__r.BillingCountry, Request_Date__c, Internal_Email_Sent_To_s__c, Request_Last_Sent__c  FROM Catalog_Request__c LIMIT 1];
        ApexPages.StandardController sc = new ApexPages.StandardController(r);
        ControllerCatalogRequestPDF s = new ControllerCatalogRequestPDF(sc);
        PageReference pageRef = Page.catalogrequest;
        pageRef.getParameters().put('id', String.valueOf(r.Id));
        Test.setCurrentPage(pageRef);        
        s.savePDF();
        
    }

}