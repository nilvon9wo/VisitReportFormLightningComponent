trigger AccountTriggers on Account (before insert, before update, after insert, after update) {
	
    if(Trigger.IsBefore && Trigger.IsUpdate){
        TriggerUtil_Account.calculateRebateAmounts(Trigger.New, Trigger.OldMap);
    }
}