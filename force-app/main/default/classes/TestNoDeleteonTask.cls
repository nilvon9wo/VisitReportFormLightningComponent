@isTest
public class TestNoDeleteonTask {
    
    static testmethod void testPreventAccDel(){
        Task accRecord = new Task(Subject='Call' , CurrencyIsoCode='EUR' , Priority='High' , Status='Open' , OwnerId=UserInfo.getUserId());
        insert accRecord;
        
        try{
            delete accRecord;
        }catch(DMLexception e){
            system.assert(e.getMessage().contains('Only Administrators can delete Task!'),'Only Administrators can delete Task!');                       
        }
    }

}