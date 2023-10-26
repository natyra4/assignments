trigger AccountActivationTrigger on Account (after update) {
    List<Contact> contactsToUpdate = new List<Contact>();
   
    for (Account updatedAccount : Trigger.new) {
        Account oldAccount = Trigger.oldMap.get(updatedAccount.Id);

        if (updatedAccount.Activated__c != oldAccount.Activated__c) {
            List<Contact> childContacts = [SELECT Id FROM Contact WHERE AccountId = :updatedAccount.Id];
            for (Contact childContact : childContacts) {
                childContact.Activated__c = updatedAccount.Activated__c;
                contactsToUpdate.add(childContact);
            }
        }
    }

    update contactsToUpdate;
    
}