public with sharing  class CaseForm {
    
    public ApexPages.StandardSetController ssc;
    public ApexPages.StandardController controller;
    Public Case caso {get; set;}
    public Database.DmlOptions.EmailHeader emailHeader {get; set;}

    
   

    public CaseForm(ApexPages.StandardController controller)
    {
        caso = (Case)Controller.getRecord(); 
        this.controller=Controller;
    }
   

    public PageReference save()
    {
        AssignmentRule AR = new AssignmentRule();
AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
           PageReference pr = new PageReference('/apex/ChooseRecord' );
        
        Database.DMLOptions dmlOpts = new Database.DMLOptions();
dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
        dmlOpts.EmailHeader.TriggerUserEmail = true;


       caso.setOptions(dmlOpts);

        	insert caso; 
        pr.setredirect(true);
      return pr;   
    }
    public PageReference cancel()
    {
		 PageReference pr = new PageReference('/apex/ChooseRecord' );
         pr.setRedirect(true);
       
        return pr;
    }
    
    }