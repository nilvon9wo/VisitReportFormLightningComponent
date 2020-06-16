@isTest
public class TestTriggerAccCont {


    static testMethod void testUnit()
	{
     	Account zc = new Account();
        zc.Name = 'FirasTest';
       // zc.Counserlor__c = userinfo.getuserid() ;
		insert zc;
        
        Account zc1 = new Account();
        zc1.Name = 'FirasTest2';
       // zc.Counserlor__c = userinfo.getuserid() ;
		insert zc1;
        
     //   zc = [SELECT Id, PersonContactId FROM Account where Id =: zc.Id];
        
        
        
        Contact led = new Contact();
        led.lastname = 'Test';
        led.firstName ='Test';
        led.AccountId = zc.Id;
        led.phone = '4514';
        led.email ='firas@firasTest.com';
       // led.Zip_Code__c = '123456';
		// Add all required field
        insert led;
        
        Task t = new Task();
        t.Subject = 'call';
        t.WhoId = led.Id;
        t.WhatId = zc.Id;
        
        insert t;

            

}
    
}