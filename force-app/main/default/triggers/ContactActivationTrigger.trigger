trigger ContactActivationTrigger on Contact (after update) {
    if(trigger.isAfter && trigger.isUpdate){
        //create a map to store the Account ids of the contact as key and contact as value
      Map<Id, Contact> consMapToBeUpdated = new Map<Id,Contact>();
        //find the contacts that deactivate field has changed 
        //and put them to the map that we have created for 
      for (Contact con : trigger.new) { 
     Contact oldCon=trigger.oldMap.get(con.id); 
      if(con.Activated__c!=oldCon.Activated__c){
          consMapToBeUpdated.put(con.AccountId, con); 
      }
      }
         //retrieve the contacts to be updated 
 List <Contact> consToBeUpdated = [Select id, AccountId, Activated__c from Contact where Accountid in : consMapToBeUpdated.keySet() ];
        for (Contact con : consToBeUpdated){
               Contact orgCon = consMapToBeUpdated.get(con.AccountId); 
            con.Activated__c=orgCon.Activated__c; 
             update consToBeUpdated;
            List<Account> accsToBeUpdated = [Select id, Activated__c, (Select id, Activated__c from Contacts) from Account where id in : consMapToBeUpdated.keySet() ];
            for (Account acc : accsToBeUpdated) {
                acc.Activated__c=consMapToBeUpdated.get(acc.id).Activated__c; 
            }
            update accsToBeUpdated; 
            } 
    }
}