@isTest
public class TriggerUtil_QuoteLineItemTest {

   static {
        Id pricebookId = Test.getStandardPricebookId();
        Account account = new Account(Name = 'Test Account', Price_Book__c = pricebookId);
        insert account;
        
        Contact contact1 = new Contact(FirstName = 'Contact1', LastName = 'One', AccountId = account.Id, CurrencyIsoCode = 'EUR' , Email ='firas@gs.com');
        insert contact1;
        
        Contact contact2 = new Contact(FirstName = 'Contact2', LastName = 'Two', AccountId = account.Id, CurrencyIsoCode = 'EUR' ,Email ='firast@gs.com' );
        insert contact2;
        
        Campaign campaign = new Campaign(Name = 'Test Campaign', CurrencyIsoCode='EUR');
        insert campaign;
        
        Opportunity o = new Opportunity(Pricebook2Id = pricebookId, Name = 'Test Opportunity', CampaignId = campaign.Id, AccountId = account.Id, CloseDate = System.today(), StageName = 'Proposal', CurrencyIsoCode='EUR');
        insert o;
        
        Quote quote = new Quote(Pricebook2Id = pricebookId, Name = o.Name, OpportunityId = o.Id, Description = 'Test Description', ContactId = contact1.Id);
        insert quote;
        o.SyncedQuoteId = quote.Id;
        update o;
        
        OpportunityContactRole primaryOcr = new OpportunityContactRole (ContactId = contact1.Id, Role = 'Decision Maker',
                                                                        OpportunityId = o.Id, IsPrimary = true);
        insert primaryOcr;
        
        Product2 markingPen = new Product2(Name = 'Marking Pen', IsActive = true, ProductCode = 'mkgpen', Description = 'Pen');
        insert markingPen;
        Product2 mechPencil = new Product2(Name = 'Mechanical Pencil', IsActive = true, ProductCode = 'mechgpen', Description = 'Mechanical Pencil');
        insert mechPencil;
        
        PricebookEntry mkgPenEntry = new PricebookEntry(unitprice = 5.00, Product2Id = markingPen.Id, Pricebook2Id = pricebookId,
                                         isActive=true);
        insert mkgPenEntry;
        PricebookEntry mechPencilEntry = new PricebookEntry(unitprice = 10.00, Product2Id = mechPencil.Id, Pricebook2Id = pricebookId,
                                         isActive=true);
        insert mechPencilEntry;

        List<Quantity_Tier_Pricing__c> tiers = new List<Quantity_Tier_Pricing__c>();
        Quantity_Tier_Pricing__c penTier1 = new Quantity_Tier_Pricing__c(Low_Quantity__c = 1, High_Quantity__c = 11, Price_Book__c = pricebookId, Product__c = markingPen.Id,
                                                                        Unit_Price__c = 5.00);
        tiers.add(penTier1);                                                                                                                                     
        Quantity_Tier_Pricing__c penTier2 = new Quantity_Tier_Pricing__c(Low_Quantity__c = 11, High_Quantity__c = 21, Price_Book__c = pricebookId, Product__c = markingPen.Id,
                                                                        Unit_Price__c = 2.00);   
        tiers.add(penTier2);                                                                 
        Quantity_Tier_Pricing__c penTier3 = new Quantity_Tier_Pricing__c(Low_Quantity__c = 21, High_Quantity__c = 51, Price_Book__c = pricebookId, Product__c = markingPen.Id,
                                                                        Unit_Price__c = 1.00);      
        tiers.add(penTier3); 
        Quantity_Tier_Pricing__c mpTier1 = new Quantity_Tier_Pricing__c(Low_Quantity__c = 1, High_Quantity__c = 11, Price_Book__c = pricebookId, Product__c = mechPencil.Id,
                                                                         Unit_Price__c = 10.00);
        tiers.add(mpTier1);                                                                
        Quantity_Tier_Pricing__c mpTier2 = new Quantity_Tier_Pricing__c(Low_Quantity__c = 11, High_Quantity__c = 21, Price_Book__c = pricebookId, Product__c = mechPencil.Id,
                                                                        Unit_Price__c = 5.00);    
        tiers.add(mpTier2);                                                                 
        Quantity_Tier_Pricing__c mpTier3 = new Quantity_Tier_Pricing__c(Low_Quantity__c = 21, High_Quantity__c = 51, Price_Book__c = pricebookId, Product__c = mechPencil.Id,
                                                                        Unit_Price__c = 2.00); 
        tiers.add(mpTier3);  
        insert tiers;                                                                                                                                                                                                            
        
    }
    
    static testMethod void testCreateQuoteLines(){   
        Id pricebookId = Test.getStandardPricebookId();     
        Quote quote = [SELECT Id FROM Quote LIMIT 1];
        Product2 markingPen = [SELECT Id FROM Product2 WHERE Name = 'Marking Pen' LIMIT 1];
        PricebookEntry mkgPenEntry = [SELECT Id FROM PricebookEntry WHERE Pricebook2Id = :pricebookId and Product2Id = :markingPen.Id];
        Product2 mechPencil = [SELECT Id FROM Product2 WHERE Name = 'Mechanical Pencil' LIMIT 1];
        PricebookEntry mechPencilEntry = [SELECT Id FROM PricebookEntry WHERE Pricebook2Id = :pricebookId and Product2Id = :mechPencil.Id];
        List<QuoteLineItem> qiList = new List<QuoteLineItem> {
                           new QuoteLineItem(QuoteId = quote.Id, Quantity = 5, 
                                             PricebookEntryId = mkgPenEntry.Id, Product2Id = markingPen.Id, UnitPrice = 5.00),
                          new QuoteLineItem(QuoteId = quote.Id, Quantity = 12, 
                                             PricebookEntryId = mkgPenEntry.Id, Product2Id = markingPen.Id, UnitPrice = 5.00), 
                          new QuoteLineItem(QuoteId = quote.Id, Quantity = 22, 
                                             PricebookEntryId = mkgPenEntry.Id, Product2Id = markingPen.Id, UnitPrice = 5.00),     
                          new QuoteLineItem(QuoteId = quote.Id, Quantity = 4, 
                                             PricebookEntryId = mechPencilEntry.Id, Product2Id = mechPencil.Id, UnitPrice = 10.00),     
                          new QuoteLineItem(QuoteId = quote.Id, Quantity = 15, 
                                             PricebookEntryId = mechPencilEntry.Id, Product2Id = mechPencil.Id, UnitPrice = 10.00),    
                          new QuoteLineItem(QuoteId = quote.Id, Quantity = 25, 
                                             PricebookEntryId = mechPencilEntry.Id, Product2Id = mechPencil.Id, UnitPrice = 10.00)};    
        insert qiList;        
        
        List<QuoteLineItem> qlis = [SELECT Quantity FROM QuoteLineItem WHERE Quantity >= 5 AND Quantity <= 10 And Product2Id = :markingPen.Id];
        for(QuoteLineItem qli : qlis){
            qli.Quantity = 17;
        }                     
        update qlis;     
        
        QuoteLineItem mkgpenItem = [SELECT UnitPrice FROM QuoteLineItem WHERE Quantity = 17 AND Product2Id = :markingPen.Id LIMIT 1];   
        System.assertEquals(2.00, mkgpenItem.UnitPrice);                                                                                                                   
        
    }

}