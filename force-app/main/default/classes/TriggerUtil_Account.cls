public class TriggerUtil_Account {

    public static void calculateRebateAmounts(List<Account> newAccounts, Map<Id, Account> oldAccountMap){
    
        Map<Id, Account> accountsToUpdateMap = new Map<Id, Account>();

        for(Account acct : newAccounts){
            if((acct.Order_Total_This_Year__c != oldAccountMap.get(acct.Id).Order_Total_This_Year__c) || (acct.Order_Total_Last_Year__c != oldAccountMap.get(acct.Id).Order_Total_Last_Year__c) ){
                accountsToUpdateMap.put(acct.Id, acct);
            }
        }
        
        List<Rebate_Tracker__c> rebateTrackers = [SELECT Id, Account__c, Rebate__c, Rebate_End_Date__c, Rebate_Start_Date__c, Spend_Tier_End__c, Spend_Tier_Start__c FROM Rebate_Tracker__c 
                                                  WHERE Account__c IN :accountsToUpdateMap.keySet() AND Active__c = true ORDER BY Spend_Tier_End__c DESC];
                                                  
        Map <Id, List<Rebate_Tracker__c>> rebateTrackerMap = new Map<Id, List<Rebate_Tracker__c>>();
        for(Rebate_Tracker__c rt : rebateTrackers){
            if(rebateTrackerMap.get(rt.Account__c) == null){
                rebateTrackerMap.put(rt.Account__c, new List<Rebate_Tracker__c>{rt});
            } else {
                rebateTrackerMap.get(rt.Account__c).add(rt);
            }
        }        
        
        Integer previousYear = System.Today().year() - 1; 
        Integer currentYear = System.Today().year();
        
        for(Account acct : accountsToUpdateMap.values()){
        if(rebateTrackerMap.get(acct.Id) == NULL) continue;
            List<Rebate_Tracker__c> rtracks = rebateTrackerMap.get(acct.Id);
            List<Rebate_Tracker__c> pyTrackers = new List<Rebate_Tracker__c>();
            List<Rebate_Tracker__c> cyTrackers = new List<Rebate_Tracker__c>();
            for(Rebate_Tracker__c rt : rtracks){
                if(rt.Rebate_Start_Date__c.year() == previousYear){
                    pyTrackers.add(rt);
                }
                if(rt.Rebate_Start_Date__c.year() == currentYear){
                    cyTrackers.add(rt);
                }
            
            }
            //Previous Year
            Decimal pyTotal = acct.Order_Total_Last_Year__c;            
            List<Decimal> pyAmtEachRebate = new List<Decimal>(); 
                      
            Integer pycount = 0;
            do {            
                for(Rebate_Tracker__c r : pyTrackers){
                    if(pyTotal == r.Spend_Tier_End__c){
                        pyAmtEachRebate.add(r.Spend_Tier_End__c * (r.Rebate__c/100));
                        System.debug('Total is exactly equal to a Spend Tier End');
                        pyTotal = 0.00;  
                        break;                  
                    } 
                    else if(pyTotal > r.Spend_Tier_End__c){
                        System.debug('Total is greater than Spend Tier End');
                        pyAmtEachRebate.add(r.Spend_Tier_End__c * (r.Rebate__c/100));
                        pyTotal = pyTotal - r.Spend_Tier_End__c;
                        break;
                    } else if(pyTotal >= r.Spend_Tier_Start__c && pyTotal < r.Spend_Tier_End__c && pyTotal > 0.00){
                        System.debug('PY Total is between  Spend Tiers ' + pyTotal);
                        pyAmtEachRebate.add(pyTotal * (r.Rebate__c/100));
                        pyTotal = 0.00;
                        break;                    
                    } else {
                        continue;
                    }
                }
                
                pycount++;
                if(pycount == 20) pyTotal = 0.00;//Error in tiers
            } while(pyTotal > 0.99);
            
            Decimal pyTotalDiscount = 0.00;
            for(Decimal d : pyAmtEachRebate){
                pyTotalDiscount += d;
            }
            acct.Rebate_Amount_PY__c = pyTotalDiscount;
            //End Previous Year
            
            //Start Current Year
            Decimal cyTotal = acct.Order_Total_This_Year__c;            
            List<Decimal> cyAmtEachRebate = new List<Decimal>();   
            Integer cycount = 0;
            do {            
                for(Rebate_Tracker__c r : cyTrackers){
                    if(cyTotal == r.Spend_Tier_End__c){
                        cyAmtEachRebate.add(r.Spend_Tier_End__c * (r.Rebate__c/100));
                        System.debug('Total is exactly equal to a Spend Tier End');
                        cyTotal = 0.00;  
                        break;                  
                    } 
                    else if(cyTotal > r.Spend_Tier_End__c){
                        System.debug('Total is greater than Spend Tier End');
                        cyAmtEachRebate.add(r.Spend_Tier_End__c * (r.Rebate__c/100));
                        cyTotal = cyTotal - r.Spend_Tier_End__c;
                        break;
                    } else if(cyTotal >= r.Spend_Tier_Start__c && cyTotal < r.Spend_Tier_End__c && cyTotal > 0.00){
                        System.debug('Total is between  Spend Tiers');
                        cyAmtEachRebate.add(cyTotal * (r.Rebate__c/100));
                         cyTotal = 0.00;
                        break;                    
                    } else {
                        continue;
                    }
                }
                
                cycount++;
                if(cycount == 20) cyTotal = 0.00;//Error in tiers
            } while(cyTotal > 0.99);             
            
            Decimal cyTotalDiscount = 0.00;
            for(Decimal d : cyAmtEachRebate){
                System.debug('Calc rebate: ' + d);
                cyTotalDiscount += d;
            }
            acct.Rebate_Amount_CY__c = cyTotalDiscount;     
        
        }
        
    }

}