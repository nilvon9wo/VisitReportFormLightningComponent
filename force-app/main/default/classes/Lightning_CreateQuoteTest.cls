@isTest
public class Lightning_CreateQuoteTest {
    
    static {
        Id pricebookId = Test.getStandardPricebookId();
        Account account = new Account(Name = 'Test Account', Price_Book__c = pricebookId, CurrencyIsoCode = 'EUR');
        insert account;
        
        Contact contact1 = new Contact(FirstName = 'Contact1', LastName = 'One', AccountId = account.Id, CurrencyIsoCode = 'EUR' , Phone = '213562' , Email ='firas@taamallah.sf');
        insert contact1;
        
        Contact contact2 = new Contact(FirstName = 'Contact2', LastName = 'Two', AccountId = account.Id, CurrencyIsoCode = 'EUR' ,Phone = '6666' , Email ='firas@taamallah.sf.goldstar');
        insert contact2;
        
        Campaign campaign = new Campaign(Name = 'Test Campaign', CurrencyIsoCode='EUR');
        insert campaign; 
        
        Opportunity o = new Opportunity(Name = 'Test Opportunity', CampaignId = campaign.Id, AccountId = account.Id, CloseDate = System.today(), StageName = 'Proposal/Quote', CurrencyIsoCode='EUR');
        insert o;
    }
    
    static testMethod void testCreateQuotes(){
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Opportunity' LIMIT 1];
        Contact primaryContact = [SELECT Id FROM Contact WHERE LastName = 'One' LIMIT 1];        
        Contact secondaryContact = [SELECT Id, Title FROM Contact WHERE LastName = 'Two'];
        List<Contact> cons = new List<Contact>{secondaryContact};

        String quoteId = Lightning_CreateQuote.createQuote(opp.Id, primaryContact.Id, 'Decision Maker', true  );
        Quote q = [SELECT Id, Description FROM Quote WHERE Id = :quoteId];
        String quoteIdt = Lightning_CreateQuote.createQuoteAndPrimaryContact(opp.id, 'contactFirst', 'contactLast', 'contactEmail@email.com', 'ontactPhone',
                                                      true);
        System.assert(q != null);
    }
    
    static testMethod void testGetContacts(){
        Contact c = [SELECT Id FROM Contact WHERE LastName = 'One'];
        Contact con = Lightning_CreateQuote.getContact(c.Id);
        System.assert(c.Id == con.Id);
    }

}