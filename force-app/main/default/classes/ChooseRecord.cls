public with sharing  class ChooseRecord {
    
    private ApexPages.StandardSetController ssc;
    private ApexPages.StandardController controller;

    
    public ChooseRecord(ApexPages.StandardSetController controller) {
        this.ssc = controller;
    }

    public ChooseRecord(ApexPages.StandardController controller)
    {
        this.controller = controller;
    }

    public PageReference save()
    {
        PageReference pr = new PageReference('/apex/ChooseRecord' );
        
         this.controller.save();
        
        pr.setRedirect(true);
       
        return pr;
        
    }
    public PageReference cancel()
    {
		 PageReference pr = new PageReference('/apex/ChooseRecord' );
         pr.setRedirect(true);
       
        return pr;
    }
    
    }