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
                component.set('v.recordId', response.getReturnValue());
                alert('Record is Created Successfully');
            } else {
                console.error('Failed with state: ' + state);
            }
        });
        $A.enqueueAction(saveDetails);
    },

    handleSubmit: function (component, event) {
        event.preventDefault();

        const action = component.get('c.saveVisitReport');
        action.setParams({
            visitReport: event.getParam('fields'),
            contactList: component.get('v.selectedContacts'),
            userList: component.get('v.selectedUsers')
        });
        action.setCallback(this, function (response) {
            if ('SUCCESS' === response.getState()) {
                alert('From server: ' + response.getReturnValue());
            } else {
                const errors = response.getError();
                const error = errors[0];
                console.error((error && error.message)
                    ? `Error message: ${error}`
                    : 'Unknown error'
                );
            }
        });

        $A.enqueueAction(action);
    }
})