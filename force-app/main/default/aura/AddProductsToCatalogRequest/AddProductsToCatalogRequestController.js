({
	doInit : function(component, event, helper) {
        
		helper.setDatatableColums(component);
        helper.searchProducts(component);
	},
    
    searchProducts : function(component, event, helper) {
        component.set("v.showSpinner", true);
        helper.searchProducts(component);    
	},
    
	updateSelectedRows : function(component, event, helper){
        var selectedRows = event.getParam('selectedRows');
        component.set("v.selectedRows" ,event.getParam('selectedRows') )
    },
       
    selectProducts : function(component, event, helper) {		
        component.set("v.showSpinner", true);
	    var selectedRows = component.get("v.selectedRows");
        helper.addLineItems(component, event, selectedRows);
    }, 
    
})