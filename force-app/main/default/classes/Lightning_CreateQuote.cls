public class Lightning_CreateQuote {
    
    @AuraEnabled
    public static String createQuoteAndPrimaryContact(String opportunityId, String contactFirst, String contactLast, String contactEmail, String contactPhone,
                                                      Boolean createQuote){
        
        Opportunity opp = [SELECT Id, Name, AccountId,CurrencyIsoCode, SyncedQuoteId, pricebook2id FROM Opportunity WHERE Id = :opportunityId];  
        Account acc = [SELECT Price_Book__c,CurrencyIsoCode FROM Account WHERE Id = :opp.AccountId];                                                  
        Contact con = new Contact(accountid = acc.id, FirstName = contactFirst, LastName = contactLast, Email = contactEmail, Phone = contactPhone);
        insert con;
                                                          
        String quoteId = null;
        
        opp.Pricebook2Id = acc.Price_Book__c;
        
        if(createQuote){                                
            Quote quote = new Quote(Name = opp.Name, OpportunityId = opp.Id, ContactId = con.Id, pricebook2id = opp.pricebook2id, account__c = acc.id);
            insert quote;
            opp.SyncedQuoteId = quote.Id;
            quoteId = quote.Id;
            opp.CurrencyIsoCode = acc.CurrencyIsoCode;
        }
        update opp; 
                                                          
        List<OpportunityContactRole> isPrimary = [SELECT ContactId, Role, OpportunityId, IsPrimary FROM OpportunityContactRole WHERE ContactId = :con.Id 
                                            AND OpportunityId = :opportunityId]; 
        if(isPrimary.size() > 0){
            isPrimary[0].Role = 'Decision Maker';
            update isPrimary[0];
        } else {                                 
            OpportunityContactRole primaryOcr = new OpportunityContactRole (ContactId = con.Id, Role = 'Decision Maker',
                                                                        OpportunityId = opportunityId, IsPrimary = true);
            insert primaryOcr;
        }                                                          
        return (quoteId != null) ? quoteId : opportunityId;                                                     
    }

    @AuraEnabled
    public static String createQuote(String opportunityId, String primaryContactId, String primaryContactRole, 
                                      Boolean createQuote){
        String quoteId = null;
        Opportunity opp = [SELECT Id, Name,CurrencyIsoCode, AccountId, SyncedQuoteId, pricebook2id FROM Opportunity WHERE Id = :opportunityId];  
        Account acc = [SELECT Price_Book__c , CurrencyIsoCode FROM Account WHERE Id = :opp.AccountId];
        opp.Pricebook2Id = acc.Price_Book__c;
        
        if(createQuote){                                
            Quote quote = new Quote(Name = opp.Name, OpportunityId = opp.Id, ContactId = primaryContactId, pricebook2id = opp.pricebook2id, account__c = acc.id  );
            insert quote;
            opp.SyncedQuoteId = quote.Id;
           
            quoteId = quote.Id;
        }
        update opp;                                  
                                          
        List<OpportunityContactRole> isPrimary = [SELECT ContactId, Role, OpportunityId, IsPrimary FROM OpportunityContactRole WHERE ContactId = :primaryContactId 
                                            AND OpportunityId = :opportunityId]; 
        if(isPrimary.size() > 0){
            isPrimary[0].Role = primaryContactRole;
            update isPrimary[0];
        } else {                                 
            OpportunityContactRole primaryOcr = new OpportunityContactRole (ContactId = primaryContactId, Role = primaryContactRole,
                                                                        OpportunityId = opportunityId, IsPrimary = true);
            insert primaryOcr;
        }
                                               
        return (quoteId != null) ? quoteId : opportunityId;
    }
    
    @AuraEnabled
    public static Contact getContact(String contactId){
        return [SELECT Id, Name, Title FROM Contact WHERE Id = :contactId];
    }
    @AuraEnabled
    public static List<Contact> findByName(String searchKey) {
        String name =  + searchKey + '%';
        return [SELECT id, name, Title FROM Contact WHERE name LIKE :name];
    }}