trigger ContactViews on Task (before insert) {
    List<Task> tList = trigger.new;
    List<Id> idList = new List<Id>();
    for(Task t : tList) {
        if(t.whoId != null) idList.add(t.whoId);
    }
    Map<Id, Contact> cMap = new Map<Id, Contact>([select id, accountId from contact where Id in: idList]);

    List<Task> tList_failed = new List<Task>();
    for(Task t : tList) {
        if(t.whoId != null && t.whatId != null && t.whatId != cMap.get(t.whoId).accountId) tList_failed.add(t);
    }

    if(tList_failed.size() > 0) tList[0].addError('Please refer only contact related to its account');
}