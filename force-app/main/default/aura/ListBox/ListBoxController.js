({
    init : function(component, event, helper){
        var listSource = component.get("v.listSource");
        if(listSource == "picklist"){
            helper.getPicklist(component, event);
        } else {
            helper.getObjectPair(component, event);
        }
    },

    handleChange : function(component, event, helper){
        var selectedOptionValue = component.find("selectOption").get("v.value");
        console.log("Option selected with value: '" + selectedOptionValue + "'"); 
        var appEvent = $A.get("e.c:ListBoxEvent");
        appEvent.setParams({"uniqueName" : component.get("v.uniqueName"), "selectedOptionValue" : selectedOptionValue});
        appEvent.fire();
    },
    
    handleValidationView : function(component, event, helper){
        var showError = component.get("v.showError");
        if(showError){
            $A.util.addClass(component.find("selectOption"), 'slds-has-error');
        } else {
            $A.util.removeClass(component.find("selectOption"), 'slds-has-error');
        }
    }
})