@isTest
private class PricingImportJobTest {
    
    static testmethod void LightningRun(){
        string c = Lightning_RunPricingImportJob.runJob();
    }
    
  static testmethod void PricingImportJobTest(){
        product2 p = new product2();
        p.name = 'test';
        p.productcode = 'PAD';
        p.language__c = 'French';
        insert p;
      
      product2 p1 = new product2();
        p1.name = 'test';
        p1.productcode = 'PAD';
        p1.language__c = 'German';
        insert p1;
      
      product2 p2 = new product2();
        p2.name = 'test';
        p2.productcode = 'PAD';
        p2.language__c = 'Italian';
        insert p2;
      
      product2 p3 = new product2();
        p3.name = 'test';
        p3.productcode = 'PAD';
        p3.language__c = 'English';
        insert p3;
        
        pricing_import__c pi = new pricing_import__c();
        pi.product_code__c = 'PAD';
        pi.Q50_100__c = 5;
        pi.currencyisocode = 'EUR';
        insert pi;
    
        list<pricing_import__c> Pricings = [
            SELECT name, 
            Q50_100__c,
            Q100_250__c ,
            Q250_500__c ,
            Q500_1000__c ,
            Q1000_2500__c ,
            Q2500_5000__c ,
            Q5000_10000__c ,
            Q10000_1000000__c ,
            CurrencyIsoCode,
            Product_Code__c FROM pricing_import__c
        ];
        
     	Pricebook2 price = new Pricebook2();
      	price.Name = 'French Pricebook';
     	insert price;
      
      Pricebook2 price1 = new Pricebook2();
      	price1.Name = 'German Pricebook';
     	insert price1;
      
      Pricebook2 price2 = new Pricebook2();
      	price2.Name = 'Italian Pricebook';
     	insert price2;
      
      Pricebook2 price3 = new Pricebook2();
      	price3.Name = 'English Pricebook';
     	insert price3;
     	
      
        Database.executeBatch(new PricingImportJob(), 1);

    }
}