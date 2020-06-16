@isTest
public class TriggerUtil_OrderTests {
    
    static {
        Id pricebookId = Test.getStandardPricebookId();
        Account account = new Account(Name = 'Test Account', Price_Book__c = pricebookId);
        insert account;
        
    }
    
    static testMethod void testMassInserts(){
        account a = [select id from account limit 1];
        list<order> orders = new list<order>();
        For(integer i=0;i<201;i++){
            Order o = new Order();
            o.accountid = a.id;
            o.effectivedate = system.today() - i;
            o.status = 'BOOKED';
            orders.add(o);
        }
        
        insert orders;
        
        list<order_line__c> lines = new list<order_line__c>();
        For(order o: orders){
            For(integer i=0;i<1;i++){
                order_line__c line = new order_line__c();
                line.Order__c = o.id;
                line.Total_Amount__c = i + 1000;
                line.Qty__c = i;
                lines.add(line);
            }
        }
        insert lines;
        
    }
    

}