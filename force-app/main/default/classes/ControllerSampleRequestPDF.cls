public class ControllerSampleRequestPDF {
    
    
      @testvisible
    private Contact acc ;
     public Sample_Line_Item__c objB {get; set;}
    public ControllerSampleRequestPDF(ApexPages.StandardController stdController) {
        
        
        this.acc = (Contact)stdController.getRecord();  
        objB = new Sample_Line_Item__c();
		ObjB.Contact__c = acc.id;
    }
    
    public PageReference save() {
        objB.Catalog_Request__c = null;
		insert objB;
        return null;
}

}