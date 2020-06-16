trigger QuoteTriggers on Quote (after update, after delete) {
    
    if(trigger.isDelete)
    TriggerUtil_Quote.deleteOpportunity(trigger.old);
    
    if(trigger.isUpdate)
    TriggerUtil_Quote.setOpportunityStage(trigger.old,trigger.new);
	
}