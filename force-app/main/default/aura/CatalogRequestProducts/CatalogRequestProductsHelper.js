({
	getRelatedLineItems : function (component, event) {
		var action = component.get("c.getSampleLineItems");
        var recordId = component.get("v.recordId");
        action.setParams({ "catalogRequestId" : recordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('Response is' +  JSON.stringify(response.getReturnValue()));
                var results = response.getReturnValue();
                results.forEach(function(result){
                    result.linkName = '/'+result.Id;
                });
				component.set("v.lineItems", results);
            }
        });
        $A.enqueueAction(action);
    },
    deleteLineItem : function (component, event, row) {
		var action = component.get("c.removeSampleLineItem");
        action.setParams({ "sampleLineItemId" : row.Id});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                this.getRelatedLineItems(component, event);
            }
        });
        $A.enqueueAction(action);
    },
    updateLineItems : function (component, event, draftValues) {
        var recordId = component.get("v.recordId");
		var action = component.get("c.updateSampleLineItems");
        action.setParams({ "lineItems" : draftValues, "catalogRequestId" : recordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {  
                this.getRelatedLineItems(component, event);
                this.showToast(component, event, 'Your changes have been saved.', 'Sample Line Items Updated', 'success');
                $A.get('e.force:refreshView').fire();
                component.set('v.draftValues', []);
            } else {
                var errors = response.getError();
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    for (i = 0; i < errors.length; i++) { 
                        message = message +'Error'+ i + ':' + errors[i].message;
                    }
                }                
                component.set("v.errors", message)
            }            
        });
        $A.enqueueAction(action);
    },
    showToast : function(component, event, message, title, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type,
            "mode": 'dismissible',
        });
        toastEvent.fire();
	},

})