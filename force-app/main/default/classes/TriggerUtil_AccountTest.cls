@IsTest
public class TriggerUtil_AccountTest {


    public static testMethod void testCalculateRebateAmounts(){
        Account acct = [SELECT Order_Total_This_Year__c, Order_Total_Last_Year__c, Rebate_Amount_CY__c, Rebate_Amount_PY__c FROM Account WHERE NAME = 'Test' LIMIT 1];
        acct.Order_Total_Last_Year__c = 40000;
        
        //Edge Cases
        acct.Order_Total_This_Year__c = 49999.99;
        acct.Order_Total_Last_Year__c = 50000.00;
        update acct;
        acct = [SELECT Order_Total_This_Year__c, Order_Total_Last_Year__c, Rebate_Amount_CY__c, Rebate_Amount_PY__c FROM Account WHERE Id = :acct.Id];
        System.debug('Rebate Amount CY for 49,999.99, Should be 499.99 :' + acct.Rebate_Amount_CY__c);//Should be 499.99
        System.debug('Rebate Amount PY for 50000.00,  Should be 1000.00 :' + acct.Rebate_Amount_PY__c);//Should be 1000.00
        
        acct.Order_Total_This_Year__c = 50000.00;
        acct.Order_Total_Last_Year__c = 55000.00;
        update acct;
        acct = [SELECT Order_Total_This_Year__c, Order_Total_Last_Year__c, Rebate_Amount_CY__c, Rebate_Amount_PY__c FROM Account WHERE Id = :acct.Id];
        System.debug('Rebate Amount CY for 50,000.00, Should be 1000.00 :' + acct.Rebate_Amount_CY__c);//Should be 1000.00
        System.debug('Rebate Amount PY for 55,000.00, Should be 1100.00 :' + acct.Rebate_Amount_PY__c);//Should be 1100.00
        
        acct.Order_Total_This_Year__c = 99999.99;
        acct.Order_Total_Last_Year__c = 225000.00;
        update acct;
        acct = [SELECT Order_Total_This_Year__c, Order_Total_Last_Year__c, Rebate_Amount_CY__c, Rebate_Amount_PY__c FROM Account WHERE Id = :acct.Id];
        System.debug('Rebate Amount CY for 99999.99, Should be 1999.99  :' + acct.Rebate_Amount_CY__c);//Should be 1999.99
        System.debug('Rebate Amount PY for 225000.00, Should be 8250.00  :' + acct.Rebate_Amount_PY__c);//Should be 8250.00
        
        acct.Order_Total_This_Year__c = 100000.00;
        update acct;
        acct = [SELECT Order_Total_This_Year__c, Order_Total_Last_Year__c, Rebate_Amount_CY__c, Rebate_Amount_PY__c FROM Account WHERE Id = :acct.Id];
        System.debug('Rebate Amount CY for 100000.00, Should be 3000.00  :' + acct.Rebate_Amount_CY__c);//Should be 3000.00
        
        acct.Order_Total_This_Year__c = 149999.99;
        update acct;
        acct = [SELECT Order_Total_This_Year__c, Order_Total_Last_Year__c, Rebate_Amount_CY__c, Rebate_Amount_PY__c FROM Account WHERE Id = :acct.Id];
        System.debug('Rebate Amount CY for 149999.99, Should be 4499.99  :' + acct.Rebate_Amount_CY__c);//Should be 4499.99
        
        acct.Order_Total_This_Year__c = 150000.00;
        update acct;
        acct = [SELECT Order_Total_This_Year__c, Order_Total_Last_Year__c, Rebate_Amount_CY__c, Rebate_Amount_PY__c FROM Account WHERE Id = :acct.Id];
        System.debug('Rebate Amount CY for 150000.00, Should be 6000.00  :' + acct.Rebate_Amount_CY__c);//Should be 6000.00
        
        acct.Order_Total_This_Year__c = 199999.99;
        update acct;
        acct = [SELECT Order_Total_This_Year__c, Order_Total_Last_Year__c, Rebate_Amount_CY__c, Rebate_Amount_PY__c FROM Account WHERE Id = :acct.Id];
        System.debug('Rebate Amount CY for 150000.00, Should be 7999.99  :' + acct.Rebate_Amount_CY__c);//Should be 7999.99
        
        //Over
        acct.Order_Total_This_Year__c = 225000.00;
        update acct;
        acct = [SELECT Order_Total_This_Year__c, Order_Total_Last_Year__c, Rebate_Amount_CY__c, Rebate_Amount_PY__c FROM Account WHERE Id = :acct.Id];
        System.debug('Rebate Amount CY for 225000, Should be 8249.99  :' + acct.Rebate_Amount_CY__c);//Should be 8249.99 
    }

