trigger OrderTriggers on Order (after insert, after update, after delete) {
    
    if(trigger.isInsert)
        TriggerUtil_Order.OrderTotals(trigger.new);
        
    if(trigger.isUpdate){
        TriggerUtil_Order.OrderTotals(trigger.new);
    }

    if(trigger.isDelete)
        TriggerUtil_Order.OrderTotals(trigger.old);
}