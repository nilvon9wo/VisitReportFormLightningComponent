public inherited sharing class VisitReportInserter implements XAP_DAO_TRANS_DmlOperationIntf {
    private List<Visit_Report__c> visitReportList;
    private XAP_DAO_DML_InheritedSharingDml genericDml;
    private XAP_DAO_TRANS_DmlResultFactory dmlResultFactory;

    public VisitReportInserter(
            Visit_Report__c visitReport,
            XAP_DAO_DML_InheritedSharingDml genericDml,
            XAP_DAO_TRANS_DmlResultFactory dmlResultFactory
    ) {
        this.visitReportList = new List<Visit_Report__c>{visitReport};
        this.genericDml = genericDml;
        this.dmlResultFactory = dmlResultFactory;

    }

    public VisitReportInserter(Visit_Report__c visitReport) {
        this(
                visitReport,
                XAP_DAO_DML_InheritedSharingDml.getInstance(),
                XAP_DAO_TRANS_DmlResultFactory.getInstance()
        );
    }

    public XAP_DAO_TRANS_DmlResultIntf doDml(
            Map<XAP_DAO_TRANS_SObjectListKeyEnum, List<SObject>> prerequisitSObjectsByKeyMap
    ) {
        return this.dmlResultFactory.createFor(
                new Map<XAP_DAO_TRANS_SObjectListKeyEnum, List<SObject>>{
                        XAP_DAO_TRANS_SObjectListKeyEnum.VISIT_REPORT_LIST => this.visitReportList
                },
                this.genericDml.doInsert(this.visitReportList, XAP_DAO_DML_OperationModeEnum.ALL_OR_NONE)
        );
    }
}