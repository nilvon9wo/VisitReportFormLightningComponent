@isTest
public class TriggerUtil_CatalogRequestsTest {
    
    static {
        Id pricebookId = Test.getStandardPricebookId();
        Account account = new Account(Name = 'Test Account', Price_Book__c = pricebookId , Total_Catalogs_Sent__c = 12);
        insert account;
        
        Contact contact1 = new Contact(FirstName = 'Contact1', LastName = 'One', AccountId = account.Id, CurrencyIsoCode = 'EUR' , Email = 'firas@goldstar.me');
        insert contact1;
        
        Catalog_Request__c cr = new Catalog_Request__c();
        cr.Request_Date__c = system.today();
        cr.Contact__c = contact1.id;
        cr.Catalog_Type__c = 'Summer' ;
        cr.Language__c = 'English-Euro';
        cr.Quantity__c = 1;
         cr.Account__c = account.Id;
     //  cr.Compliment_Slip__c = 'Yes';
        cr.Delivery_Address__c = 'test';
        insert cr;

    }
    
    static testMethod void testCreateQuotes(){
        Catalog_Request__c c = [SELECT Id FROM Catalog_Request__c LIMIT 1];
        update c;
        delete c;
        
    }
    

}