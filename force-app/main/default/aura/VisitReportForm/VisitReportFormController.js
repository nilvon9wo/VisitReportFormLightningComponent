({
    save: function (component) {
        const newRecord = component.get('v.newRecord');
        const saveDetails = component.get('c.saveDetails');
        saveDetails.setParams({
            'acc': newRecord
        });
        saveDetails.setCallback(this, function (response) {
            const state = response.getState();
            if (state === 'SUCCESS') {
                const firas = component.set('v.recordId', response.getReturnValue());
                alert('Record is Created Successfully');
            } else {
                console.error('Failed with state: ' + state);
            }
        });
        $A.enqueueAction(saveDetails);
    },

    doInit: function (component) {
        const getId = component.get('v.recordId');
    },

    handleSubmit: function (component, event) {
        event.preventDefault();

        // const fields = event.getParam('fields');
        // fields.Contact__c = component.get('v.selectedContacts')[0].Id;
        // fields.User__c = component.get('v.selectedUsers')[0].Id;

        component.find('visitReportForm').submit(fields);
    }

})