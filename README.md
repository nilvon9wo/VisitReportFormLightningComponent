Hi Brian ,

To test the LC you need to create new custom object Visit_Report__c 
Fieds : 
* Assigned_to__c : Lookup user 
* Comments__c : long text
* Contact__c : master detail to contact
* Account__c : lookup to account
* Subject__c : text
* Visit_Type__c : picklist 

After that you need to add Firas.cmp to Account page layout as tab via lightning App builder
Just focus on " Firas.cmp " , " reUsableMultiSelectLookup " is lightning component its goal is to be able to select more than 1 recor on lookup field  " - it's controller is " reUsableMultiSelectLookupCtrl " 

the screenshots are in : https://salesforce.stackexchange.com/questions/302998/save-form-lightning-component

the problem i'm face is when i hit on the button " Create New "  , only the fields " Contact & User " can't be saved 
I'm on Xing ;)
