({
	run : function(component, event, helper) {
		var action = component.get("c.runJob");
         action.setCallback(this, function(response) {
             if (response.getState() == "SUCCESS") {
                 $A.get("e.force:closeQuickAction").fire()
                 var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Job is Running."
                    });
                    toastEvent.fire();
             } 
         });
         $A.enqueueAction(action);        
	}
})