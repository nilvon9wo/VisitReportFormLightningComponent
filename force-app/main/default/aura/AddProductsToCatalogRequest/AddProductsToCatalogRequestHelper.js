({
	showToast : function(component, event, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Sample Line Items Added",
            "message": message,
            "type": type,
            "mode": 'dismissible',
        });
        toastEvent.fire();
	},
    
    setDatatableColums : function(component) {
		component.set('v.columns', [
            {label: 'Product Code', fieldName: 'ProductCode', type: 'text'} //,
            //{label: 'List Price', fieldName: 'UnitPrice', type: 'currency'}
        ]);	        
    },
    
    searchProducts : function(component, event) {
		var catalogRequestId = component.get("v.recordId");
        var searchString = component.get("v.searchText");
        component.set("v.resultsFound", '');
        var action = component.get("c.searchProductsServer");
        action.setParams({"catalogRequestId" : catalogRequestId, "searchString" : searchString});
		action.setCallback(this, function(response) {
            var results = response.getReturnValue();
            if(!$A.util.isEmpty(results) && results.length != 0) {
                for (var i = 0; i < results.length; i++) {
					var row = results[i];
					row.ProductCode = row.Product2.ProductCode;
                    row.ProductFamily = row.Product2.Family;
                    row.ProductDesc = row.Product2.Description ;
            	}
				component.set("v.data", results);
            }else{
                component.set("v.resultsFound", 'No Products Found');                
            } 
            component.set("v.showSpinner",false);
		});
        
		$A.enqueueAction(action);        
        
    },
    
    addLineItems : function(component, event, products) {  
        component.set('v.isLoading', true);
        var catalogRequestId = component.get("v.recordId");
    	var action = component.get("c.addSampleLineItems");
        action.setParams({"priceBookEntries" : products, "catalogRequestId" : catalogRequestId});
        action.setCallback(this, function(response){
            var responseState = response.getState();            
            if(responseState === 'SUCCESS') {
            	 var recordCount = response.getReturnValue();
                 this.showToast(component,event, recordCount + ' Sample Lines added.', responseState);
                 var selectEvent = component.getEvent("ProductsAddedEvt");
                 selectEvent.setParam('eventSource', 'SampleLineItem');
		         selectEvent.fire();
            } else {
            	this.showToast(component,event,'Error!',response.getReturnValue());
            	console.log('fail');
            }  
            component.set("v.showSpinner",false);
            component.set('v.isLoading', false);
            
        });	
		$A.enqueueAction(action);        
    }
})