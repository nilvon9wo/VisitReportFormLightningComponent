public class CatalogRequest_vfp_Controller {
    
   @testvisible
    private Catalog_Request__c catreq;
	public CatalogRequest_vfp_Controller(ApexPages.StandardController sc){ 
	this.catreq = (Catalog_Request__c)sc.getRecord();  
	
}

}