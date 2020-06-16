trigger QuoteLineItemTrigger on QuoteLineItem ( before insert , before update ,after insert, after update , after delete) {

  
    if(Trigger.isBefore && Trigger.isInsert){
        TriggerUtil_QuoteLineItem.setTieredPricing(Trigger.New);
    }
    
    if(Trigger.isBefore && Trigger.isUpdate){
        TriggerUtil_QuoteLineItem.setTieredPricingUpdate(Trigger.New, Trigger.Old);
    }
    
    if(Trigger.isInsert){
        TriggerUtil_QuoteLineItem.setProductCode(Trigger.New );
    }
    if(Trigger.isDelete){
        TriggerUtil_QuoteLineItem.setProductCode(Trigger.old);
    }
 

}