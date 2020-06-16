({
	doInit : function(component, event, helper) {

        component.set('v.columns', [   
            {type:  'button',fixedWidth: 60,  typeAttributes:  {label: 'X', name: 'removeRecord', title: 'Remove Product',  disabled: false, value: 'Remove'}},
 			{label: 'PRODUCT', fixedWidth: 200, fieldName: 'linkName', type: 'url', 
             typeAttributes: {label: { fieldName: 'ProductCode' }, target: '_blank', tooltip:{fieldName: 'ProductName'}}},
            {label: 'QUANTITY', fixedWidth: 100, fieldName: 'Quantity', type: 'number', editable: true, sortable: false},  
            {label: 'DESCRIPTION',  fieldName: 'ProductDescription', type: 'text', sortable: false, editable: true}
        ]);
        helper.getRelatedLineItems(component, event);
	},
    handleLoad : function(component, event, helper) {
        var recUi = event.getParam("recordUi");
        var pricebook2Id = recUi.record.fields["Price_Book__c"];        
        component.set("v.pricebookId", pricebook2Id);      
    },    
    showAddProducts: function(component, event, helper) {
        var pricebookId = component.get("v.pricebookId"); 
        if(pricebookId && pricebookId.value){
        	component.set("v.showingAddProducts", true);
        } else {
            helper.showToast(component, event, "You cannot add products until you set a Pricebook for the Catalog Request.","Missing Pricebook","error");
        }
    },
    hideAddProducts : function(component, event, helper) {
        component.set("v.showingAddProducts", false);
        $A.get('e.force:refreshView').fire();
    },
    handleProductsAdded : function(component, event, helper) {
        var eventSource = event.getParam("eventSource");
        if(eventSource == 'SampleLineItem'){
            helper.getRelatedLineItems(component, event);
            component.set("v.showingAddProducts", false);
            $A.get('e.force:refreshView').fire();
        }
    },
    handleRowAction : function(component, event, helper) {
		var action = event.getParam('action');
        var row = event.getParam('row');
        if(action.name == 'removeRecord'){
            helper.deleteLineItem(component, event, row);
            $A.get('e.force:refreshView').fire();
        }
    },
    handleTableUpdates : function(component, event, helper) {
		var draftValues = event.getParam('draftValues');
        var stringValue = JSON.stringify(draftValues);
        var quantity = new RegExp('Quantity', 'g');
        var productDescription = new RegExp('ProductDescription', 'g');
        stringValue = stringValue.replace(quantity, 'Quantity__c');
        stringValue = stringValue.replace(productDescription, 'Product_Description__c');
        //console.log('Draft values: ' + JSON.stringify(draftValues));
        //console.log('String values: ' + stringValue);
        helper.updateLineItems(component, event, JSON.parse(stringValue));
    },
    onCallChildMethod : function(component, event, helper) {
        var childComponent = component.find('child');
        childComponent.selectProductsAndClose();
    }
})