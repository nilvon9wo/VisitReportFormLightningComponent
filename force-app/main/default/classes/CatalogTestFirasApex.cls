public class CatalogTestFirasApex {
     public Catalog_Request__c catrequest;
    public Contact contact;
    public List<Sample_Line_Item__c> lineItems {get; set;}
    public string status {get;set;}
    public Catalog_Request__c catreq;
    public ApexPages.StandardSetController stdCntrlr {get; set;}
    
    public CatalogTestFirasApex(ApexPages.StandardController stdController) {
        	
        this.catrequest = (Catalog_Request__c)stdController.getRecord();
     catrequest = [Select Compliment_Slip__c,Catalog_Type__c,Language__c,Quantity__c from Catalog_Request__c ];
    }

}