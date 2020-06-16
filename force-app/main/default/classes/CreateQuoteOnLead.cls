public with sharing class CreateQuoteOnLead {
	
    @AuraEnabled
    public static ID saveQuote(Quote quot){
        try{
            insert quot;
        } catch (Exception e){
            
        }
        return quot.Id ;
    }
}