public inherited sharing class VisitReportFormAuraCtrl {
    private XAP_DAO_TRANS_MultiDmlOperationProcessor multiDmlOperationProcessor;

    private VisitReportFormAuraCtrl(XAP_DAO_TRANS_MultiDmlOperationProcessor multiDmlOperationProcessor) {
        this.multiDmlOperationProcessor = multiDmlOperationProcessor;
    }

    private VisitReportFormAuraCtrl() {
        this(XAP_DAO_TRANS_MultiDmlOperationProcessor.getInstance());
    }

    private static VisitReportFormAuraCtrl instance;
    public static VisitReportFormAuraCtrl getInstance() {
        if (instance == null) {
            instance = new VisitReportFormAuraCtrl();
        }
        return instance;
    }

    @AuraEnabled
    public static Visit_Report__c saveVisitReport(
            Visit_Report__c visitReport,
            List<Contact> contactList,
            List<User> userList
    ) {
        return VisitReportFormAuraCtrl.getInstance()
                .save(visitReport, contactList, userList);
    }

    private Visit_Report__c save(Visit_Report__c visitReport, List<Contact> contactList, List<User> userList) {
        this.multiDmlOperationProcessor.process(new List<XAP_DAO_TRANS_DmlOperationIntf>{
                new VisitReportInserter(visitReport),
                new VisitReportRelationInserter(contactList, userList)
        });
        return visitReport;
    }
}