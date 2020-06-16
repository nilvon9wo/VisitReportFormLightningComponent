public class FindDuplicates {
    

    
	public static List<Contact> findContacts(List<Contact> cons) {
	List<Contact> foundContacts = new List<Contact>();
	List<Datacloud.FindDuplicatesResult> results;
	try {
		results = Datacloud.FindDuplicates.findDuplicates(cons);
	} catch (Exception ex) {
		// FYI if there are no active rules for an object, then the exception is
		// System.HandledException: No active duplicate rules are defined for the [objname] object type
		return null;
	}

	// Loop the original contacts
	for (Integer i = 0; i < cons.size(); i++) {
		Contact foundCon = null;
		// Find the first duplicate result with a match result, then use the first match record.
		for (Datacloud.DuplicateResult dr : results[i].getDuplicateResults()) {
			if (dr.matchResults.size() > 0 && dr.getMatchResults()[0].matchRecords.size() > 0) {
				foundCon = (Contact) dr.getMatchResults()[0].getMatchRecords()[0].getRecord();
				break;
			}
		}
		foundContacts.add(foundCon);
	}

	return foundContacts;
}
}