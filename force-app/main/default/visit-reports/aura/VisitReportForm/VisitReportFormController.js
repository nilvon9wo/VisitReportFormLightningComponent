({
    handleSubmit: function (component, event) {
        event.preventDefault();

        const fields = event.getParam('fields');
        fields.Account__c = component.get('v.recordId');

        const action = component.get('c.saveVisitReport');
        action.setParams({
            visitReport: fields,
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