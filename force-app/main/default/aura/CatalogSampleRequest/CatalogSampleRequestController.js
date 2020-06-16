({
	gotoURL:function(component,event,helper){
    var evt = $A.get("e.force:navigateToComponent"); 
     var accountFromId = component.get("v.recordId");
   
    evt.setParams({
        componentDef:"c:AddProductsToCatalogRequest",
        componentAttribute : {
            catalogRequestId : accountFromId }
    });

evt.fire();
}
})