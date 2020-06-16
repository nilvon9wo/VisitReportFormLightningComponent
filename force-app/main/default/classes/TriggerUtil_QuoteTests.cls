@isTest
public class TriggerUtil_QuoteTests {
    
    static {
        Id pricebookId = Test.getStandardPricebookId();
        Account account = new Account(Name = 'Test Account', Price_Book__c = pricebookId);
        insert account;
        
        Contact contact1 = new Contact(FirstName = 'Contact1', LastName = 'One', AccountId = account.Id, CurrencyIsoCode = 'EUR');
        insert contact1;
        
        Contact contact2 = new Contact(FirstName = 'Contact2', LastName = 'Two', AccountId = account.Id, CurrencyIsoCode = 'EUR');
        insert contact2;
        
        Campaign campaign = new Campaign(Name = 'Test Campaign', CurrencyIsoCode='EUR');
        insert campaign;
        
        Opportunity o = new Opportunity(Name = 'Test Opportunity', CampaignId = campaign.Id, AccountId = account.Id, CloseDate = System.today(), StageName = 'Proposal/Quote', CurrencyIsoCode='EUR');
        insert o;
    }
    
    static testMethod void setAccepted(){
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Opportunity' LIMIT 1];
        Contact primaryContact = [SELECT Id FROM Contact WHERE LastName = 'One' LIMIT 1];        
        Contact secondaryContact = [SELECT Id, Title FROM Contact WHERE LastName = 'Two'];
        List<Contact> cons = new List<Contact>{secondaryContact};
        String quoteId = Lightning_CreateQuote.createQuote(opp.Id, primaryContact.Id, 'Decision Maker', true);
        Quote q = [SELECT Id, Description, status FROM Quote WHERE Id = :quoteId];
        q.status = 'Accepted';
        update q;
        System.assert(q != null);
    }
    
    static testMethod void setDenied(){
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Opportunity' LIMIT 1];
        Contact primaryContact = [SELECT Id FROM Contact WHERE LastName = 'One' LIMIT 1];        
        Contact secondaryContact = [SELECT Id, Title FROM Contact WHERE LastName = 'Two'];
        List<Contact> cons = new List<Contact>{secondaryContact};
        String quoteId = Lightning_CreateQuote.createQuote(opp.Id, primaryContact.Id, 'Decision Maker', true);
        Quote q = [SELECT Id, Description, status FROM Quote WHERE Id = :quoteId];
        q.status = 'Denied';
        update q;
        delete q;
        System.assert(q != null);
    }

}