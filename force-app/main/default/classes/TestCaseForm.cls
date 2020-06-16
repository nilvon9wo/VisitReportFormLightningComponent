@isTest
public class TestCaseForm {
    
    	public static testMethod void testAutoRun() {
            try {
             test.startTest();
   			PageReference pageRef = Page.ChooseRecord;
            Case caseForm = new Case(Subject='Firas Subject', Description='Firas Test',Priority='Medium', Status='New');
            
            insert caseForm;
           
                
            
             pageRef.getParameters().put('id',caseForm.id);
   			ApexPages.StandardController sc = new ApexPages.standardController(caseForm);
             CaseForm  controller = new CaseForm(sc);
  			 System.assertNotEquals(null,controller.save());
            System.assertNotEquals(null,controller.cancel());
             test.stopTest();
             }catch(Exception exc){
        }

}
    
  @isTest
    static void TestCancelMethod() {
         try {
             test.startTest();
   			PageReference pageRef = Page.ChooseRecord;
            Case caseForm = new Case(Subject='Firas Subject2', Description='Firas Test2',Priority='Medium', Status='New');
            
            insert caseForm;
           
                
            
             pageRef.getParameters().put('id',caseForm.id);
   			 ApexPages.StandardController sc = new ApexPages.standardController(caseForm);
             CaseForm  controller = new CaseForm(sc);
  			 
            System.assertNotEquals(null,controller.cancel());
             test.stopTest();
             }catch(Exception exc){
        }
    }
}