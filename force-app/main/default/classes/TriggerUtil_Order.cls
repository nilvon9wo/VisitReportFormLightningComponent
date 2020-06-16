public class TriggerUtil_Order {
    
    public static void OrderTotals(list<Order> orders){
		set<id> accountIds = new set<id>();        
        For(Order o: orders){
            accountIds.add(o.AccountId);
        }
        list<account> allAccounts = [SELECT id,
                                   Order_Count_Last_12_Months__c,
                                   Order_Count_Last_Year__c,
                                   Order_Count_This_Year__c,
                                   Order_Total_Last_12_Months__c,
                                   Order_Total_Last_Year__c,
                                   Order_Total_This_Year__c FROM account WHERE ID IN: accountIds];
        
        list<account> LastTwelveMonthsAccounts = [SELECT id,
                                   Order_Count_Last_12_Months__c,
                                   Order_Count_Last_Year__c,
                                   Order_Count_This_Year__c,
                                   Order_Total_Last_12_Months__c,
                                   Order_Total_Last_Year__c,
                                   Order_Total_This_Year__c,
                                   (SELECT accountid,
                                   Order_Total__c,status,effectivedate 
                                   FROM Orders 
                                   WHERE status != 'CANCELLED' 
                                   AND effectivedate = LAST_N_MONTHS:12)
                                   FROM account WHERE ID IN:accountIds];
        
        Map<id,account> LastTwelveMonthsAccountsMap = new Map<id,account>(LastTwelveMonthsAccounts);
        
        list<account> LastYearMonthsTotalAccounts = [SELECT id,
                                   Order_Count_Last_12_Months__c,
                                   Order_Count_Last_Year__c,
                                   Order_Count_This_Year__c,
                                   Order_Total_Last_12_Months__c,
                                   Order_Total_Last_Year__c,
                                   Order_Total_This_Year__c,
                                   (SELECT accountid,
                                   Order_Total__c,status,effectivedate 
                                   FROM Orders 
                                   WHERE status != 'CANCELLED' 
                                   AND effectivedate = LAST_YEAR)
                                   FROM account WHERE ID IN:accountIds];
        
        Map<id,account> LastYearMonthsTotalAccountsMap = new Map<id,account>(LastYearMonthsTotalAccounts);
        
        list<account> ThisYearMonthsTotalAccounts = [SELECT id,
                                   Order_Count_Last_12_Months__c,
                                   Order_Count_Last_Year__c,
                                   Order_Count_This_Year__c,
                                   Order_Total_Last_12_Months__c,
                                   Order_Total_Last_Year__c,
                                   Order_Total_This_Year__c,
                                   (SELECT accountid,
                                   Order_Total__c,status,effectivedate 
                                   FROM Orders 
                                   WHERE status != 'CANCELLED' 
                                   AND effectivedate = THIS_YEAR)
                                   FROM account WHERE ID IN:accountIds];
        
        Map<id,account> ThisYearMonthsTotalAccountsMap = new Map<id,account>(ThisYearMonthsTotalAccounts);
        
        list<account> accountsToUpdate = new list<account>();
        For(account a: allAccounts){
            a.Order_Count_Last_12_Months__c = 0;
            a.Order_Count_Last_Year__c = 0;
            a.Order_Count_This_Year__c = 0;
            a.Order_Total_Last_12_Months__c = 0;
            a.Order_Total_Last_Year__c = 0;
            a.Order_Total_This_Year__c = 0;
            if(LastTwelveMonthsAccountsMap.get(a.id) != NULL){
                a.Order_Count_Last_12_Months__c = LastTwelveMonthsAccountsMap.get(a.id).orders.size();
                for(order o: LastTwelveMonthsAccountsMap.get(a.id).orders){
                    a.Order_Total_Last_12_Months__c += o.Order_Total__c;
                }
            }
            if(LastYearMonthsTotalAccountsMap.get(a.id) != NULL){
                a.Order_Count_Last_Year__c = LastYearMonthsTotalAccountsMap.get(a.id).orders.size();
                for(order o: LastYearMonthsTotalAccountsMap.get(a.id).orders){
                    a.Order_Total_Last_Year__c += o.Order_Total__c;
                }
            }
            if(ThisYearMonthsTotalAccountsMap.get(a.id) != NULL){
                a.Order_Count_This_Year__c = ThisYearMonthsTotalAccountsMap.get(a.id).orders.size();
                for(order o: ThisYearMonthsTotalAccountsMap.get(a.id).orders){
                    a.Order_Total_This_Year__c += o.Order_Total__c;
                }
            }
            accountsToUpdate.add(a);
        }
        
        if(!accountsToUpdate.isEmpty()) update accountsToUpdate;

    }

}