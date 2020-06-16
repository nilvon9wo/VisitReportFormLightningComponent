({
    getContactForRole : function(component, event, contactId, role) {
        var otherContacts = component.get("v.otherContacts");
        if(!otherContacts) otherContacts = new Array();
        var action = component.get("c.getContact");
        action.setParams({"contactId" : contactId});
        action.setCallback(this, function(response){
            var responseState = response.getState();
            if(responseState === 'SUCCESS') {
            	var contact = response.getReturnValue();
                contact.Title = role;
                console.log('Role ' + contact.Title);
                otherContacts.push(contact);
                component.set("v.otherContacts", otherContacts);
            }    
        });
        
        $A.enqueueAction(action);
    }, 
    
    makeQuoteAndContact : function(component, event, opportunityId) {
        var primaryContactId = component.find("primaryContactId").get("v.value");
        var createQuote = component.get("v.createQuote");
		var contactFirst = component.find("contactFirst").get("v.value");
        var contactLast = component.find("contactLast").get("v.value");
        var contactEmail = component.find("contactEmail").get("v.value");
        var contactPhone = component.find("contactPhone").get("v.value");

        var action = component.get("c.createQuoteAndPrimaryContact");
        action.setParams({"opportunityId" : opportunityId, "contactFirst" : contactFirst, "contactLast" : contactLast, "contactEmail" : contactEmail,
                          "contactPhone" : contactPhone, "createQuote" : createQuote});
        action.setCallback(this, function(response){
            var responseState = response.getState();
            console.log('Response State: ' + responseState);
            if(responseState === 'SUCCESS') {
                var retval = response.getReturnValue();  
                var navTo = (retval != opportunityId) ? retval : opportunityId;
                if(retval != opportunityId){
                    this.showToast(component, event, "Created Opportunity", "success", "Created Opportunity and Related Quote.");
                } else {
                    this.showToast(component, event, "Created Opportunity", "success", "Created Opportunity.");
                }
                var resultsToast = $A.get("e.force:showToast");
                if(resultsToast){
                    $A.get("e.force:closeQuickAction").fire();
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                      "recordId": navTo
                     });
                    navEvt.fire();
                }
            } else {
                this.showToast(component, event, "Error Creating Quote", "error", "There was an error creating quotes and contact roles.");
                $A.get("e.force:closeQuickAction").fire();
            }    
        });
        
       $A.enqueueAction(action);
    },
    
    makeQuoteAndAddContactRoles : function(component, event, opportunityId) {
        var otherContacts = component.get("v.otherContacts");
        for(var i = 0; i < otherContacts.length; i++){
            console.log('Contact: ' + otherContacts[i].Name + ', Id: ' + otherContacts[i].Id + ', Role ' + otherContacts[i].Title);
        }
        var primaryContactId = component.find("primaryContactId").get("v.value");
        var primaryRole = component.get("v.primaryRole");
        var createQuote = component.get("v.createQuote");
        var action = component.get("c.createQuote");
        action.setParams({"opportunityId" : opportunityId, "primaryContactId" : primaryContactId,
                          "primaryContactRole" : primaryRole, "createQuote" : createQuote});
        action.setCallback(this, function(response){
            var responseState = response.getState();
            console.log('Response State: ' + responseState);
            if(responseState === 'SUCCESS') {
                var retval = response.getReturnValue();  
                var navTo = (retval != opportunityId) ? retval : opportunityId;
                if(retval != opportunityId){
                    this.showToast(component, event, "Created Opportunity", "success", "Created Opportunity and Related Quote.");
                } else {
                    this.showToast(component, event, "Created Opportunity", "success", "Created Opportunity.");
                }
                var resultsToast = $A.get("e.force:showToast");
                if(resultsToast){
                    $A.get("e.force:closeQuickAction").fire();
                    //$A.get("e.force:refreshView").fire();
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                      "recordId": navTo
                     });
                    navEvt.fire();
                }
            } else {
                this.showToast(component, event, "Error Creating Quote", "error", "There was an error creating quotes and contact roles.");
                $A.get("e.force:closeQuickAction").fire();
            }    
        });
        
       $A.enqueueAction(action);
    },
    
	showToast : function(component, event, title, mtype, msg){        
        var resultsToast = $A.get("e.force:showToast");
        if(resultsToast){
            resultsToast.setParams({
                "title": title,
                "type" : mtype,
                "message": msg
            });
            resultsToast.fire();   
        } else {
            alert(title + ', ' + msg);
        }
    },
    
})