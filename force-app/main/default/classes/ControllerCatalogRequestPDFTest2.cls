@isTest
public class ControllerCatalogRequestPDFTest2 {

    
    static { 
        Id pricebookId = Test.getStandardPricebookId();
        Account account = new Account(Name = 'Test Account2', Price_Book__c = pricebookId , BillingCountry = 'Belgium');
        insert account;
        
        Contact contact1 = new Contact(FirstName = 'Contact1', LastName = 'One', AccountId = account.Id, CurrencyIsoCode = 'EUR', Email = 'firas.taamallah@goldstar-europe.com2');
        insert contact1;
        
        catalog_request__c r = new catalog_request__c(Contact__c = contact1.Id, Account__c = account.Id, Internal_Email_Sent_To_s__c = 'test22@gmail.com,admi1n@gmail.com', 
                                                      Request_Last_Sent__c = System.today(), Request_Date__c = System.today().addDays(31));
        insert r;
        
        
        
        
        
        
    }
    
    static testMethod void testCreateQuotes(){ 
        
        catalog_request__c r = [SELECT Name, Account__r.BillingCountry, Request_Date__c, Internal_Email_Sent_To_s__c, Request_Last_Sent__c  FROM Catalog_Request__c];
        ApexPages.StandardController sc = new ApexPages.StandardController(r); 
        ControllerCatalogRequestPDF2 s = new ControllerCatalogRequestPDF2(sc);
        PageReference pageRef = Page.CRequest2;
        pageRef.getParameters().put('id', String.valueOf(r.Id));
        Test.setCurrentPage(pageRef);        
        s.sendPDF();
        
    }

}