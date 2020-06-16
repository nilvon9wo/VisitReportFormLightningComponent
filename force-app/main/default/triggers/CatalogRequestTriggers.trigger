trigger CatalogRequestTriggers on Catalog_Request__c (after insert, after update, after delete) {
    
    if(trigger.isInsert)
        TriggerUtil_CatalogRequests.CountCatalogs(trigger.new);
        
    if(trigger.isUpdate){
        TriggerUtil_CatalogRequests.CountCatalogs(trigger.new);
    }
        
        
    if(trigger.isDelete)
        TriggerUtil_CatalogRequests.CountCatalogs(trigger.old);

}