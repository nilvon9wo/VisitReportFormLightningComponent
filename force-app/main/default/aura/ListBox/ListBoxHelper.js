({
    getPicklist : function(component, event) {
        var objectName = component.get("v.objectName");
        var fieldName = component.get("v.fieldName");
        var action = component.get("c.getPicklistOptionValues");
        action.setParams({"objectName" : objectName, "fieldName" : fieldName});
        action.setCallback(this, function(response){
            var responseState = response.getState();
            if(responseState === 'SUCCESS') {
                var optvalues = response.getReturnValue();
                var addedOptions = '';
                addedOptions = component.get("v.addedOptions");
                console.log('Added: ' + JSON.stringify(addedOptions));
                if(addedOptions){
                    var added = addedOptions.concat(optvalues);
                    console.log('Added Options: ' + JSON.stringify(added));
                    component.set("v.options", added);
                } else {
                	component.set("v.options", optvalues);
                }
            }    
        });
        
        $A.enqueueAction(action);
    }, 
    
    getObjectPair : function(component, event) {
        var objectName = component.get("v.objectName");
        var fieldName1 = component.get("v.fieldName1");
        var fieldName2 = component.get("v.fieldName2");
        var whereClause = component.get("v.whereClause");
        var limit = component.get("v.limit");
        var action = component.get("c.getOptionValuePairsByQuery");
        action.setParams({"objectName" : objectName, "fieldName1" : fieldName1, "fieldName2" : fieldName2, "whereClause" : whereClause, "lmit" : limit});
        action.setCallback(this, function(response){
            var responseState = response.getState();
            if(responseState === 'SUCCESS') {
                var optvalues = response.getReturnValue();
                var addedOptions = '';
                addedOptions = component.get("v.addedOptions");
                console.log('Added: ' + JSON.stringify(addedOptions));
                if(addedOptions){
                    var added = addedOptions.concat(optvalues);
                    console.log('Added Options: ' + JSON.stringify(added));
                    component.set("v.options", added);
                } else {
                	component.set("v.options", optvalues);
                }
            }    
        });
        
        $A.enqueueAction(action);
    },
})