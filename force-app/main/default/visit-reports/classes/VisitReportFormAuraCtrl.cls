public inherited sharing class VisitReportFormAuraCtrl {
    private VisitReportFormAuraCtrl(){
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
        return null;
    }
}