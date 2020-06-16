@isTest
public class Lightning_PicklistLookupTest {

    static {
        Account acc = new Account(Name = 'Test');
        insert acc;
    }

    static testmethod void testGetPicklist(){ 
        Lightning_PicklistLookup.getPicklistOptionValues('Opportunity','Type');
    }
    
    static testMethod void testGetOptionsByQuery(){
        Lightning_PicklistLookup.getOptionValuePairsByQuery('Id','Name', 'Account', '', '');
    }

}