({
     save: function(component, event, helper){
    var vr = component.get("v.newRecord");

    //Creating a new record on the button click
    var action = component.get("c.saveDetails");
    action.setParams({
        "acc" : vr
    });
    action.setCallback(this, function(response) {
        var state = response.getState();
        if (state == "SUCCESS") {
         //   var newRecord = response.getReturnValue();
          //  newRecord.sobjectType = 'Visit_Type__c';
       //     component.set("v.newRecord", response.getReturnValue());
        //    console.log('FIRAASOO'+response.getReturnValue());
         //   console.log('FIRAASOO1111:' + JSON.stringify(response.getReturnValue()));
			var firas = component.set('v.recordId' , response.getReturnValue());
             console.log("firrrrr " + firas);
             alert('Record is Created Successfully');
        }
        else {
            console.log("Failed with state: " + state);
        }
    });
    $A.enqueueAction(action);
    },
    
    doInit: function(component,event,helper) {
        var getId = component.get( "v.recordId" );
        console.log("reccccccc " + getId);
        
    },
    
    handleSubmit: function(component, event, handler) {
    	
        event.preventDefault();       // stop the form from submitting
        var fields = event.getParam('fields');
        var input1 = c.get("v.selectedLookUpRecords");
        component.set("v.selectedLookUpRecords", input1);
        var input2 = c.get("v.selectedLookUpRecords1");
        component.set("v.selectedLookUpRecords1", input2);
		var compEvent = component.getEvent("oSelectedRecordEvent");
        // set the Selected sObject Record to the event attribute.  
        compEvent.setParams({"recordByEvent" : getSelectRecord });  
        // fire the event  
        compEvent.fire();
    	console.log('fields = '+fields);
   
  		component.find("myform").submit();
     
    
   
    }  
        
})