    static {    
       
        Account acct = new Account(Name = 'Test');
        insert acct;
        Integer currentYear = System.Today().year();
        Integer previousYear = System.Today().year() - 1;
        Date currentYearStart = Date.parse('01/01/' + String.valueOf(currentYear));
        Date currentYearEnd = Date.parse('12/31/' + String.valueOf(currentYear));
        Date previousYearStart = Date.parse('01/01/' + String.valueOf(previousYear));
        Date previousYearEnd = Date.parse('12/31/' + String.valueOf(previousYear));       
        
        Rebate_Tracker__c currentYear1 = new Rebate_Tracker__c(Account__c = acct.Id, Rebate__c = 1.0, Rebate_Start_Date__c = currentYearStart, 
                                                                Rebate_End_Date__c = currentYearEnd, Spend_Tier_Start__c = 0.00, Spend_Tier_End__c = 49999.99, Active__c = true);
        insert currentYear1;                                                         
        Rebate_Tracker__c currentYear2 = new Rebate_Tracker__c(Account__c = acct.Id, Rebate__c = 2.0, Rebate_Start_Date__c = currentYearStart, 
                                                                Rebate_End_Date__c = currentYearEnd, Spend_Tier_Start__c = 50000.00, Spend_Tier_End__c = 99999.99, Active__c = true); 
        insert currentYear2;                                                         
        Rebate_Tracker__c currentYear3 = new Rebate_Tracker__c(Account__c = acct.Id, Rebate__c = 3.0, Rebate_Start_Date__c = currentYearStart, 
                                                                Rebate_End_Date__c = currentYearEnd, Spend_Tier_Start__c = 100000.00, Spend_Tier_End__c = 149999.99, Active__c = true);  
        insert currentYear3;                                                        
        Rebate_Tracker__c currentYear4 = new Rebate_Tracker__c(Account__c = acct.Id, Rebate__c = 4.0, Rebate_Start_Date__c = currentYearStart, 
                                                                Rebate_End_Date__c = currentYearEnd, Spend_Tier_Start__c = 150000.00, Spend_Tier_End__c = 199999.99, Active__c = true); 
        insert currentYear4;     
        
        Rebate_Tracker__c previousYear1 = new Rebate_Tracker__c(Account__c = acct.Id, Rebate__c = 1.0, Rebate_Start_Date__c = previousYearStart, 
                                                                Rebate_End_Date__c = previousYearEnd, Spend_Tier_Start__c = 0.00, Spend_Tier_End__c = 49999.99, Active__c = true);
        insert previousYear1;                                                         
        Rebate_Tracker__c previousYear2 = new Rebate_Tracker__c(Account__c = acct.Id, Rebate__c = 2.0, Rebate_Start_Date__c = previousYearStart, 
                                                                Rebate_End_Date__c = previousYearEnd, Spend_Tier_Start__c = 50000.00, Spend_Tier_End__c = 99999.99, Active__c = true); 
        insert previousYear2;                                                         
        Rebate_Tracker__c previousYear3 = new Rebate_Tracker__c(Account__c = acct.Id, Rebate__c = 5.0, Rebate_Start_Date__c = previousYearStart, 
                                                                Rebate_End_Date__c = previousYearEnd, Spend_Tier_Start__c = 100000.00, Spend_Tier_End__c = 149999.99, Active__c = true);  
        insert previousYear3;                                                        
        Rebate_Tracker__c previousYear4 = new Rebate_Tracker__c(Account__c = acct.Id, Rebate__c = 4.0, Rebate_Start_Date__c = previousYearStart, 
                                                                Rebate_End_Date__c = previousYearEnd, Spend_Tier_Start__c = 150000.00, Spend_Tier_End__c = 199999.99, Active__c = true); 
        insert previousYear4;                                                                                                                                                                                                                                                    
   
    }


}