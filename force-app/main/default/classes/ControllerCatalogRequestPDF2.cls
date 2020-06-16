public class ControllerCatalogRequestPDF2 {
    
    @testvisible
    private Catalog_Request__c catreq;
    public Catalog_Request__c catrequest;
    public List<Sample_Line_Item__c> lineItems {get; set;}
    public string status {get;set;}
    
    public ControllerCatalogRequestPDF2(ApexPages.StandardController stdController) {
        this.catreq = (Catalog_Request__c)stdController.getRecord();     
      //  status = 'Email Sent with attached PDF and all existing files that were previously attached to the catalog request.';
        this.catrequest = [SELECT Name, Account__r.Name,Account__r.BillingCountry, Request_Date__c, Internal_Email_Sent_To_s__c, Request_Last_Sent__c , Requested_By_Internal__r.FirstName , Requested_By_Internal__r.LastName FROM Catalog_Request__c WHERE Id =:this.catreq.Id];
        this.lineItems = [SELECT Product__r.Name, Product__r.ProductCode, Quantity__c, Product_Description__c FROM Sample_Line_Item__c WHERE Catalog_Request__c = :this.catreq.Id];
    }
    
    public void sendPDF() {
        PageReference pdf = Page.CRequest2;
    
        Attachment attach = new Attachment();
    
        Blob body;
    
        try{
    
            if(!test.isRunningTest()) body = pdf.getContentAsPDF();
            if(test.isRunningTest()) body = Blob.valueof('Some random String');
            system.debug('got the body');
    
            ContentVersion contVer = new ContentVersion(Title='Goldstar Request  '+this.catrequest.Account__r.Name + ' ' + this.catreq.Name , VersionData = body, PathOnClient ='/Catalog.pdf');
            List<ContentDocumentLink> docLinks = [
                    SELECT Id, ContentDocumentId 
                    FROM ContentDocumentLink 
                    WHERE LinkedEntityId = :this.catrequest.id AND  ContentDocument.Title = 'Goldstar%'
                ];
            // check if file already exists, 
            // if yes, insert a newer ContentVersion by specifying the ContentDocumentId
            if (!docLinks.isEmpty()) {
                contVer.ContentDocumentId = docLinks[0].ContentDocumentId;
            }
            insert(contVer);
            
            // if file didn't exists before
            // insert a new ContentDocumentLink
            if (docLinks.isEmpty()) {
                ContentDocumentLink contentlink = new ContentDocumentLink();
                contentlink.LinkedEntityId = this.catrequest.Id;
                contentlink.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:contVer.Id].ContentDocumentId;
                contentlink.ShareType = 'V';
                insert contentlink;
				}
            
            
             //Now email the catalog Request
            String currentUserEmail = UserInfo.getUserEmail();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[]{currentUserEmail,'SamplesGS@goldstar-europe.com'};
                
                
                

            mail.setToAddresses(toAddresses);
            
          // String plainBody = 'https://goldstar1.lightning.force.com/'+this.catrequest.id;
 			 mail.setPlainTextBody('');
            // string formattedDate = this.catrequest.Request_Date__c.day() +'/'+this.catrequest.Request_Date__c.month() +'/'+this.catrequest.Request_Date__c.year();
           String subject = 'Goldstar Request : ' +this.catrequest.account__r.BillingCountry  +', ' + this.catrequest.Requested_By_Internal__r.FirstName  +' '+ this.catrequest.Requested_By_Internal__r.LastName +', Distributor : '+ this.catrequest.account__r.name+' '+this.catrequest.Name ;
            mail.setSubject(subject);
            
          List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
            
            if(contVer != null){
                Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
                attachment.setBody(contVer.VersionData);
                attachment.setContentType('application/pdf');
                attachment.setFileName(contVer.Title+'.pdf');
                
            }
            
            //query for any files attached to the catalog request and include them in the email
        set<id> docIds = new set<id>();
            
            list<contentdocumentlink> links = [Select Id,contentdocument.id from ContentDocumentLink where LinkedEntityId = :this.catrequest.id];
            For(contentdocumentlink l: links){
                docIds.add(l.contentdocument.id);
            }
            list<contentversion> versions = [SELECT ContentDocumentId,VersionData,FileExtension,FileType,Id,Title FROM ContentVersion where ContentDocumentId IN: docids and IsLatest = true];
            
            for(contentversion a: versions){
                Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                efa.setFileName(a.Title+'.'+a.FileExtension); 
                efa.setBody(a.VersionData);
                attachments.add(efa);
            }
            if(!attachments.isEmpty()) mail.setFileAttachments(attachments);
            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
          
            this.catrequest.Request_Last_Sent__c = system.now();
            update this.catrequest;
        } catch (Exception e) {
            status = e.getMessage();
            system.debug('error ' + e.getMessage());
        }
		             
            
           
    }

  
}