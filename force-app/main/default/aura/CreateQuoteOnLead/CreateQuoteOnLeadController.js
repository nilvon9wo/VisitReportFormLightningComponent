({
	
    
    createQuote : function(component, event, helper){
        
        var action = component.get("c.saveQuote");
        action.setParams({
            "quoteRecc" : component.get("v.Name")
        });
        
         action.setCallback(this, function(response){
            var responseState = response.getState();
             if(responseState === 'SUCCESS') {
                 
                 var quoteId = response.getReturnValue();
                 var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     "title" : "Success!" ,
                     "type" : "Success" , 
                     "message" : "Quote Created" 
                 });
                 
                 toastEvent.fire();
                 var navEvt = $A.get("e.force:navigateToSObject");
                 navEvt.setParams({
                     "recordId" : quoteId,
                     "slideDevName" : "related"
                 });
                 	navEvt.fire();
             }
         });
                            
                  
    },
    
     cancelQuickAction : function(component, event, helper){
        $A.get("e.force:closeQuickAction").fire();
    }
})