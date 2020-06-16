({
	handleCreateLoad : function(component, event, helper) {
		var recordId = component.get("v.recordId");
        component.find("AccountId").set("v.value", recordId);
        var accountName = component.find("accountName").get("v.value");
        var closeDate = new Date(new Date().setDate(new Date().getDate()));
        closeDate = $A.localizationService.formatDate(closeDate, "YYYY-MM-DD");
        component.find("CloseDate").set("v.value", closeDate);
        console.log('Close date: ' + closeDate);
        component.find("StageName").set("v.value", "Proposal/Quote");        
        var accountPricebook = component.find("AccountPriceBook").get("v.value");
        component.find("Pricebook2Id").set("v.value", accountPricebook);
        
	},    

    handleListboxEvents : function(component, event, helper) {
        var uniqueName = event.getParam("uniqueName");
        if(uniqueName == 'primaryRole'){
            var selectedOptionValue = event.getParam("selectedOptionValue");  
            if(uniqueName == 'primaryRole'){
                component.set("v.primaryRole", selectedOptionValue);
                if(selectedOptionValue) component.set("v.primaryRoleError", false);
            } else if(uniqueName == 'otherRole'){
                component.set("v.otherRole", selectedOptionValue);
            }
        }
        if(uniqueName == 'opportunityContact'){
            var selectedOptionValue = event.getParam("selectedOptionValue");  
            console.log('Selected Role: ' + selectedOptionValue);
            if(selectedOptionValue == 'Create new Contact'){
                component.set("v.createContact", true);
                component.set("v.createContactError", false);
            } else {
                component.set("v.createContact", false);
                component.find("primaryContactId").set("v.value", selectedOptionValue);
                component.set("v.createContactError", false);
            }
        }
        
    },
   
    handleOnSubmit : function(component, event, helper) {
        component.set('v.isLoading', true);
        console.log('On Submit');
        event.preventDefault();
        var fields = event.getParam("fields");
        $A.util.removeClass(component.find("name"), 'slds-has-error');
        var oppName = component.find("name").get("v.value");
        if(!oppName){
            $A.util.addClass(component.find("name"), 'slds-has-error');
            return;            
        }
       
        var createContact = component.get("v.createContact");
        if(! createContact){
            component.set("v.createContactError", false);
            $A.util.removeClass(component.find("primaryContactId"), 'slds-has-error');
            var primaryContactId = component.find("primaryContactId").get("v.value"); 
            if(!primaryContactId){
                component.set("v.createContactError", true);
                $A.util.addClass(component.find("primaryContactId"), 'slds-has-error');
                return;               
            }
            fields["ContactId"] = primaryContactId;
        } else { //New Contact
			$A.util.removeClass(component.find("contactFirst"), 'slds-has-error'); 
            var contactFirst = component.find("contactFirst").get("v.value"); 
            if(!contactFirst){
                $A.util.addClass(component.find("contactFirst"), 'slds-has-error');
                return;               
            }            
			$A.util.removeClass(component.find("contactLast"), 'slds-has-error'); 
            var contactLast = component.find("contactLast").get("v.value"); 
            if(!contactLast){
                $A.util.addClass(component.find("contactLast"), 'slds-has-error');
                return;               
            }  
			$A.util.removeClass(component.find("contactEmail"), 'slds-has-error'); 
            var contactEmail = component.find("contactEmail").get("v.value"); 
            if(!contactEmail){
                $A.util.addClass(component.find("contactEmail"), 'slds-has-error');
                return;               
            }
			$A.util.removeClass(component.find("contactPhone"), 'slds-has-error'); 
            var contactPhone = component.find("contactPhone").get("v.value"); 
            if(!contactPhone){
                $A.util.addClass(component.find("contactPhone"), 'slds-has-error');
                return;               
            }           
        }        
        fields["StageName"] = 'Proposal/Quote';
        component.find("oppForm").submit(fields);
        
    },
    
    handleOnSuccess : function(component, event, helper) {
        var record = event.getParams().response;
		var createContact = component.get("v.createContact");
        if(createContact){
            helper.makeQuoteAndContact(component, event, record.id);
        } else {
        	helper.makeQuoteAndAddContactRoles(component, event, record.id);
        }
        component.set('v.isLoading', false);
    },    
   
    handleOnError : function(component, event, helper) {
        helper.showToast(component, event, "Error Creating Quote", "error", "There was an error creating quotes and contact roles.");  
        component.set('v.isLoading', false);
    },
       
    cancelQuickAction : function(component, event, helper){
        $A.get("e.force:closeQuickAction").fire();
    },
    

})