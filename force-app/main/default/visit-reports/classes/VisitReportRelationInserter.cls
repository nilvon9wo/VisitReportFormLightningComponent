public with sharing class VisitReportRelationInserter implements XAP_DAO_TRANS_DmlOperationIntf {
    private List<SObject> relationList = new List<SObject>();
    private XAP_DAO_DML_InheritedSharingDml genericDml;
    private XAP_DAO_TRANS_DmlResultFactory dmlResultFactory;

    public VisitReportRelationInserter(
            List<Contact> contactList,
            List<User> userList,
            XAP_DAO_DML_InheritedSharingDml genericDml,
            XAP_DAO_TRANS_DmlResultFactory dmlResultFactory
    ) {
        this.relationList.addAll(contactList);
        this.relationList.addAll(userList);
        this.genericDml = genericDml;
        this.dmlResultFactory = dmlResultFactory;

    }

    public VisitReportRelationInserter(List<Contact> contactList, List<User> userList) {
        this(
                contactList,
                userList,
                XAP_DAO_DML_InheritedSharingDml.getInstance(),
                XAP_DAO_TRANS_DmlResultFactory.getInstance()
        );
    }

    private static final Map<SObjectType, SObjectType> JUNCTION_SOBJECT_TYPE_BY_RELATED_SOBJECT_TYPE_MAP
            = new Map<SObjectType, SObjectType>{
                    Contact.SObjectType => Visit_Report_Contact__c.SObjectType,
                    User.SObjectType => Visit_Report_Assignee__c.SObjectType
            };

    private static final Map<SObjectType, SObjectField> RELATION_FIELD_BY_SOBJECT_TYPE_MAP = new Map<SObjectType, SObjectField>{
            Contact.SObjectType => Visit_Report_Contact__c.Contact__c,
            User.SObjectType => Visit_Report_Assignee__c.User__c
    };

    public XAP_DAO_TRANS_DmlResultIntf doDml(Map<XAP_DAO_TRANS_SObjectListKeyEnum, List<SObject>> prerequisitSObjectsByKeyMap) {
        // The current use case only expects a single value ever to be in this list.
        Visit_Report__c visitReport
                = (Visit_Report__c) prerequisitSObjectsByKeyMap.get(XAP_DAO_TRANS_SObjectListKeyEnum.VISIT_REPORT_LIST)[0];

        List<SObject> visitReportRelationList = this.createVisitorReportRelations(visitReport);
        return this.dmlResultFactory.createFor(
                new Map<XAP_DAO_TRANS_SObjectListKeyEnum, List<SObject>>{
                        XAP_DAO_TRANS_SObjectListKeyEnum.NO_CALLBACK_REQUIRED => visitReportRelationList
                },
                this.genericDml.doInsert(visitReportRelationList, XAP_DAO_DML_OperationModeEnum.ALL_OR_NONE)
        );
    }

    private List<SObject> createVisitorReportRelations(Visit_Report__c visitReport) {
        List<SObject> visitReportJunctionList = new List<SObject>();
        for (SObject relatedSObject : this.relationList) {
            SObject junctionSObject = this.createVisitorReportRelation(visitReport, relatedSObject);
            visitReportJunctionList.add(junctionSObject);
        }
        return visitReportJunctionList;
    }

    private SObject createVisitorReportRelation(Visit_Report__c visitReport, SObject relatedSObject) {
        SObjectType junctionType = JUNCTION_SOBJECT_TYPE_BY_RELATED_SOBJECT_TYPE_MAP.get(relatedSObject.getSObjectType());
        SObjectField relationField = RELATION_FIELD_BY_SOBJECT_TYPE_MAP.get(relatedSObject.getSObjectType());

        SObject junctionSObject = junctionType.newSObject();
        junctionSObject.put('Visit_Report__c', visitReport.Id);
        junctionSObject.put(relationField, relatedSObject.Id);
        return junctionSObject;
    }
}