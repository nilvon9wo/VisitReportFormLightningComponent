public class TriggerUtil_Quote {

    public static void deleteOpportunity(list<quote> oldQuotes){
        
        list<id> idsToDelete = new list<id>();
        
        For(quote q: oldQuotes){
            idsToDelete.add(q.opportunityid);
        }
        
        if(!idsToDelete.isEmpty())
        	DELETE [SELECT id FROM opportunity WHERE id IN: idsToDelete];
        
    }
    
     public static void setOpportunityStage(list<quote> oldQuotes, list<quote> newQuotes){
        
        system.debug('ENTERING SET OPP STAGE');
        List<id> idAccepted = new List<id>();
        List<id> idDenied = new List<id>();
        
        For(integer i=0; i < newQuotes.size();i++){
            if(oldQuotes[i].status != 'Accepted' && newQuotes[i].status == 'Accepted'){
                idAccepted.add(newQuotes[i].opportunityID);
            }else if(oldQuotes[i].status != 'Denied' && newQuotes[i].status == 'Denied'){
                idDenied.add(newQuotes[i].opportunityID);
            }
        }
        
        update TriggerUtil_Quote.quoteAccepted(idAccepted);
        update TriggerUtil_Quote.quoteDenied(idDenied);

    }
    
    public static List<opportunity> quoteAccepted(list<id> idAccepted){
        list<opportunity> acceptedOpps = [SELECT stageName FROM opportunity WHERE id IN: idAccepted];
        list<opportunity> oppsToUpdate = new List<opportunity>();
        For(opportunity o: acceptedOpps){
            o.stageName = 'Closed Won';
            oppsToupdate.add(o);
        }
        return oppsToupdate;
    }
    
    public static List<opportunity> quoteDenied(list<id> idDenied){
        list<opportunity> deniedOpps = [SELECT stageName FROM opportunity WHERE id IN: idDenied];
        list<opportunity> oppsToUpdate = new List<opportunity>();
        For(opportunity o: deniedOpps){
            o.stageName = 'Closed Lost';
            oppsToupdate.add(o);
        }
        return oppsToupdate;
    }

}