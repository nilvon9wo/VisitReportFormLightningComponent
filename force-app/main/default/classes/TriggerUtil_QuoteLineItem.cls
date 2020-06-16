public class TriggerUtil_QuoteLineItem {

    public static void setTieredPricingUpdate (List<QuoteLineItem> newItems, List<QuoteLineItem> oldItems){
        List<QuoteLineItem> itemsToProcess = new List<QuoteLineItem>();
        for(Integer i = 0; i < newItems.size(); i++){
            if(newItems[i].Quantity != oldItems[i].Quantity){
                itemsToProcess.add(newItems[i]);
            }
        }
        setTieredPricing(itemsToProcess);
    }

    public static void setTieredPricing (List<QuoteLineItem> newItems){
        Set<Id> quoteIds = new Set<Id>();
        Set<string> product2Ids = new Set<string>();
        for(QuoteLineItem qli : newItems){
            product2Ids.add(qli.ProductCode__c);
            quoteIds.add(qli.QuoteId);
        } 
        
        Map<Id, Quote> quoteMap = new Map<Id, Quote>([SELECT Id, OpportunityId, Opportunity.CurrencyIsoCode FROM Quote WHERE Id IN :quoteIds]);
        Set<string> currencies = new Set<string>();
        for(QuoteLineItem qli : newItems){
            Quote q = quoteMap.get(qli.QuoteId);
            currencies.add(q.Opportunity.currencyisocode);
        }
        
        try{
        List<Quantity_Tier_Pricing__c> tiers = [SELECT Id, ProductCode__c,CurrencyIsoCode, Low_Quantity__c, High_Quantity__c, Price_Book__c, Product__c, Unit_Price__c FROM Quantity_Tier_Pricing__c
                                                WHERE ProductCode__c IN :product2Ids AND CurrencyIsoCode IN :currencies];
         System.debug('Firas : show me tiers '+ tiers );
        for(QuoteLineItem qli : newItems){
            for(Quantity_Tier_Pricing__c qtp : tiers){
                string currencyIsoCode = quoteMap.get(qli.QuoteId).Opportunity.CurrencyIsoCode;
                System.debug('Currency from Quote: ' + currencyIsoCode + ', QTP currencyIsoCode: ' + qtp.currencyIsoCode + ', Product from QLI: ' + qli.Product2Id + ', Product from QTP: ' + qtp.Product__c);
                if(currencyIsoCode == qtp.CurrencyIsoCode && qli.ProductCode__c == qtp.ProductCode__c){
                    System.debug('Quantity QLI: ' + qli.Quantity + ', QTP Quantity Low: ' +  qtp.Low_Quantity__c + ', Quantity High: ' + qtp.High_Quantity__c);                   
                    if(qli.Quantity >= qtp.Low_Quantity__c && qli.Quantity <=  qtp.High_Quantity__c){
                        System.debug('Setting Unit Price: ' + qli.UnitPrice + ', Tier ' + qtp.Unit_Price__c);
                        qli.UnitPrice = qtp.Unit_Price__c;
                        break;
                    }
                }
            }

        }   }catch(Exception e){ System.debug('Error 10.0000 ' + e.getMessage());}
            
        
        
    }
    
    public static void setProductCode (List<QuoteLineItem> newItems){
       Set<Id> quoteIds = new Set<Id>();
        Set<string> product2Ids = new Set<string>();
        for(QuoteLineItem qli : newItems){
            product2Ids.add(qli.ProductCode__c);
            quoteIds.add(qli.QuoteId);
        } 
        List<Quote> quoteList = new List<Quote>();
        Map<Id, Quote> quoteMap = new Map<Id, Quote>([SELECT Id, ProdCode__c FROM Quote WHERE Id IN :quoteIds]);
        for(Integer i = 0; i < newItems.size(); i++){
            quoteList.add(new Quote(Id = newItems[i].QuoteId, ProdCode__c = newItems[i].ProductCode__c));   
            
             quoteMap.putAll(quoteList);
        if(!quoteList.isEmpty())
            {
              update quoteMap.values();
            }
            
        }
       
        
  		  }
}