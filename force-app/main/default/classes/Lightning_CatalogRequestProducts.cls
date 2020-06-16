public class Lightning_CatalogRequestProducts {

    @AuraEnabled
    public static List<Product> getSampleLineItems(String catalogRequestId){
        List<Product> products = new List<Product>();
        List<Sample_Line_Item__c> lineItems =  [Select Id, Product__r.Name, Product__r.ProductCode, Quantity__c, Product_Description__c
                                                FROM Sample_Line_Item__c 
                                                WHERE Catalog_Request__c = :catalogRequestId ORDER BY CreatedDate ASC];
        for(Sample_Line_Item__c sli : lineItems){
            Product p = new Product(sli.Id, 
                                    sli.Product__r.Name, 
                                    sli.Product__r.ProductCode,
                                    sli.Quantity__c, 
                                    sli.Product_Description__c);
            products.add(p);
        }
        return products;    
    }
    
    @AuraEnabled
    public static void removeSampleLineItem(String sampleLineItemId){
        delete [select Id FROM Sample_Line_Item__c WHERE Id = :sampleLineItemId];
    }
    
    @AuraEnabled
    public static Integer updateSampleLineItems(List<Sample_Line_Item__c> lineItems, String catalogRequestId){
        update lineItems;
        return (lineItems == null || lineItems.size() == 0) ? 0 : lineItems.size();
    }
    
    public class Product {
        public Product(Id id, 
                       String ProductName, 
                       String ProductCode,
                       decimal Quantity,
                       string ProductDescription){
            this.Id = Id; 
            this.ProductName = ProductName; 
            this.ProductCode = ProductCode;
            this.Quantity = Quantity; 
            this.ProductDescription = ProductDescription;
        }
        @AuraEnabled
        public String ProductName {get; set;}
        @AuraEnabled
        public String ProductCode {get; set;}        
        @AuraEnabled
        public Id Id {get; set;}
        @AuraEnabled
        public decimal Quantity {get; set;}
        @AuraEnabled
        public String ProductDescription {get; set;}
    }
}