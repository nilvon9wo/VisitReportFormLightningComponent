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
            let title = '';
            let type = '';
            let message = '';
            if ('SUCCESS' === response.getState()) {
                const value = response.getReturnValue();
                title = 'Success';
                type = 'success';
                message = `'${value.Subject__c}' is Created Successfully as record ${value.Id}`;
            } else {
                title = 'Error';
                type = 'error';

                const errors = response.getError();
                const error = errors[0];
                message = (error && error.message)
                    ? `Error message: ${error}`
                    : 'Unknown error';
            }

            const toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": title,
                "type": type,
                "message": message
            });
            toastEvent.fire();
        });

        $A.enqueueAction(action);
    }
})